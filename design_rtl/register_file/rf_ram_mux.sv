`default_nettype none

module rf_ram_mux (
    bram_intf   dut0,
    bram_intf   dut1,
    bram_intf   ram,
    input wire  sel
);

always_comb begin
    dut0.q = ram.q;
    dut1.q = ram.q;

    if (sel) begin
        ram.addr = dut1.addr;
        ram.data = dut1.data;
        ram.we = dut1.we;
        ram.re = dut1.re;
    end
    else begin
        ram.addr = dut0.addr;
        ram.data = dut0.data;
        ram.we = dut0.we;
        ram.re = dut0.re;
    end
end
    
endmodule

`default_nettype wire 