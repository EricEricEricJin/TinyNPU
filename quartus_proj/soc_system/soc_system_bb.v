
module soc_system (
	ext_clk_clk,
	ext_rst_reset_n,
	f2h_pio32_en_out,
	f2h_pio32_data_in,
	f2h_sdram0_address,
	f2h_sdram0_burstcount,
	f2h_sdram0_waitrequest,
	f2h_sdram0_readdata,
	f2h_sdram0_readdatavalid,
	f2h_sdram0_read,
	f2h_sdram0_writedata,
	f2h_sdram0_byteenable,
	f2h_sdram0_write,
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
	pll_locked_export,
	sys_clk_clk,
	sys_rst_reset_n);	

	input		ext_clk_clk;
	input		ext_rst_reset_n;
	output		f2h_pio32_en_out;
	input	[31:0]	f2h_pio32_data_in;
	input	[27:0]	f2h_sdram0_address;
	input	[7:0]	f2h_sdram0_burstcount;
	output		f2h_sdram0_waitrequest;
	output	[127:0]	f2h_sdram0_readdata;
	output		f2h_sdram0_readdatavalid;
	input		f2h_sdram0_read;
	input	[127:0]	f2h_sdram0_writedata;
	input	[15:0]	f2h_sdram0_byteenable;
	input		f2h_sdram0_write;
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
	output		pll_locked_export;
	output		sys_clk_clk;
	input		sys_rst_reset_n;
endmodule
