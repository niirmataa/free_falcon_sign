# FPEMU — osobna oś stałoczasowości

**Wynik: `TIMING_EVIDENCE` (statyczny compiled control flow) oraz
`TIMING_NOT_RUN` (dudect/ctgrind). Nie ma statystycznego PASS ani proof CT.**

## Przypięta kompilacja

- GCC Debian14.2.0-19, C99, Linux x86_64/LP64. `TOOLCHAIN.txt` zawiera
  pełne wersje i hashe narzędzi. `scripts/common.py:flags()` parsuje dokładne
  CFLAGS z przypiętego Makefile. Zachowane `-W -Wall -O` i wszystkie makra
  profilu; C99 i include directory są jawnie dołączone w harnessie.
- Analiza statyczna używa niesanitizowanego builda. Cztery oryginalne TU
  skompilowano oddzielnie, bez uruchamiania KeyGen/Sign: FPEMU, FFT, Sign,
  KeyGen. `.s` i receipts mają własne SHA-256 w `production_asm.json`.
- Oryginalny `falcon-sign.o`:
  `96c7119941ccdfff4d1a36379a5f2991e4a7dd4709dc07cc858ba83eeb0efe88`.
- `checks/wrappers.c` zapewnia widoczne entry points inline helpers;
  `artifacts/disassembly.txt` i `assembly_control_flow.json` zawierają pełny
  objdump/indeks skoków, nie tylko wybrane ilustracje.

## Source flow i pamięć

Portable scaled/add/mul używają maskowania i stałej liczby etapów. Div ma55,
sqrt54 iteracje; zależne od danych porównania są kodowane maskami. Pack
`0xC8 >> f` jest przesunięciem stałej, nie sekretnym dostępem do tablicy.
Pętle expm (12 kroków) i log (31 kroków) indeksują stałe w publicznej kolejności.
Nie stwierdzono secret-indexed memory access w tych prymitywach. Tablice FFT
są indeksowane publicznym rozmiarem i numerem butterfly; nie dowodzi to
stałoczasowości otaczającego Sign.

Objdump: scaled nie ma branch; add/mul używają cmov; div/sqrt mają tylko
fixed-count loop branch. rint/trunc, max i high64 w wrapperach nie mają
operand-dependent conditional jump. To obserwacja tych bajtów maszynowych,
nie dowód czasów instrukcji na każdym CPU. `fpr_max` nie ma aktywnego call-site.
Sincos ma source switch/compiled branches zależne od kwadrantu, lecz gauss
jest wyłączone przez TRUE_TERNARY_SECRET=1; nie jest używaną ścieżką FT1536.

### F02: gałąź floor przy rzeczywistym -O

W `audit_floor`, `artifacts/disassembly.txt:618-642`:

```asm
shr $0x34, %rdx
and $0x7ff, %edx
sub $0x3fe, %esi
js  <return-sign>
```

Warunek to `encoded_exponent < 1022`, czyli dla finite wejścia `|x|<1/2`.
Np. +1/4 i +3/4 są legalnymi NumericCenter, a mają różny branch trace.
Wybrany GCC zoptymalizował maskę `fpr-emulated.h:131` do skoku.

**Potwierdzenie w oryginalnym TU**, nie tylko we wrapperze:
`artifacts/falcon-sign.s:1911` (BerExp), `:2195` (sampler), `:2908`
(aktywny sampler_large, floor z `falcon-sign.c:2864`). Pełne sąsiedztwo
w `artifacts/production_asm.json`. Nie konstruowano emitted-KeyGen witnessa
dwóch takich historii Sign ani nie mierzono wielkości wycieku.

Makefile:33 „CT-safe: -O only ... jitter in dudect” jest komentarzem, bez
wersjonowanego raportu z odpowiednim current binary/source pin w bootstrapie.
Znaleziona gałąź wyklucza przyjęcie tego komentarza jako blanket fixed-trace
gwarancji FPEMU. Nie wynika z tego, że wszystkie pozostałe prymitywy przeciekają.

### Co daje CT_BEREXP

`falcon-sign.c:66-93` opisuje stałą liczbę wywołań PRNG na jedną ocenę
BerExp. Aktywne `:2481-2510` ma dwa odczyty u64 i bezpieczny shift/cutoff.
Makro nie certyfikuje kodu floor/redukcji, stałego czasu PRNG refill,
liczby powtórzeń rejection loop (`:2898-2971`), fault branches, norm retries,
KeyGen ani całego Sign. W obecnej gałęzi CT_BEREXP=1 jest wymogiem kompilacji.

## Narzędzia i warunki

`artifacts/timing_tools.json`: dudect/ctgrind/valgrind nie znaleziono w PATH.
Nie znaleziono plików z nazwą dudect/ctgrind w jawnie sprawdzonych katalogach:

1. `/home/footfalcon/free_falcon_sign/tests`;
2. `/home/footfalcon/free_falcon_sign/.build`;
3. `/media/footfalcon/16AA-3188/FALCON_FPEMU_ternary_clean_648e3b9/tools`.

To kontrola tych lokalizacji, nie twierdzenie o wszystkich dyskach. Nie
pobrano ani nie zainstalowano narzędzia; nie czytano historycznych prywatnych
pomiarów. Obecny host zgłasza Intel Core5 210H, Linux6.12.107+deb13-amd64,
affinity0..11; snapshot loadavg `2.30 1.94 1.65` jest w platform receipt.
Warunki maszyny/hiperwizora i równoległego NODE2 nie zostały kontrolowane.

**Prób czasowych: 0. Klasy zmierzone: brak. Welch t/p-value: N/A.**
Czasy wall zapisane przez executor służą limits/receipts i nie są pomiarem
zależności czasu prymitywów. Żadnego własnego pomiaru nie nazwano dudect.

## Dokładny przepis następnego pomiaru

1. W osobnym zleceniu dostarczyć publiczny dudect z commit ID i SHA-256
   każdego używanego pliku oraz odpowiadający jego API harness. Brak tego
   pinu jest pierwszą konkretną blokadą; nie wolno wpisać fikcyjnego tool hash.
   Target ma wywoływać identyczne prymitywy jak `checks/wrappers.c`.
2. Build niesanitizowany: GCC14.2, dokładne `common.flags()`, bez zmiany
   optymalizacji lub march; osobny wariant target `.o` i końcowy binary hash.
   Zarchiwizować cały argv, compiler/CPU/microcode/kernel, disassembly i source
   manifest. Nie przenosić wyników wariantu -O3/-march=native na -O.
3. Gospodarz kończy równoległą pracę; rezerwuje jeden fizyczny core i jego
   SMT sibling, ustala governor/turbo i zapisuje ich rzeczywiste ustawienia.
   `taskset -c CPU` ustawia affinity; CPU należy wybrać z aktualnej topologii,
   nie założyć, że CPU0 i CPU1 są osobnymi cores. Udokumentować idle/load
   przed/po i VM/host interference. Bez takich warunków wynik INCONCLUSIVE.
4. Osobne eksperymenty, publiczne balanced classes i świeże przygotowanie
   poza timed region: floor `{0x3fd0000000000000}` vs
   `{0x3fe8000000000000}`; następnie oba znaki i losowane publiczne mantissy
   przy exponent1021 vs1022; add equal-sign vs cancellation; mul significand
   carry/no-carry; div mianowniki na krańcach [1/16,2^35]; sqrt parzysty/nieparzysty
   wykładnik; rint ties/non-ties; expm r=0 vs near log2. Wszystkie operands
   mają preflight z independent oracle. Badamy oddzielne targets, nie mieszankę
   różnych funkcji w jednej klasie.
5. Po 10 000 warmup, po **1 000 000 prób na klasę** na eksperyment, trzy
   niezależne publiczne kolejności balanced shuffle, maks.120s wall na partię
   100 000 prób. W receipts zapisać rzeczywistą liczbę próbek, batch schedule,
   t-statystykę i stop condition z przypiętej wersji dudect, a także pełny stdout.
   Publiczność fixtures nie znosi potrzeby randomizowania kolejności klas.
6. Controls: identyczna target/class distribution (negative control),
   jawnie różna zależna pętla w osobnym publicznym control target (positive
   control), volatile sink/barriers chroniące przed usunięciem pracy.
   Raportować statystyki kontroli i wszystkie próby, nie tylko najlepszy run.
7. Nie stwierdzać proof CT przy braku sygnału. F02 pozostaje strukturalnym
   kontrprzykładem fixed branch trace niezależnie od testu statystycznego.
   Dla ctgrind wymagany jest osobny wersjonowany tool i taint scope operands,
   z kontrolą pozytywną; jego wynik też nie zastępuje caller reachability.

## Związek z M0

M0/HOP_LEDGER:149-151 i M0/REPORT:92 jawnie wyłączają timing disclosure
z bieżących obserwacji gry. F02/F07 mają własny cel badawczy. Nie odejmujemy
ani nie dopisujemy na ich podstawie epsilon do istniejącej redukcji.
