`default_nettype none

import pkg_cpu_types::*;

module inst_decode (

    input wire [31 : 0] inst,

    // for CPU
    // output logic         beq, blt, bge, bne,
    output br_fun_t br_fun,
    output logic [4 : 0] rs1, rs2, rd,

    output alu_fun_t alu_fun,
    output wb_sel_t wb_sel,    
    output op1_sel_t op1_sel,
    output op2_sel_t op2_sel,
    output pc_sel_t pc_sel,  
    
    output logic         sw_en,
    output logic         rf_we,
    
    output logic [11 : 0]  i_im, s_im, 
    output logic [12 : 1]  b_im,
    output logic [31 : 12] u_im, 
    output logic [20 : 1]  j_im,

    output logic err_op_unk
);


logic [6 : 0] op;
logic [2 : 0] fun3;
logic [6 : 0] fun7;

assign op = inst[6 : 0];

////////////////////////
// determine types
////////////////////////
typedef enum logic[2 : 0] { R_TYPE, I_TYPE, S_TYPE, B_TYPE, U_TYPE, J_TYPE, UNK_TYPE } inst_type_t;
inst_type_t inst_type;

always_comb begin
    err_op_unk = 0;

    case (op) inside
        7'h23: inst_type = S_TYPE;
        7'h33: inst_type = R_TYPE;
        7'h63: inst_type = B_TYPE;
        7'h6f: inst_type = J_TYPE;
        7'h17, 7'h37: inst_type = U_TYPE;
        7'h03, 7'h13, 7'h67, 7'h73: inst_type = I_TYPE;
        default: begin inst_type = UNK_TYPE; err_op_unk = 1; end
    endcase
end

////////////////////////
// unpack inst 
////////////////////////
always_comb begin
    {rd, rs1, rs2, fun3, fun7, i_im, s_im, b_im, u_im, j_im} = 'x;

    case (inst_type)
        R_TYPE: {fun7, rs2, rs1, fun3, rd} = inst[31 : 7];
        I_TYPE: {i_im, rs1, fun3, rd} = inst[31 : 7];
        S_TYPE: {s_im[11 : 5], rs2, rs1, fun3, s_im[4 : 0]} = inst[31 : 7];
        B_TYPE: {b_im[12], b_im[10 : 5], rs2, rs1, fun3, b_im[4 : 1], b_im[11]} = inst[31 : 7];
        U_TYPE: {u_im, rd} = inst[31 : 7];
        J_TYPE: {j_im[20], j_im[10 : 1], j_im[11], j_im[19 : 12], rd} = inst[31 : 7];
        default: begin end // UNK
    endcase
end

////////////////////////
// determain comp and alu signals 
////////////////////////
always_comb begin
    case (fun3)
        3'h0: br_fun = BR_BEQ;
        3'h1: br_fun = BR_BNE;
        3'h4: br_fun = BR_BLT;
        default: br_fun = BR_BGE; 
    endcase
end

always_comb begin
    case (inst_type) inside
        {I_TYPE, R_TYPE}: begin
            case (fun3)
                3'b001: alu_fun = ALU_SLL;
                3'b010: alu_fun = ALU_SLT;
                3'b011: alu_fun = ALU_SLTU;
                3'b100: alu_fun = ALU_XOR;
                3'b101: begin
                    if (fun7 == 7'h0) alu_fun = ALU_SRL;
                    else alu_fun = ALU_SRA;
                end
                3'b110: alu_fun = ALU_OR;
                3'b111: alu_fun = ALU_AND;
                default: begin  // 0
                    if (inst_type == R_TYPE && fun7 == 7'b0100000)
                        alu_fun = ALU_SUB;
                    else
                        alu_fun = ALU_ADD;
                end 
            endcase
        end
        default: alu_fun = ALU_ADD; 
    endcase
end

////////////////////////
// determain sel signals
////////////////////////
always_comb begin
    rf_we = 0;
    sw_en = 0;
    
    wb_sel = WB_ALU_OUT;
    op1_sel = OP1_RD1;
    op2_sel = OP2_RD2;
    pc_sel = PC_NXT_PC;

    case (inst_type)
        R_TYPE: begin
            rf_we = 1;
            sw_en = 0;
            op1_sel = OP1_RD1;
            op2_sel = OP2_RD2;
            wb_sel = WB_ALU_OUT;
            pc_sel = PC_NXT_PC;
        end

        I_TYPE: begin
            rf_we = 1;
            sw_en = 0;
            op1_sel = OP1_RD1;
            op2_sel = OP2_I_IM;
            if (op == 7'h67 && fun3 == 3'h0) begin  // JALR
                wb_sel = WB_NXT_PC;
                pc_sel = PC_ALU_OUT;
            end else if (op == 7'h3 && fun3 == 3'h2) begin  // LW
                wb_sel = WB_MEM_Q;
                pc_sel = PC_NXT_PC;
            end else begin
                wb_sel = WB_ALU_OUT;
                pc_sel = PC_NXT_PC;
            end
        end
        S_TYPE: begin
            rf_we = 0;
            sw_en = 1;
            op1_sel = OP1_RD1;
            op2_sel = OP2_S_IM;
            // wb_sel = 'x;
            pc_sel = PC_NXT_PC;
        end
        B_TYPE: begin
            rf_we = 0;
            sw_en = 0;
            // op1_sel = 'x;
            // op2_sel = 'x;
            // wb_sel = 'x;
            pc_sel = PC_BCOMP;
        end
        U_TYPE: begin
            rf_we = 1;
            sw_en = 0;
            op1_sel = OP1_PC;
            op2_sel = OP2_U_IM;
            
            if (op == 7'h37)    // LUI
                wb_sel = WB_U_IM;
            else // AUIPC
                wb_sel = WB_ALU_OUT;
            
            pc_sel = PC_NXT_PC;
        end
        J_TYPE: begin
            rf_we = 1;
            sw_en = 0;
            // op1_sel = 'x;
            // op2_sel = 'x;
            wb_sel = WB_NXT_PC;
            pc_sel = PC_PLUS_JIM;
        end
        default: begin end 
    endcase
end


endmodule

`default_nettype wire
