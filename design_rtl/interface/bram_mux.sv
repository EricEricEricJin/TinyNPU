`default_nettype none

module bram_mux #(
    parameter int NUM_PORTS = 2,
    parameter int ADDR_W = 10,
    parameter int DATA_W = 176*8
) (
    input wire [$clog2(NUM_PORTS) - 1 : 0] sel,
    bram_intf.ram i_bram_intf_in [NUM_PORTS],
    bram_intf.dut i_bram_intf_out
);

genvar i;

logic we_arr [NUM_PORTS];
logic re_arr [NUM_PORTS];
logic [ADDR_W - 1 : 0] addr_arr [NUM_PORTS];
logic [DATA_W - 1 : 0] data_arr [NUM_PORTS];

generate
    for (i = 0; i < NUM_PORTS; i++) begin: blk_bram_mux
        assign we_arr[i] = i_bram_intf_in[i].we;
        assign re_arr[i] = i_bram_intf_in[i].re;
        assign addr_arr[i] = i_bram_intf_in[i].addr;
        assign data_arr[i] = i_bram_intf_in[i].data;
        assign i_bram_intf_in[i].q = i_bram_intf_out.q;
    end
endgenerate

assign i_bram_intf_out.addr = addr_arr[sel];
assign i_bram_intf_out.data = data_arr[sel];
assign i_bram_intf_out.we = we_arr[sel];
assign i_bram_intf_out.re = re_arr[sel];

endmodule

`default_nettype wire
