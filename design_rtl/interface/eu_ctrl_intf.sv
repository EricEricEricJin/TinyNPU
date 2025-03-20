`default_nettype none

interface eu_ctrl_intf #(
    parameter int SDRAM_ADDR_W = 32,
    parameter int SUB_NUM = 4
);

logic fetch;
logic exec;

logic [$clog2(SUB_NUM) - 1 : 0]  sub_idx;
logic [SDRAM_ADDR_W - 1 : 0]    fetch_addr;

modport exec_unit ( input fetch, exec, sub_idx, fetch_addr );
modport ctrl_unit ( output fetch, exec, sub_idx, fetch_addr );

endinterface //eu_ctrl_intf

`default_nettype wire 

