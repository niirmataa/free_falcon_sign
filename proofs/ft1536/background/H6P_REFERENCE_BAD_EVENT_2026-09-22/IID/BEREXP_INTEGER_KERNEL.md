# Dokładny integer BerExp, bez założenia exp accuracy

Source2469–2513 i fpr-emulated.h237–283. Required scalar inputs z ORDERED mają
x sign0,finite,0≤val(x)<2^19. e=floor_C(mul_C(x,inv_ln2)) jest integer
0≤e<2^20; rB=sub_C(x,mul_C(of_C(e),log2)) finite,|rB|<2^21. Te coarse
bounds, nie komentarz393 i nie przedział[0,log2), są wystarczające do definedness.

## 1. Actual expm word transducer i high product

mul_C(rB,p63) ma input operands≤2^100 i output magnitude<2^85. Source trunc
jest RAW transform: hidden mantissa, cc=1085−ex, shift cc&63, mask z
uint32(cc−64)>>31, unsigned sign reconstruction, final GCC int64 decode.
cc∈[-962,1085] dla wszystkich64-bit words, wszystkie masked shifts0..63,
int casts ex i cc arithmetic są signed32-safe. Natychmiastowy cast uint64
w expm odtwarza te same bits. Dla dużych/coarse lub negative inputs NIE
zastępujemy tego mathematical truncation. Np.raw word2^64 daje raw trunc1,
a nie mathematical integer2^64. Mała dodatnia domena z ACCEPTANCE_FLOOR
posiada odrębny exact-floor refinement.

Zdefiniuj z=(raw_trunc_bits(mul_C(rB,p63))<<1) mod2^64;
y0=C0, y_u=(C_u−high64(z*y_(u−1))) mod2^64 dla u1..12, literal13 coefficients.
Source high64 jest dokładnym high product, nie założeniem audit sample:
niech B=2^32,x=x0+B*x1,y=y0+B*y1, wszystkie limbs<B.

```
a=x0*y1+floor(x0*y0/B), b=x1*y0,
c=floor(a/B)+floor(b/B)+floor((a modB+b modB)/B)+x1*y1.
```

Binomial expansion i quotient/remainder decomposition dają c=floor(x*y/B²).
a≤B²−B−1, b≤(B−1)², low-limb sum<2B. c<B², więc także wszystkie
nonnegative partial additions c są bounded; source uint64 operations tutaj
nie tracą carry. Kernel limb_expansion/high_carry/first_limb_sum_bound/
high_product_range zamyka integer argument. Horner subtractions na ogólnej
domenie mogą wrapować; source/model zachowują wrap,12 bounded iterations.

## 2. Dwa word tests i ich liczności

sw=e<2^20; unsigned over=(63−sw)>>31 jest0 iff e≤63, otherwise1;
safe_s=min(e,63). Shifts są legalne. w0 XOR((w0>>safe_s)<<safe_s) to dokładnie
low safe_s bits. Test zero ma dla e≤63 liczność2^(64−e); przy e0 akceptuje
każdy word. Przy e≥64 over mask zeruje b. Drugi get_u64 i expm nadal się
wykonują: source nie ma short-circuit return po pierwszym teście.

Z=y12>>8 zawsze0≤Z<2^56. W=w1&(2^55−1) jest uniform low55 word, niezależny
od w0 i wcześniejszego U/sign przez fresh bytes. Każde W ma2^9 preimages.
Ponieważ −2^56<W−Z<2^55, uint64 borrow/top bit
`((W−Z) mod2^64)>>63` jest1 dokładnie gdy W<Z. Kernel unsigned_low55_comparison
sprawdza ten zakres; liczba takich W to **min(Z,2^55)**, ze strict endpoint.

Stąd dla KAŻDEGO required source x word:

```
Beta_C(x)=0                                  gdy e>=64,
Beta_C(x)=min(Z,2^55)/2^(e+55)                gdy 0<=e<=63.
```

Z=0 daje zero acceptance; Z=2^55 i większe daje saturation drugiego testu1.
Wyższe9bits w1 są ignorowane tylko przez test, ale zostały odczytane i należą
do past. Dokładna probability to wynik integer counts, nie exp(-x). Nie
udowodniono remainder-in-log2 ani Gaussian comparison. All source x/rB/expm/Z
words i Horner intermediates kontrolowane native normal/ASan/UBSan oraz
niezależnymi high-product/dyadic/QQ calculations; reduced enumerations są
kontrolą bindingu, a nie zastępstwem universal range/count proofu.
