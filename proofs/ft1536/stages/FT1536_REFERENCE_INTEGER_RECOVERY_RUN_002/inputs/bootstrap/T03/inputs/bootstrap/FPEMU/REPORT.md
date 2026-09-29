# FT1536 — niezależny audyt obecnego FPEMU

Data wykonania: 2026-09-20. Autor projektu: Niirmata.
Etap: **FT1536_FPEMU_AUDIT_RUN_001**.

## 1. Werdykt i najważniejsze ustalenia

**`CONFIRMED_ISSUE` — zakres: ogólny kontrakt porównania signed zero oraz
statyczna zależność compiled control flow od operandu.** Audyt jest zakończony
z jawnymi otwartymi obowiązkami. Nie nadaje całemu FPEMU statusu PROVED/CT-safe.

1. **F01, `CONFIRMED_IN_CONTRACT`: `fpr_lt(-0,+0)=1`**, choć `val(-0)=val(+0)`.
   Jest to naruszenie ogólnego opisu numeric `<` w `internal.h:281-282`.
   Potwierdzono normal C i ASan/UBSan. Aktywne Gate00 i adaptive selector
   porównują z dodatnimi niezerowymi stałymi; nie znaleziono konsumpcji tej
   błędnej pary przez ich obecne lokalne dziedziny. Nie jest to required-domain
   kontrprzykład do ZERO/ROOT/NODE3 ani świadectwo osiągalności w emitted Sign.
2. **F02, `TIMING_EVIDENCE`: GCC14.2 z rzeczywistym `-O` generuje w floor
   gałąź `encoded_exponent<1022`**, czyli `|x|<1/2`. Gałąź potwierdzono
   również w oryginalnym `falcon-sign.c`, w aktywnym `sampler_large` i BerExp.
   Komentarz Makefile „CT-safe: -O only” nie uzasadnia blanket fixed-trace
   zapewnienia. To analiza bajtów maszynowych, bez pomiaru wielkości wycieku.
3. **Nie znaleziono naruszenia obecnych source arithmetic contracts
   ZERO/ROOT/NODE3.** Celowane exact dyadic/QQ/RBF kontrole objęły ich
   właściwe domeny i allowances, także oba zera i subnormals. Wynik finite
   audytu nie dowodzi uniwersalności tych kontraktów.
4. **Dudect/ctgrind: `NOT_RUN`** (F07). W sprawdzonych lokalizacjach brak
   narzędzia/harnessu, a równoległe warunki maszyny nie były kontrolowane.
   Dokładny następny przepis znajduje się w TIMING_REVIEW.

Pełne8 findings, expected/observed, reproducer, zakres osiągalności i zależne
claims: `FINDINGS.json`. Macierz pokrycia ma30 wierszy, source/span hashes,
active preprocessed call-sites i przesłanki: `AUDIT_MATRIX.json/.md`.
Zależności poszczególnych twierdzeń: `IMPACT_MATRIX.md`.

## 2. Tożsamość wejść

Wyłącznym źródłem jest `inputs/bootstrap/source`, nie bieżące Extra/c.
Zweryfikowano zlecenie, manifest, exact file set, wszystkie126 members,
124 ORIGINS z długościami,17 źródeł i membership dostarczonych projekcji
w ich oryginalnych OUTPUTS. Pochodzenie jest hash-bound rekordem publicznego
BASE; w tym audycie nie wykonano ponownej ekstrakcji z Git.

| Pin | SHA-256 / identyfikator |
|---|---|
| Zlecenie | `d5b064ba6082f1f563bfba717ee1d167254e2aedcea667576bfb3f56a9103de9` |
| Bootstrap MANIFEST | `f836a37c9247de53ff70297e809fa55c46812d749e69886857d24e89db7de166` |
| BASE | `b5805bab84a9c0057cd0392671e389bf81031a76` |
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| Publiczny scalar corpus | `a7fcd95e946fc5accba3c48e2da30ddafa5700dd772f518f9e6b87b795696c3e` |

Aktywne portable C; ARM wyłączone. TRUE_TERNARY_SECRET=1 usuwa Gaussian
KeyGen call do gauss/log/sincos. fpr-double służy wyłącznie porównaniu
pochodzenia tablic; host double nie jest oracle arytmetyki.

## 3. Niezależne kontrole i ich zakres

| Kontrola | Rzeczywisty wynik |
|---|---|
| Przypięty finite smoke | 12/12 w każdym trybie |
| Scalar C | **140 225 przypadków na tryb**, identyczny pełny stdout normal/ASan+UBSan |
| ZERO actual delta | 250 dalszych subtractions na rzeczywistych C center outputs, w obu trybach |
| ZERO source add error | 25 594 porównań exact, `<2^-20`; NumericCenter/residual fixtures obejmują wszystkie z∈[-365,366] na8 endpoints |
| ROOT add/sub/mul | Odpowiednio10 321 /19 881 /10 321 porównań rzeczywistych envelopes |
| ROOT div | 8785 porównań w y∈[1/2,2^23] |
| NODE3 extended div | 12 709 porównań w y∈[1/16,2^35], plus exact inverse3 |
| sqrt | 4316 RN porównań dla legalnych normal/zero inputs |
| high64 multiply | 20 480 porównań z exact big-integer product |
| shifts | 8192 przypadki na każdy z ursh/irsh/ulsh, wszystkie counts0..63 |
| normalizer / pack | 128 /528 przypadków, w tym m0, carries, ties, underflow boundary |
| Stałe/tablice | 8192 words zgodne z exact decimal RN; **1022 pary FFT3** i11 fixed constants niezależnie sprawdzone RBF256, error<2^-50 |
| Exponentials i nieaktywne helpers | RBF:257 expm,514 exp_small,257 log,257 sincos; limity i zakres w rigorous.json |
| Oracle controls | 7 exact anchors;4 rzeczywiste value mutations wykryte; no-op PASS |
| Replay integrity controls | poprawny manifest przyjęty;7 różnych błędów pin/path/duplicate/symlink odrzuconych |
| Formal projection | **29 historycznych Lean modules**, clean logs,0 warnings; pełne dostarczone types/axioms |
| Compiled static review | oryginalne FPEMU/FFT/Sign/KeyGen TU plus inline wrappers, GCC -O |

Oracle `scripts/oracle.py` używa dokładnych Fraction/integer divisions i
isqrt, nie kopii C limb/sticky/restoring algorithm. RN jest sprawdzany
osobno od source bounds, tylko w normal-result dziedzinie lub jawnych
zero-conventions. Przypadki exponent2047, INT64_MIN conversion, skrajne sc,
zero denominators i negative sqrt są odrzucone przed możliwym UB, nie
przedstawiane jako sanitizer PASS. Pełne wyłączenia: rejected_cases.json.

ASan+UBSan nie zgłosiły błędu dla wykonanego publicznego corpus. Nie jest
to dowód nieobecności UB dla wszystkich caller inputs. Sqrt/rint/scaled
poza lokalnymi dowodami oraz cały reachable call graph pozostają odrębnymi
obowiązkami (F05/F08). Nie uruchamiano full test_falcon, KeyGen, private
loadera ani Sign z kluczem.

Binary normal scalar:
`1294c66e9b3bc26b4710bfb769e84aa54a95f7345e083c718f9c9df698cac64e`.
Binary ASan scalar tego W:
`89fbbfa3e74643076d4dbb76dbcbc0fbaa264753acc4360bf3c7f7d62688144f`.
Pełne source/compiler/flags/binary receipts: normal_build/asan_build JSON.

## 4. Ocena istniejących dowodów

**ZERO:** sprawdzono rzeczywistą definicję NumericCenter, jawny eps0 i
`FLOOR_ZERO`, dokładność signed32 `OF_EXACT`, `SOURCE_ADD_ERROR`,
SUB_CENTER/SUB_RESIDUAL i R_DELTA_DOMAIN. Analityczny argument faz
decode/alignment/normalize/shrink/pack ma jawny budżet
`13*2^-24+2^-1021<2^-20`. To nie jest założone complete IEEE. Konsument
`CONSUME_SUB_RESIDUAL` jawnie przyjmuje analytic_contract; nie ukrywa aksjomatu.

**ROOT:** osobno badano cap2^100, U2^-48/eta2^-900. Błąd exponent0 w mul
jest majorowany przez `2^-922<eta`, a nie przez nieprawdziwy complete-IEEE
budget. Generalized pack value binding jest analityczny — nie podstawia
większego exponentu do starego `pack_normal_value` z ograniczeniem1054.
`RootDiv.loop55` daje właściwy invariant/remainder na mantissach; pełny
numeric envelope wymaga także exponent/sticky/pack argumentu.

**NODE3:** jawne rozszerzenie denominator domain ma encoded exponent1019..1058;
actual inverse3 to `0x3fd5555555555555`, czyli
`6004799503160661/18014398509481984 = 1/3-1/(3*2^54)`.
Nie podstawiono idealnego1/3. Primitive assumptions nie są identyczne
z dowodem spectral/Schur composition i jego korelacji.

F04 opisuje ograniczenie pełnej kernelizacji i projekcji archiwów, nie
wykryty fałsz tych argumentów. Nie wykonano pełnych dawnych replay trees:
zlecenie dostarcza ich wybraną, hash-bound projekcję. Obecny replay odtwarza
nowy audyt i dostarczone moduły, bez udawania pełnego replayu poprzedników.

F03 (`floor(-0)=-1`, flush/half edges) pozostaje znanym accounted behavior.
F06 wskazuje konkretną lukę w niezależnej walidacji exponential whole-domain
claim: sam komentarz headera nie dostarcza aktualnego certyfikatu i jego
source binding. RBF257 dało max sampled expm error<3562 integer units,
ale nie zastępuje uniwersalnego acceptance-law proof.

## 5. Wpływ i najbliższy obowiązek

L_RHO/L_NTT/L_V są całkowitoliczbowe; M0 capacity jest faktem po defined
norm acceptance. Nie zostały obalone przez F01/F02. Także żaden obecny
lokalny arithmetic proof interface ZERO/ROOT/NODE3 nie został zakwestionowany
kontrprzykładem w jego deklarowanej dziedzinie. Zakwestionowano **generic
numeric compare API** oraz **ogólne zapewnienie fixed-trace na podstawie -O**.

Najbliższe obowiązki:

1. Dla aktywnego NODE2/lower-tree wyprowadzić każdą domenę div/half i
   ordered propagation, korzystając dokładnie z obecnych cap/U/eta i actual
   kappa. Audyt nie odczytywał ani nie oceniał bieżącego wyniku wykonawcy NODE2.
2. Dla CT zająć się compiled floor branch i wykonać przypięty, kontrolowany
   timing experiment według TIMING_REVIEW; brak sygnału nie da proof CT.
3. Przed pełnym Sign-law dostarczyć source-bound exponential certificate,
   sqrt/rint/caller-domain refinement oraz joint byte/fault/retry law.
4. Przy ewentualnej poprawce źródeł nadać nowy pin/profile i ocenić wpływ
   na K_seed[E]/Sign law. Ten audyt nie wdraża patcha ani nie zmienia starszych
   historycznych raportów/statusów.

## 6. Wykonanie, rehearsal i freeze

Wszystkie obliczenia były bounded bwrap W-only writable, bootstrap/source RO,
sieć odłączona; HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache pod W. Normal8GiB,
osobny ASan shadow mode. Szczegóły i jawna historia początkowych odczytów
metadanych oraz dwóch poprawionych prób Sage: EXECUTION_NOTES.

**Pre-freeze fresh rehearsal: PASS,29/29 semantic files,12 bounded steps**, ze
świeżymi kompilacjami C/ASan/Lean i QQ/RBF. Receipt:
`artifacts/fresh_replay.json`; pełne logs w `logs/rehearsal`.
Odrębna kotwica rehearsal:
`a0878ffd8ca99211278d186f97ab6ca59762ed94403bbaf99494cec3ce715bc0`.

Freeze obejmuje dokładny zakres OUTPUT_SCOPE, pełne receipts i niezmienione
publiczne inputs. Standardowy post-freeze replay do nowego
`tmp/postfreeze001` używa **finalnego zewnętrznego OUTPUTS SHA-256**.
Jego REPLAY_RESULT i hash są przekazywane osobno, aby nie przepisywać frozen
REPORT/OUTPUTS po wykonaniu. Przepis i manifest29 semantic files: REPLAY.md.

`source_changed=false`, `owner_accepted=false`,
`security_reduction_proved=false`, `global_FPEMU_proved=false`,
`global_CT_proved=false`, `global_reachability_proved=false`.
Prowadzący wykonuje niezależny odbiór/import/commit; etap kończy się handoffem.
