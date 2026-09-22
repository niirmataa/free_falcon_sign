# FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- source slice control builds.
# Literal Makefile -O flag (source/Makefile: CT-safe: -O only), GCC 14.2, C99.
SRC      = ../../inputs/bootstrap/source
CC       = gcc
CFLAGS   = -W -Wall -O -std=c99 -I$(SRC) -DFPR_IMPL=\"fpr-emulated.h\"

all: harness_rint harness_rint_asan harness_rint_ubsan

harness_rint: harness_rint.c $(SRC)/fpr-emulated.c $(SRC)/fpr-emulated.h
	$(CC) $(CFLAGS) -o $@ harness_rint.c $(SRC)/fpr-emulated.c

harness_rint_asan: harness_rint.c $(SRC)/fpr-emulated.c $(SRC)/fpr-emulated.h
	$(CC) $(CFLAGS) -fsanitize=address -fno-omit-frame-pointer -o $@ harness_rint.c $(SRC)/fpr-emulated.c

harness_rint_ubsan: harness_rint.c $(SRC)/fpr-emulated.c $(SRC)/fpr-emulated.h
	$(CC) $(CFLAGS) -fsanitize=undefined -fno-sanitize-recover=undefined -o $@ harness_rint.c $(SRC)/fpr-emulated.c

clean:
	rm -f harness_rint harness_rint_asan harness_rint_ubsan

.PHONY: all clean
