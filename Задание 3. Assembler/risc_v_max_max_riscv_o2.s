# Target: RISC-V (64-bits) gcc -O2 -march=rv64gc

max2:
        mv      a5,a1
        bge     a1,a0,.L2
        mv      a5,a0
.L2:
        sext.w  a0,a5
        ret

max3:
        mv      a5,a0
        sext.w  a0,a0
        bge     a5,a2,.L5
        sext.w  a0,a2
.L5:
        sext.w  a5,a0
        bge     a5,a1,.L6
        sext.w  a0,a1
.L6:
        ret