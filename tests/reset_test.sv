class reset_test extends base_test;

    `uvm_component_utils(reset_test)

    virtual cdc_fifo_if vif;

    function new(string name = "reset_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual cdc_fifo_if)::get(
            this, "", "vif", vif
        )) begin
            `uvm_fatal("NO_VIF", "reset_test could not get virtual interface")
        end
    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        vif.wnrst = 1'b0;
        vif.rnrst = 1'b0;

        repeat (3) @(negedge vif.wclk);
        repeat (3) @(negedge vif.rclk);

        if (vif.wfull !== 1'b0)
            `uvm_error("RESET_TEST", "wfull should be 0 during reset")

        if (vif.rempty !== 1'b1)
            `uvm_error("RESET_TEST", "rempty should be 1 during reset")

        vif.wnrst = 1'b1;
        vif.rnrst = 1'b1;

        repeat (3) @(negedge vif.wclk);
        repeat (3) @(negedge vif.rclk);

        if (vif.wfull !== 1'b0)
            `uvm_error("RESET_TEST", "wfull should remain 0 after reset")

        if (vif.rempty !== 1'b1)
            `uvm_error("RESET_TEST", "rempty should remain 1 after reset")

        `uvm_info("RESET_TEST", "Reset verification completed", UVM_LOW)

        phase.drop_objection(this);

    endtask

endclass