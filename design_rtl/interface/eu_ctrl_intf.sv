`default_nettype none

interface eu_ctrl_intf #(
    parameter int SDRAM_ADDR_W = 32
);

logic fetch;
logic exec;
logic [SDRAM_ADDR_W - 1 : 0] fetch_addr;

modport exec_unit ( input fetch, exec, fetch_addr );
modport ctrl_unit ( output fetch, exec, fetch_addr );

endinterface //eu_ctrl_intf

`default_nettype wire 

