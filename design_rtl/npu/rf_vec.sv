`default_nettype none

module rf_vec #(
    parameter int WIDTH = 1408,  // 176 * 8 = 1408
    parameter int DEPTH = 32
) (
    input wire clk, rst_n,

    input wire [4 : 0] ra, wa,
    input wire we,

    input wire [WIDTH - 1 : 0] wd,
    output logic [WIDTH - 1 : 0] rd
);

// use bram


endmodule

`default_nettype wire 