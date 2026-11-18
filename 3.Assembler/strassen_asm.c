#include <stdlib.h>
#include <string.h>

#define MAXN 1024
#define THRESHOLD 64

int n;
double a[MAXN][MAXN], b[MAXN][MAXN], c[MAXN][MAXN];

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

static void base_mul(int sz, const double *A, int sa, const double *B, int sb, double *C, int sc) {
    for (int i = 0; i < sz; i++)
        for (int j = 0; j < sz; j++)
            C[i * sc + j] = 0.0;

    for (int i = 0; i < sz; i++)
        for (int k = 0; k < sz; k++) {
            double aik = A[i * sa + k];
            for (int j = 0; j < sz; j++)
                C[i * sc + j] += aik * B[k * sb + j];
        }
}

void strassen_rec(int sz, const double *A, int sa, const double *B, int sb, double *C, int sc, double *work) {
    if (sz <= THRESHOLD) {
        base_mul(sz, A, sa, B, sb, C, sc);
        return;
    }

    int m = sz / 2;
    int m2 = m * m;

    const double *A11 = A, *A12 = A + m, *A21 = A + m * sa, *A22 = A + m * sa + m;
    const double *B11 = B, *B12 = B + m, *B21 = B + m * sb, *B22 = B + m * sb + m;
    double *C11 = C, *C12 = C + m, *C21 = C + m * sc, *C22 = C + m * sc + m;

    double *M1 = work, *M2 = M1 + m2, *M3 = M2 + m2, *M4 = M3 + m2;
    double *M5 = M4 + m2, *M6 = M5 + m2, *M7 = M6 + m2;
    double *T1 = M7 + m2, *T2 = T1 + m2, *next_work = T2 + m2;

    add_mat(m, A11, sa, A22, sa, T1, m);
    add_mat(m, B11, sb, B22, sb, T2, m);
    strassen_rec(m, T1, m, T2, m, M1, m, next_work);

    add_mat(m, A21, sa, A22, sa, T1, m);
    strassen_rec(m, T1, m, B11, sb, M2, m, next_work);

    sub_mat(m, B12, sb, B22, sb, T2, m);
    strassen_rec(m, A11, sa, T2, m, M3, m, next_work);

    sub_mat(m, B21, sb, B11, sb, T2, m);
    strassen_rec(m, A22, sa, T2, m, M4, m, next_work);

    add_mat(m, A11, sa, A12, sa, T1, m);
    strassen_rec(m, T1, m, B22, sb, M5, m, next_work);

    sub_mat(m, A21, sa, A11, sa, T1, m);
    add_mat(m, B11, sb, B12, sb, T2, m);
    strassen_rec(m, T1, m, T2, m, M6, m, next_work);

    sub_mat(m, A12, sa, A22, sa, T1, m);
    add_mat(m, B21, sb, B22, sb, T2, m);
    strassen_rec(m, T1, m, T2, m, M7, m, next_work);

    for (int i = 0; i < m; i++)
        for (int j = 0; j < m; j++) {
            int idx = i * m + j;
            C11[i * sc + j] = M1[idx] + M4[idx] - M5[idx] + M7[idx];
            C12[i * sc + j] = M3[idx] + M5[idx];
            C21[i * sc + j] = M2[idx] + M4[idx];
            C22[i * sc + j] = M1[idx] - M2[idx] + M3[idx] + M6[idx];
        }
}

void strassen(void) {
    int p = 1;
    while (p < n) p <<= 1;

    double *work = (double *)malloc(3 * (size_t)p * (size_t)p * sizeof(double));

    if (p == n) {
        strassen_rec(n, &a[0][0], MAXN, &b[0][0], MAXN, &c[0][0], MAXN, work);
    } else {
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