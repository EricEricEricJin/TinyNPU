`define xm i_sdram_bi_slave
`define wm i_sdram_ro_slave

`xm.read_file_to_mem("test_data/x_768.bin", 32'h3000_0000, 176*166);

`wm.read_file_to_mem("test_data/gamma_lo.bin", 32'h2000_0000, 176);
`wm.read_file_to_mem("test_data/gamma_hi.bin", 32'h2000_0000+176, 176);
`wm.read_file_to_mem("test_data/beta_scaled.bin", 32'h2000_0000+176*2, 176);

$display("mem[176*2:176*2+1] = %x %x", `wm.mem[176*2], `wm.mem[176*2+1]);

`undef xm
`undef wm
