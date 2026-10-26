module tb_top;

    import uvm_pkg::*;
    import cdc_fifo_pkg::*;


    // Interface
    cdc_fifo_if #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) fifo_if();


    // DUT
    socetlib_cdc_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .wdata  (fifo_if.wdata),
        .winc   (fifo_if.winc),
        .wclk   (fifo_if.wclk),
        .wnrst  (fifo_if.wnrst),
        .wfull  (fifo_if.wfull),

        .rdata  (fifo_if.rdata),
        .rinc   (fifo_if.rinc),
        .rclk   (fifo_if.rclk),
        .rnrst  (fifo_if.rnrst),
        .rempty (fifo_if.rempty)
    );


    // Write clock
    initial begin
        fifo_if.wclk = 1'b0;

        forever #10
            fifo_if.wclk = ~fifo_if.wclk;
    end


    // Read clock
    initial begin
        fifo_if.rclk = 1'b0;

        forever #5
            fifo_if.rclk = ~fifo_if.rclk;
    end


    // Reset
    initial begin

        fifo_if.wnrst = 1'b0;
        fifo_if.rnrst = 1'b0;

        repeat (3) @(posedge fifo_if.wclk);

        fifo_if.wnrst = 1'b1;
        fifo_if.rnrst = 1'b1;

    end


    // Start UVM
    initial begin

        uvm_config_db#(virtual cdc_fifo_if)::set(
            null,
            "*",
            "vif",
            fifo_if
        );

        run_test();

    end

endmodule