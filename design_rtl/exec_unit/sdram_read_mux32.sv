`default_nettype none

module sdram_read_mux_32 (
    input wire [4 : 0]  sel,
    sdram_read_intf     in_intf[0 : 31],
    sdram_read_intf     out_intf
);

// Direct combinational assignments
assign out_intf.read_addr  = in_intf[sel].read_addr;
assign out_intf.read_cnt   = in_intf[sel].read_cnt;
assign out_intf.read_start = in_intf[sel].read_start;

genvar i;
generate
    for (i = 0; i < 32; i++) begin : gen_out
        assign in_intf[i].read_data = out_intf.read_data;
        assign in_intf[i].read_done = out_intf.read_done;
        assign in_intf[i].read_valid = out_intf.read_valid;
    end
endgenerate

endmodule

`default_nettype wire