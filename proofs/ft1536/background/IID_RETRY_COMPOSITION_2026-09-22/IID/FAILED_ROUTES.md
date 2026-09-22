# Nieudane próby, odrzucone skróty i granice

## Zachowane rzeczywiste failed executions

- IidBerExp initial: unused positive-divisor premise i nieudany rewrite
  warunku cutoff przez equality of Props. Usunięto zbędną premise, cutoff
  udowodniono bezpośrednim range split/omega. Pełna wersja/log w
  artifacts/attempts/berexp_initial; nie wyciszano lintera.
- IidCDF base case: rfl nie redukował0+count. Zastąpiony simp/count definition;
  artifacts/attempts/cdf_append_base.
- IidRejection initial: brak unqualified pow_succ, induction hypothesis z
  niepotrzebnym fixed-a equality i unused simp. Poprawiono Int.pow_succ,
  subst i base simplification; artifacts/attempts/rejection_initial.
- Sage QQ constructor z dwoma args nie był poprawnym tworzeniem fraction;
  NotImplementedError zachowany w attempts/rational_constructor. Użyto
  jawnego QQ(numerator)/denominator. Nie zmieniono mathematical target.

Wszystkie final Lean logs są clean; wcześniejsze failures/receipts pozostają
w authoritative scope. Native normal/ASan/UBSan kontrole przeszły bez rozbieżności.

## Faktycznie wykonane mutacje / countermodels

13 meaningful mutations i no-op, complete baseline/changed evidence w
artifacts/mutations: CDF<→<=, last zamiast first bank, różneU w każdym banku,
reuse Bernoulli word, brak saturation, brak cutoff, early BerExp read-return,
ptr>4087, big endian, brak suffix drop, conditioning na unread buffer,
nonreturn→normal0 i normalization przyA0. No-op zachował wynik.

Saturation countermodel jest extended valid comparator-domain Z=2^55+1,
bez source-reachable Z claim. Bad-conditioning countermodel enumeruje dwie
IID bits: marginal Y jest uniform, po conditioning na unread Y=0 już nie.
Zero-normalizer to abstract rejection kernel poza required source instance;
pokazuje konieczność udowodnienia dodatniości przed w/A. Infinite all-zero
continuation dotyczy local legal scalar envelope mu0,sigma RN(4/3), nie
emitted/source-history membership. Bounded observed prefix ma124 rejections
i jawny HARNESS_EXHAUSTED/NONE. Nie jest zgłoszeniem nowego błędu C.

## Skróty, których nie wolno konsumować

- Komentarze exp(-x),remainder[0,log2),e<=393 nie są przesłankami tego prawa.
  Exact raw threshold/kernel obejmuje coarse source remainder i cutoff.
- fpr_trunc przy word2^64 daje raw bits1; mathematical trunc jest dowiedziony
  tylko w małej dodatniej domenie użytej dla acceptance floor.
- Positive ideal exp nie gwarantuje dodatniego integer Z. Nowy proof używa
  k0,smaller delta,z≤2^63 i całego Horner interval do Z≥2^54+92.
-33 returned bytes nie znaczy33 wygenerowane bytes; suffix drop jest do9,
  get_u8 może refillować po odczycie, ptr4087 już refilluje dla u64.
- Fixed public fixture nie jest IID sample ani proof PRNG uniformity.
- Full-buffer conditioning niszczy świeżość. Wszystkie prawa mają PAST
  filtrację; fresh-tail wynika ze stopping-time argumentu.
- A.s. IID nie oznacza all-tapes/real-source termination, ideal Gaussian,
  full ordered joint law, Safe16, Sign→Verify lub security. POST pozostaje partial.

Nie stwierdzono required-domain counterexample. Otwarty real-PRNG bridge
jest osobnym obowiązkiem kryptograficznym, nie brakującą przesłanką ukrytą
wewnątrz już nazwanej idealnej gry IID_BUFFER.
