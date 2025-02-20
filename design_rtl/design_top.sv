`default_nettype none

module design_top (
    input logic clk, rst_n,
    
    // connect to sdram_read_wrapper
    sdram_read_wrapper_intf mem_read_intf,

    // connect to MMIO
    input logic [31 : 0] h2f_pio32,
    output logic [31 : 0] f2h_pio32
);

// CPU
cpu i_cpu (
    .clk        (clk),
    .rst_n      (rst_n),
    .inst_addr  (inst_addr)
    // todo
);
    
endmodule

`default_nettype wire 