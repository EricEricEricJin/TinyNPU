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

logic [$clog2(N) - 1 : 0] cnt;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        cnt <= '0;
    else if (start)
        cnt <= '0;
    else if (cnt == N)
        cnt <= '0;
    else
        cnt <= cnt + 1;
end

logic store;
assign store = (cnt != 0);

assign done = ~store;


// unpack X,Y
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

endmodule

`default_nettype wire 