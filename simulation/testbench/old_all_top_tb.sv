`timescale 1ps/1ps

module all_top_tb;

import avmm_sdram_bfm_pkg::*;
import hps_bfm_pkg::*;
// import avmm_raw_intf_pkg::*;

localparam string WEIGHT_MEM_FILE = "utils/mem_w.bin";
localparam string RD_MEM_FILE = "utils/mem_in.bin";
localparam string WT_MEM_FILE = "wt_mem.bin";

logic clk, rst_n;

// ----------------- BFM -----------------
avmmSdramBfm #(.SDRAM_W (128)) i_sdram_bi_slave;
avmmSdramBfm #(.SDRAM_W (128)) i_sdram_ro_slave;
hpsBfm #(.H2F_PIO_W(32), .F2H_PIO_W(32)) i_hps_bfm;

avmm_raw_intf #(.SDRAM_W(128)) i_avmm_raw_bi_intf();
avmm_raw_intf #(.SDRAM_W(128)) i_avmm_raw_ro_intf();
assign i_avmm_raw_ro_intf.write = 1'b0;

sdram_read_intf #(.SDRAM_DATA_W(128)) i_sdram_read_intf();
sdram_intf #(.SDRAM_DATA_W(128)) i_sdram_intf();

// ----------------- Bi-directional SDRAM -----------------
// logic [127 : 0] bi_readdata;
// logic bi_readdatavalid;
// logic bi_waitrequest;
// logic bi_read;
// logic [31 : 0] bi_address;
// logic [10 : 0] bi_burstcount;
// logic bi_write;
// logic [127 : 0] bi_writedata;
// logic [15 : 0] bi_byteenable;

avmm_sdram_wrapper #(.SDRAM_DATA_W(128) ) i_avmm_sdram_wrapper (
    .clk    (clk),
    .rst_n  (rst_n),

    .readdata       (i_avmm_raw_bi_intf.readdata),
    .readdatavalid  (i_avmm_raw_bi_intf.readdatavalid),
    .waitrequest    (i_avmm_raw_bi_intf.waitrequest),
    .read           (i_avmm_raw_bi_intf.read),
    .address        (i_avmm_raw_bi_intf.address),
    .burstcount     (i_avmm_raw_bi_intf.burstcount),
    .write          (i_avmm_raw_bi_intf.write),
    .writedata      (i_avmm_raw_bi_intf.writedata),
    .byteenable     (i_avmm_raw_bi_intf.byteenable),

    .rw_addr(i_sdram_intf.rw_addr),
    .rw_cnt (i_sdram_intf.rw_cnt),
    .rw_done(i_sdram_intf.rw_done),

    .read_start (i_sdram_intf.read_start),
    .read_valid (i_sdram_intf.read_valid),
    .read_data  (i_sdram_intf.read_data),

    .write_start(i_sdram_intf.write_start),
    .write_nxt  (i_sdram_intf.write_nxt),
    .write_data (i_sdram_intf.write_data)
);

// ----------------- Read-only SDRAM -----------------
// logic [127 : 0] ro_readdata;
// logic ro_readdatavalid;
// logic ro_waitrequest;
// logic ro_read;
// logic [31 : 0] ro_address;
// logic [10 : 0] ro_burstcount;

avmm_sdram_read_wrapper #(.SDRAM_DATA_W(128) ) i_avmm_sdram_read_wrapper (
    .clk    (clk),
    .rst_n  (rst_n),

    .readdata       (i_avmm_raw_ro_intf.readdata),
    .readdatavalid  (i_avmm_raw_ro_intf.readdatavalid), 
    .waitrequest    (i_avmm_raw_ro_intf.waitrequest),
    .read           (i_avmm_raw_ro_intf.read),
    .address        (i_avmm_raw_ro_intf.address),
    .burstcount     (i_avmm_raw_ro_intf.burstcount),

    .read_addr  (i_sdram_read_intf.read_addr),
    .read_cnt   (i_sdram_read_intf.read_cnt),
    .read_done  (i_sdram_read_intf.read_done),

    .read_start (i_sdram_read_intf.read_start),
    .read_valid (i_sdram_read_intf.read_valid),
    .read_data  (i_sdram_read_intf.read_data)
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

    // .h2f_pio32(h2f_pio32),
    // .h2f_write(h2f_write),
    // .f2h_pio32(f2h_pio32),
    // .f2h_write(f2h_write),
    .h2f_pio32(i_hps_bfm.h2f_pio32),
    .h2f_write(i_hps_bfm.h2f_write),
    .f2h_pio32(i_hps_bfm.f2h_pio32),
    .f2h_write(i_hps_bfm.f2h_write),

    .LED(LED)
);


bit sim_stop;
logic ro_write;
logic [127 : 0] ro_writedata;
logic [15 : 0] ro_byteenable;

initial begin
    ro_write = 0;
    ro_writedata = 0;
    ro_byteenable = 0;

    sim_stop = 0;
    clk = 0;
    rst_n = 0;

    i_sdram_bi_slave = new (128*1024, 32'h3000_0000);
    i_sdram_ro_slave = new (176*176*2, 32'h2000_0000);
    i_hps_bfm = new();

    i_sdram_bi_slave.i_avmm_raw_intf = i_avmm_raw_bi_intf;
    i_sdram_ro_slave.i_avmm_raw_intf = i_avmm_raw_ro_intf;

    i_sdram_bi_slave.read_file_to_mem(RD_MEM_FILE, 32'h3000_0000, 176*166);
    i_sdram_ro_slave.read_file_to_mem(WEIGHT_MEM_FILE, 32'h2000_0000, 176*176+16);


    fork
        // i_sdram_bi_slave.run(
        //     .clk(clk),
        //     .address(bi_address),
        //     .burstcount(bi_burstcount),
        //     .waitrequest(bi_waitrequest),
        //     .read(bi_read),
        //     .readdata(bi_readdata),
        //     .readdatavalid(bi_readdatavalid),
        //     .writedata(bi_writedata),
        //     .write(bi_write),
        //     .byteenable(bi_byteenable)
        // );
        i_sdram_bi_slave.run(clk, rst_n);

        // i_sdram_ro_slave.run(
        //     .clk(clk),
        //     .address(ro_address),
        //     .burstcount(ro_burstcount),
        //     .waitrequest(ro_waitrequest),
        //     .read(ro_read),
        //     .readdata(ro_readdata),
        //     .readdatavalid(ro_readdatavalid),
        //     .writedata(ro_writedata),
        //     .write(ro_write),
        //     .byteenable(ro_byteenable)
        // );
        i_sdram_ro_slave.run(clk, rst_n);
    join_none
    i_hps_bfm.reset(clk, rst_n);
    // i_hps_bfm.run(
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .h2f_pio32(h2f_pio32),
    //     .h2f_write(h2f_write),
    //     .f2h_pio32(f2h_pio32),
    //     .f2h_write(f2h_write),
    //     .sim_stop(sim_stop)
    // );
    i_hps_bfm.run(clk);

    i_sdram_bi_slave.write_mem_to_file(WT_MEM_FILE);
    $stop();

end

always #10000 clk = ~clk;

endmodule
