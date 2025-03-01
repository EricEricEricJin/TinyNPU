`default_nettype none

module ram_wrapper #(
    parameter int V_WIDTH = 1408  // 176 * 8 = 1408
) (
    input wire clk, rst_n,

    // address
    input wire [31 : 0] addr,
        

    // sdram-mapped-bram

    // to ConvDP
    output logic [7 : 0]            convdp_x_addr,
    output logic [V_WIDTH - 1 : 0]  convdp_x_data,
    output logic [7 : 0]            convdp_x_we,
    
    // to DyMM
    output logic [7 : 0]            convdp_y_addr,
    input logic [V_WIDTH - 1 : 0]   convdp_y_data,
);

// memory-mapped BRAMs
// if address == mapped address then directly return FU's data



endmodule

`default_nettype wire 