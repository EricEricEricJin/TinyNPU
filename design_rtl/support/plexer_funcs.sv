`default_nettype none

virtual class PlexerFunctions #(parameter N = 3);
    static function [$clog2(N) - 1 : 0] priority_encoder(input [N - 1 : 0] in);
        for (int i = 0; i < N; i++) begin
            if (in[i])
                return ($clog2(N))'i;
        end
        return ($clog2(N))'(N-1);   // todo: verify this!
    endfunction 
endclass //PlexerFunctions

`default_nettype wire 