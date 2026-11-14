#include <limits.h>
#include <stdint.h>

/* Безветвевая версия is_pow2 */
int is_pow2(uint64_t x) {
    return (x != 0) & ((x & (x - 1)) == 0);
}

/* Ветвящаяся версия is_pow2_branchy для сравнения ассемблера на -O2 */
int is_pow2_branchy(uint64_t x) {
    if (x == 0) return 0;
    while (x > 1) {
        if (x & 1) return 0;
        x >>= 1;
    }
    return 1;
}

/* Безветвевая версия sat_add32 через битовую маску переполнения */
int32_t sat_add32(int32_t a, int32_t b) {
    uint32_t ua = (uint32_t)a;
    uint32_t ub = (uint32_t)b;
    uint32_t usum = ua + ub;
    uint32_t ovf = (~(ua ^ ub) & (ua ^ usum)) >> 31;
    uint32_t ovf_mask = 0u - ovf;
    uint32_t sat_val = 0x7FFFFFFFu + (ua >> 31);
    return (int32_t)((usum & ~ovf_mask) | (sat_val & ovf_mask));
}

/* Ветвящаяся версия sat_add32_branchy для сравнения ассемблера на -O2 */
int32_t sat_add32_branchy(int32_t a, int32_t b) {
    long long s = (long long)a + b;
    if (s > INT32_MAX) return INT32_MAX;
    if (s < INT32_MIN) return INT32_MIN;
    return (int32_t)s;
}
