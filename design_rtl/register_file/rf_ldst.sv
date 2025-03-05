// Load and store vector from / to SDRAM

`default_nettype none

module rf_ldst #(
    parameter int RF_ADDR_W = 9,
    parameter int SDRAM_DATA_W = 128,
    parameter int RF_DATA_W = 176*8
)(
    input wire clk, rst_n,

    // to SDRAM
    sdram_intf sdram,

    // to RF 
    output wire [ADDR_W - 1 : 0] rf_addr,
    output wire [DATA_W - 1 : 0] rf_d, 
    output wire rf_we, 
    output wire rf_re,
    input wire [DATA_W - 1 : 0] rf_q,

    // to master
    input wire [31 : 0]   ldst_sdram_addr,
    input wire [RF_ADDR_W - 1 : 0]      ldst_rf_addr,
    input wire [7 : 0]  ldst_line_num,
    input wire          load_start, store_start,
    output logic        ldst_done

);

// addr ff
logic [31 : 0] sdram_addr;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        sdram_addr <= 0;
    end
    else if (load_start || store_start) begin
        sdram_addr <= ldst_sdram_addr;
    end
end

// rf addr = rf_addr + i;
// RF_ADDR COUNTER  
logic [10 : 0] line_num_ff;
logic rf_addr_inc;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        rf_addr <= 0;
        line_num_ff <= 0;
    end
    else if (store_start || load_start) begin
        rf_addr <= ldst_rf_addr;
        line_num_ff <= ldst_line_num;
    end
    else if (rf_addr_inc) begin
        rf_addr <= rf_addr + 1;
    end
end

// line buffer
logic [$clog2(RF_DATA_W / SDRAM_DATA_W) - 1 : 0] line_buf_addr;
logic line_buf_inc, line_buf_clr, line_buf_ld;
logic [SDRAM_DATA_W - 1 : 0] line_buf [0 : RF_DATA_W / SDRAM_DATA_W - 1];

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        line_buf_addr <= '0;
    else if (line_buf_clr)
        line_buf_addr <= '0;
    else if (line_buf_inc)
        line_buf_addr <= line_buf_addr + 1'b1;
end

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < RF_DATA_W / SDRAM_DATA_W; i++)
            line_buf[i] <= '0;
    end
    else if (line_buf_ld) begin
        line_buf[line_buf_addr] <= sdram.readdata;
    end
end

genvar i;
generate
    for (i = 0; i < RF_DATA_W / SDRAM_DATA_W; i++) begin
        assign rf_d[i * SDRAM_DATA_W +: SDRAM_DATA_W] = line_buf[i];
    end
endgenerate

// unpack rf_q;
logic [SDRAM_DATA_W - 1 : 0] rf_q_unpacked [0 : RF_DATA_W / SDRAM_DATA_W - 1];
generate
    for (i = 0; i < RF_DATA_W / SDRAM_DATA_W; i++) begin
        assign rf_q_unpacked[i] = rf_q[i * SDRAM_DATA_W +: SDRAM_DATA_W];
    end
endgenerate

assign sdram.writedata = rf_q_unpacked[line_buf_addr];

typedef enum logic[1:0] { 
    IDLE, 
    READ_SEND_ADDR, WRITE_SEND_ADDR,
    READ_FROM_SDRAM, WRITE_TO_RF, 
    READ_FROM_RF, WRITE_TO_SDRAM 
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
    sdram.addr = 0;
    sdram.data = 0;
    sdram.valid = 0;

    sdram.byteenable = '1;
    sdram.burstcount = RF_DATA_W / SDRAM_DATA_W;

    line_buf_clr = 0;
    line_buf_inc = 0;
    line_buf_ld = 0;
    
    case (state)
        IDLE: begin
            if (load_start) begin
                line_buf_clr = 1;
                nxt_state = READ_SEND_ADDR;
            end
            else if (store_start) begin
                nxt_state = READ_FROM_RF;
            end
        end
        
        READ_SEND_ADDR: begin
            sdram.addr = sdram_addr;
            sdram.read = 1;

            // wait until waitreq is deasserted
            if (!sdram.waitrequest)
                nxt_state = READ_FROM_SDRAM;
        end

        READ_FROM_SDRAM: begin
            if (sdram.readdatavalid) begin
                line_buf_ld = 1;
                line_buf_inc = 1;
                if (line_buf_addr == RF_DATA_W / SDRAM_DATA_W - 1)
                    nxt_state = WRITE_TO_RF;
            end
        end

        WRITE_TO_RF: begin
            rf_we = 1;
            rf_addr_inc = 1;
            if (rf_addr == rf_addr_end)
                ldst_done = 1;
                nxt_state = IDLE;
            else begin
                nxt_state = READ_SEND_ADDR;
            end
        end

        READ_FROM_RF: begin
            rf_re = 1;
            nxt_state = WRITE_SEND_ADDR;
        end

        WRITE_SEND_ADDR: begin
            sdram.addr = sdram_addr;
            sdram.write = 1;
            if (!sdram.waitrequest)
                nxt_state = WRITE_TO_SDRAM;
        end

        // todo: add burstcnt to Write
        default: begin      // WRITE_TO_SDRAM
            line_buf_inc = 1;
            sdram.write = 1;
            if (line_buf_addr == RF_DATA_W / SDRAM_DATA_W - 1)
                nxt_state = IDLE;
        end

    endcase

end

    
endmodule

`default_nettype wire 
