import numpy as np

l = ["fread", "syscall"]
n = ["64", "128", "512", "1024", "4096", "16384", "65336", "262144"]
prefixes = ["real", "sys", "usr"]

def process_file(t, i, pre):
    with open(t + "/" + pre + "_times_" + i + ".txt", "r") as file:
        nums = [float(line.strip()) for line in file]
        print(t + " | " + i + " | " + pre + " | "  + str(np.mean(nums)) + " | " + str(np.std(nums, ddof=1)))

for t in l:
    for i in n:
        for p in prefixes:
            process_file(t, i, p)


