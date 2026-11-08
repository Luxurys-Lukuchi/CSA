#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAXN 768
#define RUNS 5

static int n;
static double a[MAXN][MAXN], b[MAXN][MAXN], c[MAXN][MAXN];

static double now(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec * 1e-9;
}

static void init(void) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            a[i][j] = (double)rand() / RAND_MAX;
            b[i][j] = (double)rand() / RAND_MAX;
        }
}

static void mul_ijk(void) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            for (int k = 0; k < n; k++)
                c[i][j] += a[i][k] * b[k][j];
}

static void mul_ikj(void) {
    for (int i = 0; i < n; i++)
        for (int k = 0; k < n; k++)
            for (int j = 0; j < n; j++)
                c[i][j] += a[i][k] * b[k][j];
}

static void mul_jik(void) {
    for (int j = 0; j < n; j++)
        for (int i = 0; i < n; i++)
            for (int k = 0; k < n; k++)
                c[i][j] += a[i][k] * b[k][j];
}

static void mul_jki(void) {
    for (int j = 0; j < n; j++)
        for (int k = 0; k < n; k++)
            for (int i = 0; i < n; i++)
                c[i][j] += a[i][k] * b[k][j];
}

static void mul_kij(void) {
    for (int k = 0; k < n; k++)
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                c[i][j] += a[i][k] * b[k][j];
}

static void mul_kji(void) {
    for (int k = 0; k < n; k++)
        for (int j = 0; j < n; j++)
            for (int i = 0; i < n; i++)
                c[i][j] += a[i][k] * b[k][j];
}

typedef void (*mul_fn)(void);

int main(void) {
    const int sizes[] = {128, 256, 384, 512};
    const int nsizes = (int)(sizeof sizes / sizeof sizes[0]);
    struct { const char *name; mul_fn fn; } methods[] = {
        {"ijk", mul_ijk}, {"ikj", mul_ikj}, {"jik", mul_jik},
        {"jki", mul_jki}, {"kij", mul_kij}, {"kji", mul_kji},
    };

    printf("n,method,run,seconds,gflops,control\n");
    for (int s = 0; s < nsizes; s++) {
        n = sizes[s];
        init();
        for (int m = 0; m < 6; m++) {
            for (int r = 1; r <= RUNS; r++) {
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < n; j++)
                        c[i][j] = 0.0;

                double t0 = now();
                methods[m].fn();
                double t = now() - t0;

                printf("%d,%s,%d,%.6f,%.3f,%.9f\n",
                       n, methods[m].name, r, t,
                       2.0 * n * n * n / t / 1e9, c[7][7]);
            }
        }
    }
    return 0;
}

/*
ВЫВОДЫ ПО ЧАСТИ 3:
1. Проверка control:
 Во всех 6 методах c[7][7] = 128.735066262 (совпадает бит в бит, ошибок в циклах нет).
 2. Почему 6 порядков циклов делятся на 3 группы по скорости (в C массивы хранятся построчно):
 - Быстрые (ikj, kij): внутренний цикл по j. Матрицы b[k][j] и c[i][j] читаются и пишутся
   подряд по строкам (шаг 8 байт). Кэш работает без промахов (~2.5 GFLOPS на -O2).
 - Средние (ijk, jik): внутренний цикл по k. Матрица a[i][k] идет подряд по строке,
   но b[k][j] прыгает по столбцу через всю строку. Много промахов кэша (~1.0 GFLOPS на -O2).
 - Медленные (jki, kji): внутренний цикл по i. И a[i][k], и c[i][j] прыгают по столбцам.
   Постоянные промахи кэша, работают в 10 раз медленнее быстрых (~0.25 GFLOPS на -O2).
 3. Сравнение флагов компиляции (на примере n = 512, порядок ikj):
 - -O0: 0.75 GFLOPS (без оптимизаций, все обращения идут через память).
 - -O2: 2.28 GFLOPS (базовые оптимизации регистров и циклов + SSE2).
 - -O3 -march=native: 17.17 GFLOPS (включилась векторизация AVX2 + FMA, по 4 double за такт).

 4. Наклон графика (log-log):
 Сложность алгоритма O(n^3), поэтому на логарифмическом графике линии идут с наклоном ~3.
 При больших n (384, 512) наклон становится чуть круче (>3), так как 3 матрицы (6 МБ при n=512)
 перестают помещаться в кэш L2 ядра (512 КБ) и вываливаются в более медленный L3 и RAM.
 
5. Сравнение внутренних циклов ijk и ikj в Godbolt (x86-64 gcc -O2 -masm=intel):
 - В ijk (внутренний цикл по k, метка .L4):
   Обращения к матрице b[k][j] идут С ШАГОМ В СТРОКУ. В ассемблере указатель на b (регистр rax)
   каждую итерацию прыгает на 6144 байта (add rax, 6144, так как 768 элементов * 8 байт = 6144),
   а указатель на a[i][k] (rdx) идет подряд (add rdx, 8).
 - В ikj (внутренний цикл по j):
   Обращения к матрице b[k][j] (и c[i][j]) идут ПОДРЯД по одной строке. Элемент a[i][k] один раз
   загружается в регистр до цикла, а внутри цикла адрес сдвигается на соседние элементы
   (+8 байт для 1 double или +16 байт для пары в xmm), прыжков на 6144 байта нет.
*/