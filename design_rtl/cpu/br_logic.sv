`default_nettype none

module 

import pkg_cpu_types::*;

br_logic (
    input logic signed [31 : 0] rd1, rd2,
    input br_fun_t br_fun,
    output logic bcomp
);

// assign bcomp = (beq && rd1 == rd2) 
//             || (bne && rd1 != rd2) 
//             || (blt && rd1 < rd2) 
//             || (bge && rd1 >= rd2);

always_comb begin
    case (br_fun)
        BEQ: bcomp = (rd1 == rd2);
        BNE: bcomp = (rd1 != rd2);
        BLT: bcomp = ($signed(rd1) < $signed(rd2));
        default: bcomp = ($signed(rd1) >= $signed(rd2));
    endcase
end

endmodule

`default_nettype wire 