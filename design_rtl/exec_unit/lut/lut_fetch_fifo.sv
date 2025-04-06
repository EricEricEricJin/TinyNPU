`default_nettype none

module lut_fetch_fifo (
    input wire clk,
    input wire rst_n,

    // ------ to writter ------
    input wire [127 : 0] data_in,
    input wire we_in,

    // ------ to bram ------
    bram_intf i_bram_intf,
    output logic done
);

logic empty;

logic [127 : 0] fifo_out;
logic fifo_rdreq;
fifo_16x128 i_fifo (
    .clock  (clk),
    .data   (data_in),
    .rdreq  (fifo_rdreq),
    .wrreq  (we_in),
    .empty  (empty),
    .q      (fifo_out)
);

// line buffer
logic [127 : 0] line_buffer;
logic line_buf_ld;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        line_buffer <= '0;
    else if (line_buf_ld)
        line_buffer <= fifo_out;
end

// unpack line buffer
logic [7 : 0] line_buf_unpacked [16];
genvar i;
generate
    for (i = 0; i < 16; i++) begin: blk_unpack_line_buf
        assign line_buf_unpacked[i] = line_buffer[i * 8 +: 8];
    end
endgenerate

// index
logic [3:0] line_buf_idx;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        line_buf_idx <= '0;
    else if (i_bram_intf.we)
        line_buf_idx <= line_buf_idx + 1;        
end
assign i_bram_intf.data = line_buf_unpacked[line_buf_idx];

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        i_bram_intf.addr <= '0;
    else if (i_bram_intf.we)
        i_bram_intf.addr <= i_bram_intf.addr + 1;
end

// state machine
typedef enum logic[1:0] { IDLE, READ_FROM_FIFO, WRITE_TO_BRAM } state_t;
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end
always_comb begin
    fifo_rdreq = 0;
    line_buf_ld = 0;
    i_bram_intf.we = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            if (!empty) begin
                fifo_rdreq = 1;
                nxt_state = READ_FROM_FIFO;
            end
        end
        READ_FROM_FIFO: begin
            line_buf_ld = 1;
            nxt_state = WRITE_TO_BRAM;
        end
        default: begin
            i_bram_intf.we = 1;
            if (line_buf_idx == 4'hf) 
                nxt_state = IDLE;
        end
    endcase

end

assign done = (state == IDLE) && (empty);

endmodule

`default_nettype wire
