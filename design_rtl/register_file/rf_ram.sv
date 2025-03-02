`default_nettype none

module rf_ram #(
    parameter int M = 256,
    parameter int DATA_W = 176*8,
    parameter int ADDR_W = 9
) (
    input wire clk,

    // act as a normal Block RAM
    input wire [ADDR_W - 1 : 0] rf_addr,
    input wire [ADDR_W - 1 : 0] rf_d, 
    input wire [ADDR_W - 1 : 0] rf_q,
    input wire rf_we,

    // << memory mapped IOs >>

    // to four StMMs
    output logic [DATA_W - 1 : 0] stmm_X_data [0 : 3],
    output logic                  stmm_X_ld   [0 : 3],
    input wire  [DATA_W - 1 : 0]  stmm_Y_data [0 : 3],

    // to LayerNorm
    output logic [N - 1 : 0] layernorm_X_data [0 : 3],
    output logic             layernorm_X_ld   [0 : 3], 
    input wire  [N - 1 : 0]  layernorm_Y_data [0 : 3]    // to LayerNorm

    // to Attention
    // output wire [N - 1 : 0]         att_Q_data, att_K_data, att_V_data,
    // output wire [$clog2(M) - 1 : 0] att_Q_addr, att_K_addr, att_V_addr,
    // output wire                     att_Q_ld, att_K_ld, att_V_ld,


    // // to attention
    // output wire [$clog2(M) - 1 : 0] att_out_addr,
    // input wire [N - 1 : 0]          att_out_data,
    // input wire                      att_out_valid,

    
    // todo: to SiLU 


);

// << The real BRAM >>
logic [7 : 0] ram_addr;
logic ram_we;
logic [DATA_W - 1 : 0] ram_d;
logic [DATA_W - 1 : 0] ram_q;

assign ram_addr = rf_addr[7 : 0];

ram_256x1408 i_real_ram (
    .clock      (clk),
    .address    (ram_addr),
    .we         (ram_we),
    .data       (ram_d),
    .q          (ram_q)
);


// << Flip addr to keep sync with bram >>
logic [ADDR_W - 1 : 0] rf_addr_ff;
always_ff @( posedge clk ) begin
    rf_addr_ff <= rf_addr;
end

// Connect ram_d and all MM output into rf_d
always_comb begin
    for (int i = 0; i < 4; i++)
        stmm_X_data[i] = rf_d;

    for (int i = 0; i < 4; i++)
        layernorm_X_data[i] = rf_d;

    ram_d = rf_d;
end


typedef enum logic [ADDR_W - 1 : 0] { 
    ADDR_STMM_0_X = 9'h100,
    ADDR_STMM_1_X = 9'h101,
    ADDR_STMM_2_X = 9'h102,
    ADDR_STMM_3_X = 9'h103,

    ADDR_LN_0_X = 9'h110,
    ADDR_LN_1_X = 9'h111,
    ADDR_LN_2_X = 9'h112,
    ADDR_LN_3_X = 9'h113,

    ADDR_SILU_0_X = 9'h120,
    ADDR_SILU_1_X = 9'h121,
    ADDR_SILU_2_X = 9'h122,
    ADDR_SILU_3_X = 9'h123,

    ADDR_ATT_0_Q = 9'h130,
    ADDR_ATT_1_Q = 9'h131,
    ADDR_ATT_2_Q = 9'h132,
    ADDR_ATT_3_Q = 9'h133,

} addr_t;

// determine ram_we and load signals
always_comb begin

    ram_we = 0;

    for (int i = 0; i < 4; i++)
        stmm_X_ld[i] = 0;
    for (int i = 0; i < 4; i++)
        layernorm_X_ld[i] = 0;

    if (rf_we) begin
        case (rf_add)
            ADDR_STMM_0_X:  stmm_X_ld[0] = 1;
            ADDR_STMM_1_X:  stmm_X_ld[1] = 1;
            ADDR_STMM_2_X:  stmm_X_ld[2] = 1;
            ADDR_STMM_3_X:  stmm_X_ld[3] = 1;
            ADDR_LN_0_X:    layernorm_X_ld[0] = 1;
            ADDR_LN_1_X:    layernorm_X_ld[1] = 1;
            ADDR_LN_2_X:    layernorm_X_ld[2] = 1;
            ADDR_LN_3_X:    layernorm_X_ld[3] = 1;
            default:        ram_we = 1;
        endcase
    end
end

// determine rf_q
always_comb begin
    case (rf_addr_ff)
        ADDR_STMM_0_X:  rf_q = stmm_Y_data[0];
        ADDR_STMM_1_X:  rf_q = stmm_Y_data[1];
        ADDR_STMM_2_X:  rf_q = stmm_Y_data[2];
        ADDR_STMM_3_X:  rf_q = stmm_Y_data[3];
        ADDR_LN_0_X:    rf_q = layernorm_Y_data[0];
        ADDR_LN_1_X:    rf_q = layernorm_Y_data[1];
        ADDR_LN_2_X:    rf_q = layernorm_Y_data[2];
        ADDR_LN_3_X:    rf_q = layernorm_Y_data[3];
        default:        rf_q = ram_q;
    endcase
end

endmodule

`default_nettype wire 
