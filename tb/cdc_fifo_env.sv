class cdc_fifo_env extends uvm_env;

    `uvm_component_utils(cdc_fifo_env)

    write_agent         w_agent;
    read_agent          r_agent;
    cdc_fifo_scoreboard scoreboard;


    function new(string name = "cdc_fifo_env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        w_agent = write_agent::type_id::create(
            "w_agent", this
        );

        r_agent = read_agent::type_id::create(
            "r_agent", this
        );

        scoreboard = cdc_fifo_scoreboard::type_id::create(
            "scoreboard", this
        );

    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        w_agent.monitor.ap.connect(
            scoreboard.write_imp
        );

        r_agent.monitor.ap.connect(
            scoreboard.read_imp
        );

    endfunction

endclass