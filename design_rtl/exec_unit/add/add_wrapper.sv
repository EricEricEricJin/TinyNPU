`default_nettype none


// no need scaling
module add_wrapper #( parameter int N = 176 ) (
    input wire clk, 
    input wire rst_n,

    // ------------------scaling and zeros------------------
    input wire [15 : 0]         s_a,
    input wire [15 : 0]         s_b,
    input wire signed [7 : 0]   z_tot,

    // ----------------------- inputs -----------------------
    input wire [N * 8 - 1 : 0] a,
    input wire [N * 8 - 1 : 0] b,

    // ----------------------- outputs -----------------------
    output logic [N * 8 - 1 : 0] c,

    // ----------------------- control -----------------------
    input wire              fetch,
    input wire              exec,
    input wire [31 : 0]     fetch_addr,
    output logic            done
);

// genvar i;
// generate
//     for (i = 0; i < N; i++) begin: blk_add
//         assign c[i * 8 +: 8] = $signed(a[i * 8 +: 8]) + $signed(b[i * 8 +: 8]);
//     end
// endgenerate
    
endmodule

`default_nettype wire 