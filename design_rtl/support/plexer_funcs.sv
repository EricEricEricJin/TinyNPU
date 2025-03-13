// The f**king Intel Quartus doesn't support virtual class for synthesis at all!!! 
// so parameterized functions cannot be implmented   

// `default_nettype none

// package pkg_plexer_funcs;

// virtual class PlexerFunctions #(parameter N = 3);
//     static function logic [$clog2(N) - 1 : 0] priority_encoder(input [N - 1 : 0] in);
//         for (int i = 0; i < N; i++) begin
//             if (in[i])
//                 return ($clog2(N))'(i);
//         end
//         return ($clog2(N))'(N-1);   // todo: verify this!
//     endfunction

//     static function logic [N - 1 : 0] decoder (input [$clog2(N) - 1 : 0] in);
//         decoder = '0;
//         decoder[in] = 1'b1;
//     endfunction
// endclass //PlexerFunctions

// endpackage

// `default_nettype wire 
