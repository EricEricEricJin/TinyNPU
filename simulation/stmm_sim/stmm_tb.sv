`timescale 1 ps / 1 ps

module stmm_tb;

localparam int N = 176;
localparam int P = 176;

localparam int Q = 8;
localparam int DQ = 18;

logic clk, rst_n;

logic [Q * N - 1 : 0] X_in;
logic start;


logic W_wren;
logic [176 * 8 - 1 : 0] W_in;


wire [$clog2(P) - 1 : 0] W_addr;
wire [$clog2(P) - 1 : 0] mm_W_addr;
logic [$clog2(P) - 1 : 0] tb_W_addr;
assign W_addr = W_wren ? tb_W_addr : mm_W_addr;

wire [Q*N - 1 : 0] W_data;

wire [DQ * P - 1 : 0] Y_out;
wire out_valid;

StMM #(.N(N), .P(P), .DQ(DQ), .Q(Q)) i_stmm (
    .clk(clk), .rst_n(rst_n), 
    .X_in(X_in), .start(start),
    .scale_fp16(16'h22d6), .z_X(-8'd11), .z_W(8'd0), .zero(8'd25),
    .W_addr(mm_W_addr), .W_data(W_data),
    .Y_out(Y_out), .out_valid(out_valid) 
);

//bram #(.L(P), .W(N * Q)) i_bram (
//    .clk(clk), .addr(W_addr), .data(W_data) );
ram0 i_ram (
    .clock      (clk), 
    .address    (W_addr), 
    .data       (W_in),
    .wren       (W_wren), 
    .q          (W_data) 
);


int fd;
logic [15:0] x;

initial begin
    start = 0;
    W_wren = 0;

    // reset
    rst_n = 0;
    @(negedge clk) rst_n = 1;

    // load X
    fd = $fopen(X_FILE, "rb");
    for (int i = 0; i < N; i++) begin
        x = $fgetc(fd);
        X_in[i * Q +: Q] = x[Q - 1 : 0];
    end
    $fclose(fd);

    $display("X_in = %x", X_in);

    // Load W
    tb_W_addr = 0;
    fd = $fopen(W_FILE, "rb");
    for (int i = 0; i < P; i++) begin
        for (int j = 0; j < N; j++) begin
            x = $fgetc(fd);
            // $display("%d %d: %x", i, j, x[Q - 1 : 0]);
            W_in[j * Q +: Q] = x[Q - 1 : 0];
        end
        
        @(negedge clk);
        W_wren = 1;
        @(negedge clk);
        W_wren = 0;

        tb_W_addr++;
    end
    $fclose(fd);

    repeat (5) @(negedge clk);

    @(negedge clk) start = 1;
    @(negedge clk) start = 0;

    $display("Started!");
    @(posedge out_valid);

    // fork
    //     begin
    //         @(posedge out_valid);
    //     end
    //     begin
    //         @(negedge clk) $display("addr=%x value=%x", W_addr, W_data);
    //     end
    // join


    fd = $fopen(OUT_FILE, "wb");
    
    for (int i = 0; i < P; i++) begin
        x = Y_out[Q * i +: Q];
        $fwrite(fd, "%c" , x[7:0]);
        // $display("$d ", $signed(Y_out[Q * i +: Q]));
    end
    
    $fclose(fd);
    
    $stop();

end


initial clk = 0;
always #10_000 clk = ~clk;

endmodule