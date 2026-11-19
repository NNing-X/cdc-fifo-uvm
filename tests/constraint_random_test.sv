class constrained_random_test extends base_test;

    `uvm_component_utils(constrained_random_test)

    int num_iterations = 30;

    function new(string name = "constrained_random_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);

        fifo_random_cfg cfg;
        write_sequence wseq;
        read_sequence rseq;

        int unsigned occupancy;
        int unsigned expected_writes;
        int unsigned expected_reads;

        phase.raise_objection(this);

        reset_dut();

        cfg = fifo_random_cfg::type_id::create("cfg");

        occupancy = 0;
        expected_writes = 0;
        expected_reads = 0;

        for (int i = 0; i < num_iterations; i++) begin

            cfg.occupancy = occupancy;

            if (!cfg.randomize())
                `uvm_fatal("RAND_FAIL", "Failed to randomize FIFO configuration")

                `uvm_info(
                "CRV",
                $sformatf(
                    "Iteration=%0d operation=%0d writes=%0d reads=%0d idle=%0d occupancy=%0d",
                    i, cfg.operation, cfg.write_burst,
                    cfg.read_burst, cfg.idle_cycles, occupancy
                ),
                UVM_LOW
            )

            repeat (cfg.idle_cycles) @(negedge vif.wclk);

            if (cfg.write_burst > 0) begin

                wseq = write_sequence::type_id::create("wseq");
                wseq.num_writes = cfg.write_burst;

                wseq.start(env.w_agent.sequencer);

                occupancy += cfg.write_burst;
                expected_writes += cfg.write_burst;

            end

            if (cfg.read_burst > 0) begin

                rseq = read_sequence::type_id::create("rseq");
                rseq.num_reads = cfg.read_burst;

                rseq.start(env.r_agent.sequencer);

                occupancy -= cfg.read_burst;
                expected_reads += cfg.read_burst;

            end

            repeat (4) @(negedge vif.rclk);

            if (env.scoreboard.write_count != expected_writes)
                `uvm_error("CRV", "Write count mismatch")

            if (env.scoreboard.read_count != expected_reads)
                `uvm_error("CRV", "Read count mismatch")

            if (env.scoreboard.expected_queue.size() != occupancy)
                `uvm_error("CRV", "Scoreboard occupancy mismatch")

        end

        if (occupancy > 0) begin

            rseq = read_sequence::type_id::create("drain_seq");
            rseq.num_reads = occupancy;

            rseq.start(env.r_agent.sequencer);

            expected_reads += occupancy;
            occupancy = 0;

        end

        repeat (6) @(negedge vif.rclk);

        if (env.scoreboard.write_count != expected_writes)
            `uvm_error("CRV", "Final write count mismatch")

        if (env.scoreboard.read_count != expected_reads)
            `uvm_error("CRV", "Final read count mismatch")

        if (env.scoreboard.expected_queue.size() != 0)
            `uvm_error("CRV", "Expected queue is not empty")

        if (vif.rempty !== 1'b1)
            `uvm_error("CRV", "FIFO should be empty")

        `uvm_info(
            "CRV",
            $sformatf(
                "Constrained-random test completed: writes=%0d reads=%0d",
                expected_writes, expected_reads
            ),
            UVM_LOW
        )

        phase.drop_objection(this);

    endtask

endclass