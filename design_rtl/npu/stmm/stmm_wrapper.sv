`default_nettype none

module stmm_wrapper #(
    parameter int N = 176,
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    input wire start_fetch_param, start_ex,

    input wire [N * 8 - 1 : 0] X_in,

    // connect to SDRAM READ     

    output wire done_fetch_param, done_ex,
    output wire [N * 8 - 1 : 0] Y_out
);
    
localparam int P = N;
localparam int DQ = 18;
localparam int Q = 8;

// << Parameter memory >>
logic [15 : 0] scale_fp16;
logic [7 : 0] z_X, z_W, zero;


logic [7 : 0] bram_addr, bram_addr_ex, bram_addr_fetch;
logic [1407 : 0] bram_data, bram_q;
logic bram_we;

assign bram_addr = bram_we ? bram_addr_fetch : bram_addr_ex;

ram_176x1408 i_wmem(
    .address    (bram_addr)
    .clock      (clk),
    .data       (bram_data),
    .wren       (bram_we),
    .q          (bram_q)
);

// Connect to StMM
StMM #(.N(N), .P(P), .DQ(DQ), .Q(Q)) i_stmm (
    .clk        (clk),
    .rst_n      (rst_n),

    .X_in       (X_in),
    .start      (start_ex),

    .scale_fp16 (scale_fp16),
    .z_X        (z_X),
    .z_W        (z_W),
    .zero       (zero),

    .W_addr     (bram_addr_ex),
    .W_data     (bram_q),

    .Y_out      (Y_out),
    .out_valid  (done_ex)
);

// << Connect to Param fetcher >>
stmm_param_fetcher #( .BRAM_W(N * 8), .BRAM_L(N), .SDRAM_W(SDRAM_W) ) i_param_fetcher (
    .clk        (clk),
    .rst_n      (rst_n),

    .start      (start_fetch_param),
    .base_addr  (),

    .out_valid  (),
    .out_idx    ()
)


// // Fetch DONE srff
// logic set_fetch_done;
// always_ff @( posedge clk, negedge rst_n ) begin
//     if (!rst_n)
//         done_fetch_param <= 0;
//     else if (set_fetch_done)
//         done_fetch_param <= 1;
//     else if (start_fetch_param)
//         done_fetch_param <= 0;
// end



endmodule

`default_nettype wire 