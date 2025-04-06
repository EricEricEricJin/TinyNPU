`default_nettype none

module lut_fetch #(
    parameter int BRAM_W = 8,
    parameter int BRAM_L = 256,
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    // ------------------ To AVMM Read ------------------
    sdram_read_intf i_sdram_read_intf,

    // ------------------ To StMM Weight BRAM ------------------
    bram_intf i_bram_intf,
    
    // ------------------ To Control ------------------
    input wire          start,
    input wire [31 : 0] fetch_addr,
    output logic        done
);

logic fifo_we;
logic fifo_done;
logic feed_done;

assign done = fifo_done && feed_done;

//////////////////////////
// Fetch FIFO
//////////////////////////
lut_fetch_fifo i_fetch_fifo (
    .clk(clk),
    .rst_n(rst_n),

    .data_in(i_sdram_read_intf.read_data),
    .we_in(fifo_we),

    .i_bram_intf(i_bram_intf),
    .done(fifo_done)
)



////////////////////////
// Fetch from SDRAM to FIFO
////////////////////////
typedef enum logic[1:0] { IDLE, SEND_ADDR, RECV_DATA } state_t;
state_t state, nxt_state;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end

assign i_sdram_read_intf.read_cnt = (BRAM_L*BRAM_W) / SDRAM_W;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) 
        i_sdram_read_intf.read_addr <= '0;
    else if (start)
        i_sdram_read_intf.read_addr <= fetch_addr;
end

always_comb begin
    i_sdram_read_intf.read_start = 0;
    fifo_we = 0;

    feed_done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            feed_done = 1;
            if (start)
                nxt_state = SEND_ADDR;
        end
        
        SEND_ADDR: begin
            i_sdram_read_intf.read_start = 1;
            nxt_state = RECV_DATA;
        end

        default: begin
            if (i_sdram_read_intf.read_valid)
                fifo_we = 1;

            if (i_sdram_read_intf.read_done)
                nxt_state = IDLE;
        end
    endcase
end

endmodule

`default_nettype wire
