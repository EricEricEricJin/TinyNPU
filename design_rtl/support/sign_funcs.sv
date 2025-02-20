`default_nettype none

virtual class SignFunctions 
#(
    parameter IN_W = 16,
    parameter OUT_W = 8
);
    static function [OUT_W - 1 : 0] saturate(input [IN_W - 1 : 0] in);
        return in[IN_W - 1]  && !(&in[IN_W - 2 : OUT_W - 1]) ? {1'b1, {(OUT_W - 1){1'b0}}} : 
             (!in[IN_W - 1]) &&  (|in[IN_W - 2 : OUT_W - 1]) ? {1'b0, {(OUT_W - 1){1'b1}}} : in[OUT_W - 1 : 0];
    endfunction

    static function [OUT_W - 1 : 0] extend (input [IN_W - 1 : 0] in);
        return {{(OUT_W - IN_W){in[IN_W - 1]}}, in};
    endfunction
endclass

`default_nettype wire 
