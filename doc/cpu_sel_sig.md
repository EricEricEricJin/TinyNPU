| Type  | `rf_we` | `sw_en` | `op2_sel` | `wb_sel` | `pc_sel`   |
| ---   | ---     | ---     | ---       | ---      | ---        |
|R-Type | 1       | 0       | RD2       | ALUOUT   | NXTPC      |
|I-Type | 1       | 0       | I_IM      | ALUOUT   | NXTPC      |
|+JALR  | 1       | 0       | I_IM      | NXTPC    | ALUOUT     |
|+LW    | 1       | 0       | I_IM      | MEM_Q    | NXTPC      |
|S-Type | 0       | 1       | S_IM      | x        | NXTPC      |
|B-Type | 0       | 0       | x         | x        |  BCOMP ? B_IM : NXTPC |
|+LUI(U)| 1       | 0       | x         | U_IM     | NXTPC      |
|+AUIPC(U)|DO      | NOT       | SUPPORT | THIS    | DICK       |   // use OP1 SEL
|+JAL (J)| 1      | 0       | /