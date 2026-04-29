LDFLAGS =  -L/usr/local/lib
CFLAGS = -I/usr/local/include -I/usr/local/include/libkeccak.a.headers
LIBFLAGS = -lcrypto -lkeccak -lm
CC = gcc
CFILES := $(shell find . -name '*.c' | sed -e 's/\.c/\.o/')

OBJS = ${CFILES}

SIGN_OBJS = ${OBJS} \
	sign.o \
	PQCgenKAT_sign.o
ENC_OBJS = ${OBJS} 
KEM_OBJS = ${OBJS} \
	kem.o \
	PQCgenKAT_kem.o

kem: ${OBJS}
	$(CC) $(LDFLAGS) $(CFLAGS)  -o $@ $^ $(LIBFLAGS)
encrypt: ${OBJS}
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $^ $(LIBFLAGS)
sign: ${OBJS}
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $^  $(LIBFLAGS)

%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $< 

rng.o : rng.h
api.o : api.h

