`default_nettype none

module rf_ram #(
    parameter int M = 256,
    parameter int RF_DATA_W = 176*8,
    parameter int RF_ADDR_W = 10,
    parameter int EU_NUM = 8
) (
    input wire clk,

    bram_intf ram,

    rmio_intf rmio [0 : EUNUM - 1]

);

// << The real BRAM >>
bram_intf #(.ADDR_W (9), .DATA_W (RF_DATA_W) ) real_ram();
ram_512x1408 i_real_ram (
    .clock      (clk),
    .address    (real_ram.addr),
    .we         (real_ram.we),
    .data       (real_ram.data),
    .q          (real_ram.q)
);

assign ram_addr = rf_addr[8 : 0];

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
    ADDR_STMM_0_X = 10'h200,
    ADDR_STMM_1_X = 10'h201,
    ADDR_STMM_2_X = 10'h202,
    ADDR_STMM_3_X = 10'h203,

    ADDR_STMM_0_Y = 10'h208,
    ADDR_STMM_1_Y = 10'h209,
    ADDR_STMM_2_Y = 10'h20a,
    ADDR_STMM_3_Y = 10'h20b,

    ADDR_LN_0_X = 10'h210,
    ADDR_LN_1_X = 10'h211,
    ADDR_LN_2_X = 10'h212,
    ADDR_LN_3_X = 10'h213,

    ADDR_LN_0_Y = 10'h218,
    ADDR_LN_1_Y = 10'h219,
    ADDR_LN_2_Y = 10'h21a,
    ADDR_LN_3_Y = 10'h21b,

    ADDR_SILU_0_X = 10'h220,
    ADDR_SILU_1_X = 10'h221,
    ADDR_SILU_2_X = 10'h222,
    ADDR_SILU_3_X = 10'h223,

    ADDR_SILU_0_Y = 10'h228,
    ADDR_SILU_1_Y = 10'h229,
    ADDR_SILU_2_Y = 10'h22a,
    ADDR_SILU_3_Y = 10'h22b,

    ADDR_ATT_0_Q = 10'h230,
    ADDR_ATT_1_Q = 10'h231,
    ADDR_ATT_2_Q = 10'h232,
    ADDR_ATT_3_Q = 10'h233,

} addr_t;

// determine ram_we and load signals
always_comb begin

    ram_we = 0;

    for (int i = 0; i < 4; i++)
        stmm_X_ld[i] = 0;
    for (int i = 0; i < 4; i++)
        layernorm_X_ld[i] = 0;

    if (rf_we) begin
        case (rf_addr)
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

// determine read signals
always_comb begin
    // set all to zero by default 
    att_out_read = 0;


    ram_re = 0;

    if (rf_re) begin
        case (rf_addr)
            ADDR_ATT_0_Y:  att_out_read = 1;
            default:       ram_re = 1;
        endcase
    end
end

// determine rf_q
always_comb begin
    case (rf_addr_ff)
        ADDR_STMM_0_Y:  rf_q = stmm_Y_data[0];
        ADDR_STMM_1_Y:  rf_q = stmm_Y_data[1];
        ADDR_STMM_2_Y:  rf_q = stmm_Y_data[2];
        ADDR_STMM_3_Y:  rf_q = stmm_Y_data[3];
        ADDR_LN_0_Y:    rf_q = layernorm_Y_data[0];
        ADDR_LN_1_Y:    rf_q = layernorm_Y_data[1];
        ADDR_LN_2_Y:    rf_q = layernorm_Y_data[2];
        ADDR_LN_3_Y:    rf_q = layernorm_Y_data[3];
        default:        rf_q = ram_q;
    endcase
end

endmodule

`default_nettype wire 
