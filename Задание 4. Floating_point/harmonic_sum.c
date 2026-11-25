#include <math.h>
#include <stdio.h>

static float sum_forward(int n) {
    float s = 0.0f;
    for (int i = 1; i <= n; i++) {
        s += 1.0f / (float)i;
    }
    return s;
}

static float sum_backward(int n) {
    float s = 0.0f;
    for (int i = n; i >= 1; i--) {
        s += 1.0f / (float)i;
    }
    return s;
}

static float sum_pairwise(int l, int r) {
    if (l == r) {
        return 1.0f / (float)l;
    }
    int m = l + (r - l) / 2;
    return sum_pairwise(l, m) + sum_pairwise(m + 1, r);
}

static float sum_kahan(int n) {
    float s = 0.0f;
    float c = 0.0f;
    for (int i = 1; i <= n; i++) {
        float y = (1.0f / (float)i) - c;
        float t = s + y;
        c = (t - s) - y;
        s = t;
    }
    return s;
}

static long double sum_reference(int n) {
    long double s = 0.0L;
    for (int i = n; i >= 1; i--) {
        s += 1.0L / (long double)i;
    }
    return s;
}

int main(void) {
    const int n = 10000000;
    long double ref = sum_reference(n);

    float r_fwd  = sum_forward(n);
    float r_bwd  = sum_backward(n);
    float r_pair = sum_pairwise(1, n);
    float r_kah  = sum_kahan(n);

    printf("Reference (long double): %.12Lf\n\n", ref);
    printf("%-12s | %-14s | %-14s\n", "Method", "Result (float)", "Rel. error");
    printf("-------------|----------------|----------------\n");
    printf("%-12s | %-14.8f | %.6e\n", "Forward",  r_fwd,  (double)(fabsl((long double)r_fwd  - ref) / ref));
    printf("%-12s | %-14.8f | %.6e\n", "Backward", r_bwd,  (double)(fabsl((long double)r_bwd  - ref) / ref));
    printf("%-12s | %-14.8f | %.6e\n", "Pairwise", r_pair, (double)(fabsl((long double)r_pair - ref) / ref));
    printf("%-12s | %-14.8f | %.6e\n", "Kahan",    r_kah,  (double)(fabsl((long double)r_kah  - ref) / ref));

    return 0;
}
