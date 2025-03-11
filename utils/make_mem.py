# Dump parameters into memory file for simulation

import numpy as np

class MakeMem:
    def __init__(self, size_MB):
        self.mem = np.zeros(size_MB * 2**20, dtype=np.uint8)

    def add_mat(self, address, npy_file):
        addr = address
        for line in npy_file:
            self.mem[addr:addr+len(line)] = line
            addr += len(line)

    def add_bytes(self, address, bytes):
        pass

    def __bytes__(self):
        return bytes(self.mem)
    
    def save(self, filename):
        with open(filename, "wb") as f:
            f.write(self.mem)


if __name__ == "__main__":
    mm = MakeMem(1)
    arr = np.fromfile("../test_data/x_768.bin", dtype=np.uint8)
    arr = arr.reshape(-1, 176)
    print(arr.shape)
    mm.add_mat(0, arr)
    mm.save("mem.bin")

    