`default_nettype none

module sdram_read #(
    parameter int SDRAM_W = 128
) (
    input   logic          clk,
    input   logic          rst_n,

    // Connector to AvMM Slave
    // input   logic [SDRAM_W - 1 : 0] readdata,
    // input   logic         readdatavalid,
    // input   logic         waitrequest,

    // output  logic         read,
    // output  logic [31:0]  address,
    // output  logic [10:0]  burstcount,
    sdram_read_intf avalon_intf,

    // output
    // input logic [31:0]       read_addr,      // base address
    // input logic [10:0]       read_cnt,       // burst count
    // input logic              read_start,     // start
    // output logic            out_valid,     // current data is valid
    // output logic  [10:0]    out_idx,       // index, 0 <= i < cnt       
    // output logic  [SDRAM_W - 1 : 0]   out_data
    sdram_read_wrapper_intf wrapper_intf
);

logic [SDRAM_W - 1 : 0] readdata;
logic         readdatavalid;
logic         waitrequest;

logic         read;
logic [31:0]  address;
logic [10:0]  burstcount;

assign readdata = avalon_intf.readdata;
assign readdatavalid = avalon_intf.readdatavalid;
assign waitrequest = avalon_intf.waitrequest;

assign avalon_intf.read = read;
assign avalon_intf.address = address;
assign avalon_intf.burstcount = burstcount;

logic [31:0]       read_addr;      // base address
logic [10:0]       read_cnt;       // burst count
logic              read_start;     // start

logic              out_valid;     // current data is valid
logic  [10:0]      out_idx;       // index, 0 <= i < cnt       
logic  [SDRAM_W - 1 : 0]   out_data;

assign read_addr = wrapper_intf.read_addr;
assign read_cnt = wrapper_intf.read_cnt;
assign read_start = wrapper_intf.read_start;

assign wrapper_intf.out_valid = out_valid;
assign wrapper_intf.out_idx = out_idx;
assign wrapper_intf.out_data = out_data;

// read count and address FF
logic [10:0]    read_cnt_ff;
logic [31 : 0]  read_addr_ff;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        read_cnt_ff <= '0;
        read_addr_ff <= '0;
    end
    else if (read_start) begin
        read_cnt_ff <= read_cnt;
        read_addr_ff <= read_addr;
    end
end

// << output index accumulator >>
logic out_idx_clr;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        out_idx <= '0;
    else if (out_idx_clr)
        out_idx <= '0;
    else if (out_valid)
        out_idx <= out_idx + 11'd1;
end

assign out_data = readdata;

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
    address = 32'd0;
    burstcount = 11'd0;
    
    out_idx_clr = 0;

    out_valid = 0;

    nxt_state = state;
    
    case(state)
        IDLE: begin
            if (read_start) begin
                out_idx_clr = 1;
                nxt_state = SEND_ADDR;
            end
        end

        SEND_ADDR: begin
            address = read_addr_ff;
            burstcount = read_cnt_ff;
            read = 1;
            if (!waitrequest)
                nxt_state = RECV_DATA;
        end

        default: begin  // RECV_DATA
            if (readdatavalid) begin
                out_valid = 1;
                if (out_idx == read_cnt_ff - 1)
                    nxt_state = IDLE;
            end
        end
    endcase
end
endmodule

`default_nettype wire 
