`default_nettype none

module layernorm_wrapper #(
    parameter int SUB_NUM = 4,
    parameter int N = 176,
    parameter int SDRAM_W = 128
) (
    input wire clk, rst_n,

    rmio_intf i_rmio_intf,

    sdram_read_intf i_sdram_read_intf,
    
    input wire [SUB_NUM - 1 : 0] fetch,
    input wire [SUB_NUM - 1 : 0] exec,
    input wire [31 : 0] fetch_addr,

    output logic fetch_done,
    output logic [SUB_NUM - 1 : 0] exec_done
);

// Param fetcher
logic [N*8-1 : 0] fetch_data;
logic gamma_hi_valid, gamma_lo_valid, beta_valid;
layernorm_fetch #(
    .SDRAM_DATA_W(SDRAM_W),
    .DATA_W(N*8),
    .N(N)
) i_layernorm_fetch (
    .clk(clk),
    .rst_n(rst_n),

    .i_sdram_read_intf(i_sdram_read_intf),

    .data_out(fetch_data),    
    .gamma_hi_valid(gamma_hi_valid),
    .gamma_lo_valid(gamma_lo_valid),
    .beta_valid(beta_valid),

    .start(|fetch),
    .fetch_addr(fetch_addr),
    .done(fetch_done)
);

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

// Param storer
logic [N*8-1 : 0] gamma_scaled_lo[SUB_NUM];
logic [N*8-1 : 0] gamma_scaled_hi[SUB_NUM];
logic [N*8-1 : 0] beta_scaled[SUB_NUM];

always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
        for (int i = 0; i < SUB_NUM; i++) begin
            gamma_scaled_lo[i] <= '0;
            gamma_scaled_hi[i] <= '0;
            beta_scaled[i] <= '0;
        end
    end else begin
        if (gamma_hi_valid)
            gamma_scaled_hi[fetch_sub_idx] <= fetch_data;
        if (gamma_lo_valid)
            gamma_scaled_lo[fetch_sub_idx] <= fetch_data;
        if (beta_valid)
            beta_scaled[fetch_sub_idx] <= fetch_data;
    end
end

// input loader
logic [N*8-1 : 0] X_in[SUB_NUM];
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

// Layernorm executors 
logic [N * 8 - 1 : 0] Y_out[SUB_NUM];
genvar i;
generate
    for (i = 0; i < SUB_NUM; i++) begin: blk_instantiate_layernorm
        layernorm #( .N(N) ) i_layernorm (
            .clk    (clk),
            .rst_n  (rst_n),

            .x_in           (X_in[i]),
            .gamma_scaled_hi(gamma_scaled_hi[i]),
            .gamma_scaled_lo(gamma_scaled_lo[i]),
            .beta_scaled    (beta_scaled[i]),

            .start      (exec[i]),

            .y_out      (Y_out[i]),
            .out_valid  (exec_done[i])
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
