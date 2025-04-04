`default_nettype none

module hps_bfm (
    input wire clk,
    input wire rst_n,

    output logic [31 : 0] h2f_pio32,
    output logic h2f_write,
    input wire [31 : 0] f2h_pio32,
    input wire f2h_write,

    output logic sim_stop
);

initial begin
    sim_stop = 0;
    h2f_pio32 = 32'h0;
    h2f_write = 0;

    @(posedge rst_n);
    @(negedge clk);

    `include "simulation/hps_prgms/test_prgm.sv"

    // // - load from sdram to line 0
    // h2f_pio32 = {2'b00, 9'h0, 13'h0, 8'd166};
    // h2f_write = 1;
    // @(negedge clk) h2f_write = 0;
    // @(posedge f2h_pio32[30]) $display("Load Done");
    // @(negedge clk);

    // // - move from line 0 to line 167
    // // h2f_pio32 = {2'b10, 10'h0, 10'd167, 2'b00, 8'd166};
    // // h2f_write = 1;
    // // @(negedge clk) h2f_write = 0;
    // // @(posedge f2h_pio32[31]) $display("MOVE Done");
    // // @(negedge clk);

    // // stmm fetch
    // h2f_pio32 = {2'b11, 1'b0, 5'h0, 24'h0};
    // h2f_write = 1;
    // @(negedge clk) h2f_write = 0;
    // @(posedge f2h_pio32[28]) $display("Fetch Done");
    // @(negedge clk);

    // // move to StMM
    // h2f_pio32 = {2'b10, 10'h0, 10'h200, 2'b00, 8'h1};
    // h2f_write = 1;
    // @(negedge clk) h2f_write = 0;
    // @(posedge f2h_pio32[31]) $display("Move Done");
    // @(negedge clk);

    // repeat(100) @(negedge clk);

    // // StMM exec
    // h2f_pio32 = {2'b11, 1'b1, 5'h0, 24'h0};
    // h2f_write = 1;
    // @(negedge clk) h2f_write = 0;
    // @(posedge f2h_pio32[0]) $display("StMM Exec Done");
    // @(negedge clk);

    // // extract from StMM
    // h2f_pio32 = {2'b10, 10'h208, 10'd167, 2'b00, 8'h1};
    // h2f_write = 1;
    // @(negedge clk) h2f_write = 0;
    // @(posedge f2h_pio32[31]) $display("Extract Done");
    // @(negedge clk);

    // // - store to sdram
    // h2f_pio32 = {2'b01, 9'd167, 13'h1000, 8'h1};
    // h2f_write = 1;
    // @(negedge clk) h2f_write = 0;
    // @(posedge f2h_pio32[30]) $display("Store Done");
    // @(negedge clk);

    sim_stop = 1;

end
    
endmodule

`default_nettype wire
