	soc_system u0 (
		.avmm_sdram_wrapper_0_read_read_start   (<connected-to-avmm_sdram_wrapper_0_read_read_start>),   //  avmm_sdram_wrapper_0_read.read_start
		.avmm_sdram_wrapper_0_read_read_data    (<connected-to-avmm_sdram_wrapper_0_read_read_data>),    //                           .read_data
		.avmm_sdram_wrapper_0_read_read_valid   (<connected-to-avmm_sdram_wrapper_0_read_read_valid>),   //                           .read_valid
		.avmm_sdram_wrapper_0_rw_rw_cnt         (<connected-to-avmm_sdram_wrapper_0_rw_rw_cnt>),         //    avmm_sdram_wrapper_0_rw.rw_cnt
		.avmm_sdram_wrapper_0_rw_rw_done        (<connected-to-avmm_sdram_wrapper_0_rw_rw_done>),        //                           .rw_done
		.avmm_sdram_wrapper_0_rw_rw_addr        (<connected-to-avmm_sdram_wrapper_0_rw_rw_addr>),        //                           .rw_addr
		.avmm_sdram_wrapper_0_write_write_data  (<connected-to-avmm_sdram_wrapper_0_write_write_data>),  // avmm_sdram_wrapper_0_write.write_data
		.avmm_sdram_wrapper_0_write_write_nxt   (<connected-to-avmm_sdram_wrapper_0_write_write_nxt>),   //                           .write_nxt
		.avmm_sdram_wrapper_0_write_write_start (<connected-to-avmm_sdram_wrapper_0_write_write_start>), //                           .write_start
		.clk_clk                                (<connected-to-clk_clk>),                                //                        clk.clk
		.f2h_pio32_en_out                       (<connected-to-f2h_pio32_en_out>),                       //                  f2h_pio32.en_out
		.f2h_pio32_data_in                      (<connected-to-f2h_pio32_data_in>),                      //                           .data_in
		.h2f_pio32_en_out                       (<connected-to-h2f_pio32_en_out>),                       //                  h2f_pio32.en_out
		.h2f_pio32_data_out                     (<connected-to-h2f_pio32_data_out>),                     //                           .data_out
		.h2f_reset_reset_n                      (<connected-to-h2f_reset_reset_n>),                      //                  h2f_reset.reset_n
		.memory_mem_a                           (<connected-to-memory_mem_a>),                           //                     memory.mem_a
		.memory_mem_ba                          (<connected-to-memory_mem_ba>),                          //                           .mem_ba
		.memory_mem_ck                          (<connected-to-memory_mem_ck>),                          //                           .mem_ck
		.memory_mem_ck_n                        (<connected-to-memory_mem_ck_n>),                        //                           .mem_ck_n
		.memory_mem_cke                         (<connected-to-memory_mem_cke>),                         //                           .mem_cke
		.memory_mem_cs_n                        (<connected-to-memory_mem_cs_n>),                        //                           .mem_cs_n
		.memory_mem_ras_n                       (<connected-to-memory_mem_ras_n>),                       //                           .mem_ras_n
		.memory_mem_cas_n                       (<connected-to-memory_mem_cas_n>),                       //                           .mem_cas_n
		.memory_mem_we_n                        (<connected-to-memory_mem_we_n>),                        //                           .mem_we_n
		.memory_mem_reset_n                     (<connected-to-memory_mem_reset_n>),                     //                           .mem_reset_n
		.memory_mem_dq                          (<connected-to-memory_mem_dq>),                          //                           .mem_dq
		.memory_mem_dqs                         (<connected-to-memory_mem_dqs>),                         //                           .mem_dqs
		.memory_mem_dqs_n                       (<connected-to-memory_mem_dqs_n>),                       //                           .mem_dqs_n
		.memory_mem_odt                         (<connected-to-memory_mem_odt>),                         //                           .mem_odt
		.memory_mem_dm                          (<connected-to-memory_mem_dm>),                          //                           .mem_dm
		.memory_oct_rzqin                       (<connected-to-memory_oct_rzqin>),                       //                           .oct_rzqin
		.reset_reset_n                          (<connected-to-reset_reset_n>)                           //                      reset.reset_n
	);

