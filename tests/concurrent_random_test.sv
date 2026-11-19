
class concurrent_random_test extends base_test;

    `uvm_component_utils(concurrent_random_test)

    function new(string name = "concurrent_random_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);

        fifo_random_vseq vseq;

        phase.raise_objection(this);

        reset_dut();

        vseq = fifo_random_vseq::type_id::create("vseq");

        vseq.w_sequencer = env.w_agent.sequencer;
        vseq.r_sequencer = env.r_agent.sequencer;

        vseq.num_iterations = 10;

        vseq.start(null);

        repeat (6) @(negedge vif.rclk);

        if (env.scoreboard.write_count != vseq.total_writes)
            `uvm_error(
                "CONCURRENT_RANDOM",
                $sformatf(
                    "Write count mismatch: expected=%0d actual=%0d",
                    vseq.total_writes,
                    env.scoreboard.write_count
                )
            )

        if (env.scoreboard.read_count != vseq.total_reads)
            `uvm_error(
                "CONCURRENT_RANDOM",
                $sformatf(
                    "Read count mismatch: expected=%0d actual=%0d",
                    vseq.total_reads,
                    env.scoreboard.read_count
                )
            )

        if (env.scoreboard.expected_queue.size() != 0)
            `uvm_error("CONCURRENT_RANDOM", "Scoreboard queue is not empty")

        if (vif.rempty !== 1'b1)
            `uvm_error("CONCURRENT_RANDOM", "FIFO should be empty")

        `uvm_info(
            "CONCURRENT_RANDOM",
            $sformatf(
                "Concurrent random test completed: writes=%0d reads=%0d",
                vseq.total_writes,
                vseq.total_reads
            ),
            UVM_LOW
        )

        phase.drop_objection(this);

    endtask

endclass
