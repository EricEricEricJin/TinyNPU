module rf_move_tb;

localparam int DATA_W = 176*8;
localparam int ADDR_W = 10;
localparam int LINE_NUM_W = 8;

bram_intf i_bram_intf();


ram_512x1408 i_ram (

);

endmodule

// todo: try to implement port sel inside interface 