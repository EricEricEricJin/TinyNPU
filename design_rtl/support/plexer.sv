`default_nettype none

module priority_encoder #(parameter int N =3) (
    input wire      [N - 1 : 0]         in,
    output logic    [$clog2(N) - 1 : 0] out
);

always_comb begin
    out = '0;
    for (int i = 0; i < N; i++) begin
        if (in[i]) begin
            out = ($clog2(N))'(i);
            break;
        end
    end 
end

endmodule

module decoder #(parameter int N = 3) (
    input [$clog2(N) - 1 : 0] in,
    output logic [N - 1 : 0] out
);

always_comb begin
    out = '0;
    out[in] = 1'b1; 
end
    
endmodule


`default_nettype wire