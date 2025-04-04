`default_nettype none

module rf_wrapper #(
    parameter int ADDR_W = 10,
    parameter int DATA_W = 176*8
) (
    input wire clk, 
    input wire rst_n,
    
    // Connect to Avalon SDRAM
    sdram_intf sdram,

    // Connect to control unit
    rf_move_intf i_rf_move_intf,
    rf_ldst_intf i_rf_ldst_intf,
    input wire   ram_sel,

    // Connect to RF Ram RMIO
    rmio_intf   rmio_stmm,
    rmio_intf   rmio_layernorm,
    rmio_intf   rmio_silu       [0 : 3],
    rmio_intf   rmio_att        [0 : 0],

    // Done signals
    output logic move_done,
    output logic ldst_done
);

////////////////////////
// Parameters
////////////////////////
localparam RF_ADDR_W = 10;
localparam RF_DATA_W = 176*8;
localparam SDRAM_DATA_W = 128;
localparam LINE_NUM_W = 11;


localparam MOVE_RAM_IF_IDX = 0;
localparam LDST_RAM_IF_IDX = 1;

bram_intf #(.ADDR_W(ADDR_W), .DATA_W(DATA_W)) i_rf_ram_intf_ram ();
bram_intf #(.ADDR_W(ADDR_W), .DATA_W(DATA_W)) i_rf_ram_intf_arr [2] ();
// bram_intf #(.ADDR_W(ADDR_W), .DATA_W(DATA_W)) i_rf_ram_intf_ldst ();
// bram_intf #(.ADDR_W(ADDR_W), .DATA_W(DATA_W)) i_rf_ram_intf_move ();

////////////////////////
// RF Ram Mux
////////////////////////
// always_comb begin
//     i_rf_ram_intf_move.q = i_rf_ram_intf_ram.q;
//     i_rf_ram_intf_ldst.q = i_rf_ram_intf_ram.q;

//     if (ram_sel) begin
//         i_rf_ram_intf_ram.addr = i_rf_ram_intf_ldst.addr;
//         i_rf_ram_intf_ram.data = i_rf_ram_intf_ldst.data;
//         i_rf_ram_intf_ram.we = i_rf_ram_intf_ldst.we;
//         i_rf_ram_intf_ram.re = i_rf_ram_intf_ldst.re;
//     end
//     else begin
//         i_rf_ram_intf_ram.addr = i_rf_ram_intf_move.addr;
//         i_rf_ram_intf_ram.data = i_rf_ram_intf_move.data;
//         i_rf_ram_intf_ram.we = i_rf_ram_intf_move.we;
//         i_rf_ram_intf_ram.re = i_rf_ram_intf_move.re;
//     end
// end

bram_mux #(
    .NUM_PORTS (2),
    .ADDR_W    (RF_ADDR_W),
    .DATA_W    (RF_DATA_W)
) i_rf_ram_mux (
    .sel (ram_sel),
    .i_bram_intf_in (i_rf_ram_intf_arr),
    .i_bram_intf_out (i_rf_ram_intf_ram.dut)
);

////////////////////////
// RF Ram
////////////////////////
rf_ram #( .RF_DATA_W(RF_DATA_W), .RF_ADDR_W(RF_ADDR_W) ) i_rf_ram (
    .clk            (clk),
    .rst_n          (rst_n),

    .ram            (i_rf_ram_intf_ram.ram),
    
    .rmio_stmm      (rmio_stmm),
    .rmio_layernorm (rmio_layernorm),
    .rmio_silu      (rmio_silu),
    .rmio_att       (rmio_att)
);


////////////////////////
// RF Load and Store
////////////////////////
rf_ldst #(
    .RF_ADDR_W      (RF_ADDR_W),
    .LINE_NUM_W     (LINE_NUM_W),
    .SDRAM_DATA_W   (SDRAM_DATA_W),
    .RF_DATA_W      (RF_DATA_W)
) i_rf_ldst (
    .clk        (clk),
    .rst_n      (rst_n),

    .rf_ldst    (i_rf_ldst_intf.rf_ldst),

    .sdram      (sdram.ldst),
    // .rf_ram     (i_rf_ram_intf_ldst.dut),
    .rf_ram     (i_rf_ram_intf_arr[LDST_RAM_IF_IDX].dut),
    .done       (ldst_done)
);


////////////////////////
// RF Move
////////////////////////
rf_move #( .ADDR_W (RF_ADDR_W), .LINE_NUM_W (LINE_NUM_W) ) i_rf_move (
    .clk        (clk),
    .rst_n      (rst_n),

    // .ram        (i_rf_ram_intf_move.dut),
    .ram        (i_rf_ram_intf_arr[MOVE_RAM_IF_IDX].dut),
    .rf_move    (i_rf_move_intf.rf_move),

    .done       (move_done)
);


endmodule

`default_nettype wire
