`default_nettype none

package avmm_sdram_bfm_pkg;

class avmmSdramBfm #( parameter int SDRAM_W = 128 );

int size;
int offset;

logic [7 : 0] mem [];

function new(int size, int offset);
    this.size = size;
    this.offset = offset;
    this.mem = new[size];
endfunction

task read_file_to_mem(string filename, int addr, int size);

    int i;
    int fd;
    int n;

    addr = addr - this.offset;
    assert (addr >= 0 && addr + size <= this.size) else begin
        $display("Error: address %d out of range.", addr);
        $stop();
    end

    // open file
    fd = $fopen(filename, "rb");
    assert (fd != 0) else begin
        $display("Error: cannot open file %s", filename);
        $stop();
    end
    
    for (i = 0; i < size && !$feof(fd); i++) begin
        mem[addr + i] = $fgetc(fd);
    end
    assert (i == size) else begin
        $display("Error: read %d expect %d", i, size);
        $stop();
    end

    $fclose(fd);
    $display("%d bytes read from %s to addr %d.", i, filename, offset);
endtask

task write_mem_to_file(string filename);

    int i;
    int fd;

    fd = $fopen(filename, "wb");
    assert (fd != 0) else begin
        $display("Error: cannot open file %s", filename);
        $stop();
    end
        
    for (i = 0; i < this.size; i++) begin
        $fwrite(fd, "%c", mem[i]);
    end

    $fclose(fd);
    $display("%d bytes write to %s from addr %d.", i, filename, offset);

endtask

task automatic wait_sometime(ref logic clk);
    repeat($urandom_range(7, 37)) @(negedge clk);
endtask

task automatic run(
    ref logic clk,

    ref logic [31 : 0]  address,
    ref logic [10 : 0]  burstcount,
    ref logic           waitrequest,

    ref logic                   read,
    ref logic [SDRAM_W - 1 : 0] readdata,
    ref logic                   readdatavalid,

    ref logic                   write,
    ref logic [SDRAM_W - 1 : 0] writedata,
    ref logic [15 : 0]          byteenable
);

logic [31 : 0] address_reg;
logic [10 : 0] burstcount_reg;
int idx;

forever begin

    int i,j;
    logic [SDRAM_W - 1 : 0] readdata_temp;

    // process read
    @(negedge clk);
    // $display("SDRAM BFM Run");

    assert (!(read && write)) else begin
        $display("Error: read and write at the same time.");
        $stop();
    end

    if (read) begin
        $display("Read request");

        waitrequest = 1;
        wait_sometime(clk);

        address_reg = (address);
        burstcount_reg = burstcount;
        waitrequest = 0;
        $display("Read address=0x%h, burstcount=%d", address_reg, burstcount_reg);

        for (i = 0; i < burstcount_reg; i++) begin

            for (j = 0; j < SDRAM_W / 8; j++) begin
                idx = (address_reg - offset + i * SDRAM_W / 8 + j);
                assert (idx >= 0 && idx < size) else begin
                    $display("Error: address %d out of range.", idx);
                    $stop();
                end
                readdata_temp[j*8 +: 8] = mem[idx];
            end

            wait_sometime(clk);
            readdata = readdata_temp;
            readdatavalid = 1;
            @(negedge clk) readdatavalid = 0;
        end
        $display("Read done.");
    end else begin
        readdatavalid = 0;
        readdata = 'x;
    end
    
    if (write) begin

        waitrequest = 1;
        wait_sometime(clk);
        address_reg = (address);
        burstcount_reg = burstcount;
        waitrequest = 0;
        $display("Write address=0x%h, burstcount=%d", address_reg, burstcount_reg);

        for (i = 0; i < burstcount_reg; ) begin
            @(posedge clk);
            if (write) begin
                for (j = 0; j < SDRAM_W / 8; j++) begin
                    idx = (address_reg - offset + i * SDRAM_W / 8 + j);
                    assert (idx >= 0 && idx < size) else begin
                        $display("Error: address %d out of range.", idx);
                        $stop();
                    end
                    if (byteenable[j]) begin
                        mem[idx] = writedata[j*8 +: 8];
                    end
                end
                i++;
            end
        end
        $display("Write done.");
    end


end

endtask

endclass

    
endpackage

`default_nettype wire
