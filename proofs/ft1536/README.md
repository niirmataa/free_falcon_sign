# FT1536 — wersjonowane punkty kontrolne dowodów

To archiwum ukończonych etapów FT1536 w docelowym `free_falcon_sign`.
Każdy wpis `catalog/*.json` wskazuje konkretny raport, zewnętrzny pin
OUTPUTS oraz niezmienione bajty objęte tym manifestem.

Źródła projektu zachowują ścieżkę `Extra/c`; `FT1536` jest nazwą profilu/builda.
Kopie źródeł wewnątrz checkpointów dokumentują badane wersje i umożliwiają
replay. Integracja zaakceptowanej poprawki do źródeł odbywa się osobnym
commitem w `Extra/c`, bez przemianowania historycznego katalogu Extra.

**Aktywny build na main:** Extra/c zawiera teraz dokładnego kandydata L_RHO,
manifest `2553358f...`, użytego przez L_NTT/L_V/M0. Komendy i pełna tożsamość:
[główny README](../../README.md) oraz
[proweniencja aktywnego builda](../../provenance/FT1536_ACTIVE_BUILD.md).

## Mapa dalszych działań

**[Zamrożony punkt pracy po M0](stages/FT1536_POST_M0_FREEZE_RUN_001/REPORT.md)**
jest obszernym zapisem stanu na aktywnym buildzie main `2959064`: źródła,
osiągnięcia, T2C3/T5, kontrakt M0, graf zależności i dalsze obowiązki.
Pakiet ma 211 członków OUTPUTS i 198 publicznych wejść Git, manifest
`c3efdcff510983a143946d43ab456656090061cd5b9b4b6847abc7f141c0cfa3`.
Jest checkpointem dokumentacyjnym (`replay=none`); obecnie archiwum zawiera
także osiemnaście etapów badawczych i audytowych, w tym późniejsze H3_RANGE,
H3_ZERO_SCALAR, H3_ROOT_LDL, H3_NODE3, H3_NODE2, BINARY_TOWER, audyt FPEMU,
FLOOR_CT, RAW_ASSEMBLY i STABLE_NORMALIZATION.

[Mapa po domknięciu L_V — 2026-09-19](documents/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md)
przedstawia zależności i proponowaną kolejność: dokładny kontrakt gry,
osiągalność H3, pełne prawo Sign i bajty, spójna konsumpcja R5T, ciaśniejszy
transfer chi-square, symulacja ROM i końcowa kompozycja. Jest materiałem
do omówienia przed wyborem następnego zadania Astry.

Po omówieniu właściciel wybrał pojemność **4096 bajtów payloadu Sign**
(nonce 40 bajtów osobno) oraz **parametryczny** cel redukcji.
[Zlecenie M0](documents/FT1536_ZADANIE_ASTRA_M0_CONTRACT_2026-09-19.md)
zakończyło się wynikiem
[M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE](stages/FT1536_M0_CONTRACT_RUN_001/REPORT.md).
Kontrakt, 22-wierszowy ledger i dowód payloadu STATIC <=3160 są gotowe.
Następny interfejs źródłowy to [H3](stages/FT1536_M0_CONTRACT_RUN_001/H3_INTERFACE.md).
M0 nie jest jeszcze dowodem końcowej redukcji ani integracją opakowania.

**Odebrany H3_RANGE:** [raport częściowy](stages/FT1536_H3_RANGE_RUN_001/REPORT.md)
zachowuje `PARTIAL_PROOF`. Niezależny replay odtworzył 96/96 plików i 49
twierdzeń. Lokalny proposal/floor/residual interface jest sprawdzony, a
`Reach_call_C -> CenterClass` pozostaje otwarty. [Odbiór](validation/2026-09-19-h3/README.md)
rozlicza negative zero, underflow oraz granice syntetycznych kontroli.
[Zlecenie](documents/FT1536_ZADANIE_ASTRA_H3_RANGE_2026-09-19.md) i
[publiczne wejścia](background/H3_RANGE_2026-09-19/README.md) zachowują piny.

**Odebrany H3_ZERO_SCALAR:** [wynik lokalny](stages/FT1536_H3_ZERO_SCALAR_RUN_001/REPORT.md)
ma status `H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL`, z mieszaną warstwą
Lean/analityczny dowód źródłowy. Domknięto zero-aware floor/cast/s+z i
of/sub z E_r=E_res=2^-20 dla wszystkich NumericCenter, także obu zer
i subnormals. [Niezależny odbiór](validation/2026-09-19-zero-scalar/README.md):
95/95 plików, 17 modułów i 97 twierdzeń (48 nowych).
Globalne `Reach_call_C -> NumericCenter` i prawo samplera pozostają otwarte.
[Zlecenie](documents/FT1536_ZADANIE_ASTRA_H3_ZERO_SCALAR_2026-09-19.md) oraz
[bootstrap](background/H3_ZERO_SCALAR_2026-09-19/README.md) zachowują piny.

**Odebrany H3_ROOT_LDL:** [raport](stages/FT1536_H3_ROOT_LDL_RUN_001/REPORT.md)
ma status `H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL`. Wyprowadzono source
FFT/Gram, dodatni root denominator, L i subtractive Schur z
`32<Re(D_C)<2^31`, `abs(Im(D_C))<32`, wraz z conditional root frame.
[Niezależny odbiór](validation/2026-09-19-root-ldl/README.md): 131/131 plików,
17 modułów i 99 twierdzeń (17 nowych); pełna kompozycja jest mieszana
analityczna/kernelowa. [NEXT_INTERFACE](stages/FT1536_H3_ROOT_LDL_RUN_001/NEXT_INTERFACE.md)
określa dalszy certyfikat split_top/LDL_dim3 dla obu branches.

**Odebrany H3_NODE3:** [raport](stages/FT1536_H3_NODE3_RUN_001/REPORT.md)
ma status `H3_NODE3_PROVED_FOR_PINNED_MODEL`: jeden c3 dla obu branches
i wszystkich 256 slots, dodatnie pivots, L10/L20<2 i L21<4, osobne errors
i imaginary bounds, nowa domena div[1/16,2^35] oraz frame.
[Odbiór](validation/2026-09-19-node3/README.md): 123/123 plików, 21 modułów,
115 twierdzeń (16 nowych), z jawnym mixed proof scope.
[NEXT_INTERFACE](stages/FT1536_H3_NODE3_RUN_001/NEXT_INTERFACE.md) eksportuje
sześć diagonal branches do pierwszego split_deep/inner LDL2.

**Odebrany H3_NODE2:** [raport](stages/FT1536_H3_NODE2_RUN_001/REPORT.md)
ma status `H3_NODE2_PROVED_FOR_PINNED_MODEL`, dokładnie dla split9/LDL8,
2×3×128 positions. Nowe wyniki obejmują |Im(root D_C)|<1, kernelowy half
na wszystkich finite words i dodatnie computed pivots.
[Odbiór](validation/2026-09-19-node2/README.md): 160/160 plików, 26 modułów,
131 twierdzeń (16 nowych), z jawnym mixed proof scope.
[NEXT_INTERFACE](stages/FT1536_H3_NODE2_RUN_001/NEXT_INTERFACE.md) podaje
level7 i warunki dalszej kompozycji parametrycznego binary step.

**Odebrany BINARY_TOWER:** [raport](stages/FT1536_H3_BINARY_TOWER_RUN_001/REPORT.md)
ma status `H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL`: wszystkie levels7–1
oraz actual defined terminating execution12 raw inner7 subtrees.
[Odbiór](validation/2026-09-20-binary-tower/README.md):175/175 plików,
30 modułów,147 twierdzeń (16 nowych), mixed analytical/kernel scope.
[NEXT_INTERFACE](stages/FT1536_H3_BINARY_TOWER_RUN_001/NEXT_INTERFACE.md)
zachowuje pełny raw-loader assembly, stable normalization, targets i Reach
jako dalsze odrębne obowiązki.

**Odebrany audyt FPEMU:** [raport](stages/FT1536_FPEMU_AUDIT_RUN_001/REPORT.md)
ma status `CONFIRMED_ISSUE` w zakresie generic numeric fpr_lt(-0,+0)=1
i operand-dependent compiled floor branch przy GCC14.2/-O, również w Sign.
[Niezależny odbiór](validation/2026-09-20-fpemu-audit/README.md): 29/29 plików,
140225 scalar cases i 250 delta cases na tryb normal/ASan+UBSan, 29 historycznych
modułów Lean. W tamtym zamrożonym audycie dudect/ctgrind miały NOT_RUN.
[Bieżąca macierz wpływu](validation/2026-09-20-fpemu-audit/CURRENT_IMPACT.md)
rozlicza późniejszy NODE2 i BINARY_TOWER. Nie znaleziono kontrprzykładu do
badanych lokalnych arithmetic contracts; source pozostaje niezmienione.

**Późniejsza kampania dudect zakończona:** [raport baseline](background/FPEMU_FLOOR_CT_2026-09-20/DUD/REPORT.md)
zapisuje3 rundy/36 prób+6 controls,7h59m42s. Floor:9/9 LEAKAGE_FOUND;
pozostałe9 kontrastów:27/27 NO_LEAKAGE_EVIDENCE_YET; controls poprawne.
[Ponowne przeliczenie raw](background/FPEMU_FLOOR_CT_2026-09-20/DUD/RECEIPT_REVIEW.json)
odtworzyło wszystkie102 stany testów każdej partii dla9 floor probes i6 controls.
To [projekcja wejściowa](background/FPEMU_FLOOR_CT_2026-09-20/README.md),
nie pełny import raw wszystkich42 prób ani proof CT współdzielonego hosta.

**Odebrany kandydat FLOOR_CT:** [raport](stages/FT1536_FPEMU_FLOOR_CT_RUN_001/REPORT.md)
ma status `FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD`: all-word bit-equivalence
i definedness w jawnym GCC/LP64 modelu, pięć real machine regions i prespecified
A/B (baseline9/9 wykryć, candidate9/9 bez sygnału, controls6/6+6/6).
[Odbiór](validation/2026-09-20-floor-ct/README.md):235/235 plików,8 modułów,
41 twierdzeń (15 nowych),1065562 przypadki w normal/sanitizers i pełna
rekalkulacja9771 partii A/B. Nowy17-file pin56974571… jest w
stage/candidate; produkcyjny Extra/c ma nadal baseline pin2553358f….
Source integration i dalsze interfejsy matematyczne mają własny zakres.

**Odebrany RAW_ASSEMBLY:** [raport](stages/FT1536_H3_RAW_ASSEMBLY_RUN_001/REPORT.md)
domyka actual raw prefix do powrotu ffLDL_fft3:6144 basis,18432 raw tree,
source order/totality/frame i emitted corollary. [Odbiór](validation/2026-09-20-raw-assembly/README.md):
195/195 plików,33 moduły,180 twierdzeń (33 nowych), mixed analytical/kernel scope.
Źródła mają pin56974571…; pełny normalized loader pozostaje odrębny.
[Uwagi do następnego typu](validation/2026-09-20-raw-assembly/NEXT_SCOPE.md)
rozdzielają P_key/raw computation od narrow stable gate acceptance i wymagają
źródłowego bridge obowiązkowego certificate udanego KeyGen.

**Odebrany STABLE_NORMALIZATION:** [raport](stages/FT1536_H3_STABLE_NORMALIZATION_RUN_001/REPORT.md)
domyka emitted gate bridge, actual1536 stored widths, source sqrt54/div/scaling
i preserved L/basis. [Odbiór](validation/2026-09-20-stable-normalization/README.md):
262/262 plików,40 modułów,230 twierdzeń (50 nowych), mixed proof boundary.
Stored sigma²∈(1.7763,575.9999), paired∈(2.3684,767.9999), literal dss obu
klas>1/1536. All-P_key definedness jest proved, narrow gate acceptance nadal
OPEN_NOT_DISPROVED. Source success event/K_seed pozostają te same.
Następne typy to INITIAL_TARGETS oraz osobny ORDERED_REACH→NumericCenter.

**Następne zadanie do ręcznego startu:**
[H3_INITIAL_TARGETS](documents/FT1536_ZADANIE_ASTRA_H3_INITIAL_TARGETS_2026-09-20.md),
z [bootstrapem198 członków](background/H3_INITIAL_TARGETS_2026-09-20/README.md).
Cel: actual target prefix do_sign1849–1892 dla wszystkich canonical c,
source words/domains/errors i key/frame przed ffSampling_fft3. FFT challenge
domain18432 wymaga nowej instancji; scalar NumericCenter pozostaje osobny.

Mapa pokazuje również całe historyczne ścieżki T2C3 i T5. Szczegółowe
publiczne opracowania z zachowanymi pinami:

- [ciągłość K0, uporządkowanej bazy i etapów T2C3](documents/FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md);
- [późniejsza weryfikacja uzasadnienia D11E2](documents/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md);
- [mapa twierdzeń T2C3/T5 i ich publicznego pakietu](documents/FT1536_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md).

T2C3 dotyczy idealnego obrazu po ostrym obcięciu dla jednej kanonicznej
instancji; T5 jest odrębnym pure/untruncated twierdzeniem dla każdego
successful-KeyGen output. Datowane opracowania zachowują historyczny zakres;
aktualne domknięcie L_V kandydata opisuje tabela i sekcja poniżej.

## Układ

- `stages/<id>/`: wyłącznie OUTPUTS.sha256 i jego członkowie; bez cache,
  nieprzypiętego ogona dziennika i roboczych binariów;
- `objects/<sha256>`: publiczne wejścia wymienione w INPUTS, deduplikowane
  po treści; oryginalne ścieżki są zachowane w katalogu jako proweniencja;
- `catalog/<id>.json`: piny, status, mapa INPUTS i przepis replayu;
- `documents/`: czytelne kopie zleceń i notatek; historia istnieje w Git;
- `tools/archive.py`: import, odczytowa weryfikacja i izolowany replay;
- `work/`, `replay-work/`: lokalne, ignorowane obszary robocze.

Historycznych INPUTS, raportów i skryptów nie przepisuje się, aby zmienić
ich ścieżki. Weryfikator używa mapy oryginalne wejście → obiekt w repo.
Weryfikacja archiwum nie potrzebuje oryginalnych katalogów Dokumenty/H/USB.
Nie jest ona nowym dowodem matematycznym: raport zachowuje swój zakres i werdykt.

## Weryfikacja po pobraniu repo

### Zapisane etapy

| Etap | Werdykt / zakres | Commit checkpointu |
|---|---|---|
| L_V-STATIC | kontrprzykład do ustalonego Ext0 | `0b7cc0d` |
| Odbiór Blue | niezależne potwierdzenie kontrprzykładu | `bf4fb40` |
| L_RHO | poprawna normalizacja całej dziedziny int16 w przypiętym modelu | `5c2cdcc` |
| L_NTT | lokalne kontrakty i certyfikaty; globalna kompozycja częściowa | `1d78645` |
| L_NTT_GLOBAL | globalny inverse; na tym etapie forward_product pozostawało otwarte | `d67228d` |
| [L_NTT_FORWARD](stages/FT1536_L_NTT_FORWARD_RUN_001/REPORT.md) | **L_NTT_PROVED_FOR_PINNED_MODEL** — forward, iloczyn i pełna kompozycja | `71bbb35` |
| [L_V_BRIDGE](stages/FT1536_L_V_BRIDGE_RUN_001/REPORT.md) | **L_V_PROVED_FOR_PINNED_MODEL** — pełny most bajtowy Verify → Ext0 dla kandydata | `17f8f8b` |
| [M0](stages/FT1536_M0_CONTRACT_RUN_001/REPORT.md) | **M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE** — gra, budżety, framing i dowód pojemności | `95f8015` |
| [H3_RANGE](stages/FT1536_H3_RANGE_RUN_001/REPORT.md) | **PARTIAL_PROOF** — lokalne floor/proposal/residual; globalna osiągalność otwarta | `cb99e67` |
| [H3_ZERO_SCALAR](stages/FT1536_H3_ZERO_SCALAR_RUN_001/REPORT.md) | **H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL** — lokalny zero-aware most, błąd 2^-20; mieszany dowód | `9a76ecf` |
| [H3_ROOT_LDL](stages/FT1536_H3_ROOT_LDL_RUN_001/REPORT.md) | **H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL** — source FFT/Gram, dodatni subtractive root pivot i frame; mieszany dowód | `3d6bf58` |
| [H3_NODE3](stages/FT1536_H3_NODE3_RUN_001/REPORT.md) | **H3_NODE3_PROVED_FOR_PINNED_MODEL** — uniform split_top/Adj/LDL3, obie branches i 256 slots; mieszany dowód | `afa52d8` |
| [H3_NODE2](stages/FT1536_H3_NODE2_RUN_001/REPORT.md) | **H3_NODE2_PROVED_FOR_PINNED_MODEL** — pierwszy binary level8, half i upstream imaginary refinement; mieszany dowód | `b27a055` |
| [FPEMU audit](stages/FT1536_FPEMU_AUDIT_RUN_001/REPORT.md) | **CONFIRMED_ISSUE** — generic signed-zero compare i compiled floor branch; timing NOT_RUN | `8bbab81` |
| [BINARY_TOWER](stages/FT1536_H3_BINARY_TOWER_RUN_001/REPORT.md) | **H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL** — levels7–1 i12 total raw subtrees; mieszany dowód | `1a04145` |
| [FLOOR_CT](stages/FT1536_FPEMU_FLOOR_CT_RUN_001/REPORT.md) | **FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD** — bit-preserving patch i kwalifikowana walidacja buildu; osobna integracja | `6ed89ca` |
| [RAW_ASSEMBLY](stages/FT1536_H3_RAW_ASSEMBLY_RUN_001/REPORT.md) | **H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL** — pełny raw prefix, source transport i emitted corollary; mieszany dowód | `a53d723` |
| [STABLE_NORMALIZATION](stages/FT1536_H3_STABLE_NORMALIZATION_RUN_001/REPORT.md) | **H3_STABLE_NORMALIZATION_PROVED_FOR_EMITTED_PINNED_MODEL** — actual widths/gates i source sqrt/div; mieszany dowód | niniejszy checkpoint |

Identyfikatory starszych lokalnych commitów są rozliczone w
[mapie historii publikacji](history/README.md).

### Aktualny wynik L_NTT

Checkpoint FORWARD domyka ostatnią globalną przesłankę poprzedniej kompozycji.
W `formal/Complete.lean` końcowe twierdzenie ma postać:

```text
FT1536Forward.L_NTT : ∀ h r c,
  CanonVec h → CanonVec r → CanonVec c →
  pipelineC h r c = (product h r, subtract (product h r) c).
```

Iloczyn pozostaje niezależnym iloczynem współczynnikowym z `remMonomial`.
Dowiedziono ewaluacji forward w fizycznym porządku `3i+j`, `forward_product`,
zakresów oraz podstawienia L_RHO dla wszystkich signed int16.
Pełne typy i termy dowodowe są w
[AuditTypes.stdout](stages/FT1536_L_NTT_FORWARD_RUN_001/logs/final/AuditTypes.stdout).
Powiązanie z C99/GCC/LP64 i warunki buforów określa
[CLAIM](stages/FT1536_L_NTT_FORWARD_RUN_001/CLAIM.md).

Odbiór odtworzył **63 moduły, 472 twierdzenia (109 nowych)** i **217/217**
plików znaczeniowych ze świeżej kopii archiwum:
[zapis kontroli FORWARD](validation/2026-09-18-forward/README.md).

### Aktualny wynik L_V

[Zadanie mostu L_V](documents/FT1536_ZADANIE_ASTRA_L_V_BRIDGE_2026-09-19.md)
zostało domknięte w checkpointcie **L_V_BRIDGE**. Dla wszystkich canonical h,c
i legalnych skończonych ciągów bajtów b w przypiętym modelu:

```text
V_CAND(h,c,b)=1 =>
  s(b) i Ext0 są zdefiniowane,
  z1+h*z2=c modulo(q,Phi),
  Q(z1,z2)<2093922385,
  gdzie (z1,z2)=Ext0(h,c,b)=(center_q(c-h*s(b)),s(b)).
```

Dowód konsumuje L_NTT_rho i domyka centrowanie C, znak Ext0, dokładną normę
int64, ścisły próg, dekodery NONE/STATIC, guards i przygotowanie klucza.
Obejmuje uint32 wrap dowolnie długiego skończonego unary i narrowing GCC;
nie dodaje limitu 2049 bajtów. Eksporty formalne: `L_V_BYTES`, `L_V_LOADED`,
`L_V_SOURCE`; [dokładna teza i model](stages/FT1536_L_V_BRIDGE_RUN_001/CLAIM.md).

Odbiór odtworzył **73 moduły, 570 twierdzeń (104 nowe), 402/402 pliki**,
w tym kontrole C/Lean/Sage i ASan/UBSan:
[zapis kontroli L_V](validation/2026-09-19-lv/README.md).

`full_L_V_proved=true` dotyczy wyłącznie kandydata `falcon-vrfy.c` o SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Historyczny raport zachowuje wykonawcze `source_integrated=false` i
`owner_accepted=false`; późniejsza integracja tego dokładnego kandydata
na main jest odrębnym zdarzeniem opisanym w proweniencji aktywnego builda.
Historyczny kontrprzykład S17 i wcześniejsze wyniki częściowe zachowują swoje
zakresy. Pełne L_V nie zamyka samplera, rozkładu kluczy, EUF-CMA, MT-ISIS
ani warunkowych transferów strat redukcji.

### Kontrakt i pojemność po M0

[GAME](stages/FT1536_M0_CONTRACT_RUN_001/GAME.md),
[RESOURCE_MODEL](stages/FT1536_M0_CONTRACT_RUN_001/RESOURCE_MODEL.md) i
[HOP_LEDGER](stages/FT1536_M0_CONTRACT_RUN_001/HOP_LEDGER.md) definiują
parametryczny klasyczny cel EUF-CMA. Własne obowiązki źródłowe i rozkładowe
mają jawne statusy; `security_reduction_proved=false`.

Nowy [dowód pojemności](stages/FT1536_M0_CONTRACT_RUN_001/CAPACITY.md) daje
po zdefiniowanym source norm acceptance payload STATIC <=3160 bajtów,
więc wybrany bufor 4096 wystarcza. Syntetyczny short vector wymaga 3156:
stare pojemności 2049 i 3073 nie wystarczają uniwersalnie. Nonce40 jest osobno.
[Odbiór M0](validation/2026-09-19-m0/README.md) odtworzył 273/273 pliki,
67 modułów i 535 twierdzeń (43 nowe), wraz z normal/ASan/UBSan.

### Wynik częściowy H3_RANGE

Lokalne wyniki obejmują support propozycji `[-365,366]`, floor refinement
w jawnej domenie, right-before-left i 3072 calls oraz error-aware residual
lemmas. `fpr_floor(-0)=-1` narusza mathematical-floor equality, lecz samo nie
powoduje overflow s+z. Przykłady underflow wymagają modelu rzeczywistego FPEMU.
Nie wykazano osiągalności tych syntetycznych przypadków z emitted KeyGen.

[REACHABILITY](stages/FT1536_H3_RANGE_RUN_001/REACHABILITY.md) i
[ledger](stages/FT1536_H3_RANGE_RUN_001/BOUND_LEDGER.md) zachowują pełny cel:
zero/domain invariant, internal LDL pivots/L, machine-error transfer i
emitted/loader refinement pozostają otwarte. Odbiór odtworzył 8 modułów,
49 nowych twierdzeń oraz 96/96 plików; [receipts](validation/2026-09-19-h3/README.md).

Odtwarzanie z czystego checkoutu Git i ukrytymi oryginałami sprawdzono
2026-09-18: [zapis kontroli](validation/2026-09-18/README.md).

Z katalogu głównego repo, Python 3.11 lub nowszy (biblioteka standardowa):

```sh
python3 -B proofs/ft1536/tools/archive.py list
python3 -B proofs/ft1536/tools/archive.py verify
python3 -B -m unittest discover -s proofs/ft1536/tests -v
```

Polecenie verify sprawdza zewnętrzne piny w katalogu, wszystkie członki
OUTPUTS, dokładny zbiór plików archiwum oraz wszystkie zarchiwizowane INPUTS.
Nie traktuje zgodnych hashy jako potwierdzenia pełnego L_V.

## Odtwarzanie obliczeń

Przykład dla lokalnego L_RHO:

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_L_RHO_RUN_001 --run replay-001 --hide-originals
```

Analogicznie dla `FT1536_LV_STATIC_RUN_001`, `FT1536_L_NTT_RUN_001`,
`FT1536_L_NTT_GLOBAL_RUN_001`, `FT1536_L_NTT_FORWARD_RUN_001`
i `FT1536_L_V_BRIDGE_RUN_001`, `FT1536_M0_CONTRACT_RUN_001`
oraz `FT1536_H3_RANGE_RUN_001`, `FT1536_H3_ZERO_SCALAR_RUN_001`
i `FT1536_H3_ROOT_LDL_RUN_001`, `FT1536_H3_NODE3_RUN_001`
oraz `FT1536_H3_NODE2_RUN_001`, `FT1536_FPEMU_AUDIT_RUN_001`
i `FT1536_H3_BINARY_TOWER_RUN_001`, `FT1536_FPEMU_FLOOR_CT_RUN_001`
oraz `FT1536_H3_RAW_ASSEMBLY_RUN_001` i `FT1536_H3_STABLE_NORMALIZATION_RUN_001`.
Wpis katalogu określa właściwy punkt wejścia. Odbiór Blue jest archiwum
recenzji i receipts; nie ma zadeklarowanego pojedynczego pełnego runnera.

Runner tworzy świeżą kopię pod `replay-work/<id>/<run>/`, przywraca roboczy
COMMANDS wyłącznie z zamrożonego prefiksu, a następnie uruchamia przypięty
skrypt replayu z oczekiwanym hashem OUTPUTS. Root sandboxa jest read-only,
zapis dozwolony tylko w tej świeżej kopii, sieć odłączona. Opcja
`--hide-originals` dodatkowo ukrywa historyczne Dokumenty i H, jeśli istnieją.
Katalog uruchomienia musi być nowy. Wszystkie logi i wynik pozostają w nim,
również przy błędzie lub przekroczeniu limitu. Archiwum pozostaje read-only.

Wynik operacji zawiera status historycznej tezy osobno od wyniku replayu:
udane odtworzenie `PARTIAL_PROOF` nadal jest wynikiem częściowym.

### Przypięte środowisko

Pełne replaye wymagają Linux x86_64 LP64, GCC 14.2.0, Python 3, bwrap,
SageMath 10.9 i Lean 4.34.0/Std. Zachowane skrypty używają ścieżek:

```text
/home/footfalcon/.local/bin/sage
/home/footfalcon/miniforge3/envs/sage/bin/python
/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
```

Te narzędzia i ich środowiska trzeba udostępnić pod zapisanymi ścieżkami.
Repo nie zawiera dystrybucji kompilatorów ani menedżerów pakietów i niczego
nie instaluje. Inne wersje lub mapowanie narzędzi trzeba opisać jako osobną
konfigurację odtworzenia, zachowując oryginalne piny.

## Import następnego etapu

Po zakończeniu pracy, zamrożeniu OUTPUTS i otrzymaniu hashy w przekazaniu:

```sh
python3 -B proofs/ft1536/tools/archive.py import /ABSOLUTE/COMPLETED_STAGE \
  --manifest-sha MANIFEST_SHA256 --report-sha REPORT_SHA256 \
  --replay standard
python3 -B proofs/ft1536/tools/archive.py verify COMPLETED_STAGE
```

`standard` oznacza sprawdzony protokół `scripts/replay.py DEST OUTPUTS_SHA`,
z DEST pod tmp świeżej kopii. Dla dawnego L_V użyj `--replay lv-static`;
dla GLOBAL z jego przepisem pre-freeze `--replay global-crt`, a dla pakietu
bez takiego runnera `--replay none`. Przed wyborem protokołu
przeczytaj REPLAY danego etapu. Inne nazwy raportu/JSON podaje się przez
`--report` i `--result`.

Adapter `global-crt` pomija w świeżym seed wyłącznie dawny podkatalog replay/
i metadane jego odtworzenia, które skrypt tworzy ponownie. Pominięcia są
wymienione w receipt. Wrapper przed wykonaniem weryfikuje pełne archiwum,
a po wykonaniu porównuje cały wykaz i bajty plików znaczeniowych ze
**zarchiwizowanym** receipt. Sam nowy napis PASS nie wystarcza.

Importer kopiuje tylko jawne członki manifestu i publiczne zadeklarowane
wejścia, weryfikuje hashe, odrzuca symlinki i ucieczki ścieżek. Nie nadpisuje
etapu inną wersją: nowy wynik wymaga nowego identyfikatora. Powtórzenie
identycznego importu tylko sprawdza już zapisany checkpoint.

Zlecenie/notatkę można dołączyć czytelną kopią:

```sh
python3 -B proofs/ft1536/tools/archive.py document /ABSOLUTE/TASK.md --sha SHA256
```

## Commit po każdym zakończonym zadaniu

1. Sprawdzić raport, status i piny. Zachować dokładnie `PROVED`,
   `PARTIAL_PROOF`, kontrprzykład albo blokadę — bez zmiany znaczenia.
2. Zaimportować zamknięty pakiet oraz zlecenie; uruchomić verify.
3. Wykonać kontrole właściwe dla nowych narzędzi lub zmienionego replayu.
4. Sprawdzić `git status`, diff roboczy/staged i `git log --oneline -10`.
5. Dodać wyłącznie pliki danego etapu i utworzyć osobny commit, np.
   `proof: record L_NTT partial proof checkpoint`.
6. Podać hash commita obok hashy raportu i OUTPUTS w przekazaniu użytkownikowi.

Docelowa gałąź to lokalny **main**. Jeśli checkpoint powstał na innej gałęzi,
po sprawdzeniu przenieś go fast-forward, o ile historia na to pozwala.
Przy zajętym roboczym indeksie użyj osobnego worktree do operacji na main.
Rozbieżnej historii nie nadpisuj. Push pozostaje osobnym poleceniem właściciela.

Nowe zadania mogą używać `proofs/ft1536/work/<id>/` jako sandboxa obliczeń.
Ta robocza zawartość jest ignorowana; po zakończeniu zadania importer zapisze
jej zamrożony zakres pod stages/, a następny commit obejmie ten checkpoint.

Przy wcześniejszych staged zmianach używać dokładnych pathspeców i
`git commit --only -- <własne ścieżki>`. Jeden wykonawca operuje na indeksie.
Obecnie prowadzący sesję wykonuje commit po sprawdzeniu raportu Astry.
Jeśli obowiązek przejmie Astra, musi otrzymać ten zakres i odpowiedni dostęp
do repo; sandbox samego obliczenia nadal powinien obejmować tylko jego W.

Commit checkpointu nie integruje kandydata z Extra/c ani nie nadaje
owner acceptance. Każde kolejne zadanie dodaje się po zamknięciu
odpowiedniego punktu kontrolnego. Aktywnego drzewa nie migruje się podczas
zapisu przez wykonawcę.
