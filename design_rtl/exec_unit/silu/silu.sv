`default_nettype none

module SiLU #(
    .N  (176)
) (
    input wire clk, 
    input wire rst_n,

    input wire [N * 8 - 1 : 0] X0_in,
    input wire [N * 8 - 1 : 0] X1_in,

    output logic [N * 8 - 1 : 0] Y_out,
    output logic out_valid
);


    
endmodule

`default_nettype wire 