// Load and store vector from / to SDRAM

`default_nettype none

module rf_ldst #(
    parameter int SDRAM_ADDR_W = 25,
    parameter int RF_ADDR_W = 9,
    parameter int SDRAM_DATA_W = 128,
    parameter int RF_DATA_W = 176*8
)(
    input wire clk, rst_n,

    // to SDRAM
    sdram_intf sdram,

    // to RF 
    // todo


    // to master
    input wire [SDRAM_ADDR_W - 1 : 0]   ldst_sdram_addr,
    input wire [RF_ADDR_W - 1 : 0]      ldst_rf_addr,
    input wire [7 : 0]  ldst_line_num,
    input wire          ldst_start,
    output logic        ldst_done

);

// State machine

/*
SDRAM to RF:
    IDLE -> SEND_ADDR -> READ_FROM_SDRAM -> WRITE_TO_RF -> IDLE

RF to SDRAM:
    IDLE -> READ_FROM_RF -> SEND_ADDR -> WRITE_TO_SDRAM -> IDLE
*/

typedef enum logic[1:0] { 
    IDLE, 
    SEND_ADDR,
    READ_FROM_SDRAM, WRITE_TO_RF, 
    READ_FROM_RF, WRITE_TO_SDRAM 
} state_t;

state_t state, nxt_state;

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin
    sdram.read = 0;
    sdram.write = 0;
    sdram.addr = 0;
    sdram.data = 0;
    sdram.valid = 0;
    
    case (state)
        IDLE: begin
            if (load_start)
                nxt_state = SEND_ADDR;
            else if (store_start)
                nxt_state = READ_FROM_RF;
        end
        
        SEND_ADDR: begin
            
        end

        default: 
    endcase

end

    
endmodule

`default_nettype wire 
