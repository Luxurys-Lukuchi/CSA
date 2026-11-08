import csv
import statistics
import matplotlib.pyplot as plt

# Список файлов и соответствующие им цвета/метки
configs = [
    ("matmul-O0.csv", "O0 (без оптимизаций)", "gray", "--"),
    ("matmul.csv", "O2 (стандартная)", "#0072B2", "-"),
    ("matmul-O3.csv", "O3 + AVX2 (максимальная)", "#D55E00", "-"),
]

plt.figure(figsize=(9, 6))

for filename, label, color, linestyle in configs:
    data = {}
    try:
        with open(filename, encoding="utf-8-sig") as f:
            for row in csv.DictReader(f):
                if row["method"] == "ikj":  # берем лучший метод ikj
                    key = int(row["n"])
                    data.setdefault(key, []).append(float(row["seconds"]))

        ns = sorted(data.keys())
        med = [statistics.median(data[n]) for n in ns]
        plt.plot(ns, med, marker="o", color=color, linestyle=linestyle, linewidth=2, label=label)
    except FileNotFoundError:
        print(f"Файл {filename} не найден, пропуск.")

plt.xscale("log")
plt.yscale("log")
plt.xlabel("Размер матрицы n", fontsize=12)
plt.ylabel("Медиана времени, с (метод ikj)", fontsize=12)
plt.title("Сравнение флагов оптимизации GCC (-O0 vs -O2 vs -O3)", fontsize=14)
plt.legend(fontsize=11)
plt.grid(True, which="both", linestyle=":", alpha=0.7)
plt.tight_layout()
plt.savefig("matmul-flags-comparison.png", dpi=150)
print("График сохранен в файл matmul-flags-comparison.png")