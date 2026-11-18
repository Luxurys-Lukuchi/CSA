long sum(const long *a, long n) {
    long s = 0;
    for (long i = 0; i < n; i++)
        s += a[i];
    return s;
}

long f(long n) {
    long s = 0;
    for (long i = 0; i < n; i++)
        s += i * i;
    return s;
}