`default_nettype none


interface rf_ldst_intf #(
    parameter int RF_ADDR_W = 10,
    parameter int LINE_NUM_W = 8,
    parameter int SDRAM_ADDR_W = 32
);

  logic load_start;
  logic store_start;
  logic [RF_ADDR_W - 1 : 0] rf_addr;
  logic [SDRAM_ADDR_W - 1 : 0] sdram_addr;
  logic [LINE_NUM_W - 1 : 0] line_num;


  modport ctrl_unit(output load_start, store_start, rf_addr, sdram_addr, line_num);
  modport rf_ldst(input load_start, store_start, rf_addr, sdram_addr, line_num);

endinterface  //rf_ldst_intf

// endpackage

`default_nettype wire
