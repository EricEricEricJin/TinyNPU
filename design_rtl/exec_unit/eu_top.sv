`default_nettype none

module eu_top #(
    
) (
    input wire clk, rst_n,

    // ---------- Avalon MM Read ----------
    sdram_read_intf i_sdram_read_intf,

    // ---------- RMIO ----------
    rmio_intf rmio_stmm [4],
    // todo

    // ---------- Control Unit eu_ctrl_intf ----------
    input wire [4 : 0] sdram_read_sel,
    eu_ctrl_intf ctrl_intf_stmm,
    // todo

    // ---------- States ----------
    output logic fetch_done,
    output logic [27 : 0] exec_done
);

localparam int STMM_SUB_NUM = 4;

// ---------- Done signals ----------
logic stmm_fetch_done;
logic [STMM_SUB_NUM - 1 : 0] stmm_exec_done;

// todo 

assign fetch_done = stmm_fetch_done;
assign exec_done = {24'b0, stmm_exec_done};

////////////////////////
// SDRAM Read Mux
////////////////////////
sdram_read_intf i_sdram_read_intf_arr [32] ();
sdram_read_mux #( .NUM_PORTS (32) ) i_sdram_read_mux (
    .sel(sdram_read_sel),
    .i_sdram_read_intf_in(i_sdram_read_intf_arr),
    .i_sdram_read_intf_out(i_sdram_read_intf)
);

////////////////////////
// EU Groups 
////////////////////////
stmm_wrapper #( .SUB_NUM (4), .N (176), .SDRAM_W (128) ) i_stmm_wrapper (
    .clk(clk),
    .rst_n(rst_n),

    .i_rmio_intf(rmio_stmm),

    .i_sdram_read_intf(i_sdram_read_intf_arr[0]),

    .i_eu_ctrl_intf(ctrl_intf_stmm),

    .fetch_done(stmm_fetch_done),
    .exec_done(stmm_exec_done)
);

// todo


endmodule

`default_nettype wire
