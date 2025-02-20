module cpu_sim_tb;

logic clk, rst_n;

logic [13 : 0] inst_addr;
logic 

ram_32x256 i_inst_mem (
    .address    (inst_addr[9 : 2])
    .clock      (clk),
    .data       (data_d),
    .wren       (1'b0),
    .q          (inst_data)
);

ram_32x256 i_data_mem (
	.address    (data_addr[9 : 2]),
	.clock      (clk),
	.data       (data_d),
	.wren       (data_we),
    .q          (data_q)
);



endmodule