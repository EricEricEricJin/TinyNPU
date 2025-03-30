`default_nettype none

module stmm_wrapper_tb;

logic clk, rst_n;

rmio_intf #( ) i_rmio_intf [4] ();

sdram_read_intf i_sdram_read_intf;

logic [3 : 0] fetch, exec;
logic [31 : 0] fetch_addr;

logic fetch_done;
logic [3 : 0] exec_done;

stmm_wrapper #( .SUB_NUM(4), .N(176), .SDRAM_W(128) ) i_stmm_wrapper (
    .clk(clk),
    .rst_n(rst_n),
    .i_rmio_intf(i_rmio_intf),    
    .i_sdram_read_intf(i_sdram_read_intf),
    .fetch(fetch),
    .exec(exec),
    .fetch_addr(fetch_addr),
    .fetch_done(fetch_done),
    .exec_done(exec_done)
);

logic [31 : 0] address;
logic [10 : 0] burstcount;
logic waitrequest;
logic [127 : 0] readdata;
logic readdatavalid;
logic read;

sdram_slave_bfm #(
    .SDRAM_W        (128),
    .RD_MEM_FILE    ("simulation/sdram_bfm/rd_mem.bin"),
    .RD_MEM_SIZE    (1024*1024),
    .RD_MEM_OFFSET  (512*1024*1024),
    .WT_MEM_FILE    (""),
    .WT_MEM_SIZE    (),
    .WT_MEM_OFFSET  ()
) i_sdram_slave_bfm (
    .clk    (clk),
    .rst_n  (rst_n),
    .address    (address),
    .burstcount (burstcount),
    .waitrequest    (waitrequest),
    .readdata   (readdata),
    .readdatavalid  (readdatavalid),
    .read   (read),
    .writedata  ('0),
    .byteenable ('0),
    .write  ('0)
);

avmm_sdram_read_wrapper #(
    .SDRAM_DATA_W (128)
) sdram (
    .clk    (clk),
    .rst_n  (rst_n),
    
    .readdata       (readdata),
    .readdatavalid  (readdatavalid),
    .waitrequest    (waitrequest),
    .read           (read),
    .address        (address),
    .burstcount     (burstcount),
    .read_addr  (i_sdram_read_intf.read_addr),
    .read_cnt   (i_sdram_read_intf.read_cnt),
    .read_start (i_sdram_read_intf.read_start),
    .read_valid (i_sdram_read_intf.read_valid),
    .read_data  (i_sdram_read_intf.read_data),
    .read_done  (i_sdram_read_intf.read_done)
);

initial begin
    clk = 1'b0;
    rst_n = 1'b0;

    fetch = '0;
    exec = '0;
    fetch_addr = '0;

    @(negedge clk) rst_n = 1'b1;


    fetch_addr = 32'h20_000_000;
    @(negedge clk) fetch = 4'b1;
    @(negedge clk) fetch = 4'b0;

    @(posedge fetch_done);
    @(negedge clk);
    $display("fetch done");

    i_rmio_intf.input_data = 

    $stop();
end

always #5 clk = ~clk;

endmodule

`default_nettype wire