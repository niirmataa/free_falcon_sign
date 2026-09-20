
typedef long unsigned int size_t;
extern void *memcpy (void *__restrict __dest, const void *__restrict __src,
       size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memmove (void *__dest, const void *__src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memset (void *__s, int __c, size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern int memcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int __memcmpeq (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memchr (const void *__s, int __c, size_t __n)
      __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *strcpy (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncpy (char *__restrict __dest,
        const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strcat (char *__restrict __dest, const char *__restrict __src)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncat (char *__restrict __dest, const char *__restrict __src,
        size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcmp (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strncmp (const char *__s1, const char *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcoll (const char *__s1, const char *__s2)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strxfrm (char *__restrict __dest,
         const char *__restrict __src, size_t __n)
    __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2))) __attribute__ ((__access__ (__write_only__, 1, 3)));
extern char *strchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *strrchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern size_t strcspn (const char *__s, const char *__reject)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strspn (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strpbrk (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strstr (const char *__haystack, const char *__needle)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strtok (char *__restrict __s, const char *__restrict __delim)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));
extern char *__strtok_r (char *__restrict __s,
    const char *__restrict __delim,
    char **__restrict __save_ptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2, 3)));
extern size_t strlen (const char *__s)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *strerror (int __errnum) __attribute__ ((__nothrow__ , __leaf__));

typedef long int ptrdiff_t;
typedef int wchar_t;
typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;
typedef __int8_t __int_least8_t;
typedef __uint8_t __uint_least8_t;
typedef __int16_t __int_least16_t;
typedef __uint16_t __uint_least16_t;
typedef __int32_t __int_least32_t;
typedef __uint32_t __uint_least32_t;
typedef __int64_t __int_least64_t;
typedef __uint64_t __uint_least64_t;
typedef long int __quad_t;
typedef unsigned long int __u_quad_t;
typedef long int __intmax_t;
typedef unsigned long int __uintmax_t;
typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned long int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef long int __suseconds64_t;
typedef int __daddr_t;
typedef int __key_t;
typedef int __clockid_t;
typedef void * __timer_t;
typedef long int __blksize_t;
typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;
typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;
typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;
typedef long int __fsword_t;
typedef long int __ssize_t;
typedef long int __syscall_slong_t;
typedef unsigned long int __syscall_ulong_t;
typedef __off64_t __loff_t;
typedef char *__caddr_t;
typedef long int __intptr_t;
typedef unsigned int __socklen_t;
typedef int __sig_atomic_t;
typedef __int8_t int8_t;
typedef __int16_t int16_t;
typedef __int32_t int32_t;
typedef __int64_t int64_t;
typedef __uint8_t uint8_t;
typedef __uint16_t uint16_t;
typedef __uint32_t uint32_t;
typedef __uint64_t uint64_t;
typedef __int_least8_t int_least8_t;
typedef __int_least16_t int_least16_t;
typedef __int_least32_t int_least32_t;
typedef __int_least64_t int_least64_t;
typedef __uint_least8_t uint_least8_t;
typedef __uint_least16_t uint_least16_t;
typedef __uint_least32_t uint_least32_t;
typedef __uint_least64_t uint_least64_t;
typedef signed char int_fast8_t;
typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
typedef unsigned char uint_fast8_t;
typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
typedef long int intptr_t;
typedef unsigned long int uintptr_t;
typedef __intmax_t intmax_t;
typedef __uintmax_t uintmax_t;
typedef struct {
 unsigned char dbuf[200];
 size_t dptr;
 size_t rate;
 uint64_t A[25];
} shake_context;
void shake_init(shake_context *sc, int capacity);
void shake_inject(shake_context *sc, const void *data, size_t len);
void shake_flip(shake_context *sc);
void shake_extract(shake_context *sc, void *out, size_t len);
static const uint64_t RC[] = {
 0x0000000000000001, 0x0000000000008082,
 0x800000000000808A, 0x8000000080008000,
 0x000000000000808B, 0x0000000080000001,
 0x8000000080008081, 0x8000000000008009,
 0x000000000000008A, 0x0000000000000088,
 0x0000000080008009, 0x000000008000000A,
 0x000000008000808B, 0x800000000000008B,
 0x8000000000008089, 0x8000000000008003,
 0x8000000000008002, 0x8000000000000080,
 0x000000000000800A, 0x800000008000000A,
 0x8000000080008081, 0x8000000000008080,
 0x0000000080000001, 0x8000000080008008
};
static inline uint64_t
dec64le(const void *data)
{
 const unsigned char *buf;
 buf = data;
 return (uint64_t)buf[0]
  | ((uint64_t)buf[1] << 8)
  | ((uint64_t)buf[2] << 16)
  | ((uint64_t)buf[3] << 24)
  | ((uint64_t)buf[4] << 32)
  | ((uint64_t)buf[5] << 40)
  | ((uint64_t)buf[6] << 48)
  | ((uint64_t)buf[7] << 56);
}
static inline void
enc64le(void *out, uint64_t x)
{
 unsigned char *buf;
 buf = out;
 buf[0] = (unsigned char)x;
 buf[1] = (unsigned char)(x >> 8);
 buf[2] = (unsigned char)(x >> 16);
 buf[3] = (unsigned char)(x >> 24);
 buf[4] = (unsigned char)(x >> 32);
 buf[5] = (unsigned char)(x >> 40);
 buf[6] = (unsigned char)(x >> 48);
 buf[7] = (unsigned char)(x >> 56);
}
static void
xor_block(uint64_t *A, const void *data, size_t rate)
{
 size_t u;
 for (u = 0; u < rate; u += 8) {
  A[u >> 3] ^= dec64le((const unsigned char *)data + u);
 }
}
static void
process_block(uint64_t *A)
{
 uint64_t t0, t1, t2, t3, t4;
 uint64_t tt0, tt1, tt2, tt3;
 uint64_t t, kt;
 uint64_t c0, c1, c2, c3, c4, bnn;
 int j;
 for (j = 0; j < 24; j += 2) {
  tt0 = A[ 1] ^ A[ 6];
  tt1 = A[11] ^ A[16];
  tt0 ^= A[21] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[ 4] ^ A[ 9];
  tt3 = A[14] ^ A[19];
  tt0 ^= A[24];
  tt2 ^= tt3;
  t0 = tt0 ^ tt2;
  tt0 = A[ 2] ^ A[ 7];
  tt1 = A[12] ^ A[17];
  tt0 ^= A[22] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[ 0] ^ A[ 5];
  tt3 = A[10] ^ A[15];
  tt0 ^= A[20];
  tt2 ^= tt3;
  t1 = tt0 ^ tt2;
  tt0 = A[ 3] ^ A[ 8];
  tt1 = A[13] ^ A[18];
  tt0 ^= A[23] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[ 1] ^ A[ 6];
  tt3 = A[11] ^ A[16];
  tt0 ^= A[21];
  tt2 ^= tt3;
  t2 = tt0 ^ tt2;
  tt0 = A[ 4] ^ A[ 9];
  tt1 = A[14] ^ A[19];
  tt0 ^= A[24] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[ 2] ^ A[ 7];
  tt3 = A[12] ^ A[17];
  tt0 ^= A[22];
  tt2 ^= tt3;
  t3 = tt0 ^ tt2;
  tt0 = A[ 0] ^ A[ 5];
  tt1 = A[10] ^ A[15];
  tt0 ^= A[20] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[ 3] ^ A[ 8];
  tt3 = A[13] ^ A[18];
  tt0 ^= A[23];
  tt2 ^= tt3;
  t4 = tt0 ^ tt2;
  A[ 0] = A[ 0] ^ t0;
  A[ 5] = A[ 5] ^ t0;
  A[10] = A[10] ^ t0;
  A[15] = A[15] ^ t0;
  A[20] = A[20] ^ t0;
  A[ 1] = A[ 1] ^ t1;
  A[ 6] = A[ 6] ^ t1;
  A[11] = A[11] ^ t1;
  A[16] = A[16] ^ t1;
  A[21] = A[21] ^ t1;
  A[ 2] = A[ 2] ^ t2;
  A[ 7] = A[ 7] ^ t2;
  A[12] = A[12] ^ t2;
  A[17] = A[17] ^ t2;
  A[22] = A[22] ^ t2;
  A[ 3] = A[ 3] ^ t3;
  A[ 8] = A[ 8] ^ t3;
  A[13] = A[13] ^ t3;
  A[18] = A[18] ^ t3;
  A[23] = A[23] ^ t3;
  A[ 4] = A[ 4] ^ t4;
  A[ 9] = A[ 9] ^ t4;
  A[14] = A[14] ^ t4;
  A[19] = A[19] ^ t4;
  A[24] = A[24] ^ t4;
  A[ 5] = (A[ 5] << 36) | (A[ 5] >> (64 - 36));
  A[10] = (A[10] << 3) | (A[10] >> (64 - 3));
  A[15] = (A[15] << 41) | (A[15] >> (64 - 41));
  A[20] = (A[20] << 18) | (A[20] >> (64 - 18));
  A[ 1] = (A[ 1] << 1) | (A[ 1] >> (64 - 1));
  A[ 6] = (A[ 6] << 44) | (A[ 6] >> (64 - 44));
  A[11] = (A[11] << 10) | (A[11] >> (64 - 10));
  A[16] = (A[16] << 45) | (A[16] >> (64 - 45));
  A[21] = (A[21] << 2) | (A[21] >> (64 - 2));
  A[ 2] = (A[ 2] << 62) | (A[ 2] >> (64 - 62));
  A[ 7] = (A[ 7] << 6) | (A[ 7] >> (64 - 6));
  A[12] = (A[12] << 43) | (A[12] >> (64 - 43));
  A[17] = (A[17] << 15) | (A[17] >> (64 - 15));
  A[22] = (A[22] << 61) | (A[22] >> (64 - 61));
  A[ 3] = (A[ 3] << 28) | (A[ 3] >> (64 - 28));
  A[ 8] = (A[ 8] << 55) | (A[ 8] >> (64 - 55));
  A[13] = (A[13] << 25) | (A[13] >> (64 - 25));
  A[18] = (A[18] << 21) | (A[18] >> (64 - 21));
  A[23] = (A[23] << 56) | (A[23] >> (64 - 56));
  A[ 4] = (A[ 4] << 27) | (A[ 4] >> (64 - 27));
  A[ 9] = (A[ 9] << 20) | (A[ 9] >> (64 - 20));
  A[14] = (A[14] << 39) | (A[14] >> (64 - 39));
  A[19] = (A[19] << 8) | (A[19] >> (64 - 8));
  A[24] = (A[24] << 14) | (A[24] >> (64 - 14));
  bnn = ~A[12];
  kt = A[ 6] | A[12];
  c0 = A[ 0] ^ kt;
  kt = bnn | A[18];
  c1 = A[ 6] ^ kt;
  kt = A[18] & A[24];
  c2 = A[12] ^ kt;
  kt = A[24] | A[ 0];
  c3 = A[18] ^ kt;
  kt = A[ 0] & A[ 6];
  c4 = A[24] ^ kt;
  A[ 0] = c0;
  A[ 6] = c1;
  A[12] = c2;
  A[18] = c3;
  A[24] = c4;
  bnn = ~A[22];
  kt = A[ 9] | A[10];
  c0 = A[ 3] ^ kt;
  kt = A[10] & A[16];
  c1 = A[ 9] ^ kt;
  kt = A[16] | bnn;
  c2 = A[10] ^ kt;
  kt = A[22] | A[ 3];
  c3 = A[16] ^ kt;
  kt = A[ 3] & A[ 9];
  c4 = A[22] ^ kt;
  A[ 3] = c0;
  A[ 9] = c1;
  A[10] = c2;
  A[16] = c3;
  A[22] = c4;
  bnn = ~A[19];
  kt = A[ 7] | A[13];
  c0 = A[ 1] ^ kt;
  kt = A[13] & A[19];
  c1 = A[ 7] ^ kt;
  kt = bnn & A[20];
  c2 = A[13] ^ kt;
  kt = A[20] | A[ 1];
  c3 = bnn ^ kt;
  kt = A[ 1] & A[ 7];
  c4 = A[20] ^ kt;
  A[ 1] = c0;
  A[ 7] = c1;
  A[13] = c2;
  A[19] = c3;
  A[20] = c4;
  bnn = ~A[17];
  kt = A[ 5] & A[11];
  c0 = A[ 4] ^ kt;
  kt = A[11] | A[17];
  c1 = A[ 5] ^ kt;
  kt = bnn | A[23];
  c2 = A[11] ^ kt;
  kt = A[23] & A[ 4];
  c3 = bnn ^ kt;
  kt = A[ 4] | A[ 5];
  c4 = A[23] ^ kt;
  A[ 4] = c0;
  A[ 5] = c1;
  A[11] = c2;
  A[17] = c3;
  A[23] = c4;
  bnn = ~A[ 8];
  kt = bnn & A[14];
  c0 = A[ 2] ^ kt;
  kt = A[14] | A[15];
  c1 = bnn ^ kt;
  kt = A[15] & A[21];
  c2 = A[14] ^ kt;
  kt = A[21] | A[ 2];
  c3 = A[15] ^ kt;
  kt = A[ 2] & A[ 8];
  c4 = A[21] ^ kt;
  A[ 2] = c0;
  A[ 8] = c1;
  A[14] = c2;
  A[15] = c3;
  A[21] = c4;
  A[ 0] = A[ 0] ^ RC[j + 0];
  tt0 = A[ 6] ^ A[ 9];
  tt1 = A[ 7] ^ A[ 5];
  tt0 ^= A[ 8] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[24] ^ A[22];
  tt3 = A[20] ^ A[23];
  tt0 ^= A[21];
  tt2 ^= tt3;
  t0 = tt0 ^ tt2;
  tt0 = A[12] ^ A[10];
  tt1 = A[13] ^ A[11];
  tt0 ^= A[14] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[ 0] ^ A[ 3];
  tt3 = A[ 1] ^ A[ 4];
  tt0 ^= A[ 2];
  tt2 ^= tt3;
  t1 = tt0 ^ tt2;
  tt0 = A[18] ^ A[16];
  tt1 = A[19] ^ A[17];
  tt0 ^= A[15] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[ 6] ^ A[ 9];
  tt3 = A[ 7] ^ A[ 5];
  tt0 ^= A[ 8];
  tt2 ^= tt3;
  t2 = tt0 ^ tt2;
  tt0 = A[24] ^ A[22];
  tt1 = A[20] ^ A[23];
  tt0 ^= A[21] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[12] ^ A[10];
  tt3 = A[13] ^ A[11];
  tt0 ^= A[14];
  tt2 ^= tt3;
  t3 = tt0 ^ tt2;
  tt0 = A[ 0] ^ A[ 3];
  tt1 = A[ 1] ^ A[ 4];
  tt0 ^= A[ 2] ^ tt1;
  tt0 = (tt0 << 1) | (tt0 >> 63);
  tt2 = A[18] ^ A[16];
  tt3 = A[19] ^ A[17];
  tt0 ^= A[15];
  tt2 ^= tt3;
  t4 = tt0 ^ tt2;
  A[ 0] = A[ 0] ^ t0;
  A[ 3] = A[ 3] ^ t0;
  A[ 1] = A[ 1] ^ t0;
  A[ 4] = A[ 4] ^ t0;
  A[ 2] = A[ 2] ^ t0;
  A[ 6] = A[ 6] ^ t1;
  A[ 9] = A[ 9] ^ t1;
  A[ 7] = A[ 7] ^ t1;
  A[ 5] = A[ 5] ^ t1;
  A[ 8] = A[ 8] ^ t1;
  A[12] = A[12] ^ t2;
  A[10] = A[10] ^ t2;
  A[13] = A[13] ^ t2;
  A[11] = A[11] ^ t2;
  A[14] = A[14] ^ t2;
  A[18] = A[18] ^ t3;
  A[16] = A[16] ^ t3;
  A[19] = A[19] ^ t3;
  A[17] = A[17] ^ t3;
  A[15] = A[15] ^ t3;
  A[24] = A[24] ^ t4;
  A[22] = A[22] ^ t4;
  A[20] = A[20] ^ t4;
  A[23] = A[23] ^ t4;
  A[21] = A[21] ^ t4;
  A[ 3] = (A[ 3] << 36) | (A[ 3] >> (64 - 36));
  A[ 1] = (A[ 1] << 3) | (A[ 1] >> (64 - 3));
  A[ 4] = (A[ 4] << 41) | (A[ 4] >> (64 - 41));
  A[ 2] = (A[ 2] << 18) | (A[ 2] >> (64 - 18));
  A[ 6] = (A[ 6] << 1) | (A[ 6] >> (64 - 1));
  A[ 9] = (A[ 9] << 44) | (A[ 9] >> (64 - 44));
  A[ 7] = (A[ 7] << 10) | (A[ 7] >> (64 - 10));
  A[ 5] = (A[ 5] << 45) | (A[ 5] >> (64 - 45));
  A[ 8] = (A[ 8] << 2) | (A[ 8] >> (64 - 2));
  A[12] = (A[12] << 62) | (A[12] >> (64 - 62));
  A[10] = (A[10] << 6) | (A[10] >> (64 - 6));
  A[13] = (A[13] << 43) | (A[13] >> (64 - 43));
  A[11] = (A[11] << 15) | (A[11] >> (64 - 15));
  A[14] = (A[14] << 61) | (A[14] >> (64 - 61));
  A[18] = (A[18] << 28) | (A[18] >> (64 - 28));
  A[16] = (A[16] << 55) | (A[16] >> (64 - 55));
  A[19] = (A[19] << 25) | (A[19] >> (64 - 25));
  A[17] = (A[17] << 21) | (A[17] >> (64 - 21));
  A[15] = (A[15] << 56) | (A[15] >> (64 - 56));
  A[24] = (A[24] << 27) | (A[24] >> (64 - 27));
  A[22] = (A[22] << 20) | (A[22] >> (64 - 20));
  A[20] = (A[20] << 39) | (A[20] >> (64 - 39));
  A[23] = (A[23] << 8) | (A[23] >> (64 - 8));
  A[21] = (A[21] << 14) | (A[21] >> (64 - 14));
  bnn = ~A[13];
  kt = A[ 9] | A[13];
  c0 = A[ 0] ^ kt;
  kt = bnn | A[17];
  c1 = A[ 9] ^ kt;
  kt = A[17] & A[21];
  c2 = A[13] ^ kt;
  kt = A[21] | A[ 0];
  c3 = A[17] ^ kt;
  kt = A[ 0] & A[ 9];
  c4 = A[21] ^ kt;
  A[ 0] = c0;
  A[ 9] = c1;
  A[13] = c2;
  A[17] = c3;
  A[21] = c4;
  bnn = ~A[14];
  kt = A[22] | A[ 1];
  c0 = A[18] ^ kt;
  kt = A[ 1] & A[ 5];
  c1 = A[22] ^ kt;
  kt = A[ 5] | bnn;
  c2 = A[ 1] ^ kt;
  kt = A[14] | A[18];
  c3 = A[ 5] ^ kt;
  kt = A[18] & A[22];
  c4 = A[14] ^ kt;
  A[18] = c0;
  A[22] = c1;
  A[ 1] = c2;
  A[ 5] = c3;
  A[14] = c4;
  bnn = ~A[23];
  kt = A[10] | A[19];
  c0 = A[ 6] ^ kt;
  kt = A[19] & A[23];
  c1 = A[10] ^ kt;
  kt = bnn & A[ 2];
  c2 = A[19] ^ kt;
  kt = A[ 2] | A[ 6];
  c3 = bnn ^ kt;
  kt = A[ 6] & A[10];
  c4 = A[ 2] ^ kt;
  A[ 6] = c0;
  A[10] = c1;
  A[19] = c2;
  A[23] = c3;
  A[ 2] = c4;
  bnn = ~A[11];
  kt = A[ 3] & A[ 7];
  c0 = A[24] ^ kt;
  kt = A[ 7] | A[11];
  c1 = A[ 3] ^ kt;
  kt = bnn | A[15];
  c2 = A[ 7] ^ kt;
  kt = A[15] & A[24];
  c3 = bnn ^ kt;
  kt = A[24] | A[ 3];
  c4 = A[15] ^ kt;
  A[24] = c0;
  A[ 3] = c1;
  A[ 7] = c2;
  A[11] = c3;
  A[15] = c4;
  bnn = ~A[16];
  kt = bnn & A[20];
  c0 = A[12] ^ kt;
  kt = A[20] | A[ 4];
  c1 = bnn ^ kt;
  kt = A[ 4] & A[ 8];
  c2 = A[20] ^ kt;
  kt = A[ 8] | A[12];
  c3 = A[ 4] ^ kt;
  kt = A[12] & A[16];
  c4 = A[ 8] ^ kt;
  A[12] = c0;
  A[16] = c1;
  A[20] = c2;
  A[ 4] = c3;
  A[ 8] = c4;
  A[ 0] = A[ 0] ^ RC[j + 1];
  t = A[ 5];
  A[ 5] = A[18];
  A[18] = A[11];
  A[11] = A[10];
  A[10] = A[ 6];
  A[ 6] = A[22];
  A[22] = A[20];
  A[20] = A[12];
  A[12] = A[19];
  A[19] = A[15];
  A[15] = A[24];
  A[24] = A[ 8];
  A[ 8] = t;
  t = A[ 1];
  A[ 1] = A[ 9];
  A[ 9] = A[14];
  A[14] = A[ 2];
  A[ 2] = A[13];
  A[13] = A[23];
  A[23] = A[ 4];
  A[ 4] = A[21];
  A[21] = A[16];
  A[16] = A[ 3];
  A[ 3] = A[17];
  A[17] = A[ 7];
  A[ 7] = t;
 }
}
void
shake_init(shake_context *sc, int capacity)
{
 sc->rate = 200 - (size_t)(capacity >> 3);
 sc->dptr = 0;
 memset(sc->A, 0, sizeof sc->A);
 sc->A[ 1] = ~(uint64_t)0;
 sc->A[ 2] = ~(uint64_t)0;
 sc->A[ 8] = ~(uint64_t)0;
 sc->A[12] = ~(uint64_t)0;
 sc->A[17] = ~(uint64_t)0;
 sc->A[20] = ~(uint64_t)0;
}
void
shake_inject(shake_context *sc, const void *data, size_t len)
{
 const unsigned char *buf;
 size_t rate, dptr;
 buf = data;
 rate = sc->rate;
 dptr = sc->dptr;
 while (len > 0) {
  size_t clen;
  clen = rate - dptr;
  if (clen > len) {
   clen = len;
  }
  memcpy(sc->dbuf + dptr, buf, clen);
  dptr += clen;
  buf += clen;
  len -= clen;
  if (dptr == rate) {
   xor_block(sc->A, sc->dbuf, rate);
   process_block(sc->A);
   dptr = 0;
  }
 }
 sc->dptr = dptr;
}
void
shake_flip(shake_context *sc)
{
 if ((sc->dptr + 1) == sc->rate) {
  sc->dbuf[sc->dptr ++] = 0x9F;
 } else {
  sc->dbuf[sc->dptr ++] = 0x1F;
  memset(sc->dbuf + sc->dptr, 0x00, sc->rate - sc->dptr - 1);
  sc->dbuf[sc->rate - 1] = 0x80;
  sc->dptr = sc->rate;
 }
 xor_block(sc->A, sc->dbuf, sc->rate);
}
void
shake_extract(shake_context *sc, void *out, size_t len)
{
 unsigned char *buf;
 size_t dptr, rate;
 buf = out;
 dptr = sc->dptr;
 rate = sc->rate;
 while (len > 0) {
  size_t clen;
  if (dptr == rate) {
   unsigned char *dbuf;
   uint64_t *A;
   A = sc->A;
   dbuf = sc->dbuf;
   process_block(A);
   enc64le(dbuf + 0, A[ 0]);
   enc64le(dbuf + 8, ~A[ 1]);
   enc64le(dbuf + 16, ~A[ 2]);
   enc64le(dbuf + 24, A[ 3]);
   enc64le(dbuf + 32, A[ 4]);
   enc64le(dbuf + 40, A[ 5]);
   enc64le(dbuf + 48, A[ 6]);
   enc64le(dbuf + 56, A[ 7]);
   enc64le(dbuf + 64, ~A[ 8]);
   enc64le(dbuf + 72, A[ 9]);
   enc64le(dbuf + 80, A[10]);
   enc64le(dbuf + 88, A[11]);
   enc64le(dbuf + 96, ~A[12]);
   enc64le(dbuf + 104, A[13]);
   enc64le(dbuf + 112, A[14]);
   enc64le(dbuf + 120, A[15]);
   enc64le(dbuf + 128, A[16]);
   enc64le(dbuf + 136, ~A[17]);
   enc64le(dbuf + 144, A[18]);
   enc64le(dbuf + 152, A[19]);
   enc64le(dbuf + 160, ~A[20]);
   enc64le(dbuf + 168, A[21]);
   enc64le(dbuf + 176, A[22]);
   enc64le(dbuf + 184, A[23]);
   enc64le(dbuf + 192, A[24]);
   dptr = 0;
  }
  clen = rate - dptr;
  if (clen > len) {
   clen = len;
  }
  memcpy(buf, sc->dbuf + dptr, clen);
  dptr += clen;
  buf += clen;
  len -= clen;
 }
 sc->dptr = dptr;
}
