# Safe16 pozostaje otwarte — nie zmieniamy programu

Po source rint zdefiniuj w1,w2:Fin1536→Int z actual int64 results. Definicje:

```
Safe16(w1,w2) := ∀i, -32768≤w1_i≤32767 ∧ -32768≤w2_i≤32767
BadPrecast := ¬Safe16
narrow16(w) := (w+32768) mod65536−32768          [mathematical Int]
```

W GCC14.2 x86_64/LP64/C99 signed conversion do int16 redukuje modulo2^16
i interpretuje reprezentację two's-complement. Jest implementation-defined,
nie undefined signed overflow. Rint int64 jest w dowiedzionej domenie.
Nie wykonujemy powyższego wzoru jako C signed addition na dowolnym int64.
Zatem source stores są zawsze s1=narrow16(w1),s2=narrow16(w2).
Kernel narrow_range, narrow_preserves_iff i joint_preserves_iff dowodzą:
exact preservation obu wektorów **iff** Safe16. Source nie ma dodatkowego
abort/clip/resample na BadPrecast, więc nie dopisujemy takiego zdarzenia do Sign.

## Wynik badania required histories

Po whole-root correlated reconstruction i source rounding najsilniejszy
eksportowany tutaj uniform bound to |w1_i|,|w2_i|≤4572095. Jest poprawny,
ale niewystarczający do signed16. Większość tego boundu pochodzi z all-history
terminal weighted-energy support, a nie iFFT roundoff≤1/128. Nie dowodzi
istnienia dużego actual output, nie jest counterexample ani tail estimate.
Nie wykazano uniwersalnego Safe16 i nie obalono go w REQUIRED domenie.

Failed route: Q(s1,s2)<B jest testem PO casts; nie dowodzi Q(w1,w2)<B lub Safe16.
Założenie przyszłego norm acceptance byłoby kołem. M0 capacity to theorem
o stored signed16, niezależny od value preservation przed store.

Wykonany source-slice witness `suffix_extended_wrap`: syntetyczna basis
[1,1,0,0], x=FFT_C(65536),y=0 daje w1_0=w2_0=65536, stored s1=s2=0,Q=0.
Normal/ASan/UBSan i independent model są zgodne. To **EXTENDED_LOCAL_SUFFIX**,
det basis0≠q: brak P_key, Emitted i actual sampler-history membership. Obala
wyłącznie ogólną implikację future norm⇒precast; nie obala main-domain theorem
i nie jest zgłoszeniem błędu produkcyjnego.

## Joint event i warunkowy consumer

Dla rzeczywistej próby j, C_j oznacza: próba została osiągnięta i jej sampling
oraz deterministyczny suffix ukończyły się w wymaganej legalnej domenie.
Bad_j=C_j∧∃i,(w1_ji∉[-32768,32767]∨w2_ji∉[-32768,32767]).
WholeCallBad=∃j<16,Bad_j, obejmuje także ukończone norm-rejected attempts,
nie tylko ostatnią zaakceptowaną. Wartości w_j dla nieukończonych prób są
nieobserwowane; dowolne total extensions definicji nie zmieniają event dzięki C_j.

Consumer: dla każdego C_j∧¬BadPrecast, actual stored vectors równe w1,w2;
wtedy norma i bytes mogą być przepisane na te w. Bez tej przesłanki używa się
wyłącznie narrow16(w). Nie przypisano η_pre, independence, probability zero
ani Gaussian tail. Zadanie SOURCE_SAMPLER_LAW/H6P musi samo wyprowadzić law
rzeczywistej causally ordered historii, a następnie potrzebny joint estimate
w tej samej grze/K_seed[E], z retry/conditioning bookkeeping.

Reference integer recovery to osobna luka: potrzeba niezależnego exact pair
z coefficient target/sample history, integrality/congruence i source-to-reference
error/tie-gap. Rounding actual word, even tie i byte round-trip nie dają tego.
