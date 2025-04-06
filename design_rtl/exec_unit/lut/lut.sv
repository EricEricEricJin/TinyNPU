`default_nettype none

module lut #(
    parameter int N = 176
) (
    input wire clk, 
    input wire rst_n,

    // -------- LUT RAM --------
    output logic [7 : 0] x_i,
    input wire [7 : 0] y_i,

    // -------- Input Output --------
    input wire [N * 8 - 1 : 0]      X_in,
    input wire start,
    output logic [N * 8 - 1 : 0]    Y_out,
    output logic done
);


//////////////////////////////
// Counter
//////////////////////////////
logic [$clog2(N) - 1 : 0] cnt;
logic cnt_inc, cnt_clr;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        cnt <= '0;
    else if (cnt_clr)
        cnt <= '0;
    else if (cnt_inc)
        cnt <= cnt + 1;
end

/////////////////////////////
// Pack Unpack Store 
/////////////////////////////
logic store;

logic [7 : 0] x_unpacked [N];
logic [7 : 0] y_unpacked [N];
genvar i;
generate
    for (i = 0; i < N; i++) begin: blk_unpack_xy
        assign x_unpacked[i] = X_in[i * 8 +: 8];
        assign Y_out[i * 8 +: 8] = y_unpacked[i];
    end
endgenerate

assign x_i = x_unpacked[cnt];
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < N; i++)
            y_unpacked[i] <= '0;
    end else if (store) begin
        y_unpacked[cnt-1] <= y_i;
    end
end



/////////////////////////////
// State Machine
/////////////////////////////
typedef enum logic[1:0] { IDLE, RUN } state_t;
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end

always_comb begin

    cnt_inc = 0;
    cnt_clr = 0;
    store = 0;
    done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            done = 1;
            if (start) begin
                cnt_inc = 1;
                nxt_state = RUN;
            end
            else begin
                cnt_clr = 1;
            end
        end

        default: begin
            cnt_inc = 1;
            store = 1;
            if (cnt == N - 1)
                nxt_state = IDLE;
        end
    endcase
end

endmodule

`default_nettype wire 