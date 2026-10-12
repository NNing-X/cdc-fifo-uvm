class write_transaction extends uvm_sequence_item;

    rand logic [DATA_WIDTH-1:0] data;

    `uvm_object_utils(write_transaction)

    function new(string name = "write_transaction");
        super.new(name);
    endfunction

endclass