interface cdc_fifo_if #(
    parameter int DATA_WIDTH = 4,
    parameter int FIFO_DEPTH = 16);

   // Write domain
   logic [DATA_WIDTH-1:0] wdata;
   logic winc, wclk, wnrst, wfull;
   
   //Read domain
   logic [DATA_WIDTH-1:0] rdata;
   logic rinc, rclk, rnrst, rempty;

   //write-side driver clocking block
    clocking write_drv_cb @(posedge wclk);
        output wdata;
        output winc;
        input wfull;
    endclocking

    //Write-side monitor clocking block
    clocking write_mon_cb @(posedge wclk);
        input wdata;
        input winc;
        input wfull;
    endclocking

    //Read-side driver clocking block
    clocking read_drv_cb @(posedge rclk);
        input rdata;
        output rinc;
        input rempty;
    endclocking

    //Read-side monitor clocking block
    clocking read_mon_cb @(posedge rclk);
        input rdata;
        input rinc;
        input rempty;
    endclocking
endinterface