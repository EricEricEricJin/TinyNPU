`default_nettype none

import pkg_plexer_funcs::*;

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

    // connect to mover
    // output logic                        move_start,
    // output logic [RF_ADDR_W - 1 : 0]    move_src_addr, 
    // output logic [RF_ADDR_W - 1 : 0]    move_dst_addr,
    // output logic [7 : 0]                move_line_num,
    rf_move_intf rf_move,

    // connect to load-storer
    // output logic                        load_start, 
    // output logic                        store_start,
    // output logic [RF_ADDR_W - 1 : 0]    ldst_rf_addr,
    // output logic [31 : 0]               ldst_sdram_addr,
    // output logic [7 : 0]                ldst_line_num,
    rf_ldst_intf rf_ldst,

    // connect to EU
    output logic [31 : 0] eu_fetch,
    output logic [31 : 0] eu_exec,
    output logic [31 : 0] eu_fetch_addr

);

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
assign eu_unit_onehot = PlexerFunctions #(.N(32)) :: decoder (eu_unit);

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
            nxt_state = ISSUE;
        end
        
        default: begin  // ISSUE
            // load_start = load;
            // store_start = store;
            rf_ldst.load_start = load;
            rf_ldst.store_start = store;

            // move_start = move;
            rf_move.start = move;

            unique0 if (exec)
                eu_exec = eu_unit_onehot;
            else if (fetch)
                eu_fetch = eu_unit_onehot;
            
            nxt_state = IDLE;
        end
    endcase
end



endmodule


`default_nettype wire 