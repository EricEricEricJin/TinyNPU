`default_nettype none

module layer_norm #(
    parameter int N = 176,
    parameter int Q = 8
) (
    input wire clk,
    input wire rst_n,

    // input 
    input wire signed [7 : 0]   x_in [0 : N - 1],
    input wire [15 : 0]         gamma_scaled[0 : N - 1],    // FP16!!
    input wire signed [7 : 0]   beta_scaled[0 : N - 1],     // INT8!!
    input wire                  start,

    output logic signed [7 : 0] y_out[0 : N - 1],
    output logic                out_valid
);

// Command signals
logic idx_acc, idx_clr;         // index accumulator
logic avg_acc, avg_clr;         // average accumulator
logic ld_x_mean, ld_sd_mean;    // average load
logic avg_sel;                  // average input select
logic latency_start;            // start latency counter

logic store_y_nf, store_y;

logic sd_valid;

// logic flop_sd;
logic gamma_path_flop;

logic set_out_valid;


// Condition signals
logic latency_done;             // latency count to end
logic rsqrt_done;

// Valid SRFF
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        out_valid <= 0;
    else if (start)
        out_valid <= 0;
    else if (set_out_valid)
        out_valid <= 1;
end

// << Index Accumulator >>
logic [7 : 0]    index;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        index <= '0;
    else if (idx_clr)
        index <= '0;
    else if (idx_acc)
        index <= index + 1;
end

// << Averager >>
logic signed [15 : 0] avg_in;
logic signed [23 : 0] avg_sum;

logic signed [31 : 0]    avg_mul;
logic signed [15 : 0]    avg_out;


always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        avg_sum <= '0;
    else if (avg_clr)
        avg_sum <= '0;
    else if (avg_acc)
        avg_sum <= avg_sum + avg_in;
end

// out = sum / 176 = sum * 93 / (2^14)
localparam int AVG_MUL = 93;
localparam int AVG_BS  = 14;
assign avg_mul = avg_sum * AVG_MUL;
assign avg_out = avg_mul [AVG_BS +: 16];


// <<Unpack X>>
// wire signed [7 : 0] x_unpacked  [0 : N - 1];
// genvar i;
// generate
//     for (int = 0; i < N; i++;) begin: blk_unpack_x
//         assign x_unpacked[i] = x_in[i * Q +: Q];
//     end
// endgenerate

// x_mz = x[i] - z_x
// wire signed [8 : 0]    x_mz;
// assign x_mz = x_in[index] - z_x;
// assign x_mz = x_unpacked[index] - z_x;

// todo: change x_unpacked into register to flop the x_in at start


// << mean store FFs >>
logic signed [Q - 1 : 0] x_mean;
logic [Q*2 - 1 : 0] sd_mean;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        x_mean <= '0;
        sd_mean <= '0;
    end
    else if (ld_x_mean) begin
        x_mean <= avg_out;
    end
    else if (ld_sd_mean) begin
        sd_mean <= avg_out;
    end
end

wire signed [7 : 0] xd;
assign xd = x_in[index] - x_mean;

assign avg_in = avg_sel ? xd**2 : x_in[index]; 

// <<Gamma Path >>
wire signed [7 : 0] y1;
wire [8 : 0] cs_in, cs_out;


gamma_path i_gamma_path (
    .clk            (clk),
    .rst_n          (rst_n),

    .gamma_scaled   (gamma_scaled[index]),
    .xd             (xd),
    .sd             (sd_mean),
    
    .sd_valid       (sd_valid),
    .flop           (gamma_path_flop),
    .cs_in          (cs_in),

    .rsqrt_done     (rsqrt_done),
    .y              (y1),
    .cs_out         (cs_out)
);

// << Output y = t1 + y2 >>
logic [7 : 0] y_idx;

wire signed [8 : 0]    y_i_raw;
wire signed [7 : 0]     y_i;

assign y_i_raw = y1 + beta_scaled[y_idx];
saturate #( .IN_W (9), .OUT_W (8) ) i_sat_y (.in (y_i_raw), .out (y_i) );


// << Output Loader >>
assign cs_in = {store_y_nf, index};
assign {store_y, y_idx} = cs_out;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < N; i++)
            y_out[i] <= '0;
    end
    else if (store_y) begin
        y_out[y_idx] <= y_i;
    end
end


// << Outside Latency timer >>
localparam int GAMMA_PATH_LATENCY = 3;
count_down #(.N(GAMMA_PATH_LATENCY)) i_count_down (
    .clk    (clk),
    .rst_n  (rst_n),
    .start  (latency_start),
    .done   (latency_done)
);
// logic [3 : 0] latency_cnt;

// always_ff @( posedge clk, negedge rst_n ) begin
//     if (!rst_n) 
//         latency_cnt <= '0;
//     else if (latency_start) 
//         latency_cnt <= GAMMA_PATH_LATENCY;
//     else if (latency_cnt != 0) 
//         latency_cnt <= latency_cnt - 1;
// end
// assign latency_done = (latency_cnt == 0);


// << State Machine >>
typedef enum logic[2 : 0] {
    IDLE, 
    X_MEAN, 
    SD_MEAN,
    FLOP_SD, 
    WAIT_Y,
    STORE_Y
} state_t;

state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end

always_comb begin
    idx_clr = 0;
    idx_acc = 0;

    avg_acc = 0;
    avg_clr = 0;

    ld_x_mean = 0;
    ld_sd_mean = 0;

    avg_sel = 0;

    latency_start = 0;

    store_y_nf = 0;
    
    sd_valid = 0;
    
    gamma_path_flop = 0;

    set_out_valid = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            if (start) begin
                idx_clr = 1;
                avg_clr = 1;
                nxt_state = X_MEAN;
            end
        end

        // Calculate mean(x)
        X_MEAN: begin
            avg_sel = 0;
            avg_acc = 1;
            idx_acc = 1;
            if (index == N) begin
                ld_x_mean = 1;
                idx_clr = 1;
                avg_clr = 1;
                nxt_state = SD_MEAN;
            end
        end

        // Calculate mean( (x - mean_x)^2 )
        SD_MEAN: begin
            avg_sel = 1;
            avg_acc = 1;
            idx_acc = 1;
            if (index == N) begin
                ld_sd_mean = 1;
                idx_clr = 1;
                
                sd_valid = 1;

                nxt_state = FLOP_SD;
            end
        end

        // Flop SD into gamma path until rsqrt_done
        FLOP_SD: begin
            if (rsqrt_done) begin
                latency_start = 1;
                gamma_path_flop = 1;
                store_y_nf = 1;

                nxt_state = WAIT_Y;
            end
        end

        // Wait for LATENCY cycles
        WAIT_Y: begin // WAIT_Y
            if (y_idx == N - 1) begin
                idx_clr = 1;
                set_out_valid = 1;
                nxt_state = IDLE;
            end
            else if (latency_done) begin
                idx_acc = 1;
                nxt_state = STORE_Y;
            end
        end
        
        // Push one X into gamma path
        default: begin  // STORE_Y
            latency_start = 1;
            store_y_nf = 1;
            gamma_path_flop = 1;
            
            nxt_state = WAIT_Y;
        end 

    endcase
end

// HOW TO FUCK THE STORE_Y SIGNAL???



endmodule

`default_nettype wire 