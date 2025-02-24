`default_nettype none

import pkg_cpu_types::*;

module br_logic (
    input wire signed [31 : 0] rd1, rd2,
    input wire br_fun_t br_fun,
    output logic bcomp
);

always_comb begin
    case (br_fun)
        BR_BEQ: bcomp = (rd1 == rd2);
        BR_BNE: bcomp = (rd1 != rd2);
        BR_BLT: bcomp = ($signed(rd1) < $signed(rd2));
        default: bcomp = ($signed(rd1) >= $signed(rd2));
    endcase
end

endmodule

`default_nettype wire 
