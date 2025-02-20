`default_nettype none

module pio32_f2h (
    input logic clk,
    input logic rst_n,
  
    input logic [31 : 0] read_data_in,
    output logic read_en_out,

    input logic read_en_in,
    output logic [31 : 0] read_data_out
);

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        read_data_out <= '0;
    else if (read_en_in)
        read_data_out <= read_data_in;
end

assign read_en_out = read_en_in;

endmodule

`default_nettype wire 
