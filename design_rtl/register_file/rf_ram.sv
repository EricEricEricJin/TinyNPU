`default_nettype none

module rf_ram #(
    parameter int RF_DATA_W = 176*8,
    parameter int RF_ADDR_W = 10
) (
    input wire clk,         
    input wire rst_n,

    // === Export BRAM interface ===
    bram_intf ram,

    // === RMIOs ===
    rmio_intf rmio_stmm,
    rmio_intf rmio_layernorm    [0 : 3],
    rmio_intf rmio_silu         [0 : 3],
    rmio_intf rmio_att          [0 : 0]

);

//////////////////////////////
// The real BRAM
//////////////////////////////
localparam int REAL_RAM_ADDR_W = 9;

bram_intf #(.ADDR_W (REAL_RAM_ADDR_W), .DATA_W (RF_DATA_W) ) real_ram();

ram_512x1408 i_real_ram (
    .clock      (clk),
    .address    (real_ram.addr),
    .data       (real_ram.data),
    .rden       (real_ram.re),
    .wren       (real_ram.we),
    .q          (real_ram.q)
);

assign real_ram.addr = ram.addr[REAL_RAM_ADDR_W - 1 : 0];

logic is_real_ram_addr;
assign is_real_ram_addr = ram.addr < 2**REAL_RAM_ADDR_W;

//////////////////////////////
// Flip addr to keep sync with bram
//////////////////////////////
logic [RF_ADDR_W - 1 : 0] addr_ff;
always_ff @( posedge clk ) begin
    addr_ff <= ram.addr;
end

//////////////////////////////
// Connect rmio input data and real_ram.d to ram.d
//////////////////////////////

logic [RF_DATA_W - 1 : 0] ram_data_ff;
always_ff @( posedge clk ) begin
    ram_data_ff <= ram.data;
end

logic [3 : 0] stmm_input_we;

// genvar i;
// generate
//     for (i = 0; i < 4; i++) begin: blk_connect_rmio_in_data
//         // assign rmio_stmm[i].input_data = ram.data;
//         assign rmio_stmm[i].input_data = ram_data_ff[i];
//         // assign rmio_layernorm[i].input_data = ram.data;
//         // assign rmio_silu[i].input_data = ram.data;
//     end
// endgenerate
assign rmio_stmm.input_data = ram_data_ff;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        rmio_stmm.input_we <= '0;
    else
        rmio_stmm.input_we <= stmm_input_we;
end

// Only one ATT
// assign rmio_att[0].input_data = ram.data;

assign real_ram.data = ram.data;

//////////////////////////////
// Defination of all memory-mapped IO addresses
//////////////////////////////
typedef enum logic [RF_ADDR_W - 1 : 0] { 
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
    ADDR_ATT_0_K = 10'h231,
    ADDR_ATT_0_V = 10'h232,
    ADDR_ATT_0_Y = 10'h238
    
} addr_t;

//////////////////////////////
// Determine write-enable and load signals
//////////////////////////////
always_comb begin

    // rmio_stmm.input_we = '0;
    stmm_input_we = '0;
    
    // rmio_layernorm[0].input_we = 0;
    // rmio_layernorm[1].input_we = 0;
    // rmio_layernorm[2].input_we = 0;
    // rmio_layernorm[3].input_we = 0;
    
    // rmio_silu[0].input_we = 0;
    // rmio_silu[1].input_we = 0;
    // rmio_silu[2].input_we = 0;
    // rmio_silu[3].input_we = 0;
    
    // rmio_att[0].input_we = 3'b000;
    // rmio_att[1].input_we = 3'b000;
    // rmio_att[2].input_we = 3'b000;
    // rmio_att[3].input_we = 3'b000;

    real_ram.we = 0;

    if (ram.we) begin
        case (ram.addr)
            // === STMM ===
            // ADDR_STMM_0_X:  rmio_stmm.input_we = 4'b0001;
            // ADDR_STMM_1_X:  rmio_stmm.input_we = 4'b0010;
            // ADDR_STMM_2_X:  rmio_stmm.input_we = 4'b0100;
            // ADDR_STMM_3_X:  rmio_stmm.input_we = 4'b1000;
            ADDR_STMM_0_X:  stmm_input_we = 4'b0001;
            ADDR_STMM_1_X:  stmm_input_we = 4'b0010;
            ADDR_STMM_2_X:  stmm_input_we = 4'b0100;
            ADDR_STMM_3_X:  stmm_input_we = 4'b1000;

            // === LAYER NORM ===
            // ADDR_LN_0_X:    rmio_layernorm[0].input_we = 1;
            // ADDR_LN_1_X:    rmio_layernorm[1].input_we = 1;
            // ADDR_LN_2_X:    rmio_layernorm[2].input_we = 1;
            // ADDR_LN_3_X:    rmio_layernorm[3].input_we = 1;

            // === SILU ===
            // ADDR_SILU_0_X:  rmio_silu[0].input_we = 1;
            // ADDR_SILU_1_X:  rmio_silu[1].input_we = 1;
            // ADDR_SILU_2_X:  rmio_silu[2].input_we = 1;
            // ADDR_SILU_3_X:  rmio_silu[3].input_we = 1;

            // === ATTENTION ===
            // ADDR_ATT_0_Q:  rmio_att[0].input_we = 3'b001;
            // ADDR_ATT_1_Q:  rmio_att[1].input_we = 3'b001;
            // ADDR_ATT_2_Q:  rmio_att[2].input_we = 3'b001;
            // ADDR_ATT_3_Q:  rmio_att[3].input_we = 3'b001;

            // ADDR_ATT_0_K:  rmio_att[0].input_we = 3'b010;
            // ADDR_ATT_1_K:  rmio_att[1].input_we = 3'b010;
            // ADDR_ATT_2_K:  rmio_att[2].input_we = 3'b010;
            // ADDR_ATT_3_K:  rmio_att[3].input_we = 3'b010;

            // ADDR_ATT_0_V:  rmio_att[0].input_we = 3'b100;
            // ADDR_ATT_1_V:  rmio_att[1].input_we = 3'b100;
            // ADDR_ATT_2_V:  rmio_att[2].input_we = 3'b100;
            // ADDR_ATT_3_V:  rmio_att[3].input_we = 3'b100;

            default: if (is_real_ram_addr) real_ram.we = 1;
        endcase
    end

end

//////////////////////////////
// Determine read signals and read data
// Assert rmio.re for all EUs even not needed
//////////////////////////////
always_comb begin
    
    // set all read-enable to zero by default 
    rmio_stmm.output_re = '0;

    // rmio_layernorm[0].output_re = 0;
    // rmio_layernorm[1].output_re = 0;
    // rmio_layernorm[2].output_re = 0;
    // rmio_layernorm[3].output_re = 0;

    // rmio_silu[0].output_re = 0;
    // rmio_silu[1].output_re = 0;
    // rmio_silu[2].output_re = 0;
    // rmio_silu[3].output_re = 0;

    // rmio_att[0].output_re = 0;
    // rmio_att[1].output_re = 0;
    // rmio_att[2].output_re = 0;
    // rmio_att[3].output_re = 0;

    real_ram.re = 0;

    if (ram.re) begin
        case (ram.addr)
            // === STMM ===
            ADDR_STMM_0_Y:  rmio_stmm.output_re = 4'b0001;
            ADDR_STMM_1_Y:  rmio_stmm.output_re = 4'b0010;
            ADDR_STMM_2_Y:  rmio_stmm.output_re = 4'b0100;
            ADDR_STMM_3_Y:  rmio_stmm.output_re = 4'b1000;

            // === LAYER NORM ===
            // ADDR_LN_0_Y:    rmio_layernorm[0].output_re = 1;
            // ADDR_LN_1_Y:    rmio_layernorm[1].output_re = 1;
            // ADDR_LN_2_Y:    rmio_layernorm[2].output_re = 1;
            // ADDR_LN_3_Y:    rmio_layernorm[3].output_re = 1;

            // === SILU ===
            // ADDR_SILU_0_Y:  rmio_silu[0].output_re = 1;
            // ADDR_SILU_1_Y:  rmio_silu[1].output_re = 1;
            // ADDR_SILU_2_Y:  rmio_silu[2].output_re = 1;
            // ADDR_SILU_3_Y:  rmio_silu[3].output_re = 1;

            // === ATTENTION ===
            // ADDR_ATT_0_Y:  rmio_att[0].output_re = 1;
            // ADDR_ATT_1_Y:  rmio_att[1].output_re = 1;
            // ADDR_ATT_2_Y:  rmio_att[2].output_re = 1;
            // ADDR_ATT_3_Y:  rmio_att[3].output_re = 1;

            default: if (is_real_ram_addr) real_ram.re = 1;
        endcase
    end
end

//////////////////////////////
// determine ram.q based on the flip-floped addr
//////////////////////////////
always_comb begin
    unique case (addr_ff)
        // === STMM ===
        ADDR_STMM_0_Y:  ram.q = rmio_stmm.output_data;
        ADDR_STMM_1_Y:  ram.q = rmio_stmm.output_data;        
        ADDR_STMM_2_Y:  ram.q = rmio_stmm.output_data;
        ADDR_STMM_3_Y:  ram.q = rmio_stmm.output_data;

/*
        
        // === LAYER NORM ===
        ADDR_LN_0_Y:    ram.q = rmio_layernorm[0].output_data;
        ADDR_LN_1_Y:    ram.q = rmio_layernorm[1].output_data;
        ADDR_LN_2_Y:    ram.q = rmio_layernorm[2].output_data;
        ADDR_LN_3_Y:    ram.q = rmio_layernorm[3].output_data;
        
        // === SILU ===
        ADDR_SILU_0_Y:  ram.q = rmio_silu[0].output_data;
        ADDR_SILU_1_Y:  ram.q = rmio_silu[1].output_data;
        ADDR_SILU_2_Y:  ram.q = rmio_silu[2].output_data;
        ADDR_SILU_3_Y:  ram.q = rmio_silu[3].output_data;

        // === ATTENTION ===
        ADDR_ATT_0_Y:  ram.q = rmio_att[0].output_data;
        // ADDR_ATT_1_Y:  ram.q = rmio_att[1].output_data;
        // ADDR_ATT_2_Y:  ram.q = rmio_att[2].output_data;
        // ADDR_ATT_3_Y:  ram.q = rmio_att[3].output_data;
*/
        default:       ram.q = real_ram.q;  // no need if(...), dirty is OK.
    endcase
end



endmodule

`default_nettype wire 
