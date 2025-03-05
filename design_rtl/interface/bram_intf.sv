`default_nettype none

interface bram_intf #(
    parameter int ADDR_W = 10,
    parameter int DATA_W = 176*8
);

logic [ADDR_W - 1 : 0]  addr;
logic [DATA_W - 1 : 0]  data;
logic [DATA_W - 1 : 0]  q;
logic                   we;
logic                   re;

modport ram (
    input addr, data, we, re,
    output q
);

modport dut (
    input q,
    output addr, data, we, re
);

endinterface //bram_intf

`default_nettype none