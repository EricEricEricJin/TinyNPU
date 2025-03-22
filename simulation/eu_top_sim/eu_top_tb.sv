!!! NOT FINISHED YET !!!

`default_nettype none

module eu_top_tb;

logic clk, rst_n;

sdram_read_intf i_sdram_read_intf;
rmio_intf rmio_stmm [4];
eu_ctrl_intf ctrl_intf_stmm;

logic [4 : 0] sdram_read_sel;
logic fetch_done;
logic [27 : 0] exec_done;

eu_top i_eu_top (
    .clk(clk),
    .rst_n(rst_n),
    
    // ---------- Avalon MM Read ----------
    .i_sdram_read_intf(i_sdram_read_intf),
    
    // ---------- RMIO ----------
    .rmio_stmm(rmio_stmm),
    
    // ---------- Control Unit eu_ctrl_intf ----------
    .sdram_read_sel(sdram_read_sel),
    
    .ctrl_intf_stmm(ctrl_intf_stmm),
    
    // ---------- States ----------
    .fetch_done(fetch_done),
    .exec_done(exec_done)
);


// ---------- test procedure ----------
initial begin
    clk = 0;
    rst_n = 0;

    i_sdram_slave_bfm.read_file_to_mem();
    
    sdram_read_sel = 0;
    ctrl_intf_stmm.fetch = 0;
    ctrl_intf_stmm.exec = 0;

    rst_n = 1;

    @(negedge clk);

    ctrl_intf_stmm.sub_idx = 0;
    ctrl_intf_stmm.fetch_addr = 32'h20_000_000;
    
    ctrl_intf_stmm.fetch = 1;
    @(negedge clk);
    ctrl_intf_stmm.fetch = 0;

    @(posedge fetch_done);
    $display("Fetch done");
    @(negedge clk);

    rmio_stmm[0].input_data = 0;

    ctrl_intf_stmm.exec = 1;
    @(negedge clk);
    ctrl_intf_stmm.exec = 0;

    @(posedge exec_done[0]);
    $display("Exec done");
    @(negedge clk);

    $stop();
end

always #10000 clk = ~clk;  




// ---------- SDRAM READ BFM ----------

logic [31:0]             address;
logic [10:0]             burstcount;
logic                    waitrequest;
logic [SDRAM_W-1:0]      readdata;
logic                    readdatavalid;
logic                    read;
logic [SDRAM_W-1:0]      writedata;
logic [15:0]             byteenable;
logic                    write;

sdram_slave_bfm #(
    .SDRAM_W        (128),
    .RD_MEM_FILE    ("simulation/eu_top_sim/rd_mem.bin"),
    .RD_MEM_SIZE    (1024*1024),
    .RD_MEM_OFFSET  (512*1024*1024),
    .WT_MEM_FILE    ("simulation/eu_top_sim/wt_mem.bin"),
    .WT_MEM_SIZE    (1024*1024),
    .WT_MEM_OFFSET  (512*1024*1024)
) i_sdram_slave_bfm (
    .clk    (clk),
    .rst_n  (rst_n),
    .address    (address),
    .burstcount (burstcount),
    .waitrequest    (waitrequest),
    .readdata   (readdata),
    .readdatavalid  (readdatavalid),
    .read   (read),
    .writedata  (writedata),
    .byteenable (byteenable),
    .write  (write)
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

endmodule

`default_nettype wire
