class read_transaction extends uvm_sequence_item;

    logic [DATA_WIDTH-1:0] data;

    `uvm_object_utils(read_transaction)

    function new(string name = "read_transaction");
        super.new(name);
    endfunction

endclass