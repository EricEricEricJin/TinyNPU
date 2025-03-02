`default_nettype none

module register_file #(
    parameter int ADDR_W = 9
) (
    input wire clk, rst_n,
    
    // load and store to / from VRAM
    // todo: add SDRAM interface



    // read
    // input wire [ADDR_W - 1 : 0 : 0]  ra, // 9-bit address
    // input wire read_start,
    // output wire [N - 1 : 0] rd,
    // output wire read_valid,
    
    input wire [ADDR_W - 1 : 0] addr_src, addr_dst,
    input wire copy_start, copy_done,

    input wire [24 : 0] sdram_addr,
    input wire sdram_load, sdram_store,    

    // write
    input wire [ADDR_W - 1 : 0]  wa,
    input wire write_start,
    output wire [N - 1 : 0] wd,
    output wire write_done,

    // << memory mapped inputs >>
    // to Attention
    output wire [N - 1 : 0]         att_Q_data, att_K_data, att_V_data,
    output wire [$clog2(M) - 1 : 0] att_Q_addr, att_K_addr, att_V_addr,
    output wire                     att_Q_ld, att_K_ld, att_V_ld,

    // to four StMMs
    output wire [N - 1 : 0] stmm_X_data [0 : 3],
    output wire             stmm_X_ld [0 : 3],

    // to LayerNorm
    output wire [N - 1 : 0] layernorm_X_data,
    output wire             layernorm_X_ld, 

    // todo: to SiLU

    // << memory mapped outputs >>

    // to attention
    output wire [$clog2(M) - 1 : 0] att_out_addr,
    input wire [N - 1 : 0]          att_out_data,
    input wire                      att_out_valid,

    // to StMM
    input wire [N - 1 : 0]  stmm_Y_data [0 : 3],

    // to LayerNorm
    input wire [N - 1 : 0]  layernorm_Y_data,
    
    // todo: to SiLU 

);

typedef enum logic [ADDR_W - 1 : 0] { 
    ADDR_ATT_Q = // todo: assign address to all unit IOs
} addr_t;

// all normal read and write behaviors 

// todo: instantiate the real BRAM


always_comb begin
    case (ra)
        : 
        default: 
    endcase
end

    
endmodule

`default_nettype wire 