import csv
import statistics
import matplotlib.pyplot as plt

data = {}
with open("matmul.csv", encoding="utf-8-sig") as f:
    for row in csv.DictReader(f):
        key = (row["method"], int(row["n"]))
        data.setdefault(key, []).append(float(row["seconds"]))

methods = ["ijk", "ikj", "jik", "jki", "kij", "kji"]
colors = ["#0072B2", "#E69F00", "#009E73", "#D55E00", "#CC79A7", "#56B4E9"]
markers = ["o", "s", "^", "D", "v", "P"]

for method, color, marker in zip(methods, colors, markers):
    ns = sorted(n for (m, n) in data if m == method)
    med = [statistics.median(data[(method, n)]) for n in ns]
    plt.plot(ns, med, marker=marker, color=color, label=method)

plt.xscale("log")
plt.yscale("log")
plt.xlabel("размер матрицы n")
plt.ylabel("медиана времени, с")
plt.legend()
plt.grid(True, which="both")
plt.tight_layout()
plt.savefig("matmul-orders.png", dpi=150)
# ВЫВОДЫ ПО РАБОТЕ:
# 1. Порядки циклов (C, -O2):
#    - Быстрые (ikj, kij): обход b[k][j] и c[i][j] подряд по строкам, кэш работает идеально (~2.5 GFLOPS).
#    - Средние (ijk, jik): a[i][k] идет по строке, но b[k][j] прыгает по столбцу (~1.0 GFLOPS).
#    - Медленные (jki, kji): обход a[i][k] и c[i][j] по столбцам, промахи кэша (~0.25 GFLOPS).
#
# 2. Сравнение скорости (n=512, порядок ikj):
#    - Python (n=256): 0.03 GFLOPS
#    - C (-O0): 0.75 GFLOPS
#    - C (-O2): 2.28 GFLOPS
#    - C (-O3 -march=native): 17.17 GFLOPS (векторизация AVX2 + FMA, ускорение в 560 раз к Python).
#
# 3. Наклон графика:
#    Равен ~3 из-за кубической сложности O(n^3). При n=512 наклон чуть больше 3,
#    так как матрицы (6 МБ) превышают размер кэша L2 (512 КБ) и идут обращения к L3/RAM.
#
# 4. Сравнение ijk и ikj в Godbolt (x86-64 gcc -O2 -masm=intel):
#    - В ijk (цикл по k, .L4): обращения к b[k][j] идут С ШАГОМ В СТРОКУ (+6144 байта: add rax, 6144,
#      где 768 * 8 = 6144), а к a[i][k] — подряд (add rdx, 8).
#    - В ikj (цикл по j): обращения к b[k][j] и c[i][j] идут ПОДРЯД по соседним ячейкам (+8 / +16 байт),
#      а элемент a[i][k] фиксируется в регистре до начала цикла.