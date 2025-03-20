`default_nettype none

module add_tb;

logic clk, rst_n;

sdram_read_intf i_sdram_read_intf();




avmm_sdram_read_wrapper i_sdram_read_wrapper (
    .clk(clk),
    .rst_n(rst_n),

    // .readdata(readdata),
    // .readdatavalid(readdatavalid),


always #10000 clk = ~clk;

endmodule

`default_nettype wire