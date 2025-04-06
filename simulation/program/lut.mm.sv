`define xm i_sdram_bi_slave
`define wm i_sdram_ro_slave

`xm.read_file_to_mem("test_data/x_789.bin", 32'h3000_0000, 176);
`wm.read_file_to_mem("test_data/lut_silu_0.bin", 32'h2000_0000, 256);

`undef xm
`undef wm
