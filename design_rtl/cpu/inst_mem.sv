`default_nettype none

module inst_mem #(parameter int DEPTH = 256) (
    input wire [$clog2(DEPTH) - 1 : 0] addr,
    input wire              clk,
    input wire [31 : 0]     data,
    input wire              we,
    output wire [31 : 0]    q
);

logic [31 : 0] mem_reg [0 : DEPTH - 1];

// Read
assign q = mem_reg[addr];

// Write 
always_ff @( posedge clk ) begin
    if (we)
        mem_reg[addr] <= data;
end

endmodule

`default_nettype wire 