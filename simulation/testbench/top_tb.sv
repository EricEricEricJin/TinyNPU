/**
 * Organization: The University of Hong Kong 
 * Student: Jin Yushang
 * Project: ELEC4848 SDP

 * File: top_tb.sv
 * Brief: top module for functional simulation
 */
`timescale 1ps/1ps

module top_tb;

import avmm_sdram_bfm_pkg::*;
import hps_bfm_pkg::*;

////////////////////////
// Board hardware
//////////////////////// 

logic 		     [1:0]		KEY;
logic		     [7:0]		LED;
logic 		     [3:0]		SW;
logic                       FPGA_CLK1_50;

initial KEY = '1;

initial FPGA_CLK1_50 = 0;
always #10_000 FPGA_CLK1_50 = ~FPGA_CLK1_50;

////////////////////////
// Parameters
////////////////////////
localparam int SDRAM_W = 128;

////////////////////////
// Clock and reset 
////////////////////////
logic h2f_rst_n;
logic clk;
logic rst_n;

assign clk = FPGA_CLK1_50;
assign rst_n = h2f_rst_n & KEY[0];

//////////////////////////
// HPS SOC
//////////////////////////
logic [31 : 0] f2h_pio32, h2f_pio32;
logic f2h_read, h2f_write;

sdram_intf i_sdram_intf_bi_0 ();
sdram_read_intf i_sdram_intf_read_0 ();


soc_system u0 (
    .clk_clk                  (clk),                  //        clk.clk
    .reset_reset_n            (rst_n),            //      reset.reset_n
	.h2f_reset_reset_n        (h2f_rst_n),        //  h2f_reset.reset_n
	
	// -------------------- MMIO between HPS and FPGA --------------------
	.f2h_pio32_en_out         (f2h_read),         //  f2h_pio32.en_out
	.f2h_pio32_data_in        (f2h_pio32),        //           .data_in
	.h2f_pio32_en_out         (h2f_write),         //  h2f_pio32.en_out
	.h2f_pio32_data_out       (h2f_pio32),       //           .data_out

	// -------------------- SDRAM Read --------------------
	.avmm_sdram_read_wrapper_0_read_read_start (i_sdram_intf_read_0.read_start), // avmm_sdram_read_wrapper_0_read.read_start
	.avmm_sdram_read_wrapper_0_read_read_cnt   (i_sdram_intf_read_0.read_cnt),   //                               .read_cnt
	.avmm_sdram_read_wrapper_0_read_read_data  (i_sdram_intf_read_0.read_data),  //                               .read_data
	.avmm_sdram_read_wrapper_0_read_read_addr  (i_sdram_intf_read_0.read_addr),  //                               .read_addr
	.avmm_sdram_read_wrapper_0_read_read_done  (i_sdram_intf_read_0.read_done),  //                               .read_done
	.avmm_sdram_read_wrapper_0_read_read_valid (i_sdram_intf_read_0.read_valid), //  							  .read_valid

	// -------------------- SDRAM Bidirectional --------------------
	.avmm_sdram_wrapper_0_read_read_start   (i_sdram_intf_bi_0.read_start),   //  avmm_sdram_wrapper_0_read.read_start
	.avmm_sdram_wrapper_0_read_read_data    (i_sdram_intf_bi_0.read_data),    //                           .read_data
	.avmm_sdram_wrapper_0_read_read_valid   (i_sdram_intf_bi_0.read_valid),   //                           .read_valid

	.avmm_sdram_wrapper_0_rw_rw_cnt         (i_sdram_intf_bi_0.rw_cnt),         //    avmm_sdram_wrapper_0_rw.rw_cnt
	.avmm_sdram_wrapper_0_rw_rw_done        (i_sdram_intf_bi_0.rw_done),        //                           .rw_done
	.avmm_sdram_wrapper_0_rw_rw_addr        (i_sdram_intf_bi_0.rw_addr),        //                           .rw_addr

	.avmm_sdram_wrapper_0_write_write_data  (i_sdram_intf_bi_0.write_data),  // avmm_sdram_wrapper_0_write.write_data
	.avmm_sdram_wrapper_0_write_write_nxt   (i_sdram_intf_bi_0.write_nxt),   //                           .write_nxt
	.avmm_sdram_wrapper_0_write_write_start (i_sdram_intf_bi_0.write_start) //   
);


////////////////////////
// Design Top
////////////////////////
design_top i_design_top (
    .clk            (clk),   
    .rst_n          (rst_n),

    .i_sdram_intf   (i_sdram_intf_bi_0.ldst),
	.i_sdram_read_intf (i_sdram_intf_read_0.fetch),
    
    .h2f_pio32      (h2f_pio32),
    .h2f_write      (h2f_write),
    
    .f2h_pio32      (f2h_pio32),
    .f2h_write      (f2h_write),

    .LED            (LED)
);


endmodule
