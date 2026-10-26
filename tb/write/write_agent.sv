class write_agent extends uvm_agent;

    `uvm_component_utils(write_agent)

    write_sequencer sequencer;
    write_driver    driver;
    write_monitor   monitor;

    function new(string name = "write_agent",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sequencer = write_sequencer::type_id::create(
            "sequencer", this
        );

        driver = write_driver::type_id::create(
            "driver", this
        );

        monitor = write_monitor::type_id::create(
            "monitor", this
        );

    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        driver.seq_item_port.connect(
            sequencer.seq_item_export
        );

    endfunction

endclass