# Build script for the Falcon implementation.
#
# ==========================(LICENSE BEGIN)============================
#
# Copyright (c) 2017  Falcon Project
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# ===========================(LICENSE END)=============================
#
# @author   Thomas Pornin <thomas.pornin@nccgroup.trust>

.POSIX:

CC = c99
# CT-safe: -O only. -O3 -march=native introduced timing jitter in dudect.
# FPEMU_CT_STRICT uses the branchless default CDF path and CT BerExp.
CFLAGS = -W -Wall -O -DFPR_IMPL=\"fpr-emulated.h\" -DSAMPLER_CODF=0 -DSAMPLER_CDF=0 -DCT_BEREXP=1 -DFT_TERNARY_ADAPTIVE_CDF=1 -DFT1536_CANDIDATE_PROFILE=1 -DCLEANSE=1 -DTRUE_TERNARY_SECRET=1 -DTRUE_TERNARY_SECRET_MODE=1 -DTERNARY_KEYGEN_BOUND_SCALE_NUM=1250 -DTERNARY_KEYGEN_BOUND_SCALE_DEN=100 -DTERNARY_KEYGEN_MAX_ATTEMPTS=3000000 -DSIGN_MAX_ATTEMPTS=16
LD = c99
LDFLAGS =
LDLIBS = -lm

OBJ = falcon-enc.o falcon-vrfy.o frng.o shake.o fpr-emulated.o falcon-fft.o falcon-keygen.o falcon-sign.o

all: test_falcon falcon

clean:
	-rm -f $(OBJ) test_falcon test_falcon.o falcon tool.o

test_falcon: test_falcon.o $(OBJ)
	$(LD) $(LDFLAGS) -o test_falcon test_falcon.o $(OBJ) $(LDLIBS)

falcon: tool.o $(OBJ)
	$(LD) $(LDFLAGS) -o falcon tool.o $(OBJ) $(LDLIBS)

test_falcon.o: test_falcon.c falcon.h internal.h fpr-emulated.h shake.h
	$(CC) $(CFLAGS) -c -o test_falcon.o test_falcon.c

tool.o: tool.c falcon.h
	$(CC) $(CFLAGS) -c -o tool.o tool.c

falcon-enc.o: falcon-enc.c falcon.h internal.h fpr-emulated.h shake.h
	$(CC) $(CFLAGS) -c -o falcon-enc.o falcon-enc.c

falcon-fft.o: falcon-fft.c falcon.h internal.h fpr-emulated.h shake.h
	$(CC) $(CFLAGS) -c -o falcon-fft.o falcon-fft.c

falcon-keygen.o: falcon-keygen.c falcon.h internal.h fpr-emulated.h shake.h
	$(CC) $(CFLAGS) -c -o falcon-keygen.o falcon-keygen.c

falcon-sign.o: falcon-sign.c falcon.h internal.h fpr-emulated.h shake.h ft1536-adaptive-cdf-tables.h
	$(CC) $(CFLAGS) -c -o falcon-sign.o falcon-sign.c

falcon-vrfy.o: falcon-vrfy.c falcon.h internal.h fpr-emulated.h shake.h
	$(CC) $(CFLAGS) -c -o falcon-vrfy.o falcon-vrfy.c

frng.o: frng.c falcon.h internal.h fpr-emulated.h shake.h
	$(CC) $(CFLAGS) -c -o frng.o frng.c

fpr-emulated.o: fpr-emulated.c falcon.h internal.h fpr-emulated.h shake.h
	$(CC) $(CFLAGS) -c -o fpr-emulated.o fpr-emulated.c

shake.o: shake.c shake.h
	$(CC) $(CFLAGS) -c -o shake.o shake.c
