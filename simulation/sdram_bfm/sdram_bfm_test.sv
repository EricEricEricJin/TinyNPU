module sdram_bfm_test;

localparam int SDRAM_W = 128;

logic clk, rst_n;

sdram_read_intf i_sdram_read_intf();

logic [31:0]             address;
logic [10:0]             burstcount;
logic                    waitrequest;
logic [SDRAM_W-1:0]      readdata;
logic                    readdatavalid;
logic                    read;
logic [SDRAM_W-1:0]      writedata;
logic [15:0]             byteenable;
logic                    write;

sdram_slave_bfm #(
    .SDRAM_W        (128),
    .RD_MEM_FILE    ("simulation/sdram_bfm/rd_mem.bin"),
    .RD_MEM_SIZE    (1024*1024),
    .RD_MEM_OFFSET  (512*1024*1024),
    .WT_MEM_FILE    ("simulation/sdram_bfm/wt_mem.bin"),
    .WT_MEM_SIZE    (1024*1024),
    .WT_MEM_OFFSET  (512*1024*1024)
) i_sdram_slave_bfm (
    .clk    (clk),
    .rst_n  (rst_n),
    .address    (address),
    .burstcount (burstcount),
    .waitrequest    (waitrequest),
    .readdata   (readdata),
    .readdatavalid  (readdatavalid),
    .read   (read),
    .writedata  (writedata),
    .byteenable (byteenable),
    .write  (write)
);


avmm_sdram_read_wrapper #(
    .SDRAM_DATA_W (128)
) sdram (
    .clk    (clk),
    .rst_n  (rst_n),

    .readdata       (readdata),
    .readdatavalid  (readdatavalid),
    .waitrequest    (waitrequest),
    .read           (read),
    .address        (address),
    .burstcount     (burstcount),

    .read_addr  (i_sdram_read_intf.read_addr),
    .read_cnt   (i_sdram_read_intf.read_cnt),
    .read_start (i_sdram_read_intf.read_start),
    .read_valid (i_sdram_read_intf.read_valid),
    .read_data  (i_sdram_read_intf.read_data),
    .read_done  (i_sdram_read_intf.read_done)
); 


initial begin
    clk = 0;
    rst_n = 0;

    i_sdram_slave_bfm.read_file_to_mem();

    i_sdram_read_intf.read_addr = 32'h20_000_000;
    i_sdram_read_intf.read_cnt = 11;
    i_sdram_read_intf.read_start = 0;
    
    @(negedge clk) rst_n = 1;

    i_sdram_read_intf.read_start = 1;
    @(negedge clk) i_sdram_read_intf.read_start = 0;

    fork
        begin
            forever begin
                @(posedge i_sdram_read_intf.read_valid);
                $display("Read data: %x", i_sdram_read_intf.read_data);
            end
        end
        begin
            @(posedge i_sdram_read_intf.read_done);
            $display("Read done");
            @(negedge clk);
            $stop();
        end
    join

end

always #5 clk = ~clk;

endmodule
