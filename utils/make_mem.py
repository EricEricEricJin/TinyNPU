# Dump parameters into memory file for simulation

import numpy as np

class MakeMem:
    def __init__(self, size_MB):
        self.mem = np.zeros(size_MB * 2**20, dtype=np.uint8)

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
    mm_in = MakeMem(1)
    # arr = np.fromfile("../test_data/x_768.bin", dtype=np.uint8)
    arr = np.load("x_786.npy")
    print(arr[0,0:10])
    # arr = arr.reshape(-1, 176)
    print(arr.shape)
    mm_in.add_mat(0, arr)
    mm_in.save("mem_in.bin")

    mm_w = MakeMem(1)
    arr = np.load("w_641.npy")
    print(arr.shape)
    # exit()
    arr = arr[0 : 176, :]
    print(arr.shape)
    mm_w.add_mat(0, arr)

    s = 0.013350207369103884
    zx = -11
    zw = 0
    zy = 25

    mm_w.add_int8(176*176, zx)
    mm_w.add_int8(176*176+4, zw)
    mm_w.add_int8(176*176+8, zy)
    mm_w.add_fp16(176*176+12, s)

    mm_w.save("mem_w.bin")
