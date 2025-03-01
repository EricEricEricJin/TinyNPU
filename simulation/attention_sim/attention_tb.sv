module attention_tb;

localparam int M = 166;
localparam int N = 44 

task automatic load_mat (
    ref logic clk,

    input string fp,

    ref logic we,
    ref logic [$clog2(M) - 1 : 0] addr,
    reg logic [N * 8 - 1 : 0] data,
);

int fd;
int j;

we = 0;
addr = '0;
data = '0;

fd = $fopen(fp, "rb");
$display("fd = %d", fd);

@(negedge clk);
for (addr = 0; addr < M; addr++) begin
    for (j = 0; j < N; j++) begin
        data[8 * j +: 8] = $fgetc(fd);        
    end
    we = 1;
    @(negedge clk) we = 0;
end

$fclose(fd);

endtask



logic clk, rst_n;


// << BRAM >>
logic K_we, V_we;

wire [7 : 0] K_addr_dut, V_addr_dut;
logic [7 : 0] K_addr_tb, V_addr_tb;
wire [7 : 0] K_addr_ram, V_addr_ram;
assign K_addr_ram = K_we ? K_addr_tb : K_addr_dut;
assign V_addr_ram = V_we ? V_addr_tb : V_addr_dut;


logic K_data, V_data;
logic [1407 : 0] K_q_4head, V_q_4head;

ram_1408x256 i_ram_K (
    .address    (K_addr),
    .clock      (clk),
    .data       (K_data),
    .wren       (K_we),
    .q          (K_q_4head)
);

ram_1408x256 i_ram_V (
    .address    (V_addr),
    .clock      (clk),
    .data       (V_data),
    .wren       (V_we),
    .q          (V_q_4head)
);

logic [176 * 8 - 1 : 0] Q_in_4head;
logic [44 * 8 - 1 : 0] QKV_out;
logic start;

attention #(.M(166), .N(44)) i_dut (
    .clk            (clk),
    .rst_n          (rst_n),

    .sqrt_d_fp16    (),
    .start          (start),
    .Q_in           (Q_in_4head[176 * 8 - 1 : 132 * 8]),

    .K_ram_addr     (K_addr_dut),
    .K_ram_data     (K_q_4head[176 * 8 - 1 : 132 * 8]),

    .V_ram_addr     (V_addr_dut),
    .V_ram_data     (V_q_4head[176 * 8 - 1 : 132 * 8]),

    .QKV_out        (QKV_out),
    .out_valid      (out_valid)
);


initial begin
    clk = 0;
    rst_n = 0;

    // Load K and V ram
    load_mat ( .clk(clk), .fp("K.bin"), .we(K_we), .addr(K_addr_tb), .data(K_data) );
    load_mat ( .clk(clk), .fp("V.bin"), .we(V_we), .addr(V_addr_tb), .data(V_data) );

    // Load Qin
    // todo: integrate softmax into MHA??
    // add the fucking

        


    @(negedge clk) rst_n = 1;
    @(negedge clk) start = 1;

    @(posedge out_valid);

    $stop();

end

always #5 clk = ~clk;

endmodule