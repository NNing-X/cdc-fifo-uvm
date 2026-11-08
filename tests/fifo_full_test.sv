
class fifo_full_test extends base_test;

    `uvm_component_utils(fifo_full_test)

    function new(string name = "fifo_full_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);

        write_sequence wseq;

        phase.raise_objection(this);

        reset_dut();

        if (vif.wfull !== 1'b0)
            `uvm_error("FIFO_FULL", "FIFO should not be full after reset")

        wseq = write_sequence::type_id::create("wseq");
        wseq.num_writes = FIFO_DEPTH;

        `uvm_info("FIFO_FULL", "Filling FIFO", UVM_LOW)

        wseq.start(env.w_agent.sequencer);

        repeat (2) @(negedge vif.wclk);

        if (vif.wfull !== 1'b1)
            `uvm_error("FIFO_FULL", "wfull should be asserted after FIFO_DEPTH writes")

        if (env.scoreboard.write_count != FIFO_DEPTH)
            `uvm_error(
                "FIFO_FULL",
                $sformatf(
                    "Expected %0d accepted writes, got %0d",
                    FIFO_DEPTH,
                    env.scoreboard.write_count
                )
            )

        if (env.scoreboard.expected_queue.size() != FIFO_DEPTH)
            `uvm_error("FIFO_FULL", "Scoreboard queue size is incorrect")

        `uvm_info("FIFO_FULL", "FIFO full test completed", UVM_LOW)

        phase.drop_objection(this);

    endtask

endclass
