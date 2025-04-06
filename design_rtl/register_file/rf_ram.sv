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
    rmio_intf rmio_layernorm,
    rmio_intf rmio_lut
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
logic [3 : 0] stmm_input_we;
logic [0 : 0] layernorm_input_we;
logic [1 : 0] lut_input_we;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        rmio_stmm.input_data <= '0;
        rmio_layernorm.input_data <= '0;
        rmio_lut.input_data <= '0;

        rmio_stmm.input_we <= '0;
        rmio_layernorm.input_we <= '0;
        rmio_lut.input_we <= '0;
    end else begin
        rmio_stmm.input_data <= ram.data;
        rmio_layernorm.input_data <= ram.data;
        rmio_lut.input_data <= ram.data;       

        rmio_stmm.input_we <= stmm_input_we;
        rmio_layernorm.input_we <= layernorm_input_we;
        rmio_lut.input_we <= lut_input_we;
    end
end

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
    // ADDR_LN_1_X = 10'h211,
    // ADDR_LN_2_X = 10'h212,
    // ADDR_LN_3_X = 10'h213,

    ADDR_LN_0_Y = 10'h218,
    // ADDR_LN_1_Y = 10'h219,
    // ADDR_LN_2_Y = 10'h21a,
    // ADDR_LN_3_Y = 10'h21b,

    ADDR_LUT_0_X = 10'h220,
    ADDR_LUT_1_X = 10'h221,
    // ADDR_LUT_2_X = 10'h222,
    // ADDR_LUT_3_X = 10'h223,
    
    ADDR_LUT_0_Y = 10'h228,
    ADDR_LUT_1_Y = 10'h229
    // ADDR_LUT_2_Y = 10'h22a,
    // ADDR_LUT_3_Y = 10'h22b
    
} addr_t;

//////////////////////////////
// Determine write-enable and load signals
//////////////////////////////
always_comb begin

    // rmio_stmm.input_we = '0;
    stmm_input_we = '0;
    layernorm_input_we = '0;
    lut_input_we = '0;

    real_ram.we = 0;

    if (ram.we) begin
        case (ram.addr)
            // === STMM ===
            ADDR_STMM_0_X:  stmm_input_we = 4'b0001;
            ADDR_STMM_1_X:  stmm_input_we = 4'b0010;
            ADDR_STMM_2_X:  stmm_input_we = 4'b0100;
            ADDR_STMM_3_X:  stmm_input_we = 4'b1000;

            // === LAYER NORM ===
            ADDR_LN_0_X:    layernorm_input_we = 4'b0001;
            // ADDR_LN_1_X:    layernorm_input_we = 4'b0010;
            // ADDR_LN_2_X:    layernorm_input_we = 4'b0100;
            // ADDR_LN_3_X:    layernorm_input_we = 4'b1000;

            // === LUT ===
            ADDR_LUT_0_X:   lut_input_we = 4'b0001;
            ADDR_LUT_1_X:   lut_input_we = 4'b0010;
            // ADDR_LUT_2_X:   lut_input_we = 4'b0100;
            // ADDR_LUT_3_X:   lut_input_we = 4'b1000;

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
    rmio_layernorm.output_re = '0;
    rmio_lut.output_re = '0;

    real_ram.re = 0;

    if (ram.re) begin
        case (ram.addr)
            // === STMM ===
            ADDR_STMM_0_Y:  rmio_stmm.output_re = 4'b0001;
            ADDR_STMM_1_Y:  rmio_stmm.output_re = 4'b0010;
            ADDR_STMM_2_Y:  rmio_stmm.output_re = 4'b0100;
            ADDR_STMM_3_Y:  rmio_stmm.output_re = 4'b1000;

            // === LAYER NORM ===
            ADDR_LN_0_Y:    rmio_layernorm.output_re = 4'b0001;
            // ADDR_LN_1_Y:    rmio_layernorm.output_re = 4'b0010;
            // ADDR_LN_2_Y:    rmio_layernorm.output_re = 4'b0100;
            // ADDR_LN_3_Y:    rmio_layernorm.output_re = 4'b1000;

            // === LUT ===
            ADDR_LUT_0_Y:   rmio_lut.output_re = 4'b0001;
            ADDR_LUT_1_Y:   rmio_lut.output_re = 4'b0010;
            // ADDR_LUT_2_Y:   rmio_lut.output_re = 4'b0100;
            // ADDR_LUT_3_Y:   rmio_lut.output_re = 4'b1000;

            default: if (is_real_ram_addr) real_ram.re = 1;
        endcase
    end
end

//////////////////////////////
// determine ram.q based on the flip-floped addr
//////////////////////////////
always_comb begin
    case (addr_ff)
        // === STMM ===
        ADDR_STMM_0_Y, ADDR_STMM_1_Y, ADDR_STMM_2_Y, ADDR_STMM_3_Y: ram.q = rmio_stmm.output_data;
        // ADDR_LN_0_Y, ADDR_LN_1_Y, ADDR_LN_2_Y, ADDR_LN_3_Y:         ram.q = rmio_layernorm.output_data;
        ADDR_LN_0_Y:         ram.q = rmio_layernorm.output_data;
        // ADDR_LUT_0_Y, ADDR_LUT_1_Y, ADDR_LUT_2_Y, ADDR_LUT_3_Y:     ram.q = rmio_lut.output_data;
        ADDR_LUT_0_Y, ADDR_LUT_1_Y:     ram.q = rmio_lut.output_data;

        default:       ram.q = real_ram.q;  // no need if(...), dirty is OK.
    endcase
end


endmodule

`default_nettype wire 
