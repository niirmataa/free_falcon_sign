/* V02 independent diagnostic: original pinned C through direct inclusion. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "fpr-emulated.h"
#include "shake.c"

/* Synthetic stand-in: only the sub -> add wiring is checked, not fpr_add. */
fpr fpr_add(fpr x, fpr y) { return x + y; }

int main(int argc, char **argv) {
    FILE *in;
    char op[32];
    unsigned long long aa, bb, cc, ee;
    unsigned long long n = 0;
    if (argc != 2 || !(in = fopen(argv[1], "r"))) return 2;
    while (fscanf(in, "%31s %llx %llx %llx %llx", op, &aa, &bb, &cc, &ee) == 5) {
        uint64_t a = (uint64_t)aa, b = (uint64_t)bb, c = (uint64_t)cc;
        uint64_t actual = 0;
        if (!strcmp(op,"neg")) actual = fpr_neg(a);
        else if (!strcmp(op,"half")) actual = fpr_half(a);
        else if (!strcmp(op,"double")) actual = fpr_double(a);
        else if (!strcmp(op,"rint")) actual = (uint64_t)fpr_rint(a);
        else if (!strcmp(op,"floor")) actual = (uint64_t)fpr_floor(a);
        else if (!strcmp(op,"pack")) actual = FPR((int32_t)(uint32_t)a, (int32_t)(uint32_t)b, c);
        else if (!strcmp(op,"sub_stub")) actual = fpr_sub(a, b);
        else if (!strcmp(op,"ursh")) { if (b >= 64) return 4; actual = fpr_ursh(a, (int)b); }
        else if (!strcmp(op,"ulsh")) { if (b >= 64) return 4; actual = fpr_ulsh(a, (int)b); }
        else if (!strcmp(op,"irsh")) { if (b >= 64) return 4; actual = (uint64_t)fpr_irsh((int64_t)a, (int)b); }
        else if (!strcmp(op,"le")) {
            unsigned char buf[32];
            if (b > 8) return 4;
            memset(buf, 0xa5, sizeof buf);
            enc64le(buf+b, a);
            actual = dec64le(buf+b);
            for (unsigned i = 0; i < sizeof buf; i++)
                if ((i < b || i >= b+8) && buf[i] != 0xa5) return 5;
            for (unsigned i = 0; i < 8; i++)
                if (buf[b+i] != (unsigned char)(a >> (8*i))) return 6;
        } else return 3;
        if (actual != (uint64_t)ee) {
            fprintf(stderr, "mismatch row=%llu op=%s a=%016" PRIx64 " actual=%016" PRIx64
                    " expected=%016llx\n", n, op, a, actual, ee);
            return 1;
        }
        n++;
    }
    if (ferror(in)) return 7;
    fclose(in);
    printf("V02 PINNED C PASS rows=%llu; word/LE/sub-stub only\n", n);
    return 0;
}
