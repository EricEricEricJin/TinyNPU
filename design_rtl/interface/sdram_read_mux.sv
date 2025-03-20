`default_nettype none

module sdram_read_mux #(
    parameter int NUM_PORTS = 2
) (
    input wire [$clog2(NUM_PORTS) - 1 : 0] sel,
    sdram_read_intf i_sdram_read_intf_in [NUM_PORTS],
    sdram_read_intf i_sdram_read_intf_out
);

genvar i;

logic [31:0]    read_addr_arr [NUM_PORTS];
logic [10:0]    read_cnt_arr [NUM_PORTS];
logic           read_start_arr [NUM_PORTS];

generate
    for (i = 0; i < NUM_PORTS; i++) begin: blk_sdram_read_mux
        assign read_addr_arr[i] = i_sdram_read_intf_in[i].read_addr;
        assign read_cnt_arr[i] = i_sdram_read_intf_in[i].read_cnt;
        assign read_start_arr[i] = i_sdram_read_intf_in[i].read_start;
        assign i_sdram_read_intf_in[i].read_done = i_sdram_read_intf_out.read_done;
        assign i_sdram_read_intf_in[i].read_valid = i_sdram_read_intf_out.read_valid;
        assign i_sdram_read_intf_in[i].read_data = i_sdram_read_intf_out.read_data;
    end
endgenerate

assign i_sdram_read_intf_out.read_addr = read_addr_arr[sel];
assign i_sdram_read_intf_out.read_cnt = read_cnt_arr[sel];
assign i_sdram_read_intf_out.read_start = read_start_arr[sel];

endmodule

`default_nettype wire