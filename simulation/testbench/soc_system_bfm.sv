// `define MM_PRGM "simulation/program/stmm.mm.sv"
// `define HPS_PRGM "simulation/program/stmm.hps.sv"

// `define MM_PRGM "simulation/program/layernorm.mm.sv"
// `define HPS_PRGM "simulation/program/layernorm.hps.sv"

`define MM_PRGM "simulation/program/lut.mm.sv"
`define HPS_PRGM "simulation/program/lut.hps.sv"

`default_nettype none

module soc_system #(
    parameter int SDRAM_W = 128,
    parameter int H2F_PIO_W = 32,
    parameter int F2H_PIO_W = 32,
    parameter string WT_MEM_FILE = "wt_mem.bin"
) (
    input wire clk_clk,             // system clock input
    input wire reset_reset_n,       // system reset input
    output logic h2f_reset_reset_n, // HPS to FPGA reset


	// -------------------- MMIO between HPS and FPGA --------------------
    output logic f2h_pio32_en_out,
    input wire [F2H_PIO_W - 1 : 0] f2h_pio32_data_in,
    output logic h2f_pio32_en_out,
    output logic [H2F_PIO_W - 1 : 0] h2f_pio32_data_out,

	// -------------------- SDRAM Read --------------------
	input wire                      avmm_sdram_read_wrapper_0_read_read_start,
	input wire [10 : 0]             avmm_sdram_read_wrapper_0_read_read_cnt,
	output logic [SDRAM_W - 1 : 0]  avmm_sdram_read_wrapper_0_read_read_data,
	input wire [31 : 0]             avmm_sdram_read_wrapper_0_read_read_addr,
	output logic                    avmm_sdram_read_wrapper_0_read_read_done,
	output logic                    avmm_sdram_read_wrapper_0_read_read_valid,

	// -------------------- SDRAM Bidirectional --------------------
	input wire                      avmm_sdram_wrapper_0_read_read_start,
	output logic [SDRAM_W - 1 : 0]  avmm_sdram_wrapper_0_read_read_data,
	output logic                    avmm_sdram_wrapper_0_read_read_valid,
	input wire [10 : 0]             avmm_sdram_wrapper_0_rw_rw_cnt,
	output logic                    avmm_sdram_wrapper_0_rw_rw_done,
	input wire [31 : 0]             avmm_sdram_wrapper_0_rw_rw_addr,
	input wire [SDRAM_W - 1 : 0]    avmm_sdram_wrapper_0_write_write_data,
	output logic                    avmm_sdram_wrapper_0_write_write_nxt,
	input wire                      avmm_sdram_wrapper_0_write_write_start
);

logic clk, rst_n;
assign clk = clk_clk;
assign rst_n = reset_reset_n;

import avmm_sdram_bfm_pkg::*;
import hps_bfm_pkg::*;

// ----------------- BFMs -----------------
avmmSdramBfm #(.SDRAM_W (128)) i_sdram_bi_slave;
avmmSdramBfm #(.SDRAM_W (128)) i_sdram_ro_slave;
hpsBfm #(.H2F_PIO_W(32), .F2H_PIO_W(32)) i_hps_bfm;

// ----------------- Interfaces and port connections -----------------
avmm_raw_intf #(.SDRAM_W(128)) i_avmm_raw_bi_intf();
avmm_raw_intf #(.SDRAM_W(128)) i_avmm_raw_ro_intf();
assign i_avmm_raw_ro_intf.write = 1'b0;

assign h2f_pio32_data_out = i_hps_bfm.h2f_pio32;
assign h2f_pio32_en_out = i_hps_bfm.h2f_write;
assign i_hps_bfm.f2h_pio32 = f2h_pio32_data_in;
assign i_hps_bfm.f2h_write = f2h_pio32_en_out;

// ----------------- SDRAM Wrappers -----------------
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

    .rw_addr(avmm_sdram_wrapper_0_rw_rw_addr),
    .rw_cnt (avmm_sdram_wrapper_0_rw_rw_cnt),
    .rw_done(avmm_sdram_wrapper_0_rw_rw_done),

    .read_start (avmm_sdram_wrapper_0_read_read_start),
    .read_valid (avmm_sdram_wrapper_0_read_read_valid),
    .read_data  (avmm_sdram_wrapper_0_read_read_data),

    .write_start(avmm_sdram_wrapper_0_write_write_start),
    .write_nxt  (avmm_sdram_wrapper_0_write_write_nxt),
    .write_data (avmm_sdram_wrapper_0_write_write_data)
);

avmm_sdram_read_wrapper #(.SDRAM_DATA_W(128) ) i_avmm_sdram_read_wrapper (
    .clk    (clk),
    .rst_n  (rst_n),

    .readdata       (i_avmm_raw_ro_intf.readdata),
    .readdatavalid  (i_avmm_raw_ro_intf.readdatavalid), 
    .waitrequest    (i_avmm_raw_ro_intf.waitrequest),
    .read           (i_avmm_raw_ro_intf.read),
    .address        (i_avmm_raw_ro_intf.address),
    .burstcount     (i_avmm_raw_ro_intf.burstcount),

    .read_addr  (avmm_sdram_read_wrapper_0_read_read_addr),
    .read_cnt   (avmm_sdram_read_wrapper_0_read_read_cnt),
    .read_done  (avmm_sdram_read_wrapper_0_read_read_done),

    .read_start (avmm_sdram_read_wrapper_0_read_read_start),
    .read_valid (avmm_sdram_read_wrapper_0_read_read_valid),
    .read_data  (avmm_sdram_read_wrapper_0_read_read_data)
);

// do after reset 
initial begin

    h2f_reset_reset_n = 1'b0;

    i_sdram_bi_slave = new (128*1024, 32'h3000_0000);
    i_sdram_ro_slave = new (176*176*2, 32'h2000_0000);
    i_hps_bfm = new();

    i_sdram_bi_slave.i_avmm_raw_intf = i_avmm_raw_bi_intf;
    i_sdram_ro_slave.i_avmm_raw_intf = i_avmm_raw_ro_intf;



    // i_sdram_bi_slave.read_file_to_mem(RD_MEM_FILE, 32'h3000_0000, 176*166);
    // i_sdram_ro_slave.read_file_to_mem(WEIGHT_MEM_FILE, 32'h2000_0000, 176*176+16);

    // `include "simulation/program/stmm.mm.sv"
    `include `MM_PRGM

    fork
        i_sdram_bi_slave.run(clk, rst_n);
        i_sdram_ro_slave.run(clk, rst_n);
    join_none

    i_hps_bfm.reset(clk, h2f_reset_reset_n);

    repeat (10) @(negedge clk);

    // i_hps_bfm.run(clk, h2f_reset_reset_n);
    // `include "simulation/program/stmm.hps.sv"
    `include `HPS_PRGM

    i_sdram_bi_slave.write_mem_to_file(WT_MEM_FILE);

    $stop();
end

endmodule

`default_nettype wire
