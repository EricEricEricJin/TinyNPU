`default_nettype none

module 

import pkg_cpu_types::*;

cpu (
    input logic clk, rst_n,

    // to inst mem 
    output logic [13 : 0] inst_addr,
    input logic [31 : 0] inst_data,

    // to data mem
    output logic [13 : 0] data_addr,
    output logic data_we,
    inout wire [31 : 0] data_d, data_q

    // register-mapped IOs
    output logic [31 : 0] start_io,
    input logic [31 : 0] done_io,

    // memory-mapped IOs
    input logic [31 : 0] h2f_io [0 : 3],
    output logic [31 : 0] f2h_io [0 : 3],

    output logic ebreak
);

// pc
logic [31 : 0] prgm_cnt;
logic [31 : 0] prgm_cnt_d;

// function commands
br_fun_t br_fun;
alu_fun_t alu_fun;

// sel and en signals
logic rf_we;
logic sw_en;
op1_sel_t op1_sel;
op2_sel_t op2_sel;
wb_sel_t wb_sel;
pc_sel_t pc_sel;

// immediate values 
logic [11 : 0] s_im, i_im;
logic [12 : 1] b_im;
logic [31 : 12] u_im;
logic [20 : 1] j_im;

// rf32
logic [4 : 0] ra1, ra2, rf_wa; 
logic [31 : 0] rf_wd;
logic [31 : 0] rf_rd1, rf_rd2;

// ALU
logic [31 : 0] alu_in0, alu_in1, alu_out;

// BR
logic bcomp;

////////////////////////
// Program counter
////////////////////////
always_comb begin
    case (pc_sel)
        NXT_PC: prgm_cnt_d = prgm_cnt + 32'h4;
        BCOMP: begin
            if (bcomp) prgm_cnt_d = prgm_cnt +  {{19{b_im[12]}}, b_im, 1'b0};
            else       prgm_cnt_d = prgm_cnt + 32'h4;
        end
        PLUS_JIM: prgm_cnt_d = prgm_cnt + {{11{j_im[20]}} , j_im, 1'b0};
        default:  prgm_cnt_d = {alu_out[31 : 1], 1'b0};
    endcase
end

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        prgm_cnt <= '0;
    else
        prgm_cnt <= prgm_cnt_d;
end

assign inst_addr = prgm_cnt_d;

////////////////////////
// Inst decoder 
////////////////////////
inst_decode i_inst_decode (
    .inst       (inst_data),

    .br_fun     (br_fun),
    .alu_fun    (alu_fun),

    .rs1        (ra1),
    .rs2        (ra2),
    .rd         (rf_wa),

    .wb_sel     (wb_sel),
    .op1_sel    (op1_sel),
    .op2_sel    (op2_sel),
    .pc_sel     (pc_sel),

    .sw_en      (sw_en),
    .rf_we      (rf_we),
    
    .i_im       (i_im),
    .s_im       (s_im),
    .b_im       (b_im),
    .u_im       (u_im),
    .j_im       (j_im)
);

////////////////////////
// register file 
////////////////////////
rf32 i_rf32 (
    .clk    (clk),
    .rst_n  (rst_n),
    
    .ra1    (ra1),
    .ra2    (ra2),

    .wa     (rf_wa),
    .we     (rf_we),
    .wd     (rf_wd),

    .rd1    (rf_rd1),
    .rd2    (rf_rd2)
);


////////////////////////
// ALU 
////////////////////////

always_comb begin
    case (op1_sel)
        RD1:     alu_in0 = rf_rd1;
        default: alu_in0 = prgm_cnt;
    endcase

    case (op2_sel)
        2'h0: alu_in1 = rf_rd2;
        2'h1: alu_in1 = i_im;
        2'h2: alu_in1 = s_im;
        default: alu_in1 = '0;
    endcase
end

alu i_alu (
    .alu_in0    (alu_in0),
    .alu_in1    (alu_in1),
    .u_fun      (alu_fun),
    .alu_out    (alu_out)
);

////////////////////////
// BR logic
////////////////////////
br_logic i_br_logic (
    .rd1    (rf_rd1),
    .rd2    (rf_rd2),
    .br_fun (br_fun),
    .bcomp  (bcomp)
);

////////////////////////
// Data mem connection
////////////////////////
assign data_addr = alu_out[15 : 2];
assign data_d = rf_rd2;
assign data_we = sw_en;

// NOTE: USE TWO LW instructions to load a word!!

////////////////////////
// RF write back
////////////////////////
always_comb begin
    case (wb_sel)
        ALU_OUT:    rf_wd = alu_out;
        MEM_Q:      rf_wd = data_q;
        U_IM:       rf_wd = {u_im, 12'b0};
        default:    rf_wd = prgm_cnt + 32'h4;
    endcase
end

endmodule

`default_nettype wire 