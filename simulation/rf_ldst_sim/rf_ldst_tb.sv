`timescale 1ps / 1ps
`default_nettype none

module rf_ldst_tb;

logic clk, rst_n;
wire done;

rf_ldst_intf    #( .RF_ADDR_W(10), .LINE_NUM_W (8) )        i_rf_ldst_intf();
bram_intf       #( .ADDR_W(10), .DATA_W(176*8) )            i_rf_ram_intf();
sdram_intf      #( .SDRAM_DATA_W(128), .SDRAM_ADDR_W(32) )  i_sdram_intf();

rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_stmm       [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_layernorm  [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_silu       [4] ();
rmio_intf #( .INPUT_NUM (3), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_att        [1] ();


rf_ldst #(
    .RF_ADDR_W      (10),
    .LINE_NUM_W     (11),
    .SDRAM_DATA_W   (128),
    .RF_DATA_W      (176*8)
) i_rf_ldst (
    .clk        (clk),
    .rst_n      (rst_n),
    .rf_ldst    (i_rf_ldst_intf.rf_ldst),
    .sdram      (i_sdram_intf.ldst),
    .rf_ram     (i_rf_ram_intf.dut),
    .done       (done)
);

rf_ram #( .RF_ADDR_W(10), .RF_DATA_W(176*8) ) i_rf_ram(
    .clk    (clk),
    .ram    (i_rf_ram_intf.ram),

    .rmio_stmm      (rmio_stmm.rf),    
    .rmio_layernorm (rmio_layernorm.rf),
    .rmio_silu      (rmio_silu.rf),
    .rmio_att       (rmio_att.rf)
);

sdram_slave_bfm #(
    .SDRAM_W        (128),
    .RD_MEM_FILE    ("simulation/sdram_bfm/rd_mem.bin"),
    .RD_MEM_SIZE    (1024*1024),
    .RD_MEM_OFFSET  (512*1024*1024),
    .WT_MEM_FILE    ("simulation/rf_ldst_sim/wt_mem.bin"),
    .WT_MEM_SIZE    (1024*1024),
    .WT_MEM_OFFSET  (512*1024*1024)
) i_sdram_slave_bfm (
    .clk    (clk),
    .rst_n  (rst_n),
    .sdram  (i_sdram_intf.avmm_slave)
);


initial begin

    i_sdram_slave_bfm.read_file_to_mem();

    clk = 0;
    rst_n = 0;

    i_rf_ldst_intf.load_start = 0;
    i_rf_ldst_intf.store_start = 0;

    @(negedge clk) rst_n = 1;

    i_rf_ldst_intf.rf_addr = 0;
    i_rf_ldst_intf.sdram_addr = 32'h20_000_000;
    i_rf_ldst_intf.line_num = 8;
    
    @(negedge clk) i_rf_ldst_intf.load_start = 1;
    @(negedge clk) i_rf_ldst_intf.load_start = 0;

    @(posedge done);
    $display("Load done");

    i_rf_ldst_intf.rf_addr = 0;
    i_rf_ldst_intf.sdram_addr = 32'h20_010_000;
    i_rf_ldst_intf.line_num = 8;

    @(negedge clk) i_rf_ldst_intf.store_start = 1;
    @(negedge clk) i_rf_ldst_intf.store_start = 0;

    @(posedge done);
    $display("Store done");

    i_sdram_slave_bfm.write_mem_to_file();

    $stop;
end

always #1250 clk = ~clk;

endmodule

`default_nettype wire 

