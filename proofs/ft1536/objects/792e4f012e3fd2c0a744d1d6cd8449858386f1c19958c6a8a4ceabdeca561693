# GPT-ASTRA — H3_ROOT_LDL: źródłowy certyfikat korzenia drzewa

Data: 2026-09-19. Autor projektu: Niirmata.
Kontynuacja tej samej rozmowy po odebranym H3_ZERO_SCALAR.

## 0. Jeden następny obowiązek

Wyprowadź **jednostajny numeryczny certyfikat korzenia rzeczywistego
subtractive LDL** dla emitted-KeyGen support M0: źródłowe FFT klucza,
root Gram, root divisor, multiplier L oraz obliczone przez odejmowanie d11.
To pierwsza konkretna podteza potrzebna do internal-tree bounds, a następnie
do globalnego `Reach_call_C -> NumericCenter`.

H3_ZERO_SCALAR ma status `H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL`, niezależny
replay95/95 i97 twierdzeń (48 nowych). Lokalny residual bound366+2^-20 jest
gotowy po NumericCenter. Ten etap dostarcza wcześniejszy certyfikat drzewa;
nie przyjmuje NumericCenter jako założenia do dowodu własnych root bounds.

Zakres: **korzeń 2x2 i jego źródłowe wejścia**. Rekurencyjne LDL_dim3/inner,
centra i pełne prawo Sign mają kolejne obowiązki. Wynik może być dowodem,
nowym partial albo precyzyjnie sklasyfikowanym wynikiem negatywnym.
Wykonaj pracę do raportu, freeze i standardowego replayu.

## 1. W i wejścia

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_ROOT_LDL_RUN_001
IN = W/inputs/bootstrap
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_ROOT_LDL_2026-09-19.md
BASE = 9a76ecfd72d83e131d79299f0249bca1efdf9468
```

Przeczytaj REPO/AGENTS i W/AGENTS; potwierdź cwd, rzeczywisty sandbox tylko W
i brak drugiego wykonawcy. REPO ma własny wcześniejszy checkout/indeks.
Źródłem zadania jest gotowy bootstrap, nie REPO/Extra/c. Nie zmieniaj Git.

Zestaw `proofs/ft1536/background/H3_ROOT_LDL_2026-09-19/` ma104 publiczne
oryginały Git oraz ORIGINS/README, razem106 członków manifestu.
IN jest jego identyczną kopią. **Pin IN/MANIFEST.sha256:**

```text
f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73
```

Sprawdź pin, wszystkich członków i dokładny zbiór plików.

| Wejście w IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| ZERO/REPORT.md | `d7e59a782a3b89bf7adfe1bc0894595a18e907a11019e557ecd55d588befaec8` |
| ZERO/OUTPUTS.sha256 | `599b33ccaefb5109cf1ce25c2cd4cc639abb4330ea05e89f3537cf86d57900ab` |
| ZERO/ANALYTIC_PROOF.md | `579b8614c249dc2f1a6938d600f6b234e85ef6a441ef922bde5570e304d93918` |
| ZERO/formal/BitErrors.lean | `ec214fafcf80626ef657f69bd9aa8623153cd8c55cb7222b395cf2e57cf2aef8` |
| ZERO/formal/LiteralAdd.lean | `52fe51d622295a30f1c3fd7264ba2f716fb847df842e5e71d55f4729972e918f` |
| H3/REPORT.md | `e808b0ecd9d39b575c075bf64056df93586d6fad60a0932866d673d0b45abb8c` |
| H3/OUTPUTS.sha256 | `911276514089b86e72173d4260aede980bb4497bcfce2789df5fbd56b8f1ce6e` |
| H3/REACHABILITY.md | `b44ea093f97c66a186abca0ac8c1d8a680bd3feec1f9121e165c5f623f1809e2` |
| M0/H3_INTERFACE.md | `2e427f66d242cd4a95f777b9be8948ced315d3c683727d21e965c5fb3934e97c` |
| source/falcon-sign.c | `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8` |
| source/falcon-keygen.c | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |
| source/falcon-fft.c | `06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063` |
| source/fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| source/fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| review/VALIDATION.sha256 | `d919df88c7d74bf57175ac4dd8b2bbe9303ebffe9266f70defd25d861a90f87a` |

ZERO/H3/M0 są wybranymi projekcjami, a legacy jest publicznym wycinkiem
historycznego H3_RANGE bootstrap. Stare manifesty zachowują własne bazy;
nie jest to kompletne stare replay tree. Kontrolery adaptuj do W z diffem
i pinami. Nowy replay nie może wymagać starego W, Dokumenty/H, USB albo
tymczasowego worktree prowadzącego. Bootstrap i kopie source są read-only.

## 2. Dziedzina emitted i własności wejściowe

N1536, q18433, Phi=X^1536-X^768+1, sigma768, B2093922385,
MODE1/FPEMU, dokładne flagi Makefile; M0 caller4096/nonce40, jeden wspólny
K_seed[E] warunkowany sukcesem całego KeyGen,16 outer attempts, cel parametryczny.

Użyj operacyjnego `Emitted_C` z H3/REACHABILITY. Nie zastępuj go K_iid,
jednym kluczem h*, dowolnym loader-accepted sk ani samymi coefficient caps.
Możesz dowieść twierdzenia na jawnym nadzbiorze P_key, ale trzeba osobno
uzasadnić, że wszystkie właściwe emitted outputs spełniają P_key.

Wyprowadź konsumowane własności z rzeczywistej ścieżki KeyGen i dekodowania
tego samego sk: f,g∈{-1,0,1}, |F_i|,|G_i|<=2047, fG-gF=q i używane machine
gate predicates. Pełne C/compiler refinement ma własną granicę, którą nazwij.
Nie wbuduj root positivity, małego L albo pożądanego błędu do P_key i nie
ogłoś ich przez to udowodnionymi. Sukces obu serializerów pozostaje w Emitted.

Miejsca źródłowe: poly_big_to_small/solve_NTRU i mandatory
`ft_keygen_leaf_certificate` (keygen7690+, call8110), signer decode/NTRU
checks przed load_skey oraz load_skey1159–1268. Jeśli korzystasz z zgodności
root g00 między KeyGen gate a loaderem, wykaż zgodność wejść, FFT, znaków,
obliczeń i layoutu — nie wystarcza ta sama nazwa normy.

## 3. Definicja badanego wycinka i dokładne obiekty

Zdefiniuj `RootSlice_C(f,g,F,G)` przez **rzeczywiste operacje C**, w kolejności:

1. smallints_to_fpr i FFT3 wszystkich czterech polinomów;
2. B00=FFT(g), B01=-FFT(f), B10=FFT(G), B11=-FFT(F);
3. source g00/g10/g11 z load_skey1232–1248;
4. oryginalne `LDL_dim2_fft3(...,logn=10,full=1)`:
   `L_C=g10_C/g00_C` przez faktyczny div_autoadj i
   `D_C=g11_C-g10_C*adj(L_C)` przez faktyczne muladj/neg/add.

Nie definiuj D_C przez q²/g00. To tylko dokładny punkt odniesienia.
Zwiąż fizyczny packed layout, real/imag slots, normalization i twiddles
z source falcon-fft.c oraz headerem FPEMU, dla całego N1536.

Dla każdej dokładnej częstotliwości z właściwej mapy FFT:

```text
A = |f|²+|g|²
C = G*conj(g)+F*conj(f)
J = |F|²+|G|²
L = C/A
D = J-|C|²/A = q²/A
```

Ustal orientację B·B* i znak L z C; nie przenoś bez sprawdzenia konwencji
B^T M B z historycznej analizy dualnej. Dokładna tożsamość determinantowa
jest przydatna do kontroli błędu subtractive D_C, nie zastępuje tej kontroli.

**Kolejność realnego loadera:** ffLDL_fft3 najpierw wykonuje split g00 i
rekurencję pierwszego subtree (sign732–735), dopiero potem root dim2 (741).
RootSlice jest wydzielonym wycinkiem numerycznym. Wykaż frame/input binding:
gdy rzeczywiste wykonanie dochodzi do root call, wcześniejsza rekurencja
nie zmieniła g00/g10/g11. Nie deklaruj na tej podstawie, że cała wcześniejsza
rekurencja jest zdefiniowana lub ma poprawne pivots — to dalszy obowiązek.

## 4. Wymagany certyfikat korzenia

Wyprowadź jawne rational/outward-certified stałe, jednostajne po required
support i wszystkich częstotliwościach. Końcowy `RootCertificate` obejmuje:

- FFT bounds i błędy względem niezależnych exact ring evaluations;
- bounds i błędy wszystkich trzech root Gram arrays;
- **ściśle dodatnią dolną granicę** rzeczywistych real denominators g00_C
  oraz ich górną granicę; finite, właściwą klasę FPR i defined reciprocal/div;
- finite L_C, jawny bound jego komponentów/modułu oraz |L_C-L|;
- finite D_C, dodatnią dolną i skończoną górną granicę Re(D_C),
  oraz konkretny błąd względem q²/A;
- osobno granicę części urojonej D_C. Matematyczne D jest realne;
  nie zakładaj, że sekwencja zaokrąglonych produktów daje identyczne imag0;
- zakresy wszystkich pośrednich instrukcji potrzebne dla C/FPEMU bindingu.

Wynik po wszystkich emitted outputs ma mieć postać:

```text
Emitted_C(E,sk,pk) + source-bound decoding of that same sk
  -> P_key(f,g,F,G)
  -> RootSlice_C is defined AND RootCertificate(RootSlice_C; explicit constants).
```

Przesłanki API/buforów/modelu wymień. Jeśli pozostaje numerical premise
dotycząca emitowanego klucza, FFT, dzielnika lub rounding, to jest partial.
Samo twierdzenie „jeśli errors są małe, pivot jest dodatni” nie zamyka etapu.
Gdy dodatniość nie wynika z dostępnego certyfikatu, dostarcz dokładnie
najbliższy dowiedziony kontrakt i brakującą nierówność; nie wymuszaj PASS.

Oddziel sprawdzenie rzeczywistego boundu od wymagania późniejszego centrum.
Nie trzeba w tym etapie wykazywać NumericCenter ani optymalizować L do
arbitralnie narzuconej liczby. Przydatny dodatkowy aggregate/energy bound
można wyprowadzić z zachowanych korelacji, z jawną normą i normalizacją.

## 5. Reuse i błędy: konkretne pułapki do rozliczenia

1. ZERO daje SOURCE_ADD_ERROR dla exponents<=1054 i E=2^-20. Root g11 oraz
   iloczyny F/G mogą mieć większy exponent. **Nie stosuj automatycznie 2^-20
   do całego root circuit.** Możesz rozszerzyć phase proof parametrycznie,
   wyprowadzając nową domenę, pack bounds i finiteness z faktycznych instrukcji.
2. Mul, reciprocal/div i używane FFT operacje potrzebują własnych domain/error
   lemmas. Ujęcie u|x|+eta z eta=2^-1075 nie jest ogólnie poprawne dla FPEMU.
   Wykorzystuj rzeczywiste normal/zero/subnormal/underflow branches; albo
   dowiedź normal-domain invariant, albo jawnie policz błąd pozostałych klas.
3. Legacy T5 NUMERICAL_SOUNDNESS stwierdza correctly-rounded binary64.
   Dla nowej konsumpcji wykazuj jego wymagania na używanej source domain;
   hash historycznego twierdzenia sam ich nie rozstrzyga. Zachowaj stare
   statusy i piny; eksport nowego domain bridge nie przepisuje dawnych plików.
4. Twiddle bound i exponents/maps muszą pochodzić ze wskazanych certyfikatów
   lub nowego exact/RBF/RIF audytu wszystkich używanych stałych. Legacy ma
   wybrane runner/certificate inputs, nie pełne historyczne replay tree.
5. H4 stable leaves nie certyfikują wszystkich internal words. Normalizacja
   nadpisuje1536 z18432 słów drzewa; wewnętrzne16896 pozostają subtractive.
   T5 exact leaf positivity nie jest automatycznym machine-pivot boundem.
6. Nie zakładaj idealnego Babai quotient<=1/2. Jeśli jest naprawdę potrzebny,
   podaj dokładną brakującą własność source final reduction i dlaczego same
   udowodnione caps/NTRU/gates nie domykają danego kroku.

Każdy reused result: dokładny statement/domain, pin, proof layer, sposób
konsumpcji i rozliczone przesłanki. Mixed analytic/kernel proof jest
dopuszczalny; nie ukrywaj analitycznych upstream contracts w Lean assumptions.

## 6. Kontrole i wynik negatywny

Główny dowód jest uniwersalny/analityczny/kernellowy, ze związkiem z C.
Kontrole: publiczne sztuczne spectral/Gram arrays i małe niesekretne
polinomowe przykłady, dokładny ZZ/QQ/dyadic lub rigorous RBF/RIF oracle,
C normal/ASan/UBSan. Nie generuj kluczy i nie uruchamiaj private loadera
ani Sign/KeyGen. Lokalny harness może wywoływać oryginalny LDL_dim2/FFT.

Sprawdź znaki/conjugation, packed order, alias/frame, dzielnik na granicy,
cancellation d11, positive/negative zero i istotne klasy FPR. Host-double
nie jest jedynym oracle. Małe stopnie/próbki nie zamykają N1536 quantifier.
Mutacje: podmiana source subtractive D na idealny reciprocal, pominięcie
błędu FFT/Gram/div/sub, błędny znak/conjugation, nielegalne użycie E2^-20
poza jego domeną; no-op ma przechodzić. Kontroluj wartości, nie etykiety.

Arbitrary/sheared loader key, sztuczny Gram, niezależny interval box lub
luźny majorant nie jest kontrprzykładem w emitted support. Rozróżnij:
naruszenie użytej lokalnej przesłanki, niewystarczalność majorantu i rzeczywisty
required-domain counterexample. Ten ostatni wymaga publicznego dowodu
emitted/source membership, bez odczytu lub generowania prywatnych danych.

## 7. Dalsza kompozycja i granica tego etapu

W `NEXT_INTERFACE.md` eksportuj certyfikat dwóch root Schur branches i L
w postaci konsumowalnej przez następny internal-LDL etap. Opisz co jeszcze
trzeba dowieść dla split_top, LDL_dim3, split_deep i niższych nodes, w tym
propagację małych imaginary errors oraz dzielniki używające real slots.
Osobno zachowaj initial targets i ordered sampling-prefix induction.

ROOT_LDL -> INTERNAL_LDL oraz INITIAL_TARGETS -> ORDERED_REACH, który
konsumuje ZERO_SCALAR -> lokalne bezpieczeństwo. Source sampler-law bridge
ma osobne obowiązki. Nie używaj residual bound do udowodnienia przedziału
tego samego call, od którego ten bound zależy. Fault0 nie ma closeness.

## 8. Narzędzia, pakiet i freeze

Tylko W writable; bootstrap/source read-only. AGENTS nie jest sandboxem.
HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin pod W. Skończone limity;
GCC14.2/C99/LP64, Sage10.9 (`sage plik.py ...`), Lean4.34/Std
`-j1 -M2048`,8GiB address space. ASan osobno z dostępną przestrzenią shadow.
Bez instalacji, sieci badawczej, innych agentów, Git, sekretów, .private,
private_extraction, prywatnych seedów/współczynników lub nowych kluczy.
Nie zmieniaj parametrów, C, guards albo programu na stable LDL w tym zadaniu.

Nowe/edytowane Lean: pełne czyste logi, typy/implicits/termy/axioms, bez
sorry/admit/native_decide, aksjomatu wniosku lub wyciszania ostrzeżeń.
Zależności zachowaj bajtowo albo adaptuj w nowej kopii z diffem i rebuildem.
Nie kopiuj olean jako dowodu. Zachowuj wszystkie nieudane próby/logi.

Wymagane: REPORT.md, RESULT.json, CLAIM.md, ROOT_CERTIFICATE.json,
BOUND_LEDGER.json/.md, SOURCE_MODEL_BINDING.md, REUSED_RESULTS.md,
OBLIGATIONS.json, NEXT_INTERFACE.md, formalne źródła/certyfikaty i kontrolery,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
OUTPUTS.sha256. Rozdziel proof layers i universality od finite controls.
Ledger minimum: EMITTED_BINDING, FFT_DOMAIN_ERROR, ROOT_GRAM,
ROOT_DIVISOR, ROOT_MULTIPLIER, SUBTRACTIVE_SCHUR, IMAGINARY_ERROR,
ROOT_FRAME, RECURSIVE_TREE_OPEN, INITIAL_TARGETS_OPEN, ORDERED_REACH_OPEN.

Standard: `python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`.
Przed utworzeniem DEST zweryfikuj zewnętrzny pin i wszystkich członków.
DEST nowy pod tmp kopii; pełny rebuild konsumowanych dowodów/kontroli,
bez wcześniejszych olean/cache/bin. `artifacts/fresh_replay.json` ma listę
matches(path,sha256), związaną z OUTPUTS; rehearsal osobno bez cyklu hashów.
Po freeze wykonaj standard replay z finalnym pinem; zapis tylko do DEST.

## 9. Status i handoff

- `H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL`: pełny zakres root certificate,
  wszystkie source-domain/error premises rozliczone, jawne stałe i frame binding.
- `PARTIAL_PROOF`: nowe lematy i dokładne brakujące typy/nierówności,
  w szczególności jeśli root input domain lub positivity pozostają warunkowe.
- `COUNTEREXAMPLE_REQUIRED_DOMAIN` / `COUNTEREXAMPLE_EXTENDED_DOMAIN`:
  z wyraźnym rozliczeniem emitted membership i zakresu naruszonej tezy.
- `EXECUTION_BLOCKED`: konkretna przeszkoda techniczna, zachowane logi.

Nawet przy pełnym lokalnym wyniku: `H3_range_proved=false`,
`global_reachability_proved=false`, `full_internal_tree_proved=false`,
`sampler_law_proved=false`, `security_reduction_proved=false`.
`baseline_source_integrated=true`, `source_changed=false`,
`new_source_patch_integrated=false`, `protocol_wrapper_integrated=false`,
`owner_accepted=false`. Nie zmieniaj historycznych flag poprzedników.

Podaj REPORT/OUTPUTS SHA-256, dokładną tezę i stałe, warstwy dowodu oraz
pełny typ najbliższego następnego lematu. Prowadzący wykona niezależny
odbiór/import/commit. Zakończ na przekazaniu; nie zaczynaj kolejnego etapu.
