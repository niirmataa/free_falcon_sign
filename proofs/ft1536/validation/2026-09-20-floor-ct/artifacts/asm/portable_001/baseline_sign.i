# 0 "baseline/source/falcon-sign.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "baseline/source/falcon-sign.c"
# 32 "baseline/source/falcon-sign.c"
# 1 "baseline/source/internal.h" 1
# 36 "baseline/source/internal.h"
# 1 "/usr/include/stdlib.h" 1 3 4
# 26 "/usr/include/stdlib.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 33 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 415 "/usr/include/features.h" 3 4
# 1 "/usr/include/features-time64.h" 1 3 4
# 20 "/usr/include/features-time64.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 21 "/usr/include/features-time64.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 1 3 4
# 19 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 2 3 4
# 22 "/usr/include/features-time64.h" 2 3 4
# 416 "/usr/include/features.h" 2 3 4
# 523 "/usr/include/features.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 1 3 4
# 730 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 731 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/long-double.h" 1 3 4
# 732 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 2 3 4
# 524 "/usr/include/features.h" 2 3 4
# 547 "/usr/include/features.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 1 3 4
# 10 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/gnu/stubs-64.h" 1 3 4
# 11 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 2 3 4
# 548 "/usr/include/features.h" 2 3 4
# 34 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 2 3 4
# 27 "/usr/include/stdlib.h" 2 3 4





# 1 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 1 3 4
# 214 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 3 4

# 214 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 3 4
typedef long unsigned int size_t;
# 329 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 3 4
typedef int wchar_t;
# 33 "/usr/include/stdlib.h" 2 3 4


# 56 "/usr/include/stdlib.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/floatn.h" 1 3 4
# 131 "/usr/include/x86_64-linux-gnu/bits/floatn.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 1 3 4
# 24 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/long-double.h" 1 3 4
# 25 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 2 3 4
# 132 "/usr/include/x86_64-linux-gnu/bits/floatn.h" 2 3 4
# 57 "/usr/include/stdlib.h" 2 3 4


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
# 98 "/usr/include/stdlib.h" 3 4
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
# 177 "/usr/include/stdlib.h" 3 4
extern long int strtol (const char *__restrict __nptr,
   char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));

extern unsigned long int strtoul (const char *__restrict __nptr,
      char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
# 200 "/usr/include/stdlib.h" 3 4
__extension__
extern long long int strtoll (const char *__restrict __nptr,
         char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));

__extension__
extern unsigned long long int strtoull (const char *__restrict __nptr,
     char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
# 480 "/usr/include/stdlib.h" 3 4
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
# 573 "/usr/include/stdlib.h" 3 4
extern int rand (void) __attribute__ ((__nothrow__ , __leaf__));

extern void srand (unsigned int __seed) __attribute__ ((__nothrow__ , __leaf__));
# 672 "/usr/include/stdlib.h" 3 4
extern void *malloc (size_t __size) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__))
     __attribute__ ((__alloc_size__ (1))) ;

extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__malloc__)) __attribute__ ((__alloc_size__ (1, 2))) ;






extern void *realloc (void *__ptr, size_t __size)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__warn_unused_result__)) __attribute__ ((__alloc_size__ (2)));


extern void free (void *__ptr) __attribute__ ((__nothrow__ , __leaf__));
# 730 "/usr/include/stdlib.h" 3 4
extern void abort (void) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__)) __attribute__ ((__cold__));



extern int atexit (void (*__func) (void)) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));
# 756 "/usr/include/stdlib.h" 3 4
extern void exit (int __status) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
# 768 "/usr/include/stdlib.h" 3 4
extern void _Exit (int __status) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));




extern char *getenv (const char *__name) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1))) ;
# 923 "/usr/include/stdlib.h" 3 4
extern int system (const char *__command) ;
# 948 "/usr/include/stdlib.h" 3 4
typedef int (*__compar_fn_t) (const void *, const void *);
# 960 "/usr/include/stdlib.h" 3 4
extern void *bsearch (const void *__key, const void *__base,
        size_t __nmemb, size_t __size, __compar_fn_t __compar)
     __attribute__ ((__nonnull__ (1, 2, 5))) ;


# 1 "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h" 1 3 4
# 19 "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h" 3 4
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
# 966 "/usr/include/stdlib.h" 2 3 4




extern void qsort (void *__base, size_t __nmemb, size_t __size,
     __compar_fn_t __compar) __attribute__ ((__nonnull__ (1, 4)));
# 980 "/usr/include/stdlib.h" 3 4
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
# 1062 "/usr/include/stdlib.h" 3 4
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
# 1155 "/usr/include/stdlib.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h" 1 3 4
# 24 "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h" 3 4
extern __inline __attribute__ ((__gnu_inline__)) double
__attribute__ ((__nothrow__ , __leaf__)) atof (const char *__nptr)
{
  return strtod (__nptr, (char **) ((void *)0));
}
# 1156 "/usr/include/stdlib.h" 2 3 4
# 1167 "/usr/include/stdlib.h" 3 4

# 37 "baseline/source/internal.h" 2
# 1 "/usr/include/string.h" 1 3 4
# 26 "/usr/include/string.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 27 "/usr/include/string.h" 2 3 4






# 1 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 1 3 4
# 34 "/usr/include/string.h" 2 3 4
# 43 "/usr/include/string.h" 3 4
extern void *memcpy (void *__restrict __dest, const void *__restrict __src,
       size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));


extern void *memmove (void *__dest, const void *__src, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1, 2)));
# 61 "/usr/include/string.h" 3 4
extern void *memset (void *__s, int __c, size_t __n) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (1)));


extern int memcmp (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 80 "/usr/include/string.h" 3 4
extern int __memcmpeq (const void *__s1, const void *__s2, size_t __n)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 107 "/usr/include/string.h" 3 4
extern void *memchr (const void *__s, int __c, size_t __n)
      __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 141 "/usr/include/string.h" 3 4
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
# 246 "/usr/include/string.h" 3 4
extern char *strchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 273 "/usr/include/string.h" 3 4
extern char *strrchr (const char *__s, int __c)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 293 "/usr/include/string.h" 3 4
extern size_t strcspn (const char *__s, const char *__reject)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));


extern size_t strspn (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 323 "/usr/include/string.h" 3 4
extern char *strpbrk (const char *__s, const char *__accept)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
# 350 "/usr/include/string.h" 3 4
extern char *strstr (const char *__haystack, const char *__needle)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));




extern char *strtok (char *__restrict __s, const char *__restrict __delim)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));



extern char *__strtok_r (char *__restrict __s,
    const char *__restrict __delim,
    char **__restrict __save_ptr)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2, 3)));
# 407 "/usr/include/string.h" 3 4
extern size_t strlen (const char *__s)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
# 419 "/usr/include/string.h" 3 4
extern char *strerror (int __errnum) __attribute__ ((__nothrow__ , __leaf__));
# 552 "/usr/include/string.h" 3 4

# 38 "baseline/source/internal.h" 2

# 1 "baseline/source/shake.h" 1
# 41 "baseline/source/shake.h"
# 1 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 1 3 4
# 145 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 3 4
typedef long int ptrdiff_t;
# 42 "baseline/source/shake.h" 2
# 1 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stdint.h" 1 3 4
# 9 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stdint.h" 3 4
# 1 "/usr/include/stdint.h" 1 3 4
# 26 "/usr/include/stdint.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 27 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/types.h" 1 3 4
# 27 "/usr/include/x86_64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 28 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 1 3 4
# 19 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 2 3 4
# 29 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4


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
# 141 "/usr/include/x86_64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/typesizes.h" 1 3 4
# 142 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/time64.h" 1 3 4
# 143 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4


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
# 28 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wchar.h" 1 3 4
# 29 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 30 "/usr/include/stdint.h" 2 3 4




# 1 "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h" 1 3 4
# 24 "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h" 3 4
typedef __int8_t int8_t;
typedef __int16_t int16_t;
typedef __int32_t int32_t;
typedef __int64_t int64_t;
# 35 "/usr/include/stdint.h" 2 3 4


# 1 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h" 1 3 4
# 24 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h" 3 4
typedef __uint8_t uint8_t;
typedef __uint16_t uint16_t;
typedef __uint32_t uint32_t;
typedef __uint64_t uint64_t;
# 38 "/usr/include/stdint.h" 2 3 4



# 1 "/usr/include/x86_64-linux-gnu/bits/stdint-least.h" 1 3 4
# 25 "/usr/include/x86_64-linux-gnu/bits/stdint-least.h" 3 4
typedef __int_least8_t int_least8_t;
typedef __int_least16_t int_least16_t;
typedef __int_least32_t int_least32_t;
typedef __int_least64_t int_least64_t;


typedef __uint_least8_t uint_least8_t;
typedef __uint_least16_t uint_least16_t;
typedef __uint_least32_t uint_least32_t;
typedef __uint_least64_t uint_least64_t;
# 42 "/usr/include/stdint.h" 2 3 4





typedef signed char int_fast8_t;

typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
# 60 "/usr/include/stdint.h" 3 4
typedef unsigned char uint_fast8_t;

typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
# 76 "/usr/include/stdint.h" 3 4
typedef long int intptr_t;


typedef unsigned long int uintptr_t;
# 90 "/usr/include/stdint.h" 3 4
typedef __intmax_t intmax_t;
typedef __uintmax_t uintmax_t;
# 10 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stdint.h" 2 3 4
# 43 "baseline/source/shake.h" 2
# 81 "baseline/source/shake.h"

# 81 "baseline/source/shake.h"
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
# 40 "baseline/source/internal.h" 2
# 1 "baseline/source/falcon.h" 1
# 35 "baseline/source/falcon.h"
# 1 "/usr/lib/gcc/x86_64-linux-gnu/14/include/stddef.h" 1 3 4
# 36 "baseline/source/falcon.h" 2
# 84 "baseline/source/falcon.h"
typedef struct falcon_vrfy_ falcon_vrfy;







falcon_vrfy *falcon_vrfy_new(void);







void falcon_vrfy_free(falcon_vrfy *fv);
# 109 "baseline/source/falcon.h"
int falcon_vrfy_set_public_key(falcon_vrfy *fv,
 const void *pkey, size_t len);






void falcon_vrfy_start(falcon_vrfy *fv, const void *r, size_t rlen);






void falcon_vrfy_update(falcon_vrfy *fv, const void *data, size_t len);
# 136 "baseline/source/falcon.h"
int falcon_vrfy_verify(falcon_vrfy *fv, const void *sig, size_t len);
# 170 "baseline/source/falcon.h"
typedef struct falcon_sign_ falcon_sign;







falcon_sign *falcon_sign_new(void);







void falcon_sign_free(falcon_sign *fs);
# 210 "baseline/source/falcon.h"
void falcon_sign_set_seed(falcon_sign *fs,
 const void *seed, size_t len, int replace);
# 221 "baseline/source/falcon.h"
int falcon_sign_set_private_key(falcon_sign *fs,
 const void *skey, size_t len);
# 234 "baseline/source/falcon.h"
int falcon_sign_start(falcon_sign *fs, void *r );
# 244 "baseline/source/falcon.h"
void falcon_sign_start_external_nonce(falcon_sign *fs,
 const void *r, size_t rlen);






void falcon_sign_update(falcon_sign *fs, const void *data, size_t len);
# 274 "baseline/source/falcon.h"
size_t falcon_sign_generate(falcon_sign *fs,
 void *sig, size_t sig_max_len, int comp);
# 290 "baseline/source/falcon.h"
typedef struct falcon_keygen_ falcon_keygen;
# 307 "baseline/source/falcon.h"
falcon_keygen *falcon_keygen_new(unsigned logn, int ternary);






void falcon_keygen_free(falcon_keygen *fk);







size_t falcon_keygen_max_privkey_size(falcon_keygen *fk);






size_t falcon_keygen_max_pubkey_size(falcon_keygen *fk);
# 353 "baseline/source/falcon.h"
void falcon_keygen_set_seed(falcon_keygen *fk,
 const void *seed, size_t len, int replace);
# 376 "baseline/source/falcon.h"
int falcon_keygen_make(falcon_keygen *fk, int comp,
 void *privkey, size_t *privkey_len,
 void *pubkey, size_t *pubkey_len);
# 41 "baseline/source/internal.h" 2
# 85 "baseline/source/internal.h"
size_t falcon_encode_12289(void *out, size_t max_out_len,
 const uint16_t *x, unsigned logn);






size_t falcon_decode_12289(uint16_t *x, unsigned logn,
 const void *data, size_t len);
# 109 "baseline/source/internal.h"
size_t falcon_encode_18433(void *out, size_t max_out_len,
 const uint16_t *x, unsigned logn);
# 119 "baseline/source/internal.h"
size_t falcon_decode_18433(uint16_t *x, unsigned logn,
 const void *data, size_t len);
# 141 "baseline/source/internal.h"
size_t falcon_encode_small(void *out, size_t max_out_len,
 int comp, unsigned q, const int16_t *x, unsigned logn);






size_t falcon_decode_small(int16_t *x, unsigned logn,
 int comp, unsigned q, const void *data, size_t len);




void falcon_hash_to_point(shake_context *sc, unsigned q,
 uint16_t *x, unsigned logn);
# 171 "baseline/source/internal.h"
int falcon_is_short(const int16_t *s1, const int16_t *s2,
 unsigned logn, unsigned ter);
# 188 "baseline/source/internal.h"
int falcon_vrfy_verify_raw(const uint16_t *c0, const int16_t *s2,
 const uint16_t *h, unsigned logn, int ternary);







int falcon_compute_public(uint16_t *h,
 const int16_t *f, const int16_t *g, unsigned logn, int ternary);
# 208 "baseline/source/internal.h"
int falcon_complete_private(int16_t *G,
 const int16_t *f, const int16_t *g, const int16_t *F,
 unsigned logn, int ternary);
# 296 "baseline/source/internal.h"
# 1 "baseline/source/fpr-emulated.h" 1
# 14 "baseline/source/fpr-emulated.h"
# 1 "/usr/include/math.h" 1 3 4
# 27 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 28 "/usr/include/math.h" 2 3 4












# 1 "/usr/include/x86_64-linux-gnu/bits/math-vector.h" 1 3 4
# 25 "/usr/include/x86_64-linux-gnu/bits/math-vector.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libm-simd-decl-stubs.h" 1 3 4
# 26 "/usr/include/x86_64-linux-gnu/bits/math-vector.h" 2 3 4
# 41 "/usr/include/math.h" 2 3 4
# 156 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/flt-eval-method.h" 1 3 4
# 157 "/usr/include/math.h" 2 3 4
# 167 "/usr/include/math.h" 3 4

# 167 "/usr/include/math.h" 3 4
typedef float float_t;
typedef double double_t;
# 208 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/fp-logb.h" 1 3 4
# 209 "/usr/include/math.h" 2 3 4
# 251 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/fp-fast.h" 1 3 4
# 252 "/usr/include/math.h" 2 3 4
# 275 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-macros.h" 1 3 4
# 276 "/usr/include/math.h" 2 3 4





# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 3 4
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
# 282 "/usr/include/math.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 1 3 4
# 53 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double acos (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __acos (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double asin (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __asin (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double atan (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __atan (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double atan2 (double __y, double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __atan2 (double __y, double __x) __attribute__ ((__nothrow__ , __leaf__));


 extern double cos (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __cos (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double sin (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __sin (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double tan (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __tan (double __x) __attribute__ ((__nothrow__ , __leaf__));
# 89 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double cosh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __cosh (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double sinh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __sinh (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double tanh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __tanh (double __x) __attribute__ ((__nothrow__ , __leaf__));
# 103 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double acosh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __acosh (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double asinh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __asinh (double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern double atanh (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __atanh (double __x) __attribute__ ((__nothrow__ , __leaf__));





 extern double exp (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __exp (double __x) __attribute__ ((__nothrow__ , __leaf__));


extern double frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__)); extern double __frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__));


extern double ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__)); extern double __ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__));


 extern double log (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __log (double __x) __attribute__ ((__nothrow__ , __leaf__));


 extern double log10 (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __log10 (double __x) __attribute__ ((__nothrow__ , __leaf__));


extern double modf (double __x, double *__iptr) __attribute__ ((__nothrow__ , __leaf__)); extern double __modf (double __x, double *__iptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));
# 152 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
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
# 231 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double copysign (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));




extern double nan (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__)); extern double __nan (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__));
# 264 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double erf (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __erf (double) __attribute__ ((__nothrow__ , __leaf__));
 extern double erfc (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __erfc (double) __attribute__ ((__nothrow__ , __leaf__));
extern double lgamma (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __lgamma (double) __attribute__ ((__nothrow__ , __leaf__));




extern double tgamma (double) __attribute__ ((__nothrow__ , __leaf__)); extern double __tgamma (double) __attribute__ ((__nothrow__ , __leaf__));
# 292 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double rint (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern double __rint (double __x) __attribute__ ((__nothrow__ , __leaf__));


extern double nextafter (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __nextafter (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));

extern double nexttoward (double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __nexttoward (double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
# 308 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double remainder (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__)); extern double __remainder (double __x, double __y) __attribute__ ((__nothrow__ , __leaf__));



extern double scalbn (double __x, int __n) __attribute__ ((__nothrow__ , __leaf__)); extern double __scalbn (double __x, int __n) __attribute__ ((__nothrow__ , __leaf__));



extern int ilogb (double __x) __attribute__ ((__nothrow__ , __leaf__)); extern int __ilogb (double __x) __attribute__ ((__nothrow__ , __leaf__));
# 326 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
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
# 283 "/usr/include/math.h" 2 3 4
# 298 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 3 4
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
# 299 "/usr/include/math.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 1 3 4
# 53 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float acosf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __acosf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float asinf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __asinf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float atanf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __atanf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float atan2f (float __y, float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __atan2f (float __y, float __x) __attribute__ ((__nothrow__ , __leaf__));


 extern float cosf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __cosf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float sinf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __sinf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float tanf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __tanf (float __x) __attribute__ ((__nothrow__ , __leaf__));
# 89 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float coshf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __coshf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float sinhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __sinhf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float tanhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __tanhf (float __x) __attribute__ ((__nothrow__ , __leaf__));
# 103 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float acoshf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __acoshf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float asinhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __asinhf (float __x) __attribute__ ((__nothrow__ , __leaf__));

 extern float atanhf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __atanhf (float __x) __attribute__ ((__nothrow__ , __leaf__));





 extern float expf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __expf (float __x) __attribute__ ((__nothrow__ , __leaf__));


extern float frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__)); extern float __frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__));


extern float ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__)); extern float __ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__));


 extern float logf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __logf (float __x) __attribute__ ((__nothrow__ , __leaf__));


 extern float log10f (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __log10f (float __x) __attribute__ ((__nothrow__ , __leaf__));


extern float modff (float __x, float *__iptr) __attribute__ ((__nothrow__ , __leaf__)); extern float __modff (float __x, float *__iptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));
# 152 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
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
# 231 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern float copysignf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));




extern float nanf (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__)); extern float __nanf (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__));
# 264 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float erff (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __erff (float) __attribute__ ((__nothrow__ , __leaf__));
 extern float erfcf (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __erfcf (float) __attribute__ ((__nothrow__ , __leaf__));
extern float lgammaf (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __lgammaf (float) __attribute__ ((__nothrow__ , __leaf__));




extern float tgammaf (float) __attribute__ ((__nothrow__ , __leaf__)); extern float __tgammaf (float) __attribute__ ((__nothrow__ , __leaf__));
# 292 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern float rintf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern float __rintf (float __x) __attribute__ ((__nothrow__ , __leaf__));


extern float nextafterf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __nextafterf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));

extern float nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __nexttowardf (float __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
# 308 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern float remainderf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__)); extern float __remainderf (float __x, float __y) __attribute__ ((__nothrow__ , __leaf__));



extern float scalbnf (float __x, int __n) __attribute__ ((__nothrow__ , __leaf__)); extern float __scalbnf (float __x, int __n) __attribute__ ((__nothrow__ , __leaf__));



extern int ilogbf (float __x) __attribute__ ((__nothrow__ , __leaf__)); extern int __ilogbf (float __x) __attribute__ ((__nothrow__ , __leaf__));
# 326 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
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
# 300 "/usr/include/math.h" 2 3 4
# 367 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 3 4
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
# 368 "/usr/include/math.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 1 3 4
# 53 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double acosl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __acosl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double asinl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __asinl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double atanl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __atanl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double atan2l (long double __y, long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __atan2l (long double __y, long double __x) __attribute__ ((__nothrow__ , __leaf__));


 extern long double cosl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __cosl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double sinl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __sinl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double tanl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __tanl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
# 89 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double coshl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __coshl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double sinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __sinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double tanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __tanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
# 103 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double acoshl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __acoshl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double asinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __asinhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));

 extern long double atanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __atanhl (long double __x) __attribute__ ((__nothrow__ , __leaf__));





 extern long double expl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __expl (long double __x) __attribute__ ((__nothrow__ , __leaf__));


extern long double frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__)); extern long double __frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__ , __leaf__));


extern long double ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__)); extern long double __ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__ , __leaf__));


 extern long double logl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __logl (long double __x) __attribute__ ((__nothrow__ , __leaf__));


 extern long double log10l (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __log10l (long double __x) __attribute__ ((__nothrow__ , __leaf__));


extern long double modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__ , __leaf__)); extern long double __modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__nonnull__ (2)));
# 152 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
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
# 231 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern long double copysignl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__const__));




extern long double nanl (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__)); extern long double __nanl (const char *__tagb) __attribute__ ((__nothrow__ , __leaf__));
# 264 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double erfl (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __erfl (long double) __attribute__ ((__nothrow__ , __leaf__));
 extern long double erfcl (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __erfcl (long double) __attribute__ ((__nothrow__ , __leaf__));
extern long double lgammal (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __lgammal (long double) __attribute__ ((__nothrow__ , __leaf__));




extern long double tgammal (long double) __attribute__ ((__nothrow__ , __leaf__)); extern long double __tgammal (long double) __attribute__ ((__nothrow__ , __leaf__));
# 292 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern long double rintl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern long double __rintl (long double __x) __attribute__ ((__nothrow__ , __leaf__));


extern long double nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));

extern long double nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __nexttowardl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));
# 308 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern long double remainderl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__)); extern long double __remainderl (long double __x, long double __y) __attribute__ ((__nothrow__ , __leaf__));



extern long double scalbnl (long double __x, int __n) __attribute__ ((__nothrow__ , __leaf__)); extern long double __scalbnl (long double __x, int __n) __attribute__ ((__nothrow__ , __leaf__));



extern int ilogbl (long double __x) __attribute__ ((__nothrow__ , __leaf__)); extern int __ilogbl (long double __x) __attribute__ ((__nothrow__ , __leaf__));
# 326 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
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
# 369 "/usr/include/math.h" 2 3 4
# 450 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 3 4
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
# 451 "/usr/include/math.h" 2 3 4
# 903 "/usr/include/math.h" 3 4
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
# 1441 "/usr/include/math.h" 3 4

# 15 "baseline/source/fpr-emulated.h" 2


# 16 "baseline/source/fpr-emulated.h"
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
 uint64_t t;
 int64_t xi;
 int e, cc;

 e = (int)(x >> 52) & 0x7FF;
 t = x >> 63;
 xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
  & (((uint64_t)1 << 63) - 1));
 xi = (xi ^ -(int64_t)t) + (int64_t)t;
 cc = 1085 - e;
 xi = fpr_irsh(xi, cc & 63);
 xi ^= (xi ^ -(int64_t)t) & -(int64_t)((uint32_t)(63 - cc) >> 31);
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
# 297 "baseline/source/internal.h" 2
# 316 "baseline/source/internal.h"
void falcon_FFT(fpr *f, unsigned logn);
# 326 "baseline/source/internal.h"
void falcon_iFFT(fpr *f, unsigned logn);





void falcon_poly_add(fpr *restrict a, const fpr *restrict b, unsigned logn);
# 344 "baseline/source/internal.h"
void falcon_poly_addconst(fpr *a, fpr x, unsigned logn);





void falcon_poly_addconst_fft(fpr *a, fpr x, unsigned logn);





void falcon_poly_sub(fpr *restrict a, const fpr *restrict b, unsigned logn);
# 367 "baseline/source/internal.h"
void falcon_poly_neg(fpr *a, unsigned logn);
# 378 "baseline/source/internal.h"
void falcon_poly_adj(fpr *a, unsigned logn);




void falcon_poly_adj_fft(fpr *a, unsigned logn);
# 396 "baseline/source/internal.h"
void falcon_poly_mul_fft(fpr *restrict a, const fpr *restrict b, unsigned logn);
# 408 "baseline/source/internal.h"
void falcon_poly_sqr_fft(fpr *a, unsigned logn);





void falcon_poly_muladj_fft(fpr *restrict a,
 const fpr *restrict b, unsigned logn);





void falcon_poly_mulselfadj_fft(fpr *a, unsigned logn);





void falcon_poly_mulconst(fpr *a, fpr x, unsigned logn);
# 438 "baseline/source/internal.h"
void falcon_poly_inv_fft(fpr *a, unsigned logn);





void falcon_poly_div_fft(fpr *restrict a, const fpr *restrict b, unsigned logn);





void falcon_poly_divadj_fft(fpr *restrict a,
 const fpr *restrict b, unsigned logn);
# 461 "baseline/source/internal.h"
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
# 529 "baseline/source/internal.h"
void falcon_FFT3(fpr *f, unsigned logn, unsigned full);
# 540 "baseline/source/internal.h"
void falcon_iFFT3(fpr *f, unsigned logn, unsigned full);





void falcon_poly_add3(fpr *restrict a, const fpr *restrict b,
 unsigned logn, unsigned full);
# 559 "baseline/source/internal.h"
void falcon_poly_addconst3(fpr *a, fpr x, unsigned logn, unsigned full);





void falcon_poly_addconst_fft3(fpr *a, fpr x, unsigned logn, unsigned full);





void falcon_poly_sub3(fpr *restrict a, const fpr *restrict b,
 unsigned logn, unsigned full);
# 583 "baseline/source/internal.h"
void falcon_poly_neg3(fpr *a, unsigned logn, unsigned full);
# 593 "baseline/source/internal.h"
void falcon_poly_adj_fft3(fpr *a, unsigned logn, unsigned full);
# 607 "baseline/source/internal.h"
void falcon_poly_mul_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
# 621 "baseline/source/internal.h"
void falcon_poly_sqr_fft3(fpr *a, unsigned logn, unsigned full);





void falcon_poly_muladj_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);





void falcon_poly_mulselfadj_fft3(fpr *a, unsigned logn, unsigned full);





void falcon_poly_mulconst3(fpr *a, fpr x, unsigned logn, unsigned full);
# 651 "baseline/source/internal.h"
void falcon_poly_inv_fft3(fpr *a, unsigned logn, unsigned full);





void falcon_poly_div_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);





void falcon_poly_divadj_fft3(fpr *restrict a,
 const fpr *restrict b, unsigned logn, unsigned full);
# 675 "baseline/source/internal.h"
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
# 714 "baseline/source/internal.h"
void falcon_poly_split_top_fft3(
 fpr *restrict f0, fpr *restrict f1, fpr *restrict f2,
 const fpr *restrict f, unsigned logn);
# 726 "baseline/source/internal.h"
void falcon_poly_split_deep_fft3(fpr *restrict f0, fpr *restrict f1,
 const fpr *restrict f, unsigned logn);





void falcon_poly_merge_top_fft3(fpr *restrict f,
 const fpr *restrict f0, const fpr *restrict f1, const fpr *restrict f2,
 unsigned logn);





void falcon_poly_merge_deep_fft3(fpr *restrict f,
 const fpr *restrict f0, const fpr *restrict f1, unsigned logn);
# 757 "baseline/source/internal.h"
int falcon_get_seed(void *seed, size_t seed_len);
# 767 "baseline/source/internal.h"
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
# 797 "baseline/source/internal.h"
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
# 851 "baseline/source/internal.h"
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
# 33 "baseline/source/falcon-sign.c" 2
# 117 "baseline/source/falcon-sign.c"
# 1 "baseline/source/ft1536-adaptive-cdf-tables.h" 1
# 15 "baseline/source/ft1536-adaptive-cdf-tables.h"
static const uint16_t
ft_adaptive_cdf_nominal_variance[5] = {
 5u, 20u, 80u, 320u, 768u
};

static const uint64_t
ft_adaptive_cdf_inv_2sigma0_sq_bits[5] = {
 0x3fb999999999999aUL, 0x3f9999999999999aUL, 0x3f7999999999999aUL, 0x3f5999999999999aUL, 0x3f45555555555555UL
};

static const uint64_t
ft_adaptive_cdf[5]
[512][2] = {

 {
  { 12861045783025194338u, 12252846954397398268u },
  { 7806896963754487748u, 10129021331992920674u },
  { 4062691428401757708u, 15009104145105922937u },
  { 1791715974944572614u, 1131232196543415969u },
  { 663982939486702418u, 10160953296563491616u },
  { 205480902982363162u, 12929462529601554840u },
  { 52858833213387332u, 16624293526215542351u },
  { 11264466882686183u, 6402942527299198922u },
  { 1983509262044379u, 528584377842064364u },
  { 288031217321451u, 3323640802786710131u },
  { 34440907249949u, 14891117231725159281u },
  { 3387143639027u, 10460940179961012124u },
  { 273729206155u, 4154952407859878138u },
  { 18164586717u, 5025769011716514427u },
  { 989235429u, 14864629377703894473u },
  { 44192296u, 6814955709367163543u },
  { 1618856u, 18089287533554113204u },
  { 48613u, 12706079518862937421u },
  { 1196u, 8301927825880451400u },
  { 24u, 2373930578663425549u },
  { 0u, 7354088428325324242u },
  { 0u, 99537325746473300u },
  { 0u, 1103521004104849u },
  { 0u, 10020207975859u },
  { 0u, 74515224141u },
  { 0u, 453796867u },
  { 0u, 2263115u },
  { 0u, 9242u },
  { 0u, 31u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
 },

 {
  { 15425160025535684910u, 15009123207525132744u },
  { 12478179153325017678u, 7431689668279310431u },
  { 9744136844796733656u, 6099097060328714098u },
  { 7331352975985286279u, 7638439653485460598u },
  { 5305924617712826635u, 17557425575242719382u },
  { 3688587223697089370u, 16799894838802821779u },
  { 2460102825353418410u, 12691388226791720984u },
  { 1572489244027592596u, 10370973629550282719u },
  { 962441945873093836u, 15444102649843163367u },
  { 563611454839583318u, 8582801130833214415u },
  { 315584732403236953u, 10685569075868380012u },
  { 168863194239697174u, 12023323799228676542u },
  { 86302270356227783u, 892129302104811908u },
  { 42110592298514338u, 10610302201719188249u },
  { 19610115678007791u, 16734139402055863295u },
  { 8712582037490748u, 6211560136626546902u },
  { 3692047085741121u, 15126139469351401997u },
  { 1491872988991110u, 1193648627099954367u },
  { 574703971375562u, 4775509138714396746u },
  { 211017639288851u, 18010225540434755401u },
  { 73837935730313u, 15864960441338101768u },
  { 24618342968074u, 2708690906234567796u },
  { 7819806441492u, 12889180655363909128u },
  { 2366120110128u, 12356226121575214740u },
  { 681918261738u, 6094648388007837006u },
  { 187170999874u, 9980515139773345144u },
  { 48923293467u, 963726982674711791u },
  { 12176644016u, 12627998322424548438u },
  { 2885636022u, 8760224084796948804u },
  { 651069968u, 2418427164677120435u },
  { 139848790u, 13279178921321801904u },
  { 28596297u, 14752664176117079761u },
  { 5566191u, 9420231496765493604u },
  { 1031294u, 12934119240913770261u },
  { 181871u, 8035988793249604396u },
  { 30527u, 1847732285243861385u },
  { 4876u, 13652966102839220832u },
  { 741u, 8292042617070591979u },
  { 107u, 5204881337291465740u },
  { 14u, 14250372621042914452u },
  { 1u, 17261629291838392740u },
  { 0u, 4452704326664921662u },
  { 0u, 528354183233036624u },
  { 0u, 59657397085039772u },
  { 0u, 6409620579345062u },
  { 0u, 655270824330326u },
  { 0u, 63741459459463u },
  { 0u, 5899680904883u },
  { 0u, 519557417592u },
  { 0u, 43534211222u },
  { 0u, 3470674742u },
  { 0u, 263255608u },
  { 0u, 18998379u },
  { 0u, 1304445u },
  { 0u, 85212u },
  { 0u, 5296u },
  { 0u, 313u },
  { 0u, 18u },
  { 0u, 1u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
 },

 {
  { 16871443326712168131u, 12180455140806270948u },
  { 15305957505789925130u, 5640603969068712604u },
  { 13769551072817740308u, 808824660875537233u },
  { 12280414896317847271u, 11820216274906728921u },
  { 10855023835774616412u, 6643822227615715586u },
  { 9507597702726512226u, 3954371237875415309u },
  { 8249694506825339503u, 5139244116674995860u },
  { 7089954086467265050u, 13358755099922907374u },
  { 6033998417220001997u, 18146255347154342712u },
  { 5084483269485260468u, 14781905888604716158u },
  { 4241285541300408586u, 2319215863189622710u },
  { 3501802400706431213u, 2535803808687359933u },
  { 2861332912010593433u, 15486384835473068106u },
  { 2313510327571634514u, 3449598710846216162u },
  { 1850753602815739783u, 1279788645692094637u },
  { 1464709552282681241u, 4631908547858267796u },
  { 1146661816669529927u, 16716634470198719569u },
  { 887888750944425467u, 6682461457288373454u },
  { 679958751171581064u, 8286180834781903350u },
  { 514957759583783055u, 15857344255772006289u },
  { 385649199934276106u, 7493303825524552426u },
  { 285571039653290305u, 2619219310023198758u },
  { 209077867534078181u, 10591436833828086035u },
  { 151337791936735470u, 3799774517928043585u },
  { 108294711554766332u, 11015611833391451159u },
  { 76606286197995909u, 11913526149199890374u },
  { 53566985504885385u, 12815750115243840708u },
  { 37024176875176693u, 14004031863148336364u },
  { 25293569000971513u, 8343482415093642660u },
  { 17078653352024472u, 654072693283661313u },
  { 11397231749765667u, 9048440913506541350u },
  { 7516780363614337u, 17591355447460861160u },
  { 4899327950004504u, 5475473609801618395u },
  { 3155728748357890u, 15481858552985819169u },
  { 2008669509602222u, 4544799471672693723u },
  { 1263429175484580u, 15494160176028784610u },
  { 785263744526000u, 8745159226220012927u },
  { 482271635458820u, 11568472227381693704u },
  { 292664018568209u, 4390947671336579390u },
  { 175484540208930u, 4708029167400035434u },
  { 103965996940459u, 3050179058884905135u },
  { 60858075924886u, 9160112435413466504u },
  { 35197475389176u, 8455939218226418562u },
  { 20112386540125u, 9027250889036438903u },
  { 11354481177612u, 3283705957058491652u },
  { 6333091304746u, 14142171981231377504u },
  { 3489815719915u, 16564313239891689594u },
  { 1899859052779u, 1834311012578470355u },
  { 1021801587699u, 14253536396840267095u },
  { 542915842366u, 17584442205329835563u },
  { 284979700673u, 6263127660289298833u },
  { 147776637487u, 9580755171526530712u },
  { 75701291674u, 14366009081234189967u },
  { 38309094854u, 18230812650166320029u },
  { 19151254660u, 11144996910560457194u },
  { 9457691810u, 16956439728221184917u },
  { 4613831239u, 12529093080183912734u },
  { 2223428071u, 3131246559802990542u },
  { 1058438609u, 3418716178553875155u },
  { 497721049u, 5307841303745579646u },
  { 231196243u, 2837946150732794247u },
  { 106083244u, 3981900449803623443u },
  { 48081834u, 4135761907339548123u },
  { 21526853u, 12916873139858773687u },
  { 9520123u, 14126435122741219692u },
  { 4158765u, 12222612276801306418u },
  { 1794500u, 6594273466572622439u },
  { 764852u, 436677670987471458u },
  { 322005u, 14638585330608030243u },
  { 133906u, 136597609063833792u },
  { 55002u, 13708137208589681808u },
  { 22315u, 16630060457235422026u },
  { 8943u, 1920481891807669858u },
  { 3540u, 102069696834344077u },
  { 1384u, 1376859271941524374u },
  { 534u, 9347522987661658718u },
  { 203u, 16307282229315901408u },
  { 76u, 15040006537323293899u },
  { 28u, 10800240884792184390u },
  { 10u, 9350673605148682380u },
  { 3u, 15024234790228745895u },
  { 1u, 6784629327128576243u },
  { 0u, 8936252034079364217u },
  { 0u, 3126047579509823670u },
  { 0u, 1080090355131528408u },
  { 0u, 368593470205377657u },
  { 0u, 124238725951138998u },
  { 0u, 41360610552049655u },
  { 0u, 13599919216633939u },
  { 0u, 4416762271296861u },
  { 0u, 1416736019160214u },
  { 0u, 448838398091787u },
  { 0u, 140444974147441u },
  { 0u, 43404677817068u },
  { 0u, 13248906701002u },
  { 0u, 3994254938825u },
  { 0u, 1189331291711u },
  { 0u, 349768225440u },
  { 0u, 101593857086u },
  { 0u, 29144949006u },
  { 0u, 8257852060u },
  { 0u, 2310883540u },
  { 0u, 638697799u },
  { 0u, 174348589u },
  { 0u, 47005253u },
  { 0u, 12516375u },
  { 0u, 3291655u },
  { 0u, 854974u },
  { 0u, 219328u },
  { 0u, 55569u },
  { 0u, 13905u },
  { 0u, 3437u },
  { 0u, 839u },
  { 0u, 202u },
  { 0u, 48u },
  { 0u, 11u },
  { 0u, 3u },
  { 0u, 1u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
 },

 {
  { 17641911074100443335u, 10341896189161377996u },
  { 16838334644102565781u, 7535171075961544893u },
  { 16038516164044123395u, 4288111913028101275u },
  { 15244921920778094001u, 6928789251525602430u },
  { 14459960318731835504u, 7253020379803916392u },
  { 13685959987145853142u, 676099967218907246u },
  { 12925149114654825189u, 2092757125138988827u },
  { 12179636315957141937u, 6161014783674436141u },
  { 11451393302640699944u, 8982267094805765028u },
  { 10742239592177586054u, 8590996572297028133u },
  { 10053829446699118662u, 17797586834436613443u },
  { 9387641187547424035u, 12873349421349822273u },
  { 8744968983966791718u, 992346722856316236u },
  { 8126917165870249065u, 253120757395280289u },
  { 7534397062604997742u, 16886104411174834283u },
  { 6968126323206809970u, 8403993841030165546u },
  { 6428630629857830852u, 10138022770471099497u },
  { 5916247676111460903u, 7341914687190478027u },
  { 5431133245751258116u, 2880001640994933977u },
  { 4973269197579876640u, 15686037084702223665u },
  { 4542473136489881442u, 11071337374797628473u },
  { 4138409532173793310u, 12696716278058626220u },
  { 3760602033930028881u, 3780888646077716732u },
  { 3408446723184898219u, 11815732681146257384u },
  { 3081226044385817344u, 7215963122669730879u },
  { 2778123159487038519u, 2858704600948609450u },
  { 2498236480877881711u, 10700262696563652360u },
  { 2240594151720182865u, 310026182652092118u },
  { 2004168260610520448u, 1713152583111850015u },
  { 1787888598551759090u, 17813969350530602065u },
  { 1590655789664956890u, 2823466936251217360u },
  { 1411353652148026974u, 13377262024234012443u },
  { 1248860671959754169u, 16091869269581609526u },
  { 1102060497882026277u, 11964487764775235243u },
  { 969851392349286581u, 2767272119963007294u },
  { 851154597160954631u, 9064610581836295777u },
  { 744921596418158992u, 14974390632305919624u },
  { 650140280345515946u, 9243183534179943581u },
  { 565840032757107175u, 618396950109475226u },
  { 491095781579126120u, 9786268025971163033u },
  { 425031065913744136u, 17494645272877113482u },
  { 366820184566246716u, 13699813328598855163u },
  { 315689499782510811u, 3553957000497427266u },
  { 270917976245019886u, 10558264042578854934u },
  { 231837039297794812u, 2392325534005611644u },
  { 197829838104406179u, 9424309393868970831u },
  { 168329999213805313u, 6115487293663830463u },
  { 142819954065106728u, 8996280684997188009u },
  { 120828920567365536u, 2711597205929474674u },
  { 101930614310796361u, 18062112593081990906u },
  { 85740759464735511u, 9471740830401342148u },
  { 71914463246809399u, 14470748940574265765u },
  { 60143511242199483u, 189571979140531794u },
  { 50153634025189938u, 4672088886844510272u },
  { 41701788676430001u, 18128001871856760645u },
  { 34573492061157342u, 687743295752624304u },
  { 28580236271346901u, 10636527079835213238u },
  { 23557010546582040u, 3354408103921960753u },
  { 19359948356470075u, 16453312076331259257u },
  { 15864113209252943u, 2706727913098858531u },
  { 12961432182213771u, 4590105828113170008u },
  { 10558782165110776u, 240141886391857420u },
  { 8576230366727934u, 4064591324444260618u },
  { 6945427741085087u, 9117914249594935128u },
  { 5608151616894179u, 13361674141162117039u },
  { 4514991925798225u, 5283111291958784277u },
  { 3624173979922128u, 4998701690002624519u },
  { 2900509701519952u, 14393870494493967708u },
  { 2314468509311593u, 15143701456127549898u },
  { 1841358669514457u, 10816174911998976721u },
  { 1460609777799121u, 2225063088041568192u },
  { 1155147106895564u, 846911659099438809u },
  { 910848791896786u, 11070458862473022819u },
  { 716077193659101u, 8804738818282811598u },
  { 561276246307786u, 17008720756904137598u },
  { 438627128124641u, 6619620235305833875u },
  { 341755170600546u, 9761340865637070973u },
  { 265481516813836u, 2439057546253820645u },
  { 205613640003462u, 7129286363170169269u },
  { 158769422234684u, 1877200100723405000u },
  { 122230060581900u, 11218267259594600233u },
  { 93817606274881u, 4630016512270352798u },
  { 71793445209760u, 3834012012296484462u },
  { 54774492625225u, 11568550161395329730u },
  { 41664298816017u, 2598307703133434935u },
  { 31596646118731u, 4390327493364000707u },
  { 23889560769541u, 4330591657821355769u },
  { 18007968137780u, 1546995525409178906u },
  { 13533488419136u, 4500807734978744454u },
  { 10140104665506u, 7016636355820291482u },
  { 7574638813167u, 16828611341137804331u },
  { 5641147032628u, 12287975599404162339u },
  { 4188496151826u, 906025866711955763u },
  { 3100510913118u, 7110811217446997227u },
  { 2288190093681u, 12060687515666912685u },
  { 1683580554460u, 15638762347042798532u },
  { 1234974391608u, 8859498032441229577u },
  { 903157641190u, 12069401011525358586u },
  { 658491312160u, 9844777147002861433u },
  { 478648561800u, 12164986143557311274u },
  { 346867047050u, 3389442258503196811u },
  { 250604159583u, 14265296995923659703u },
  { 180506082686u, 8673557998878562106u },
  { 129620335927u, 10193526460116562290u },
  { 92796499667u, 2646957671988141103u },
  { 66231810474u, 5902926610326712040u },
  { 47127855889u, 4830889632550436722u },
  { 33432142946u, 13674728909972124035u },
  { 23644258303u, 13253199119023178324u },
  { 16670998124u, 4357070803336442944u },
  { 11718483958u, 4398768440241907218u },
  { 8212108538u, 10836835640758424129u },
  { 5737343741u, 12213280589326165009u },
  { 3996129238u, 12690707079364862520u },
  { 2774854281u, 8764506444258101413u },
  { 1920933746u, 11381268583983522457u },
  { 1325731868u, 9340529765492698448u },
  { 912157173u, 9943670965771047982u },
  { 625682354u, 18149590655658955650u },
  { 427866190u, 2882213804920418337u },
  { 291696662u, 2714804760131381581u },
  { 198254922u, 5369594252493235641u },
  { 134333750u, 2737163164571410405u },
  { 90743298u, 7720628985159948u },
  { 61109941u, 7420085667817029067u },
  { 41027655u, 5206084983417326955u },
  { 27460516u, 190056397188214299u },
  { 18323460u, 16030678518100191967u },
  { 12189132u, 4462428889213553009u },
  { 8083588u, 13285276980386340489u },
  { 5344430u, 9999006458066322903u },
  { 3522606u, 11951027973090631308u },
  { 2314685u, 13312056995414434781u },
  { 1516298u, 13671053800153325064u },
  { 990243u, 12235688248591462981u },
  { 644708u, 15566822538609648647u },
  { 418455u, 6903343482226220699u },
  { 270768u, 11675002937783998437u },
  { 174667u, 690697186919888851u },
  { 112327u, 12025223536599459772u },
  { 72015u, 7023178291621539998u },
  { 46028u, 8458932702488427837u },
  { 29328u, 9321962987974254257u },
  { 18630u, 2097130244581090578u },
  { 11797u, 15696557065593419048u },
  { 7448u, 3863772101954001486u },
  { 4687u, 13387829798827843554u },
  { 2941u, 4820630559784600515u },
  { 1839u, 14388801121225322420u },
  { 1147u, 4648582368713951495u },
  { 713u, 3714538655551607253u },
  { 442u, 64507155256642058u },
  { 273u, 1583974037076538693u },
  { 168u, 3735947909229182857u },
  { 103u, 5205155599879252169u },
  { 63u, 4120248968739402103u },
  { 38u, 10742868887630853663u },
  { 23u, 8715978998089320516u },
  { 14u, 4353635674362204931u },
  { 8u, 11206007193069499264u },
  { 5u, 3472842487682484676u },
  { 3u, 2170109832489425343u },
  { 1u, 16004761004537476338u },
  { 1u, 2127708473598745114u },
  { 0u, 12249152484066016502u },
  { 0u, 7270115085712485297u },
  { 0u, 4301637930841198179u },
  { 0u, 2537368686383943501u },
  { 0u, 1492073752634354031u },
  { 0u, 874689344402943664u },
  { 0u, 511180234666832065u },
  { 0u, 297817892396848909u },
  { 0u, 172975215744971419u },
  { 0u, 100155127262463852u },
  { 0u, 57812074771859215u },
  { 0u, 33267475089646622u },
  { 0u, 19084329095910657u },
  { 0u, 10914141600757013u },
  { 0u, 6222397650095932u },
  { 0u, 3536562136422496u },
  { 0u, 2003826160758530u },
  { 0u, 1131863034325769u },
  { 0u, 637356860083273u },
  { 0u, 357788417745611u },
  { 0u, 200227897999813u },
  { 0u, 111706249597682u },
  { 0u, 62127632354342u },
  { 0u, 34446608007524u },
  { 0u, 19039797740259u },
  { 0u, 10491372044756u },
  { 0u, 5763100854453u },
  { 0u, 3155978317718u },
  { 0u, 1722921730343u },
  { 0u, 937671512532u },
  { 0u, 508732427550u },
  { 0u, 275157616485u },
  { 0u, 148363465153u },
  { 0u, 79749065801u },
  { 0u, 42734373768u },
  { 0u, 22828747560u },
  { 0u, 12157372637u },
  { 0u, 6454315244u },
  { 0u, 3415964299u },
  { 0u, 1802308293u },
  { 0u, 947976022u },
  { 0u, 497070562u },
  { 0u, 259831058u },
  { 0u, 135399268u },
  { 0u, 70338600u },
  { 0u, 36426981u },
  { 0u, 18806354u },
  { 0u, 9679166u },
  { 0u, 4966187u },
  { 0u, 2540153u },
  { 0u, 1295234u },
  { 0u, 658398u },
  { 0u, 333641u },
  { 0u, 168548u },
  { 0u, 84882u },
  { 0u, 42615u },
  { 0u, 21328u },
  { 0u, 10642u },
  { 0u, 5293u },
  { 0u, 2625u },
  { 0u, 1297u },
  { 0u, 639u },
  { 0u, 314u },
  { 0u, 154u },
  { 0u, 75u },
  { 0u, 37u },
  { 0u, 18u },
  { 0u, 9u },
  { 0u, 4u },
  { 0u, 2u },
  { 0u, 1u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
 },

 {
  { 17923177608791436565u, 1856879543224439531u },
  { 17399951896523130235u, 14697716415193149543u },
  { 16877747112149656428u, 1544424865956070197u },
  { 16357239449401141510u, 3449151401204498800u },
  { 15839098494900458299u, 8344424996771080457u },
  { 15323984645422693712u, 13033521411235832838u },
  { 14812546584601391017u, 13669051427848916178u },
  { 14305418835138391526u, 1800773155638938727u },
  { 13803219401893034104u, 8062820180986817658u },
  { 13306547520410359004u, 7573996989988472996u },
  { 12815981524506223273u, 17421131056428515997u },
  { 12332076845470676697u, 4988090017321982721u },
  { 11855364154291616799u, 9082402333538420614u },
  { 11386347657051756859u, 3213166128369732055u },
  { 10925503552327309693u, 7244958247682784880u },
  { 10473278658031217705u, 3039924504011476739u },
  { 10030089213712450491u, 10972697860006584721u },
  { 9596319862861344613u, 10627170361399614026u },
  { 9172322818294766078u, 13683333321635310437u },
  { 8758417212219513239u, 8685091962280839793u },
  { 8354888631113015988u, 13412746417010693659u },
  { 7961988834131698521u, 587307186275433468u },
  { 7579935652373354015u, 11092894201676976444u },
  { 7208913064993686652u, 4139601535578720123u },
  { 6849071446920976504u, 8104379531402894524u },
  { 6500527981737662737u, 17005048587514248490u },
  { 6163367232213334263u, 3419272271295886816u },
  { 5837641859988654318u, 17116406751282283483u },
  { 5523373485031221344u, 2451779378930526358u },
  { 5220553674717934273u, 5750985781434919278u },
  { 4929145051748266808u, 10911712506925236928u },
  { 4649082509561666994u, 16642786565471186286u },
  { 4380274523521329692u, 5850470123980512437u },
  { 4122604545835659318u, 4146995604373451212u },
  { 3875932472016296579u, 14475237375662952185u },
  { 3640096166614774321u, 14666682674186240957u },
  { 3414913036034629858u, 12212146401980278205u },
  { 3200181636376957731u, 15416965897147603093u },
  { 2995683304538760820u, 11198191974238253409u },
  { 2801183801137992990u, 7986349419078318146u },
  { 2616434954279075839u, 5757245521888367802u },
  { 2441176293689490450u, 13677398606402933453u },
  { 2275136665342884783u, 7281060301266975971u },
  { 2118035817327744285u, 14632128990514918586u },
  { 1969585948413581030u, 13021678064901656406u },
  { 1829493211499256789u, 5916928760221340842u },
  { 1697459164890962872u, 682754441269900108u },
  { 1573182165141190246u, 570602227007834952u },
  { 1456358695975663957u, 5070065337516521655u },
  { 1346684628633983076u, 2278239388324147863u },
  { 1243856409743357403u, 16967601906446129451u },
  { 1147572173625658086u, 1451069575138029612u },
  { 1057532776698896691u, 13282487920505200726u },
  { 973442752368767813u, 5770320683581856888u },
  { 895011185508282423u, 8976705953085554449u },
  { 821952506288757650u, 11984207271092291847u },
  { 753987203749230828u, 4419788503815072224u },
  { 690842460070197814u, 859853964679961637u },
  { 632252707048647458u, 6300537188682210702u },
  { 577960106752614157u, 8449334116638624191u },
  { 527714958763541732u, 15525240536952731186u },
  { 481276036792960062u, 17167032865707520518u },
  { 438410857786270092u, 7753847625188944461u },
  { 398895886901350651u, 2176517930861818246u },
  { 362516681974318167u, 11781430030916586294u },
  { 329067981260649163u, 15659395168893254069u },
  { 298353738369005521u, 283389186384310661u },
  { 270187108389845113u, 7688196445538605774u },
  { 244390389263929313u, 9587818161526509569u },
  { 220794922440082375u, 1236474729379543677u },
  { 199240956840141604u, 14401233190176062979u },
  { 179577480085229809u, 931907826222844675u },
  { 161662020844641000u, 9640941540549691157u },
  { 145360426050155674u, 4049712570152321241u },
  { 130546616577886957u, 9229787259162311212u },
  { 117102324840150668u, 5856204464001608818u },
  { 104916817554613619u, 5575546462615743001u },
  { 93886606770250993u, 10029003159793261126u },
  { 83915152032435229u, 17506689487721213908u },
  { 74912556365615969u, 14350009120985189000u },
  { 66795258544174663u, 10588970878595408042u },
  { 59485723912585894u, 2340818770183942706u },
  { 52912135807213029u, 7665290700263860780u },
  { 47008089425909518u, 5783492071408710467u },
  { 41712289789865166u, 15979575238534815003u },
  { 36968255246380583u, 17357546245155965835u },
  { 32724027772802675u, 913018483906103502u },
  { 28931891161824001u, 6198160498380837107u },
  { 25548097997646021u, 18434937471926477812u },
  { 22532606171840501u, 13294972481468752207u },
  { 19848825537639067u, 3190638843336242386u },
  { 17463375162190061u, 13317883146933054955u },
  { 15345851508238159u, 4858825432585157317u },
  { 13468607759755656u, 8502067917278690252u },
  { 11806544400206292u, 406701124664913531u },
  { 10336911057160596u, 8090275915984987390u },
  { 9039119542615307u, 13616760691343198248u },
  { 7894567944223473u, 7782040502513720679u },
  { 6886475558271801u, 9879996654437722947u },
  { 5999728400146501u, 3523732881658969020u },
  { 5220734981663364u, 12159507519647149309u },
  { 4537292006425283u, 1823006849750198522u },
  { 3938459603712662u, 7114227820269969750u },
  { 3414445697699854u, 6037489413883627267u },
  { 2956499091411713u, 10536213401276700157u },
  { 2556810833181905u, 2017668710262763877u },
  { 2208423426853748u, 17517752364680373641u },
  { 1905147444998040u, 3046493217652550000u },
  { 1641485106455791u, 172978725869180460u },
  { 1412560385019002u, 6937029766169456867u },
  { 1214055224540665u, 13112899114825585726u },
  { 1042151446749263u, 15287517543109740845u },
  { 893477951099436u, 3090008218051161952u },
  { 765062820719783u, 1560224070431933726u },
  { 654289964556147u, 16476544247734821826u },
  { 558859942823668u, 4629092219533538220u },
  { 476754640576749u, 14253996158557992327u },
  { 406205472319016u, 5698629223838526082u },
  { 345664818872900u, 846098989423622002u },
  { 293780416008530u, 3320828418905336814u },
  { 249372432419943u, 4268654333990411949u },
  { 211412992385806u, 6059031283773268768u },
  { 179007915738765u, 127997801033868391u },
  { 151380464491668u, 6585922436750689224u },
  { 127856901550270u, 8614252484138515825u },
  { 107853682319065u, 18372878135352831232u },
  { 90866114634773u, 12726098760243911882u },
  { 76458336310412u, 1552263311095852274u },
  { 64254472624585u, 13934170504348080600u },
  { 53930848339374u, 5544832161379133637u },
  { 45209140279533u, 14455653967044484689u },
  { 37850367167128u, 8012296412652253830u },
  { 31649623297490u, 14432616600216298025u },
  { 26431471788330u, 969330700538067034u },
  { 22045921561998u, 10538316296416627306u },
  { 18364919962857u, 8043404509811123385u },
  { 15279300001276u, 16293520822469375627u },
  { 12696127688642u, 12996442780438897232u },
  { 10536400820367u, 11799123915008710028u },
  { 8733055913256u, 1984282513670921470u },
  { 7229244846451u, 3196474862661965665u },
  { 5976847127873u, 13452471551055226634u },
  { 4935187645931u, 3762211130041243926u },
  { 4069933303552u, 8323550418162153492u },
  { 3352145101146u, 17836427729649271707u },
  { 2757465068202u, 13226443724450356341u },
  { 2265419969587u, 9869886620501647511u },
  { 1858825960137u, 7373276354214021564u },
  { 1523280355968u, 4308837488131678599u },
  { 1246728457528u, 3208899345023798317u },
  { 1019094920346u, 10299963672143367460u },
  { 831970545641u, 13520858619177581454u },
  { 678346573657u, 5095881202958001223u },
  { 552389625432u, 7987217584804394321u },
  { 449251369770u, 14867453166286240694u },
  { 364907806092u, 4738898715973448255u },
  { 296023763909u, 17063231217256066107u },
  { 239838837861u, 9163888132502453436u },
  { 194071514345u, 3598510787208889929u },
  { 156838711568u, 1377693052209983347u },
  { 126588357893u, 1718030934813279661u },
  { 102042981526u, 3236584663328893382u },
  { 82152584717u, 15252950751091822744u },
  { 66055333893u, 13228737877545307748u },
  { 53044818900u, 11827210562535062836u },
  { 42542824649u, 9092145177160853960u },
  { 34076721075u, 8059544966642847789u },
  { 27260716225u, 1064293502096833523u },
  { 21780335670u, 9328458542070603986u },
  { 17379592182u, 13521330715685300425u },
  { 13850395148u, 822346220981068201u },
  { 11023821740u, 17951322367008485173u },
  { 8762933244u, 5629754975792763433u },
  { 6956871755u, 16861001536111861812u },
  { 5516016243u, 14801921842578625849u },
  { 4368013714u, 8728183233442453704u },
  { 3454532185u, 16399085053829382821u },
  { 2728608098u, 5747283071990548572u },
  { 2152482519u, 15363561888839074770u },
  { 1695838663u, 2020331695628916326u },
  { 1334368384u, 6414838152704646943u },
  { 1048607960u, 13394443051026292351u },
  { 822993942u, 9618673958071879111u },
  { 645098594u, 3106185758709264182u },
  { 505011664u, 11785777679433088795u },
  { 394841207u, 2340734894196693460u },
  { 308311107u, 15899324581038083778u },
  { 240437057u, 18045126963868681594u },
  { 187266056u, 16690924970403613603u },
  { 145667293u, 4763015285624503055u },
  { 113164512u, 4631143270441411859u },
  { 87801832u, 14967710573490103893u },
  { 68036494u, 6124623862718040154u },
  { 52653251u, 11794910965447061355u },
  { 40696146u, 13391888597928037274u },
  { 31414207u, 17183699802891048212u },
  { 24218295u, 8140287281518420699u },
  { 18646854u, 2766751311798924792u },
  { 14338774u, 3357342621642802439u },
  { 11011914u, 11708135308249688048u },
  { 8446133u, 376420708042035360u },
  { 6469894u, 3899317892337409822u },
  { 4949718u, 16868967781903313784u },
  { 3781881u, 6953837488980916135u },
  { 2885886u, 2521436459310245783u },
  { 2199349u, 15961175223937111840u },
  { 1673991u, 6278306039549270692u },
  { 1272494u, 1357583437284589837u },
  { 966055u, 2941803730995315961u },
  { 732472u, 17657459201904421373u },
  { 554657u, 4809912397764106474u },
  { 419470u, 4675328974668283950u },
  { 316826u, 1374292698339086359u },
  { 238992u, 5147442029407546901u },
  { 180048u, 12657052730893834121u },
  { 135468u, 13700498305001681077u },
  { 101796u, 2228390355024056722u },
  { 76395u, 4329537789890042734u },
  { 57259u, 956163509953763060u },
  { 42861u, 4563539326309201610u },
  { 32042u, 11631094427785905353u },
  { 23924u, 363326768549490073u },
  { 17839u, 9244707681993583538u },
  { 13285u, 6884809556114681285u },
  { 9881u, 2663527967843655722u },
  { 7339u, 14405923563783845639u },
  { 5445u, 779514236156817250u },
  { 4034u, 4413177285066366078u },
  { 2985u, 2521146934103632331u },
  { 2206u, 318166810286377127u },
  { 1628u, 2851801379800860233u },
  { 1200u, 2197978777492325968u },
  { 883u, 8790727988054110069u },
  { 649u, 10006858957138127360u },
  { 476u, 17302451977394330697u },
  { 349u, 13839083161294480882u },
  { 256u, 2782553882118460940u },
  { 187u, 6627667121063464949u },
  { 136u, 15978768959551537387u },
  { 99u, 15725213038808414709u },
  { 72u, 13927201814647231299u },
  { 52u, 17394632961026134287u },
  { 38u, 8789071683541208859u },
  { 27u, 17098835725997648524u },
  { 20u, 4497779594053082492u },
  { 14u, 12093416248834805664u },
  { 10u, 11000098299824850518u },
  { 7u, 12018443586123810632u },
  { 5u, 9555414040133330204u },
  { 3u, 17971983552393229078u },
  { 2u, 15840695707955815075u },
  { 2u, 989918219048912307u },
  { 1u, 8733082327520556937u },
  { 1u, 1028600461629026845u },
  { 0u, 13936842380536718117u },
  { 0u, 9960573602178697670u },
  { 0u, 7109597022753888214u },
  { 0u, 5068112562070069071u },
  { 0u, 3608179244616512654u },
  { 0u, 2565491009104736072u },
  { 0u, 1821769332680772104u },
  { 0u, 1291982795339981490u },
  { 0u, 915082993686355625u },
  { 0u, 647298508026796426u },
  { 0u, 457287208671672607u },
  { 0u, 322636713191339639u },
  { 0u, 227341519682347750u },
  { 0u, 159986719960001094u },
  { 0u, 112442183853150038u },
  { 0u, 78925025444270622u },
  { 0u, 55327401168527005u },
  { 0u, 38735204593169904u },
  { 0u, 27083914936646607u },
  { 0u, 18912850669192999u },
  { 0u, 13189929470991385u },
  { 0u, 9186875754353075u },
  { 0u, 6390473894671985u },
  { 0u, 4439541325188683u },
  { 0u, 3080228394573075u },
  { 0u, 2134359051219929u },
  { 0u, 1477038268558593u },
  { 0u, 1020835317780157u },
  { 0u, 704626971606079u },
  { 0u, 485738403695188u },
  { 0u, 334414567195342u },
  { 0u, 229936261937432u },
  { 0u, 157895315852229u },
  { 0u, 108285546454609u },
  { 0u, 74167078509173u },
  { 0u, 50733082756542u },
  { 0u, 34658574919307u },
  { 0u, 23646642561585u },
  { 0u, 16112672368080u },
  { 0u, 10964906657166u },
  { 0u, 7452149234155u },
  { 0u, 5058215856184u },
  { 0u, 3428880535394u },
  { 0u, 2321381397331u },
  { 0u, 1569566661267u },
  { 0u, 1059868832771u },
  { 0u, 714765427121u },
  { 0u, 481408756812u },
  { 0u, 323819827106u },
  { 0u, 217536362028u },
  { 0u, 145948364189u },
  { 0u, 97792493444u },
  { 0u, 65441116026u },
  { 0u, 43735564533u },
  { 0u, 29191580611u },
  { 0u, 19458945103u },
  { 0u, 12954473157u },
  { 0u, 8613089740u },
  { 0u, 5719221500u },
  { 0u, 3792744286u },
  { 0u, 2511937819u },
  { 0u, 1661509606u },
  { 0u, 1097578151u },
  { 0u, 724113508u },
  { 0u, 477107693u },
  { 0u, 313953074u },
  { 0u, 206324872u },
  { 0u, 135418167u },
  { 0u, 88764795u },
  { 0u, 58108950u },
  { 0u, 37991263u },
  { 0u, 24806349u },
  { 0u, 16176343u },
  { 0u, 10535040u },
  { 0u, 6852206u },
  { 0u, 4451054u },
  { 0u, 2887578u },
  { 0u, 1870866u },
  { 0u, 1210570u },
  { 0u, 782304u },
  { 0u, 504893u },
  { 0u, 325433u },
  { 0u, 209489u },
  { 0u, 134679u },
  { 0u, 86472u },
  { 0u, 55449u },
  { 0u, 35509u },
  { 0u, 22711u },
  { 0u, 14506u },
  { 0u, 9254u },
  { 0u, 5896u },
  { 0u, 3751u },
  { 0u, 2384u },
  { 0u, 1513u },
  { 0u, 959u },
  { 0u, 607u },
  { 0u, 384u },
  { 0u, 242u },
  { 0u, 153u },
  { 0u, 96u },
  { 0u, 60u },
  { 0u, 38u },
  { 0u, 24u },
  { 0u, 15u },
  { 0u, 9u },
  { 0u, 6u },
  { 0u, 4u },
  { 0u, 2u },
  { 0u, 1u },
  { 0u, 1u },
  { 0u, 1u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
  { 0u, 0u },
 },
};
# 118 "baseline/source/falcon-sign.c" 2
# 293 "baseline/source/falcon-sign.c"
static void
LDL_fft(fpr *restrict d11, fpr *restrict l10,
 const fpr *restrict g00, const fpr *restrict g01,
 const fpr *restrict g11, unsigned logn, fpr *restrict tmp)
{
 size_t n;

 n = ((size_t)(1 + ((0) << 1)) << ((logn) - (0)));


 memcpy(tmp, g01, n * sizeof *g01);
 falcon_poly_div_fft(tmp, g00, logn);


 memcpy(l10, tmp, n * sizeof *tmp);
 falcon_poly_adj_fft(l10, logn);
 falcon_poly_mul_fft(tmp, l10, logn);


 falcon_poly_mul_fft(tmp, g00, logn);
 memcpy(d11, g11, n * sizeof *g11);
 falcon_poly_sub(d11, tmp, logn);
}




static inline void
LDLqc_fft(fpr *restrict d11, fpr *restrict l10,
 const fpr *restrict g00, const fpr *restrict g01, unsigned logn,
 fpr *restrict tmp)
{
 LDL_fft(d11, l10, g00, g01, g00, logn, tmp);
}





static inline unsigned
ffLDL_treesize(unsigned logn)
{
# 344 "baseline/source/falcon-sign.c"
 return (logn + 1) << logn;
}
# 354 "baseline/source/falcon-sign.c"
static void
ffLDL_fft_inner(fpr *restrict tree,
 fpr *restrict g0, fpr *restrict g1, unsigned logn, fpr *restrict tmp)
{
 size_t n, hn;

 n = ((size_t)(1 + ((0) << 1)) << ((logn) - (0)));
 if (n == 1) {
  tree[0] = g0[0];
  return;
 }
 hn = n >> 1;






 LDLqc_fft(tmp, tree, g0, g1, logn, tmp + n);







 falcon_poly_split_fft(g1, g1 + hn, g0, logn);
 falcon_poly_split_fft(g0, g0 + hn, tmp, logn);





 ffLDL_fft_inner(tree + n,
  g1, g1 + hn, logn - 1, tmp);
 ffLDL_fft_inner(tree + n + ffLDL_treesize(logn - 1),
  g0, g0 + hn, logn - 1, tmp);
}
# 404 "baseline/source/falcon-sign.c"
static void
ffLDL_fft(fpr *restrict tree, const fpr *restrict g00,
 const fpr *restrict g01, const fpr *restrict g11,
 unsigned logn, fpr *restrict tmp)
{
 size_t n, hn;
 fpr *d00, *d11;

 n = ((size_t)(1 + ((0) << 1)) << ((logn) - (0)));
 if (n == 1) {
  tree[0] = g00[0];
  return;
 }
 hn = n >> 1;
 d00 = tmp;
 d11 = tmp + n;
 tmp += n << 1;

 memcpy(d00, g00, n * sizeof *g00);
 LDL_fft(d11, tree, g00, g01, g11, logn, tmp);

 falcon_poly_split_fft(tmp, tmp + hn, d00, logn);
 falcon_poly_split_fft(d00, d00 + hn, d11, logn);
 memcpy(d11, tmp, n * sizeof *tmp);
 ffLDL_fft_inner(tree + n,
  d11, d11 + hn, logn - 1, tmp);
 ffLDL_fft_inner(tree + n + ffLDL_treesize(logn - 1),
  d00, d00 + hn, logn - 1, tmp);
}





static void
ffLDL_binary_normalize(fpr *tree, fpr sigma, unsigned logn)
{



 size_t n;

 n = ((size_t)(1 + ((0) << 1)) << ((logn) - (0)));
 if (n == 1) {
  tree[0] = fpr_div(sigma, fpr_sqrt(tree[0]));
 } else {
  ffLDL_binary_normalize(tree + n,
   sigma, logn - 1);
  ffLDL_binary_normalize(tree + n + ffLDL_treesize(logn - 1),
   sigma, logn - 1);
 }
}
# 504 "baseline/source/falcon-sign.c"
static void
LDL_dim2_fft3(fpr *restrict d11, fpr *restrict l10,
 const fpr *restrict g00, const fpr *restrict g10,
 const fpr *restrict g11, unsigned logn, unsigned full)
{
 size_t n;

 n = ((size_t)(1 + ((full) << 1)) << ((logn) - (full)));






 memcpy(l10, g10, n * sizeof *g10);
 falcon_poly_div_autoadj_fft3(l10, g00, logn, full);






 memcpy(d11, g10, n * sizeof *g10);
 falcon_poly_muladj_fft3(d11, l10, logn, full);
 falcon_poly_neg3(d11, logn, full);
 falcon_poly_add3(d11, g11, logn, full);
}
# 547 "baseline/source/falcon-sign.c"
static void
LDL_dim3_fft3(fpr *restrict d11, fpr *restrict d22,
 fpr *restrict l10, fpr *restrict l20, fpr *restrict l21,
 const fpr *restrict g00, const fpr *restrict g10,
 const fpr *restrict g11, const fpr *restrict g20,
 const fpr *restrict g21, const fpr *restrict g22,
 unsigned logn, unsigned full, fpr *restrict tmp)
{
 size_t n;

 n = ((size_t)(1 + ((full) << 1)) << ((logn) - (full)));







 LDL_dim2_fft3(d11, l10, g00, g10, g11, logn, full);




 memcpy(l20, g20, n * sizeof *g20);
 falcon_poly_div_autoadj_fft3(l20, g00, logn, full);





 memcpy(l21, g20, n * sizeof *g20);
 falcon_poly_muladj_fft3(l21, g10, logn, full);
 falcon_poly_div_autoadj_fft3(l21, g00, logn, full);
 falcon_poly_neg3(l21, logn, full);
 falcon_poly_add3(l21, g21, logn, full);
 falcon_poly_div_autoadj_fft3(l21, d11, logn, full);




 memcpy(d22, l20, n * sizeof *l20);
 falcon_poly_muladj_fft3(d22, g20, logn, full);
 falcon_poly_neg3(d22, logn, full);
 falcon_poly_add3(d22, g22, logn, full);
 memcpy(tmp, l21, n * sizeof *l21);
 falcon_poly_mulselfadj_fft3(tmp, logn, full);
 falcon_poly_mul_autoadj_fft3(tmp, d11, logn, full);
 falcon_poly_sub3(d22, tmp, logn, full);
}

static size_t
ffLDL_inner_fft3(fpr *restrict tree, const fpr *restrict g00,
 const fpr *restrict g10, const fpr *restrict g11,
 unsigned logn, fpr *restrict tmp)
{
 size_t n, hn, s;
 fpr *t0, *t1, *t2;

 n = (size_t)1 << logn;
 hn = n >> 1;

 if (logn == 1) {
# 620 "baseline/source/falcon-sign.c"
  LDL_dim2_fft3(tmp, tree, g00, g10, g11, logn, 0);

  tree[2] = g00[0];
  tree[3] = tmp[0];
  return 4;
 }






 s = n;
 t0 = tmp;
 t1 = tmp + hn;
 t2 = t1 + hn;

 falcon_poly_split_deep_fft3(t0, t1, g00, logn);
 falcon_poly_adj_fft3(t1, logn - 1, 0);
 s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

 LDL_dim2_fft3(t2, tree, g00, g10, g11, logn, 0);

 falcon_poly_split_deep_fft3(t0, t1, t2, logn);
 falcon_poly_adj_fft3(t1, logn - 1, 0);
 s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

 return s;
}

static size_t
ffLDL_depth1_fft3(fpr *restrict tree, const fpr *restrict g00,
 const fpr *restrict g10, const fpr *restrict g11,
 const fpr *restrict g20, const fpr *restrict g21,
 const fpr *restrict g22, unsigned logn, fpr *restrict tmp)
{





 size_t n, hn, s;
 fpr *l10, *l20, *l21, *d11, *d22;
 fpr *t0, *t1, *t2;

 n = (size_t)1 << logn;
 hn = n >> 1;
 l10 = tree;
 l20 = l10 + n;
 l21 = l20 + n;
 d11 = tmp;
 d22 = d11 + n;
 t0 = d22 + n;
 t1 = t0 + hn;
 t2 = t1 + hn;
 s = 3 * n;




 LDL_dim3_fft3(d11, d22, l10, l20, l21,
  g00, g10, g11, g20, g21, g22, logn, 0, t2);
# 690 "baseline/source/falcon-sign.c"
 falcon_poly_split_deep_fft3(t0, t1, g00, logn);
 falcon_poly_adj_fft3(t1, logn - 1, 0);
 s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

 falcon_poly_split_deep_fft3(t0, t1, d11, logn);
 falcon_poly_adj_fft3(t1, logn - 1, 0);
 s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

 falcon_poly_split_deep_fft3(t0, t1, d22, logn);
 falcon_poly_adj_fft3(t1, logn - 1, 0);
 s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

 return s;
}

static size_t
ffLDL_fft3(fpr *restrict tree, const fpr *restrict g00,
 const fpr *restrict g10, const fpr *restrict g11,
 unsigned logn, fpr *restrict tmp)
{
 size_t n, tn, s;
 fpr *l10, *d11, *t0, *t1, *t2, *t3;

 n = (size_t)3 << (logn - 1);
 tn = (size_t)1 << (logn - 1);
 l10 = tree;
 s = n;
 t0 = tmp;
 t1 = t0 + tn;
 t2 = t1 + tn;
 t3 = t2 + tn;
# 732 "baseline/source/falcon-sign.c"
 falcon_poly_split_top_fft3(t0, t1, t2, g00, logn);
 falcon_poly_adj_fft3(t1, logn - 1, 0);
 falcon_poly_adj_fft3(t2, logn - 1, 0);
 s += ffLDL_depth1_fft3(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);




 d11 = t3;
 LDL_dim2_fft3(d11, l10, g00, g10, g11, logn, 1);




 falcon_poly_split_top_fft3(t0, t1, t2, d11, logn);
 falcon_poly_adj_fft3(t1, logn - 1, 0);
 falcon_poly_adj_fft3(t2, logn - 1, 0);
 s += ffLDL_depth1_fft3(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);

 return s;
}

static uint64_t ft_fpr_bits(fpr x);
static fpr ft_fpr_from_bits(uint64_t w);
static int ft_fpr_is_positive_finite(fpr x);
static void smallints_to_fpr(fpr *r, const int16_t *t,
 unsigned logn, unsigned ter);

static fpr
ft_stable_positive(fpr x, uint32_t *bad)
{
 uint64_t mask, xb;
 uint32_t valid;

 valid = (uint32_t)ft_fpr_is_positive_finite(x);
 *bad |= valid ^ 1U;
 mask = (uint64_t)0 - (uint64_t)valid;
 xb = ft_fpr_bits(x);
 return ft_fpr_from_bits((xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
}

static void
ft_stable_binary_inplace(fpr *values, size_t n,
 fpr *scratch, uint32_t *bad)
{
 size_t hn, u;

 if (n == 1) {
  values[0] = ft_stable_positive(values[0], bad);
  return;
 }
 hn = n >> 1;
 for (u = 0; u < hn; u ++) {
  fpr a, b, product, sum;

  a = ft_stable_positive(values[(u << 1) + 0], bad);
  b = ft_stable_positive(values[(u << 1) + 1], bad);
  sum = ft_stable_positive(fpr_add(a, b), bad);
  product = ft_stable_positive(fpr_mul(a, b), bad);
  scratch[u] = ft_stable_positive(fpr_half(sum), bad);
  scratch[u + hn] = ft_stable_positive(
   fpr_div(fpr_double(product), sum), bad);
 }
 memcpy(values, scratch, n * sizeof *values);
 ft_stable_binary_inplace(values, hn, scratch, bad);
 ft_stable_binary_inplace(values + hn, hn, scratch, bad);
}

static void
ft_stable_top_branch(const fpr *roots, fpr *leaves,
 fpr *scratch, uint32_t *bad)
{
 fpr three;
 size_t u, v;

 three = fpr_of(3);
 for (u = 0, v = 0; u < 768; u += 3, v ++) {
  fpr a, ab, abc, ac, b, bc, c, e1, e2;

  a = ft_stable_positive(roots[u + 0], bad);
  b = ft_stable_positive(roots[u + 1], bad);
  c = ft_stable_positive(roots[u + 2], bad);
  e1 = ft_stable_positive(fpr_add(fpr_add(a, b), c), bad);
  ab = ft_stable_positive(fpr_mul(a, b), bad);
  ac = ft_stable_positive(fpr_mul(a, c), bad);
  bc = ft_stable_positive(fpr_mul(b, c), bad);
  e2 = ft_stable_positive(fpr_add(fpr_add(ab, ac), bc), bad);
  abc = ft_stable_positive(fpr_mul(ab, c), bad);
  leaves[v] = ft_stable_positive(fpr_div(e1, three), bad);
  leaves[256 + v] = ft_stable_positive(fpr_div(e2, e1), bad);
  leaves[512 + v] = ft_stable_positive(
   fpr_div(fpr_mul(three, abc), e2), bad);
 }
 ft_stable_binary_inplace(leaves + 0, 256, scratch, bad);
 ft_stable_binary_inplace(leaves + 256, 256, scratch, bad);
 ft_stable_binary_inplace(leaves + 512, 256, scratch, bad);
}






static int
ft_build_stable_certified_leaves(fpr *tmp, fpr **leaves_out,
 const int16_t *f_src, const int16_t *g_src, unsigned logn)
{
 fpr *f, *g, *leaves, *scratch;
 fpr q_squared;
 size_t hn, n, u;
 uint32_t bad;

 n = ((size_t)(1 + ((1) << 1)) << ((logn) - (1)));
 hn = n >> 1;
 if (logn != 10 || n != 1536 || hn != 768) {
  return 0;
 }
 f = tmp;
 g = f + n;
 smallints_to_fpr(f, f_src, logn, 1);
 smallints_to_fpr(g, g_src, logn, 1);
 falcon_FFT3(f, logn, 1);
 falcon_FFT3(g, logn, 1);
 falcon_poly_mulselfadj_fft3(f, logn, 1);
 falcon_poly_mulselfadj_fft3(g, logn, 1);
 falcon_poly_add3(f, g, logn, 1);

 bad = 0;
 for (u = 0; u < hn; u ++) {
  uint32_t valid;
  uint64_t mask, xb;

  valid = (uint32_t)ft_fpr_is_positive_finite(f[u]);
  valid &= (uint32_t)(1 ^ fpr_lt(f[u], fpr_onehalf));
  bad |= valid ^ 1U;
  mask = (uint64_t)0 - (uint64_t)valid;
  xb = ft_fpr_bits(f[u]);
  f[u] = ft_fpr_from_bits(
   (xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
 }

 leaves = f + hn;
 scratch = leaves + n;
 ft_stable_top_branch(f, leaves, scratch, &bad);
 q_squared = fpr_of(((int64_t)339775489));
 for (u = 0; u < hn; u ++) {
  leaves[n - 1 - u] = ft_stable_positive(
   fpr_div(q_squared, leaves[u]), &bad);
 }


 for (u = 0; u < n; u ++) {
  uint64_t bits;
  uint32_t valid;

  leaves[u] = ft_stable_positive(leaves[u], &bad);
  bits = ft_fpr_bits(leaves[u]);
  valid = (uint32_t)(1 ^ (uint32_t)((bits - 0x4090000053700377UL) >> 63));
  valid &= (uint32_t)(1 ^ (uint32_t)((0x4114444d1a037d50UL - bits) >> 63));
  bad |= valid ^ 1U;
 }
 *leaves_out = leaves;
 return bad == 0;
}
# 963 "baseline/source/falcon-sign.c"
static size_t
ffLDL_ternary_normalize_inner(fpr *tree, fpr sigma, unsigned logn,
 const fpr *leaves, size_t *leaf_index)
{
 size_t s;

 if (logn == 1) {
# 987 "baseline/source/falcon-sign.c"
  tree[2] = fpr_div(sigma,
   fpr_sqrt(leaves[(*leaf_index) ++]));
  tree[3] = fpr_div(sigma,
   fpr_sqrt(leaves[(*leaf_index) ++]));

  return 4;
 }

 s = (size_t)1 << logn;
 s += ffLDL_ternary_normalize_inner(
  tree + s, sigma, logn - 1, leaves, leaf_index);
 s += ffLDL_ternary_normalize_inner(
  tree + s, sigma, logn - 1, leaves, leaf_index);
 return s;
}

static size_t
ffLDL_ternary_normalize_depth1(fpr *tree, fpr sigma, unsigned logn,
 const fpr *leaves, size_t *leaf_index)
{
 size_t s;

 s = (size_t)3 << logn;
 s += ffLDL_ternary_normalize_inner(
  tree + s, sigma, logn - 1, leaves, leaf_index);
 s += ffLDL_ternary_normalize_inner(
  tree + s, sigma, logn - 1, leaves, leaf_index);
 s += ffLDL_ternary_normalize_inner(
  tree + s, sigma, logn - 1, leaves, leaf_index);
 return s;
}

static size_t
ffLDL_ternary_normalize(fpr *tree, fpr sigma, unsigned logn,
 const fpr *leaves, size_t *leaf_count)
{
 size_t leaf_index, s;




 leaf_index = 0;
 s = (size_t)3 << (logn - 1);
 s += ffLDL_ternary_normalize_depth1(
  tree + s, sigma, logn - 1, leaves, &leaf_index);
 s += ffLDL_ternary_normalize_depth1(
  tree + s, sigma, logn - 1, leaves, &leaf_index);




 *leaf_count = leaf_index;
 return s;
}







static void
smallints_to_fpr(fpr *r, const int16_t *t, unsigned logn, unsigned ter)
{
 size_t n, u;

 n = ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)));
 for (u = 0; u < n; u ++) {
  r[u] = fpr_of(t[u]);
 }
}







static inline size_t
skoff_b00(unsigned logn, unsigned ter)
{
 (void)logn;
 (void)ter;
 return 0;
}

static inline size_t
skoff_b01(unsigned logn, unsigned ter)
{
 return ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)));
}

static inline size_t
skoff_b10(unsigned logn, unsigned ter)
{
 return 2 * ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)));
}

static inline size_t
skoff_b11(unsigned logn, unsigned ter)
{
 return 3 * ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)));
}

static inline size_t
skoff_tree(unsigned logn, unsigned ter)
{
 return 4 * ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)));
}






static int
ft_validate_ternary_private(const int16_t *f, const int16_t *g,
 const int16_t *F, const int16_t *G, int64_t *relation)
{
 const size_t n = 1536;
 const size_t hn = 768;
 size_t i, j;
 uint32_t bad;

 memset(relation, 0, n * sizeof *relation);
 bad = 0;
 for (i = 0; i < n; i ++) {
  int32_t fi, gi;

  fi = f[i];
  gi = g[i];
  bad |= (uint32_t)((fi < -1) | (fi > 1));
  bad |= (uint32_t)((gi < -1) | (gi > 1));
  for (j = 0; j < n; j ++) {
   int64_t v;
   size_t k, u;

   v = (int64_t)fi * (int64_t)G[j]
    - (int64_t)gi * (int64_t)F[j];
   k = i + j;
   if (k < n) {
    relation[k] += v;
   } else {
    u = k - n;
    if (u < hn) {
     relation[u] -= v;
     relation[u + hn] += v;
    } else {
     relation[u - hn] -= v;
    }
   }
  }
 }
 relation[0] -= 18433;
 for (i = 0; i < n; i ++) {
  bad |= (uint32_t)(relation[i] != 0);
 }
 return bad == 0;
}
# 1158 "baseline/source/falcon-sign.c"
static int
load_skey(fpr *restrict sk, unsigned q,
 const int16_t *f_src, const int16_t *g_src,
 const int16_t *F_src, const int16_t *G_src,
 unsigned logn, unsigned ter, fpr *restrict tmp)
{
 size_t n;
 fpr *f, *g, *F, *G;
 fpr *b00, *b01, *b10, *b11;
 fpr *tree;
 fpr sigma;

 n = ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)));
 b00 = sk + skoff_b00(logn, ter);
 b01 = sk + skoff_b01(logn, ter);
 b10 = sk + skoff_b10(logn, ter);
 b11 = sk + skoff_b11(logn, ter);
 tree = sk + skoff_tree(logn, ter);





 f = b01;
 g = b00;
 F = b11;
 G = b10;

 smallints_to_fpr(f, f_src, logn, ter);
 smallints_to_fpr(g, g_src, logn, ter);
 smallints_to_fpr(F, F_src, logn, ter);
 smallints_to_fpr(G, G_src, logn, ter);




 if (ter) {
  falcon_FFT3(f, logn, 1);
  falcon_FFT3(g, logn, 1);
  falcon_FFT3(F, logn, 1);
  falcon_FFT3(G, logn, 1);
  falcon_poly_neg3(f, logn, 1);
  falcon_poly_neg3(F, logn, 1);
 } else {
  falcon_FFT(f, logn);
  falcon_FFT(g, logn);
  falcon_FFT(F, logn);
  falcon_FFT(G, logn);
  falcon_poly_neg(f, logn);
  falcon_poly_neg(F, logn);
 }
# 1217 "baseline/source/falcon-sign.c"
 if (ter) {
  fpr *g00, *g10, *g11, *gxx;
  fpr *stable_leaves;
  size_t leaf_count, tree_words;
  int stable_ok;

  if (logn != 10 || n != 1536 || q != 18433) {
   return 0;
  }

  g00 = tmp;
  g10 = g00 + n;
  g11 = g10 + n;
  gxx = g11 + n;

  memcpy(g00, b00, n * sizeof *b00);
  falcon_poly_mulselfadj_fft3(g00, logn, 1);
  memcpy(gxx, b01, n * sizeof *b01);
  falcon_poly_mulselfadj_fft3(gxx, logn, 1);
  falcon_poly_add3(g00, gxx, logn, 1);

  memcpy(g10, b10, n * sizeof *b10);
  falcon_poly_muladj_fft3(g10, b00, logn, 1);
  memcpy(gxx, b11, n * sizeof *b11);
  falcon_poly_muladj_fft3(gxx, b01, logn, 1);
  falcon_poly_add3(g10, gxx, logn, 1);

  memcpy(g11, b10, n * sizeof *b10);
  falcon_poly_mulselfadj_fft3(g11, logn, 1);
  memcpy(gxx, b11, n * sizeof *b11);
  falcon_poly_mulselfadj_fft3(gxx, logn, 1);
  falcon_poly_add3(g11, gxx, logn, 1);




  ffLDL_fft3(tree, g00, g10, g11, logn, gxx);







  stable_ok = ft_build_stable_certified_leaves(tmp,
   &stable_leaves, f_src, g_src, logn);
  sigma = fpr_of(((int64_t)768));
  tree_words = ffLDL_ternary_normalize(tree, sigma, logn,
   stable_leaves, &leaf_count);
  return stable_ok
   && leaf_count == n
   && tree_words == (size_t)12 * n;
 } else {




  fpr *g00, *g01, *g11, *gxx;

  g00 = tmp;
  g01 = g00 + n;
  g11 = g01 + n;
  gxx = g11 + n;

  memcpy(g00, b00, n * sizeof *b00);
  falcon_poly_mulselfadj_fft(g00, logn);
  memcpy(gxx, b01, n * sizeof *b01);
  falcon_poly_mulselfadj_fft(gxx, logn);
  falcon_poly_add(g00, gxx, logn);

  memcpy(g01, b00, n * sizeof *b00);
  falcon_poly_muladj_fft(g01, b10, logn);
  memcpy(gxx, b01, n * sizeof *b01);
  falcon_poly_muladj_fft(gxx, b11, logn);
  falcon_poly_add(g01, gxx, logn);

  memcpy(g11, b10, n * sizeof *b10);
  falcon_poly_mulselfadj_fft(g11, logn);
  memcpy(gxx, b11, n * sizeof *b11);
  falcon_poly_mulselfadj_fft(gxx, logn);
  falcon_poly_add(g11, gxx, logn);




  ffLDL_fft(tree, g00, g01, g11, logn, gxx);





  sigma = fpr_mul(fpr_sqrt(fpr_of(q)),
   fpr_div(fpr_of(155), fpr_of(100)));




  ffLDL_binary_normalize(tree, sigma, logn);
  return 1;
 }
}

typedef int (*samplerZ)(void *ctx, fpr mu, fpr sigma);

enum {
 FT_SAMPLER_FAULT_NONE = 0,
 FT_SAMPLER_FAULT_INVALID_SIGMA = 1,
 FT_SAMPLER_FAULT_PROPOSAL_RANGE = 2,
 FT_SAMPLER_FAULT_NEGATIVE_X = 3
};

typedef struct {
 prng p;
 unsigned fault;
} ternary_sampler_context;
# 1563 "baseline/source/falcon-sign.c"
static void
ffSampling_fft(samplerZ samp, void *samp_ctx,
 fpr *restrict z0, fpr *restrict z1,
 const fpr *restrict tree,
 const fpr *restrict t0, const fpr *restrict t1, unsigned logn,
 fpr *restrict tmp)
{
 size_t n, hn;
 const fpr *tree0, *tree1;

 n = (size_t)1 << logn;
 if (n == 1) {
  fpr x0, x1, sigma;

  x0 = t0[0];
  x1 = t1[0];
  sigma = tree[0];
  z0[0] = fpr_of(samp(samp_ctx, x0, sigma));
  z1[0] = fpr_of(samp(samp_ctx, x1, sigma));
  return;
 }

 hn = n >> 1;
 tree0 = tree + n;
 tree1 = tree + n + ffLDL_treesize(logn - 1);






 falcon_poly_split_fft(z1, z1 + hn, t1, logn);
 ffSampling_fft(samp, samp_ctx, tmp, tmp + hn,
  tree1, z1, z1 + hn, logn - 1, tmp + n);
 falcon_poly_merge_fft(z1, tmp, tmp + hn, logn);




 memcpy(tmp, t1, n * sizeof *t1);
 falcon_poly_sub(tmp, z1, logn);
 falcon_poly_mul_fft(tmp, tree, logn);
 falcon_poly_add(tmp, t0, logn);




 falcon_poly_split_fft(z0, z0 + hn, tmp, logn);
 ffSampling_fft(samp, samp_ctx, tmp, tmp + hn,
  tree0, z0, z0 + hn, logn - 1, tmp + n);
 falcon_poly_merge_fft(z0, tmp, tmp + hn, logn);
}

static void
ffSampling_inner_fft3(samplerZ samp, void *samp_ctx,
 fpr *restrict z0, fpr *restrict z1,
 const fpr *restrict tree,
 const fpr *restrict t0, const fpr *restrict t1,
 unsigned logn, fpr *restrict tmp)
{
 size_t n, hn;
 fpr *x0, *x1, *y0, *y1;
 const fpr *tree0, *tree1;







 if (logn == 0) {
  fpr r0, r1, rx;
  fpr sigma;

  sigma = tree[0];
  r1 = *t1;
  r0 = *t0;
  r1 = fpr_sub(r1, fpr_of(
   samp(samp_ctx, r1, fpr_mul(fpr_IW1I, sigma))));
  rx = fpr_half(r1);
  r0 = fpr_add(r0, rx);
  r0 = fpr_sub(r0, fpr_of(
   samp(samp_ctx, r0, sigma)));
  r0 = fpr_sub(r0, rx);
  *z0 = r0;
  *z1 = r1;
  return;
 }

 n = (size_t)1 << logn;
 hn = n >> 1;
 y0 = tmp;
 y1 = y0 + hn;

 tree0 = tree + n;
 tree1 = tree + n + (logn << (logn - 1));




 x0 = z1;
 x1 = x0 + hn;
 falcon_poly_split_deep_fft3(x0, x1, t1, logn);
 ffSampling_inner_fft3(samp, samp_ctx,
  y0, y1, tree1, x0, x1, logn - 1, tmp + n);
 falcon_poly_merge_deep_fft3(z1, y0, y1, logn);





 memcpy(tmp, z1, n * sizeof *t1);
 falcon_poly_mul_fft3(tmp, tree, logn, 0);
 falcon_poly_add3(tmp, t0, logn, 0);




 x0 = z0;
 x1 = x0 + hn;
 falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
 ffSampling_inner_fft3(samp, samp_ctx,
  y0, y1, tree0, x0, x1, logn - 1, tmp + n);
 falcon_poly_merge_deep_fft3(z0, y0, y1, logn);




 memcpy(tmp, z1, n * sizeof *z1);
 falcon_poly_mul_fft3(tmp, tree, logn, 0);
 falcon_poly_sub3(z0, tmp, logn, 0);
}

static void
ffSampling_depth1_fft3(samplerZ samp, void *samp_ctx,
 fpr *restrict z0, fpr *restrict z1, fpr *restrict z2,
 const fpr *restrict tree,
 const fpr *restrict t0, const fpr *restrict t1, const fpr *restrict t2,
 unsigned logn, fpr *restrict tmp)
{
 size_t n, hn;
 fpr *x0, *x1, *y0, *y1;
 const fpr *tree0, *tree1, *tree2;

 n = (size_t)1 << logn;
 hn = n >> 1;

 tree0 = tree + 3 * n;
 tree1 = tree0 + (logn << (logn - 1));
 tree2 = tree1 + (logn << (logn - 1));
 y0 = tmp;
 y1 = y0 + hn;




 x0 = z2;
 x1 = x0 + hn;
 falcon_poly_split_deep_fft3(x0, x1, t2, logn);
 ffSampling_inner_fft3(samp, samp_ctx,
  y0, y1, tree2, x0, x1, logn - 1, tmp + n);
 falcon_poly_merge_deep_fft3(z2, y0, y1, logn);





 memcpy(tmp, z2, n * sizeof *z2);
 falcon_poly_mul_fft3(tmp, tree + 2 * n, logn, 0);
 falcon_poly_add3(tmp, t1, logn, 0);




 x0 = z1;
 x1 = x0 + hn;
 falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
 ffSampling_inner_fft3(samp, samp_ctx,
  y0, y1, tree1, x0, x1, logn - 1, tmp + n);
 falcon_poly_merge_deep_fft3(z1, y0, y1, logn);
 memcpy(tmp, z2, n * sizeof *z2);
 falcon_poly_mul_fft3(tmp, tree + 2 * n, logn, 0);
 falcon_poly_sub3(z1, tmp, logn, 0);






 memcpy(z0, t0, n * sizeof *t0);
 memcpy(tmp, z1, n * sizeof *z1);
 falcon_poly_mul_fft3(tmp, tree, logn, 0);
 falcon_poly_add3(z0, tmp, logn, 0);
 memcpy(tmp, z2, n * sizeof *z1);
 falcon_poly_mul_fft3(tmp, tree + n, logn, 0);
 falcon_poly_add3(z0, tmp, logn, 0);




 x0 = z0;
 x1 = x0 + hn;
 memcpy(tmp, z0, n * sizeof *z0);
 falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
 ffSampling_inner_fft3(samp, samp_ctx,
  y0, y1, tree0, x0, x1, logn - 1, tmp + n);
 falcon_poly_merge_deep_fft3(z0, y0, y1, logn);




 memcpy(tmp, z1, n * sizeof *z1);
 falcon_poly_mul_fft3(tmp, tree, logn, 0);
 falcon_poly_sub3(z0, tmp, logn, 0);
 memcpy(tmp, z2, n * sizeof *z1);
 falcon_poly_mul_fft3(tmp, tree + n, logn, 0);
 falcon_poly_sub3(z0, tmp, logn, 0);
}

static void
ffSampling_fft3(samplerZ samp, void *samp_ctx,
 fpr *restrict z0, fpr *restrict z1,
 const fpr *restrict tree,
 const fpr *restrict t0, const fpr *restrict t1, unsigned logn,
 fpr *restrict tmp)
{
 size_t n, tn;
 fpr *x0, *x1, *x2, *y0, *y1, *y2;
 const fpr *tree0, *tree1;

 n = (size_t)3 << (logn - 1);
 tn = (size_t)1 << (logn - 1);

 tree0 = tree + n;
 tree1 = tree0 + 3 * ((logn + 1) << (logn - 2));
 y0 = tmp;
 y1 = y0 + tn;
 y2 = y1 + tn;





 x0 = z1;
 x1 = x0 + tn;
 x2 = x1 + tn;
 falcon_poly_split_top_fft3(x0, x1, x2, t1, logn);
 ffSampling_depth1_fft3(samp, samp_ctx,
  y0, y1, y2, tree1, x0, x1, x2, logn - 1, tmp + n);
 falcon_poly_merge_top_fft3(z1, y0, y1, y2, logn);





 memcpy(tmp, z1, n * sizeof *z1);
 falcon_poly_mul_fft3(tmp, tree, logn, 1);
 falcon_poly_add3(tmp, t0, logn, 1);




 x0 = z0;
 x1 = x0 + tn;
 x2 = x1 + tn;
 falcon_poly_split_top_fft3(x0, x1, x2, tmp, logn);
 ffSampling_depth1_fft3(samp, samp_ctx,
  y0, y1, y2, tree0, x0, x1, x2, logn - 1, tmp + n);
 falcon_poly_merge_top_fft3(z0, y0, y1, y2, logn);




 memcpy(tmp, z1, n * sizeof *z1);
 falcon_poly_mul_fft3(tmp, tree, logn, 1);
 falcon_poly_sub3(z0, tmp, logn, 1);
}
# 1848 "baseline/source/falcon-sign.c"
static void
do_sign(samplerZ samp, void *samp_ctx,
 int16_t *restrict s1, int16_t *restrict s2,
 unsigned q, const fpr *restrict sk, const uint16_t *restrict hm,
 unsigned logn, unsigned ter, fpr *restrict tmp)
{
 size_t n, u;
 fpr *t0, *t1, *tx, *ty, *tz;
 const fpr *b00, *b01, *b10, *b11, *tree;
 fpr ni;

 n = ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)));
 t0 = tmp;
 t1 = t0 + n;
 tx = t1 + n;
 ty = tx + n;
 tz = ty + n;
 b00 = sk + skoff_b00(logn, ter);
 b01 = sk + skoff_b01(logn, ter);
 b10 = sk + skoff_b10(logn, ter);
 b11 = sk + skoff_b11(logn, ter);
 tree = sk + skoff_tree(logn, ter);




 for (u = 0; u < n; u ++) {
  t0[u] = fpr_of(hm[u]);



 }

 if (ter) {




  falcon_FFT3(t0, logn, 1);
  ni = fpr_inverse_of(q);
  memcpy(t1, t0, n * sizeof *t0);
  falcon_poly_mul_fft3(t1, b01, logn, 1);
  falcon_poly_mulconst3(t1, fpr_neg(ni), logn, 1);
  falcon_poly_mul_fft3(t0, b11, logn, 1);
  falcon_poly_mulconst3(t0, ni, logn, 1);




  ffSampling_fft3(samp, samp_ctx, tx, ty, tree, t0, t1, logn, tz);




  memcpy(t0, tx, n * sizeof *tx);
  memcpy(t1, ty, n * sizeof *ty);
  falcon_poly_mul_fft3(tx, b00, logn, 1);
  falcon_poly_mul_fft3(ty, b10, logn, 1);
  falcon_poly_add3(tx, ty, logn, 1);
  memcpy(ty, t0, n * sizeof *t0);
  falcon_poly_mul_fft3(ty, b01, logn, 1);

  memcpy(t0, tx, n * sizeof *tx);
  falcon_poly_mul_fft3(t1, b11, logn, 1);
  falcon_poly_add3(t1, ty, logn, 1);

  falcon_iFFT3(t0, logn, 1);
  falcon_iFFT3(t1, logn, 1);




  for (u = 0; u < n; u ++) {
# 1931 "baseline/source/falcon-sign.c"
   s1[u] = (int16_t)fpr_rint(t0[u]);
   s2[u] = (int16_t)fpr_rint(t1[u]);

  }
 } else {




  falcon_FFT(t0, logn);
  ni = fpr_inverse_of(q);
  memcpy(t1, t0, n * sizeof *t0);
  falcon_poly_mul_fft(t1, b01, logn);
  falcon_poly_mulconst(t1, fpr_neg(ni), logn);
  falcon_poly_mul_fft(t0, b11, logn);
  falcon_poly_mulconst(t0, ni, logn);




  ffSampling_fft(samp, samp_ctx, tx, ty, tree, t0, t1, logn, tz);




  memcpy(t0, tx, n * sizeof *tx);
  memcpy(t1, ty, n * sizeof *ty);
  falcon_poly_mul_fft(tx, b00, logn);
  falcon_poly_mul_fft(ty, b10, logn);
  falcon_poly_add(tx, ty, logn);
  memcpy(ty, t0, n * sizeof *t0);
  falcon_poly_mul_fft(ty, b01, logn);

  memcpy(t0, tx, n * sizeof *tx);
  falcon_poly_mul_fft(t1, b11, logn);
  falcon_poly_add(t1, ty, logn);

  falcon_iFFT(t0, logn);
  falcon_iFFT(t1, logn);




  for (u = 0; u < n; u ++) {
# 1985 "baseline/source/falcon-sign.c"
   s1[u] = (int16_t)(hm[u] - fpr_rint(t0[u]));
   s2[u] = (int16_t)-fpr_rint(t1[u]);

  }
 }
}
# 2236 "baseline/source/falcon-sign.c"
typedef struct {
 uint64_t hi, lo;
} z128;

static const uint8_t CDF8[] = {
 170u, 95u, 44u, 16u, 4u, 1u
};

static const z128 CDFs[] = {
 { 15768066815414256656u, 2878715985279770247u },
 { 13178414795510471601u, 2650718273802340096u },
 { 1313815201007480117u, 632549813042453946u },
 { 7906626931797828486u, 889294877069012273u },
 { 16702932880114533024u, 10156928267985658938u },
 { 3033535791909276021u, 9305891721635116763u }
};

static const z128 CDF0[] = {
 { 4031913084411455523u, 10918864678521243583u },
 { 596125951946700678u, 5229758529120913067u },
 { 69230930161336360u, 13628093135512931395u },
 { 6302293744552402u, 7352830732370919967u },
 { 449018771521685u, 9764979398035562428u },
 { 25008954620675u, 11366537104174662165u },
 { 1087957639417u, 2775583653356073882u },
 { 36942382845u, 16012748850353453704u },
 { 978618449u, 2690982465095676317u },
 { 20216591u, 2875354667081992134u },
 { 325595u, 3253399177098153241u },
 { 4087u, 3145154105398596933u },
 { 39u, 18114503424067091158u },
 { 0u, 5621630163842613476u },
 { 0u, 33383367111730198u },
 { 0u, 154437016759436u },
 { 0u, 556541887369u },
 { 0u, 1562239343u },
 { 0u, 3415730u },
 { 0u, 5817u },
 { 0u, 8u },
 { 0u, 0u }
};
# 2286 "baseline/source/falcon-sign.c"
static int
gaussian0_sampler(prng *p)
{
 uint8_t msb;
 uint64_t hi, lo;
 int z, result;
 uint64_t not_found, msb_nz;


 msb = falcon_prng_get_u8(p);
 hi = falcon_prng_get_u64(p);
 lo = falcon_prng_get_u64(p);

 result = 0;
 not_found = 1;


 for (z = 0; z < (int)(sizeof CDF8); z ++) {
  uint64_t d, msb_gt, msb_eq, hi_gt, hi_eq, lo_ge, ge, sel;

  d = (uint64_t)msb - (uint64_t)CDF8[z];
  msb_gt = ((uint64_t)CDF8[z] - (uint64_t)msb) >> 63;
  msb_eq = ~(d | (0 - d)) >> 63;

  d = hi - CDFs[z].hi;
  hi_gt = (CDFs[z].hi - hi) >> 63;
  hi_eq = ~(d | (0 - d)) >> 63;
  lo_ge = ~((lo - CDFs[z].lo) >> 63);

  ge = msb_gt | (msb_eq & (hi_gt | (hi_eq & lo_ge)));
  sel = ge & not_found;
  result += (int)(sel * (uint64_t)z);
  not_found &= ~ge;
 }
# 2329 "baseline/source/falcon-sign.c"
 msb_nz = (uint64_t)0 - ((0 - (uint64_t)msb) >> 63);
 for (z = 0; z < (int)(sizeof CDF0 / sizeof CDF0[0]); z ++) {
  uint64_t d, hi_gt, hi_eq, lo_ge, ge, sel;

  d = hi - CDF0[z].hi;
  hi_gt = (CDF0[z].hi - hi) >> 63;
  hi_eq = ~(d | (0 - d)) >> 63;
  lo_ge = ~((lo - CDF0[z].lo) >> 63);

  ge = (msb_nz | (hi_gt | (hi_eq & lo_ge))) & 1;
  sel = ge & not_found;
  result += (int)(sel * (uint64_t)(z + (int)(sizeof CDF8)));
  not_found &= ~ge;
 }

 return result;
}






static const uint8_t CDF8_large[] = {
 178u, 108u, 56u, 24u, 9u, 2u
};

static const z128 CDFs_large[] = {
 { 8907275334149596729u, 16778027755648063129u },
 { 6317262760517346072u, 15902788240420165876u },
 { 7031337543115141225u, 9824276216381865951u },
 { 15957431816781393328u, 16574837997735344921u },
 { 3958935845209878676u, 6981315484799813327u },
 { 15709623016065876966u, 2702816742530118898u }
};

static const z128 CDF0_large[] = {
 { 13531861302627160881u, 12501850565673174323u },
 { 2883703521967663950u, 5157340768998930255u },
 { 507778371083361256u, 11424694869198933797u },
 { 73735991634291542u, 8646638592401813304u },
 { 8816872255987156u, 9065313618840431804u },
 { 867108771591057u, 15825127838409392498u },
 { 70074676775737u, 13399288374961512449u },
 { 4650134199621u, 13863624956398687773u },
 { 253244270030u, 5321603584647435131u },
 { 11313227870u, 10635011769594914448u },
 { 414427387u, 724858218881080488u },
 { 12445104u, 6129400264707983377u },
 { 306291u, 3917954960011630607u },
 { 6176u, 17430417779382047418u },
 { 102u, 1078742132913311815u },
 { 1u, 7034811317387681053u },
 { 0u, 282501377050842205u },
 { 0u, 2565173241819955u },
 { 0u, 19075897380102u },
 { 0u, 116171998071u },
 { 0u, 579357465u },
 { 0u, 2365944u },
 { 0u, 7912u },
 { 0u, 22u },
 { 0u, 0u }
};

static int __attribute__((unused))
gaussian0_sampler_large(prng *p)
{
 uint8_t msb;
 uint64_t hi, lo;
 int z, result;
 uint64_t not_found, msb_nz;

 msb = falcon_prng_get_u8(p);
 hi = falcon_prng_get_u64(p);
 lo = falcon_prng_get_u64(p);

 result = 0;
 not_found = 1;

 for (z = 0; z < (int)(sizeof CDF8_large); z ++) {
  uint64_t d, msb_gt, msb_eq, hi_gt, hi_eq, lo_ge, ge, sel;

  d = (uint64_t)msb - (uint64_t)CDF8_large[z];
  msb_gt = ((uint64_t)CDF8_large[z] - (uint64_t)msb) >> 63;
  msb_eq = ~(d | (0 - d)) >> 63;

  d = hi - CDFs_large[z].hi;
  hi_gt = (CDFs_large[z].hi - hi) >> 63;
  hi_eq = ~(d | (0 - d)) >> 63;
  lo_ge = ~((lo - CDFs_large[z].lo) >> 63);

  ge = msb_gt | (msb_eq & (hi_gt | (hi_eq & lo_ge)));
  sel = ge & not_found;
  result += (int)(sel * (uint64_t)z);
  not_found &= ~ge;
 }




 msb_nz = (uint64_t)0 - ((0 - (uint64_t)msb) >> 63);
 for (z = 0; z < (int)(sizeof CDF0_large / sizeof CDF0_large[0]); z ++) {
  uint64_t d, hi_gt, hi_eq, lo_ge, ge, sel;

  d = hi - CDF0_large[z].hi;
  hi_gt = (CDF0_large[z].hi - hi) >> 63;
  hi_eq = ~(d | (0 - d)) >> 63;
  lo_ge = ~((lo - CDF0_large[z].lo) >> 63);

  ge = (msb_nz | (hi_gt | (hi_eq & lo_ge))) & 1;
  sel = ge & not_found;
  result += (int)(sel * (uint64_t)(z + (int)(sizeof CDF8_large)));
  not_found &= ~ge;
 }

 return result;
}



static void
ft_berexp_cutoff_state(uint32_t sw, uint32_t *safe_s, uint32_t *over)
{
 *over = (63U - sw) >> 31;
 *safe_s = sw ^ ((sw ^ 63U) & (0U - *over));
}
# 2468 "baseline/source/falcon-sign.c"
static int
BerExp(prng *p, fpr x)
{
 int s;
 fpr r;
 uint64_t w, z;
 int b;
 uint32_t over, safe_s, sw;





 s = fpr_floor(fpr_mul(x, fpr_inv_ln2));
 r = fpr_sub(x, fpr_mul(fpr_of(s), fpr_log2));






 sw = (uint32_t)s;
 ft_berexp_cutoff_state(sw, &safe_s, &over);







 w = falcon_prng_get_u64(p);
 w ^= (w >> safe_s) << safe_s;
 b = 1 - (int)((w | -w) >> 63);
 b &= 1 ^ (int)over;





 z = fpr_expm_scaled(r) >> 8;
 w = falcon_prng_get_u64(p);
 w &= ((uint64_t)1 << 55) - 1;
 b &= (int)((w - z) >> 63);

 return b;
}
# 2522 "baseline/source/falcon-sign.c"
static int
sampler(void *ctx, fpr mu, fpr sigma)
{
 prng *p;
 int s;
 fpr r, dss;

 p = ctx;
# 2542 "baseline/source/falcon-sign.c"
 s = fpr_floor(mu);
 r = fpr_sub(mu, fpr_of(s));




 dss = fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)));




 for (;;) {
  int z, b;
  fpr x;
# 2568 "baseline/source/falcon-sign.c"
  z = gaussian0_sampler(p);
  b = falcon_prng_get_u8(p) & 1;
  z = b + ((b << 1) - 1) * z;
# 2593 "baseline/source/falcon-sign.c"
  x = fpr_mul(fpr_sqr(fpr_sub(fpr_of(z), r)), dss);
  x = fpr_sub(x, fpr_mul(fpr_of((z - b) * (z - b)), fpr_inv_8));
  if (BerExp(p, x)) {




   return s + z;
  }
 }
}


static uint64_t
ft_fpr_bits(fpr x)
{
 uint64_t w;

 memcpy(&w, &x, sizeof w);
 return w;
}

static fpr
ft_fpr_from_bits(uint64_t w)
{
 fpr x;

 memcpy(&x, &w, sizeof x);
 return x;
}

static int
ft_fpr_is_positive_finite(fpr x)
{
 uint64_t w, e;

 w = ft_fpr_bits(x);
 e = (w >> 52) & 0x7FF;
 return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
}

static int
ft_fpr_is_finite(fpr x)
{
 uint64_t w;

 w = ft_fpr_bits(x);
 return (int)(((w >> 52) & 0x7FF) != 0x7FF);
}

static int
ft_fpr_is_nonnegative_finite(fpr x)
{
 uint64_t w, e;

 w = ft_fpr_bits(x);
 e = (w >> 52) & 0x7FF;
 return (int)(e != 0x7FF && ((w >> 63) == 0 || (w << 1) == 0));
}
# 2732 "baseline/source/falcon-sign.c"
static uint64_t
ft_ct_lt_u64(uint64_t x, uint64_t y)
{
 return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
}

static uint64_t
ft_ct_eq_u64(uint64_t x, uint64_t y)
{
 uint64_t q;

 q = x ^ y;
 return 1 ^ ((q | (0 - q)) >> 63);
}

static uint64_t
ft_ct_lt_u128(uint64_t x_hi, uint64_t x_lo,
 uint64_t y_hi, uint64_t y_lo)
{
 uint64_t hi_lt, hi_eq, lo_lt;

 hi_lt = ft_ct_lt_u64(x_hi, y_hi);
 hi_eq = ft_ct_eq_u64(x_hi, y_hi);
 lo_lt = ft_ct_lt_u64(x_lo, y_lo);
 return hi_lt | (hi_eq & lo_lt);
}






static void
ft_adaptive_cdf_samples(uint64_t hi, uint64_t lo,
 int samples[5])
{
 unsigned level, u;

 for (level = 0; level < 5; level ++) {
  uint64_t z;

  z = 0;
  for (u = 0; u < 512; u ++) {
   z += ft_ct_lt_u128(hi, lo,
    ft_adaptive_cdf[level][u][0],
    ft_adaptive_cdf[level][u][1]);
  }
  samples[level] = (int)z;
 }
}
# 2790 "baseline/source/falcon-sign.c"
static int
ft_adaptive_proposal(prng *p, fpr dss, int *k,
 fpr *inv_2sigma0_sq, unsigned *proposal_level)
{
 uint64_t coefficient_bits;
 unsigned found, level, selected_level;
 int selected_sample;
 int samples[5];
 uint64_t hi, lo;

 hi = falcon_prng_get_u64(p);
 lo = falcon_prng_get_u64(p);
 ft_adaptive_cdf_samples(hi, lo, samples);

 found = 0;
 selected_level = 0;
 selected_sample = 0;
 coefficient_bits = 0;
 for (level = 0; level < 5; level ++) {
  fpr coefficient;
  uint64_t mask;
  unsigned ge, take;

  coefficient = ft_fpr_from_bits(
   ft_adaptive_cdf_inv_2sigma0_sq_bits[level]);
  ge = (unsigned)(1 ^ fpr_lt(dss, coefficient));
  take = (1U ^ found) & ge;
  mask = (uint64_t)0 - (uint64_t)take;
  selected_sample += samples[level] * (int)take;
  selected_level += level * take;
  coefficient_bits |=
   ft_adaptive_cdf_inv_2sigma0_sq_bits[level] & mask;
  found |= ge;
 }

 *k = selected_sample;
 *inv_2sigma0_sq = ft_fpr_from_bits(coefficient_bits);
 *proposal_level = selected_level;
 return (int)found;
}
# 2840 "baseline/source/falcon-sign.c"
static int
sampler_large(void *ctx, fpr mu, fpr sigma)
{
 ternary_sampler_context *tsc;
 prng *p;
 int s;
 fpr r, dss;

 tsc = ctx;
 p = &tsc->p;
 if (tsc->fault != FT_SAMPLER_FAULT_NONE) {
  return 0;
 }



 if (!ft_fpr_is_finite(mu) || !ft_fpr_is_positive_finite(sigma)) {
  tsc->fault = FT_SAMPLER_FAULT_INVALID_SIGMA;



  return 0;
 }

 s = fpr_floor(mu);
 r = fpr_sub(mu, fpr_of(s));
 dss = fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)));



 if (!ft_fpr_is_positive_finite(dss)) {
  tsc->fault = FT_SAMPLER_FAULT_INVALID_SIGMA;



  return 0;
 }
# 2898 "baseline/source/falcon-sign.c"
 for (;;) {
  int z, b;
  fpr x;


  int k;
  int64_t kk;
  unsigned proposal_level;
  fpr inv_2sigma0_sq, delta, gap, tail_term;

  if (!ft_adaptive_proposal(p, dss, &k,
   &inv_2sigma0_sq, &proposal_level))
  {
   tsc->fault = FT_SAMPLER_FAULT_PROPOSAL_RANGE;



   return 0;
  }




  b = falcon_prng_get_u8(p) & 1;
  z = b ? (1 + k) : -k;
  delta = b ? fpr_sub(fpr_of(1), r) : r;







  gap = fpr_sub(dss, inv_2sigma0_sq);
  if (!ft_fpr_is_nonnegative_finite(gap)) {
   tsc->fault = FT_SAMPLER_FAULT_PROPOSAL_RANGE;



   return 0;
  }
  kk = (int64_t)k * (int64_t)k;
  x = fpr_mul(fpr_of(kk), gap);
  tail_term = fpr_add(
   fpr_mul(fpr_of((int64_t)2 * k), delta),
   fpr_sqr(delta));
  x = fpr_add(x, fpr_mul(tail_term, dss));
# 2953 "baseline/source/falcon-sign.c"
  if (!ft_fpr_is_nonnegative_finite(x)) {
   tsc->fault = FT_SAMPLER_FAULT_NEGATIVE_X;



   return 0;
  }
  if (BerExp(p, x)) {







   return s + z;

  }
 }
}
# 3016 "baseline/source/falcon-sign.c"
static void
cleanse(void *data, size_t len)
{
 volatile unsigned char *p;

 p = (volatile unsigned char *)data;
 while (len -- > 0) {
  *p ++ = 0;
 }
}


struct falcon_sign_ {

 shake_context sc;




 shake_context rng;
 int seeded;
 int flipped;


 unsigned q;
 unsigned logn;
 unsigned ternary;
 fpr *sk;
 size_t sk_len;
 fpr *tmp;
 size_t tmp_len;
};

static void
clear_private(falcon_sign *fs)
{
 if (fs->sk != 
# 3052 "baseline/source/falcon-sign.c" 3 4
              ((void *)0)
# 3052 "baseline/source/falcon-sign.c"
                  ) {

  cleanse(fs->sk, fs->sk_len);

  free(fs->sk);
  fs->sk = 
# 3057 "baseline/source/falcon-sign.c" 3 4
          ((void *)0)
# 3057 "baseline/source/falcon-sign.c"
              ;
  fs->sk_len = 0;
 }
 if (fs->tmp != 
# 3060 "baseline/source/falcon-sign.c" 3 4
               ((void *)0)
# 3060 "baseline/source/falcon-sign.c"
                   ) {

  cleanse(fs->tmp, fs->tmp_len);

  free(fs->tmp);
  fs->tmp = 
# 3065 "baseline/source/falcon-sign.c" 3 4
           ((void *)0)
# 3065 "baseline/source/falcon-sign.c"
               ;
  fs->tmp_len = 0;
 }
 fs->q = 0;
 fs->logn = 0;
 fs->ternary = 0;
}


falcon_sign *
falcon_sign_new(void)
{
 falcon_sign *fs;

 fs = malloc(sizeof *fs);
 if (fs == 
# 3080 "baseline/source/falcon-sign.c" 3 4
          ((void *)0)
# 3080 "baseline/source/falcon-sign.c"
              ) {
  return 
# 3081 "baseline/source/falcon-sign.c" 3 4
        ((void *)0)
# 3081 "baseline/source/falcon-sign.c"
            ;
 }
 fs->seeded = 0;
 fs->flipped = 0;
 fs->q = 0;
 fs->logn = 0;
 fs->ternary = 0;
 fs->sk = 
# 3088 "baseline/source/falcon-sign.c" 3 4
         ((void *)0)
# 3088 "baseline/source/falcon-sign.c"
             ;
 fs->sk_len = 0;
 fs->tmp = 
# 3090 "baseline/source/falcon-sign.c" 3 4
          ((void *)0)
# 3090 "baseline/source/falcon-sign.c"
              ;
 fs->tmp_len = 0;
 shake_init(&fs->rng, 512);
 return fs;
}


void
falcon_sign_free(falcon_sign *fs)
{
 if (fs != 
# 3100 "baseline/source/falcon-sign.c" 3 4
          ((void *)0)
# 3100 "baseline/source/falcon-sign.c"
              ) {
  clear_private(fs);
  free(fs);
 }
}


void
falcon_sign_set_seed(falcon_sign *fs,
 const void *seed, size_t len, int replace)
{
 if (replace) {
  shake_init(&fs->rng, 512);
  shake_inject(&fs->rng, seed, len);
  fs->seeded = 1;
  fs->flipped = 0;
  return;
 }
 if (fs->flipped) {
  unsigned char tmp[32];

  shake_extract(&fs->rng, tmp, sizeof tmp);
  shake_init(&fs->rng, 512);
  shake_inject(&fs->rng, tmp, sizeof tmp);
  fs->flipped = 0;
 }
 shake_inject(&fs->rng, seed, len);
}

static int
rng_ready(falcon_sign *fs)
{
 if (!fs->seeded) {
  unsigned char tmp[32];

  if (!falcon_get_seed(tmp, sizeof tmp)) {
   return 0;
  }
  falcon_sign_set_seed(fs, tmp, sizeof tmp, 0);
  fs->seeded = 1;
 }
 if (!fs->flipped) {
  shake_flip(&fs->rng);
  fs->flipped = 1;
 }
 return 1;
}


int
falcon_sign_set_private_key(falcon_sign *fs,
 const void *skey, size_t len)
{
 const unsigned char *skey_buf;
 int comp;
 int16_t ske[4][3072];
 int i;
 int fb, has_G;
# 3167 "baseline/source/falcon-sign.c"
 clear_private(fs);
 if (skey == 
# 3168 "baseline/source/falcon-sign.c" 3 4
            ((void *)0) 
# 3168 "baseline/source/falcon-sign.c"
                 || len < 1) {
  goto bad_skey;
 }
# 3190 "baseline/source/falcon-sign.c"
 skey_buf = skey;
 fb = *skey_buf ++;
 len --;
 fs->logn = fb & 0x0F;
 has_G = !(fb & 0x10);
 fs->ternary = fb >> 7;
 if (fs->ternary) {
  fs->q = 18433;
  if (fs->logn != 10) {
   goto bad_skey;
  }
 } else {
  fs->q = 12289;
  if (fs->logn < 1 || fs->logn > 10) {
   goto bad_skey;
  }
 }
 comp = (fb >> 5) & 0x03;





 for (i = 0; i < 3 + has_G; i ++) {
  size_t elen;

  elen = falcon_decode_small(ske[i], fs->logn,
   comp, fs->q, skey_buf, len);
  if (elen == 0) {
   goto bad_skey;
  }
  skey_buf += elen;
  len -= elen;
 }
 if (len != 0) {
  goto bad_skey;
 }




 if (!has_G) {
  if (!falcon_complete_private(ske[3],
   ske[0], ske[1], ske[2], fs->logn, fs->ternary))
  {
   goto bad_skey;
  }
 }




 if (fs->ternary) {
  fs->sk_len = ((size_t)(3 * (fs->logn + 6)) << (fs->logn - 1))
   * sizeof(fpr);
  fs->tmp_len = ((size_t)21 << (fs->logn - 1)) * sizeof(fpr);
 } else {
  fs->sk_len = ((size_t)(fs->logn + 5) << fs->logn)
   * sizeof(fpr);
  fs->tmp_len = ((size_t)7 << fs->logn) * sizeof(fpr);
 }
 fs->sk = malloc(fs->sk_len);
 if (fs->sk == 
# 3252 "baseline/source/falcon-sign.c" 3 4
              ((void *)0)
# 3252 "baseline/source/falcon-sign.c"
                  ) {
  goto bad_skey;
 }
 fs->tmp = malloc(fs->tmp_len);
 if (fs->tmp == 
# 3256 "baseline/source/falcon-sign.c" 3 4
               ((void *)0)
# 3256 "baseline/source/falcon-sign.c"
                   ) {
  goto bad_skey;
 }

 if (fs->ternary
  && !ft_validate_ternary_private(ske[0], ske[1], ske[2], ske[3],
   (int64_t *)(void *)fs->tmp))
 {
  goto bad_skey;
 }
 memset(fs->tmp, 0, fs->tmp_len);
 if (!load_skey(fs->sk, fs->q, ske[0], ske[1], ske[2], ske[3],
  fs->logn, fs->ternary, fs->tmp))
 {
  goto bad_skey;
 }
 return 1;

bad_skey:
 clear_private(fs);
 return 0;
}


int
falcon_sign_start(falcon_sign *fs, void *r)
{
 if (!rng_ready(fs)) {
  return 0;
 }
 shake_extract(&fs->rng, r, 40);
 falcon_sign_start_external_nonce(fs, r, 40);
 return 1;
}


void
falcon_sign_start_external_nonce(falcon_sign *fs, const void *r, size_t rlen)
{
 shake_init(&fs->sc, 512);
 shake_inject(&fs->sc, r, rlen);
}


void
falcon_sign_update(falcon_sign *fs, const void *data, size_t len)
{
 shake_inject(&fs->sc, data, len);
}


size_t
falcon_sign_generate(falcon_sign *fs, void *sig, size_t sig_max_len, int comp)
{
 uint16_t hm[3072];
 int16_t s1[3072], s2[3072];
 unsigned char *sig_buf;
 size_t sig_len;

 if (fs->sk == 
# 3315 "baseline/source/falcon-sign.c" 3 4
              ((void *)0)
# 3315 "baseline/source/falcon-sign.c"
                  ) {
  return 0;
 }
 if (!rng_ready(fs)) {
  return 0;
 }
 if (sig_max_len < 2) {
  return 0;
 }
 shake_flip(&fs->sc);
 falcon_hash_to_point(&fs->sc, fs->q, hm, fs->logn);


 uint32_t sign_loop_attempts = 0;

 for (;;) {

  if (++ sign_loop_attempts > 16) {
   return 0;
  }
# 3346 "baseline/source/falcon-sign.c"
  prng p;
  ternary_sampler_context tsc;
  samplerZ samp;
  void *samp_ctx;





  if (fs->ternary) {
   falcon_prng_init(&tsc.p, &fs->rng, 0);
   tsc.fault = FT_SAMPLER_FAULT_NONE;
   samp = sampler_large;
   samp_ctx = &tsc;
  } else {
   falcon_prng_init(&p, &fs->rng, 0);
   samp = sampler;
   samp_ctx = &p;
  }







  do_sign(samp, samp_ctx, s1, s2,
   fs->q, fs->sk, hm, fs->logn, fs->ternary, fs->tmp);
  if (fs->ternary && tsc.fault != FT_SAMPLER_FAULT_NONE) {
   return 0;
  }
# 3385 "baseline/source/falcon-sign.c"
  {
   int short_ok;

   short_ok = falcon_is_short(s1, s2, fs->logn, fs->ternary);
# 3402 "baseline/source/falcon-sign.c"
   if (short_ok) {
    break;
   }



  }
 }

 sig_buf = sig;
 sig_len = falcon_encode_small(sig_buf + 1, sig_max_len - 1,
  comp, fs->q, s2, fs->logn);
 if (sig_len == 0) {



  return 0;
 }
 sig_buf[0] = (fs->ternary << 7) | (comp << 5) | fs->logn;
 return sig_len + 1;
}
