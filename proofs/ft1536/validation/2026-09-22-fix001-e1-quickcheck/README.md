# S01/FIX_001 i S06/E1 — szybka kontrola,2026-09-22

Recenzent: GPT-6 Astra. Zlecenie właściciela: szybko sprawdzić przedstawione
poprawki i wskazać stan Git do późniejszego push. **QUICKCHECK_ONLY**;
nie jest to końcowy scoped PASS S01 ani odbiór całej kampanii S06.
W: `proofs/ft1536/work/FT_FAMILY_FIX001_E1_QUICKCHECK_2026-09-22`.

## S01 — ustalenia

- FIX_001 REPORT `33d69dad2fecc91651830559d9f5e43f73144f99925501cbcd23c7ae9b561e25`,
  OUTPUTS `d24d531cd202c5f8b46835dd5864458bb48fd02d7243d0e360f01b9a56d5bd39`:
  116/116 członków zgodnych. Piny odczytane z lokalnego HANDOFF/postfreeze.
- Frozen poprzednik RUN_003 OUTPUTS `9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e`:
  100/100 członków zgodnych. W całym manifeście FIX:28 zmienionych,17 dodanych,
  usunięty1 `.pyc`; autorskie15 diffów dotyczy wybranego zestawu źródeł/tekstu.
- **I1/R1:** ATTACK_PROBLEMS §1 i N3 rzeczywiście rozdzielają punktową
  ekstrakcję od warunkowej nierówności przewag. N3 ma świeżą wiadomość,
  własny indeks celu i jawny privileged/toy witness. Nie jest konstrukcją
  forgera lub dowodem symulatora. Te poprawki odpowiadają uwadze I1.
- **I2/R5:** niezależna rekurencja QQ + MPFI768 potwierdza nowy przedział,
  ogon≈2.9925420736e-9 i `2^-40 < tail < 2^-28`. Półszerokość certyfikatu
  ≈1.0595040170e-82. `.exact_rational()` poprawnie usuwa problem gwarancji
  konwersji. Poprzedni margines ±2·rad TAKŻE obejmował kulę dla tego x;
  zdanie autora,że margines nie pokrywałby błędu,nie opisuje tego przypadku.
- **Pozostała errata R5:** `tail_interval.precision_note` nadal nazywa
  ≈1.06e-82 promieniem Arb,chociaż pola liczbowe poprawnie rozróżniają
  `arb256_ball_radius_abs_display`≈5.30e-83 i półszerokość≈1.06e-82.

**Pozostała uwaga replayu (wymagana już w poprzednim odbiorze):**
`scripts/replay.py:185–188` kopiuje źródłowy pakiet z produktami semantic/PDF,
a `:217–220` usuwa tylko `byte_deterministic`. `semantic_only`,PDF i pliki
pomocnicze PDF pozostają. Ponadto `:285` nie uzależnia FRESH_REPLAY_PASS od
powodzenia kroków semantic/PDF. Węższy PASS jest jawnie opisany,ale nie dowodzi
pełnego fresh replayu. Samo wyłączenie pliku z porównania bajtowego nie zapewnia
jego świeżości. Przed finalnym scoped PASS należy usunąć wszystkie regenerowane
produkty przed producentami i rozliczyć osobno ich rzeczywiste wyjścia/logi
oraz świeży PDF. Autorskich18/18 nie przedstawiam jako mojego replayu.

## S06/E1 — ustalenia

Odczytany wynik ma SHA `25021a4bda321fb6803d709a8913c92a23d6cb4848c72e4509e59ada7644a03b`.
Na dostarczonych exact moments niezależnie sprawdziłem MPFI256 wszystkie
kandydaty β w zakresie100…dim,oddzielając ujemny gap od overlapu przedziałów:

| N | β_full | skończone β_sub | brak przecięcia100…dim |
|---|---:|---|---:|
|768|462|6×637 oraz758|0|
|1536|1077|4×1518 oraz2×1519|1 (u=4607)|
|3072|2409|brak|7|

13 skończonych przecięć i8 przypadków braku przecięcia;0 niejednoznacznych
porównań. `u=2177,N=768 → 637` potwierdzone. Wymiar `n=N/2,dim=N`,
`sigma_sq=E[Q]/n` i zapisany podział raw−mean=variance zgodne dla21 wierszy.
Nie przeprowadzałem ponownego dowodu wzorów momentów/geometrii/liftu.

Poprawny wniosek: dla13 skończonych wyników β_sub>β_full; dla8 pozostałych
badany warunek nie zachodzi w zakresie do capu. `None` nie jest liczbą β.
To wynik określonego modelu i zakresu wyszukiwania,z LIFT OPEN.

Przed finalizacją runnera: dokładne ujemne `centered_var` ma zgłaszać błąd,
zamiast być zamieniane na zero (`subfield_normdown_v2.sage:163–164`).
Niepewne porównanie przedziałowe ma dostać osobny status,nie NO_CROSSING;
na obecnych21 wierszach niezależna kontrola nie znalazła overlapu ani ujemnej
wariancji. E2–E5 pozostają niezakończone zgodnie z handoffem autora.

## Wykonanie i historia prób

`sage quickcheck.sage`,SageMath10.9,preparser,QQ/ZZ + MPFI768/256,Arb256
dla kontroli starego marginesu. Bwrap:network-off,root RO,prywatny trwały W,
8GiB,limit120s. Ostateczny run003:exit0,4.18s,czysty stderr.
Źródło `.sage`,NUMERIC_CHECKS,INPUTS,receipty i raw logs są dołączone.

Próby techniczne zachowane z rzeczywiście uruchomionymi źródłami:
v1:QQ nie przyjął decimal-string → dokładny parser ZZ/10^digits;
v2:matematyczne asercje przeszły,eksport JSON odrzucił Sage Integer →
serializer integerów. Bez zmiany wartości/warunków matematycznych.

## Stan publikacji

**S01 nie otrzymuje tu finalnego scoped PASS; publikacja pozostaje wstrzymana
do domknięcia powyższej uwagi.** Docelową gałęzią push jest istniejący
`main`,po archiwizacji odebranego FIX_001 i jego odbioru oraz aktualizacji
STATE. W nie przechodzi do Git przez samo istnienie plików. E1 i trwająca
naprawa E2–E5 nie są jeszcze odebranym finalnym pakietem S06.

Workflow B20 przywrócono w `4a96d2d`: work → review → zaakceptowane stages
→ commit main;112 plików instrukcji/indeksów uaktualnionych,20+20 zadań i
formalna treść specs bez zmiany. Przygotowany odbiór T02.1 zachowuje `4defee3`.
Żaden z tych lokalnych commitów nie stanowi polecenia push.
