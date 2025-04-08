# Dump parameters into memory file for simulation

import numpy as np

class MakeMem:
    def __init__(self, size_B):
        self.mem = np.zeros(size_B, dtype=np.uint8)

    def add_mat(self, address, arr):
        addr = address
        for line in arr:
            self.mem[addr:addr+len(line)] = line
            addr += len(line)

    def add_bytes(self, address, bytes):
        self.mem[address:address+len(bytes)] = bytes

    def add_fp16(self, address, val):
        buf = np.frombuffer(np.float16(val).tobytes(), dtype=np.uint8)
        # buf = buf[::-1]
        print("fp16", buf)
        self.mem[address:address+2] = buf

    def add_int8(self, address, val):
        self.mem[address] = np.int8(val)

    def __bytes__(self):
        return bytes(self.mem)
    
    def save(self, filename):
        # with open(filename, "wb") as f:
        #     f.write(self.mem)
        self.mem.tofile(filename, )


if __name__ == "__main__":
    mm_w = MakeMem(176*176+16)
    arr = np.load("w_641.npy")

    s = 0.013350207369103884
    zx = -11
    zw = 0
    zy = 25

    for i in range(4):
        w = arr[176*i : 176*(i+1), :]
        mm_w.add_mat(0, w)
        mm_w.add_int8(176*176, zx)
        mm_w.add_int8(176*176+4, zw)
        mm_w.add_int8(176*176+8, zy)
        mm_w.add_fp16(176*176+12, s)
        mm_w.save(f"stmm_w{i}.bin")

    s = 0.008486759084962672
    zx = -128
    zw = 0
    zy = 10
    arr = np.load("w_639.npy").T
    print(arr.shape)
    for i in range(4):
        w = arr[176*i : 176*(i+1), :]
        mm_w.add_mat(0, w)
        mm_w.add_int8(176*176, zx)
        mm_w.add_int8(176*176+4, zw)
        mm_w.add_int8(176*176+8, zy)
        mm_w.add_fp16(176*176+12, s)
        mm_w.save(f"stmm2_w{i+4}.bin")