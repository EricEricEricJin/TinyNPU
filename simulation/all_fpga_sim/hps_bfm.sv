`default_nettype none

package hps_bfm_pkg;

class hpsBfm #(
    parameter int H2F_PIO_W = 32,
    parameter int F2H_PIO_W = 32
);

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


    task run(ref logic clk);
        `include "simulation/hps_prgms/test_prgm.sv"
    endtask
    
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
