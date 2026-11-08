
class multiple_write_read_test extends base_test;

    `uvm_component_utils(multiple_write_read_test)

    function new(string name = "multiple_write_read_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);

        write_sequence wseq;
        read_sequence rseq;

        phase.raise_objection(this);

        reset_dut();

        wseq = write_sequence::type_id::create("wseq");
        rseq = read_sequence::type_id::create("rseq");

        wseq.num_writes = 8;
        rseq.num_reads = 8;

        `uvm_info("MULTI_RW", "Starting 8 writes", UVM_LOW)

        wseq.start(env.w_agent.sequencer);

        `uvm_info("MULTI_RW", "Writes completed", UVM_LOW)

        repeat (4) @(negedge vif.rclk);

        `uvm_info("MULTI_RW", "Starting 8 reads", UVM_LOW)

        rseq.start(env.r_agent.sequencer);

        repeat (4) @(negedge vif.rclk);

        if (env.scoreboard.write_count != 8)
            `uvm_error("MULTI_RW", "Expected 8 accepted writes")

        if (env.scoreboard.read_count != 8)
            `uvm_error("MULTI_RW", "Expected 8 accepted reads")

        if (env.scoreboard.expected_queue.size() != 0)
            `uvm_error("MULTI_RW", "Expected queue is not empty")

        if (vif.rempty !== 1'b1)
            `uvm_error("MULTI_RW", "FIFO should be empty after all reads")

        `uvm_info("MULTI_RW", "Multiple write/read test completed", UVM_LOW)

        phase.drop_objection(this);

    endtask

endclass
