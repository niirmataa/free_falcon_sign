typedef long unsigned int size_t;
typedef int wchar_t;

typedef struct
  {
    int quot;
    int rem;
  } div_t;
typedef struct
  {
    long int quot;
    long int rem;
  } ldiv_t;
__extension__ typedef struct
  {
    long long int quot;
    long long int rem;
  } lldiv_t;
extern size_t __ctype_get_mb_cur_max (void) __attribute__ ((__nothrow__ , __leaf__)) ;
extern double atof (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
extern int atoi (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
extern long int atol (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
__extension__ extern long long int atoll (const char *__nptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
extern double strtod (const char *__restrict __nptr,
        char **__restrict __endptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern float strtof (const char *__restrict __nptr,
       char **__restrict __endptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern long double strtold (const char *__restrict __nptr,
       char **__restrict __endptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern long int strtol (const char *__restrict __nptr,
   char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern unsigned long int strtoul (const char *__restrict __nptr,
      char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
__extension__
extern long long int strtoll (const char *__restrict __nptr,
         char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
__extension__
extern unsigned long long int strtoull (const char *__restrict __nptr,
     char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern __inline __attribute__ ((__gnu_inline__)) int
__attribute__ ((__nothrow__ , __leaf__)) atoi (const char *__nptr)
{
  return (int) strtol (__nptr, (char **) ((void *)0), 10);
}
extern __inline __attribute__ ((__gnu_inline__)) long int
__attribute__ ((__nothrow__ , __leaf__)) atol (const char *__nptr)
{
  return strtol (__nptr, (char **) ((void *)0), 10);
}
__extension__ extern __inline __attribute__ ((__gnu_inline__)) long long int
__attribute__ ((__nothrow__ , __leaf__)) atoll (const char *__nptr)
{
  return strtoll (__nptr, (char **) ((void *)0), 10);
}
extern int rand (void) __attribute__ ((__nothrow__ , __leaf__));
extern void srand (unsigned int __seed) __attribute__ ((__nothrow__ , __leaf__));
extern void *malloc (size_t __size) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__))
     __attribute__ ((__alloc_size__ (1))) ;
extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) __attribute__ ((__alloc_size__ (1, 2))) ;
extern void *realloc (void *__ptr, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__warn_unused_result__)) __attribute__ ((__alloc_size__ (2)));
extern void free (void *__ptr) __attribute__ ((__nothrow__ , __leaf__));
extern void abort (void) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__)) __attribute__ ((__cold__));
extern int atexit (void (*__func) (void)) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
extern void exit (int __status) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern void _Exit (int __status) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
extern char *getenv (const char *__name) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1))) ;
extern int system (const char *__command) ;
typedef int (*__compar_fn_t) (const void *, const void *);
extern void *bsearch (const void *__key, const void *__base,
        size_t __nmemb, size_t __size, __compar_fn_t __compar)
     __attribute__ ((__nonnull__ (1, 2, 5))) ;
extern __inline __attribute__ ((__gnu_inline__)) void *
bsearch (const void *__key, const void *__base, size_t __nmemb, size_t __size,
  __compar_fn_t __compar)
{
  const void *__p;
  int __comparison;
  while (__nmemb)
    {
      __p = (const void *) (((const char *) __base) + ((__nmemb >> 1) * __size));
      __comparison = (*__compar) (__key, __p);
      if (__comparison == 0)
 {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wcast-qual"
   return (void *) __p;
#pragma GCC diagnostic pop
 }
      if (__comparison > 0)
 {
   __base = ((const char *) __p) + __size;
   --__nmemb;
 }
      __nmemb >>= 1;
    }
  return ((void *)0);
}
extern void qsort (void *__base, size_t __nmemb, size_t __size,
     __compar_fn_t __compar) __attribute__ ((__nonnull__ (1, 4)));
extern int abs (int __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
extern long int labs (long int __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
__extension__ extern long long int llabs (long long int __x)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
extern div_t div (int __numer, int __denom)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
extern ldiv_t ldiv (long int __numer, long int __denom)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
__extension__ extern lldiv_t lldiv (long long int __numer,
        long long int __denom)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__)) ;
extern int mblen (const char *__s, size_t __n) __attribute__ ((__nothrow__ , __leaf__));
extern int mbtowc (wchar_t *__restrict __pwc,
     const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__ , __leaf__));
extern int wctomb (char *__s, wchar_t __wchar) __attribute__ ((__nothrow__ , __leaf__));
extern size_t mbstowcs (wchar_t *__restrict __pwcs,
   const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__ , __leaf__))
    __attribute__ ((__access__ (__read_only__, 2)));
extern size_t wcstombs (char *__restrict __s,
   const wchar_t *__restrict __pwcs, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__access__ (__write_only__, 1, 3)))
  __attribute__ ((__access__ (__read_only__, 2)));
extern __inline __attribute__ ((__gnu_inline__)) double
__attribute__ ((__nothrow__ , __leaf__)) atof (const char *__nptr)
{
  return strtod (__nptr, (char **) ((void *)0));
}


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
typedef struct falcon_vrfy_ falcon_vrfy;
falcon_vrfy *falcon_vrfy_new(void);
void falcon_vrfy_free(falcon_vrfy *fv);
int falcon_vrfy_set_public_key(falcon_vrfy *fv,
 const void *pkey, size_t len);
void falcon_vrfy_start(falcon_vrfy *fv, const void *r, size_t rlen);
void falcon_vrfy_update(falcon_vrfy *fv, const void *data, size_t len);
int falcon_vrfy_verify(falcon_vrfy *fv, const void *sig, size_t len);
typedef struct falcon_sign_ falcon_sign;
falcon_sign *falcon_sign_new(void);
void falcon_sign_free(falcon_sign *fs);
void falcon_sign_set_seed(falcon_sign *fs,
 const void *seed, size_t len, int replace);
int falcon_sign_set_private_key(falcon_sign *fs,
 const void *skey, size_t len);
int falcon_sign_start(falcon_sign *fs, void *r );
void falcon_sign_start_external_nonce(falcon_sign *fs,
 const void *r, size_t rlen);
void falcon_sign_update(falcon_sign *fs, const void *data, size_t len);
size_t falcon_sign_generate(falcon_sign *fs,
 void *sig, size_t sig_max_len, int comp);
typedef struct falcon_keygen_ falcon_keygen;
falcon_keygen *falcon_keygen_new(unsigned logn, int ternary);
void falcon_keygen_free(falcon_keygen *fk);
size_t falcon_keygen_max_privkey_size(falcon_keygen *fk);
size_t falcon_keygen_max_pubkey_size(falcon_keygen *fk);
void falcon_keygen_set_seed(falcon_keygen *fk,
 const void *seed, size_t len, int replace);
int falcon_keygen_make(falcon_keygen *fk, int comp,
 void *privkey, size_t *privkey_len,
 void *pubkey, size_t *pubkey_len);
size_t falcon_encode_12289(void *out, size_t max_out_len,
 const uint16_t *x, unsigned logn);
size_t falcon_decode_12289(uint16_t *x, unsigned logn,
 const void *data, size_t len);
size_t falcon_encode_18433(void *out, size_t max_out_len,
 const uint16_t *x, unsigned logn);
size_t falcon_decode_18433(uint16_t *x, unsigned logn,
 const void *data, size_t len);
size_t falcon_encode_small(void *out, size_t max_out_len,
 int comp, unsigned q, const int16_t *x, unsigned logn);
size_t falcon_decode_small(int16_t *x, unsigned logn,
 int comp, unsigned q, const void *data, size_t len);
void falcon_hash_to_point(shake_context *sc, unsigned q,
 uint16_t *x, unsigned logn);
int falcon_is_short(const int16_t *s1, const int16_t *s2,
 unsigned logn, unsigned ter);
int falcon_vrfy_verify_raw(const uint16_t *c0, const int16_t *s2,
 const uint16_t *h, unsigned logn, int ternary);
int falcon_compute_public(uint16_t *h,
 const int16_t *f, const int16_t *g, unsigned logn, int ternary);
int falcon_complete_private(int16_t *G,
 const int16_t *f, const int16_t *g, const int16_t *F,
 unsigned logn, int ternary);

typedef float float_t;
typedef double double_t;
extern int __fpclassify (double __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __signbit (double __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __isinf (double __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __finite (double __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __isnan (double __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __iseqsig (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));
extern int __issignaling (double __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
 extern double acos (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __acos (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double asin (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __asin (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double atan (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __atan (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double atan2 (double __y, double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __atan2 (double __y, double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double cos (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __cos (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double sin (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __sin (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double tan (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __tan (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double cosh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __cosh (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double sinh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __sinh (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double tanh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __tanh (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double acosh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __acosh (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double asinh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __asinh (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double atanh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __atanh (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double exp (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __exp (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__)); extern double __frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__));
extern double ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__)); extern double __ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__));
 extern double log (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __log (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double log10 (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __log10 (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double modf (double __x, double *__iptr) __attribute__ ((__nothrow__ , __leaf__)); extern double __modf (double __x, double *__iptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));
 extern double expm1 (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __expm1 (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double log1p (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __log1p (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double logb (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __logb (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double exp2 (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __exp2 (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double log2 (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __log2 (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double pow (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __pow (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));
extern double sqrt (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __sqrt (double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern double hypot (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __hypot (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));
 extern double cbrt (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __cbrt (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double ceil (double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double fabs (double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double floor (double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double fmod (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __fmod (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));
extern double copysign (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double nan (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__)); extern double __nan (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__));
 extern double erf (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __erf (double) __attribute__ ((__nothrow__ , __leaf__));
 extern double erfc (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __erfc (double) __attribute__ ((__nothrow__ , __leaf__));
extern double lgamma (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __lgamma (double) __attribute__ ((__nothrow__ , __leaf__));
extern double tgamma (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __tgamma (double) __attribute__ ((__nothrow__ , __leaf__));
extern double rint (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __rint (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double nextafter (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __nextafter (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));
extern double nexttoward (double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __nexttoward (double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern double remainder (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __remainder (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));
extern double scalbn (double __x, int __n) __attribute__ ((__nothrow__ , __leaf__)); extern double __scalbn (double __x, int __n) __attribute__ ((__nothrow__ , __leaf__));
extern int ilogb (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern int __ilogb (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double scalbln (double __x, long int __n) __attribute__ ((__nothrow__ , __leaf__)); extern double __scalbln (double __x, long int __n) __attribute__ ((__nothrow__ , __leaf__));
extern double nearbyint (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __nearbyint (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double round (double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double trunc (double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double remquo (double __x, double __y, int *__quo) __attribute__ ((__nothrow__ , __leaf__)); extern double __remquo (double __x, double __y, int *__quo) __attribute__ ((__nothrow__ , __leaf__));
extern long int lrint (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long int __lrint (double __x) __attribute__ ((__nothrow__ , __leaf__));
__extension__
extern long long int llrint (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long long int __llrint (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long int lround (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long int __lround (double __x) __attribute__ ((__nothrow__ , __leaf__));
__extension__
extern long long int llround (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long long int __llround (double __x) __attribute__ ((__nothrow__ , __leaf__));
extern double fdim (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __fdim (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));
extern double fmax (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double fmin (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern double fma (double __x, double __y, double __z) __attribute__ ((__nothrow__ , __leaf__)); extern double __fma (double __x, double __y, double __z) __attribute__ ((__nothrow__ , __leaf__));
extern int __fpclassifyf (float __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __signbitf (float __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __isinff (float __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __finitef (float __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __isnanf (float __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __iseqsigf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));
extern int __issignalingf (float __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
 extern float acosf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __acosf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float asinf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __asinf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float atanf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __atanf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float atan2f (float __y, float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __atan2f (float __y, float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float cosf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __cosf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float sinf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __sinf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float tanf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __tanf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float coshf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __coshf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float sinhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __sinhf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float tanhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __tanhf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float acoshf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __acoshf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float asinhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __asinhf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float atanhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __atanhf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float expf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __expf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__)); extern float __frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__));
extern float ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__)); extern float __ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__));
 extern float logf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __logf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float log10f (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __log10f (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float modff (float __x, float *__iptr) __attribute__ ((__nothrow__ , __leaf__)); extern float __modff (float __x, float *__iptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));
 extern float expm1f (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __expm1f (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float log1pf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __log1pf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float logbf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __logbf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float exp2f (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __exp2f (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float log2f (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __log2f (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float powf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __powf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));
extern float sqrtf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __sqrtf (float __x) __attribute__ ((__nothrow__ , __leaf__));
 extern float hypotf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __hypotf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));
 extern float cbrtf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __cbrtf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float ceilf (float __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float fabsf (float __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float floorf (float __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float fmodf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __fmodf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));
extern float copysignf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float nanf (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__)); extern float __nanf (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__));
 extern float erff (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __erff (float) __attribute__ ((__nothrow__ , __leaf__));
 extern float erfcf (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __erfcf (float) __attribute__ ((__nothrow__ , __leaf__));
extern float lgammaf (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __lgammaf (float) __attribute__ ((__nothrow__ , __leaf__));
extern float tgammaf (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __tgammaf (float) __attribute__ ((__nothrow__ , __leaf__));
extern float rintf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __rintf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float nextafterf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __nextafterf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));
extern float nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern float remainderf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __remainderf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));
extern float scalbnf (float __x, int __n) __attribute__ ((__nothrow__ , __leaf__)); extern float __scalbnf (float __x, int __n) __attribute__ ((__nothrow__ , __leaf__));
extern int ilogbf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern int __ilogbf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float scalblnf (float __x, long int __n) __attribute__ ((__nothrow__ , __leaf__)); extern float __scalblnf (float __x, long int __n) __attribute__ ((__nothrow__ , __leaf__));
extern float nearbyintf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __nearbyintf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float roundf (float __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float truncf (float __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float remquof (float __x, float __y, int *__quo) __attribute__ ((__nothrow__ , __leaf__)); extern float __remquof (float __x, float __y, int *__quo) __attribute__ ((__nothrow__ , __leaf__));
extern long int lrintf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern long int __lrintf (float __x) __attribute__ ((__nothrow__ , __leaf__));
__extension__
extern long long int llrintf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern long long int __llrintf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern long int lroundf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern long int __lroundf (float __x) __attribute__ ((__nothrow__ , __leaf__));
__extension__
extern long long int llroundf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern long long int __llroundf (float __x) __attribute__ ((__nothrow__ , __leaf__));
extern float fdimf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __fdimf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));
extern float fmaxf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float fminf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern float fmaf (float __x, float __y, float __z) __attribute__ ((__nothrow__ , __leaf__)); extern float __fmaf (float __x, float __y, float __z) __attribute__ ((__nothrow__ , __leaf__));
extern int __fpclassifyl (long double __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __signbitl (long double __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __isinfl (long double __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __finitel (long double __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __isnanl (long double __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __iseqsigl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern int __issignalingl (long double __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
 extern long double acosl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __acosl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double asinl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __asinl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double atanl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __atanl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double atan2l (long double __y, long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __atan2l (long double __y, long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double cosl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __cosl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double sinl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __sinl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double tanl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __tanl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double coshl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __coshl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double sinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __sinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double tanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __tanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double acoshl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __acoshl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double asinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __asinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double atanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __atanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double expl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __expl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__)); extern long double __frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__));
extern long double ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__)); extern long double __ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__));
 extern long double logl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __logl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double log10l (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __log10l (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__ , __leaf__)); extern long double __modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));
 extern long double expm1l (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __expm1l (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double log1pl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __log1pl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double logbl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __logbl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double exp2l (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __exp2l (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double log2l (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __log2l (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double powl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __powl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern long double sqrtl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __sqrtl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
 extern long double hypotl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __hypotl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
 extern long double cbrtl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __cbrtl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double ceill (long double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double fabsl (long double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double floorl (long double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double fmodl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __fmodl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern long double copysignl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double nanl (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__)); extern long double __nanl (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__));
 extern long double erfl (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __erfl (long double) __attribute__ ((__nothrow__ , __leaf__));
 extern long double erfcl (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __erfcl (long double) __attribute__ ((__nothrow__ , __leaf__));
extern long double lgammal (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __lgammal (long double) __attribute__ ((__nothrow__ , __leaf__));
extern long double tgammal (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __tgammal (long double) __attribute__ ((__nothrow__ , __leaf__));
extern long double rintl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __rintl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern long double nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern long double remainderl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __remainderl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern long double scalbnl (long double __x, int __n) __attribute__ ((__nothrow__ , __leaf__)); extern long double __scalbnl (long double __x, int __n) __attribute__ ((__nothrow__ , __leaf__));
extern int ilogbl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern int __ilogbl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double scalblnl (long double __x, long int __n) __attribute__ ((__nothrow__ , __leaf__)); extern long double __scalblnl (long double __x, long int __n) __attribute__ ((__nothrow__ , __leaf__));
extern long double nearbyintl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __nearbyintl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double roundl (long double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double truncl (long double __x) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double remquol (long double __x, long double __y, int *__quo) __attribute__ ((__nothrow__ , __leaf__)); extern long double __remquol (long double __x, long double __y, int *__quo) __attribute__ ((__nothrow__ , __leaf__));
extern long int lrintl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long int __lrintl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
__extension__
extern long long int llrintl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long long int __llrintl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long int lroundl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long int __lroundl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
__extension__
extern long long int llroundl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long long int __llroundl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
extern long double fdiml (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __fdiml (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
extern long double fmaxl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double fminl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));
extern long double fmal (long double __x, long double __y, long double __z) __attribute__ ((__nothrow__ , __leaf__)); extern long double __fmal (long double __x, long double __y, long double __z) __attribute__ ((__nothrow__ , __leaf__));
extern int __fpclassifyf128 (_Float128 __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __signbitf128 (_Float128 __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
extern int __isinff128 (_Float128 __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __finitef128 (_Float128 __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __isnanf128 (_Float128 __value) __attribute__ ((__nothrow__ , __leaf__))
  __attribute__ ((__const__));
extern int __iseqsigf128 (_Float128 __x, _Float128 __y) __attribute__ ((__nothrow__ , __leaf__));
extern int __issignalingf128 (_Float128 __value) __attribute__ ((__nothrow__ , __leaf__))
     __attribute__ ((__const__));
enum
  {
    FP_NAN =
      0,
    FP_INFINITE =
      1,
    FP_ZERO =
      2,
    FP_SUBNORMAL =
      3,
    FP_NORMAL =
      4
  };

typedef uint64_t fpr;
static inline uint64_t
fpr_ursh(uint64_t x, int n)
{
 x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
 return x >> (n & 31);
}
static inline int64_t
fpr_irsh(int64_t x, int n)
{
 x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
 return x >> (n & 31);
}
static inline uint64_t
fpr_ulsh(uint64_t x, int n)
{
 x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
 return x << (n & 31);
}
static inline fpr
FPR(int s, int e, uint64_t m)
{
 fpr x;
 uint32_t t;
 unsigned f;
 e += 1076;
 t = (uint32_t)e >> 31;
 m &= (uint64_t)t - 1;
 t = (uint32_t)(m >> 54);
 e &= -(int)t;
 x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
 f = (unsigned)m & 7U;
 x += (0xC8U >> f) & 1;
 return x;
}
fpr fpr_scaled(int64_t i, int sc);
fpr fpr_add(fpr x, fpr y);
fpr fpr_mul(fpr x, fpr y);
fpr fpr_div(fpr x, fpr y);
fpr fpr_sqrt(fpr x);
static const fpr fpr_log2 = 0x3fe62e42fefa39efULL;
static const fpr fpr_p55 = 0x4360000000000000ULL;
static const fpr fpr_p63 = 0x43e0000000000000ULL;
static const fpr fpr_p64 = 0x43f0000000000000ULL;
static const fpr fpr_W1R = 0x3fe0000000000000ULL;
static const fpr fpr_W1I = 0x3febb67ae8584caaULL;
static const fpr fpr_W2R = 0xbfe0000000000000ULL;
static const fpr fpr_W2I = 0x3febb67ae8584caaULL;
static const fpr fpr_W4R = 0xbfe0000000000000ULL;
static const fpr fpr_W4I = 0xbfebb67ae8584caaULL;
static const fpr fpr_W5R = 0x3fe0000000000000ULL;
static const fpr fpr_W5I = 0xbfebb67ae8584caaULL;
static const fpr fpr_IW1I = 0x3ff279a74590331cULL;
static const fpr fpr_zero = 0x0000000000000000ULL;
static const fpr fpr_one = 0x3ff0000000000000ULL;
static const fpr fpr_two = 0x4000000000000000ULL;
static const fpr fpr_onehalf = 0x3fe0000000000000ULL;
static const fpr FPR_P1_EMU = 0x3fc555555555553eULL;
static const fpr FPR_P2_EMU = 0xbf66c16c16bebd93ULL;
static const fpr FPR_P3_EMU = 0x3f11566aaf25de2cULL;
static const fpr FPR_P4_EMU = 0xbebbbd41c5d26bf1ULL;
static const fpr FPR_P5_EMU = 0x3e66376972bea4d0ULL;
static inline fpr
fpr_of(int64_t i)
{
 return fpr_scaled(i, 0);
}
static inline fpr
fpr_inverse_of(long i)
{
 return fpr_div(fpr_one, fpr_of(i));
}
static inline int64_t
fpr_rint(fpr x)
{
 uint64_t m, d;
 int e;
 uint32_t s, dd, f;
 m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
 e = 1085 - ((int)(x >> 52) & 0x7FF);
 m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
 e &= 63;
 d = fpr_ulsh(m, 63 - e);
 dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
 f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
 m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
 s = (uint32_t)(x >> 63);
 return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
}
static inline long
fpr_floor(fpr x)
{
 uint64_t t, mask;
 int64_t xi;
 int e, cc;
 e = (int)(x >> 52) & 0x7FF;
 t = x >> 63;
 xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
  & (((uint64_t)1 << 63) - 1));
 xi = (xi ^ -(int64_t)t) + (int64_t)t;
 cc = 1085 - e;
 xi = fpr_irsh(xi, cc & 63);
 mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
 xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
 return (long)xi;
}
static inline int64_t
fpr_trunc(fpr x)
{
 uint64_t t, xu;
 int e, cc;
 e = (int)(x >> 52) & 0x7FF;
 xu = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
 cc = 1085 - e;
 xu = fpr_ursh(xu, cc & 63);
 xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
 t = x >> 63;
 xu = (xu ^ -t) + t;
 return (int64_t)xu;
}
static inline fpr
fpr_sub(fpr x, fpr y)
{
 y ^= (uint64_t)1 << 63;
 return fpr_add(x, y);
}
static inline fpr
fpr_neg(fpr x)
{
 x ^= (uint64_t)1 << 63;
 return x;
}
static inline fpr
fpr_half(fpr x)
{
 uint32_t t;
 x -= (uint64_t)1 << 52;
 t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
 x &= (uint64_t)t - 1;
 return x;
}
static inline fpr
fpr_double(fpr x)
{
 x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
 return x;
}
static inline fpr
fpr_sqr(fpr x)
{
 return fpr_mul(x, x);
}
static inline fpr
fpr_inv(fpr x)
{
 return fpr_div(fpr_one, x);
}
static inline int
fpr_lt(fpr x, fpr y)
{
 int64_t sx, sy;
 int cc0, cc1;
 memcpy(&sx, &x, sizeof sx);
 memcpy(&sy, &y, sizeof sy);
 cc0 = sx < sy;
 cc1 = sx > sy;
 return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
}
static inline fpr
fpr_max(fpr x, fpr y)
{
 return fpr_lt(x, y) ? y : x;
}
static inline fpr
fpr_exp_small(fpr x)
{
 fpr s, t, c;
 s = fpr_half(x);
 t = fpr_sqr(s);
 c = fpr_add(FPR_P4_EMU, fpr_mul(t, FPR_P5_EMU));
 c = fpr_add(FPR_P3_EMU, fpr_mul(t, c));
 c = fpr_add(FPR_P2_EMU, fpr_mul(t, c));
 c = fpr_add(FPR_P1_EMU, fpr_mul(t, c));
 c = fpr_sub(s, fpr_mul(t, c));
 s = fpr_sub(fpr_one,
  fpr_sub(fpr_div(fpr_mul(s, c), fpr_sub(c, fpr_two)), s));
 return fpr_sqr(s);
}
static const uint64_t fpr_expm_p63_coefficients[13] = {
 0x00000004741183A3ULL,
 0x00000036548CFC06ULL,
 0x0000024FDCBF140AULL,
 0x0000171D939DE045ULL,
 0x0000D00CF58F6F84ULL,
 0x000680681CF796E3ULL,
 0x002D82D8305B0FEAULL,
 0x011111110E066FD0ULL,
 0x0555555555070F00ULL,
 0x155555555581FF00ULL,
 0x400000000002B400ULL,
 0x7FFFFFFFFFFF4800ULL,
 0x8000000000000000ULL
};
static inline uint64_t
fpr_mul_high_u64(uint64_t x, uint64_t y)
{
 uint32_t x0, x1, y0, y1;
 uint64_t a, b, c;
 x0 = (uint32_t)x;
 x1 = (uint32_t)(x >> 32);
 y0 = (uint32_t)y;
 y1 = (uint32_t)(y >> 32);
 a = (uint64_t)x0 * (uint64_t)y1
  + (((uint64_t)x0 * (uint64_t)y0) >> 32);
 b = (uint64_t)x1 * (uint64_t)y0;
 c = (a >> 32) + (b >> 32);
 c += ((uint64_t)(uint32_t)a + (uint64_t)(uint32_t)b) >> 32;
 c += (uint64_t)x1 * (uint64_t)y1;
 return c;
}
static inline uint64_t
fpr_expm_scaled(fpr r)
{
 uint64_t y, z;
 unsigned u;
 y = fpr_expm_p63_coefficients[0];
 z = (uint64_t)fpr_trunc(fpr_mul(r, fpr_p63)) << 1;
 for (u = 1; u < 13; u ++) {
  y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
 }
 return y;
}
static const fpr fpr_inv_ln2 = 0x3ff71547652b82feULL;
static const fpr fpr_inv_8 = 0x3fc0000000000000ULL;
static const fpr fpr_inv_10 = 0x3fb999999999999aULL;
static const fpr fpr_pi = 0x400921fb54442d18ULL;
static const fpr fpr_sin_c0 = 0x3ff0000000000000ULL;
static const fpr fpr_sin_c1 = 0xbfc5555555555555ULL;
static const fpr fpr_sin_c2 = 0x3f81111111111111ULL;
static const fpr fpr_sin_c3 = 0xbf2a01a01a01a01aULL;
static const fpr fpr_sin_c4 = 0x3ec71de3a556c734ULL;
static const fpr fpr_sin_c5 = 0xbe5ae64567f544e4ULL;
static const fpr fpr_sin_c6 = 0x3de6124613a86d09ULL;
static const fpr fpr_sin_c7 = 0xbd6ae7f3e733b81fULL;
static const fpr fpr_sin_c8 = 0x3ce952c77030ad4aULL;
static const fpr fpr_sin_c9 = 0xbc62f49b46814157ULL;
static const fpr fpr_cos_c0 = 0x3ff0000000000000ULL;
static const fpr fpr_cos_c1 = 0xbfe0000000000000ULL;
static const fpr fpr_cos_c2 = 0x3fa5555555555555ULL;
static const fpr fpr_cos_c3 = 0xbf56c16c16c16c17ULL;
static const fpr fpr_cos_c4 = 0x3efa01a01a01a01aULL;
static const fpr fpr_cos_c5 = 0xbe927e4fb7789f5cULL;
static const fpr fpr_cos_c6 = 0x3e21eed8eff8d898ULL;
static const fpr fpr_cos_c7 = 0xbda93974a8c07c9dULL;
static const fpr fpr_cos_c8 = 0x3d2ae7f3e733b81fULL;
static const fpr fpr_cos_c9 = 0xbca6827863b97d97ULL;
static const fpr fpr_inv_odd[] = { 0x3ff0000000000000ULL, 0x3fd5555555555555ULL, 0x3fc999999999999aULL, 0x3fc2492492492492ULL, 0x3fbc71c71c71c71cULL, 0x3fb745d1745d1746ULL, 0x3fb3b13b13b13b14ULL, 0x3fb1111111111111ULL, 0x3fae1e1e1e1e1e1eULL, 0x3faaf286bca1af28ULL, 0x3fa8618618618618ULL, 0x3fa642c8590b2164ULL, 0x3fa47ae147ae147bULL, 0x3fa2f684bda12f68ULL, 0x3fa1a7b9611a7b96ULL, 0x3fa0842108421084ULL, 0x3f9f07c1f07c1f08ULL, 0x3f9d41d41d41d41dULL, 0x3f9bacf914c1bad0ULL, 0x3f9a41a41a41a41aULL, 0x3f98f9c18f9c18faULL, 0x3f97d05f417d05f4ULL, 0x3f96c16c16c16c17ULL, 0x3f95c9882b931057ULL, 0x3f94e5e0a72f0539ULL, 0x3f94141414141414ULL, 0x3f93521cfb2b78c1ULL, 0x3f929e4129e4129eULL, 0x3f91f7047dc11f70ULL, 0x3f915b1e5f75270dULL, 0x3f90c9714fbcda3bULL, 0x3f90410410410410ULL };
static inline fpr
fpr_log_emu(fpr x)
{
 fpr m, y, y2, acc;
 int e, i;
 e = (int)((x >> 52) & 0x7FF) - 1023;
 m = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1023 << 52);
 y = fpr_div(fpr_sub(m, fpr_one), fpr_add(m, fpr_one));
 y2 = fpr_sqr(y);
 acc = fpr_inv_odd[31];
 for (i = 30; i >= 0; i --) {
  acc = fpr_add(fpr_inv_odd[i], fpr_mul(y2, acc));
 }
 return fpr_add(fpr_mul(fpr_of(e), fpr_log2),
  fpr_double(fpr_mul(y, acc)));
}
static inline fpr
fpr_sin_poly(fpr t)
{
 fpr x, y;
 x = fpr_sqr(t);
 y = fpr_sin_c9;
 y = fpr_add(fpr_sin_c8, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c7, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c6, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c5, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c4, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c3, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c2, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c1, fpr_mul(x, y));
 y = fpr_add(fpr_sin_c0, fpr_mul(x, y));
 return fpr_mul(t, y);
}
static inline fpr
fpr_cos_poly(fpr t)
{
 fpr x, y;
 x = fpr_sqr(t);
 y = fpr_cos_c9;
 y = fpr_add(fpr_cos_c8, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c7, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c6, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c5, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c4, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c3, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c2, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c1, fpr_mul(x, y));
 y = fpr_add(fpr_cos_c0, fpr_mul(x, y));
 return y;
}
static inline void
fpr_sincos_tick(fpr *c, fpr *s, uint32_t b)
{
 uint64_t u, qraw;
 int64_t rem;
 int q;
 fpr t, st, ct;
 u = (uint64_t)b + 1;
 qraw = (u + ((uint64_t)1 << 29)) >> 30;
 q = (int)qraw & 3;
 rem = (int64_t)u - ((int64_t)qraw << 30);
 t = fpr_mul(fpr_scaled(rem, -31), fpr_pi);
 st = fpr_sin_poly(t);
 ct = fpr_cos_poly(t);
 switch (q) {
 case 0:
  *s = st;
  *c = ct;
  break;
 case 1:
  *s = ct;
  *c = fpr_neg(st);
  break;
 case 2:
  *s = fpr_neg(st);
  *c = fpr_neg(ct);
  break;
 default:
  *s = fpr_neg(ct);
  *c = st;
  break;
 }
}
static inline void
fpr_gauss(fpr *re, fpr *im, fpr sigma, uint32_t a, uint32_t b)
{
 fpr u, mag, c, s;
 u = fpr_scaled((int64_t)a + 1, -32);
 mag = fpr_mul(sigma, fpr_sqrt(fpr_neg(fpr_double(fpr_log_emu(u)))));
 fpr_sincos_tick(&c, &s, b);
 *re = fpr_mul(mag, c);
 *im = fpr_mul(mag, s);
}
void falcon_FFT(fpr *f, unsigned logn);
void falcon_iFFT(fpr *f, unsigned logn);
void falcon_poly_add(fpr *restrict a, const fpr *restrict b, unsigned logn);
void falcon_poly_addconst(fpr *a, fpr x, unsigned logn);
void falcon_poly_addconst_fft(fpr *a, fpr x, unsigned logn);
void falcon_poly_sub(fpr *restrict a, const fpr *restrict b, unsigned logn);
void falcon_poly_neg(fpr *a, unsigned logn);
void falcon_poly_adj(fpr *a, unsigned logn);
void falcon_poly_adj_fft(fpr *a, unsigned logn);
void falcon_poly_mul_fft(fpr *restrict a, const fpr *restrict b, unsigned logn);
void falcon_poly_sqr_fft(fpr *a, unsigned logn);
void falcon_poly_muladj_fft(fpr *restrict a,
 const fpr *restrict b, unsigned logn);
void falcon_poly_mulselfadj_fft(fpr *a, unsigned logn);
void falcon_poly_mulconst(fpr *a, fpr x, unsigned logn);
void falcon_poly_inv_fft(fpr *a, unsigned logn);
void falcon_poly_div_fft(fpr *restrict a, const fpr *restrict b, unsigned logn);
void falcon_poly_divadj_fft(fpr *restrict a,
 const fpr *restrict b, unsigned logn);
void falcon_poly_invnorm2_fft(fpr *restrict d,
 const fpr *restrict a, const fpr *restrict b, unsigned logn);
void falcon_poly_add_muladj_fft(fpr *restrict d,
 const fpr *restrict F, const fpr *restrict G,
 const fpr *restrict f, const fpr *restrict g, unsigned logn);
void falcon_poly_mul_autoadj_fft(fpr *restrict a,
 const fpr *restrict b, unsigned logn);
void falcon_poly_div_autoadj_fft(fpr *restrict a,
 const fpr *restrict b, unsigned logn);
void falcon_poly_split_fft(fpr *restrict t0, fpr *restrict t1,
 const fpr *restrict f, unsigned logn);
void falcon_poly_merge_fft(fpr *restrict f,
 const fpr *restrict f0, const fpr *restrict f1, unsigned logn);
void falcon_FFT3(fpr *f, unsigned logn, unsigned full);
void falcon_iFFT3(fpr *f, unsigned logn, unsigned full);
void falcon_poly_add3(fpr *restrict a, const fpr *restrict b,
 unsigned logn, unsigned full);
void falcon_poly_addconst3(fpr *a, fpr x, unsigned logn, unsigned full);
void falcon_poly_addconst_fft3(fpr *a, fpr x, unsigned logn, unsigned full);
void falcon_poly_sub3(fpr *restrict a, const fpr *restrict b,
 unsigned logn, unsigned full);
void falcon_poly_neg3(fpr *a, unsigned logn, unsigned full);
void falcon_poly_adj_fft3(fpr *a, unsigned logn, unsigned full);
void falcon_poly_mul_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
void falcon_poly_sqr_fft3(fpr *a, unsigned logn, unsigned full);
void falcon_poly_muladj_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
void falcon_poly_mulselfadj_fft3(fpr *a, unsigned logn, unsigned full);
void falcon_poly_mulconst3(fpr *a, fpr x, unsigned logn, unsigned full);
void falcon_poly_inv_fft3(fpr *a, unsigned logn, unsigned full);
void falcon_poly_div_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
void falcon_poly_divadj_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
void falcon_poly_invnorm2_fft3(fpr *restrict d,
 const fpr *restrict a, const fpr *restrict b,
 unsigned logn, unsigned full);
void falcon_poly_add_muladj_fft3(fpr *restrict d,
 const fpr *restrict F, const fpr *restrict G,
 const fpr *restrict f, const fpr *restrict g,
 unsigned logn, unsigned full);
void falcon_poly_mul_autoadj_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
void falcon_poly_div_autoadj_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
void falcon_poly_split_top_fft3(
 fpr *restrict f0, fpr *restrict f1, fpr *restrict f2,
 const fpr *restrict f, unsigned logn);
void falcon_poly_split_deep_fft3(fpr *restrict f0, fpr *restrict f1,
 const fpr *restrict f, unsigned logn);
void falcon_poly_merge_top_fft3(fpr *restrict f,
 const fpr *restrict f0, const fpr *restrict f1, const fpr *restrict f2,
 unsigned logn);
void falcon_poly_merge_deep_fft3(fpr *restrict f,
 const fpr *restrict f0, const fpr *restrict f1, unsigned logn);
int falcon_get_seed(void *seed, size_t seed_len);
typedef struct {
 union {
  unsigned char d[4096];
  uint64_t dummy_u64;
 } buf;
 size_t ptr;
 union {
  unsigned char d[256];
  uint64_t dummy_u64;
 } state;
 int type;
} prng;
int falcon_prng_init(prng *p, shake_context *src, int type);
void falcon_prng_refill(prng *p);
void falcon_prng_get_bytes(prng *p, void *dst, size_t len);
static inline uint64_t
falcon_prng_get_u64(prng *p)
{
 size_t u;
 u = p->ptr;
 if (u >= (sizeof p->buf.d) - 9) {
  falcon_prng_refill(p);
  u = 0;
 }
 p->ptr = u + 8;
 {
  uint64_t x;
  memcpy(&x, p->buf.d + u, sizeof x);
  return x;
 }
}
static inline unsigned
falcon_prng_get_u8(prng *p)
{
 unsigned v;
 v = p->buf.d[p->ptr ++];
 if (p->ptr == sizeof p->buf.d) {
  falcon_prng_refill(p);
 }
 return v;
}
size_t
falcon_encode_12289(void *out, size_t max_out_len,
 const uint16_t *x, unsigned logn)
{
 unsigned char *buf;
 size_t n, u;
 uint32_t acc;
 int acc_len;
 n = (size_t)1 << logn;
 buf = out;
 u = 0;
 acc = 0;
 acc_len = 0;
 while (n > 0) {
  acc = (acc << 14) | (*x ++);
  n --;
  acc_len += 14;
  while (acc_len >= 8) {
   acc_len -= 8;
   if (out != ((void *)0)) {
    if (u >= max_out_len) {
     return 0;
    }
    buf[u] = (unsigned char)(acc >> acc_len);
   }
   u ++;
   acc &= (1U << acc_len) - 1U;
  }
 }
 if (acc_len > 0) {
  if (out != ((void *)0)) {
   if (u >= max_out_len) {
    return 0;
   }
   buf[u] = (unsigned char)(acc << (8 - acc_len));
  }
  u ++;
 }
 return u;
}
size_t
falcon_decode_12289(uint16_t *x, unsigned logn, const void *data, size_t len)
{
 const unsigned char *buf;
 size_t n, u;
 uint32_t acc;
 int acc_len;
 n = (size_t)1 << logn;
 buf = data;
 u = 0;
 acc = 0;
 acc_len = 0;
 while (n > 0) {
  if (u >= len) {
   return 0;
  }
  acc = (acc << 8) | buf[u ++];
  acc_len += 8;
  if (acc_len >= 14) {
   uint32_t w;
   acc_len -= 14;
   w = acc >> acc_len;
   if (w >= 12289) {
    return 0;
   }
   *x ++ = (uint16_t)w;
   n --;
   acc &= (1U << acc_len) - 1U;
  }
 }
 if (acc != 0) {
  return 0;
 }
 return len;
}
size_t
falcon_encode_18433(void *out, size_t max_out_len,
 const uint16_t *x, unsigned logn)
{
 unsigned char *buf;
 size_t n, u;
 uint32_t acc;
 int acc_len;
 n = (size_t)3 << (logn - 1);
 buf = out;
 u = 0;
 acc = 0;
 acc_len = 0;
 while (n > 0) {
  acc = (acc << 15) | (*x ++);
  n --;
  acc_len += 15;
  while (acc_len >= 8) {
   acc_len -= 8;
   if (out != ((void *)0)) {
    if (u >= max_out_len) {
     return 0;
    }
    buf[u] = (unsigned char)(acc >> acc_len);
   }
   u ++;
   acc &= (1U << acc_len) - 1U;
  }
 }
 if (acc_len > 0) {
  if (out != ((void *)0)) {
   if (u >= max_out_len) {
    return 0;
   }
   buf[u] = (unsigned char)(acc << (8 - acc_len));
  }
  u ++;
 }
 return u;
}
size_t
falcon_decode_18433(uint16_t *x, unsigned logn, const void *data, size_t len)
{
 const unsigned char *buf;
 size_t n, u;
 uint32_t acc;
 int acc_len;
 n = (size_t)3 << (logn - 1);
 buf = data;
 u = 0;
 acc = 0;
 acc_len = 0;
 while (n > 0) {
  if (u >= len) {
   return 0;
  }
  acc = (acc << 8) | buf[u ++];
  acc_len += 8;
  if (acc_len >= 15) {
   uint32_t w;
   acc_len -= 15;
   w = acc >> acc_len;
   if (w >= 18433) {
    return 0;
   }
   *x ++ = (uint16_t)w;
   n --;
   acc &= (1U << acc_len) - 1U;
  }
 }
 if (acc != 0) {
  return 0;
 }
 return len;
}
static size_t
compress_none(void *out, size_t max_out_len,
 unsigned q, const int16_t *x, unsigned logn)
{
 size_t len, u;
 unsigned char *buf;
 if (q == 12289) {
  len = (size_t)2 << logn;
 } else {
  len = (size_t)3 << logn;
 }
 if (out == ((void *)0)) {
  return len;
 }
 if (max_out_len < len) {
  return 0;
 }
 buf = out;
 for (u = 0; u < len; u += 2) {
  unsigned w;
  w = *x ++;
  buf[u + 0] = (unsigned char)(w >> 8);
  buf[u + 1] = (unsigned char)w;
 }
 return len;
}
static size_t
compress_static(void *out, size_t max_out_len,
 unsigned q, const int16_t *x, unsigned logn)
{
 unsigned char *buf;
 size_t n, u;
 unsigned acc, mask;
 int acc_len, j;
 if (q == 12289) {
  n = (size_t)1 << logn;
  j = 7;
 } else {
  n = (size_t)3 << (logn - 1);
  j = 8;
 }
 mask = (1U << j) - 1U;
 buf = out;
 u = 0;
 acc = 0;
 acc_len = 0;
 while (n > 0) {
  int w;
  unsigned lo;
  int ne;
  w = *x ++;
  n --;
  if (w < 0) {
   w = -w;
   lo = 1U << j;
  } else {
   lo = 0;
  }
  lo |= w & mask;
  ne = w >> j;
  acc = (acc << (j + 1)) | lo;
  acc_len += j + 1;
  while (acc_len >= 8) {
   acc_len -= 8;
   if (buf != ((void *)0)) {
    if (u >= max_out_len) {
     return 0;
    }
    buf[u] = (unsigned char)(acc >> acc_len);
   }
   u ++;
  }
  while (ne -- >= 0) {
   acc <<= 1;
   acc += ((unsigned)ne >> 15) & 1;
   if (++ acc_len == 8) {
    if (buf != ((void *)0)) {
     if (u >= max_out_len) {
      return 0;
     }
     buf[u] = (unsigned char)acc;
    }
    u ++;
    acc_len = 0;
   }
  }
 }
 if (acc_len > 0) {
  if (buf != ((void *)0)) {
   if (u >= max_out_len) {
    return 0;
   }
   buf[u] = (unsigned char)(acc << (8 - acc_len));
  }
  u ++;
 }
 return u;
}
size_t
falcon_encode_small(void *out, size_t max_out_len,
 int comp, unsigned q, const int16_t *x, unsigned logn)
{
 switch (comp) {
 case 0:
  return compress_none(out, max_out_len, q, x, logn);
 case 1:
  return compress_static(out, max_out_len, q, x, logn);
 default:
  return 0;
 }
}
static size_t
uncompress_none(int16_t *x, unsigned logn,
 unsigned q, const void *data, size_t len)
{
 size_t n, u;
 const unsigned char *buf;
 uint32_t hq, tq;
 if (q == 12289) {
  n = (size_t)1 << logn;
 } else {
  n = (size_t)3 << (logn - 1);
 }
 if (len < (n << 1)) {
  return 0;
 }
 hq = q >> 1;
 tq = hq + q + 1;
 buf = data;
 for (u = 0; u < n; u ++) {
  uint32_t w;
  long y;
  w = ((uint32_t)buf[(u << 1) + 0] << 8)
   | (uint32_t)buf[(u << 1) + 1];
  w |= -(w & 0x8000);
  w += q;
  if (!(((hq - w) & (w - tq)) >> 31)) {
   return 0;
  }
  y = (long)w - (long)q;
  x[u] = (int16_t)y;
 }
 return n << 1;
}
static size_t
uncompress_static(int16_t *x, unsigned logn,
 unsigned q, const void *data, size_t len)
{
 const unsigned char *buf;
 size_t n, u, v;
 unsigned db, mask;
 unsigned db_len, j;
 if (q == 12289) {
  n = (size_t)1 << logn;
  j = 7;
 } else {
  n = (size_t)3 << (logn - 1);
  j = 8;
 }
 mask = (1U << j) - 1U;
 buf = data;
 u = 0;
 v = 0;
 db = 0;
 db_len = 0;
 for (;;) {
  unsigned sign;
  unsigned lo;
  unsigned ne;
  while (db_len <= j) {
   if (v >= len) {
    return 0;
   }
   db = (db << 8) + buf[v ++];
   db_len += 8;
  }
  sign = (db >> (db_len - 1)) & 1;
  db_len -= j + 1;
  lo = (db >> db_len) & mask;
  for (ne = 0;; ne ++) {
   unsigned bit;
   if (db_len == 0) {
    if (v >= len) {
     return 0;
    }
    db = buf[v ++];
    db_len = 8;
   }
   db_len --;
   bit = (db >> db_len) & 1;
   if (bit) {
    break;
   }
  }
  if (ne > 255) {
   return 0;
  }
  lo += (ne << j);
  if (sign) {
   x[u] = -(int16_t)lo;
  } else {
   x[u] = (int16_t)lo;
  }
  if (++ u >= n) {
   if ((db & ((1U << db_len) - 1U)) != 0) {
    return 0;
   }
   return v;
  }
 }
}
size_t
falcon_decode_small(int16_t *x, unsigned logn,
 int comp, unsigned q, const void *data, size_t len)
{
 switch (comp) {
 case 0:
  return uncompress_none(x, logn, q, data, len);
 case 1:
  return uncompress_static(x, logn, q, data, len);
 default:
  return 0;
 }
}
void
falcon_hash_to_point(shake_context *sc, unsigned q, uint16_t *x, unsigned logn)
{
 size_t n;
 uint32_t lim;
 if (q == 12289) {
  n = (size_t)1 << logn;
 } else {
  n = (size_t)3 << (logn - 1);
 }
 lim = (uint32_t)65536 - ((uint32_t)65536 % q);
 while (n > 0) {
  unsigned char buf[2];
  uint32_t w;
  shake_extract(sc, buf, sizeof buf);
  w = (buf[0] << 8) | buf[1];
  if (w < lim) {
   *x ++ = (uint16_t)(w % q);
   n --;
  }
 }
}
int
falcon_is_short(const int16_t *s1, const int16_t *s2,
 unsigned logn, unsigned ter)
{
 if (ter) {
  size_t n, hn, u;
  int64_t s;
  n = (size_t)3 << (logn - 1);
  hn = n >> 1;
  s = 0;
  for (u = 0; u < n; u ++) {
   int32_t z;
   z = s1[u];
   s += z * z;
   z = s2[u];
   s += z * z;
  }
  for (u = 0; u < hn; u ++) {
   s += (int32_t)s1[u] * (int32_t)s1[u + hn];
   s += (int32_t)s2[u] * (int32_t)s2[u + hn];
  }
  {
   int64_t bound;
   switch (logn) {
   case 3:
    bound = 987497;
    break;
   case 4:
    bound = 2052189;
    break;
   case 5:
    bound = 4258765;
    break;
   case 6:
    bound = 8826305;
    break;
   case 7:
    bound = 18270159;
    break;
   case 8:
    bound = 37775417;
    break;
   case 9:
    bound = 78021029;
    break;
   case 10:
    bound = ((int64_t)2093922385);
    break;
   default:
    return 0;
   }
   return s < bound;
  }
 } else {
  size_t n, u;
  uint32_t s, ng;
  n = (size_t)1 << logn;
  s = 0;
  ng = 0;
  for (u = 0; u < n; u ++) {
   int32_t z;
   z = s1[u];
   s += (uint32_t)(z * z);
   ng |= s;
   z = s2[u];
   s += (uint32_t)(z * z);
   ng |= s;
  }
  s |= -(ng >> 31);
  return s < (((uint32_t)7085 * (uint32_t)12289) >> (10 - logn));
 }
}
