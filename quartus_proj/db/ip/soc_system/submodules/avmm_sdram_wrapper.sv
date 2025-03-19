module avmm_sdram_wrapper #(
    parameter int SDRAM_DATA_W = 128
) (
    input   wire          clk,
    input   wire          rst_n,

    // ----------------- Connect to AvMM Slave -----------------
    input   wire [SDRAM_DATA_W - 1 : 0] readdata,
    input   wire                        readdatavalid,
    input   wire                        waitrequest,

    output  logic           read,
    output  logic [31:0]    address,
    output  logic [10:0]    burstcount,

    output logic                        write,
    output logic [SDRAM_DATA_W - 1 : 0] writedata,
    output logic [15:0]                 byteenable,

    // ----------------- for read and write -----------------
    input wire [31:0]       rw_addr,      // base address
    input wire [10:0]       rw_cnt,       // burst count
    output logic            rw_done,      // done

    // ----------------- for read -----------------
    input wire                              read_start,     // start
    output logic                            read_valid,     // current data is valid
    output logic  [SDRAM_DATA_W - 1 : 0]    read_data,
    
    // ----------------- for write -----------------
    input wire                          write_start,     // start
    output logic                        write_nxt,
    input wire [SDRAM_DATA_W - 1 : 0]   write_data
);

logic start;
assign start = read_start || write_start;

// Flip addr and cnt at start
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        address <= '0;
    else if (start)
        address <= rw_addr;
end

logic cnt_dec;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        burstcount <= '0;
    else if (start)
        burstcount <= rw_cnt;
    else if (cnt_dec)
        burstcount <= burstcount - 1;
end

// connect read and write data
assign read_data = readdata;
assign writedata = write_data;
assign byteenable = '1;

// << State Machine >>
typedef enum logic [2 : 0] { 
    IDLE, 
    RD_SEND_ADDR, RECV_DATA,
    WT_SEND_ADDR, SEND_DATA
} state_t;

state_t state, nxt_state;

always_ff @(posedge clk, negedge rst_n ) begin
    if (!rst_n)
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin
    
    read = 0;
    write = 0;

    read_valid = 0;
    cnt_dec = 0;
    write_nxt = 0;

    rw_done = 0;

    nxt_state = state;
    
    case(state)
        IDLE: begin
            rw_done = 1;
            
            if (read_start)
                nxt_state = RD_SEND_ADDR;
            else if (write_start)
                nxt_state = WT_SEND_ADDR;
        end

        RD_SEND_ADDR: begin
            read = 1;
            if (!waitrequest)
                nxt_state = RECV_DATA;
        end

        RECV_DATA: begin
            if (readdatavalid) begin
                read_valid = 1;
                cnt_dec = 1;
                if (burstcount == 1)
                    nxt_state = IDLE;
            end
        end

        WT_SEND_ADDR: begin
            write = 1;
            if (!waitrequest) begin
                write_nxt = 1;
                nxt_state = SEND_DATA;
            end
        end

        default: begin      // SEND_DATA
            cnt_dec = 1;
            if (burstcount == 1) begin
                nxt_state = IDLE;
            end else begin
                write_nxt = 1;
                write = 1;
            end 
        end
    endcase
end
endmodule
