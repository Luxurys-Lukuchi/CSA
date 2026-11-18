#define MAXN 768

int n;
double a[MAXN][MAXN], b[MAXN][MAXN], c[MAXN][MAXN];

void mul_ijk(void) {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            double s = 0.0;
            for (int k = 0; k < n; k++)
                s += a[i][k] * b[k][j];
            c[i][j] = s;
        }
}

void mul_ikj(void) {
    for (int i = 0; i < n; i++)
        for (int k = 0; k < n; k++) {
            double aik = a[i][k];
            for (int j = 0; j < n; j++)
                c[i][j] += aik * b[k][j];
        }
}