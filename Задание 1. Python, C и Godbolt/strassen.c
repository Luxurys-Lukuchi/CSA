/*
 * ВЫВОДЫ ПО ЧАСТИ 5 (Алгоритм Штрассена):
 *
 * 1. Суть алгоритма и реализация:
 *    Матрицы делятся на 4 блока (m = n/2). Вместо 8 умножений блоков выполняются
 *    7 рекурсивных умножений M1..M7 и 18 матричных сложений/вычитаний.
 *    Асимптотическая сложность снижается с O(n^3) до O(n^log2(7)) ≈ O(n^2.807).
 *    Если размер n не является степенью двойки, матрица дополняется нулями до ближайшей 2^k.
 *    При размере блока sz <= 64 (THRESHOLD) вызывается базовое умножение в быстром порядке ikj.
 *
 * 2. Сравнение времени и наклона графика:
 *    - В функции naive используется порядок ijk (шаг по столбцу в матрице b), а в базовом
 *      случае Штрассена блоки 64x64 помещаются в кэш L1/L2 и умножаются по строкам (ikj).
 *    - При каждом удвоении размера n (256 -> 512 -> 1024) время naive растет в ~8 раз (2^3 = 8),
 *      а время strassen — примерно в ~7 раз (2^2.807 = 7), поэтому с ростом n отрыв увеличивается.
 *
 * 3. Почему maxdiff не равен 0, но очень мал (~1e-14 .. 1e-12):
 *    - У naive maxdiff = 0.000e+00, так как он сравнивается сам с собой (ref).
 *    - В алгоритме Штрассена используется другой порядок сложений и вычитаний промежуточных
 *      матриц (например, C11 = M1 + M4 - M5 + M7). Так как арифметика с плавающей точкой (double)
 *      неассоциативна: (a + b) + c != a + (b + c) из-за округления младших битов мантиссы (точность
 *      double ~ 1e-16), возникает микроскопическая погрешность ~7.8e-14 (при n=128) .. ~6.4e-12 (при n=1024).
 *      Малый порядок погрешности (1e-12) доказывает, что все 7 формул Штрассена написаны без ошибок.
 */

#define _POSIX_C_SOURCE 200809L
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAXN 1024
#define RUNS 5
#define THRESHOLD 64

static int n;
static double a[MAXN][MAXN], b[MAXN][MAXN];
static double c[MAXN][MAXN], ref[MAXN][MAXN];

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

/* Эталон: обычное умножение, нужно для проверки и как базовый случай. */
static void naive(double out[MAXN][MAXN]) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            double s = 0;
            for (int k = 0; k < n; k++)
                s += a[i][k] * b[k][j];
            out[i][j] = s;
        }
}

/* Сложение и вычитание подматриц с произвольным шагом строки (stride) */
static void add_mat(int sz, const double *X, int sx, const double *Y, int sy, double *Z, int sz_stride) {
    for (int i = 0; i < sz; i++)
        for (int j = 0; j < sz; j++)
            Z[i * sz_stride + j] = X[i * sx + j] + Y[i * sy + j];
}

static void sub_mat(int sz, const double *X, int sx, const double *Y, int sy, double *Z, int sz_stride) {
    for (int i = 0; i < sz; i++)
        for (int j = 0; j < sz; j++)
            Z[i * sz_stride + j] = X[i * sx + j] - Y[i * sy + j];
}

/* Базовое умножение подматриц при sz <= THRESHOLD (порядок ikj для работы с кэшем) */
static void base_mul(int sz, const double *A, int sa, const double *B, int sb, double *C, int sc) {
    for (int i = 0; i < sz; i++)
        for (int j = 0; j < sz; j++)
            C[i * sc + j] = 0.0;

    for (int i = 0; i < sz; i++) {
        for (int k = 0; k < sz; k++) {
            double aik = A[i * sa + k];
            for (int j = 0; j < sz; j++) {
                C[i * sc + j] += aik * B[k * sb + j];
            }
        }
    }
}

/* Рекурсивный шаг Штрассена */
static void strassen_rec(int sz, const double *A, int sa, const double *B, int sb, double *C, int sc, double *work) {
    if (sz <= THRESHOLD) {
        base_mul(sz, A, sa, B, sb, C, sc);
        return;
    }

    int m = sz / 2;
    int m2 = m * m;

    const double *A11 = A;
    const double *A12 = A + m;
    const double *A21 = A + m * sa;
    const double *A22 = A + m * sa + m;

    const double *B11 = B;
    const double *B12 = B + m;
    const double *B21 = B + m * sb;
    const double *B22 = B + m * sb + m;

    double *C11 = C;
    double *C12 = C + m;
    double *C21 = C + m * sc;
    double *C22 = C + m * sc + m;

    /* Размечаем память под M1..M7 и временные буферы T1, T2 в едином массиве work */
    double *M1 = work;
    double *M2 = M1 + m2;
    double *M3 = M2 + m2;
    double *M4 = M3 + m2;
    double *M5 = M4 + m2;
    double *M6 = M5 + m2;
    double *M7 = M6 + m2;
    double *T1 = M7 + m2;
    double *T2 = T1 + m2;
    double *next_work = T2 + m2;

    /* M1 = (A11 + A22) * (B11 + B22) */
    add_mat(m, A11, sa, A22, sa, T1, m);
    add_mat(m, B11, sb, B22, sb, T2, m);
    strassen_rec(m, T1, m, T2, m, M1, m, next_work);

    /* M2 = (A21 + A22) * B11 */
    add_mat(m, A21, sa, A22, sa, T1, m);
    strassen_rec(m, T1, m, B11, sb, M2, m, next_work);

    /* M3 = A11 * (B12 - B22) */
    sub_mat(m, B12, sb, B22, sb, T2, m);
    strassen_rec(m, A11, sa, T2, m, M3, m, next_work);

    /* M4 = A22 * (B21 - B11) */
    sub_mat(m, B21, sb, B11, sb, T2, m);
    strassen_rec(m, A22, sa, T2, m, M4, m, next_work);

    /* M5 = (A11 + A12) * B22 */
    add_mat(m, A11, sa, A12, sa, T1, m);
    strassen_rec(m, T1, m, B22, sb, M5, m, next_work);

    /* M6 = (A21 - A11) * (B11 + B12) */
    sub_mat(m, A21, sa, A11, sa, T1, m);
    add_mat(m, B11, sb, B12, sb, T2, m);
    strassen_rec(m, T1, m, T2, m, M6, m, next_work);

    /* M7 = (A12 - A22) * (B21 + B22) */
    sub_mat(m, A12, sa, A22, sa, T1, m);
    add_mat(m, B21, sb, B22, sb, T2, m);
    strassen_rec(m, T1, m, T2, m, M7, m, next_work);

    /* Сборка блоков результата C11, C12, C21, C22 */
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < m; j++) {
            int idx = i * m + j;
            C11[i * sc + j] = M1[idx] + M4[idx] - M5[idx] + M7[idx];
            C12[i * sc + j] = M3[idx] + M5[idx];
            C21[i * sc + j] = M2[idx] + M4[idx];
            C22[i * sc + j] = M1[idx] - M2[idx] + M3[idx] + M6[idx];
        }
    }
}

static void strassen(void) {
    /* Находим ближайшую степень двойки p >= n (на случай n не степени 2) */
    int p = 1;
    while (p < n) p <<= 1;

    /* Выделяем единый буфер памяти на все уровни рекурсии */
    double *work = (double *)malloc(3 * (size_t)p * (size_t)p * sizeof(double));

    if (p == n) {
        strassen_rec(n, &a[0][0], MAXN, &b[0][0], MAXN, &c[0][0], MAXN, work);
    } else {
        /* Дополнение нулями, если размер матрицы не степень двойки */
        double *ap = (double *)calloc((size_t)p * p, sizeof(double));
        double *bp = (double *)calloc((size_t)p * p, sizeof(double));
        double *cp = (double *)calloc((size_t)p * p, sizeof(double));

        for (int i = 0; i < n; i++) {
            memcpy(&ap[i * p], &a[i][0], n * sizeof(double));
            memcpy(&bp[i * p], &b[i][0], n * sizeof(double));
        }

        strassen_rec(p, ap, p, bp, p, cp, p, work);

        for (int i = 0; i < n; i++)
            memcpy(&c[i][0], &cp[i * p], n * sizeof(double));

        free(ap);
        free(bp);
        free(cp);
    }

    free(work);
}

static double maxdiff(void) {
    double d = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            double x = fabs(c[i][j] - ref[i][j]);
            if (x > d) d = x;
        }
    return d;
}

int main(void) {
    const int sizes[] = {128, 256, 512, 1024};
    const int nsizes = (int)(sizeof sizes / sizeof sizes[0]);

    printf("n,method,run,seconds,gflops,maxdiff\n");

    for (int s = 0; s < nsizes; s++) {
        n = sizes[s];
        init();
        naive(ref);

        for (int m = 0; m < 2; m++) {
            const char *name = m ? "strassen" : "naive";
            for (int r = 1; r <= RUNS; r++) {
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < n; j++)
                        c[i][j] = 0.0;

                double t0 = now();
                if (m) strassen();
                else   naive(c);
                double t = now() - t0;

                printf("%d,%s,%d,%.6f,%.3f,%.3e\n",
                       n, name, r, t, 2.0 * n * n * n / t / 1e9, maxdiff());
            }
        }
    }
    return 0;
}