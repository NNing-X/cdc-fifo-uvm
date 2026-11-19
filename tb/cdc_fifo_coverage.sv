
class cdc_fifo_coverage extends uvm_component;

    `uvm_component_utils(cdc_fifo_coverage)

    virtual cdc_fifo_if vif;

    int unsigned write_samples = 0;
    int unsigned read_samples = 0;

    covergroup write_cg with function sample(
        bit write_en,
        bit full_flag
    );

        option.per_instance = 1;

        write_cp: coverpoint write_en {
            bins idle = {0};
            bins active = {1};
        }

        full_cp: coverpoint full_flag {
            bins not_full = {0};
            bins full = {1};
        }

        write_full_cross: cross write_cp, full_cp;

    endgroup

    covergroup read_cg with function sample(
        bit read_en,
        bit empty_flag
    );

        option.per_instance = 1;

        read_cp: coverpoint read_en {
            bins idle = {0};
            bins active = {1};
        }

        empty_cp: coverpoint empty_flag {
            bins not_empty = {0};
            bins empty = {1};
        }

        read_empty_cross: cross read_cp, empty_cp;

    endgroup

    function new(string name = "cdc_fifo_coverage",
                 uvm_component parent = null);
        super.new(name, parent);

        write_cg = new();
        read_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual cdc_fifo_if)::get(
            this, "", "vif", vif
        )) begin
            `uvm_fatal("NO_VIF", "Coverage could not get virtual interface")
        end
    endfunction

    task run_phase(uvm_phase phase);

        fork

            forever begin
                @(vif.write_mon_cb);

                if (vif.wnrst) begin
                    write_cg.sample(
                        vif.write_mon_cb.winc,
                        vif.write_mon_cb.wfull
                    );

                    if (vif.write_mon_cb.winc &&
                        !vif.write_mon_cb.wfull)
                        write_samples++;
                end
            end

            forever begin
                @(vif.read_mon_cb);

                if (vif.rnrst) begin
                    read_cg.sample(
                        vif.read_mon_cb.rinc,
                        vif.read_mon_cb.rempty
                    );

                    if (vif.read_mon_cb.rinc &&
                        !vif.read_mon_cb.rempty)
                        read_samples++;
                end
            end

        join

    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "COVERAGE",
            $sformatf(
                "Write coverage=%0.2f%% Read coverage=%0.2f%% Accepted writes=%0d reads=%0d",
                write_cg.get_inst_coverage(),
                read_cg.get_inst_coverage(),
                write_samples,
                read_samples
            ),
            UVM_LOW
        )
    endfunction

endclass
