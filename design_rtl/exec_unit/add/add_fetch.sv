`default_nettype none

module add_fetch #(
    parameter int SDRAM_DATA_W = 128
) (
    input wire clk,
    input wire rst_n,

    // ------------------ To AVMM ------------------
    sdram_read_intf i_sdram_read_intf,

    // ------------------ To Adder ------------------
    output logic [15 : 0]       s_a,
    output logic [15 : 0]       s_b,
    output logic signed [7 : 0] z_tot,

    // ------------------ To Control Unit ------------------
    input wire start,
    input wire [31 : 0] addr,
    output logic valid,
    output logic done
);

////////////////////////// 
// Flop data and unpack 
//////////////////////////
// logic [SDRAM_DATA_W - 1 : 0] data;
// always_ff @( posedge clk, negedge rst_n ) begin
//     if (!rst_n)
//         data <= 0;
//     else if (i_sdram_read_intf.read_valid)
//         data <= i_sdram_read_intf.read_data;
// end

assign s_a = i_sdram_read_intf.read_data[0 +: 16];
assign s_b = i_sdram_read_intf.read_data[32 +: 16];
assign z_tot = i_sdram_read_intf.read_data[64 +: 8];

assign i_sdram_read_intf.read_start = start;
assign valid = i_sdram_read_intf.read_valid;
assign done = i_sdram_read_intf.read_done;

assign i_sdram_read_intf.read_addr = addr;
assign i_sdram_read_intf.read_cnt = 1;

endmodule

`default_nettype wire
