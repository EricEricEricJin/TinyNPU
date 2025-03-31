`default_nettype none

module avmm_sdram_read_wrapper #(
    parameter int SDRAM_DATA_W = 128
) (
    input   wire          clk,
    input   wire          rst_n,

    // ---------- Connector to AvMM Slave ----------
    input   wire [SDRAM_DATA_W - 1 : 0] readdata,
    input   wire                        readdatavalid,
    input   wire                        waitrequest,
    output  logic           read,
    output  logic [31:0]    address,
    output  logic [10:0]    burstcount,

    // ---------- for read ----------
    input wire [31:0]       read_addr,      // base address
    input wire [10:0]       read_cnt,       // burst count
    input wire              read_start,     // start
    output logic            read_valid,     // current data is valid
    output logic  [SDRAM_DATA_W - 1 : 0]    read_data,
    output logic           read_done
);

// flip addr and cnt at start
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        address <= '0;
    else if (read_start)
        address <= read_addr;
end

// burst counter 
logic cnt_dec;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        burstcount <= '0;
    else if (read_start)
        burstcount <= read_cnt;
    else if (cnt_dec)
        burstcount <= burstcount - 1;
end

// connect read data
assign read_data = readdata;

// << State Machine >>
typedef enum logic [1 : 0] { IDLE, SEND_ADDR, RECV_DATA } state_t;
state_t state, nxt_state;

always_ff @(posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin
    
    read = 0;
    
    read_valid = 0;
    cnt_dec = 0;
    read_done = 0;

    nxt_state = state;
    
    case(state)
        IDLE: begin
            read_done = 1;
            if (read_start)
                nxt_state = SEND_ADDR;
        end

        SEND_ADDR: begin
            read = 1;
            if (!waitrequest)
                nxt_state = RECV_DATA;
        end

        default: begin  // RECV_DATA
            if (readdatavalid) begin
                read_valid = 1;
                cnt_dec = 1;
                if (burstcount == 1)
                    nxt_state = IDLE;
            end
        end
    endcase
end

endmodule

`default_nettype wire 
