`timescale 1ps / 1ps
`default_nettype none

module fifo_tb;

logic clk, rst_n;
logic [127 : 0] data_in;
logic we_in;
bram_intf #(.ADDR_W(8), .DATA_W(8)) i_bram_intf ();
logic done;
  
lut_fifo_wrapper i_lut_fetch_fifo (
    .clk(clk),
    .rst_n(rst_n),
    
    .data_in(data_in),
    .we_in(we_in),
    .i_bram_intf(i_bram_intf),
    .done(done)
);

initial begin
    clk = 0;
    rst_n = 0;
    data_in = 0;
    we_in = 0;
    @(negedge clk) rst_n = 1;

    for (int i = 0; i < 16; i++) begin
        @(negedge clk) data_in = { { 32 {(4)'(i)} } };
        we_in = 1;
        @(negedge clk) we_in = 0;
        repeat (100) @(negedge clk);
    end

    forever @(negedge clk) if (done) break;
    
    repeat (5) @(negedge clk);

    $stop();    

end


always #10_000 clk = ~clk;

endmodule


`default_nettype wire