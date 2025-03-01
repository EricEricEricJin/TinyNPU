`default_nettype none

interface sdram_read_intf #(parameter int SDRAM_W = 128);
    logic [31:0]       address;
    logic [10:0]       burstcount;
    logic              waitrequest;
    logic [SDRAM_W - 1 : 0] readdata;
    logic readdatavalid;
    logic read;

    modport FPGA (
        input waitrequest, readdata, readdatavalid,
        output address, burstcount, read 
    );

    modport slave (
        input address, burstcount, read,
        output waitrequest, readdata, readdatavalid
    );
endinterface 

interface sdram_intf #(parameter int SDRAM_W = 128);
    
    logic [31:0]            address;
    logic [10:0]            burstcount;
    logic                   waitrequest;
    logic [SDRAM_W - 1 : 0] readdata;
    logic                   readdatavalid;
    logic                   read;
    logic [SDRAM_W - 1 : 0] writedata;
    logic [15 : 0]          byteenable;
    logic                   write;

    modport FPGA (
        input waitrequest, readdata, readdatavalid,
        output address, burstcount, read, writedata, byteenable, write
    );

    modport HPS (
        input address, burstcount, read, writedata, byteenable, write,
        output waitrequest, readdata, readdatavalid
    );
endinterface



`default_nettype wire 