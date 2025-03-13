`default_nettype none


module sdram_slave_bfm #(
    parameter int       SDRAM_W         = 128,
    parameter string    RD_MEM_FILE     = "rd_mem.bin",
    parameter int       RD_MEM_SIZE     = 1024*1024,
    parameter int       RD_MEM_OFFSET   = 512*1024*1024,
    parameter string    WT_MEM_FILE     = "wt_mem.bin",
    parameter int       WT_MEM_SIZE     = 1024*1024,
    parameter int       WT_MEM_OFFSET   = 512*1024*1024
) (
    input wire      clk, 
    input wire      rst_n,
    sdram_intf      sdram
);


logic [31 : 0] mem [0 : RD_MEM_SIZE / 4 - 1];


task read_file_to_mem();
    int i;
    // open file
    int fd;
    fd = $fopen(RD_MEM_FILE, "rb");
    if (fd == 0) begin
        $display("Error: cannot open file %s", RD_MEM_FILE);
        $stop();
    end

    // read into mem arr
    for (i = 0; i < (RD_MEM_SIZE / 4) && !$feof(fd); i++) begin
        for (int j = 0; j < 4; j++) begin
            mem[i][j*8 +: 8] = $fgetc(fd);
        end
    end    

    $display("%d words read from %s to addr %d.", i, RD_MEM_FILE, RD_MEM_OFFSET);    
endtask



logic [31 : 0] address;
logic [10 : 0] burstcount;

// process read
always @(negedge clk, negedge rst_n) begin

    int i, j, k;
    logic [SDRAM_W - 1 : 0] readdata;

    if (sdram.read && rst_n) begin
        // wait request for some time 

        $display("Read operation start, waiting...");
        
        sdram.waitrequest = 1;
        repeat($urandom_range(10, 100)) @(negedge clk);
        address = (sdram.address - RD_MEM_OFFSET) / 4;
        burstcount = sdram.burstcount;
        $display("Read wait done. address: %h, burstcount: %d", sdram.address, sdram.burstcount);
        sdram.waitrequest = 0;


        // read from memory
        for (i = 0; i < burstcount; i++) begin
            // read data  
            for (j = 0; j < 4; j++) begin
                readdata[j*32 +: 32] = mem[address + i*4 + j];
            end

            // wait for some time
            repeat($urandom_range(10, 100)) @(negedge clk);

            // set read valid
            sdram.readdata = readdata;
            sdram.readdatavalid = 1;
            @(negedge clk) sdram.readdatavalid = 0;
        end
        $display("Read operation done.");
    end
    else begin
        sdram.readdata = 'x;
        sdram.readdatavalid = 0;
        // sdram.waitrequest = 0;        
    end    
end


// process write
always @(negedge clk, negedge rst_n) begin

    if (sdram.write && rst_n) begin
        
        $display("Write operation start, waiting...");

        // wait request for some time 
        sdram.waitrequest = 1;
        repeat($urandom_range(10, 30)) @(negedge clk);
        address = (sdram.address - WT_MEM_OFFSET) / 4;
        burstcount = sdram.burstcount;
        $display("Write wait done. address: %h, burstcount: %d", sdram.address, sdram.burstcount);
        sdram.waitrequest = 0;

        // write to memory
        for (int i = 0; i < burstcount; ) begin
            @(posedge clk);
            if (sdram.write) begin
                for (int j = 0; j < SDRAM_W/32; j++) begin
                    for (int k = 0; k < 32/8; k++) begin
                        if (sdram.byteenable[j*(SDRAM_W/32) + k]) begin
                            // $display("byte %h bit %h data %h", address + i*4 + j, k*8, j*32 + k*8);
                            mem[address + i*4 + j][k*8 +: 8] = sdram.writedata[j*32 + k*8 +: 8];
                        end
                    end
                end
                i++;
            end                
        end
        $display("Write operation done.");
    end
end

task write_mem_to_file();
    int fd;
    int i, j;

    $display("Writing memory to file %s...", WT_MEM_FILE);
    
    // open file 
    fd = $fopen(WT_MEM_FILE, "wb");
    if (fd == 0) begin
        $display("Error: cannot open file %s", WT_MEM_FILE);
        $stop();
    end

    for (i = 0; i < (WT_MEM_SIZE / 4); i++) begin
        for (j = 0; j < 4; j++) begin
            $fwrite(fd, "%c", mem[i][j*8 +: 8]);
        end
    end

    $fclose(fd);
    $display("%i words written to file %s.", WT_MEM_FILE);
endtask


endmodule


`default_nettype wire
