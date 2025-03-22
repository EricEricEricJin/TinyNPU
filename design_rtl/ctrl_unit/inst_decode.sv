`default_nettype none

module inst_decode #(
    parameter int RF_ADDR_W = 10,
    parameter logic [14 : 0] SDRAM_OFFSET = 15'h1000
) (
    input wire [31 : 0] inst,

    output logic load, 
    output logic store,
    output logic move,
    output logic fetch,       // command this exec unit to start fetch
    output logic exec,         // command this exec unit to start execute

    // connect to ldst
    output logic [RF_ADDR_W - 1 : 0]    ldst_rf_addr,
    output logic [31 : 0]               ldst_sdram_addr,  // already bit-extended
    output logic [7 : 0]                ldst_line_num,

    // connect to rf mover
    output logic [RF_ADDR_W - 1 : 0]    move_src_addr, 
    output logic [RF_ADDR_W - 1 : 0]    move_dst_addr,
    output logic [7 : 0]                move_line_num,
    output logic                        move_src_freeze,
    output logic                        move_dst_freeze,

    // connect to all fetch operations
    output wire [4 : 0]     eu_group_idx, // the group index
    output wire [3 : 0]     eu_sub_idx,
    output logic [31 : 0]   eu_fetch_addr
);

// LDST: 2^13 * 176 = 176KB
// Fetch: 2^24 * 


/*
LOAD / STORE:
| OP[31:30] | RF_ADDR[29:21] | SDRAM_ADDR[20:8] | LINE_NUM[7:0] |

MOVE: 
| OP[31:30] | SRC[29:20]      | DST[19:10]    | NC[9:8] | LINE_NUM[7:0] |

FETCH / EXEC: 
| OP[31:30] | FUN[29] | EU [28:24] | FETCH_ADDR[23:0] |

*/

typedef enum logic[1:0] {
    OP_LOAD = 2'b00,
    OP_STORE = 2'b01,
    OP_MOVE = 2'b10,
    OP_FETCH_EXEC = 2'b11
} op_t;

op_t inst_op;
assign inst_op =  op_t'(inst[31 : 30]);

// Load Store RF and SDRAM address
assign ldst_rf_addr = inst[29 : 21];
assign ldst_sdram_addr = {SDRAM_OFFSET, inst[20 : 8], 4'b0};
assign ldst_line_num = inst[7 : 0];

// Move
assign move_src_addr = inst[29 : 20];
assign move_dst_addr = inst[19 : 10];
assign move_src_freeze = inst[9];
assign move_dst_freeze = inst[8];
assign move_line_num = inst[7 : 0];

// Exec Unit command
logic eu_fun;
assign eu_fun = inst[29];

// assign eu_unit = inst[28 : 24];
assign eu_group_idx = inst[28 : 24];
assign eu_sub_idx = inst[23 : 20];

assign eu_fetch_addr = {4'b0, inst[23 : 0], 4'b0};

// Command signals
always_comb begin
    load = 0;
    store = 0;
    move = 0;
    fetch = 0;
    exec = 0;
    
    case (inst_op)
        OP_LOAD:    load = 1;
        OP_STORE:   store = 1;
        OP_MOVE:    move = 1;
        
        OP_FETCH_EXEC: begin
            if (eu_fun == 1'b0)
                fetch = 1;
            else 
                exec = 1;
        end
        
        default: begin
            // do nothing
        end
    endcase
end


endmodule

`default_nettype wire 
