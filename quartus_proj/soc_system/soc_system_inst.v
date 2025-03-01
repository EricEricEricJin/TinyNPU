	soc_system u0 (
		.ext_clk_clk              (<connected-to-ext_clk_clk>),              //    ext_clk.clk
		.ext_rst_reset_n          (<connected-to-ext_rst_reset_n>),          //    ext_rst.reset_n
		.f2h_pio32_en_out         (<connected-to-f2h_pio32_en_out>),         //  f2h_pio32.en_out
		.f2h_pio32_data_in        (<connected-to-f2h_pio32_data_in>),        //           .data_in
		.f2h_sdram0_address       (<connected-to-f2h_sdram0_address>),       // f2h_sdram0.address
		.f2h_sdram0_burstcount    (<connected-to-f2h_sdram0_burstcount>),    //           .burstcount
		.f2h_sdram0_waitrequest   (<connected-to-f2h_sdram0_waitrequest>),   //           .waitrequest
		.f2h_sdram0_readdata      (<connected-to-f2h_sdram0_readdata>),      //           .readdata
		.f2h_sdram0_readdatavalid (<connected-to-f2h_sdram0_readdatavalid>), //           .readdatavalid
		.f2h_sdram0_read          (<connected-to-f2h_sdram0_read>),          //           .read
		.f2h_sdram0_writedata     (<connected-to-f2h_sdram0_writedata>),     //           .writedata
		.f2h_sdram0_byteenable    (<connected-to-f2h_sdram0_byteenable>),    //           .byteenable
		.f2h_sdram0_write         (<connected-to-f2h_sdram0_write>),         //           .write
		.h2f_pio32_en_out         (<connected-to-h2f_pio32_en_out>),         //  h2f_pio32.en_out
		.h2f_pio32_data_out       (<connected-to-h2f_pio32_data_out>),       //           .data_out
		.h2f_reset_reset_n        (<connected-to-h2f_reset_reset_n>),        //  h2f_reset.reset_n
		.memory_mem_a             (<connected-to-memory_mem_a>),             //     memory.mem_a
		.memory_mem_ba            (<connected-to-memory_mem_ba>),            //           .mem_ba
		.memory_mem_ck            (<connected-to-memory_mem_ck>),            //           .mem_ck
		.memory_mem_ck_n          (<connected-to-memory_mem_ck_n>),          //           .mem_ck_n
		.memory_mem_cke           (<connected-to-memory_mem_cke>),           //           .mem_cke
		.memory_mem_cs_n          (<connected-to-memory_mem_cs_n>),          //           .mem_cs_n
		.memory_mem_ras_n         (<connected-to-memory_mem_ras_n>),         //           .mem_ras_n
		.memory_mem_cas_n         (<connected-to-memory_mem_cas_n>),         //           .mem_cas_n
		.memory_mem_we_n          (<connected-to-memory_mem_we_n>),          //           .mem_we_n
		.memory_mem_reset_n       (<connected-to-memory_mem_reset_n>),       //           .mem_reset_n
		.memory_mem_dq            (<connected-to-memory_mem_dq>),            //           .mem_dq
		.memory_mem_dqs           (<connected-to-memory_mem_dqs>),           //           .mem_dqs
		.memory_mem_dqs_n         (<connected-to-memory_mem_dqs_n>),         //           .mem_dqs_n
		.memory_mem_odt           (<connected-to-memory_mem_odt>),           //           .mem_odt
		.memory_mem_dm            (<connected-to-memory_mem_dm>),            //           .mem_dm
		.memory_oct_rzqin         (<connected-to-memory_oct_rzqin>),         //           .oct_rzqin
		.pll_locked_export        (<connected-to-pll_locked_export>),        // pll_locked.export
		.sys_clk_clk              (<connected-to-sys_clk_clk>),              //    sys_clk.clk
		.sys_rst_reset_n          (<connected-to-sys_rst_reset_n>)           //    sys_rst.reset_n
	);

