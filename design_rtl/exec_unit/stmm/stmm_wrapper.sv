`default_nettype none

module stmm_wrapper #(
    parameter int SUB_NUM = 4,
    parameter int N = 176,
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    rmio_intf i_rmio_intf,

    sdram_read_intf i_sdram_read_intf,
    
    // eu_ctrl_intf i_eu_ctrl_intf,
    input wire [SUB_NUM - 1 : 0] fetch,
    input wire [SUB_NUM - 1 : 0] exec,
    input wire [31 : 0] fetch_addr,

    output logic fetch_done,
    output logic [SUB_NUM - 1 : 0] exec_done
);


// ------------------ Fetcher related ------------------
logic [$clog2(SUB_NUM)-1 : 0] fetch_sub_idx_wire, fetch_sub_idx;
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

    // .start      (i_eu_ctrl_intf.fetch),
    // .fetch_addr (i_eu_ctrl_intf.fetch_addr),
    .start      (|fetch),
    .fetch_addr (fetch_addr),

    .done       (fetch_done)
);

////////////////////////
// Weight BRAM
////////////////////////
logic [$clog2(N) - 1 : 0]   stmm_ram_addr [4];
logic [N * 8 - 1 : 0]       stmm_ram_data [4];

genvar i;
generate
    for (i = 0; i < SUB_NUM; i++) begin: blk_instantiate_wmem
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
// logic               input_we_arr[SUB_NUM];
// logic [N * 8 - 1 : 0] input_data_arr[SUB_NUM];
// generate
//     for (i = 0; i < SUB_NUM; i++) begin: blk_assign_rmio_intf_arr
//         assign input_we_arr[i] = i_rmio_intf[i].input_we;
//         assign input_data_arr[i] = i_rmio_intf[i].input_data;
//     end
// endgenerate

logic [N * 8 - 1 : 0] X_in[SUB_NUM];
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < SUB_NUM; i++)
            X_in[i] <= 0;
    end
    else begin
        for (int i = 0; i < SUB_NUM; i++) begin
            if (i_rmio_intf.input_we[i])
                X_in[i] <= i_rmio_intf.input_data;
        end
    end
end

logic [N * 8 - 1 : 0] Y_out[SUB_NUM];
generate
    for (i = 0; i < SUB_NUM; i++) begin: blk_instantiate_stmm
        StMM #(.N(176), .P(176), .DQ(18), .Q(8)) i_stmm(
            .clk        (clk),
            .rst_n      (rst_n),

            .X_in       (X_in[i]),
            // .start      ((i_eu_ctrl_intf.sub_idx == i) && i_eu_ctrl_intf.exec),
            .start      (exec[i]),

            .scale_fp16 (scale_fp16_arr[i]),
            .z_X        (z_X_arr[i]),
            .z_W        (z_W_arr[i]),
            .zero       (zero_arr[i]),

            .W_addr     (stmm_ram_addr[i]),
            .W_data     (stmm_ram_data[i]),

            .Y_out      (Y_out[i]),
            .out_valid  (exec_done[i])
        );
    end
endgenerate

// output mux
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
