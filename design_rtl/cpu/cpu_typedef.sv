package pkg_cpu_types;

// typedef enum logic [2 : 0] { SUB, ADD, OR, AND, SLLI } alu_fun_t;
typedef enum logic [3 : 0] {    
    ADD, SUB, 
    AND, OR, XOR, 
    SLL, SRL, SRA,    
    SLT, SLTU, 
} alu_fun_t;

typedef enum logic[1 : 0] { BEQ, BNE, BLT, BGE } br_fun_t;

typedef enum logic         { RD1, PC } op1_sel_t;
typedef enum logic [1 : 0] { RD2, I_IM, S_IM, U_IM } op2_sel_t;
typedef enum logic [1 : 0] { ALU_OUT, MEM_Q, U_IM, NXT_PC } wb_sel_t;
typedef enum logic [1 : 0] { NXT_PC, BCOMP, PLUS_JIM, ALU_OUT } pc_sel_t;


endpackage