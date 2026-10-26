class write_sequence extends uvm_sequence #(write_transaction);

    `uvm_object_utils(write_sequence)

    int num_writes = 1;


    function new(string name = "write_sequence");
        super.new(name);
    endfunction


    task body();

        write_transaction tx;

        repeat (num_writes) begin

            tx = write_transaction::type_id::create("tx");

            start_item(tx);

            if (!tx.randomize()) begin
                `uvm_fatal(
                    "RAND_FAIL",
                    "Failed to randomize write transaction"
                )
            end

            finish_item(tx);

        end

    endtask

endclass