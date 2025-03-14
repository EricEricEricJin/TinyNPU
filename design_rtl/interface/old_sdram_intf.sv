`default_nettype none

// Read-only, for parameter fetching
interface sdram_read_intf #(
    parameter int SDRAM_DATA_W = 128,
    parameter int SDRAM_ADDR_W = 32
);
  logic [SDRAM_ADDR_W - 1 : 0] address;
  logic [SDRAM_ADDR_W - 1 : 0] burstcount;
  logic                        waitrequest;
  logic [SDRAM_DATA_W - 1 : 0] readdata;
  logic                        readdatavalid;
  logic                        read;

  modport fetcher(input waitrequest, readdata, readdatavalid, output address, burstcount, read);

  modport avmm_slave(input address, burstcount, read, output waitrequest, readdata, readdatavalid);
endinterface


// RW, for LDST
interface sdram_intf #(
    parameter int SDRAM_DATA_W = 128,
    parameter int SDRAM_ADDR_W = 32
);
  logic [SDRAM_ADDR_W - 1 : 0] address;
  logic [              10 : 0] burstcount;
  logic                        waitrequest;
  logic [SDRAM_DATA_W - 1 : 0] readdata;
  logic                        readdatavalid;
  logic                        read;
  logic [SDRAM_DATA_W - 1 : 0] writedata;
  logic [              15 : 0] byteenable;
  logic                        write;

  modport ldst(
      input waitrequest, readdata, readdatavalid,
      output address, burstcount, read, writedata, byteenable, write
  );

  modport avmm_slave(
      input address, burstcount, read, writedata, byteenable, write,
      output waitrequest, readdata, readdatavalid
  );
endinterface



`default_nettype wire
