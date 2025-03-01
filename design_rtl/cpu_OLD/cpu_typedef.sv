`default_nettype none

package pkg_cpu_types;

// typedef enum logic [2 : 0] { SUB, ADD, OR, AND, SLLI } alu_fun_t;
typedef enum logic [3 : 0] {    
    ALU_ADD, ALU_SUB, 
    ALU_AND, ALU_OR, ALU_XOR, 
    ALU_SLL, ALU_SRL, ALU_SRA,    
    ALU_SLT, ALU_SLTU 
} alu_fun_t;

typedef enum logic [1 : 0] { BR_BEQ, BR_BNE, BR_BLT, BR_BGE } br_fun_t;
typedef enum logic         { OP1_RD1, OP1_PC } op1_sel_t;
typedef enum logic [1 : 0] { OP2_RD2, OP2_I_IM, OP2_S_IM, OP2_U_IM } op2_sel_t;
typedef enum logic [1 : 0] { WB_ALU_OUT, WB_MEM_Q, WB_U_IM, WB_NXT_PC } wb_sel_t;
typedef enum logic [1 : 0] { PC_NXT_PC, PC_BCOMP, PC_PLUS_JIM, PC_ALU_OUT } pc_sel_t;

endpackage

`default_nettype wire 
