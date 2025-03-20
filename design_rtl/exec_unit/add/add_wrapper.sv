`default_nettype none

// NOTE:
// Currently use seperate fetcher for each adder
// Later change to multi-EU single-fetcher

module add_wrapper #( 
    parameter int N = 176,
    parameter int SDRAM_DATA_W = 128,
) (
    input wire clk, 
    input wire rst_n,

    rmio_intf i_rmio_intf,
    sdram_read_intf i_sdram_read_intf,

    eu_ctrl_intf i_eu_ctrl_intf,

    output logic fetch_done,
    output logic exec_done
);


//////////////////////////
// Parameter Fetcher
//////////////////////////
logic [15 : 0]         s_a, sa_nf;
logic [15 : 0]         s_b, sb_nf;
logic signed [7 : 0]   z_tot, z_tot_nf;
logic fetch_valid;

add_fetch #( .SDRAM_DATA_W(SDRAM_DATA_W) ) i_add_fetch (
    .clk                (clk),
    .rst_n              (rst_n),

    .i_sdram_read_intf  (i_sdram_read_intf),

    .s_a                (sa_nf),
    .s_b                (sb_nf),
    .z_tot              (z_tot_nf),

    .start              (i_eu_ctrl_intf.fetch),
    .addr               (i_eu_ctrl_intf.fetch_addr),
    .valid              (fetch_valid),
    .done               (fetch_done)
);

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        s_a <= 0;
        s_b <= 0;
        z_tot <= 0;
    end
    else if (fetch_valid) begin
        s_a <= sa_nf;
        s_b <= sb_nf;
        z_tot <= z_tot_nf;
    end
end

//////////////////////////
// buffer inputs
//////////////////////////
logic [N * 8 - 1 : 0] a;
logic [N * 8 - 1 : 0] b;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        a <= 0;
        b <= 0;
    end
    else if (i_rmio_intf.input_we[0]) begin
        a <= i_rmio_intf.input_data;
    end else if (i_rmio_intf.input_we[1]) begin
        b <= i_rmio_intf.input_data;
    end
end

//////////////////////////
// Adder 
//////////////////////////
add #( .N(N) ) add_inst (
    .clk        (clk),
    .rst_n      (rst_n),

    .s_a        (s_a),
    .s_b        (s_b),
    .z_tot      (z_tot),

    .a          (a),
    .b          (b),
    .c          (i_rmio_intf.output_data),

    .start      (i_eu_ctrl_intf.exec),
    .done       (exec_done)
);

endmodule

`default_nettype wire
