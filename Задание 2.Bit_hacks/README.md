# Лабораторная работа: Битовые алгоритмы, код без ветвлений и сравнение архитектур x86-64 и RISC-V

## Структура репозитория и артефакты работы

В репозитории сохранены все исходные файлы, сгенерированные ассемблерные листинги и исполняемые файлы, подтверждающие выполнение всех этапов работы:
* [`bits.c`](./bits.c) — исходный код с реализацией 9 функций без ветвлений и без неопределенного поведения (UB), модульными тестами и бенчмарком.
* [`swar.s`](./swar.s) — ассемблерный листинг компиляции с программным подсчетом битов (`-O2 -mno-popcnt`).
* [`hw.s`](./hw.s) — ассемблерный листинг компиляции с аппаратной инструкцией подсчета битов (`-O2 -mpopcnt`).
* [`part_b.s`](./part_b.s) — полный ассемблерный листинг всех 9 функций (включая алгоритмы Части B: де Брёйн, двоичный поиск, 64-битные маски).


---


## Часть A. Ядро, отладка и бенчмарк `popcnt`

### 1. Граничные случаи и тестирование
Все функции протестированы на обязательных граничных случаях и на 200 000 псевдослучайных числах (генератор LCG `x = x * 1664525u + 1013904223u`):

| Функция | Граничный вход | Ожидаемый результат | Назначение функции |
|---|---|---|---|
| `bswap32` | `0x0A0B0C0D` | `0x0D0C0B0A` | Перестановка порядка байтов (endianness swap) в 32-битном слове |
| `is_pow2` | `0`, `1`, `2`, `1ull << 63` | `0`, `1`, `1`, `1` | Проверка, является ли 64-битное число степенью двойки |
| `parity32` | `7` (`0b111`), `3` (`0b011`) | `1`, `0` | Четность количества единичных битов (`1` — нечетное, `0` — четное) |
| `popcount32` | `0`, `0xFFFFFFFF` | `0`, `32` | Подсчет количества единичных битов (вес Хэмминга) |
| `sign_extend` | `0xF, 4`; `0x7, 4`; `0x80, 8`; `~0ull, 64` | `-1`, `7`, `-128`, `-1` | Знаковое расширение `b`-битного числа до `int64_t` |
| `sat_add32` | `INT32_MAX, 1`; `INT32_MIN, -1` | `INT32_MAX`, `INT32_MIN` | 32-битное знаковое сложение с насыщением при переполнении |

### 2. Разбор реализации функций Ядра и защита от UB

1. **`bswap32(uint32_t x)`**:
   Выделяет каждый байт масками `0x000000FFu`, `0x0000FF00u`, `0x00FF0000u`, `0xFF000000u`, сдвигает их на зеркальные позиции (`<< 24`, `<< 8`, `>> 8`, `>> 24`) и объединяет побитовым ИЛИ (`|`).
2. **`is_pow2(uint64_t x)`**:
   Формула `x & (x - 1)` сбрасывает младший установленный бит числа. У степеней двойки ровно один единичный бит, поэтому `(x & (x - 1)) == 0`. Чтобы отсечь `x == 0`, вместо запрещенного логического `&&` (создающего ветвление из-за short-circuit вычисления) применено побитовое `&` к результатам двух сравнений: `(x != 0) & ((x & (x - 1)) == 0)`.
3. **`parity32(uint32_t x)`**:
   Последовательно сворачивает 32-битное слово пополам с помощью исключающего ИЛИ: `x ^= x >> 16; x ^= x >> 8; x ^= x >> 4; x ^= x >> 2; x ^= x >> 1;`. В младшем бите `x & 1u` остается сумма всех 32 битов по модулю 2.
4. **`popcount32(uint32_t x)`**:
   Использует параллельное суммирование битов в машинном слове (SWAR):
   * `x = x - ((x >> 1) & 0x55555555u);` — считает единицы в каждой паре бит.
   * `x = (x & 0x33333333u) + ((x >> 2) & 0x33333333u);` — складывает соседние пары в 4-битные группы (нибблы).
   * `x = (x + (x >> 4)) & 0x0F0F0F0Fu;` — складывает нибблы, получая количество единиц в каждом из 4 байтов.
   * `return (x * 0x01010101u) >> 24;` — умножение на `0x01010101u` суммирует все четыре байта в старшем байте (биты 24..31), после чего сдвиг `>> 24` возвращает итоговую сумму.
5. **`sign_extend(uint64_t x, unsigned b)`**:
   * *Защита от сдвига на 64:* В стандарте C сдвиг на разрядность типа или больше (`1ull << 64` при `b = 64`) является неопределенным поведением (UB). В нашей формуле знаковый бит вычисляется как `sign_bit = 1ull << (b - 1u)`. Поскольку `b` лежит в диапазоне `1..64`, величина сдвига `b - 1u` всегда находится в диапазоне `0..63`, что полностью исключает UB.
   * *Маска без UB:* Маска младших `b` бит строится без сдвига на `b` через выражение `low_mask = ((sign_bit - 1u) << 1) + 1u`. При `b = 64` это выражение дает `0xFFFFFFFFFFFFFFFFull`.
   * *Знаковое расширение:* Очищенное значение `val = x & low_mask` расширяется формулой `(int64_t)((val ^ sign_bit) - sign_bit)`: если знаковый бит был равен `0`, `val ^ sign_bit` не меняет бит и вычитание `sign_bit` возвращает `val`; если знаковый бит был равен `1`, `val ^ sign_bit` обнуляет его, а вычитание `sign_bit` устанавливает все старшие разряды от `b-1` до `63` в единицу.
6. **`sat_add32(int32_t a, int32_t b)`**:
   * *Защита от знакового переполнения:* В языке C переполнение знакового `int32_t` при сложении вызывает UB. Поэтому аргументы приводятся к `uint32_t`, где сложение `usum = ua + ub` определено по модулю $2^{32}$.
   * *Детектирование переполнения:* Знаковое переполнение происходит тогда и только тогда, когда у `a` и `b` одинаковый знак (`~(ua ^ ub)` имеет `1` в 31-м бите), а у суммы знак противоположный (`ua ^ usum` имеет `1` в 31-м бите). Бит переполнения равен `ovf = (~(ua ^ ub) & (ua ^ usum)) >> 31`.
   * *Маска насыщения:* Выражение `ovf_mask = 0u - ovf` дает `0xFFFFFFFFu` при переполнении и `0x00000000u` без него. Значение насыщения вычисляется без ветвлений как `sat_val = 0x7FFFFFFFu + (ua >> 31)`: если `a >= 0` (`ua >> 31 == 0`), получаем `0x7FFFFFFF` (`INT32_MAX`); если `a < 0` (`ua >> 31 == 1`), получаем `0x80000000` (`INT32_MIN`).

### 3. Практический опыт отладки: исправление ошибки приведения типов (`FAILED: 91`)
При первоначальном запуске тестов в окружении MinGW-w64 (GCC 13.1.0) попытка вручную сконструировать знаковый тип через вычитание старшего бита `(int64_t)(res & 0x7FFFFFFFFFFFFFFFull) - (int64_t)(res >> 63) - (int64_t)(res >> 63)` привела к провалу тестов на отрицательных числах, так как `res >> 63` давало `1` вместо $2^{63}$:
```text
FAIL sign_extend  got 9223372036854775805, want -1
FAIL sign_extend  got 9223372036854775678, want -128
FAIL sat_add32    got -2, want -2147483648
FAILED: 91
```
Замена этой конструкции на прямое приведение типов фиксированной ширины `(int64_t)((val ^ sign_bit) - sign_bit)` и `(int32_t)((usum & ~ovf_mask) | (sat_val & ovf_mask))` (которое в дополнительном коде для `int32_t`/`int64_t` является штатным и не вызывает UB) полностью устранила ошибку:
```text
PS C:\Users\Lux\Desktop\CSA\2.Bit_hacks> gcc -std=c17 -O2 -Wall -Wextra -Wpedantic -o bits.exe bits.c
PS C:\Users\Lux\Desktop\CSA\2.Bit_hacks> .\bits.exe
OK
```

### 4. Сравнение с ветвящимися версиями (`is_pow2_branchy` и `sat_add32_branchy`)

Исследуемые ветвящиеся функции:
```c
int is_pow2_branchy(uint64_t x) {
    if (x == 0) return 0;
    while (x > 1) {
        if (x & 1) return 0;
        x >>= 1;
    }
    return 1;
}

int32_t sat_add32_branchy(int32_t a, int32_t b) {
    long long s = (long long)a + b;
    if (s > INT32_MAX) return INT32_MAX;
    if (s < INT32_MIN) return INT32_MIN;
    return (int32_t)s;
}
```

**Что оставляет компилятор на `-O2`:**
* **`is_pow2_branchy`**: Ни на x86-64, ни на RISC-V компилятор не сворачивает цикл `while (x > 1)` в битовую формулу `x & (x - 1)`. В ассемблере остается цикл с условными переходами (`je`, `jne` на x86-64; `beqz`, `bnez` на RISC-V), который при случайных входных числах вызывает ошибки предсказателя переходов (branch misprediction).
* **`sat_add32_branchy`**:
  * На **x86-64** компилятор расширяет 32-битные числа до 64 бит (`movsxd`), складывает их и заменяет оба `if` на инструкции условной пересылки **`cmovg`** и **`cmovl`** — переходов не остается.
  * На **RISC-V (`rv64gc`)** в базовой системе команд нет инструкции `cmov`, поэтому компилятор генерирует **два условных перехода (`bge`, `blt`)**. Наша безветвевая версия `sat_add32`, написанная через побитовую маску, компилируется без переходов на обеих архитектурах.

### 5. Измерение производительности `popcount32` и анализ файлов `swar.s` и `hw.s`

В ходе работы были сгенерированы два ассемблерных листинга локальным компилятором GCC 13.1.0:
```powershell
gcc -std=c17 -O2 -mno-popcnt -S -masm=intel bits.c -o swar.s
gcc -std=c17 -O2 -mpopcnt -S -masm=intel bits.c -o hw.s
```

**Фрагмент из [`swar.s`](./swar.s) (строки 135–154, без аппаратного `popcnt`):**
```asm
_popcount32:
LFB61:
    .cfi_startproc
    mov     eax, DWORD PTR [esp+4]
    mov     edx, eax
    shr     edx
    and     edx, 1431655765       ; 0x55555555
    sub     eax, edx
    mov     edx, eax
    shr     eax, 2
    and     eax, 858993459        ; 0x33333333
    and     edx, 858993459        ; 0x33333333
    add     edx, eax
    mov     eax, edx
    shr     eax, 4
    add     eax, edx
    and     eax, 252645135        ; 0x0F0F0F0F
    imul    eax, eax, 16843009    ; 0x01010101
    shr     eax, 24
    ret
```

**Фрагмент из [`hw.s`](./hw.s) (строки 135–141, с флагом `-mpopcnt`):**
```asm
_popcount32:
LFB61:
    .cfi_startproc
    xor     eax, eax
    popcnt  eax, DWORD PTR [esp+4]
    ret
    .cfi_endproc
```
*Вывод по листингу:* Компилятор автоматически распознал SWAR-алгоритм Хэмминга и свернул все 16 арифметико-логических инструкций в одну аппаратную инструкцию `popcnt` (предварительное обнуление `xor eax, eax` устраняет ложную аппаратную зависимость по выходному регистру на процессорах x86).

**Полные протоколы замеров из консоли PowerShell ($N = 2^{22} = 4\,194\,304$ элементов):**

1. **Программный SWAR (`-O2 -mno-popcnt -fno-tree-vectorize`):**
```text
PS C:\Users\Lux\Desktop\CSA\2.Bit_hacks> .\bits_swar.exe -b
run 1: 0.006083 s, sum 67107067
run 2: 0.006298 s, sum 67107067
run 3: 0.008178 s, sum 67107067
run 4: 0.006915 s, sum 67107067
run 5: 0.006141 s, sum 67107067
median 0.006298 s, min 0.006083, max 0.008178, ns/element 1.50
```

2. **Аппаратный `popcnt` (`-O2 -mpopcnt -fno-tree-vectorize`):**
```text
PS C:\Users\Lux\Desktop\CSA\2.Bit_hacks> .\bits_hw.exe -b
run 1: 0.002335 s, sum 67107067
run 2: 0.002517 s, sum 67107067
run 3: 0.002255 s, sum 67107067
run 4: 0.002583 s, sum 67107067
run 5: 0.002206 s, sum 67107067
median 0.002335 s, min 0.002206, max 0.002583, ns/element 0.56
```

3. **Автовекторизация и оптимизация под процессор (`-O3 -march=native`):**
```text
PS C:\Users\Lux\Desktop\CSA\2.Bit_hacks> .\bits_vec.exe -b
run 1: 0.002461 s, sum 67107067
run 2: 0.002506 s, sum 67107067
run 3: 0.002359 s, sum 67107067
run 4: 0.002590 s, sum 67107067
run 5: 0.002327 s, sum 67107067
median 0.002461 s, min 0.002327, max 0.002590, ns/element 0.59
```

**Сводная таблица результатов бенчмарка:**

| Вариант сборки | Медиана (с) | Минимум (с) | Максимум (с) | Время на элемент (`ns/element`) | Ускорение |
|---|---|---|---|---|---|
| `bits_swar.exe` (`-mno-popcnt`) | 0.006298 | 0.006083 | 0.008178 | **1.50 нс** | 1.00x (база) |
| `bits_hw.exe` (`-mpopcnt`) | 0.002335 | 0.002206 | 0.002583 | **0.56 нс** | **2.68x быстрее** |
| `bits_vec.exe` (`-O3 -march=native`) | 0.002461 | 0.002327 | 0.002590 | **0.59 нс** | **2.54x быстрее** |

---

## Часть B. Сложные битовые алгоритмы и анализ файла `part_b.s`

### 1. Математическое и алгоритмическое обоснование
* **`ctz32` (таблица и последовательность де Брёйна)**:
  * Выражение `lsb = x & (0u - x)` в дополнительном коде изолирует младший установленный бит числа $x$, давая точную степень двойки $2^k$ ($k \in [0..31]$).
  * Константа `0x077CB531u` является 32-битной циклической последовательностью де Брёйна $B(2, 5)$: в ее двоичной записи все 32 возможных 5-битных подслова уникальны.
  * Умножение `lsb * 0x077CB531u` эквивалентно сдвигу константы влево на $k$ бит, а сдвиг `>> 27` выделяет старшие 5 бит, однозначно отображая $k$ в индекс массива `debruijn32[idx]`.
* **`clz32` (двоичный поиск по старшей половине)**:
  * Пять шагов покрывают $16, 8, 4, 2, 1$ бит:
    1. `s = (uint32_t)(x <= 0x0000FFFFu) << 4; n += s; x <<= s;` (проверка старших 16 бит: сдвиг на 16 или 0).
    2. `s = (uint32_t)(x <= 0x00FFFFFFu) << 3; n += s; x <<= s;` (проверка старших 8 бит: сдвиг на 8 или 0).
    3. `s = (uint32_t)(x <= 0x0FFFFFFFu) << 2; n += s; x <<= s;` (проверка старших 4 бит: сдвиг на 4 или 0).
    4. `s = (uint32_t)(x <= 0x3FFFFFFFu) << 1; n += s; x <<= s;` (проверка старших 2 бит: сдвиг на 2 или 0).
    5. `s = (uint32_t)(x <= 0x7FFFFFFFu); n += s;` (проверка самого старшего 31-го бита: +1 или +0).
* **`next_pow2` (область определения $x \le 2^{63}$)**:
  * Для $x = 0$ ответ должен быть равен $1$, а для степеней двойки ($1, 2, 4, 8, \dots$) число не должно увеличиваться вдвое. Вычитание `x -= (uint64_t)(x != 0)` уменьшает все положительные числа на 1, но оставляет `0` равным `0` (предотвращая беззнаковый откат `0 - 1` в `UINT64_MAX`).
  * Каскад сдвигов `x |= x >> 1, 2, 4, 8, 16, 32` превращает число вида $0\dots01\text{xxx}\dots\text{x}_2$ в маску из одних единиц $0\dots0111\dots1_2$, а финальное `+ 1u` дает следующую степень двойки.

### 2. Детальный разбор сгенерированного ассемблера из [`part_b.s`](./part_b.s)

**1. Функции `_ctz32` и `_clz32` (строки 160–198 файла `part_b.s`):**
```asm
_ctz32:
LFB62:
    .cfi_startproc
    mov     edx, DWORD PTR [esp+4]
    mov     eax, edx
    neg     eax
    and     eax, edx                              ; lsb = x & -x
    imul    eax, eax, 125613361                   ; lsb * 0x077CB531
    shr     eax, 27                               ; >> 27
    movzx   eax, BYTE PTR _debruijn32.1[eax]      ; чтение из таблицы
    ret

_clz32:
LFB63:
    .cfi_startproc
    mov     eax, DWORD PTR [esp+4]
    xor     edx, edx
    cmp     eax, 65535                            ; x <= 0x0000FFFFu
    setbe   dl                                    ; dl = 0 или 1
    sal     edx, 4                                ; s = dl << 4 (0 или 16)
    mov     ecx, edx
    sal     eax, cl                               ; x <<= s
    xor     ecx, ecx
    cmp     eax, 16777215                         ; x <= 0x00FFFFFFu
    setbe   cl
    sal     ecx, 3                                ; s = cl << 3 (0 или 8)
    sal     eax, cl
    add     edx, ecx                              ; n += s
    xor     ecx, ecx
    cmp     eax, 268435455                        ; x <= 0x0FFFFFFFu
    setbe   cl
    sal     ecx, 2                                ; s = cl << 2 (0 или 4)
    sal     eax, cl
    add     edx, ecx
```

**2. Функции `_next_pow2` и `_sign_extend` (строки 213–299 файла `part_b.s` — работа с 64-битными числами на 32-битных регистрах без ветвлений):**
```asm
_next_pow2:
LFB64:
    .cfi_startproc
    push    ebx
    mov     edx, DWORD PTR [esp+12]               ; старшие 32 бита x
    xor     ecx, ecx
    mov     eax, DWORD PTR [esp+8]                ; младшие 32 бита x
    or      eax, edx                              ; проверка 64-битного x != 0
    mov     eax, DWORD PTR [esp+8]
    mov     edx, DWORD PTR [esp+12]
    setne   cl                                    ; cl = (x != 0)
    sub     eax, ecx                              ; младшая часть x -= (x != 0)
    sbb     edx, 0                                ; вычитание с заемом из старшей части
    mov     ecx, eax
    mov     ebx, edx
    shrd    ecx, ebx, 1                           ; 64-битный сдвиг вправо на 1 (Shift Right Double)
    shr     ebx
    or      ecx, eax
    or      ebx, edx

_sign_extend:
LFB65:
    .cfi_startproc
    push    edi
    push    esi
    mov     eax, DWORD PTR [esp+20]               ; загрузка параметра b
    lea     ecx, [eax-1]                          ; ecx = b - 1
    mov     edi, ecx
    shr     edi, 5                                ; проверка (b - 1) >= 32 через 5-й бит
    and     edi, 1
    mov     esi, edi
    sal     edi, cl                               ; сдвиг старшей половины sign_bit
    xor     esi, 1                                ; инверсия флага для младшей половины
    mov     edx, edi
    sal     esi, cl                               ; сдвиг младшей половины sign_bit
    mov     eax, esi
    shld    edx, esi, 1                           ; 64-битный сдвиг влево на 1 (Shift Left Double)
    add     eax, esi
    add     eax, -1                               ; формирование маски low_mask
    adc     edx, -1
    and     eax, DWORD PTR [esp+12]               ; val = x & low_mask (младшие 32 бита)
    and     edx, DWORD PTR [esp+16]               ; val = x & low_mask (старшие 32 бита)
```
*Анализ:* Даже при генерации кода под 32-битную платформу `i686`, где 64-битные числа хранятся в паре регистров `edx:eax`, компилятор смог выполнить переменный 64-битный сдвиг `1ull << (b - 1)` в `_sign_extend` **без единого условного перехода**, вычислив индекс целевого 32-битного регистра через `(b - 1) >> 5` (`shr edi, 5`) и `xor esi, 1`.

---

## Часть C. Ассемблер x86-64 и RISC-V

### C1. Команды и биты

Исходный код пяти функций:
```c
unsigned f_and(unsigned x) { return x & 0xff; }
unsigned f_or (unsigned x) { return x | 1; }
unsigned f_shl(unsigned x) { return x << 3; }
int      f_sar(int x)      { return x >> 3; }
unsigned f_xor(unsigned x) { return x ^ (x >> 16); }
```

**Ассемблер с Godbolt (`x86-64 gcc 14.2 -O2` и `RISC-V (64-bits) gcc 14.2.0 -O2`):**

```asm
; ==== x86-64 gcc 14.2 (-O2) ====          ; ==== RISC-V (64-bits) gcc 14.2.0 (-O2) ====
f_and:                                     f_and:
    movzx   eax, dil                           andi    a0, a0, 0xff
    ret                                        ret
f_or:                                      f_or:
    mov     eax, edi                           ori     a0, a0, 1
    or      eax, 1                             ret
    ret                                    f_shl:
f_shl:                                         slliw   a0, a0, 3
    lea     eax, [0+rdi*8]                     ret
    ret                                    f_sar:
f_sar:                                         srai    a0, a0, 3
    mov     eax, edi                           ret
    sar     eax, 3                         f_xor:
    ret                                        srliw   a5, a0, 16
f_xor:                                         xor     a0, a5, a0
    mov     eax, edi                           ret
    shr     eax, 16
    xor     eax, edi
    ret
```

**Таблица соответствия инструкций:**

| Функция | Выражение в C | Команда в x86-64 | Команда в RISC-V (64-bits) | Расшифровка и пояснение |
|---|---|---|---|---|
| `f_and` | `x & 0xff` | `movzx eax, dil` (заменяет `and eax, 0xff`) | `andi a0, a0, 0xff` | **AND I**mmediate — побитовое И с 8-битной маской |
| `f_or` | `x \| 1` | `or eax, 1` | `ori a0, a0, 1` | **OR I**mmediate — побитовое ИЛИ с константой 1 |
| `f_shl` | `x << 3` | `lea eax, [0+rdi*8]` (заменяет `shl eax, 3`) | `slliw a0, a0, 3` | **S**hift **L**eft **L**ogical **I**mmediate **W**ord — сдвиг 32-битного слова влево |
| `f_sar` | `x >> 3` (`int`) | `sar eax, 3` | `srai a0, a0, 3` | **S**hift **R**ight **A**rithmetic **I**mmediate — арифметический сдвиг вправо |
| `f_xor` | `x ^ (x >> 16)` | `shr eax, 16` + `xor eax, edi` | `srliw a5, a0, 16` + `xor a0, a5, a0` | **S**hift **R**ight **L**ogical **I**mmediate **W**ord + e**X**clusive **OR** |

**Чем `sar` (`srai`) отличается от `shr` (`srliw`):**
* **`shr` / `srliw` (логический сдвиг вправо):** Применяется к беззнаковым числам (`unsigned`). Освобождающиеся старшие разряды слева **всегда заполняются нулями (`0`)**. Например, для 8-битного числа `11110000` (`240u`) сдвиг `>> 3` дает `00011110` (`30u`).
* **`sar` / `srai` (арифметический сдвиг вправо):** Применяется к знаковым числам (`int`). Освобождающиеся старшие разряды слева **заполняются копиями знакового (старшего) бита**: если число положительное (знаковый бит `0`), вдвигаются нули; если отрицательное (знаковый бит `1`), вдвигаются единицы (`1`). Например, для `11110000` (`-16` в дополнительном коде) арифметический сдвиг `>> 3` дает `11111110` (`-2`), сохраняя знак числа.

---

### C2. Деление и обмен переменных

Исходный код для исследования на Godbolt:
```c
/* 1. Деление на 7, остаток от 7 и деление на переменную */
int d7(int x)           { return x / 7; }
int m7(int x)           { return x % 7; }
int d_var(int x, int y) { return x / y; }

/* 2А. Обмен двух переменных в регистрах */
long long swap2_reg_tmp(int a, int b) {
    int t = a; a = b; b = t;
    return ((long long)a << 32) | (unsigned)b;
}
long long swap2_reg_xor(int a, int b) {
    a ^= b; b ^= a; a ^= b;
    return ((long long)a << 32) | (unsigned)b;
}
long long swap2_reg_arith(unsigned a, unsigned b) {
    a = a + b; b = a - b; a = a - b;
    return ((long long)a << 32) | b;
}

/* 2Б. Обмен двух переменных по указателям */
void swap2_ptr_tmp(int *a, int *b) {
    int t = *a; *a = *b; *b = t;
}
void swap2_ptr_xor(int *a, int *b) {
    *a ^= *b; *b ^= *a; *a ^= *b;
}
void swap2_ptr_arith(unsigned *a, unsigned *b) {
    *a = *a + *b; *b = *a - *b; *a = *a - *b;
}

/* 2В. Циклический обмен трех переменных по указателям */
void swap3_tmp(int *a, int *b, int *c) {
    int t = *a; *a = *b; *b = *c; *c = t;
}
void swap3_xor(int *a, int *b, int *c) {
    *a ^= *b; *b ^= *a; *a ^= *b;
    *b ^= *c; *c ^= *b; *b ^= *c;
}
void swap3_arith(unsigned *a, unsigned *b, unsigned *c) {
    *a = *a + *b; *b = *a - *b; *a = *a - *b;
    *b = *b + *c; *c = *b - *c; *b = *b - *c;
}
```

**Полный сгенерированный ассемблер (`x86-64 gcc 14.2 -O2` и `RISC-V (64-bits) gcc 14.2 -O2`):**

```asm
; ======================== x86-64 gcc 14.2 (-O2) ========================
d7:
        movsx   rax, edi
        imul    rax, rax, -1840700269
        shr     rax, 32
        add     eax, edi
        sar     edi, 31
        sar     eax, 2
        sub     eax, edi
        ret
m7:
        movsx   rax, edi
        mov     edx, edi
        imul    rax, rax, -1840700269
        sar     edx, 31
        shr     rax, 32
        add     eax, edi
        sar     eax, 2
        sub     eax, edx
        lea     edx, [0+rax*8]
        sub     edx, eax
        mov     eax, edi
        sub     eax, edx
        ret
d_var:
        mov     eax, edi
        cdq
        idiv    esi
        ret
swap2_reg_tmp:
        mov     rax, rsi
        mov     edi, edi
        sal     rax, 32
        or      rax, rdi
        ret
swap2_reg_xor:
        mov     rax, rsi
        mov     edi, edi
        sal     rax, 32
        or      rax, rdi
        ret
swap2_reg_arith:
        mov     rax, rsi
        mov     edi, edi
        sal     rax, 32
        or      rax, rdi
        ret
swap2_ptr_tmp:
        mov     eax, DWORD PTR [rdi]
        mov     edx, DWORD PTR [rsi]
        mov     DWORD PTR [rdi], edx
        mov     DWORD PTR [rsi], eax
        ret
swap2_ptr_xor:
        mov     eax, DWORD PTR [rdi]
        xor     eax, DWORD PTR [rsi]
        mov     DWORD PTR [rdi], eax
        xor     eax, DWORD PTR [rsi]
        mov     DWORD PTR [rsi], eax
        xor     DWORD PTR [rdi], eax
        ret
swap2_ptr_arith:
        mov     eax, DWORD PTR [rsi]
        add     eax, DWORD PTR [rdi]
        mov     DWORD PTR [rdi], eax
        mov     edx, DWORD PTR [rsi]
        mov     ecx, eax
        sub     ecx, edx
        sub     edx, eax
        mov     DWORD PTR [rsi], ecx
        add     DWORD PTR [rdi], edx
        ret
swap3_tmp:
        mov     ecx, DWORD PTR [rsi]
        mov     eax, DWORD PTR [rdi]
        mov     DWORD PTR [rdi], ecx
        mov     ecx, DWORD PTR [rdx]
        mov     DWORD PTR [rsi], ecx
        mov     DWORD PTR [rdx], eax
        ret
swap3_xor:
        mov     eax, DWORD PTR [rdi]
        xor     eax, DWORD PTR [rsi]
        mov     DWORD PTR [rdi], eax
        xor     eax, DWORD PTR [rsi]
        mov     DWORD PTR [rsi], eax
        xor     DWORD PTR [rdi], eax
        mov     eax, DWORD PTR [rsi]
        xor     eax, DWORD PTR [rdx]
        mov     DWORD PTR [rsi], eax
        xor     eax, DWORD PTR [rdx]
        mov     DWORD PTR [rdx], eax
        xor     DWORD PTR [rsi], eax
        ret
swap3_arith:
        mov     eax, DWORD PTR [rsi]
        add     eax, DWORD PTR [rdi]
        mov     DWORD PTR [rdi], eax
        mov     ecx, DWORD PTR [rsi]
        mov     r8d, eax
        sub     r8d, ecx
        sub     ecx, eax
        mov     DWORD PTR [rsi], r8d
        add     DWORD PTR [rdi], ecx
        mov     eax, DWORD PTR [rdx]
        add     eax, DWORD PTR [rsi]
        mov     DWORD PTR [rsi], eax
        mov     ecx, DWORD PTR [rdx]
        mov     edi, eax
        sub     edi, ecx
        sub     ecx, eax
        mov     DWORD PTR [rdx], edi
        add     DWORD PTR [rsi], ecx
        ret
```

```asm
; =================== RISC-V (64-bits) gcc 14.2 (-O2) ===================
d7:
        li      a5,-1840701440
        addi    a5,a5,1171
        mul     a5,a0,a5
        sraiw   a4,a0,31
        srli    a5,a5,32
        addw    a0,a0,a5
        sraiw   a0,a0,2
        subw    a0,a0,a4
        ret
m7:
        li      a5,-1840701440
        addi    a5,a5,1171
        mul     a5,a0,a5
        sraiw   a4,a0,31
        srli    a5,a5,32
        addw    a5,a0,a5
        sraiw   a5,a5,2
        subw    a5,a5,a4
        slliw   a4,a5,3
        subw    a5,a4,a5
        subw    a0,a0,a5
        ret
d_var:
        divw    a0,a0,a1
        ret
swap2_reg_tmp:
        slli    a0,a0,32
        slli    a1,a1,32
        srli    a0,a0,32
        or      a0,a1,a0
        ret
swap2_reg_xor:
        slli    a0,a0,32
        slli    a1,a1,32
        srli    a0,a0,32
        or      a0,a1,a0
        ret
swap2_reg_arith:
        slli    a0,a0,32
        slli    a1,a1,32
        srli    a0,a0,32
        or      a0,a1,a0
        ret
swap2_ptr_tmp:
        lw      a4,0(a1)
        lw      a5,0(a0)
        sw      a4,0(a0)
        sw      a5,0(a1)
        ret
swap2_ptr_xor:
        lw      a4,0(a1)
        lw      a5,0(a0)
        xor     a5,a5,a4
        sw      a5,0(a0)
        lw      a4,0(a1)
        xor     a5,a5,a4
        sw      a5,0(a1)
        lw      a4,0(a0)
        xor     a5,a5,a4
        sw      a5,0(a0)
        ret
swap2_ptr_arith:
        lw      a5,0(a0)
        lw      a4,0(a1)
        addw    a4,a4,a5
        sw      a4,0(a0)
        lw      a3,0(a1)
        subw    a5,a4,a3
        sw      a5,0(a1)
        lw      a5,0(a0)
        addw    a5,a5,a3
        subw    a5,a5,a4
        sw      a5,0(a0)
        ret
swap3_tmp:
        lw      a4,0(a1)
        lw      a5,0(a0)
        sw      a4,0(a0)
        lw      a4,0(a2)
        sw      a4,0(a1)
        sw      a5,0(a2)
        ret
swap3_xor:
        lw      a4,0(a1)
        lw      a5,0(a0)
        xor     a5,a5,a4
        sw      a5,0(a0)
        lw      a4,0(a1)
        xor     a5,a5,a4
        sw      a5,0(a1)
        lw      a4,0(a0)
        xor     a5,a5,a4
        sw      a5,0(a0)
        lw      a4,0(a2)
        lw      a5,0(a1)
        xor     a5,a5,a4
        sw      a5,0(a1)
        lw      a4,0(a2)
        xor     a5,a5,a4
        sw      a5,0(a2)
        lw      a4,0(a1)
        xor     a5,a5,a4
        sw      a5,0(a1)
        ret
swap3_arith:
        lw      a5,0(a0)
        lw      a4,0(a1)
        addw    a4,a4,a5
        sw      a4,0(a0)
        lw      a3,0(a1)
        subw    a5,a4,a3
        sw      a5,0(a1)
        lw      a5,0(a0)
        addw    a5,a5,a3
        subw    a5,a5,a4
        sw      a5,0(a0)
        lw      a5,0(a1)
        lw      a4,0(a2)
        addw    a4,a4,a5
        sw      a4,0(a1)
        lw      a3,0(a2)
        subw    a5,a4,a3
        sw      a5,0(a2)
        lw      a5,0(a1)
        addw    a5,a5,a3
        subw    a5,a5,a4
        sw      a5,0(a1)
        ret
```

**Выводы по пункту C2:**
1. **Деление на константу `7` (`d7`, `m7`) против деления на переменную (`d_var`):**
   * В `d7` компилятор заменяет медленную инструкцию деления на умножение на магическую константу `-1840700269` (`0x92492493`, что в беззнаковом виде равно $2454267027 = \lceil 2^{34} / 7 \rceil$) со сдвигом на 34 бита (`shr 32` + `sar 2`) и коррекцией знака для отрицательных делимых. На RISC-V 32-битная константа собирается в регистре двумя инструкциями (`li a5, -1840701440` + `addi a5, a5, 1171`), так как длина любой инструкции RISC-V фиксирована и равна 32 битам.
   * В `m7` (`x % 7`) сначала тем же магическим умножением вычисляется частное $q = x / 7$, затем вычисляется $7q = 8q - q$ (`lea edx, [0+rax*8]` + `sub edx, eax` на x86-64; `slliw a4, a5, 3` + `subw a5, a4, a5` на RISC-V) и вычитается из исходного $x$.
   * В `d_var` (`x / y`) делитель неизвестен во время компиляции, поэтому появляется аппаратная инструкция деления: `cdq` + `idiv esi` на x86-64 и `divw a0, a0, a1` на RISC-V.
2. **Обмен переменных (`tmp` против `XOR` и `arith`):**
   * **В регистрах (`swap2_reg_*`)**: Оптимизатор распознает математические тождества во всех трех версиях, полностью удаляет операции `XOR` и `+/-` и генерирует идентичный код из 5 инструкций.
   * **По указателям (`swap2_ptr_*` и `swap3_*`)**: Версия через временную переменную (`swap2_ptr_tmp` — 5 инструкций, `swap3_tmp` — 7 инструкций) оказывается значительно короче и быстрее, чем `XOR` (7 и 13 инструкций на x86-64; 11 и 21 на RISC-V) и арифметика (10 и 19 инструкций на x86-64; 12 и 23 на RISC-V). Причина — **перекрытие указателей (pointer aliasing)**: если передать в функцию два одинаковых адреса (`a == b`), то версия с `tmp` сохранит значение переменной, а версии с `XOR` и `+/-` обнулят ячейку памяти (`*a ^= *a` $\rightarrow 0$). Чтобы не нарушить поведение программы при `a == b`, компилятор вынужден честно выполнять все промежуточные операции и обращения к памяти.

---

### C3. Таблица функций (GCC 14.2, `-O2`, число инструкций вместе с `ret`)

| Функция | x86-64 | x86-64-v3 | rv64gc | rv64gc_zbb | Какие инструкции появились |
|---|---|---|---|---|---|
| **`bswap32`** | 3 | 3 | 12 | 3 | `bswap` (базовая в x86-64), `rev8` (в `rv64gc_zbb`) |
| **`is_pow2`** | 8 | 6 | 6 | 6 | `blsr` (в `x86-64-v3`, расширение BMI1), `seqz`/`snez` (в RISC-V) |
| **`parity32`** | 11 | 11 | 11 | 11 | Базовые сдвиги `shr`/`srliw` и `xor` |
| **`popcount32`** | 12 | 3 | 15 | 2 | `popcnt` (в `x86-64-v3`), `cpopw` (в `rv64gc_zbb`) |
| **`ctz32`** | 8 | 4 | 9 | 2 | `tzcnt` (в `x86-64-v3`), `ctzw` (в `rv64gc_zbb`) |
| **`clz32`** | 22 | 22 | 21 | 21 | `cmp` + `setbe` + `sal` (x86-64), `sltiu` + `slli` + `sllw` (RISC-V) |
| **`next_pow2`** | 14 | 14 | 13 | 13 | Каскад `shr` + `or` (x86-64), `srli` + `or` (RISC-V) |
| **`sign_extend`** | 11 | 10 | 9 | 9 | `shlx` (бесфлаговый сдвиг BMI2 в `x86-64-v3`) |
| **`sat_add32`** | 10 | 10 | 11 | 10 | `andn` (побитовое И-НЕ из BMI1 в `x86-64-v3` и Zbb в `rv64gc_zbb`) |

#### Ответы на контрольные вопросы пункта C3:
1. **`popcount32` на `x86-64-v3` и `rv64gc_zbb`**: Оптимизатор GCC распознает многоступенчатый шаблон SWAR-суммирования битов и заменяет всё тело функции на одну аппаратную инструкцию: `popcnt eax, edi` (плюс `xor eax, eax` и `ret`) на `x86-64-v3` и `cpopw a0, a0` (плюс `ret`) на `rv64gc_zbb`.
2. **`bswap32` на `x86-64` и `rv64gc_zbb`**: В архитектуре x86 инструкция `bswap` является базовой еще со времен процессора i486, поэтому даже без флага `-march=x86-64-v3` компилятор сворачивает побитовые маски в `bswap eax`. В базовом наборе RISC-V (`rv64gc`) такой инструкции нет (компилятор генерирует 12 инструкций сдвигов и масок), а при подключении битового расширения Zbb (`-march=rv64gc_zbb`) появляется аппаратная инструкция разворота байтов `rev8` (в паре с `srli a0, a0, 32`).
3. **Почему `clz32`, написанный двоичным поиском, не превращается в `lzcnt` (`clzw`), и что было бы с `__builtin_clz`**: Пятиступенчатый каскад из сравнений с порогами и сдвигов на переменную величину (`x <<= s`) не входит в список распознаваемых идиом оптимизатора GCC. Если бы использовалась встроенная функция `__builtin_clz(x)`, компилятор сразу подставил бы аппаратную инструкцию `lzcnt` на `x86-64-v3` (или `bsr` + `xor 31` на базовом `x86-64`) и `clzw` на `rv64gc_zbb`.
4. **Почему `ctz32` через таблицу де Брёйна превращается в `tzcnt`/`ctzw`, а у Clang может появиться `test` и переход для `x == 0`**: В современных GCC и Clang есть специальный распознаватель умножения на константу де Брёйна с чтением из 32-элементной таблицы. Однако при `x == 0` формула `(0 & 0) * 0x077CB531 >> 27` дает индекс `0`, и таблица возвращает `debruijn32[0] = 0`, тогда как аппаратные инструкции `tzcnt` и `ctzw` при `x == 0` возвращают `32` (разрядность слова), а базовая инструкция `bsf` на x86 имеет неопределенный результат для нуля. Чтобы сохранить точное поведение исходного C-кода для входа `x == 0` (возврат `0`), GCC корректирует результат условной пересылкой/маской, а Clang вставляет явную проверку `test edi, edi` и условный переход `je` вокруг инструкции подсчета нулей.
5. **Почему на RISC-V безветвевый исходник иногда компилируется в ветку**: В базовом профиле `rv64gc` отсутствует инструкция условной пересылки `cmov`. Когда компилятор видит выбор между двумя значениями (например, выбор константы насыщения в `sat_add32_branchy` или тернарный оператор `?:`), на x86-64 он генерирует `cmov`, а на базовом RISC-V вынужден генерировать короткий условный переход (`beq`/`bne`/`blt`/`bge`), если считает его более коротким, чем синтез условной маски из нескольких побитовых инструкций.
