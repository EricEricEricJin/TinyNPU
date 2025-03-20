
module soc_system (
	avmm_sdram_read_wrapper_0_read_read_start,
	avmm_sdram_read_wrapper_0_read_read_cnt,
	avmm_sdram_read_wrapper_0_read_read_data,
	avmm_sdram_read_wrapper_0_read_read_addr,
	avmm_sdram_read_wrapper_0_read_read_done,
	avmm_sdram_read_wrapper_0_read_read_valid,
	avmm_sdram_wrapper_0_read_read_start,
	avmm_sdram_wrapper_0_read_read_data,
	avmm_sdram_wrapper_0_read_read_valid,
	avmm_sdram_wrapper_0_rw_rw_cnt,
	avmm_sdram_wrapper_0_rw_rw_done,
	avmm_sdram_wrapper_0_rw_rw_addr,
	avmm_sdram_wrapper_0_write_write_data,
	avmm_sdram_wrapper_0_write_write_nxt,
	avmm_sdram_wrapper_0_write_write_start,
	clk_clk,
	f2h_pio32_en_out,
	f2h_pio32_data_in,
	h2f_pio32_en_out,
	h2f_pio32_data_out,
	h2f_reset_reset_n,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	reset_reset_n);	

	input		avmm_sdram_read_wrapper_0_read_read_start;
	input	[10:0]	avmm_sdram_read_wrapper_0_read_read_cnt;
	output	[127:0]	avmm_sdram_read_wrapper_0_read_read_data;
	input	[31:0]	avmm_sdram_read_wrapper_0_read_read_addr;
	output		avmm_sdram_read_wrapper_0_read_read_done;
	output		avmm_sdram_read_wrapper_0_read_read_valid;
	input		avmm_sdram_wrapper_0_read_read_start;
	output	[127:0]	avmm_sdram_wrapper_0_read_read_data;
	output		avmm_sdram_wrapper_0_read_read_valid;
	input	[10:0]	avmm_sdram_wrapper_0_rw_rw_cnt;
	output		avmm_sdram_wrapper_0_rw_rw_done;
	input	[31:0]	avmm_sdram_wrapper_0_rw_rw_addr;
	input	[127:0]	avmm_sdram_wrapper_0_write_write_data;
	output		avmm_sdram_wrapper_0_write_write_nxt;
	input		avmm_sdram_wrapper_0_write_write_start;
	input		clk_clk;
	output		f2h_pio32_en_out;
	input	[31:0]	f2h_pio32_data_in;
	output		h2f_pio32_en_out;
	output	[31:0]	h2f_pio32_data_out;
	output		h2f_reset_reset_n;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input		reset_reset_n;
endmodule
