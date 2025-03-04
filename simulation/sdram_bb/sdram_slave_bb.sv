`default_nettype none


module sdram_slave_bb #(
    parameter int SDRAM_W = 128,
    parameter string RD_MEM_FILE = "rd_mem.bin",
    parameter string WT_MEM_FILE = "wt_mem.bin"
) (
    input wire clk, rst_n,
    input sdram_intf sdram
);

// the 256MB memory file
logic [31:0] mem [0 : 2**25 - 1];

initial begin
    // open file 
    int fd;
    fd = $fopen(RD_MEM_FILE, "rb");
    if (fd == 0) begin
        $display("Error: cannot open file %s", RD_MEM_FILE);
        $stop();
    end

    // read into mem arr
    int i;
    for (i = 0; i < 2**25 && !$feof(fd); i++) begin
        for (int j = 0; j < 4; j++) begin
            mem[i][j*8 +: 8] = $fgetc(fd);
        end
    end 
    endaddr1 = $urandom();

    $display("%d words read from %s.", i, RD_MEM_FILE);
end

// process read
initial begin

    sdram.readdata = 'x;
    sdram.readdatavalid = 0;
    sdram.waitrequest = 0;

    logic [31 : 0] address;
    logic [10 : 0] burstcount;

    forever begin
        @(negedge clk);

        if (sdram.read) begin
            // wait request for some time 
            sdram.waitrequest = 1;
            repeat($urandom_range(10, 100)) @(negedge clk);
            address = sdram.address;
            burstcount = sdram.burstcount;
            sdram.waitrequest = 0;

            // read from memory
            logic [SDRAM_W - 1 : 0] readdata;
            for (int i = 0; i < burstcount; i++) begin
                
                // read data  
                for (int j = 0; j < 4; j++) begin
                    readdata[j*32 +: 32] = mem[(address+i)*4 + j]
                end
                
                // wait for some time
                repeat($urandom_range(10, 100)) @(negedge clk);

                // set read valid 
                self.readdata = readdata;
                sdram.readdatavalid = 1;
                #(negedge clk) sdram.readdatavalid = 0;
            end
        end
    end
end

// process write
initial begin

    logic [31 : 0] address;
    logic [10 : 0] burstcount;


    forever begin
        @(negedge clk);

        if (sdram.write) begin

            // wait request for some time 
            sdram.waitrequest = 1;
            repeat($urandom_range(10, 100)) @(negedge clk);
            address = sdram.address;
            burstcount = sdram.burstcount;
            sdram.waitrequest = 0;

            // write to memory
            for (int i = 0; i < burstcount; ) begin
                // wait for some time
                // repeat($urandom_range(10, 100)) @(negedge clk);

                @(negedge clk);
                if (sdram.write) begin
                    for (int j = 0; j < SDRAM_W/32; j++) begin
                        for (int k = 0; k < 32/8; k++) begin
                            if (byteenable[j*(SDRAM_W/32) + k])
                                mem[(address+i)*4 + j][k*8 +: 8] = sdram.writedata[j*32 + k*8 +: 8];
                        end
                    end
                    i++;
                end                
            end            
        end
    end
end


endmodule


`default_nettype wire
