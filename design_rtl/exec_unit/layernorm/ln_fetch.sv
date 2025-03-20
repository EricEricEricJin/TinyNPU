`default_nettype none

module ln_fetch #(
    parameter int SDRAM_DATA_W = 128,
    parameter int DATA_W = 176*8
) (
    input wire clk, 
    input wire rst_n,

    sdram_read_intf i_sdram_read_intf,
    ln_fetch_intf   i_fetch_intf,

    input wire [31 : 0] addr,
    input wire start,
    output logic done
);

localparam BLK_NUM = DATA_W / SDRAM_DATA_W;

assign i_sdram_read_intf.read_addr = addr;
assign i_sdram_read_intf.read_cnt = BLK_NUM;


// pack data
logic [SDRAM_DATA_W - 1 : 0] data_unpacked[0 : BLK_NUM - 1];
genvar i;
generate
    for (i = 0; i < BLK_NUM - 1; i++) begin: pack_data
        assign i_fetch_intf.data[i*SDRAM_DATA_W+:SDRAM_DATA_W] = data_unpacked[i];
    end
endgenerate

// Data Index
logic [$clog2(BLK_NUM) - 1 : 0] data_idx;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        data_idx <= '0;
    else if (i_fetch_intf.data_we)
        data_idx <= data_idx + 1;
end


typedef enum logic [1 : 0] { IDLE, GAMMA_HI, GAMMA_LO, BETA } state_t;
state_t state, nxt_state;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin
    
    i_sdram_read_intf.read_start = 0;

    i_fetch_intf.gamma_high_we = 0;
    i_fetch_intf.gamma_low_we = 0;
    i_fetch_intf.beta_we = 0;

    done = 0;
    nxt_state = state;

    case (state)
        IDLE: begin
            if (start) begin
                i_sdram_read_intf.read = 1;
                nxt_state = GAMMA_HI;
            end
        end 
        GAMMA_HI: begin

        end
        GAMMA_LO: begin
        end
        default: begin  // BETA
            
        end
    endcase
end

    
endmodule

`default_nettype wire