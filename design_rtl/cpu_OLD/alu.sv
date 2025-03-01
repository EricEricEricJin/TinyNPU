`default_nettype none


import pkg_cpu_types::*; 

module alu (
    input wire [31 : 0] alu_in0, alu_in1,
    input wire pkg_cpu_types::alu_fun_t u_fun,
    
    output logic [31 : 0] alu_out,
    output logic err_ufun_unk
);


always_comb begin
    alu_out = 32'b0;
    err_ufun_unk = 0;

    case (u_fun)
        // arithmatic
        ALU_ADD: alu_out = $signed(alu_in0) + $signed(alu_in1);
        ALU_SUB: alu_out = $signed(alu_in0) - $signed(alu_in1);
        
        // bit-wise logic
        ALU_XOR: alu_out = alu_in0 ^ alu_in1;
        ALU_OR:  alu_out = alu_in0 | alu_in1;
        ALU_AND: alu_out = alu_in0 & alu_in1;
        
        // bit shift
        ALU_SLL: alu_out = alu_in0 << alu_in1;
        ALU_SRL: alu_out = alu_in0 >> alu_in1;
        ALU_SRA: alu_out = alu_in0 >>> alu_in1;

        // compare
        ALU_SLT: if ($signed(alu_in0) < $signed(alu_in1)) alu_out = 32'h1; else alu_out = 32'h0;
        ALU_SLTU: if (alu_in0 < alu_in1) alu_out = 32'h1; else alu_out = 32'h0;        

        default: begin alu_out = 32'b0; err_ufun_unk = 1; end 
    endcase
end

endmodule

`default_nettype wire 