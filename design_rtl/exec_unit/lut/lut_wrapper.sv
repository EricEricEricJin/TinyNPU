`default_nettype none

module lut_wrapper #(
    parameter int SUB_NUM = 4,
    parameter int N = 176,
    parameter int SDRAM_W = 128
) (
    input wire clk,
    input wire rst_n,

    rmio_intf i_rmio_intf,
    sdram_read_intf i_sdram_read_intf,

    input wire [SUB_NUM - 1 : 0] fetch,
    input wire [SUB_NUM - 1 : 0] exec,
    input wire [31 : 0] fetch_addr,
    output logic fetch_done,
    output logic [SUB_NUM - 1 : 0] exec_done
);

// Input FF
logic [N*8 - 1 : 0] X_in [SUB_NUM];
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < SUB_NUM; i++)
            X_in[i] <= '0;
    end else begin
        for (int i = 0; i < SUB_NUM; i++) begin
            if (i_rmio_intf.input_we[i])
                X_in[i] <= i_rmio_intf.input_data;
        end
    end             
end


// fetch index ff
logic [$clog2(SUB_NUM) - 1 : 0] fetch_sub_idx, fetch_sub_idx_wire;
priority_encoder #(SUB_NUM) i_fetch_pe (
    .in(fetch),
    .out(fetch_sub_idx_wire)
);
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        fetch_sub_idx <= '0;
    else if (|fetch)
        fetch_sub_idx <= fetch_sub_idx_wire;
end


bram_intf #(.ADDR_W(8), .DATA_W(8)) i_fetch_ram_intf ();

lut_fetch #(.BRAM_W(8), .BRAM_L(2**8), .SDRAM_W(SDRAM_W)) i_lut_fetch (
    .clk(clk),
    .rst_n(rst_n),

    .i_sdram_read_intf(i_sdram_read_intf),
    .i_bram_intf(i_fetch_ram_intf),

    .start(|fetch),
    .fetch_addr(fetch_addr),
    .done(fetch_done)
);



// LUT BRAM
logic [7 : 0] lut_bram_addr[SUB_NUM];
logic [7 : 0] lut_bram_data[SUB_NUM];

genvar i;
generate
    for (i = 0; i < SUB_NUM; i++) begin : blk_instantiate_lut_bram
        wire i_we = (i == fetch_sub_idx) && i_fetch_ram_intf.we;
        ram_256x8 i_lut_bram(
            .address    (i_we ? i_fetch_ram_intf.addr : lut_bram_addr[i]),
            .clock      (clk),
            .data       (i_fetch_ram_intf.data),
            .wren       (i_we),
            .q          (lut_bram_data[i])
        );
    end
endgenerate


logic [N*8 - 1 : 0] Y_out [SUB_NUM];

// LUT executors
generate
    for (i = 0; i < SUB_NUM; i++) begin : blk_instantiate_lut
        lut #(.N(N)) i_lut (
            .clk(clk),
            .rst_n(rst_n),

            .x_i (lut_bram_addr[i]),
            .y_i (lut_bram_data[i]),

            .X_in   (X_in[i]),
            .start  (exec[i]),
            .Y_out  (Y_out[i]),
            .done   (exec_done[i])
        );
    end
endgenerate


// Output mux
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        i_rmio_intf.output_data <= '0;
    else begin
        for (int i = 0; i < SUB_NUM; i++) begin
            if (i_rmio_intf.output_re[i])
                i_rmio_intf.output_data <= Y_out[i];
        end
    end
end

endmodule

`default_nettype wire
