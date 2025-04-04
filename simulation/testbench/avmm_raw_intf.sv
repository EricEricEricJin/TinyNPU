`default_nettype none


interface avmm_raw_intf #( parameter int SDRAM_W = 128 );

logic [31 : 0]           address;
logic [10 : 0]           burstcount;
logic                    waitrequest;

logic                    read;
logic [SDRAM_W - 1 : 0]  readdata;
logic                    readdatavalid;

logic                    write;
logic [SDRAM_W - 1 : 0]  writedata;
logic [15 : 0]           byteenable;

modport master (
    output address, burstcount, read, write, writedata, byteenable,
    input waitrequest, readdata, readdatavalid
);

modport slave (
    input address, burstcount, read, write, writedata, byteenable,
    output waitrequest, readdata, readdatavalid
);

endinterface

`default_nettype wire