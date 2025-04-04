`define xm i_sdram_bi_slave
`define wm i_sdram_ro_slave

`xm.read_file_to_mem("test_data/stmm_x.bin", 32'h3000_0000, 176*166);
`wm.read_file_to_mem("test_data/stmm_w.bin", 32'h2000_0000, 176*176+16);

`undef xm
`undef wm

