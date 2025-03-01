`default_nettype none

module sdram_write #(
    parameter int SDRAM_W = 128,
    parameter int VREG_W = 1408
) (
    input wire clk, 
    input wire rst_n,

    // connect to HPS
    output logic [31:0] sdram_address;
    output logic [SDRAM_W - 1 : 0] sdram_writedata;
    output logic [15 : 0] sdram_byteenable;
    output logic sdram_write;

    // Connect to VREG
    input wire [VREG_W - 1 : 0] vreg, 
    input wire [31 : 0] addr,
    input wire write_start,
    output logic write_done
);

localparam ADDR_INC = SDRAM_W / 8;

// Done SRFF
logic set_done;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        write_done <= 0;
    else if (write_start)
        write_done <= 0;
    else if (set_done)
        write_done <= 1;
end

// flop VREG
logic [SDRAM_W - 1 : 0] vreg_ff [0 : VREG_W / SDRAM_W - 1];
logic vref_store;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < VREG_W / SDRAM_W - 1; i++)
            vreg_ff[i] <= '0;
    end
    else if (vref_store) begin
        for (int i = 0; i < VREG_W / SDRAM_W - 1; i++)
            vreg_ff[i] <= vreg[i * SDRAM_W +: SDRAM_W];
    end
end

// counter
logic [10 : 0] cnt;
logic cnt_inc, cnt_clr;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        cnt <= '0;
        sdram_address <= '0;
    end
    else if (cnt_clr) begin
        cnt <= '0;
        sdram_address <= addr;
    end
    else if (cnt_inc) begin
        cnt <= cnt + 1;
        sdram_address <= sdram_address + ADDR_INC;
    end
end

// write data and byteenable
assign sdram_writedata = vreg_ff[cnt];
assign sdram_byteenable = 16'hffff;

// State machine 
typedef enum logic { IDLE, WRITE } state_t;
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin
    cnt_clr = 0;
    cnt_inc = 0;
    vreg_store = 0;
    set_done = 0;
    sdram_write = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            if (write_start) begin
                vreg_store = 1;
                cnt_clr = 1;

                nxt_state = WRITE;
            end
        end
        default: begin
            cnt_inc = 1;
            sdram_write = 1;
            if (cnt == VREG_W / SDRAM_W - 1) begin
                set_done = 1;
                nxt_state = IDLE;
            end
        end 
    endcase
end

endmodule

`default_nettype wire 