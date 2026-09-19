# GPT-ASTRA — H3_RANGE: osiągalne centra i bezpieczne operacje całkowitoliczbowe

Data: 2026-09-19. Autor projektu: Niirmata.
Kontynuacja po L_V i `M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE`.

## 0. Jedno zadanie i jego cel

Wykonaj **M1/H3_RANGE** dla dokładnego aktywnego kandydata FT1536:
zwiąż rzeczywiste osiągalne stany signera z zakresem centrum przed
`fpr_floor -> int` i wyprowadź zdefiniowane `s+z`.

Cel jest uniwersalny po skutecznie wyemitowanych kluczach i osiągalnych
historiach, nie po kilku kluczach/probach. Wynik może być pełnym dowodem,
nowym precyzyjnym wynikiem częściowym lub kontrprzykładem w odpowiednio
rozróżnionej dziedzinie. Wykonaj pracę do raportu, freeze i replayu.

Zachowaj kontekst obecnej rozmowy Astry. M0 jest ukończonym kontraktem,
nie nieudaną próbą pełnego bezpieczeństwa. Teraz domykasz konkretną otwartą
przesłankę źródłową. Pełne source Sign law, H6, R5T i M7 pozostają odrębne.

## 1. Świeży katalog i gotowe wejścia

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_RANGE_RUN_001
IN = W/inputs/bootstrap
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_RANGE_2026-09-19.md
BASE = f5266765c5f0733fb3ab6a5e2906aa44d15e17f7
```

W przygotowano z AGENTS.md i przypiętym bootstrapem. Potwierdź zawartość,
cwd, rzeczywisty sandbox wyłącznie W oraz brak innego wykonawcy.
Przeczytaj REPO/AGENTS.md i lokalny AGENTS.

Bootstrap to bajtowo identyczna kopia wersjonowanego zestawu
`proofs/ft1536/background/H3_RANGE_2026-09-19/`. Zawiera 50 publicznych
oryginałów, ORIGINS.json i README; MANIFEST ma 52 wpisy.

**Zewnętrzny SHA-256 IN/MANIFEST.sha256:**

```text
f9ea278838e9d1f8f959100175f56c62217997ff25611fccc0b9353dd9fcfe40
```

Zweryfikuj ten pin i WSZYSTKICH członków manifestu. Pliki bootstrap są
wejściami read-only. Do W/source możesz skopiować 17 źródeł, zachowując
tożsamość; modele, adaptery i kontrolery twórz osobno.

| Wejście w IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| M0/REPORT.md | `b71d71e8d89022ea321241d0ddabdddf4a3b81bfc9fe4faca08476baf6e71c29` |
| M0/OUTPUTS.sha256 | `08c9b6afe630e11bd98f33a910476950442854e5925efaa7f8fa1d0d8c8d695d` |
| M0/PROFILE.json | `55dc91b373858ddaab78ac4f125538505279c5f74ac3d4e4569a02164ebb1e56` |
| M0/GAME.md | `91e6323c6c3a7be748b7f029d048c38700eab924bf139b804941c10968ba363c` |
| M0/H3_INTERFACE.md | `2e427f66d242cd4a95f777b9be8948ced315d3c683727d21e965c5fb3934e97c` |
| FREEZE/REPORT.md | `5c59b414c78511743118bca67b95a11f4d78718902f1ca5f1902756937017fa6` |
| FREEZE/OUTPUTS.sha256 | `c3efdcff510983a143946d43ab456656090061cd5b9b4b6847abc7f141c0cfa3` |
| source/falcon-sign.c | `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8` |
| source/falcon-keygen.c | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |
| source/falcon-fft.c | `06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063` |
| source/fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| source/fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| source/ft1536-adaptive-cdf-tables.h | `c16f041a64aba25991b5473111675f1c046ebc38285fca6c052124cf3b7fdf4f` |
| legacy/H3/CENTER_BOUND_AUDIT.md | `75ccf272d0574ccc39c9f16e811411e302784ead465896e67ae39e13b1055675` |
| legacy/H3/h3_theorem.tex | `52a896019a704afd3b5eb63139b0809c4b479dede27cd3bdd2b4219c2bf6f5ea` |

Pozostałe pliki historyczne mają piny w MANIFEST i pochodzenie w ORIGINS.
To jawny publiczny wycinek H3/H4/T5, nie pełny eksport każdego starego
pakietu. Kopie dawnych OUTPUTS są proweniencją i zachowują pierwotne bazy.

**Ważne dla lokalizacji:** główny roboczy checkout REPO ma własny wcześniejszy
indeks i może być na starszej gałęzi. Źródłem zadania jest bootstrap z BASE,
zgodny z opublikowanym aktywnym main, a nie przypadkowe REPO/Extra/c.
Nie zmieniaj checkoutu, indeksu lub branch refs, by uzyskać zgodność.
Nie ma zależności wykonawczej od tymczasowego worktree prowadzącego lub USB.

## 2. Zachowany profil i dokładna dziedzina

N=1536, q=18433, Phi=X^1536-X^768+1, sigma_sign=768, B=2093922385,
full ternary MODE1, FPEMU, aktywne flagi przypiętego Makefile.
M0: jeden wspólny K_seed[E], świeży signer context na query, 16 outer attempts,
caller4096, nonce40, pełne obserwowalne aborty, cel parametryczny.

Kwantyfikator po (sk,pk) to **faktyczny successful-output support całego
źródłowego KeyGen** z M0. Nie utożsamiaj go z K_iid, jednym h* lub dowolnym
kluczem akceptowanym przez prywatny loader. Uwzględnij każdy właściwy M0
environment E, każdą osiągalną historię oracle, canonical target c, próbę
outer 1..16 i każdy skończony prefiks aktywnych scalar calls/rejection draws.

Przeanalizuj źródłową relację Reach_call_C. Ma opisywać realny prefix
wykonania, ładowanie tego samego wyemitowanego sk, drzewo, bufory, FPR bits,
fault state i kolejność operacji. Nie wolno wbudować żądanego zakresu centrum
w definicję Reach albo nazwać wszystkich niewygodnych stanów nieosiągalnymi.
Wykaż związek własnych reprezentacji z konkretnym C i stanem inicjalnym.

## 3. Teza do rozstrzygnięcia

Przy wejściu do aktywnej konwersji w sampler_large, po rzeczywistych guardach
fault==NONE, finite(mu) i positive-finite(sigma), udowodnij:

```text
Reach_call_C(sk,pk,history,attempt,call,state,mu_bits,sigma_bits) =>
  floor(exact_value(mu_bits)) in [-2147483283,2147483281]
  oraz fpr_floor(mu) i long->int mają wymaganą dokładną semantykę;

dla każdego rzeczywistego zwróconego proposal z:
  -365 <= z <= 366
  INT32_MIN <= s+z <= INT32_MAX,
  więc wykonany return s+z jest zdefiniowany.
```

Równoważny wystarczający przedział pre-floor to
`-2147483283 <= exact_value(mu_bits) < 2147483282`.
Jeśli wyprowadzisz inny wystarczający interfejs, porównaj go jawnie z C_mu
starego H3 i interfejsem M0. Nie relabeluj zmienionej tezy jako dowodu tej samej.

Przedmiotem jest osiągalność i lokalna poprawność operacji, nie pełne prawo
samplera. Domknięcie tego etapu nie ustawia automatycznie H3 arithmetic,
H1R/FFO, H6, R5T lub M7 jako bezwarunkowo skonsumowanych.

## 4. Kolejność pracy

### A. Lokalny kontrakt FPEMU i właściwa kolejność guards

Najpierw ustal semantykę faktycznych funkcji/bitów potrzebnych do tezy.
Nie utożsamiaj backendu z kompletną implementacją wszystkich przypadków
IEEE binary64 na podstawie samej nazwy lub testu fpr-double.

- `sampler_large`: sign2841–2864, floor w2864; **dss jest liczone i sprawdzane
  dopiero później** w2866–2875. Calls odrzucane później na dss/gap/exponent
  nadal muszą mieć bezpieczną wcześniejszą konwersję.
- `fpr_floor` zwraca long: fpr-emulated.h117–133. Wyprowadź jego zgodność
  z wymaganym matematycznym floor w rzeczywiście osiągalnej domenie.
- Rozlicz +0/-0, normalne, podnormalne, underflow i signed shifts/narrowing.
  Jeśli model wymaga kanonicznego zera albo wyklucza pewne bit patterns,
  wykaż taki invariant source execution. Bezpośredni test syntetycznego
  bit pattern nie dowodzi jego osiągalności z KeyGen/Sign.
- Sprawdź rzeczywiste FPR(), add/mul/div/sqrt/half i używane stałe. W ledgerze
  błędów nie importuj u|x|+eta dla nieobsługiwanej klasy operacji bez uzasadnienia.
- Dla źródłowego banku CDF wyprowadź rzeczywiste maxima i z∈[-365,366], z
  uwzględnieniem selector/found i return branches. Rozmiar tablicy512 sam
  nie jest maksymalnym zwracanym k.

Lokalny wynik warunkowy „jeśli mu jest w przedziale, s+z jest bezpieczne”
jest potrzebny, ale istniejąca luka polega na osiągalności tego przedziału.
Nie kończ całego H3 pozytywnie na samym takim lemacie.

### B. Ustanowienie źródłowych przesłanek o emitowanym kluczu i drzewie

Zwiąż wykorzystane własności f,g,F,G, NTRU, ich kodowania i loadera z
całą ścieżką successful KeyGen. Każdą zużytą własność rozpisz w
REUSED_RESULTS: exact statement, source/version, proof/certificate status,
rzeczywiste zastosowanie i pozostałe przesłanki.

W szczególności |F_i|,|G_i|<=2047 ma pochodzić z właściwego source return path,
nie z obserwacji klucza. Nie importuj idealnie zredukowanego Babai quotient
<=1/2 do realnego KeyGen bez błędu jego floating circuit.

T5 i numerical soundness są wejściami w ich własnych zakresach. H4 dotyczy
1536 stored widths, a terminalna pierwsza próbka używa dodatkowego
`fpr_IW1I*sigma`. Rozlicz ten transform i backend. Stare >991 nie implikuje
dowolnie silniejszej granicy; mocniejszy endpoint trzeba rzeczywiście skonsumować.

Kluczowe rozróżnienie: stabilny gate/terminal leaves nie zastępują source
subtractive `ffLDL_fft3` i jego wewnętrznych multipliers. Te wielkości i
ich zgodność machine/exact muszą dostać własne bounds.

### C. Inwariant osiągalnych centrów bez kołowego założenia

Wyprowadź actual call graph oraz znaczenie każdego bufora. W ternary
ffSampling funkcje zwracają **residua**; nie przenoś bez sprawdzenia
interpretacji z binary samplera. Miejsca:

```text
load_skey / ffLDL_fft3 / stable normalization: source falcon-sign.c
ffSampling_inner_fft3: 1617–1694
ffSampling_depth1_fft3: 1697–1780
ffSampling_fft3: 1783–1839
do_sign initial targets i wywołanie: 1849–1897
sampler_large / output s+z: 2841–2969
```

Zachowaj kolejność: prawe subtree, użycie jego residuum w centrum lewego,
odpowiednie split/merge, potem odjęcia. Na terminalu pierwsze scalar call
dotyczy r1 ze skalowaną sigma, następne r0 po dodaniu połowy residuum.

Prowadź indukcję po rzeczywistym ordered execution prefix/rekursji.
**Nie zakładaj bounds wszystkich zwróconych residuów, żeby dopiero nimi
uzasadnić bezpieczne konwersje, od których te bounds zależą.** Rozlicz bazę,
wcześniejsze calls, kolejny center i kolejny return we właściwej kolejności.
Przerwania fault są osobnymi gałęziami. Po sticky fault kolejne wywołania
wracają przed floor; ich zero-return nie jest próbką Gaussa blisko centrum.

Nie zakładaj Q<B dla stanów przed norm testem: badane są także próby, które
później odrzuci norma lub fault. Bound3160 z M0 jest po norm acceptance
i nie ogranicza wcześniejszych centrów.

### D. Majorant zachowujący strukturę i błąd maszynowy

Dobierz normę/metrykę, skalowania FFT i znaki do rzeczywistej reprezentacji.
Rozdziel dokładne algebraiczne tożsamości od zaokrąglonych instrukcji.
Przydatne mogą być NTRU/Schur, energia dodatniego Gramu, pary reciprocal,
relacyjne przedziały i source-bound wynik końcowej redukcji Babai.

Nie narzuca się jednej metody. Najpierw sprawdź, czy domknięty relacyjny
argument z istniejącymi source caps i pełnym ledgerem błędów wystarcza.
Gdy potrzebna jest mocniejsza własność Babai, wyprowadź ją dla faktycznego
emitted path i jego FFT/iFFT/round/subtract, zamiast zakładać idealny wynik.

Stara liczba około2.114e9 i margin około27e6 były diagnostycznymi majorantami
bez pełnego pokrycia multipliers, map pierścienia i floating errors. Nie są
gotowym certyfikatem. Bound366/549 dla lokalnego terminala nie jest sam
przez się boundem całego root residual. Przekroczenie limitu przez luźny
majorant również nie jest kontrprzykładem do rzeczywistych centrów.

Zachowaj pełne inward/outward kierunki. Każdy użyty endpoint ma być exact
rational albo outward-certified, z wyprowadzoną dziedziną wszystkich
emitted keys i histories. Sam bound dla jednego f,g lub małych stopni
nie zamyka kwantyfikatora N=1536.

### E. Końcowy lift

Zamknij floor/conversion i s+z przez nowy invariant Reach, rzeczywistą
semantykę FPEMU i zakres zwracanych propozycji. Pokaż pełny typ, implicit
arguments, term i axioms eksportowanych lematów. Oddziel wyniki kernelowe,
analityczne, certyfikowane obliczenia i C/model translation.

Nie pozostawiaj w pozytywnym globalnym wyniku założenia C_mu, boundu
wewnętrznego multiplier lub ideal-machine error, który sam jest otwartym
celem. Jeśli brakuje takiego lematu, podaj jego dokładny typ, najbliższy
udowodniony interfejs i wynik PARTIAL_PROOF.

## 5. Kontrole — małe i związane z nowymi mostami

- Dokładne granice INT32/floor/proposal: końce wymaganej domeny, sąsiednie
  reprezentowalne wartości, znaki, z=-365/366, zera i istotne klasy FPR.
- Rzeczywiste emulated-FPR funkcje w normal C oraz ASan/UBSan; niezależny
  oracle exact dyadic/ZZ/QQ lub rigorous RBF/RIF. Nie używaj samego host-double
  wyniku jako weryfikatora FPEMU lub dowodu uniwersalnego rounding modelu.
- Małe source-bound sprawdzenia split/merge, kolejności residuów, znaku L,
  terminalnej skali oraz przejścia fault. Kontrole lokalne nie są dowodem
  osiągalności całego syntetycznego stanu w M0.
- Jeśli dodajesz checker boundów, sprawdź rzeczywistą zmianę endpointu,
  kierunku zaokrąglenia, znaku/skali lub opuszczenie błędu oraz no-op.
  Odrzucenie etykiety mutacji nie jest kontrolą jej znaczenia.
- Nie wykonuj nowego KeyGen/Sign z prywatnym kluczem. Dozwolone są publiczne
  źródła, certyfikaty i jawne syntetyczne lokale/FPR words. Pokaż, które
  przypadki są tylko diagnostyką szerszej domeny.

## 6. Znaczenie wyniku negatywnego

Pełny kontrprzykład wymaga wiązania ze skutecznym source KeyGen i faktycznie
osiągalnym prefixem pod M0. Nie odczytuj prywatnego klucza/seedu i nie twórz
nowego klucza w celu uzyskania takiego świadka; dopuszczalny jest publiczny
argument symboliczny, jeśli naprawdę dowodzi wymaganej przynależności.

Dowolna sheared baza zaakceptowana przez loader, arbitralne finite mu lub
kontrmodel agregatów bez udowodnionego emitted/reachable bindingu nie obalają
required-domain H3. Oznacz je jako extended-domain diagnostic albo dowód
niewystarczalności danych przesłanek. Nie są pretekstem do wycięcia stanów
z rzeczywistej dziedziny.

Jeżeli potrzebny jest guard lub inna zmiana programu, opisz oddzielny
obowiązek i wpływ na abort/law. W tym zadaniu nie dodajesz H3G do źródeł,
nie zmieniasz KeyGen, sigma, B, CDF ani profilu, żeby uzyskać PASS.

## 7. Środowisko, sandbox i wyjścia

W jest jedynym katalogiem zapisu. Bootstrap, źródła i archiwa pozostają
read-only podczas wykonania. HOME/TMPDIR/DOT_SAGE/LEAN_PATH, cache, olean,
binaria i nowe wyniki kieruj pod W. AGENTS nie zastępuje sandboxa.

Używaj istniejących GCC14.2/C99/LP64, Sage10.9 (`sage plik.py ...`),
Lean4.34.0/Std. Lean: `-j1 -M2048`, sprawdzony budget address space8GiB,
skończone limity jobów. ASan ma osobny limit virtual-shadow zgodnie z
wcześniejszym sprawdzonym runnerem. Nie instaluj mathlib/innych narzędzi.

Nowe i edytowane Lean mają czyste pełne logi; bez sorry/admit/native_decide
lub lokalnych aksjomatów wniosku. Adaptowane zależności zachowują oryginał,
diff, nowe piny i ponowne sprawdzenie. Nie przenoś starego olean jako dowodu.
Nie powtarzaj całych L_RHO/L_NTT/L_V/M0, jeśli nie są konsumowaną zależnością.

Bez sekretów, odczytu seedów, .private/private_extraction, nowych kluczy,
sieci badawczej i innych agentów. Matematyczna kwantyfikacja po sk/seed nie
jest dyspozycją ich odczytu. Zapisz source spans/hashes, command/cwd,
exit codes, limity i pełne stdout/stderr. Zachowaj próby odrzucone i timeouty.

Wymagane: REPORT.md, RESULT.json, CLAIM.md, OBLIGATIONS.json,
REUSED_RESULTS.md, REACHABILITY.md, SOURCE_MODEL_BINDING.md,
BOUND_LEDGER.json/.md, formalne źródła/certyfikaty, checkery i logi,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, REPLAY.md, OUTPUT_SCOPE.md,
OUTPUTS.sha256. Wskaż każdą klasę stanu i wykorzystaną przesłankę.

Macierz obejmuje co najmniej: EMITTED_KEY_BINDING, LOADER_TREE_BINDING,
FPR_DOMAIN, FLOOR_REFINEMENT, PROPOSAL_SUPPORT, SOURCE_CALL_ORDER,
RESIDUAL_INDUCTION, ROOT_CENTER, INTERNAL_CENTERS, MACHINE_ERROR_TRANSFER,
FAULT_PATHS i FINAL_REACHABILITY_LIFT. Nie myl H3 range z pełnym sampler law.

## 8. Freeze i standardowy replay

```text
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

Przed utworzeniem DEST zweryfikuj zewnętrzny pin i wszystkich członków
OUTPUTS. DEST to nowy podkatalog tmp kopii. Nowy replay korzysta tylko z
zarchiwizowanych wejść i przypiętego toolchainu, bez oryginalnych Dokumenty/H
lub tymczasowego worktree. Odbuduj rzeczywiście konsumowane dowody/kontrole,
bez wcześniejszych olean/binariów/cache.

Przed freeze możliwy jest jawny rehearsal z osobną kotwicą. Receipt
artifacts/fresh_replay.json ma listę matches(path,sha256); receipt i wszystkie
porównane pliki należą do OUTPUTS. Bez cyklu hashowania. Po freeze wykonaj
standardowy replay z finalnym zewnętrznym pinem; wynik trafia wyłącznie do
DEST/REPLAY_RESULT.json/FRESH_REPLAY_PASS. Zamrożonych plików nie przepisuj.

## 9. Statusy i handoff

- `H3_RANGE_PROVED_FOR_PINNED_MODEL`: pełny zakres §2–3, z source bindingiem
  i domkniętymi globalnymi przesłankami. Nie oznacza całej redukcji.
- `PARTIAL_PROOF`: konkretne nowe lematy/certyfikaty i dokładne pozostałe
  typy; nie tylko powtórzenie historycznej listy braków.
- `COUNTEREXAMPLE_REQUIRED_DOMAIN`: pełny publiczny, odtwarzalny dowód
  naruszenia w rzeczywistej wymaganej dziedzinie.
- `COUNTEREXAMPLE_EXTENDED_DOMAIN`: brak wiązania z required support/Reach;
  ograniczony wynik diagnostyczny, bez relabelowania go jako required-domain.
- `EXECUTION_BLOCKED`: konkretna przeszkoda techniczna.

Baseline candidate jest już zintegrowany na main: zapisz
`baseline_source_integrated=true`, `source_changed=false`,
`new_source_patch_integrated=false`, `protocol_wrapper_integrated=false`,
`owner_accepted=false`, `security_reduction_proved=false`.
Historyczne source_integrated=false w starszych raportach pozostają ich
wykonawczymi zapisami; nie przenoś ich jako obecnego stanu aktywnego builda.

Podaj REPORT/OUTPUTS SHA-256, dokładną tezę, formalny/analityczny zakres,
pozostały następny lemat i co wynik rzeczywiście rozlicza w ledgerze M0.
Prowadzący sesję wykona odbiór, import --replay standard i osobny commit.
Astra nie operuje na Git i nie rozpoczyna następnego etapu automatycznie.
