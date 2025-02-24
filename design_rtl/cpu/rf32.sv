`default_nettype none

module rf32 (
    input wire  clk, rst_n,
    input wire [4 : 0] ra1, ra2, wa,
    input wire we,
    input wire [31 : 0] wd,
    output logic [31 : 0] rd1, rd2
);

// mem
logic [31 : 0] rf_mem [0 : 31];

// write
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < 16; i++)
            rf_mem[i] <= '0;
    end
    else if (we) begin
        rf_mem[wa] <= wd;
    end
end

// read

assign rd1 = (ra1 != 5'h0) ? rf_mem[ra1] : '0;
assign rd2 = (ra2 != 5'h0) ? rf_mem[ra2] : '0;

endmodule

`default_nettype wire
