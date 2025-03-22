`default_nettype none

// import pkg_plexer_funcs::*;
// `include "plexer_funcs.sv"

// import pkg_rf_ldst_intf::*;

module ctrl_unit #(
    parameter int RF_ADDR_W = 10
) (
    input wire clk, rst_n,

    // ---------- connect to AvMM IO ----------
    input wire [31 : 0] h2f_io,
    input wire          h2f_write,

    // ---------- connect to RF ----------
    rf_move_intf rf_move,   // connect to mover
    rf_ldst_intf rf_ldst,   // connect to load-storer
    output logic rf_ram_sel,          // select ram in rf_wrapper, 1: ldst, 0: move

    // ---------- connect to SDRAM Fetch Mux ----------
    output logic [4 : 0] sdram_read_sel,

    // ---------- connect to EU groups ----------
    eu_ctrl_intf i_eu_ctrl_intf[32],

    // ---------- state ----------
    output logic done

);

////////////////////////
// Ram sel FF
////////////////////////
logic set_ram_sel_move, set_ram_sel_ldst;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        rf_ram_sel <= 0;
    else if (set_ram_sel_move)
        rf_ram_sel <= 0;
    else if (set_ram_sel_ldst)
        rf_ram_sel <= 1;
end


////////////////////////
// SDRAM Read Sel FF
////////////////////////
logic [4 : 0] nxt_sdram_read_sel;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        sdram_read_sel <= '0;
    else
        sdram_read_sel <= nxt_sdram_read_sel;
end

////////////////////////
// inst decoder
////////////////////////
logic load, store, move, fetch, exec;

logic [4 : 0]   eu_group_idx;
logic [3 : 0]   eu_sub_idx;
logic [31 : 0]  eu_fetch_addr;

inst_decode i_inst_decode (
    .inst               (h2f_io),

    .load               (load),
    .store              (store),
    .move               (move),
    .fetch              (fetch),
    .exec               (exec),

    .ldst_rf_addr       (rf_ldst.rf_addr),
    .ldst_sdram_addr    (rf_ldst.sdram_addr),
    .ldst_line_num      (rf_ldst.line_num),

    .move_src_addr     (rf_move.src_addr),
    .move_dst_addr     (rf_move.dst_addr),
    .move_line_num     (rf_move.line_num),
    .move_src_freeze   (rf_move.src_freeze),
    .move_dst_freeze   (rf_move.dst_freeze),

    .eu_group_idx       (eu_group_idx),
    .eu_sub_idx         (eu_sub_idx),
    .eu_fetch_addr      (eu_fetch_addr)
);

logic [31 : 0] eu_group_onehot;
decoder #(.N(32)) i_eu_decoder (
    .in     (eu_group_idx),
    .out    (eu_group_onehot)
);

////////////////////////
// Unpacked exec and fetch array
////////////////////////
logic [31 : 0] eu_fetch;
logic [31 : 0] eu_exec;

genvar i;
generate
    for (i = 0; i < 32; i++) begin: blk_conn_eu_ctrl_intf
        assign i_eu_ctrl_intf[i].fetch = eu_fetch[i];
        assign i_eu_ctrl_intf[i].exec = eu_exec[i];
        assign i_eu_ctrl_intf[i].sub_idx = eu_sub_idx;
        assign i_eu_ctrl_intf[i].fetch_addr = eu_fetch_addr;
    end
endgenerate

typedef enum logic [1 : 0] { IDLE, DECODE, ISSUE } state_t;
state_t state, nxt_state;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin

    rf_ldst.load_start = 0;
    rf_ldst.store_start = 0;

    rf_move.start = 0;

    set_ram_sel_ldst = 0;
    set_ram_sel_move = 0;
    nxt_sdram_read_sel = sdram_read_sel;

    eu_exec = '0;
    eu_fetch = '0;

    done = 0;

    nxt_state = state;

    case (state)
        IDLE: begin
            done = 1;
            if (h2f_write)
                nxt_state = DECODE;
        end
        
        DECODE: begin
            set_ram_sel_ldst = load || store;
            set_ram_sel_move = move;
            nxt_sdram_read_sel = eu_group_idx;

            nxt_state = ISSUE;
        end
        
        default: begin  // ISSUE
            rf_ldst.load_start = load;
            rf_ldst.store_start = store;
            rf_move.start = move;

            if (exec)
                eu_exec = eu_group_onehot;
            else if (fetch)
                eu_fetch = eu_group_onehot;
            
            nxt_state = IDLE;
        end
    endcase
end

endmodule


`default_nettype wire
