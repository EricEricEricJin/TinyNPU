`default_nettype none

module layernorm_fetch #(
    parameter int SDRAM_DATA_W = 128,
    parameter int DATA_W = 176*8,
    parameter int N = 176
) (
    input wire clk, 
    input wire rst_n,

    // ------------------ To AVMM Read ------------------
    sdram_read_intf i_sdram_read_intf,

    // ------------------ To Registers ------------------
    output logic [8*N-1 : 0] data_out,    
    output logic gamma_hi_valid,
    output logic gamma_lo_valid,
    output logic beta_valid,

    // ------------------ To Control ------------------
    input wire          start,
    input wire [31 : 0] fetch_addr,
    output logic        done
);

localparam BLK_NUM = DATA_W / SDRAM_DATA_W;
localparam NUM_PER_BLK = SDRAM_DATA_W / 8;

logic nxt_line;
logic blk_store;

// Address FF
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        i_sdram_read_intf.read_addr <= '0;
    else if (start)
        i_sdram_read_intf.read_addr <= fetch_addr;
    else if (nxt_line)
        i_sdram_read_intf.read_addr <= i_sdram_read_intf.read_addr + 32'h10 * BLK_NUM;
end

assign i_sdram_read_intf.read_cnt = BLK_NUM;

/////////////////////////
// line buffer
/////////////////////////
logic [$clog2(BLK_NUM) - 1 : 0] blk_cnt;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        blk_cnt <= '0;
    else if (start || nxt_line)
        blk_cnt <= '0;
    else if (blk_store)
        blk_cnt <= blk_cnt + 1;
end


logic [SDRAM_DATA_W - 1 : 0] line_buf[0 : BLK_NUM - 1];
genvar i;
generate
    for (i = 0; i < BLK_NUM; i++) begin: blk_pack_line_buf
        assign data_out[i * SDRAM_DATA_W +: SDRAM_DATA_W] = line_buf[i];
    end
endgenerate

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < BLK_NUM; i++)
            line_buf[i] <= '0;
    end else begin
        if (blk_store)
            line_buf[blk_cnt] <= i_sdram_read_intf.read_data;
    end
end


/////////////////////////////
// State machine
/////////////////////////////
typedef enum logic [2 : 0] {
    IDLE, 
    GAMMA_HI_SEND_ADDR, 
    GAMMA_HI_RECV_DATA,
    GAMMA_LO_SEND_ADDR, 
    GAMMA_LO_RECV_DATA,
    BETA_SEND_ADDR, 
    BETA_RECV_DATA
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

    gamma_hi_valid = 0;
    gamma_lo_valid = 0;
    beta_valid = 0;

    nxt_line = 0;
    blk_store = 0;

    done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            done = 1;
            if (start)
                nxt_state = GAMMA_LO_SEND_ADDR;
        end

        GAMMA_LO_SEND_ADDR: begin
            i_sdram_read_intf.read_start = 1;
            nxt_state = GAMMA_LO_RECV_DATA;
        end
        GAMMA_LO_RECV_DATA: begin
            if (i_sdram_read_intf.read_valid)
                blk_store = 1;

            if (i_sdram_read_intf.read_done) begin
                nxt_line = 1;
                gamma_lo_valid = 1;
                nxt_state = GAMMA_HI_SEND_ADDR;
            end
        end

        GAMMA_HI_SEND_ADDR: begin
            i_sdram_read_intf.read_start = 1;
            nxt_state = GAMMA_HI_RECV_DATA;
        end
        GAMMA_HI_RECV_DATA: begin
            if (i_sdram_read_intf.read_valid)
                blk_store = 1;

            if (i_sdram_read_intf.read_done) begin
                nxt_line = 1;
                gamma_hi_valid = 1;
                nxt_state = BETA_SEND_ADDR;
            end 
        end

        BETA_SEND_ADDR: begin
            i_sdram_read_intf.read_start = 1;
            nxt_state = BETA_RECV_DATA;
        end
        default: begin  // BETA_RECV_DATA
            if (i_sdram_read_intf.read_valid)
                blk_store = 1;

            if (i_sdram_read_intf.read_done) begin
                nxt_line = 1;
                beta_valid = 1;
                nxt_state = IDLE;
            end
        end
    endcase
end

    
endmodule

`default_nettype wire
