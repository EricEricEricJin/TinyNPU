`default_nettype none

module design_top (
    input wire clk, rst_n,
    
    // connect to sdram_read_wrapper
    sdram_read_wrapper_intf mem_read_intf,

    // connect to MMIO
    input wire [31 : 0] h2f_pio32,
    input wire h2f_write,
    output logic [31 : 0] f2h_pio32
);

// CPU



endmodule

`default_nettype wire 