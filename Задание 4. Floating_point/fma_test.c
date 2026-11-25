#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

__attribute__((noinline))
float fma_expr(float a, float b, float c) {
    return a * b + c;
}

static uint32_t as_u32(float f) {
    uint32_t u;
    memcpy(&u, &f, sizeof u);
    return u;
}

int main(void) {
    volatile float a = 1.0f + ldexpf(1.0f, -23); /* 1 + 2^-23 */
    volatile float b = 1.0f - ldexpf(1.0f, -23); /* 1 - 2^-23 */
    volatile float c = -1.0f;

    float r = fma_expr(a, b, c);
    printf("a = %.10g (0x%08x)\n", a, as_u32(a));
    printf("b = %.10g (0x%08x)\n", b, as_u32(b));
    printf("c = %.10g (0x%08x)\n", c, as_u32(c));
    printf("a * b + c = %.10g (hex float: %a, bits: 0x%08x)\n", r, r, as_u32(r));
    return 0;
}
