`default_nettype none 

module vvm #(
    parameter int L = 176,    // total length
    parameter int W = 4,       // window size
    parameter int Q = 8,    // input quant
    parameter int DQ = 18  // calc. width
) (
    input wire clk, rst_n,
    
    input wire [L * Q - 1 : 0] A_in,
    input wire [L * Q - 1 : 0] B_in,
    
    input wire signed [Q - 1 : 0]  z_A,
    input wire signed [Q - 1 : 0]  z_B,
    
    input wire A_ld, B_ld,

    input wire start,

    output logic signed [DQ - 1 : 0] C_out,
    output logic rdy
);

localparam int WL = L / W;

// typedef logic signed [Q - 1 : 0] window_t [0 : W - 1];

// flop A, B
logic [W * Q - 1 : 0] A [0 : WL - 1];
logic [W * Q - 1 : 0] B [0 : WL - 1];
always_ff @( posedge clk ) begin 
    if (A_ld)
        for (int i = 0; i < WL; i++)
            A[i] <= A_in[W * Q * i +: W * Q];
    if (B_ld)
        for (int i = 0; i < WL; i++)
            B[i] <= B_in[W * Q * i +: W * Q];     
end

// counter
logic [$clog2(L / W) - 1 : 0] cnt;
logic cnt_ld, cnt_ctd;
always_ff @( posedge clk, negedge rst_n ) begin 
    if (!rst_n)
        cnt <= L / W - 1;
    else if (cnt_ld)
        cnt <= L / W - 1;
    else if (cnt_ctd)
        cnt <= cnt - 1;
end

// multiplier
wire signed [8 : 0] mul1 [0 : W - 1];
wire signed [8 : 0] mul2 [0 : W - 1];
logic signed [DQ - 1 : 0] mulout;

genvar i;
generate
    for (i = 0; i < W; i++) begin: blk_assign_mults
        assign mul1[i] = $signed(A[cnt][Q * i +: Q])-z_A;
        assign mul2[i] = $signed(B[cnt][Q * i +: Q])-z_B;
    end
endgenerate

always_comb begin 
    mulout = '0;
    for (int i = 0; i < W; i++)
        mulout += mul1[i] * mul2[i];
        // mulout += (mul1[i] - z_A) * (mul2[i] - z_B);
end

// output accumulator
logic acc_clr, acc_en;
always_ff @( posedge clk, negedge rst_n ) begin 
    if (!rst_n)
        C_out <= '0;
    else if (acc_clr)
        C_out <= '0;
    else if (acc_en)
        C_out <= C_out + mulout;
end

// SM
typedef enum logic[1:0] { IDLE, CNTD } state_t;
state_t state, nxt_state;

always_ff @( posedge clk, negedge rst_n ) begin 
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin 
    cnt_ld = 0;
    cnt_ctd = 0;

    acc_en = 0;
    acc_clr = 0;

    rdy = 1;

    nxt_state = state;
    
    case (state)
        IDLE: begin
            if (start) begin
                cnt_ld = 1;
                acc_clr = 1;
                nxt_state = CNTD;
            end
        end
        default: begin
            cnt_ctd = 1;
            acc_en = 1;
            rdy = 0;
            if (cnt == 0) begin
                cnt_ctd = 0;
                nxt_state = IDLE;
            end
        end 
    endcase
end

endmodule


`default_nettype wire 