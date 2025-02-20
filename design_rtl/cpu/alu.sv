`default_nettype none

module 

import pkg_cpu_types::*;

alu (
    input logic [31 : 0] alu_in0, alu_in1,
    input alu_fun_t u_fun,
    output logic [31 : 0] alu_out,
    output logic err_ufun_unk
);

always_comb begin
    alu_out = 32'b0;
    err_ufun_unk = 0;

    case (u_fun)
        // arithmatic
        ADD: alu_out = $signed(alu_in0) + $signed(alu_in1);
        SUB: alu_out = $signed(alu_in0) - $signed(alu_in1);
        
        // bit-wise logic
        XOR: alu_out = alu_in0 ^ alu_in1;
        OR:  alu_out = alu_in0 | alu_in1;
        AND: alu_out = alu_in0 & alu_in1;
        
        // bit shift
        SLL: alu_out = alu_in0 << alu_in1;
        SRL: alu_out = alu_in0 >> alu_in1;
        SRA: alu_out = alu_in0 >>> alu_in1;

        // compare
        SLT: if ($signed(alu_in0) < $signed(alu_in1)) alu_out = 32'h1; else alu_out = 32'h0;
        SLTU: if (alu_in0 < alu_in1) alu_out = 32'h1; else alu_out = 32'h0;        

        default: begin alu_out = 32'b0; err_ufun_unk = 1; end 
    endcase
end

endmodule

`default_nettype wire 