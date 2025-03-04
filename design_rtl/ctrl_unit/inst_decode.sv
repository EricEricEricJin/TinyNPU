`default_nettype none

module inst_decode (
    input wire [31 : 0] inst,

    output logic load, 
    output logic store,
    output logic move,
    output logic fetch,       // command this exec unit to start fetch
    output logic exec,         // command this exec unit to start execute

    // connect to ldst
    output logic [8 : 0] ldst_rf_addr,
    output logic [31 : 0] ldst_sdram_addr,  // already bit-extended

    // connect to rf mover
    output logic [8 : 0] move_src_addr, 
    output logic [8 : 0] move_dst_addr,


    // connect to all fetch operations
    output wire [4 : 0] eu_unit, // the exec unit index
    output logic [31 : 0] eu_fetch_addr,
);

typedef enum logic[1:0] {
    TYPE_LDST = 2'b00,
    TYPE_MOVE = 2'b01,
    TYPE_FETCH_EXEC = 2'b10,
} inst_type_t;

inst_type_t inst_type;
logic inst_op;
assign {inst_type, inst_op} = inst[31 : 29];

// Load Store RF and SDRAM address
assign ldst_rf_addr = inst[28 : 20];
assign ldst_sdram_addr = {10'b0, inst[19 : 0], 2'b0};   // x4

// Move
assign {move_src_addr, move_dst_addr} = inst[28 : 11];

// Exec Unit command
assign eu_unit = inst[28 : 24];
assign eu_fetch_addr = {6'b0, inst[23 : 0], 2'b0};


always_comb begin
    load = 0;
    store = 0;
    move = 0;
    fetch = 0;
    exec = 0;
    
    case (inst_type)
        TYPE_LDST: begin
            if (inst_op == 1'b0)
                load = 1;
            else
                store = 1;
        end

        TYPE_MOVE: begin
            move = 1;
        end
        
        TYPE_FETCH_EXEC: begin  // FETCH_EXEC
            if (op == 1'b0)
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