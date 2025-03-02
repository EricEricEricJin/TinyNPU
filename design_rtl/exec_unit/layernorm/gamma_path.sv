`default_nettype none

module gamma_path (
    input wire                  clk,
    input wire                  rst_n,

    input wire [15 : 0]         gamma_scaled,

    input wire signed [7 : 0]   xd,
    input wire [15 : 0]         sd,

    input wire                  sd_valid,
    input wire                  flop,

    input wire [8 : 0]          cs_in,

    output logic                rsqrt_done,
    output logic signed [7 : 0] y,
    output logic [8 : 0]        cs_out
);


localparam int CS_LATENCY = 3;
localparam int SD_TOTAL_LATENCY = 9;

// CS FF
logic [8 : 0] cs_ff [0 : CS_LATENCY - 1];

// All wires and FFs
logic   [15 : 0]    xd_fp_ff;
wire    [15 : 0]    xd_fp;

wire    [15 : 0]    sd_fp;
// logic   [15 : 0]    sd_fp_ff;

wire    [15 : 0]    rsqrt_sd;
logic   [15 : 0]    rsqrt_sd_ff;

wire    [15 : 0]    mult1_out;
logic   [15 : 0]    mult1_out_ff;

wire    [15 : 0]    mult2_out;
logic   [15 : 0]    mult2_out_ff;

wire signed [15 : 0] y_raw;
wire signed [7 : 0] y_sat;

////////////////////////////////
// Compute rsqrt(sd) 
////////////////////////////////
uint16_to_fp16 i_sd_int_to_fp (
    .clk    (clk),
    .areset (~rst_n),
    .a      (sd),
    .q      (sd_fp)
);

rsqrt i_rsqrt(
    .clk    (clk),
    .areset (~rst_n),
    .a      (sd_fp),
    .q      (rsqrt_sd)
);


////////////////////////////////
// Flop rsqrt(SD) after ready
////////////////////////////////
wire flop_sd;
count_down #(.N(SD_TOTAL_LATENCY)) i_count_down (
    .clk    (clk),
    .rst_n  (rst_n),
    .start  (sd_valid),
    .done   (flop_sd)
);

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        rsqrt_sd_ff <= '0;
        rsqrt_done <= 0;
    end
    else if (sd_valid) begin
        rsqrt_done <= 0;
    end
    else if (flop_sd) begin
        rsqrt_sd_ff <= rsqrt_sd;
        rsqrt_done <= 1;
    end
end

////////////////////////////////
// mult1 = gamma[i] * rsqrt_sd
////////////////////////////////
mult_fp16 i_mult1 (
    .clk    (clk),
    .areset (~rst_n),
    .a      (gamma_scaled),
    .b      (rsqrt_sd_ff),
    .q      (mult1_out)
);

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        mult1_out_ff <= '0;
    else if (flop)
        mult1_out_ff <= mult1_out;
end

////////////////////////////////
// xd_fp = i2fp(xd)
////////////////////////////////
int16_to_fp16 i_xd_int_to_fp (
    .clk    (clk),
    .areset (~rst_n),
    .a      ({{8{xd[7]}}, xd}),
    .q      (xd_fp)
);

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        xd_fp_ff <= '0;
    else if (flop)
        xd_fp_ff <= xd_fp;
end

////////////////////////////////
// mul2 = mul1 * xd_fp
////////////////////////////////
mult_fp16 i_mult2 (
    .clk    (clk),
    .areset (~rst_n),
    .a      (xd_fp_ff),
    .b      (mult1_out_ff),
    .q      (mult2_out)  
);

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        mult2_out_ff <= '0;
    else if (flop)
        mult2_out_ff <= mult2_out;
end

////////////////////////////////
// y = sat(f2i(mul2))
////////////////////////////////
fp16_to_int16 i_y_fp_to_int (
    .clk    (clk),
    .areset  (~rst_n),
    .a      (mult2_out_ff),
    .q      (y_raw)
);
saturate #(.IN_W(16), .OUT_W(8)) i_sat_y1 ( .in (y_raw), .out(y_sat) );


////////////////////////////////
// Flop y <- y_sat
////////////////////////////////
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)    
        y <= '0;
    else if (flop)
        y <= y_sat;
end

////////////////////////////////
// Flop the control signals
////////////////////////////////

// Note: store_y signal must be deasserted for other cycles
// so set cs_out to 0 in else
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < CS_LATENCY; i++)
            cs_ff[i] <= '0;
        cs_out <= '0;
    end
    else if (flop) begin
        cs_ff[0] <= cs_in;
        for (int i = 1; i < CS_LATENCY; i++)
            cs_ff[i] <= cs_ff[i - 1];
        cs_out <= cs_ff[CS_LATENCY - 1];
    end
    else begin
        cs_out <= '0;
    end
end

endmodule

`default_nettype wire 