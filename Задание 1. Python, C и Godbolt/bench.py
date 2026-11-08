import csv
import random
import statistics
import time
from student import matmul

n = 256
runs = 5
rows = []

for run in range(1, runs + 1):
    a = [[random.random() for _ in range(n)] for _ in range(n)]
    b = [[random.random() for _ in range(n)] for _ in range(n)]

    t0 = time.perf_counter()
    c = matmul(a, b)
    t = time.perf_counter() - t0

    rows.append((run, t, 2 * n**3 / t / 1e9))
    print(f"run {run}: {t:.3f} s, {rows[-1][2]:.4f} GFLOPS, c[0][0]={c[0][0]:.3f}")

with open("python-matmul.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["run", "seconds", "gflops"])
    w.writerows(rows)

med = statistics.median(r[1] for r in rows)
print(f"median: {med:.3f} s, {2 * n**3 / med / 1e9:.4f} GFLOPS")
print(f"оценка для n = 1024: {med * 64:.0f} s")

"""
run 1: 1.092 s, 0.0307 GFLOPS, c[0][0]=68.583
run 2: 1.107 s, 0.0303 GFLOPS, c[0][0]=69.538
run 3: 1.103 s, 0.0304 GFLOPS, c[0][0]=68.503
run 4: 1.084 s, 0.0310 GFLOPS, c[0][0]=63.567
run 5: 1.087 s, 0.0309 GFLOPS, c[0][0]=67.376
median: 1.092 s, 0.0307 GFLOPS
оценка для n = 1024: 70 s
"""
"""Почему умножаем на 64: В алгоритме 3 вложенных цикла, поэтому время растет в кубе от размера матрицы n^3. 
Размер вырос в 4 раза (с 256 до 1024), значит, времени нужно в 4^3 = 64 раза больше.
Сколько операций для 1024*1024: Формула числа операций 2n^3 (умножение + сложение на каждом шаге). 
2*1024^3 = около 2.15 миллиарда"""