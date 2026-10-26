class read_agent extends uvm_agent;

    `uvm_component_utils(read_agent)

    read_sequencer sequencer;
    read_driver    driver;
    read_monitor   monitor;

    function new(string name = "read_agent",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sequencer = read_sequencer::type_id::create(
            "sequencer", this
        );

        driver = read_driver::type_id::create(
            "driver", this
        );

        monitor = read_monitor::type_id::create(
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