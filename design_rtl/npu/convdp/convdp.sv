`default_nettype none

module conv_dp #(
    parameter int N = 176
) (
    // W BRAM interface

    // X BRAM write interface 
    input wire [7 : 0] x_addr,
    input wire [N * 8 - 1 : 0] x_data,
    input wire x_we,

    // Y BRAM read interface
    input wire [7 : 0] y_addr,
    output logic [N * 8 - 1 : 0] y_data,
);



endmodule

`default_nettype wire 