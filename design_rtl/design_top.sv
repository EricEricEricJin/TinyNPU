`timescale 1ps / 1ps
`default_nettype none

module design_top (
    input wire clk,
    input wire rst_n,

    sdram_intf i_sdram_intf,
    sdram_read_intf i_sdram_read_intf,

    // connect to MMIO
    input  wire  [31 : 0] h2f_pio32,
    input  wire           h2f_write,
    output logic [31 : 0] f2h_pio32,
    output logic          f2h_write,

    output logic [7 : 0] LED
);

localparam int RF_ADDR_W = 10;
localparam int RF_DATA_W = 176*8;
localparam int SDRAM_DATA_W = 128;
localparam int LINE_NUM_W = 11;

////////////////////////
// Signals
////////////////////////
logic move_done, ldst_done, cu_running;
// todo: add eu signals
assign f2h_pio32 = {move_done, ldst_done, cu_running, 29'b0};

rf_move_intf i_rf_move_intf ();
rf_ldst_intf i_rf_ldst_intf ();

// assign f2h_pio32 = i_rf_ldst_intf.sdram_addr;

logic [31:0] eu_fetch_addr;
logic [31:0] eu_fetch;
logic [31:0] eu_exec;

rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_stmm       [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_layernorm  [4] ();
rmio_intf #( .INPUT_NUM (1), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_silu       [4] ();
rmio_intf #( .INPUT_NUM (3), .OUTPUT_NUM (1), .DATA_W (176*8) ) rmio_att        [1] ();

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

    .isrunning      (cu_running),

    .rf_move        (i_rf_move_intf.ctrl_unit),
    .rf_ldst        (i_rf_ldst_intf.ctrl_unit),
    .rf_ram_sel     (rf_ram_sel),

    .sdram_read_sel (sdram_read_sel),

    .eu_fetch       (eu_fetch),
    .eu_exec        (eu_exec),
    .eu_fetch_addr  (eu_fetch_addr)
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
    .rmio_silu      (rmio_silu),
    .rmio_att       (rmio_att),

    .move_done      (move_done),
    .ldst_done      (ldst_done)
);


// ------------------------------------------------

sdram_read_intf #(.SDRAM_DATA_W(SDRAM_DATA_W)) i_sdram_read_intf_arr [31 : 0] ();

////////////////////////
// SDRAM Read Mux
////////////////////////

sdram_read_mux #( .NUM_PORTS (32) ) i_sdram_read_mux (
    .sel (sdram_read_sel),
    .i_sdram_read_intf_in (i_sdram_read_intf_arr),
    .i_sdram_read_intf_out (i_sdram_read_intf)
);

////////////////////////
// Execution Units
////////////////////////

// todo

endmodule

`default_nettype wire
