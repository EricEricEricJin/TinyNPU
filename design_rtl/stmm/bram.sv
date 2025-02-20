module bram #(
    parameter int L = 176,
    parameter int W = 128
) (
    input wire clk,
    input wire [$clog2(L) - 1 : 0] addr,
    output logic [W - 1 : 0] data
);

// BRAM
logic [W - 1 : 0] mem[0 : L - 1];

// flop addr
logic [$clog2(L) - 1 : 0] addr_ff;
always_ff @( posedge clk) begin
    addr_ff <= addr;
end

// flop q
always_ff @( posedge clk ) begin
    data <= mem[addr];
end


// initialize mem for testing
localparam MEM_FILE = "mem_w.hex";
initial $readmemh(MEM_FILE, mem);

endmodule

