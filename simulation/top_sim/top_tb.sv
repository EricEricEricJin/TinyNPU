`timescale 1ps / 1ps
`default_nettype none

module top_tb;

logic clk, rst_n;

logic [31 : 0] h2f_pio32;
logic          h2f_write;
logic [31 : 0] f2h_pio32;
logic          f2h_write;

sdram_intf i_sdram_intf ();

// DUT
design_top i_design_top (
    .clk            (clk),
    
    .rst_n          (rst_n),
    .i_sdram_intf   (i_sdram_intf.ldst),
    
    .h2f_pio32      (h2f_pio32),
    .h2f_write      (h2f_write),
    
    .f2h_pio32      (f2h_pio32),
    .f2h_write      (f2h_write)
);

// SDRAM BFM
sdram_slave_bfm #(
    .SDRAM_W      (128),
    .RD_MEM_FILE  ("simulation/top_sim/rd_mem.bin"),
    .RD_MEM_SIZE  (1024 * 1024),
    .RD_MEM_OFFSET(512 * 1024 * 1024),
    .WT_MEM_FILE  ("simulation/top_sim/wt_mem.bin"),
    .WT_MEM_SIZE  (1024 * 1024),
    .WT_MEM_OFFSET(512 * 1024 * 1024)
) i_sdram_slave_bfm (
    .clk  (clk),
    .rst_n(rst_n),
    .sdram(i_sdram_intf.avmm_slave)
);

initial begin

    i_sdram_slave_bfm.read_file_to_mem();

    clk = 0;
    rst_n = 0;
    h2f_pio32 = 0;
    h2f_write = 0;

    @(negedge clk) rst_n = 1;

    // - load from sdram to line 0
    h2f_pio32 = {2'b00, 9'h0, 13'h0, 8'd166};

    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    @(posedge f2h_pio32[30]) $display("Load Done");
    
    @(negedge clk);

    // - move from line 0 to line 167
    h2f_pio32 = {2'b10, 10'h0, 10'd167, 2'b00, 8'd166};
    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    @(posedge f2h_pio32[31]) $display("MOVE Done");
    @(negedge clk);

    // - store to sdram
    h2f_pio32 = {2'b01, 9'd167, 13'h1000, 8'd166};
    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    @(posedge f2h_pio32[30]) $display("Store Done");
    @(negedge clk);

    i_sdram_slave_bfm.write_mem_to_file();

    $stop();

end

always #1250 clk = ~clk;

endmodule

`default_nettype wire
