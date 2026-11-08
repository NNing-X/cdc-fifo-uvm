class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    cdc_fifo_env env;
    virtual cdc_fifo_if vif;

    function new(string name = "base_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = cdc_fifo_env::type_id::create("env", this);

        if (!uvm_config_db#(virtual cdc_fifo_if)::get(
            this, "", "vif", vif
        )) begin
            `uvm_fatal("NO_VIF", "base_test could not get virtual interface")
        end
    endfunction

    task reset_dut();

        vif.wnrst = 1'b0;
        vif.rnrst = 1'b0;

        repeat (3) @(negedge vif.wclk);
        repeat (3) @(negedge vif.rclk);

        vif.wnrst = 1'b1;
        vif.rnrst = 1'b1;

        repeat (3) @(negedge vif.wclk);
        repeat (3) @(negedge vif.rclk);

    endtask

endclass