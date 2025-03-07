`timescale 1 ps / 1 ps
`default_nettype none

module rf_ram_tb;

logic clk, rst_n;

bram_intf #( .ADDR_W (10), .DATA_W (176*8) ) rf_ram_intf();

rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_stmm       [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_layernorm  [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_silu       [4] ();
rmio_intf #( .INPUT_NUM (3), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_att        [1] ();

rf_ram #( .RF_DATA_W (176*8), .RF_ADDR_W (10) ) i_rf_ram (
    .clk            (clk),
    .ram            (rf_ram_intf),
    .rmio_stmm      (rmio_stmm),
    .rmio_layernorm (rmio_layernorm),
    .rmio_silu      (rmio_silu),
    .rmio_att       (rmio_att)
);

initial begin
    clk = 0;

    rf_ram_intf.addr = '0;
    rf_ram_intf.data = '0;
    rf_ram_intf.we = 0;
    rf_ram_intf.re = 0;

    rst_n = 0;
    @(negedge clk) rst_n = 1;
    repeat (5) @(negedge clk);
    
    // test write something to real mem and read from it
    rf_ram_intf.addr = 10'd167;
    rf_ram_intf.data = 32'h12345678;
    rf_ram_intf.we = 1;
    @(negedge clk) rf_ram_intf.we = 0;

    repeat (5) @(negedge clk);

    rf_ram_intf.addr = 10'd168;
    rf_ram_intf.data = 32'habcd1234;
    rf_ram_intf.we = 1;
    @(negedge clk) rf_ram_intf.we = 0;
    
    rf_ram_intf.addr = 10'd167;
    rf_ram_intf.re = 1;
    @(negedge clk);
    rf_ram_intf.re = 0;

    $display("Read data: %h", rf_ram_intf.q);

    // test write in rmio ATT K
    rf_ram_intf.addr = 10'h230;
    rf_ram_intf.data = 32'h11451419;
    rf_ram_intf.we = 1;

    @(posedge clk) begin
        $display("rmio_att.input_data = %h, we = %b", rmio_att[0].input_data, rmio_att[0].input_we);
    end
    @(negedge clk) rf_ram_intf.we = 0;

    // test read from rmio StMM0 
    rmio_stmm[0].output_data = 32'h87775544;
    rf_ram_intf.addr = 10'h208;
    rf_ram_intf.re = 1;
    #10 $display("rmio_stmm[0].re = %b", rmio_stmm[0].output_re);
    @(posedge clk);
    #10 $display("output_data = %h", rf_ram_intf.q);

    @(negedge clk);

    $stop();
end

always #1250 clk = ~clk;

endmodule

`default_nettype wire 
