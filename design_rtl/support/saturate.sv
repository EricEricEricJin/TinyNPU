////////////////////////
// Saturate
///////////////////////

`default_nettype none

module saturate #(
    parameter IN_W = 16,
    parameter OUT_W = 8
) (
    input wire signed  [IN_W - 1 : 0] in, 
    output wire signed [OUT_W - 1 : 0] out
);

assign out = in[IN_W - 1]  && !(&in[IN_W - 2 : OUT_W - 1]) ? {1'b1, {(OUT_W - 1){1'b0}}} : 
           (!in[IN_W - 1]) &&  (|in[IN_W - 2 : OUT_W - 1]) ? {1'b0, {(OUT_W - 1){1'b1}}} : in[OUT_W - 1 : 0];

endmodule

`default_nettype wire 