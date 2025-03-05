// Execute move command to RF

`default_nettype none

module rf_move #(
    parameter int WIDTH = 176*8,
    parameter int ADDR_W = 10,
    parameter int LINE_NUM_W = 8
) (
    input wire clk, rst_n,

    // to ram
    // output logic    [ADDR_W - 1 : 0]    ram_addr,
    // output logic                        ram_we, 
    // output logic                        ram_re,
    // output wire     [WIDTH - 1 : 0]     ram_d,
    // input wire      [WIDTH - 1 : 0]     ram_q,
    bram_intf ram,

    rf_move_intf rf_move,

    output wire done
);

// assign ram_d = ram_q;
assign ram.data = ram.q;

// Set done 
logic set_done;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        done <= 1;
    else if (rf_move.start)
        done <= 0;
    else if (set_done)
        done <= 1;
end

input logic line_cnt_dec;
logic [LINE_NUM_W - 1 : 0] line_cnt;
logic [ADDR_W - 1 : 0] src_addr, dst_addr;

// Flip src and dst addr at start
// Line counter
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        src_addr <= '0;
        dst_addr <= '0;
        line_cnt <= '0;
    end
    else if (rf_move.start) begin
        src_addr <= rf_move.src_addr;
        dst_addr <= rf_move.dst_addr;
        line_cnt <= rf_move.line_cnt - 1;
    end
    else if (line_cnt_dec) begin
        src_addr <= src_addr + 1;
        dst_addr <= dst_addr + 1;
        line_cnt <= line_cnt - 1;
    end
end

// State machine
typedef enum logic[1:0] { IDLE, LOAD, STORE } state_t;
state_t state, nxt_state;
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end



always_comb begin
    // ram_addr = src_addr;
    // ram_we = 0;
    // ram_re = 0;
    ram.addr = src_addr;
    ram.we = 0;
    ram.re = 0;

    set_done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            if (rf_move.start)
                nxt_state = LOAD;
        end
        LOAD: begin
            // ram_addr = src_addr;
            // ram_re = 1;
            ram.addr = src_addr;
            ram.re = 1;
            nxt_state = STORE;
        end
        default: begin
            // ram_addr = dst_addr;
            // ram_we = 1;
            ram.addr = dst_addr;
            ram.we = 1;
            
            line_cnt_dec = 1;

            if (line_cnt == 0) begin
                set_done = 1;
                nxt_state = IDLE;
            end
            else begin
                nxt_state = LOAD;
            end
        end
     endcase
end


endmodule

`default_nettype wire
