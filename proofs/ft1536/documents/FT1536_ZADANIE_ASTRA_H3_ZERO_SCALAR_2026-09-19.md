# GPT-ASTRA — H3_ZERO_SCALAR: lokalny most FPEMU z jawnym -0

Data: 2026-09-19. Autor projektu: Niirmata.
Kontynuacja tej samej rozmowy po odebranym `FT1536_H3_RANGE_RUN_001`.

## 0. Cel jednego etapu

Wyprowadź **źródłowo związany, zero-aware lokalny kontrakt skalarnego
floor/cast/return/residuum** dla przypiętego aktywnego kandydata. Najpierw
rozlicz -0 dokładnie, następnie domknij potrzebny lokalny błąd rzeczywistego
FPEMU, zamiast zakładać nieograniczony IEEE rounding model.

H3_RANGE otrzymał osobny checkpoint `cb99e67` jako **PARTIAL_PROOF**:
niezależny replay 96/96, osiem modułów Lean, 49 nowych twierdzeń, normal C
i ASan/UBSan. `fpr_floor(-0)=-1` narusza mathematical-floor equality,
lecz samo nie narusza int32 safety. Jego osiągalność z emitted keys jest
nadal nierozstrzygnięta. To motywacja lokalnego zadania, nie założenie,
że -0 musi być wykluczone z przyszłego poprawnego opisu signera.

Nowy wynik ma **własną nazwę i tezę**. Nie zastępuje zamrożonego
`Reach_call_C -> CenterClass`, nie zmienia kontraktu M0 i nie ustawia
`H3_range_proved=true`. Pozostawia jawny przyszły obowiązek osiągalnego
przedziału oraz osobny obowiązek zgodności prawa samplera z nowym interfejsem.

Wykonaj zadanie do raportu, freeze i standardowego replayu. Konkretny
nowy partial jest dopuszczalny; sam opis już znanych braków nie jest wynikiem.

## 1. Katalog i przypięte wejścia

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_ZERO_SCALAR_RUN_001
IN = W/inputs/bootstrap
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_ZERO_SCALAR_2026-09-19.md
BASE = cb99e67ae6f7cfa1c79be23d70c8fbfbe6874f13
```

W zawiera tylko AGENTS i gotowy bootstrap. Potwierdź cwd, lokalne instrukcje
REPO/AGENTS oraz W/AGENTS, rzeczywisty sandbox i brak drugiego wykonawcy.
REPO może mieć starszy checkout i zastany indeks; używaj `IN/source`, a nie
przypadkowego REPO/Extra/c. Nie zmieniaj Git, branch refs ani indeksu.

Publiczny zestaw `proofs/ft1536/background/H3_ZERO_SCALAR_2026-09-19/`
ma 71 oryginałów Git, ORIGINS i README, czyli 73 członków manifestu.
Bootstrap jest jego bajtowo identyczną kopią. **Zewnętrzny pin
IN/MANIFEST.sha256:**

```text
e8eb2b091e9396d08afbdd3f8b4adebbebf97e7a0890306c5cf07c8e7beb4099
```

Zweryfikuj cały manifest i dokładny zbiór plików. Szczególnie:

| Wejście w IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| H3/REPORT.md | `e808b0ecd9d39b575c075bf64056df93586d6fad60a0932866d673d0b45abb8c` |
| H3/OUTPUTS.sha256 | `911276514089b86e72173d4260aede980bb4497bcfce2789df5fbd56b8f1ce6e` |
| H3/formal/Floor.lean | `cf4e4442f0b188eb32b123a954db9ce8f27f9bca1f0373c13cbfad6f3a7dd9f1` |
| H3/formal/GuardPrefix.lean | `edb8a786fdb6a676057d06100f5dddd10785ea5436d0b27ec216b62522575dff` |
| H3/formal/OrderedResidual.lean | `c937e2e655b0d56d56a36f25874dd81de8de51897613aa8a7499be07e4b075a9` |
| H3/artifacts/fpr_analysis.json | `88eaa7d69330f327a418df717f3a3b13d3803364e46f0b6df777e8f7d1c24b68` |
| M0/REPORT.md | `b71d71e8d89022ea321241d0ddabdddf4a3b81bfc9fe4faca08476baf6e71c29` |
| M0/OUTPUTS.sha256 | `08c9b6afe630e11bd98f33a910476950442854e5925efaa7f8fa1d0d8c8d695d` |
| M0/H3_INTERFACE.md | `2e427f66d242cd4a95f777b9be8948ced315d3c683727d21e965c5fb3934e97c` |
| source/falcon-sign.c | `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8` |
| source/fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| source/fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| review/VALIDATION.sha256 | `0235a83eeab0b823a01f81134c03a344242a619fc60f6cb7e1de334f7ba086dc` |

To wybrana projekcja, nie pełne stare replay tree. Stare OUTPUTS/VALIDATION
są kotwicami proweniencji w ich pierwotnych bazach. Wszystkie skopiowane
członki H3/M0 sprawdzono względem tamtych manifestów. Adaptuj kontrolery do
nowego layoutu w W, zachowując oryginał, diff i piny. Nie uruchamiaj ich w IN.
Nowy replay ma być samowystarczalny z nowego OUTPUTS, bez starego W,
Dokumenty/H/USB lub tymczasowego worktree prowadzącego.

## 2. Dokładna dziedzina lokalnej tezy

Zachowaj N1536, q18433, Phi=X^1536-X^768+1, sigma768, B2093922385,
MODE1/FPEMU i flagi Makefile; M0 caller4096, nonce40, jeden K_seed[E],
16 outer attempts i parametryczny cel. Źródła C pozostają identyczne.

Użyj niezależnej dokładnej dyadycznej interpretacji `val(x)` finite binary64
bit pattern, także exponent0 i obu zer. To interpretacja wartości wejścia,
**nie założenie IEEE semantyki działań backendu**.

Zdefiniuj jawnie nowy predykat, np.:

```text
NumericCenter(x) := Word64(x) AND finite(x) AND
  -2147483283 <= val(x) < 2147483282.
```

Nie dodawaj NotNegZero, normalności ani poprawności floor do tej definicji.
To uniwersalny lokalny nadzbiór bit patterns, **nie definicja Reach_call_C**.
Przyszłe `Reach_call_C(...) -> NumericCenter(mu)` pozostaje obowiązkiem
globalnym, z emitted-KeyGen/M0 dziedziną poprzednika, także pre-dss calls
i próby później odrzucone przez normę. Nie wolno zakładać Q<B w tej fazie.

## 3. A — dokładny zero-aware floor i integer bridge

Dla wszystkich x spełniających NumericCenter wyprowadź z bitów źródła:

```text
eps0(x) = 1, gdy x jest dokładnie 0x8000000000000000; inaczej 0
s_C(x) = fpr_floor_C(x) = floor(val(x)) - eps0(x)
long -> int jest dokładne
forall z in [-365,366], INT32_MIN <= s_C(x)+z <= INT32_MAX
```

`s_C` ma być zdefiniowane literalnym bit-vector/integer modelem C, a nie
samą prawą stroną dowodzonej równości. Powiąż wszystkie shifts, wrap,
signed casts i końcowy long z GCC14.2/C99/Linux x86_64 LP64.
Wyprowadź exponent<=1053 z **niezależnego** `val` i NumericCenter;
nie używaj poza domeną starego `mathFloor`, którego potęgi mają Nat subtraction.

Możesz konsumować H3 `floor_refinement`, `negative_zero_exception`,
`integer_safety` oraz proposal/CDF support. Rzeczywisty return wymaga
nonfault/successful proposal i zaakceptowanej iteracji; sticky return0
stanowi inną gałąź. Guards dss/gap/x następują po konwersji, nie ograniczają
wstecz jej required domain.

Pokaż relację nowego predykatu do starego `CenterClass` i jawnie odróżnij:
poprawną source floor formula, int safety oraz mathematical-floor equality.
Ostatnia nadal wymaga wykluczenia -0; nie nazywaj nowej tezy starym H3.

## 4. B — lokalna semantyka maszynowa centrum i residuum

Zwiąż z rzeczywistymi instrukcjami co najmniej:

```text
r_C(x)   = fpr_sub_C(x, fpr_of_C(s_C(x)))       [sign:2865]
y        = s_C(x)+z                            [sign:2968]
res_C(x,z) = fpr_sub_C(x, fpr_of_C(y))          [terminal callback residual]
```

Udowodnij dokładność `fpr_of` dla odpowiednich signed32 i zdefiniowanie
operacji pośrednich. Dla wszystkich NumericCenter x oraz z∈[-365,366]
wyprowadź **konkretne, jawne racjonalne** E_r,E_res oraz:

```text
r_C i res_C finite;
abs(val(r_C(x)) - (val(x)-s_C(x))) <= E_r;
abs(val(res_C(x,z)) - (val(x)-(s_C(x)+z))) <= E_res.
```

Wartości mają być użyteczne do indukcji (celem są E_r,E_res<=1/4, najlepiej
znacznie mniejsze). Nie jest to narzucony z góry prawdziwy bound: wyprowadź
go, a jeśli się nie domyka, podaj dokładny kontrmodel lokalny albo brakujący
typ i partial. Sam nowy symbol E z założeniem potrzebnej nierówności nie
zamyka B. Wynik musi obejmować **wszystkie** bit patterns lokalnej domeny,
nie tylko skończony zestaw testów lub klasę normal bez uzasadnienia.

Osobno ustal rzeczywisty zakres i klasy zer `r_C` oraz `fpr_sub(1,r_C)`
używanego w delta (sign:2923): czy ich wartości należą do [0,1], jakie są
endpoint bits i jakie dodatkowe przesłanki są potrzebne. Jeśli [0,1] jest
fałszywe, pokaż właściwy bound i konsekwencję dla konsumentów; nie naprawiaj C.

Źródła minimum:
- fpr-emulated.h: shifts, FPR pack39–55, of86–90, floor117–133,
  sub151–156 i neg158–163;
- fpr-emulated.c: FPR_NORM64, aktywny C fpr_scaled151–204 oraz
  fpr_add449–556, z maskami, sticky bits, cancellation i rounding;
- falcon-sign.c: sampler2841–2969 i terminal inner1617–1646.

Nie używaj nieaktywnej gałęzi ARM ani fpr-double jako definicji FPEMU.
FPR underflow/exp0 należy rozliczyć literalnie. Cały ogólny backend
mul/div/sqrt, internal LDL i FFT nie są celem tego lokalnego etapu.

## 5. C — konsumowalny residual lemma i mapa dalszych obowiązków

Odróżnij dokładne `rho=val(x)-s_C(x)` od maszynowego `r_C`.
Wyprowadź z A zamknięty `0<=rho<=1`; -0 może dać rho=1.
Nie wnioskuj, że maszynowe r_C=1 występuje tylko przy -0: inne wartości
mogą zaokrąglić do endpointu.

Z zamkniętego przedziału i proposal support wyprowadź lokalny bound
`abs(val(x)-(s_C(x)+z))<=366`, a następnie przez B bound rzeczywistego
residuum `<=366+E_res`. Nie zwiększaj 366 wyłącznie dlatego, że endpoint
rho=1 jest teraz włączony, jeśli algebra pozwala zachować ten sam bound.

Zbuduj w nowym namespace zero-aware wersje konsumowanych OrderedResidual
lemmas. Pokaż podstawienie rzeczywiście dowiedzionego E_res; E_half/E_add
pozostaw jawnie otwarte tam, gdzie nie są przedmiotem B. Zachowaj zasadę:
najpierw bezpieczny bieżący center, następnie jego return/residuum,
dopiero potem bound kolejnego centrum. Przyszłego return nie używaj do
uzasadnienia własnego bezpiecznego floor. Nie stosuj closeness do fault0.

W `M0_COMPATIBILITY.md` porównaj dokładne stare i nowe tezy:
- old H3 RANGE/floor equality pozostaje open;
- nowy local integer/residual interface i przesłanka NumericCenter;
- globalne emitted/loader/LDL/ordered bounds pozostają do wyprowadzenia;
- source scalar-law/acceptance potrzebuje własnego spożycia endpointów
  r/delta, signed zero i błędów. Nie deklaruj równoważności prawa przez
  samą zamianę s=0 na s=-1: ograniczone propozycje zmieniają przesunięty
  support. Dla -0 odnotuj y∈[-366,365], dla +0 y∈[-365,366].

Nie wykonuj całego dowodu rozkładowego, BerExp, H1R/FFO/R5T lub M7.
Nie przypisuj automatycznie globalnej małej straty ani nowego abortu.
To zadanie ma dostarczyć dokładny interfejs i jawne warunki jego konsumpcji.

## 6. Dowody i kontrole

Wynik uniwersalny: analityczny/kernellowy argument po pełnej dziedzinie,
literalny source model i jawny zakres C-to-model binding. Pokaż pełne typy,
implicits, term i `#print axioms`. Czysty Lean nie oznacza zweryfikowanego GCC.
Nowe/edytowane Lean: bez sorry/admit/native_decide, lokalnych aksjomatów
wniosku i wyciszania ostrzeżeń; pełne czyste logi. Dziedziczone moduły mają
piny i są przebudowane. Adaptacja wymaga nowej kopii/diffu, nie zmiany IN.

Małe kontrole rzeczywistego C normal/ASan/UBSan i niezależnego integer/dyadic
oracle obejmują oba zera, subnormals obu znaków, granicę normal/underflow,
wartości po obu stronach liczb całkowitych, końce NumericCenter i najbliższe
reprezentowalne słowa, z=-365/366, cancellation i r/delta endpoint1.
Porównuj raw bits oraz exact values: samo równanie val(-0)=val(+0) nie
sprawdza klasy zera. Host double nie jest jedynym oracle.

Wymagaj wykrywania rzeczywistych mutacji: pominięcie eps0, floor->trunc,
zamknięte rho<=1 zamienione na rho<1, pominięcie rounding/underflow termu
oraz przestawiony endpoint integer range; no-op musi przechodzić.
Nie wykonuj rzeczywistego signed overflow dla negatywnej kontroli — sprawdź
naruszenie w szerszej arytmetyce i zatrzymaj przed nielegalną instrukcją.

## 7. Wykonanie i pakiet

Zapis tylko W, bootstrap/source read-only; potwierdź rzeczywisty sandbox.
HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/binaries pod W. Korzystaj z
GCC14.2/C99/LP64, Sage10.9 (`sage plik.py ...`) i Lean4.34.0/Std
`-j1 -M2048`, 8GiB address-space i skończonych limitów. ASan wymaga osobnego
trybu virtual-shadow; nie nakładaj na niego limitu odbierającego shadow.
Ścieżki toolchainu jak w H3/review; potwierdź wersje, niczego nie instaluj.

Bez sekretów, prywatnych seedów/współczynników, .private/private_extraction,
nowych kluczy, KeyGen/Sign z kluczem, sieci badawczej, innych agentów i Git.
Dozwolone są jawne syntetyczne scalar words/integer values. Takie testy nie
dowodzą emitted/whole-Sign reachability. Nie dodawaj guardu, canonicalizacji
zera, poprawki FPR lub zmiany parametrów, aby otrzymać pozytywny wynik.

Wymagane: REPORT.md, RESULT.json, CLAIM.md, OBLIGATIONS.json,
SOURCE_MODEL_BINDING.md, REUSED_RESULTS.md, M0_COMPATIBILITY.md,
ERROR_LEDGER.json/.md, formalne źródła/certyfikaty, checkery i logi,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
OUTPUTS.sha256. Zapisuj wszystkie polecenia/cwd, limity, exit codes,
pełne streams i próby odrzucone. Sekcje ledgeru: FLOOR_ZERO, C_INT_BRIDGE,
OF_EXACT, SUB_CENTER, SUB_RESIDUAL, R_DELTA_DOMAIN, ORDERED_CONSUMPTION,
GLOBAL_REACHABILITY_OPEN, SAMPLER_LAW_CONSUMPTION_OPEN.

Replay standard: `python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`.
Zweryfikuj zewnętrzny pin i wszystkich członków przed tworzeniem DEST;
DEST nowy pod tmp kopii, bez starych olean/cache/bin. Odtwórz wszystkie
konsumowane dowody i istotne kontrole. `artifacts/fresh_replay.json`
zawiera matches(path,sha256); receipt i pliki znaczeniowe należą do OUTPUTS.
Pre-freeze rehearsal ma osobną kotwicę bez cyklu hashów. Po freeze wykonaj
standard replay z finalnym pinem, zapis tylko do DEST; nie nadpisuj archiwum.

## 8. Warunek końca i statusy

- `H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL`: domknięte A/B/C w pełnej
  zadanej lokalnej domenie, jawne użyteczne błędy i source binding.
- `PARTIAL_PROOF`: konkretne nowe twierdzenia, dokładnie wskazana niedomknięta
  część A/B/C; źródłowo nieuzasadnione E nie są pełnym pozytywnym wynikiem.
- `COUNTEREXAMPLE_LOCAL_DOMAIN`: publiczny świadek naruszenia nowej lokalnej
  tezy wraz z bits/oracle/C; nie jest automatycznie required-domain H3 counterexample.
- `EXECUTION_BLOCKED`: rzeczywista blokada techniczna, z zachowanymi logami.

Zapisz osobno zakres i flagi: `H3_range_proved=false`,
`global_reachability_proved=false`, `sampler_law_proved=false`,
`baseline_source_integrated=true`, `source_changed=false`,
`new_source_patch_integrated=false`, `protocol_wrapper_integrated=false`,
`owner_accepted=false`, `security_reduction_proved=false`.

Podaj REPORT/OUTPUTS SHA-256, dokładną tezę, co nowego zamknięto, co
pozostaje i pełny typ najbliższego następnego lematu. Prowadzący wykona
niezależny odbiór, import i osobny commit. Nie zaczynaj dalszego etapu.
