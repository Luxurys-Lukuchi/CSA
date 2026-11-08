import csv
import statistics
import os

# Собираем данные по всем трем флагам (если файлы есть в папке)
files = [("O2 (базовый)", "matmul.csv"), ("O0 (без опт.)", "matmul-O0.csv"), ("O3 + AVX2", "matmul-O3.csv")]
methods = ["ijk", "ikj", "jik", "jki", "kij", "kji"]
sizes = [128, 256, 384, 512]

all_meds = {}

for label, fname in files:
    if not os.path.exists(fname):
        continue
    data = {}
    with open(fname, encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            key = (row["method"], int(row["n"]))
            data.setdefault(key, []).append(float(row["seconds"]))
    
    med_dict = { (m, s): statistics.median(data[(m, s)]) for m in methods for s in sizes if (m, s) in data }
    all_meds[fname] = med_dict

    print("=" * 68)
    print(f" ЧАСТЬ 4. ТАБЛИЦА МЕДИАН ВРЕМЕНИ (с): {fname} [{label}]")
    print("=" * 68)
    header = f"{'Порядок':<10} | " + " | ".join(f"n={s:<8}" for s in sizes)
    print(header)
    print("-" * 68)
    for m in methods:
        row_str = f"{m:<10} | " + " | ".join(f"{med_dict.get((m, s), 0.0):<10.6f}" for s in sizes)
        print(row_str)
    print()

# Выбираем основной файл (matmul.csv, а если нет — matmul-O3.csv или matmul-O0.csv) для текстовых выводов
main_file = "matmul.csv" if "matmul.csv" in all_meds else ("matmul-O3.csv" if "matmul-O3.csv" in all_meds else "matmul-O0.csv")
meds = all_meds[main_file]

fast_128 = min(methods, key=lambda m: meds[(m, 128)])
slow_128 = max(methods, key=lambda m: meds[(m, 128)])
fast_512 = min(methods, key=lambda m: meds[(m, 512)])
slow_512 = max(methods, key=lambda m: meds[(m, 512)])

ratio_128 = meds[(slow_128, 128)] / meds[(fast_128, 128)]
ratio_512 = meds[(slow_512, 512)] / meds[(fast_512, 512)]
diff_128 = meds[(slow_128, 128)] - meds[(fast_128, 128)]
diff_512 = meds[(slow_512, 512)] - meds[(fast_512, 512)]

print("=" * 68)
print(f" ОТВЕТЫ НА ВОПРОСЫ ЧАСТИ 4 (по данным {main_file})")
print("=" * 68)
print(f"1. Маленькие матрицы (n=128):")
print(f"   - Самые быстрые: ikj ({meds[('ikj', 128)]:.6f} с) и kij ({meds[('kij', 128)]:.6f} с) — обход подряд по строкам.")
print(f"   - Самые медленные: {slow_128} ({meds[(slow_128, 128)]:.6f} с) — обход по столбцам.")
print(f"2. Большие матрицы (n=512):")
print(f"   - Лидеры те же: ikj ({meds[('ikj', 512)]:.6f} с) и kij ({meds[('kij', 512)]:.6f} с).")
print(f"   - Аутсайдеры: {slow_512} ({meds[(slow_512, 512)]:.6f} с).")
print(f"3. Как меняется разрыв с ростом размера n:")
print(f"   - Абсолютный разрыв вырос с {diff_128:.6f} с (при n=128) до {diff_512:.6f} с (при n=512).")
print(f"   - Относительный разрыв (медленный / быстрый): при n=128 в {ratio_128:.1f} раза, при n=512 в {ratio_512:.1f} раза")
print(f"     (при n=512 матрицы занимают 6 МБ и выходят за пределы кэша L2 = 512 КБ, промахи кэша стоят дороже).")

if os.path.exists("python-matmul.csv"):
    with open("python-matmul.csv", encoding="utf-8-sig") as f:
        py_times = [float(r["seconds"]) for r in csv.DictReader(f)]
    py_med = statistics.median(py_times)
    print(f"4. Сравнение с Python (Часть 2, n=256):")
    print(f"   - Медиана Python (n=256): {py_med:.6f} с (~0.0307 GFLOPS).")
    for label, fname in files:
        if fname in all_meds:
            m_dict = all_meds[fname]
            t_fast = m_dict[("ikj", 256)]
            t_slow = max(m_dict[(m, 256)] for m in methods)
            print(f"   - Си [{fname}]: лучший (ikj) = {t_fast:.6f} с (быстрее Python в {py_med/t_fast:.1f} раз),")
            print(f"     худший = {t_slow:.6f} с (быстрее Python в {py_med/t_slow:.1f} раз).")

"""
ИТОГИ ЧАСТИ 4 (по точным замерам matmul.csv [-O2], matmul-O0.csv, matmul-O3.csv):

1. Таблица медиан времени (сек) для базовой сборки -O2 (matmul.csv):
   Порядок |   n=128  |   n=256  |   n=384  |   n=512
   --------+----------+----------+----------+----------
   ijk     | 0.004579 | 0.028346 | 0.107563 | 0.249507
   ikj     | 0.001591 | 0.011398 | 0.042266 | 0.118291
   jik     | 0.004706 | 0.030600 | 0.111560 | 0.270233
   jki     | 0.018117 | 0.123582 | 0.449762 | 0.997709
   kij     | 0.001487 | 0.011398 | 0.037769 | 0.096041
   kji     | 0.018236 | 0.132255 | 0.411344 | 0.909786

2. Какие порядки быстрее на маленьких и больших матрицах:
   - На маленьких (n=128): быстрее всего kij (0.001487 с) и ikj (0.001591 с),
     медленнее всего kji (0.018236 с) и jki (0.018117 с).
   - На больших (n=512): лидеры те же — kij (0.096041 с) и ikj (0.118291 с),
     аутсайдеры те же — jki (0.997709 с) и kji (0.909786 с).
   Иерархия не меняется: построчный обход (шаг 8 байт) всегда выигрывает у обхода по столбцам.

3. Как меняется разрыв:
   - В относительном выражении худшие порядки стабильно медленнее лучших в 10.4–12.3 раза.
   - В абсолютном времени разрыв растет кубически O(n^3): от 0.0167 с при n=128
     до 0.9017 с (почти целой секунды) при n=512, так как матрицы (6 МБ) выходят за пределы кэша L2 (512 КБ).

4. Сравнение с Python (Часть 2, n=256, медиана Python = 1.091551 с):
   - C (-O0): лучший (ikj, 0.043066 с) быстрее Python в 25.3 раза, худший (0.071557 с) — в 15.3 раза.
   - C (-O2): лучший (ikj/kij, 0.011398 с) быстрее Python в 95.8 раза, худший (kji, 0.132255 с) — в 8.3 раза.
   - C (-O3 -march=native): лучший (ikj, 0.001922 с) быстрее Python в 567.9 раза за счет AVX2 + FMA.
"""