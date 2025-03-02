

`default_nettype none

module attention #(
    parameter int M = 166,
    parameter int N = 44
)(
    input wire clk,
    input wire rst_n,

    input wire load_input,
    input wire [$clog2(M) - 1 : 0] input_idx,
    input wire start,



    // to wrapper
    input wire [N * 8 - 1 : 0] bias_u, bias_v,

    // parameters
    input wire [15 : 0] sqrt_d_fp16,


    // Q is one line input
    input wire [N * 8 - 1 : 0] Q_in,

    // K, V are matrix BRAM interface
    input wire [N * 8 - 1 : 0] K_ram_data, 
    output logic [$clog2(M) - 1 : 0] K_ram_addr, 

    input wire [N * 8 - 1 : 0] V_ram_data, 
    output logic [$clog2(M) - 1 : 0] V_ram_addr, 

    // Output is one line of one head!
    // output logic [N * 8 - 1 : 0] QKV_out
    output logic out_valid,
    output logic [$clog2(M) - 1 : 0] out_idx,
    output logic [8 * N - 1 : 0]    out_data
);


// Q, K, V, P buffer
ram_MxN i_ram_Q (

);

ram_MxN i_ram_K (
    .address
    .clock
    .data
    .we
    .q
);

ram_MxN i_ram_V (

);

ram_MxN i_ram_P (

);

// todo
// 



logic addr_j_clr, addr_j_inc;
logic qkv_i_clr, qkv_i_acc;
logic cnt_i_clr, cnt_i_inc;
logic store_cell;
logic set_out_valid;

// << Valid SRFF >>
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        out_valid <= 0;
    else if (start)
        out_valid <= 0;
    else if (set_out_valid)
        out_valid <= 1;
end

// << Unpack K, Q, V input, Pack QKV Output >>
logic signed [7 : 0] Q_unpacked [0 : N - 1];
logic signed [7 : 0] K_unpacked [0 : N - 1];
logic signed [7 : 0] V_unpacked [0 : N - 1];
logic signed [7 : 0] qkv_unpacked [0 : N - 1];

genvar i;
generate
    for (i = 0; i < N; i++) begin: blk_pack_unpack
        assign QKV_out[i * 8 +: 8] = qkv_unpacked;
        
        assign Q_unpacked[i] = Q_in[i * 8 +: 8];
        assign K_unpacked[i] = K_ram_data[i * 8 +: 8];
        assign V_unpacked[i] = V_ram_data[i * 8 +: 8];
    end
endgenerate

// << Address counter >>
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        K_ram_addr <= '0;
        V_ram_addr <= '0;
    end
    else if (addr_j_clr) begin
        K_ram_addr <= '0;
        V_ram_addr <= '0;
    end
    else if (addr_j_inc) begin
        K_ram_addr <= K_ram_addr + 1'b1;
        V_ram_addr <= V_ram_addr + 1'b1;
    end
end

// << qk_j = sum (K_i*Q_i) >>
logic [DQ - 1 : 0] qk_j;
always_comb begin
    qk_j = '0;
    for (int i = 0; i < 44; i++)
        qk_j += K_unpacked[i] * Q_unpacked[i];
end


// << qkv_i = sum (qk_j * V[i]) >>
logic [DQ - 1 : 0] qkv_i;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        qkv_i <= '0;
    else if (qkv_i_clr)
        qkv_i <= '0;
    else if (qkv_i_acc)
        qkv_i <= qkv_i + qk_j * V_unpacked[cnt_i]
end


// i counter 
logic [$clog2(N) - 1 : 0] cnt_i;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        cnt_i <= '0;
    else if (cnt_i_clr)
        cnt_i <= '0;
    else if (cnt_i_inc)
        cnt_i <= cnt_i + 1'b1;
end

// Store result
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < N; i++)
            qkv_unpacked[i] <= '0;
    end
    else if (store_cell) begin
        qkv_unpacked[cnt_i] <= qkv_i;
    end
end

// State Machine
typedef enum logic [1 : 0] { IDLE, CALC_QK, CALC_SOFTMAX, CALC_ATT } state_t;       // more cycles for ( / sqrt d) ready?
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end

always_comb begin
    
    // Address counter
    addr_j_clr = 0;
    addr_j_inc = 0;
    cnt_i_clr = 0;
    cnt_i_inc = 0;

    // Accumulator
    qkv_i_clr = 0;
    qkv_i_acc = 0;

    // Store and valid
    set_out_valid = 0;
    store_cell = 0;
    
    nxt_state = state;
    case (state)
        IDLE: begin
            if (start) begin
                cnt_i_clr = 1;
                qkv_i_clr = 1;

                addr_j_inc = 1;
                
                nxt_state = CALC_CELL;
            end
        end 
        CALC_CELL: begin
            if (K_ram_addr == M) begin  // cell finished
                qkv_i_clr = 1;
                store_cell = 1;
                
                addr_j_clr = 1;
                cnt_i_inc = 1;
                
                if (cnt_i == N - 1) begin
                    set_out_valid = 1;
                    addr_j_clr = 1;
                    nxt_state = IDLE;
                end
                else begin
                    nxt_state = CALC_CELL;
                end
            end
            else begin
                addr_j_inc = 1;
                qkv_i_acc = 1;    
            end
        end
        // default: begin
        //     if ()
        // end 
    endcase
end

endmodule

`default_nettype wire 