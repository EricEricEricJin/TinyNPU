`default_nettype none

// import pkg_plexer_funcs::*;
// `include "plexer_funcs.sv"

// import pkg_rf_ldst_intf::*;

module ctrl_unit #(
    parameter int RF_ADDR_W = 10
) (
    input wire clk, rst_n,

    // connect to AvMM IO
    input wire [31 : 0] h2f_io,
    input wire          h2f_write,

    // state 
    output logic isrunning,

    rf_move_intf rf_move,   // connect to mover
    rf_ldst_intf rf_ldst,   // connect to load-storer
    
    output logic rf_ram_sel,          // select ram in rf_wrapper, 1: ldst, 0: move
    

    // connect to EU
    output logic [31 : 0] eu_fetch,
    output logic [31 : 0] eu_exec,
    output logic [31 : 0] eu_fetch_addr

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


// inst decoder
logic load, store, move, fetch, exec;
logic [4 : 0]   eu_unit;

inst_decode i_inst_decode (
    .inst               (h2f_io),

    .load               (load),
    .store              (store),
    .move               (move),
    .fetch              (fetch),
    .exec               (exec),

    // .ldst_rf_addr       (ldst_rf_addr),
    // .ldst_sdram_addr    (ldst_sdram_addr),
    // .ldst_line_num      (ldst_line_num),
    .ldst_rf_addr       (rf_ldst.rf_addr),
    .ldst_sdram_addr    (rf_ldst.sdram_addr),
    .ldst_line_num      (rf_ldst.line_num),


    // .move_src_addr      (move_src_addr),
    // .move_dst_addr      (move_dst_addr),
    // .move_line_num      (move_line_num),
    .move_src_addr     (rf_move.src_addr),
    .move_dst_addr     (rf_move.dst_addr),
    .move_src_freeze   (rf_move.src_freeze),
    .move_dst_freeze   (rf_move.dst_freeze),
    .move_line_num     (rf_move.line_num),

    .eu_unit            (eu_unit),
    .eu_fetch_addr      (eu_fetch_addr)
);

logic [31 : 0] eu_unit_onehot;
// assign eu_unit_onehot = PlexerFunctions #(.N(32)) :: decoder (eu_unit);
decoder #(.N(32)) i_eu_decoder (
    .in     (eu_unit),
    .out    (eu_unit_onehot)
);

typedef enum logic [1 : 0] { IDLE, DECODE, ISSUE } state_t;
state_t state, nxt_state;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin

    // load_start = 0;
    // store_start = 0;
    rf_ldst.load_start = 0;
    rf_ldst.store_start = 0;

    // move_start = 0;
    rf_move.start = 0;

    set_ram_sel_ldst = 0;
    set_ram_sel_move = 0;

    eu_exec = '0;
    eu_fetch = '0;

    isrunning = 1;

    nxt_state = state;

    case (state)
        IDLE: begin
            isrunning = 0;

            if (h2f_write)
                nxt_state = DECODE;
        end
        
        DECODE: begin
            set_ram_sel_ldst = load || store;   // connect RAM 1 cycle in advance
            set_ram_sel_move = move;
            nxt_state = ISSUE;
        end
        
        default: begin  // ISSUE
            rf_ldst.load_start = load;
            rf_ldst.store_start = store;
            rf_move.start = move;

            // unique0 
            // damn intel quartus... it supports nothing!!!
            if (exec)
                eu_exec = eu_unit_onehot;
            else if (fetch)
                eu_fetch = eu_unit_onehot;
            
            nxt_state = IDLE;
        end
    endcase
end



endmodule


`default_nettype wire 