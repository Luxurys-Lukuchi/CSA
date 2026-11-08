"""Get-CimInstance Win32_Processor | Format-List Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed


Name                      : AMD Ryzen 5 4600H with Radeon Graphics
NumberOfCores             : 6
NumberOfLogicalProcessors : 12
MaxClockSpeed             : 3000



Get-CimInstance Win32_CacheMemory | Format-Table Purpose, InstalledSize

Purpose    InstalledSize
-------    -------------
L1 - Cache           384
L2 - Cache          3072
L3 - Cache          8192
"""

import os, platform
import cpuinfo
import psutil

print(platform.machine())    # x86_64, aarch64, ...
print(os.cpu_count())        # сколько логических ядер
print (platform.processor())

#AMD64
#12
#AMD64 Family 23 Model 96 Stepping 1, AuthenticAMD

# 1. Получаем данные о частоте и флагах процессора
info = cpuinfo.get_cpu_info()
flags = info.get("flags", [])
freq_ghz = psutil.cpu_freq().max / 1000  # Переводим МГц в ГГц (3000 -> 3.0)

# 2. Проверяем поддержку векторных инструкций и выбираем ширину вектора (для float / FP32)
if "avx512f" in flags:
    simd_type, width = "AVX-512", 16
elif "avx2" in flags:
    simd_type, width = "AVX2", 8
elif "sse" in flags:
    simd_type, width = "SSE", 4
else:
    simd_type, width = "Скалярный режим", 1

# 3. Считаем пик одного ядра в GFLOPS
gflops_basic = freq_ghz * width  # Базовая формула: Частота * Ширина вектора
gflops_fma = gflops_basic * 2  # С учетом FMA (умножение + сложение за 1 такт)
gflops_zen2 = (
    gflops_fma * 2
)  # Реальный пик архитектуры Zen 2 (2 конвейера FMA на ядро)

print(f"Процессор: {info.get('brand_raw')}")
print(f"Базовая частота: {freq_ghz:.2f} ГГц")
print(
    f"Поддержка инструкций: AVX2={'avx2' in flags}, AVX-512={'avx512f' in flags}"
)
print(f"Активный векторный режим: {simd_type} (ширина вектора W = {width})")
print(f"Пик 1 ядра (простая формула f * W):       {gflops_basic:.1f} GFLOPS")
print(f"Пик 1 ядра (с учетом FMA, f * W * 2):     {gflops_fma:.1f} GFLOPS")
print(f"Аппаратный пик 1 ядра Zen 2 (2 блока FMA): {gflops_zen2:.1f} GFLOPS")

"""Процессор: AMD Ryzen 5 4600H with Radeon Graphics
Базовая частота: 3.00 ГГц
Поддержка инструкций: AVX2=True, AVX-512=False
Активный векторный режим: AVX2 (ширина вектора W = 8)
--------------------------------------------------
Пик 1 ядра (простая формула f * W):       24.0 GFLOPS
Пик 1 ядра (с учетом FMA, f * W * 2):     48.0 GFLOPS
Аппаратный пик 1 ядра Zen 2 (2 блока FMA): 96.0 GFLOPS"""
"""Что такое такт: Это один шаг работы процессора. 
Частота 3.0 ГГц означает, что ядро делает 3 миллиарда таких шагов в секунду.

Зачем ядру кэш:RAM слишком медленная пока процессор ждет из неё данные, он простаивает сотни тактов. 
Кэш (L1/L2/L3) это сверхбыстрая память прямо внутри процессора, где хранятся нужные прямо сейчас данные,
 чтобы ядро работало без пауз.

Почему ядер несколько: Если разгонять одно ядро выше 4–5 ГГц, оно начнет потреблять слишком много энергии
 и расплавится от перегрева. Поэтому вместо одного сверхбыстрого ядра делают несколько обычных, 
 которые делят работу между собой."""
