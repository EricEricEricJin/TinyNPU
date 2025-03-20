`timescale 1 ps / 1 ps
`default_nettype none

module rf_move_tb;

localparam int DATA_W = 176*8;
localparam int ADDR_W = 10;
localparam int LINE_NUM_W = 8;

logic clk, rst_n;

logic move_done;

// RAM interfaces
bram_intf i_ram_intf_ram();
bram_intf i_ram_intf_tb();
bram_intf i_ram_intf_move();
logic ram_sel;

// rf_ram_mux i_ram_mux (
//     .dut0   (i_ram_intf_tb.ram),
//     .dut1   (i_ram_intf_move.ram),
//     .ram    (i_ram_intf_ram.dut),
//     .sel    (ram_sel)
// );
bram_mux #( .NUM_PORTS (2) ) i_ram_mux (
    .sel (ram_sel),
    .i_bram_intf_in ('{i_ram_intf_tb, i_ram_intf_move}),
    .i_bram_intf_out (i_ram_intf_ram)
);


rf_move_intf i_move_intf();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_stmm       [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_layernorm  [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_silu       [4] ();
rmio_intf #( .INPUT_NUM (3), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_att        [1] ();


rf_ram #( .RF_DATA_W (176*8), .RF_ADDR_W (10) ) i_rf_ram (
    .clk            (clk),
    .ram            (i_ram_intf_ram.ram),
    .rmio_stmm      (rmio_stmm.rf),
    .rmio_layernorm (rmio_layernorm.rf),
    .rmio_silu      (rmio_silu.rf),
    .rmio_att       (rmio_att.rf)
);


rf_move #( .ADDR_W (ADDR_W), .LINE_NUM_W (LINE_NUM_W) ) i_rf_move (
    .clk        (clk),
    .rst_n      (rst_n),
    .ram        (i_ram_intf_move.dut),
    .rf_move    (i_move_intf.rf_move),
    .done       (move_done)
);

localparam DATA_LINE_NUM = 166;
localparam TEST_LINE_NUM = 150;
localparam TEST_SRC_ADDR = 0;
localparam TEST_DST_ADDR = 167;

logic [DATA_W - 1 : 0]      test_data [0 : DATA_LINE_NUM - 1];

initial begin

    for (int i = 0; i < DATA_LINE_NUM; i++) begin
        test_data[i] = {32'(i), 32'(i ** 2), { 42 {32'h12345678} } };
    end
end

initial begin
    clk = 0;
    rst_n = 0;

    ram_sel = 0;
    i_move_intf.start = 0;

    @(negedge clk) rst_n = 1;

    // write something in ram
    for (int i = 0; i < DATA_LINE_NUM; i++) begin
        i_ram_intf_tb.addr = TEST_SRC_ADDR + i;
        i_ram_intf_tb.data = test_data[i];
        i_ram_intf_tb.we = 1;
        @(negedge clk) i_ram_intf_tb.we = 0;        
    end

    ram_sel = 1;

    // Move from 0-166 to 167-333
    i_move_intf.src_addr = TEST_SRC_ADDR;
    i_move_intf.dst_addr = TEST_DST_ADDR;
    i_move_intf.line_num = TEST_LINE_NUM;

    i_move_intf.start = 1;
    @(negedge clk) i_move_intf.start = 0;

    @(posedge move_done);
    @(negedge clk);

    ram_sel = 0;

    // read data from 167-333
    for (int i = 0; i < TEST_LINE_NUM; i++) begin
        i_ram_intf_tb.addr = TEST_DST_ADDR + i;
        i_ram_intf_tb.re = 1;
        @(negedge clk);
        assert (i_ram_intf_tb.q == test_data[i]) $display("i=%h correct", i);
        else   begin $display("Error i=%h, q=%h", i, i_ram_intf_tb.q); $stop(); end
    end

    for (int i = TEST_LINE_NUM; i < DATA_LINE_NUM; i++) begin
        i_ram_intf_tb.addr = TEST_DST_ADDR + i;
        i_ram_intf_tb.re = 1;
        @(negedge clk);
        assert (i_ram_intf_tb.q == 0) $display("i=%h correct", i);
        else   begin $display("Error i=%h, q=%h", i, i_ram_intf_tb.q); $stop(); end
    end

    $stop();
end

always #1250 clk = ~clk;

endmodule

`default_nettype wire 