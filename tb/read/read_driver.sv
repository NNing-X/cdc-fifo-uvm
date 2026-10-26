class read_driver extends uvm_driver #(read_transaction);

    `uvm_component_utils(read_driver)

    virtual cdc_fifo_if vif;

    function new(string name = "read_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual cdc_fifo_if)::get(
            this, "", "vif", vif
        )) begin
            `uvm_fatal("NO_VIF",
                       "read_driver could not get virtual interface")
        end
    endfunction


    task run_phase(uvm_phase phase);

        read_transaction req;

        vif.read_drv_cb.rinc <= 1'b0;

        forever begin

            seq_item_port.get_next_item(req);

            // Wait until FIFO is not empty
            while (vif.read_drv_cb.rempty)
                @(vif.read_drv_cb);

            // Request one read
            vif.read_drv_cb.rinc <= 1'b1;

            @(vif.read_drv_cb);

            // End read request
            vif.read_drv_cb.rinc <= 1'b0;

            seq_item_port.item_done();

        end

    endtask

endclass