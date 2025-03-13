`default_nettype none

interface rf_move_intf #(
    parameter int RF_ADDR_W  = 10,
    parameter int LINE_NUM_W = 8
);

  logic                      start;
  logic [ RF_ADDR_W - 1 : 0] src_addr;
  logic [ RF_ADDR_W - 1 : 0] dst_addr;
  logic [LINE_NUM_W - 1 : 0] line_num;
  logic                      src_freeze;
  logic                      dst_freeze;

  modport ctrl_unit(output start, src_addr, dst_addr, line_num, src_freeze, dst_freeze);
  modport rf_move(input start, src_addr, dst_addr, line_num, src_freeze, dst_freeze);

endinterface

`default_nettype wire
