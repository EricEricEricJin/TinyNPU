`default_nettype none

module eu_top #(
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    // ---------- Avalon MM Read ----------
    sdram_read_intf i_sdram_read_intf,

    // ---------- RMIO ----------
    rmio_intf rmio_stmm [4],
    // todo

    // ---------- Control Unit signals ----------
    input wire [4 : 0] sdram_read_sel,

    input wire [31 : 0] eu_fetch,
    input wire [31 : 0] eu_exec,
    input wire [31 : 0] eu_fetch_addr,

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

// determine sel signal
localparam int REAL_SDRAM_NUM_PORTS = 8;
logic [$clog2(REAL_SDRAM_NUM_PORTS) - 1 : 0] real_sdram_read_sel;
always_comb begin
    // case(sdram_read_sel) inside
    casex(sdram_read_sel)
        5'b000??: real_sdram_read_sel = ($clog2(REAL_SDRAM_NUM_PORTS))'(0);
        default: real_sdram_read_sel = '0;
    endcase
end

sdram_read_intf i_sdram_read_intf_arr [REAL_SDRAM_NUM_PORTS] ();
sdram_read_mux #( .NUM_PORTS (REAL_SDRAM_NUM_PORTS) ) i_sdram_read_mux (
    .sel(real_sdram_read_sel),
    .i_sdram_read_intf_in(i_sdram_read_intf_arr),
    .i_sdram_read_intf_out(i_sdram_read_intf)
);

logic [STMM_SUB_NUM-1 : 0] stmm_fetch, stmm_exec;
assign stmm_fetch = eu_fetch[STMM_SUB_NUM-1:0];
assign stmm_exec = eu_exec[STMM_SUB_NUM-1:0];

////////////////////////
// EU Groups 
////////////////////////
stmm_wrapper #( .SUB_NUM (STMM_SUB_NUM), .N (176), .SDRAM_W (SDRAM_W) ) i_stmm_wrapper (
    .clk(clk),
    .rst_n(rst_n),

    .i_rmio_intf(rmio_stmm),

    .i_sdram_read_intf(i_sdram_read_intf_arr[0]),

    // .i_eu_ctrl_intf(ctrl_intf_stmm),
    .fetch(stmm_fetch),
    .exec(stmm_exec),
    .fetch_addr(eu_fetch_addr),

    .fetch_done(stmm_fetch_done),
    .exec_done(stmm_exec_done)
);

// todo


endmodule

`default_nettype wire
