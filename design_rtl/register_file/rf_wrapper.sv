`default_nettype none

module rf_wrapper #(
    
) (
    input wire clk, rst_n,
    
    // Connect to control signals
    input wire mv_start,
    input wire [ADDR_W - 1 : 0] mv_src_addr, mv_dst_addr,
    output logic mv_done,

    // Connect to Avalon SDRAM
    // todo

    // Connect to exec units
    output logic [DATA_W - 1 : 0] stmm_X_data [0 : 3],
    output logic                  stmm_X_ld   [0 : 3],
    input wire  [DATA_W - 1 : 0]  stmm_Y_data [0 : 3],

    // to LayerNorm
    output logic [N - 1 : 0] layernorm_X_data [0 : 3],
    output logic             layernorm_X_ld   [0 : 3], 
    input wire  [N - 1 : 0]  layernorm_Y_data [0 : 3]    // to LayerNorm


);

typedef enum logic { OP_MV, OP_LDST } op_t;
op_t operation;

logic [ADDR_W - 1 : 0] rf_addr;
logic [DATA_W - 1 : 0] rf_d, rf_q;
logic rf_we, rf_re;

logic [ADDR_W - 1 : 0] mv_addr;
logic mv_we, mv_re;
logic mv_d;

logic [ADDR_W - 1 : 0] ldst_addr;


// Address mux 
// assign rf_addr = (operation == OP_MV) ? mv_addr : ldst_addr;
always_comb begin
    case (operation)
        OP_MV: begin
            rf_addr = mv_addr;
            rf_we = mv_we;
            rf_re = mv_re;
            rf_d = mv_d;
        end
        default: begin
            rf_addr = ldst_addr;
            rf_we = ldst_we;
            rf_re = ldst_re;
            rf_d = ldst_d;
        end
    endcase
end

// << RF RAM >>
rf_ram i_rf_ram (
    .clk        (clk),

    .rf_addr    (rf_addr),
    .rf_d       (rf_d),
    .rf_q       (rf_q),
    .rf_we      (rf_we),
    .rf_re      (rf_re),

    // Connect to Exec Unit exports
    .stmm_X_data (stmm_X_data),
    .stmm_X_ld   (stmm_X_ld),
    .stmm_Y_data (stmm_Y_data),

    .layernorm_X_data (layernorm_X_data),
    .layernorm_X_ld   (layernorm_X_ld),
    .layernorm_Y_data (layernorm_Y_data),
);



// << Mover >>
rf_mv #(.WIDTH (DATA_W), .ADDR_W (ADDR_W)) i_rf_mv (
    .clk        (clk),
    .rst_n      (rst_n),

    .ram_addr   (mv_addr),
    .ram_we     (mv_we),
    .ram_re     (mv_re),
    .ram_d      (mv_d),
    .ram_q      (rf_q),

    .mv_start   (mv_start),
    .src_addr   (mv_src_addr),
    .dst_addr   (mv_dst_addr),
    .mv_done    (mv_done)
);


// Load fetcher
rf_ldst #(
    .SDRAM_ADDR_W   (SDRAM_ADDR_W),
    .RF_ADDR_W      (ADDR_W),
    .SDRAM_DATA_W   (128),
    .RF_DATA_W      (DATA_W)
) i_rf_ldst (
    .clk    (clk),
    .rst_n  (rst_n),
    .sdram  (sdram),

    // todo: RF signals
    .ldst_sdram_addr    (ldst_sdram_addr),
    .ldst_rf_addr       (ldst_addr),
    .ldst_line_num      (ldst_line_num),
    
    .ldst_start         (ldst_start),
    .ldst_done          (ldst_done)
);

endmodule

`default_nettype wire 