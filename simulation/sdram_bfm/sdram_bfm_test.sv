module sdram_bfm_test;

logic clk, rst_n;
sdram_intf sdram();

sdram_slave_bfm #(
    .SDRAM_W        (128),
    .RD_MEM_FILE    ("simulation/sdram_bfm/rd_mem.bin"),
    .RD_MEM_SIZE    (1024*1024),
    .RD_MEM_OFFSET  (512*1024*1024),
    .WT_MEM_FILE    ("simulation/sdram_bfm/wt_mem.bin"),
    .WT_MEM_SIZE    (1024*1024),
    .WT_MEM_OFFSET  (512*1024*1024)
) sdram_slave_bfm_inst (
    .clk    (clk),
    .rst_n  (rst_n),
    .sdram  (sdram.avmm_slave)
);

initial begin
    clk = 0;
    rst_n = 0;

    sdram.read = 0;
    sdram.write = 0;

    @(negedge clk) rst_n = 1;

    sdram.address = 32'h20_000_000;
    sdram.burstcount = 8;
    sdram.read = 1;

    @(negedge sdram.waitrequest);
    sdram.address = 'x;
    sdram.burstcount = 'x;
    sdram.read = 0;

    for (int i = 0; i < 8; ) begin
        @(negedge clk);
        if (sdram.readdatavalid) begin
            $display("Read data: %h", sdram.readdata);
            i++;
        end
    end

    repeat(10) @(negedge clk);

    sdram.address = 32'h20_010_000;
    sdram.burstcount = 8;
    sdram.byteenable = 16'hffff;
    sdram.writedata = 128'h1234_5678_9abc_def0_1234_5678_9abc_def0;
    sdram.write = 1;
    @(negedge sdram.waitrequest);
    sdram.address = 'x;
    sdram.burstcount = 'x;    

    for (int i = 0; i < 8; i++) begin
        sdram.write = 1;
        @(negedge clk);
        sdram.writedata = {sdram.writedata[119:0], sdram.writedata[127:120]};
    end
    @(negedge clk) sdram.write = 0;
    
    repeat(10) @(negedge clk);

    sdram_slave_bfm_inst.write_mem_to_file();

    $stop();
end

always #5 clk = ~clk;

endmodule
