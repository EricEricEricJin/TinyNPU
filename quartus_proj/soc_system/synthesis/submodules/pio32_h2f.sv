`default_nettype none

module pio32_h2f (
  input wire clk,
  input wire rst_n,

  input wire write_en_in,
  input wire [31 : 0] write_data_in,
  
  output logic write_en_out,
  output logic [31 : 0] write_data_out
);

always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n) 
        write_data_out <= '0;
    else if (write_en_in) 
        write_data_out <= write_data_in;
end

assign write_en_out = write_en_in;

endmodule

`default_nettype wire 
