#include <stdint.h>
#include <stdio.h>
#include <string.h>

void print_float(float f) {
    uint32_t u;
    memcpy(&u, &f, sizeof u);     /* законный способ смотреть на биты */
    uint32_t s = (u >> 31) & 1u,
             e = (u >> 23) & 0xFFu,
             m = u & 0x7FFFFFu;
    printf("%-14g s=%u e=%3u (2^%4d) m=0x%06x\n",
           f, s, e, (int)e - 127, m);
}

int main(void) {
    volatile float zero = 0.0f;

    print_float(1.0f);
    print_float(-6.25f);
    print_float(0.1f);
    print_float(1e-40f);
    print_float(1.0f / zero);
    print_float(zero / zero);

    return 0;
}
