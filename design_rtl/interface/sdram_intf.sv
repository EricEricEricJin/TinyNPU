`default_nettype none

interface sdram_intf #(
    parameter int SDRAM_DATA_W = 128
);

// ----------------- for read and write -----------------
logic [31:0]                  rw_addr;
logic [10:0]                  rw_cnt;
logic                         rw_done;

// ----------------- for read -----------------
logic                         read_start;
logic                         read_valid;
logic [SDRAM_DATA_W - 1 : 0]  read_data;

// ----------------- for write -----------------
logic                         write_start;
logic                         write_nxt;
logic [SDRAM_DATA_W - 1 : 0]  write_data;

modport ldst(
    output rw_addr, rw_cnt, read_start, write_start, write_data,
    input rw_done, read_valid, read_data, write_nxt
);

modport avmm_slave(
    input rw_addr, rw_cnt, read_start, write_start, write_data,
    output rw_done, read_valid, read_data, write_nxt
);

endinterface

`default_nettype wire
