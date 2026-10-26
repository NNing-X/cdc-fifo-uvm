class read_monitor extends uvm_monitor;

    `uvm_component_utils(read_monitor)

    virtual cdc_fifo_if vif;

    uvm_analysis_port #(read_transaction) ap;

    function new(string name = "read_monitor",
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
                       "read_monitor could not get virtual interface")
        end
    endfunction


    task run_phase(uvm_phase phase);

        read_transaction tx;

        forever begin

            @(vif.read_mon_cb);

            if (vif.read_mon_cb.rinc &&
                !vif.read_mon_cb.rempty) begin

                tx = read_transaction::type_id::create("tx");

                tx.data = vif.read_mon_cb.rdata;

                ap.write(tx);

            end

        end

    endtask

endclass