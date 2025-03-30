`timescale 1ps/1ps

module all_top_tb;

// localparam string WEIGHT_MEM_FILE = "test_data/weight_mem.bin";
// localparam string RD_MEM_FILE = "test_data/rd_mem.bin";
// localparam string WT_MEM_FILE = "test_data/wt_mem.bin";

localparam string WEIGHT_MEM_FILE = "utils/mem_w.bin";
localparam string RD_MEM_FILE = "utils/mem_in.bin";
localparam string WT_MEM_FILE = "wt_mem.bin";

logic clk, rst_n;


sdram_read_intf #(.SDRAM_DATA_W(128)) i_sdram_read_intf();
sdram_intf #(.SDRAM_DATA_W(128)) i_sdram_intf();

// ----------------- Bi-directional SDRAM -----------------
logic [127 : 0] bi_readdata;
logic bi_readdatavalid;
logic bi_waitrequest;
logic bi_read;
logic [31 : 0] bi_address;
logic [10 : 0] bi_burstcount;
logic bi_write;
logic [127 : 0] bi_writedata;
logic [15 : 0] bi_byteenable;

avmm_sdram_wrapper #(.SDRAM_DATA_W(128) ) i_avmm_sdram_wrapper (
    .clk(clk),
    .rst_n(rst_n),

    .readdata(bi_readdata),
    .readdatavalid(bi_readdatavalid),
    .waitrequest(bi_waitrequest),
    .read(bi_read),
    .address(bi_address),
    .burstcount(bi_burstcount),
    .write(bi_write),
    .writedata(bi_writedata),
    .byteenable(bi_byteenable),

    .rw_addr(i_sdram_intf.rw_addr),
    .rw_cnt(i_sdram_intf.rw_cnt),
    .rw_done(i_sdram_intf.rw_done),

    .read_start(i_sdram_intf.read_start),
    .read_valid(i_sdram_intf.read_valid),
    .read_data(i_sdram_intf.read_data),

    .write_start(i_sdram_intf.write_start),
    .write_nxt(i_sdram_intf.write_nxt),
    .write_data(i_sdram_intf.write_data)
);

avmm_sdram_bfm #(
    .SDRAM_W(128),
    .RD_MEM_FILE(RD_MEM_FILE),
    .RD_MEM_SIZE(1024*1024),
    .RD_MEM_OFFSET(512*1024*1024),
    .WT_MEM_FILE(WT_MEM_FILE),
    .WT_MEM_SIZE(1024*1024),
    .WT_MEM_OFFSET(512*1024*1024)
) i_sdram_bi_slave (
    .clk(clk), 
    .rst_n(rst_n),
    .address(bi_address),
    .burstcount(bi_burstcount),
    .waitrequest(bi_waitrequest),
    .readdata(bi_readdata),
    .readdatavalid(bi_readdatavalid),
    .read(bi_read),
    .writedata(bi_writedata),
    .byteenable(bi_byteenable),
    .write(bi_write)
);

// ----------------- Read-only SDRAM -----------------
logic [127 : 0] ro_readdata;
logic ro_readdatavalid;
logic ro_waitrequest;
logic ro_read;
logic [31 : 0] ro_address;
logic [10 : 0] ro_burstcount;

avmm_sdram_read_wrapper #(.SDRAM_DATA_W(128) ) i_avmm_sdram_read_wrapper (
    .clk(clk),
    .rst_n(rst_n),

    .readdata(ro_readdata),
    .readdatavalid(ro_readdatavalid),
    .waitrequest(ro_waitrequest),
    .read(ro_read),
    .address(ro_address),
    .burstcount(ro_burstcount),

    .read_addr(i_sdram_read_intf.read_addr),
    .read_cnt(i_sdram_read_intf.read_cnt),
    .read_done(i_sdram_read_intf.read_done),

    .read_start(i_sdram_read_intf.read_start),
    .read_valid(i_sdram_read_intf.read_valid),
    .read_data(i_sdram_read_intf.read_data)
);

avmm_sdram_bfm #(
    .SDRAM_W(128),
    .RD_MEM_FILE(WEIGHT_MEM_FILE),
    .RD_MEM_SIZE(256*1024*1024),
    .RD_MEM_OFFSET(512*1024*1024),
    .WT_MEM_FILE(""),
    .WT_MEM_SIZE(0),
    .WT_MEM_OFFSET(0)
) i_sdram_ro_slave (
    .clk(clk), 
    .rst_n(rst_n),
    .address(ro_address),
    .burstcount(ro_burstcount),
    .waitrequest(ro_waitrequest),
    .readdata(ro_readdata),
    .readdatavalid(ro_readdatavalid),
    .read(ro_read),
    .writedata('0),
    .byteenable('0),
    .write('0)    
);


// ----------------- Design top -----------------
logic [31 : 0] h2f_pio32;
logic [31 : 0] f2h_pio32;
logic h2f_write;
logic f2h_write;

logic [7 : 0] LED;

design_top i_design_top (
    .clk(clk),
    .rst_n(rst_n),

    .i_sdram_intf(i_sdram_intf),
    .i_sdram_read_intf(i_sdram_read_intf),

    .h2f_pio32(h2f_pio32),
    .h2f_write(h2f_write),
    .f2h_pio32(f2h_pio32),
    .f2h_write(f2h_write),

    .LED(LED)
);

// ----------------- HPS BFM -----------------
logic sim_stop;
hps_bfm i_hps_bfm (
    .clk(clk),
    .rst_n(rst_n),

    .h2f_pio32(h2f_pio32),
    .h2f_write(h2f_write),
    .f2h_pio32(f2h_pio32),
    .f2h_write(f2h_write),

    .sim_stop(sim_stop)
);

initial begin
    clk = 0;
    rst_n = 0;

    i_sdram_bi_slave.read_file_to_mem();
    i_sdram_ro_slave.read_file_to_mem();

    @(negedge clk);
    rst_n = 1;

    @(posedge sim_stop);
    i_sdram_bi_slave.write_mem_to_file();
    $stop();
end

always #10000 clk = ~clk;

endmodule
