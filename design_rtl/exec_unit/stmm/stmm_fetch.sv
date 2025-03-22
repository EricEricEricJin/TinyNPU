
module stmm_fetch #(
    parameter int BRAM_W = 1408,  // q-width (bits)
    parameter int BRAM_L = 176,
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    // ------------------ To AVMM Read ------------------
    sdram_read_intf i_sdram_read_intf,

    // ------------------ To StMM Weight BRAM ------------------
    bram_intf i_bram_intf,

    // ------------------ To StMM scale and zero ------------------
    output logic [15 : 0]       scale_fp16,
    output logic signed [7 : 0] z_X,
    output logic signed [7 : 0] z_W,
    output logic signed [7 : 0] zero,
    output logic                quant_valid,

    // ------------------ To Control ------------------
    input wire          start,
    input wire [31 : 0] fetch_addr,
    output logic        done
);

assign i_bram_intf.re = 0;

////////////////////////
// line buffer
////////////////////////
localparam int BLK_NUM = BRAM_W / SDRAM_W;
logic [SDRAM_W - 1 : 0] line_buf[0 : BLK_NUM - 1];

genvar i;
generate
    for (i = 0; i < BLK_NUM; i++) begin: blk_pack_line_buf
        assign i_bram_intf.data[i * SDRAM_W +: SDRAM_W] = line_buf[i];
    end
endgenerate

////////////////////////
// SDRAM address and BRAM address
////////////////////////
logic nxt_line;   
logic [$clog2(BRAM_L) - 1 : 0] line_cnt;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        i_sdram_read_intf.read_addr <= '0;
        i_bram_intf.addr <= '0;
    end else if (start) begin
        i_sdram_read_intf.read_addr <= fetch_addr;
        i_bram_intf.addr <= '0;
    end else if (nxt_line) begin
        i_sdram_read_intf.read_addr <= i_sdram_read_intf.read_addr + 32'h10 * BLK_NUM;
        i_bram_intf.addr <= i_bram_intf.addr + 1;
    end
end

////////////////////////
// store read_data into line_buf
////////////////////////
logic blk_store;
logic [$clog2(BLK_NUM) - 1 : 0] blk_cnt;

always_ff @( posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < BLK_NUM; i++)
            line_buf[i] <= '0;
    end else if (blk_store) begin
        line_buf[blk_cnt] <= i_sdram_read_intf.read_data;
    end
end

////////////////////////
// block counter
////////////////////////
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        blk_cnt <= '0;
    else if (nxt_line) 
        blk_cnt <= '0;
    else if (blk_store)
        blk_cnt <= blk_cnt + 1;
end


////////////////////////
// assign quantization parameters
////////////////////////
assign z_X = i_sdram_read_intf.read_data[0 +: 8];
assign z_W = i_sdram_read_intf.read_data[32 +: 8];
assign zero = i_sdram_read_intf.read_data[64 +: 8];
assign scale_fp16 = i_sdram_read_intf.read_data[96 +: 16];

////////////////////////
// state machine
////////////////////////

typedef enum logic[1:0] { 
    IDLE, 
    RECV_MAT,
    RECV_QUANT
} state_t;

state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin    
    i_sdram_read_intf.read_start = 0;
    i_sdram_read_intf.read_cnt = (11)'(BLK_NUM);

    blk_store = 0;
    nxt_line = 0;

    i_bram_intf.we = 0;
    quant_valid = 0;

    done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            done = 1;
            if (start) begin
                i_sdram_read_intf.read_start = 1;
                nxt_state = RECV_MAT;
            end
        end
        RECV_MAT: begin
            if (i_sdram_read_intf.read_valid)
                blk_store = 1;
            
            if (i_sdram_read_intf.read_done) begin
                i_bram_intf.we = 1;
                nxt_line = 1;
                i_sdram_read_intf.read_start = 1;
                
                if (i_bram_intf.addr == BRAM_L - 1) begin
                    i_sdram_read_intf.read_cnt = 11'h1;
                    nxt_state = RECV_QUANT;
                end
            end
        end
        default: begin  // RECV_QUANT
            if (i_sdram_read_intf.read_valid) begin
                quant_valid = 1;
                nxt_state = IDLE;
            end
        end
    endcase
end

endmodule
