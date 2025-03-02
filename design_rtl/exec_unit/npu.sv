`default_nettype none

module npu #(
    parameter int VREG_W = 1408
) (
    input wire clk, 
    input wire rst_n,

    // connect to CPU
    input wire [31 : 0] start_csr,
    output wire [31 : 0] done_csr,

    // connect to IO
    // todo

    // Connect to SDRAM  
);

// instantiate the BRAM blocks

// hang BRAM to FU with Mux


// instantiate the functional units

// control signals

// state machine: 
// 
// {out_valid, wa} pair
// SM find out_valid = 1, then write to wa

// each FU has one bit

// Done signals 
logic done_stmm0, done_layernorm0, done_dymm0;  // todo
assign done_csr = {done_stmm0, done_layernorm0, done_dymm0, ...};


logic [VREG_W - 1 : 0] vreg_rd;

// connect to all the functional units
stmm #(.N(176), .P(176), .DQ(18), .Q(8)) i_stmm0 (
    .clk        (clk),
    .rst_n      (rst_n),
    .X_in       (vreg_rd),
    .start      (),
    .scale_fp16 (),
    .z_X        (),
    .z_W        (),
    .zero       (),
    .W_addr     (),
    .W_data     (),
    .Y_out      (),
    .out_valid  (done_stmm0)
);



endmodule


`default_nettype wire 
