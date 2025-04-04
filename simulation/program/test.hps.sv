`define hps i_hps_bfm

`define N 3

`hps.npu_fetch(clk, `N, 32'h2000_0000);
`hps.npu_wait(clk, 32'(1<<28));

`hps.npu_load(clk, 0, 32'h3000_0000, 8'd166);
`hps.npu_wait(clk, 32'(1<<30));

`hps.npu_move(clk, 0, 10'h200+`N, 0, 0, 1);
`hps.npu_wait(clk, 32'(1<<31));

`hps.npu_exec(clk, `N);
`hps.npu_wait(clk, 32'(1<<`N));

`hps.npu_move(clk, 10'h208+`N, 10'd167, 0, 0, 1);
`hps.npu_wait(clk, 32'(1<<31));

`hps.npu_store(clk, 167, 32'h3001_0000, 1);
`hps.npu_wait(clk, 32'(1<<30));

`undef hps