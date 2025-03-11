// Load and store vector from / to SDRAM
`default_nettype none

module rf_ldst #(
    parameter int RF_ADDR_W = 10,
    parameter int LINE_NUM_W = 11,
    parameter int SDRAM_DATA_W = 128,
    parameter int RF_DATA_W = 176*8
)(
    input wire clk, 
    input wire rst_n,

    rf_ldst_intf rf_ldst,   // Connect to control unit     

    sdram_intf sdram,       // Connect to Avalon SDRAM
    bram_intf rf_ram,       // Connect to RF Ram

    output logic done       // Running state
);


logic line_nxt, line_clr;
logic line_buf_ld_from_sdram, line_buf_ld_from_rf;
logic line_buf_idx_inc, line_buf_idx_clr;


////////////////////////
// Line and address counter 
////////////////////////
logic [31 : 0]              sdram_addr;
logic [RF_ADDR_W - 1 : 0]   rf_addr;
logic [LINE_NUM_W - 1 : 0]  line_cnt;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        sdram_addr <= '0;
        rf_addr <= '0;
        line_cnt <= '0;
    end
    else if (line_clr) begin
        sdram_addr <= rf_ldst.sdram_addr;
        rf_addr <= rf_ldst.rf_addr;
        line_cnt <= rf_ldst.line_num;  
    end
    else if (line_nxt) begin
        sdram_addr <= sdram_addr + 32'hb0;  // 176 bytes
        line_cnt <= line_cnt - 1;
        rf_addr <= rf_addr + 1;
    end
end

////////////////////////
// Line buffer
////////////////////////

// unpack rf.q
wire [SDRAM_DATA_W - 1 : 0] rf_ram_q_unpacked[0 : RF_DATA_W / SDRAM_DATA_W - 1];
genvar i;
generate
    for (i = 0; i < RF_DATA_W / SDRAM_DATA_W; i++) begin: blk_unpack_rf_q
        assign rf_ram_q_unpacked[i] = rf_ram.q[i * SDRAM_DATA_W +: SDRAM_DATA_W];
    end
endgenerate


logic [SDRAM_DATA_W - 1 : 0] line_buf[0 : RF_DATA_W / SDRAM_DATA_W - 1];
// pack line_buf
wire [RF_DATA_W - 1 : 0] line_buf_packed;
generate
    for (i = 0; i < RF_DATA_W / SDRAM_DATA_W; i++) begin: blk_pack_line_buf
        assign line_buf_packed[i * SDRAM_DATA_W +: SDRAM_DATA_W] = line_buf[i];
    end
endgenerate

logic [$clog2(RF_DATA_W / SDRAM_DATA_W) - 1 : 0] line_buf_idx;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        line_buf_idx <= '0;
    else if (line_buf_idx_clr)
        line_buf_idx <= '0;
    else if (line_buf_idx_inc)
        line_buf_idx <= line_buf_idx + 1;
end

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        foreach (line_buf[i])
            line_buf[i] <= '0;
    end
    else if (line_buf_ld_from_rf) begin
        foreach (line_buf[i])
            line_buf[i] <= rf_ram_q_unpacked[i];
    end
    else if (line_buf_ld_from_sdram) begin
        line_buf[line_buf_idx] <= sdram.readdata;
    end
end


////////////////////////
// Connect SDRAM and RF_Ram constant signals
////////////////////////
assign sdram.burstcount = RF_DATA_W / SDRAM_DATA_W;
assign sdram.address = sdram_addr;
assign sdram.byteenable = '1;
assign sdram.writedata = line_buf[line_buf_idx];

assign rf_ram.addr = rf_addr;
assign rf_ram.data = line_buf_packed;


////////////////////////
// State machine
////////////////////////
typedef enum logic[2:0] { 
    IDLE, 
    READ_SEND_ADDR,
    WRITE_SEND_ADDR,
    READ_FROM_SDRAM,
    WRITE_TO_RF, 
    READ_FROM_RF,
    WRITE_TO_SDRAM 
} state_t;
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end


always_comb begin
    sdram.read = 0;
    sdram.write = 0;

    rf_ram.we = 0;
    rf_ram.re = 0;

    line_nxt = 0;
    line_clr = 0;

    line_buf_ld_from_sdram = 0;
    line_buf_ld_from_rf = 0;
    line_buf_idx_inc = 0;
    line_buf_idx_clr = 0;

    done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            done = 1;

            line_clr = 1;
            line_buf_idx_clr = 1;
            
            if (rf_ldst.load_start) begin
                nxt_state = READ_SEND_ADDR;
            end
            else if (rf_ldst.store_start) begin
                rf_ram.re = 1;
                nxt_state = READ_FROM_RF;
            end
        end
        
        READ_SEND_ADDR: begin
            sdram.read = 1;
            if (!sdram.waitrequest)
                nxt_state = READ_FROM_SDRAM;
            // need to de-assert read if waitrequest is low?
        end

        READ_FROM_SDRAM: begin
            if (sdram.readdatavalid) begin
                line_buf_ld_from_sdram = 1;
                line_buf_idx_inc = 1;
            end
            
            if (line_buf_idx == RF_DATA_W / SDRAM_DATA_W)
                nxt_state = WRITE_TO_RF;
        end

        WRITE_TO_RF: begin
            rf_ram.we = 1;
            line_buf_idx_clr = 1;

            if (line_cnt == 1) begin
                line_clr = 1;
                nxt_state = IDLE;            
            end
            else begin
                line_nxt = 1;
                nxt_state = READ_SEND_ADDR;
            end 
        end

        READ_FROM_RF: begin
            // re alreay asserted in previous cycle, now ram.q is valid
            line_buf_ld_from_rf = 1;
            nxt_state = WRITE_SEND_ADDR;
        end

        WRITE_SEND_ADDR: begin
            // send addr
            sdram.write = 1;
            if (!sdram.waitrequest) begin
                line_nxt = 1;
                line_buf_idx_inc = 1;
                nxt_state = WRITE_TO_SDRAM;
            end
        end

        default: begin      // WRITE_TO_SDRAM

            if (line_buf_idx == RF_DATA_W / SDRAM_DATA_W) begin
                line_buf_idx_clr = 1;
                
                if (line_cnt == 0) begin
                    line_clr = 1;
                    nxt_state = IDLE;
                end
                else begin
                    rf_ram.re = 1;
                    nxt_state = READ_FROM_RF;
                end

            end
            else begin
                line_buf_idx_inc = 1;
                sdram.write = 1;                
            end
        end
    endcase
end

endmodule

`default_nettype wire 
