
module stmm_param_fetcher #(
    parameter int BRAM_W = 1408,  // q-width (bits)
    parameter int BRAM_L = 176,
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    input wire start,
    input wire [31 : 0] base_addr,

    // Connect to Avalon Read    
    sdram_read_intf sdram_read,

    // Connect to RAM
    output logic [$clog2(BRAM_L) - 1 : 0] ram_addr,
    output logic [BRAM_W - 1 : 0] ram_data,
    output logic ram_we,

    // scale and zeros
    output logic signed [7 : 0] z_X,
    output logic signed [7 : 0] z_W,
    output logic signed [7 : 0] zero,
    output logic [15 : 0] scale_fp16,

    output logic done
);

localparam BURSTCOUNT = BRAM_L * BRAM_W / SDRAM_W + 1;

// DONE srff
logic set_done;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        done <= 0;
    else if (set_done)
        done <= 1;
    else if (start)
        done <= 0;
end


logic blk_store;        // write block to line buffer
logic line_store;       // write line to ram
logic all_clr, nxt_line;   

logic ld_misc;

// line buffer
localparam int LINE_N = (BRAM_W - 1) / (AVALON_W) + 1;
logic [LINE_N * AVALON_W - 1 : 0] line_buf;
logic [AVALON_W - 1 : 0] line_buf_unpacked[0 : LINE_N - 1];

genvar i;
generate
    for (i = 0; i < LINE_N; i++) begin: blk_pack_line_buf
        assign line_buf[i * AVALON_W +: AVALON_W] = line_buf_unpacked[i];
    end
endgenerate

// AVMM address
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        read_addr <= '1;
    else if (all_clr)
        read_addr <= base_addr;
    else if (nxt_line)
        read_addr <= read_addr + 32'd32 * LINE_N;
end

// block cnt
wire [$clog2(LINE_N) - 1 : 0] blk_cnt;
assign blk_cnt = out_idx < LINE_N ? out_idx : '0;

// line cnt
logic [$clog2(BRAM_L) - 1 : 0] line_cnt;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        line_cnt <= '0;
    else if (all_clr)
        line_cnt <= '0;
    else if (nxt_line)
        line_cnt <= line_cnt + 1;
end

// store block
always_ff @( posedge clk ) begin
    if (blk_store)
        line_buf_unpacked[blk_cnt] <= out_data;
end

// store line
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        ram_data <= '0;
        ram_addr <= '0;
    end
    else if (line_store) begin
        ram_data <= line_buf[BRAM_W - 1 : 0];
        ram_addr <= line_cnt;
    end
end

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        ram_we <= 0;
    else
        ram_we <= line_store;
end

// load miscs
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        z_X <= '0;
        z_W <= '0;
        zero <= '0;
        scale_fp16 <= '0;
    end
    else if (ld_misc) begin
        {z_X, z_W, zero, scale_fp16} <= out_data[39 : 0];
    end
end

// << state machine >>
// signals
logic [3 : 0] blk_cnt;
logic [7 : 0] line_cnt;
logic blk_inc, blk_clr, line_inc, line_clr;
logic store_line;


typedef enum logic[1:0] { 
    IDLE, 
    SEND_ADDR, 
    RECV_MAT,
    RECV_MISC
} state_t;

state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end


always_comb begin
    
    // all_clr = 0;
    // nxt_line = 0;

    // read_cnt = '0;
    // read_start = 0;

    // blk_store = 0;
    // line_store = 0;

    // ld_misc = 0;
    // set_done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            if (start) begin
                line_clr = 1;
                blk_clr = 1;
                nxt_state = SEND_ADDR;
            end
        end 
        SEND_ADDR: begin
            read_cnt = 11'(BURSTCOUNT);
            read_start = 1;
            nxt_state = RECV_MAT;
        end
        RECV_MAT: begin
            if (out_valid) begin
                blk_store = 1;
                if (blk_cnt == COL_N - 1) begin
                    blk_clr = 1;
                    line_inc = 1;
                    store_line = 1;
                end
                
                if (line_cnt == LINE_N - 1) begin
                    nxt_state = RECV_LINE;
                end
            end
        end
        default: begin
            if (out_valid) begin
                ld_misc = 1;
                set_done = 1;
                nxt_state = IDLE;
            end
        end
    endcase
end


endmodule

