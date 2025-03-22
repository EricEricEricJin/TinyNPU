`default_nettype none

module hps_bfm (
    input wire clk,
    input wire rst_n,

    output logic [31 : 0] h2f_pio32,
    output logic h2f_write,
    input wire [31 : 0] f2h_pio32,
    input wire f2h_write
);


initial begin
    h2f_pio32 = 32'h0;
    h2f_write = 1'b0;

    @(posedge rst_n);
    @(negedge clk);

    
end
    
endmodule

`default_nettype wire