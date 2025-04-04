`default_nettype none

package hps_bfm_pkg;

class hpsBfm #(
    parameter int H2F_PIO_W = 32,
    parameter int F2H_PIO_W = 32
);

    typedef enum logic[1:0] { 
        OP_LOAD = 2'b00,
        OP_STORE = 2'b01,
        OP_MOVE = 2'b10,
        OP_FETCH_EXEC = 2'b11
    } op_t;


    static logic [H2F_PIO_W - 1 : 0]   h2f_pio32;
    static logic                       h2f_write;
    static logic [F2H_PIO_W - 1 : 0]   f2h_pio32;
    static logic                       f2h_write;

    function new();
        this.h2f_pio32 = '0;
        this.h2f_write = 0;
    endfunction

    task automatic reset( ref logic clk, ref logic rst_n );
        @(negedge clk) rst_n = 0;
        @(negedge clk) rst_n = 1;
    endtask

    local task _npu_load_store(ref logic clk, input op_t op, input logic [8:0] rf_addr, input logic [31:0] sdram_addr, input logic [7:0] line_num);
        h2f_pio32 = {op, rf_addr, sdram_addr[16:4], line_num};
        h2f_write = 1;
        @(negedge clk) h2f_write = 0;
    endtask

    task npu_load(ref logic clk, input logic [8:0] rf_addr, input logic [31:0] sdram_addr, input logic [7:0] line_num);
        _npu_load_store(clk, OP_LOAD, rf_addr, sdram_addr, line_num);
    endtask

    task npu_store(ref logic clk, input logic [8:0] rf_addr, input logic [31:0] sdram_addr, input logic [7:0] line_num);
        _npu_load_store(clk, OP_STORE, rf_addr, sdram_addr, line_num);
    endtask

    task npu_move(ref logic clk, input logic [9:0] src, input logic [9:0] dst, input logic src_frz, input logic dst_frz, input logic [7:0] line_num);
        h2f_pio32 = {OP_MOVE, src, dst, src_frz, dst_frz, line_num};
        h2f_write = 1;
        @(negedge clk) h2f_write = 0;
    endtask

    task npu_fetch(ref logic clk, input logic [4:0] unit, input logic [31:0] sdram_addr);
        h2f_pio32 = {OP_FETCH_EXEC, 1'b0, unit, sdram_addr[27:4]};
        h2f_write = 1;
        @(negedge clk) h2f_write = 0;
    endtask

    task npu_exec(ref logic clk, input logic [4:0] unit);
        h2f_pio32 = {OP_FETCH_EXEC, 1'b1, unit, 24'bx};
        h2f_write = 1;
        @(negedge clk) h2f_write = 0;
    endtask

    task npu_wait(ref logic clk, input logic [31:0] mask);
        @(negedge clk);
        @(posedge |(f2h_pio32 & mask));
        @(negedge clk);
    endtask


    // task run(ref logic clk, ref logic rst_n);
    //     `include "simulation/hps_prgms/test_prgm.sv"
    // endtask
    
/*
    task automatic run(
        ref logic clk,
        ref logic rst_n,

        ref logic [H2F_PIO_W - 1 : 0]   h2f_pio32,
        ref logic                       h2f_write,
        ref logic [F2H_PIO_W - 1 : 0]   f2h_pio32,
        ref logic                       f2h_write,
        ref bit                         sim_stop
    );

    sim_stop = 0;
    h2f_pio32 = '0;
    h2f_write = 0;

    // Reset from HPS
    @(negedge clk) rst_n = 0;
    @(negedge clk) rst_n = 1;
    
    `include "simulation/hps_prgms/test_prgm.sv"

    @(negedge clk) sim_stop = 1;

    endtask //automatic
*/

endclass //hpsBfm

endpackage

`default_nettype wire
