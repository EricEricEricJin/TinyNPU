// fetch col. of W^T
// when receive 4*4 block of X, times to block of W col, output
// accept next 4*4 block
// 4+4+4=12 cycles for each block, 3e5 blocks, about 3e6 cycles

// todo: Flip Xin!!

module StMM #(
    parameter int N = 176,
    parameter int P = 704,
    parameter int DQ = 18,
    parameter int Q = 8
) (
    input wire clk, rst_n,
    
    // input
    input wire [Q * N - 1 : 0] X_in,
    input wire start,

    // zero and scale 
    input wire [15 : 0] scale_fp16,
    input wire signed [7 : 0]  z_X, z_W,
    input wire signed [7 : 0]  zero,   // z_Y
    
    // W fetch
    output wire [$clog2(P) - 1 : 0] W_addr,
    input wire [Q * N - 1 : 0] W_data,


    // output
    output wire [Q * P - 1 : 0] Y_out,
    output logic out_valid
);


// out valid srff
wire set_out_valid;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        out_valid <= 0;
    else if (start)
        out_valid <= 0;
    else if (set_out_valid)
        out_valid <= 1;
end

// VVM instance
logic X_ld, W_ld, vvm_start;
wire signed [DQ - 1 : 0] vvm_out;
wire vvm_rdy;

vvm #(.L(N), .W(2), .Q(Q), .DQ(DQ)) i_vvm (
    .clk    (clk), 
    .rst_n  (rst_n), 
    .A_in   (X_in), 
    .B_in   (W_data), 
    .z_A    (z_X),
    .z_B    (z_W),
    .A_ld   (X_ld), 
    .B_ld   (W_ld),
    .start  (vvm_start), 
    .C_out  (vvm_out), 
    .rdy    (vvm_rdy) 
);

logic signed [DQ - 1 : 0] vvm_out_ff;

// W fetch address
logic [$clog2(P) : 0] W_cnt;
assign W_addr = W_cnt[$clog2(P) - 1 : 0];

logic W_addr_acc, W_addr_clr;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        W_cnt <= 0;
    else if (W_addr_clr)
        W_cnt <= 0;
    else if (W_addr_acc)
        W_cnt <= W_cnt + 1;
end

// flop Y_store and set_out_valid for some cycles 
logic Y_store_nf;
logic set_out_valid_nf;

// int18->fp16 conversion
wire [15 : 0] vvm_out_fp16, scale_out_fp16;
wire signed [15 : 0]    scale_out_fix;
wire signed [16 : 0]    vvm_out_nonsat;  // add zero 
wire signed [7 : 0]    vvm_out_final;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        vvm_out_ff <= '0;
    else if (Y_store_nf)
        vvm_out_ff <= vvm_out;
end

// to scale conversion
// INT18 -> FP16
int18_to_fp16 i_int2fp ( 
    .clk        (clk), 
    .areset     (~rst_n),
    .a          (vvm_out_ff),
    .q          (vvm_out_fp16)
);

// FP multiplication
// FP16 * FP16
mult_fp16 i_mult (
    .clk        (clk), 
    .areset     (~rst_n),
    .a          (vvm_out_fp16),
    .b          (scale_fp16),
    .q          (scale_out_fp16)
);

// output conversion
// FP16 -> FIX8|8
fp16_to_int16 i_fp2int (
    .clk        (clk),
    .areset     (~rst_n),
    .a          (scale_out_fp16),
    .q          (scale_out_fix)
);

// add Y zero
assign vvm_out_nonsat = $signed(scale_out_fix) + zero;

// saturate
saturate #(.IN_W(17), .OUT_W(8)) i_sat (.in (vvm_out_nonsat), .out(vvm_out_final)); 

// output reg
wire Y_store;
wire [$clog2(P) - 1 : 0] Y_idx;
wire [$clog2(P) - 1 : 0] Y_idx_nf;
// assign Y_idx = W_addr - 1;
assign Y_idx_nf = W_addr - 1;

logic signed [Q - 1 : 0] Y_unpacked [0 : P - 1];
always_ff @( posedge clk ) begin
    if (Y_store)
        Y_unpacked[Y_idx] = vvm_out_final;
end

// assign Y_out
genvar i;
generate
    for (i = 0; i < P; i++) begin: blk_pack_Y
        assign Y_out[Q * i +: Q] = Y_unpacked[i];
    end
endgenerate


localparam int FP_LATENCY = 6;
logic [$clog2(P) + 2 - 1 : 0] store_valid_cmd_fifo[0 : FP_LATENCY - 1];
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < FP_LATENCY; i++) begin
            store_valid_cmd_fifo[i] <= '0;
        end
    end
    else begin
        store_valid_cmd_fifo[0] <= {Y_store_nf, set_out_valid_nf, Y_idx_nf};
        for (int i = 1; i < FP_LATENCY; i++) begin
            store_valid_cmd_fifo[i] <= store_valid_cmd_fifo[i - 1];
        end
    end
end

assign {Y_store, set_out_valid, Y_idx} = store_valid_cmd_fifo[FP_LATENCY - 1];


// state machine
typedef enum logic  { IDLE, CALC } state_t;
state_t state, nxt_state;

always_ff @( posedge clk, negedge rst_n ) begin 
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end

/* 
Assume VVM takes more cycles than BRAM return! 
Assume VVM takes more cycles than FP ops!
*/

always_comb begin 

    X_ld = 0;
    W_ld = 0;
    vvm_start = 0;

    W_addr_acc = 0;
    W_addr_clr = 0;

    Y_store_nf = 0;
    set_out_valid_nf = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            if (start) begin
                X_ld = 1;
                W_ld = 1;
                vvm_start = 1;      // OK! see vvm impl.
                W_addr_acc = 1;     // add in advance!
                nxt_state = CALC;
            end
        end 
        default: begin  // CALC
            if (vvm_rdy) begin
                Y_store_nf = 1;
                if (W_cnt == P) begin  // end
                    W_addr_clr = 1;
                    set_out_valid_nf = 1;
                    nxt_state = IDLE;
                end
                else begin
                    W_ld = 1;  
                    W_addr_acc = 1;
                    vvm_start = 1;
                end
            end
        end 
    endcase
end
    
endmodule