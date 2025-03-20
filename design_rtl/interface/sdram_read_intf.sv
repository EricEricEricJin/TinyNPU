`default_nettype none

interface sdram_read_intf #(
    parameter int SDRAM_DATA_W = 128
);

logic [31:0]                  read_addr;
logic [10:0]                  read_cnt;
logic                         read_done;

logic                         read_start;
logic                         read_valid;
logic [SDRAM_DATA_W - 1 : 0]  read_data;

modport fetch (     // connect to fetcher
    output read_addr, read_cnt, read_start,
    input read_done, read_valid, read_data 
);

modport avmm (      // to AvMM Wrapper
    input read_addr, read_cnt, read_start,
    output read_done, read_valid, read_data
);

endinterface //sdram_read_intf

`default_nettype wire
