class read_sequence extends uvm_sequence #(read_transaction);

    `uvm_object_utils(read_sequence)

    int num_reads = 1;


    function new(string name = "read_sequence");
        super.new(name);
    endfunction


    task body();

        read_transaction tx;

        repeat (num_reads) begin

            tx = read_transaction::type_id::create("tx");

            start_item(tx);

            finish_item(tx);

        end

    endtask

endclass