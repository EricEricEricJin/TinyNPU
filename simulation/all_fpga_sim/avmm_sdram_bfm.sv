`default_nettype none

module avmm_sdram_bfm #(
    parameter int       SDRAM_W         = 128,
    parameter string    RD_MEM_FILE     = "rd_mem.bin",
    parameter int       RD_MEM_SIZE     = 1024*1024,
    parameter int       RD_MEM_OFFSET   = 512*1024*1024,
    parameter string    WT_MEM_FILE     = "wt_mem.bin",
    parameter int       WT_MEM_SIZE     = 1024*1024,
    parameter int       WT_MEM_OFFSET   = 512*1024*1024
) (
    input  wire                     clk, 
    input  wire                     rst_n,
    
    // ---------- Bi-direction SDRAM signals ----------
    input  wire [31:0]             address,
    input  wire [10:0]             burstcount,
    output logic                    waitrequest,
    output logic [SDRAM_W-1:0]     readdata,
    output logic                    readdatavalid,
    input  wire                     read,
    input  wire [SDRAM_W-1:0]      writedata,
    input  wire [15:0]             byteenable,
    input  wire                     write
);

task wait_sometime();
    repeat($urandom_range(7, 37)) @(negedge clk);
endtask

logic [31 : 0] mem [0 : RD_MEM_SIZE / 4 - 1];

task read_file_to_mem();
    int i;
    int fd;
    int n;

    // open file
    fd = $fopen(RD_MEM_FILE, "rb");
    if (fd == 0) begin
        $display("Error: cannot open file %s", RD_MEM_FILE);
        $stop();
    end

    // read into mem arr
    // n = $fread(mem, fd);
    // for(i = 0; i < 16; i++) begin
    //     $display("%h", mem[i]);
    // end
    
    for (i = 0; i < (RD_MEM_SIZE / 4) && !$feof(fd); i++) begin
        for (int j = 0; j < 4; j++) begin
            mem[i][j*8 +: 8] = $fgetc(fd);
        end
    end
    n = i;
    
    $fclose(fd);
    $display("%d words read from %s to addr %d.", n, RD_MEM_FILE, RD_MEM_OFFSET);
endtask

logic [31 : 0] address_reg;
logic [10 : 0] burstcount_reg;

// process read
always @(negedge clk, negedge rst_n) begin
    int i, j, k;
    logic [SDRAM_W - 1 : 0] readdata_temp;

    if (read && rst_n) begin
        // wait request for some time 
        // $display("Read operation start, waiting...");
        
        waitrequest = 1;
        wait_sometime();
        address_reg = (address - RD_MEM_OFFSET) / 4;
        burstcount_reg = burstcount;
        $display("Read wait done. address: %h, burstcount: %d", address, burstcount);
        waitrequest = 0;

        // read from memory
        for (i = 0; i < burstcount_reg; i++) begin
            // read data  
            for (j = 0; j < 4; j++) begin
                readdata_temp[j*32 +: 32] = mem[address_reg + i*4 + j];
            end

            wait_sometime();

            // set read valid
            readdata = readdata_temp;
            $display("%s Read data: %h", RD_MEM_FILE, readdata);
            readdatavalid = 1;
            @(negedge clk) readdatavalid = 0;
        end
        // $display("Read operation done.");
    end
    else begin
        readdata = 'x;
        readdatavalid = 0;
    end    
end

// process write
always @(negedge clk, negedge rst_n) begin
    if (write && rst_n) begin
        // $display("Write operation start, waiting...");

        // wait request for some time 
        waitrequest = 1;
        wait_sometime();
        address_reg = (address - WT_MEM_OFFSET) / 4;
        burstcount_reg = burstcount;
        $display("Write wait done. address: %h, burstcount: %d", address, burstcount);
        waitrequest = 0;

        // write to memory
        for (int i = 0; i < burstcount_reg; ) begin
            @(posedge clk);
            if (write) begin
                for (int j = 0; j < SDRAM_W/32; j++) begin
                    for (int k = 0; k < 32/8; k++) begin
                        if (byteenable[j*(SDRAM_W/32) + k]) begin
                            mem[address_reg + i*4 + j][k*8 +: 8] = writedata[j*32 + k*8 +: 8];
                        end
                    end
                end
                i++;
            end                
        end
        // $display("Write operation done.");
    end
end

task write_mem_to_file();
    int fd;
    int n;
    int i, j;

    $display("Writing memory to file %s...", WT_MEM_FILE);
    
    // open file 
    fd = $fopen(WT_MEM_FILE, "wb");
    if (fd == 0) begin
        $display("Error: cannot open file %s", WT_MEM_FILE);
        $stop();
    end

    // write to file
    // n = $fwrite(fd, "%u", mem);

    for (i = 0; i < (WT_MEM_SIZE / 4); i++) begin
        for (j = 0; j < 4; j++) begin
            $fwrite(fd, "%c", mem[i][j*8 +: 8]);
        end
    end
    n = i;


    $fclose(fd);
    $display("%d words written to file %s.", n, WT_MEM_FILE);
endtask

endmodule

`default_nettype wire
