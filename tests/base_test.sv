class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    cdc_fifo_env env;


    function new(string name = "base_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = cdc_fifo_env::type_id::create(
            "env", this
        );

    endfunction

endclassclass base_test extends uvm_test;

    `uvm_component_utils(base_test)

    cdc_fifo_env env;


    function new(string name = "base_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = cdc_fifo_env::type_id::create(
            "env", this
        );

    endfunction

endclass