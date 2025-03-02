`default_nettype none

module ctrl_unit (
    input wire clk, rst_n,

    // connect to IO
    input wire [31 : 0] h2f_io,
    input wire h2f_write,
    output logic [31 : 0] f2h_io,

    // connect to BRAM
    output wire xram_addr_sel,   // by fetcher or sth
    // todo 

    // load and store to external
    output logic [24 : 0] bram_addr,

    // execute 
    output wire [4 : 0] fun,
    output wire [7 : 0] ra1, ra2, wa,
    
    output wire start_ex, start_fetch_param;
    // output wire [31 : 0] ex_start_bits,

    output wire x1_ld, x2_ld,

    // connect to state signals
    input wire [31 : 0] done_signals

);

// fetched register
logic [176 * 8 - 1 : 0] reg_buf;

// Three types of operations:
// READ->WRITE
// READ->SDRAM_STORE
// SDRAM_LOAD->WRITE


typedef enum logic[2 : 0] { 
    TYPE_M = 3'b00,  
    TYPE_V = 3'b01,  
    TYPE_M2V = 3'b10,
    TYPE_V2M = 3'b10,
    TYPE_LD
    TYPE_SD
    TYPE_LP
} inst_type_t;

logic [1 : 0] op;
logic [4 : 0] fun_unit;
logic [24 : 0] sdram_addr;
logic [7 : 0] ra1, ra2, wa;
logic dual_input;

assign {op, fun_unit, sdram_addr} = h2f_io;
assign {ra1, ra2, wa} = h2f_io[23 : 0];
assign dual_inpumemt = h2f_io[24];

typedef enum logic [3 : 0] { IDLE, DECODE, XRAM_LD, XRAM_ST, FU_FETCH_PARAM, EX_X1_LD, EX_X2_LD, EX_START } state_t;
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin
    nxt_state = state;

    case (state)
        IDLE: begin
            if (h2f_write)
                nxt_state = DECODE;
        end
        DECODE: begin
            case (op)
                OP_XRAM_LD: begin
                    // todo
                end
                OP_XRAM_ST: begin
                    // todo
                end
                OP_FU_FETCH: begin
                    start_fetch_param = 1;
                    nxt_state = IDLE;
                end
                default: begin  // FU_EX
                    start_ex = 1;
                    nxt_state = IDLE;
                end 
            endcase
            bram_addr = ra1;
        end
        XRAM_LD: begin
            // todo
            nxt_state = IDLE;
        end
        XRAM_ST: begin
            // todo
            nxt_state = IDLE;
        end
        EX_X1_LD: begin
            if (dual_input) begin
                // todo
                x1_ld = 1;
                xram_addr = ra2;
                nxt_state = EX_X2_LD;
            end
            else begin
                nxt_state = EX_START;
            end
        end
        EX_X2_LD: begin
            x2_ld = 1;
            nxt_state = EX_START;
        end
        default:  begin // EX_START
            start = 1; 
            nxt_state = IDLE;
        end
    endcase
end



endmodule


`default_nettype wire 