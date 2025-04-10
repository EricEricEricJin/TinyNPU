`timescale 1ps / 1ps
`default_nettype none

module design_top (
    input wire clk,
    input wire rst_n,

    sdram_intf      i_sdram_intf,
    sdram_read_intf i_sdram_read_intf,

    // connect to MMIO
    input  wire  [31 : 0] h2f_pio32,
    input  wire           h2f_write,
    output logic [31 : 0] f2h_pio32,
    output logic          f2h_write,

    output logic [7 : 0] LED
);

assign LED = '0;

localparam int RF_ADDR_W = 10;
localparam int RF_DATA_W = 176*8;
localparam int SDRAM_DATA_W = 128;
localparam int LINE_NUM_W = 11;

////////////////////////
// Signals
////////////////////////
logic fetch_done;
logic [27:0] exec_done;

logic move_done, ldst_done, cu_done;
// todo: add eu signals
assign f2h_pio32 = {move_done, ldst_done, cu_done, fetch_done, exec_done};

////////////////////////
// Interfaces 
////////////////////////
rf_move_intf i_rf_move_intf ();
rf_ldst_intf i_rf_ldst_intf ();

rmio_intf #( .INPUT_NUM (4), .OUTPUT_NUM (4), .DATA_W (176*8) ) rmio_stmm();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_layernorm();
rmio_intf #( .INPUT_NUM (2), .OUTPUT_NUM (2), .DATA_W (176*8) ) rmio_lut();

// eu_ctrl_intf i_eu_ctrl_intf_arr [32] ();

////////////////////////
// Control unit signals
////////////////////////
logic [31 : 0] eu_fetch, eu_exec;
logic [31 : 0] eu_fetch_addr;
logic rf_ram_sel;
logic [4:0] sdram_read_sel;

////////////////////////
// Control Unit
////////////////////////
ctrl_unit #(.RF_ADDR_W (RF_ADDR_W) ) i_ctrl_unit (
    .clk            (clk),
    .rst_n          (rst_n),

    .h2f_io         (h2f_pio32),
    .h2f_write      (h2f_write),

    .rf_move        (i_rf_move_intf.ctrl_unit),
    .rf_ldst        (i_rf_ldst_intf.ctrl_unit),
    .rf_ram_sel     (rf_ram_sel),

    .sdram_read_sel (sdram_read_sel),

    // .i_eu_ctrl_intf (i_eu_ctrl_intf_arr), 
    .eu_fetch       (eu_fetch),
    .eu_exec        (eu_exec),
    .eu_fetch_addr  (eu_fetch_addr),

    .done           (cu_done)
);

////////////////////////
// RF Wrapper
////////////////////////
rf_wrapper #( .ADDR_W(RF_ADDR_W), .DATA_W(RF_DATA_W) ) i_rf_wrapper (
    .clk            (clk),
    .rst_n          (rst_n),

    .sdram          (i_sdram_intf.ldst),
    .i_rf_move_intf (i_rf_move_intf.rf_move),
    .i_rf_ldst_intf (i_rf_ldst_intf.rf_ldst),
    .ram_sel        (rf_ram_sel),

    .rmio_stmm      (rmio_stmm),
    .rmio_layernorm (rmio_layernorm),
    .rmio_lut       (rmio_lut),

    .move_done      (move_done),
    .ldst_done      (ldst_done)
);


////////////////////////
// Execution Units
////////////////////////

eu_top i_eu_top (
    .clk(clk),
    .rst_n(rst_n),

    .i_sdram_read_intf(i_sdram_read_intf),

    .rmio_stmm(rmio_stmm),
    .rmio_layernorm(rmio_layernorm),
    .rmio_lut(rmio_lut),

    .sdram_read_sel(sdram_read_sel),

    .eu_fetch(eu_fetch),
    .eu_exec(eu_exec),
    .eu_fetch_addr(eu_fetch_addr),

    .fetch_done(fetch_done),
    .exec_done(exec_done)
);

endmodule

`default_nettype wire
