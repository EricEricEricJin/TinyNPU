`default_nettype none

module count_down #(
    parameter int N = 7
) (
    input wire clk,
    input wire rst_n,
    input wire start,
    output logic done 
);

logic do_count, reset_counter;
logic [$clog2(N) - 1 : 0] counter;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        counter <= '0;
    else if (reset_counter)
        counter <= ($clog2(N))'(N);
    else if (do_count)
        counter <= counter - ($clog2(N))'(1);
end

typedef enum logic { IDLE, CNTD } state_t;
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin
    do_count = 0;
    reset_counter = 0;    
    done = 0;
    nxt_state = state;

    case (state)
        IDLE: begin
            if (start) begin
                reset_counter = 1;
                nxt_state = CNTD;
            end
        end

        default: begin
            do_count = 1;
            if (counter == 0) begin
                done = 1;
                nxt_state = IDLE;
            end
        end 
    endcase
end

endmodule

`default_nettype wire 