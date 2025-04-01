`default_nettype none

module ln_fetch #(
    parameter int SDRAM_DATA_W = 128,
    parameter int DATA_W = 176*8,
    parameter int N = 176
) (
    input wire clk, 
    input wire rst_n,

    // ------------------ To AVMM Read ------------------
    sdram_read_intf i_sdram_read_intf,

    // ------------------ To Registers ------------------
    output logic [7 : 0] data_out[0 : N - 1],    
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
    else if (start)
        blk_cnt <= '0;
    else if (blk_store)
        blk_cnt <= blk_cnt + 1;
end


logic [SDRAM_DATA_W - 1 : 0] line_buf[0 : BLK_NUM - 1];
genvar i, j;
generate
    for (i = 0; i < BLK_NUM; i++) begin: blk_pack_line_buf_i
        for (j = 0; j < NUM_PER_BLK; j++) begin: blk_pack_line_buf_j
            assign data_out[i*NUM_PER_BLK + j] = line_buf[i][j*8 +: 8];
        end
    end
endgenerate

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < BLK_NUM; i++)
            line_buf[i] <= '0;
    end else begin
        if (nxt_line)
            line_buf[line_cnt] <= i_sdram_read_intf.read_data;
    end
end


/////////////////////////////
// State machine
/////////////////////////////
typedef enum logic [2 : 0] {
    IDLE, 
    SEND_ADDR, 
    RECV_GAMMA_HI, 
    RECV_GAMMA_LO, 
    RECV_BETA 
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

    done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            done = 1;
            if (start)

        end

        SEND_ADDR: begin
            i_sdram_read_intf.read_start = 1;
            nxt_state = RECV_GAMMA_HI;
        end

        RECV_GAMMA_HI: begin
            if (i_sdram_read_intf.read_valid)
                store
        end
        GAMMA_LO: begin
        end
        default: begin  // BETA
            
        end
    endcase
end

    
endmodule

`default_nettype wire