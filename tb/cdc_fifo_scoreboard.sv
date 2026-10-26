`uvm_analysis_imp_decl(_write)
`uvm_analysis_imp_decl(_read)

class cdc_fifo_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(cdc_fifo_scoreboard)

    uvm_analysis_imp_write #(write_transaction, cdc_fifo_scoreboard) write_imp;
    uvm_analysis_imp_read  #(read_transaction,  cdc_fifo_scoreboard) read_imp;

    logic [DATA_WIDTH-1:0] expected_queue[$];

    int write_count;
    int read_count;
    int error_count;


    function new(string name = "cdc_fifo_scoreboard",
                 uvm_component parent = null);

        super.new(name, parent);

        write_imp = new("write_imp", this);
        read_imp  = new("read_imp", this);

        write_count = 0;
        read_count  = 0;
        error_count = 0;

    endfunction


    function void write_write(write_transaction tx);

        expected_queue.push_back(tx.data);
        write_count++;

        `uvm_info(
            "SCB_WRITE",
            $sformatf(
                "Expected queue push: data=0x%0h, queue_size=%0d",
                tx.data,
                expected_queue.size()
            ),
            UVM_MEDIUM
        )

    endfunction


    function void write_read(read_transaction tx);

        logic [DATA_WIDTH-1:0] expected_data;

        read_count++;

        if (expected_queue.size() == 0) begin

            error_count++;

            `uvm_error(
                "SCB_EMPTY",
                $sformatf(
                    "Observed read data 0x%0h, but expected queue is empty",
                    tx.data
                )
            )

        end
        else begin

            expected_data = expected_queue.pop_front();

            if (tx.data !== expected_data) begin

                error_count++;

                `uvm_error(
                    "SCB_MISMATCH",
                    $sformatf(
                        "Data mismatch: expected=0x%0h actual=0x%0h",
                        expected_data,
                        tx.data
                    )
                )

            end
            else begin

                `uvm_info(
                    "SCB_MATCH",
                    $sformatf(
                        "Data matched: expected=0x%0h actual=0x%0h",
                        expected_data,
                        tx.data
                    ),
                    UVM_MEDIUM
                )

            end

        end

    endfunction


    function void check_phase(uvm_phase phase);

        super.check_phase(phase);

        if (expected_queue.size() != 0) begin

            `uvm_warning(
                "SCB_REMAINING",
                $sformatf(
                    "%0d expected item(s) remain in scoreboard queue",
                    expected_queue.size()
                )
            )

        end

    endfunction


    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info(
            "SCB_REPORT",
            $sformatf(
                "Scoreboard summary: writes=%0d reads=%0d errors=%0d remaining=%0d",
                write_count,
                read_count,
                error_count,
                expected_queue.size()
            ),
            UVM_LOW
        )

    endfunction

endclass