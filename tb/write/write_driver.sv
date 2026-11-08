
class write_driver extends uvm_driver #(write_transaction);

    `uvm_component_utils(write_driver)

    virtual cdc_fifo_if vif;

    function new(string name = "write_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //driver: get interface from config_db;
        //later in tb_top: physical interface set config_db
        if (!uvm_config_db#(virtual cdc_fifo_if)::get(
            this,
            "",
            "vif",
            vif
        )) begin
            `uvm_fatal("NO_VIF",
                    "write_driver could not get virtual interface")
        end
    endfunction

    task run_phase(uvm_phase phase);
        write_transaction req;

        vif.write_drv_cb.winc <= 0;
        vif.write_drv_cb.wdata <= '0;

        forever begin
            seq_item_port.get_next_item(req);//driver wait transaction

            @(vif.write_drv_cb);

            while (vif.write_drv_cb.wfull)
                @(vif.write_drv_cb); //if wfull -> wait

            vif.write_drv_cb.wdata <= req.data;
            vif.write_drv_cb.winc  <= 1'b1;

            @(vif.write_drv_cb);//@write clock (write-sider driver clocking block in cdc_fifo_if)

            vif.write_drv_cb.winc <= 1'b0;

            @(vif.write_drv_cb);

            seq_item_port.item_done();
        end
    endtask
endclass
