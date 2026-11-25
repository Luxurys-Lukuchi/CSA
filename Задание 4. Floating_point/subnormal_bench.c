#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#if defined(__x86_64__) || defined(__i386__)
#include <xmmintrin.h>
#endif

#define RUNS  5
#define ITERS 2000000

/* noipa не даёт GCC считать функцию "чистой" и кэшировать результат между вызовами */
#if defined(__GNUC__) && !defined(__clang__)
__attribute__((noinline, noipa))
#else
__attribute__((noinline))
#endif
static float mul_loop(float x, int iters) {
    for (int i = 0; i < iters; i++) {
        x *= 0.5f;
        x *= 2.0f;
    }
    return x;
}

static int cmp_double(const void *a, const void *b) {
    double da = *(const double *)a;
    double db = *(const double *)b;
    return (da > db) - (da < db);
}

static double now_sec(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec + (double)ts.tv_nsec * 1e-9;
}

static void bench(const char *label, volatile float start_val) {
    double times[RUNS];
    volatile float sink = 0.0f;

    for (int r = 0; r < RUNS; r++) {
        float x = start_val;
        double t0 = now_sec();
        sink = mul_loop(x, ITERS);
        double t1 = now_sec();
        times[r] = (t1 - t0) * 1000.0; /* мс */
        printf("%s run %d: %.3f ms (res = %g)\n", label, r + 1, times[r], (double)sink);
    }

    qsort(times, RUNS, sizeof(double), cmp_double);
    printf("==> %s MEDIAN: %.3f ms\n\n", label, times[RUNS / 2]);
}

int main(void) {
    bench("Normal (1.0)            ", 1.0f);
    bench("Subnormal (2e-38)       ", 2e-38f);

#if defined(__x86_64__) || defined(__i386__)
    /* Включаем FTZ (бит 15 = 0x8000) и DAZ (бит 6 = 0x0040) в регистре MXCSR */
    _mm_setcsr(_mm_getcsr() | 0x8040u);
    bench("Subnormal + FTZ/DAZ     ", 2e-38f);
#endif

    return 0;
}
