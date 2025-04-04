`default_nettype none

package avmm_sdram_bfm_pkg;

class avmmSdramBfm #( parameter int SDRAM_W = 128 );

// import avmm_raw_intf_pkg::*;

local int           size;
local int           offset;
local logic [7 : 0] mem [];

// logic [31 : 0]           address;
// logic [10 : 0]           burstcount;
// logic                    waitrequest;
// logic                    read;
// logic [SDRAM_W - 1 : 0]  readdata;
// logic                    readdatavalid;
// logic                    write;
// logic [SDRAM_W - 1 : 0]  writedata;
// logic [15 : 0]           byteenable;

virtual avmm_raw_intf #(.SDRAM_W(SDRAM_W)) i_avmm_raw_intf;

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

task automatic run( ref logic clk, ref logic rst_n);

logic [31 : 0] address_reg;
logic [10 : 0] burstcount_reg;
int idx;

forever begin

    int i,j;
    logic [SDRAM_W - 1 : 0] readdata_temp;

    // process read
    @(negedge clk);
    if (!rst_n) begin
        $display("continue");
        continue;
    end
    // $display("SDRAM BFM Run");

    assert (!(i_avmm_raw_intf.read && i_avmm_raw_intf.write)) else begin
        $display("Error: read and write at the same time.");
        $display("read=%b, write=%b", i_avmm_raw_intf.read, i_avmm_raw_intf.write);
        $stop();
    end

    if (i_avmm_raw_intf.read) begin
        // $display("Read request");

        i_avmm_raw_intf.waitrequest = 1;
        wait_sometime(clk);

        address_reg = (i_avmm_raw_intf.address);
        burstcount_reg = i_avmm_raw_intf.burstcount;
        i_avmm_raw_intf.waitrequest = 0;
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
            i_avmm_raw_intf.readdata = readdata_temp;
            i_avmm_raw_intf.readdatavalid = 1;
            @(negedge clk) i_avmm_raw_intf.readdatavalid = 0;
        end
        // $display("Read done.");
    end else begin
        i_avmm_raw_intf.readdatavalid = 0;
        i_avmm_raw_intf.readdata = 'x;
    end
    
    if (i_avmm_raw_intf.write) begin

        i_avmm_raw_intf.waitrequest = 1;
        wait_sometime(clk);
        address_reg = (i_avmm_raw_intf.address);
        burstcount_reg = i_avmm_raw_intf.burstcount;
        i_avmm_raw_intf.waitrequest = 0;
        $display("Write address=0x%h, burstcount=%d", address_reg, burstcount_reg);

        for (i = 0; i < burstcount_reg; ) begin
            @(posedge clk);
            if (i_avmm_raw_intf.write) begin
                for (j = 0; j < SDRAM_W / 8; j++) begin
                    idx = (address_reg - offset + i * SDRAM_W / 8 + j);
                    assert (idx >= 0 && idx < size) else begin
                        $display("Error: address %d out of range.", idx);
                        $stop();
                    end
                    if (i_avmm_raw_intf.byteenable[j]) begin
                        mem[idx] = i_avmm_raw_intf.writedata[j*8 +: 8];
                    end
                end
                i++;
            end
        end
        // $display("Write done.");
    end

end


endtask

endclass

    
endpackage

`default_nettype wire
