// Execute move command to RF

`default_nettype none

module rf_mv #(
    parameter int WIDTH = 176*8,
    parameter int ADDR_W = 9
) (
    input wire clk, rst_n,

    // to ram
    output logic [ADDR_W - 1 : 0] ram_addr,
    output logic ram_we, ram_re,
    output wire [WIDTH - 1 : 0] ram_d,
    input wire [WIDTH - 1 : 0] ram_q,
    
    // to master
    input wire mv_start,
    input wire [ADDR_W - 1 : 0] src_addr, dst_addr,
    input wire [7 : 0] mv_line_num,
    output wire mv_done
);

// Set done 
logic set_done;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        mv_done <= 0;
    else if (mv_start)
        mv_done <= 0;
    else if (set_done)
        mv_done <= 1;
end

// Flip src and dst addr
logic [ADDR_W - 1 : 0] src_addr_ff, dst_addr_ff;
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        src_addr_ff <= '0;
        dst_addr_ff <= '0;
    end
    else if (mv_start) begin
        src_addr_ff <= dst_addr;
        dst_addr_ff <= src_addr;
    end
end

// Store the fetched data
logic ram_d_ld;
always_ff @( posedge clk, negedge rst ) begin
    if (!rst)
        ram_d <= '0;
    else if (ram_d_ld)
        ram_d <= ram_q;
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
    ram_we = 0;
    ram_re = 0;

    ram_addr = src_addr_ff;
    ram_d_ld = 0;

    set_done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            if (mv_start) begin
                ram_re = 1;
                nxt_state = LOAD;
            end
        end 
        LOAD: begin
            ram_d_ld = 1;
            nxt_state = STORE;
        end
        default: begin
            ram_addr = dst_addr_ff;
            ram_we = 1;
            set_done = 1;
            nxt_state = IDLE;
        end
     endcase
end


endmodule

`default_nettype wire
