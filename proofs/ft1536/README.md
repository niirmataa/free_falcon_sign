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
także dziesięć etapów badawczych, w tym późniejsze H3_RANGE i H3_ZERO_SCALAR.

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

**Następne przygotowane zadanie:** [H3_ROOT_LDL](documents/FT1536_ZADANIE_ASTRA_H3_ROOT_LDL_2026-09-19.md)
— certyfikat źródłowych FFT/Gram i subtractive korzenia LDL2 dla emitted
support, z dzielnikami/pivotami, L, błędami oraz frame bindingiem.
[Publiczny zestaw wejść](background/H3_ROOT_LDL_2026-09-19/README.md) ma106
przypiętych członków i gotową kopię w świeżym W. Niższe poziomy drzewa
i ordered Reach są kolejnymi obowiązkami.

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
oraz `FT1536_H3_RANGE_RUN_001` i `FT1536_H3_ZERO_SCALAR_RUN_001`.
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
