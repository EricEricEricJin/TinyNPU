`default_nettype none

module stmm_wrapper #(
    parameter int SUB_NUM = 4,
    parameter int N = 176,
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    rmio_intf i_rmio_intf [4],

    sdram_read_intf i_sdram_read_intf,
    
    eu_ctrl_intf i_eu_ctrl_intf,

    output logic fetch_done,
    output logic [SUB_NUM - 1 : 0] exec_done
);


// ------------------ Fetcher related ------------------

logic [1 : 0] fetch_sub_idx;
always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n)
        fetch_sub_idx <= '0;
    else if (i_eu_ctrl_intf.fetch)
        fetch_sub_idx <= i_eu_ctrl_intf.sub_idx;
end

////////////////////////
// Param fetcher 
////////////////////////
bram_intf #(.ADDR_W(8), .DATA_W(176*8)) i_fetch_ram_intf();

logic [15 : 0] fetch_scale_fp16;
logic [7 : 0] fetch_z_X, fetch_z_W, fetch_zero;
logic quant_valid;

stmm_fetch i_stmm_fetch (
    .clk        (clk),
    .rst_n      (rst_n),

    .i_sdram_read_intf  (i_sdram_read_intf),

    .i_bram_intf        (i_fetch_ram_intf),

    .scale_fp16 (fetch_scale_fp16),
    .z_X        (fetch_z_X),
    .z_W        (fetch_z_W),
    .zero       (fetch_zero),
    .quant_valid(quant_valid),

    .start      (i_eu_ctrl_intf.fetch),
    .fetch_addr (i_eu_ctrl_intf.fetch_addr),
    .done       (fetch_done)
);

////////////////////////
// Weight BRAM
////////////////////////
logic [$clog2(N) - 1 : 0]   stmm_ram_addr [4];
logic [N * 8 - 1 : 0]       stmm_ram_data [4];

genvar i;
generate
    for (i = 0; i < 4; i++) begin: blk_instantiate_wmem
        wire i_we = (fetch_sub_idx == i) && i_fetch_ram_intf.we;
        ram_176x1408 i_wmem(
            .address    (i_we ? i_fetch_ram_intf.addr : stmm_ram_addr[i]),
            .clock      (clk),
            .data       (i_fetch_ram_intf.data),
            .wren       (i_we),
            .q          (stmm_ram_data[i])
        );
    end
endgenerate


////////////////////////
// Quantization FF at quant_valid
////////////////////////
logic [15 : 0] scale_fp16_arr[SUB_NUM];
logic [7 : 0] z_X_arr[SUB_NUM], z_W_arr[SUB_NUM], zero_arr[SUB_NUM];

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < SUB_NUM; i++) begin
            scale_fp16_arr[i] <= 0;
            z_X_arr[i] <= 0;
            z_W_arr[i] <= 0;
            zero_arr[i] <= 0;
        end
    end else if (quant_valid) begin
        scale_fp16_arr[fetch_sub_idx] <= fetch_scale_fp16;
        z_X_arr[fetch_sub_idx] <= fetch_z_X;
        z_W_arr[fetch_sub_idx] <= fetch_z_W;
        zero_arr[fetch_sub_idx] <= fetch_zero;
    end
end

// ------------------ Executor related ------------------

////////////////////////
// Input FF
////////////////////////
logic input_we_arr[SUB_NUM];
logic [N * 8 - 1 : 0] input_data_arr[SUB_NUM];
generate
    for (i = 0; i < SUB_NUM; i++) begin: blk_assign_rmio_intf_arr
        assign input_we_arr[i] = i_rmio_intf[i].input_we;
        assign input_data_arr[i] = i_rmio_intf[i].input_data;
    end
endgenerate

logic [N * 8 - 1 : 0] X_in[SUB_NUM];
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < SUB_NUM; i++)
            X_in[i] <= 0;
    end
    else begin
        for (int i = 0; i < SUB_NUM; i++) begin
            if (input_we_arr[i])
                X_in[i] <= input_data_arr[i];
        end
    end
end


// logic exec_start [SUB_NUM];

bram_intf i_stmm_ram_intf [4] ();

generate
    for (i = 0; i < 4; i++) begin: blk_instantiate_stmm
        StMM #(.N(176), .P(176), .DQ(18), .Q(8)) i_stmm(
            .clk        (clk),
            .rst_n      (rst_n),

            .X_in       (X_in[i]),
            .start      ((i_eu_ctrl_intf.sub_idx == i) && i_eu_ctrl_intf.exec),

            .scale_fp16 (scale_fp16_arr[i]),
            .z_X        (z_X_arr[i]),
            .z_W        (z_W_arr[i]),
            .zero       (zero_arr[i]),

            .W_addr     (stmm_ram_addr[i]),
            .W_data     (stmm_ram_data[i]),

            .Y_out      (i_rmio_intf[i].output_data),
            .out_valid  (exec_done[i])
        );
    end
endgenerate

endmodule

`default_nettype wire 