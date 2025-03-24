// import pkg_rf_ldst_intf::*;

module cu_sim_tb;

localparam int RF_ADDR_W = 10;

logic clk;
logic rst_n;

logic [31 : 0] h2f_io;
logic h2f_write;
logic done;

// logic                       move_start;
// logic [RF_ADDR_W - 1 : 0]   move_src_addr;
// logic [RF_ADDR_W - 1 : 0]   move_dst_addr;
// logic [7 : 0]               move_line_num;
rf_move_intf #( .RF_ADDR_W(RF_ADDR_W), .LINE_NUM_W(8) ) i_rf_move_intf();
rf_ldst_intf #( .RF_ADDR_W(RF_ADDR_W), .LINE_NUM_W(8) ) i_rf_ldst_intf();

// logic [31 : 0]              ldst_sdram_addr;
// logic [RF_ADDR_W - 1 : 0]   ldst_rf_addr;
// logic [7 : 0]               ldst_line_num;
// logic                       load_start;
// logic                       store_start;

logic [31 : 0] eu_fetch;
logic [31 : 0] eu_exec;
logic [31 : 0] eu_fetch_addr;

ctrl_unit #( .RF_ADDR_W (10) ) i_ctrl_unit (
    .clk            (clk),
    .rst_n          (rst_n),

    .h2f_io         (h2f_io),
    .h2f_write      (h2f_write),

    // .isrunning      (isrunning),

    // .move_start       (move_start),
    // .move_src_addr    (move_src_addr),
    // .move_dst_addr    (move_dst_addr),
    // .move_line_num    (move_line_num),
    .rf_move          (i_rf_move_intf.rf_move),

    // .ldst_sdram_addr(ldst_sdram_addr),
    // .ldst_rf_addr   (ldst_rf_addr),
    // .ldst_line_num  (ldst_line_num),
    // .load_start     (load_start),
    // .store_start    (store_start),
    .rf_ldst           (i_rf_ldst_intf.rf_ldst),

    .eu_fetch       (eu_fetch),
    .eu_exec        (eu_exec),
    .eu_fetch_addr  (eu_fetch_addr),
    .done           (done)
);

initial begin
    clk = 0;
    rst_n = 0;
    h2f_io = '0;
    h2f_write = 0;

    @(negedge clk)
    rst_n = 1;

    // $display("test param = %d", i_rf_move_intf.TEST_PARAM);

    // Load 
    repeat (10) @(negedge clk);
    h2f_io = {2'b00, 9'd000, 13'h1234, 8'd166};
    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    // Store
    repeat (10) @(negedge clk);
    h2f_io = {2'b01, 9'd167, 13'h1abc, 8'd166};
    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    // Move
    repeat (10) @(negedge clk);
    h2f_io = {2'b10, 10'd167, 10'h200, 2'b01, 8'd166};
    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    // Fetch
    repeat (10) @(negedge clk);
    h2f_io = {2'b11, 1'b0, 5'd17, 24'h345678};   
    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    // Exec
    repeat (10) @(negedge clk);
    h2f_io = {2'b11, 1'b1, 5'd17, 24'hx};
    h2f_write = 1;
    @(negedge clk) h2f_write = 0;

    repeat (10) @(negedge clk);
    $stop();

end

always #5 clk = ~clk;

endmodule
