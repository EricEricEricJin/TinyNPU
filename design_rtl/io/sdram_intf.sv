`default_nettype none

interface sdram_read_wrapper_intf #(parameter int SDRAM_W = 128);
    logic [31:0]       read_addr;      // base address
    logic [10:0]       read_cnt;       // burst count
    logic              read_start;     // start

    logic              out_valid;     // current data is valid
    logic  [10:0]      out_idx;       // index, 0 <= i < cnt       
    logic  [SDRAM_W - 1 : 0]   out_data;

    modport master (
        input out_valid, out_idx, out_data,
        output read_addr, read_cnt, read_start
    );

    modport slave (
        input read_addr, read_cnt, read_start,
        output out_valid, out_idx, out_data
    );
endinterface 

interface sdram_read_intf #(parameter int SDRAM_W = 128);
    logic [SDRAM_W - 1 : 0] readdata;
    logic         readdatavalid;
    logic         waitrequest;

    logic         read;
    logic [31:0]  address;
    logic [10:0]  burstcount;

    modport master (
        input readdata, readdatavalid, waitrequest,
        output read, address, burstcount
    );

    modport slave (
        input read, address, burstcount,
        output readdata, readdatavalid, waitrequest
    );
endinterface

`default_nettype wire 