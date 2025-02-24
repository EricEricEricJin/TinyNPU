`timescale 1 ps / 1 ps

task automatic load_mem (
    ref logic clk,
    
    input string fp,

    ref logic we,
    ref logic[31 : 0] addr,
    ref logic[31 : 0] data    
);

int fd;
int j;

we = 0;
addr = '0;
data = '0;

fd = $fopen(fp, "rb");

@(negedge clk);
for (addr = 0; !$feof(fd); addr+=4) begin
    for (j = 0; j < 4; j++)
    data[8 * j +: 8] = $fgetc(fd);
    we = 1;
    @(negedge clk) we = 0;
end

$fclose(fd);

endtask


module cpu_sim_tb;

localparam INST_MEM_FILE = "simulation/cpu_sim/addi.bin";

logic clk, rst_n;

// Instruction Connection

// to CPU
wire [13 : 0] cpu_inst_addr;
wire [31 : 0] cpu_inst_data;

// to TB
logic [31 : 0] tb_inst_addr;
logic [31 : 0] tb_inst_data;
logic inst_we;

// to mem
wire [13 : 0] ram_inst_addr;

// Data memory connection
logic [13 : 0] data_addr;
logic data_we;
logic [31 : 0] data_d;
logic [31 : 0] data_q;

// State output 
logic ebreak;

////////////////////////
// CPU
////////////////////////
cpu i_cpu (
    .clk        (clk),
    .rst_n      (rst_n),

    .inst_addr  (cpu_inst_addr),
    .inst_data  (cpu_inst_data),
    
    .data_addr  (data_addr),
    .data_we    (data_we),
    .data_d     (data_d),
    .data_q     (data_q),

    .ebreak     (ebreak)
);
    
////////////////////////
// Inst and Data RAM
////////////////////////


// ram_32x256 i_inst_mem (
//     .address    (ram_inst_addr[9 : 2]),
//     .clock      (clk),
//     .data       (tb_inst_data),
//     .wren       (inst_we),
//     .q          (cpu_inst_data)
// );
inst_mem #( .DEPTH (256) ) i_inst_mem (
    .addr   (ram_inst_addr[9 : 2]),
    .clk    (clk),
    .data   (tb_inst_data),
    .we     (inst_we),
    .q      (cpu_inst_data)
);

assign ram_inst_addr = inst_we ? tb_inst_addr : cpu_inst_addr;

ram_32x256 i_data_mem (
	.address    (data_addr[9 : 2]),
	.clock      (clk),
	.data       (data_d),
	.wren       (data_we),
    .q          (data_q)
);

initial begin
    logic [31 : 0] rf_mem[0 : 31];
    
    clk = 0;
    rst_n = 0;

    // fetch instructions into imem
    load_mem(
        .clk    (clk),
        .fp     (INST_MEM_FILE),
        .we     (inst_we),
        .addr   (tb_inst_addr),
        .data   (tb_inst_data) 
    );

    // start
    @(negedge clk) rst_n = 1;

    // check RF
    @(posedge ebreak);
    for (int i = 0; i < 32; i++)
        rf_mem[i] = i_cpu.i_rf32.rf_mem[i];
    
    // Check result
    for (int i = 0; i < 32; i++) begin
        $display("dx%d = %x", i, rf_mem[i]);
    end

    $stop();

end

// 400MHz
// T = 1000_000_000_000 / 400_000_000 = 2500
always #1250 clk = ~clk;

endmodule
