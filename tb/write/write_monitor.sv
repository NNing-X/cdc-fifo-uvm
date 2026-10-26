class write_monitor extends uvm_monitor;

    `uvm_component_utils(write_monitor)

    virtual cdc_fifo_if vif;

    uvm_analysis_port #(write_transaction) ap;

    function new(string name = "write_monitor",
                 uvm_component parent = null);
        super.new(name, parent);

        ap = new("ap", this);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual cdc_fifo_if)::get(
            this, "", "vif", vif
        )) begin
            `uvm_fatal("NO_VIF",
                       "write_monitor could not get virtual interface")
        end
    endfunction


    task run_phase(uvm_phase phase);

        write_transaction tx;

        forever begin

            @(vif.write_mon_cb);

            if (vif.write_mon_cb.winc &&
                !vif.write_mon_cb.wfull) begin

                tx = write_transaction::type_id::create("tx");

                tx.data = vif.write_mon_cb.wdata;

                ap.write(tx);

            end

        end

    endtask

endclass