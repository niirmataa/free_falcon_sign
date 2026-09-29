# Nowy source mean/delta refinement, bez zmiany ZERO

Źródło i premise NumericCenter są dokładnie przypiętymi ZERO/FLOOR. Stary
generic E_r=2^-20 pozostaje poprawny. Tutaj wykorzystujemy silniejszy case
analysis z ZERO/ANALYTIC_PROOF §5 i rzeczywiste source alignment/pack, nie
postulujemy IEEE subtraction dla subnormals.

- ±0: source(+0) ma s0,r0; source(−0) ma s−1,r1. W obu m_hat=val(mu)=0.
-0<mu<1: normal input wraca exact przez add(x,−0); subnormal jest flushowany
  do+0, z błędem<2^-1022.
-mu≥1 lub mu≤−1: exact of(s) i input mają ratio magnitudes[1/2,2], exponent
  difference0 lub1. Mantissas×8 dają exact alignment, cancellation ma≤53
  significant bits, normalize/shrink/pack nie tracą informacji (source Sterbenz).
  Nonzero difference od integer jest≥2^-53, więc nie underflowuje.
-−1<mu≤−1/2: ten sam source Sterbenz z |s|=1.
-−1/2<mu<0: większy operand+1 ma encoded exponent1023. W ogólnym source
  error proof ZERO lambda=2^(1023−1078)=2^-55, więc błąd≤13*2^-55+2^-1021
  <**2^-51**. Obejmuje decode/clamp negative subnormal. To exact QQ instance
  tego samego source phase argumentu; kernel specialized_center_error sprawdza
  scaled inequality13u+1<16u dla u=2^966>0.

Zatem dla wszystkich NumericCenter words **|m_hat−m|≤2^-51**, także raw−0.
Dla delta_C=sub_C(1,r_C), oba operands mają encoded exponents≤1023 i source
values[0,1], więc ten sam specialized bound daje
|val(delta_C)−(1−val(r_C))|≤2^-51. Source positivity/range[0,1] pozostaje z ZERO;
nie jest wnioskiem tylko z małego absolute error.

True precision d=1/(2val(sigma)^2). Certified widths są normal, sigma²>1,
twice-square<2048. Dwie source mul i div mają relative error≤u'=U+4096η
(U=2^-48,η=2^-900) po jawnych lower/upper operand bounds. Stąd
(1−u')/(1+u')²≤d_hat/d≤(1+u')/(1−u')² i
**|d_hat/d−1|≤2^-45**. reduction_domain.py sprawdza exact rational inequalities.

Na proposal window k≤K_j mamy |y−m_hat|≤K_j+1. Dla d_hat≤d_hi:

```
|d_hat(y−m_hat)²−d(y−m)²|
 ≤ d_hi/(1−eps_d) * [eps_d*(K_j+1)²+2(K_j+1)eps_m+eps_m²].
```

Per-bank/class values są w REDUCTION_DOMAIN.json. Poza window nie stosujemy
tego bounded-distance argumentu; używamy jawnego Gaussian infinite-tail boundu.
Nie ma założenia integrality/reference recovery lub przyszłego norm acceptance.
