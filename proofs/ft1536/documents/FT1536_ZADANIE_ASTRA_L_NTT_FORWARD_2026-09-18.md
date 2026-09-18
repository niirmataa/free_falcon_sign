# GPT-ASTRA — FORWARD_CRT i forward_product dla FT1536

Data: 2026-09-18. Kontynuacja po domknięciu globalnego inverse.

## 0. Karta zadania

- **Cel:** udowodnić globalną interpretację source forward jako ewaluacji
  w węzłach CRT, wyprowadzić forward_product i domknąć istniejącą kompozycję L_NTT.
- **Po co teraz:** prefix/frame, zakresy, globalny inverse, lift i source
  pipeline bridge już istnieją. W końcowej tezie pozostała jedna globalna
  przesłanka — forward_product.
- **Odczyt:** zamrożone checkpointy w docelowym repo free_falcon_sign.
- **Zapis:** tylko `proofs/ft1536/work/FT1536_L_NTT_FORWARD_RUN_001` w tym repo.
- **Wynik:** globalny forward, mnożenie modulo Phi i instancja pełnego L_NTT
  albo dokładnie wskazany nowy wynik częściowy/kontrprzykład.
- **Koniec:** raport, macierz obowiązków, certyfikaty i freeze. Następnie
  prowadzący sesję sprawdzi pakiet i wykona osobny commit checkpointu.

Wykonaj pracę do raportu. Głównym celem jest nowy dowód, nie ponowienie
już zakończonej kampanii testów ani odtwarzanie inverse od początku.

## 1. Repo, kontekst i wejścia

```text
REPO = /home/footfalcon/free_falcon_sign
ARCH = REPO/proofs/ft1536
PREV = ARCH/stages/FT1536_L_NTT_GLOBAL_RUN_001
LOCAL = ARCH/stages/FT1536_L_NTT_RUN_001
RHO = ARCH/stages/FT1536_L_RHO_RUN_001
W = ARCH/work/FT1536_L_NTT_FORWARD_RUN_001
```

Kontynuuj w obecnej rozmowie, zachowując użyteczny kontekst. Przed zapisem
potwierdź nowe cwd i rzeczywisty sandbox wyłącznie W. Sam wybór repo jako
projektu nie upoważnia do zapisu w stages/, Extra/c ani indeksie Git.

Przeczytaj lokalny AGENTS.md, AGENTS repo oraz:

- PREV/REPORT.md, RESULT.json, OBLIGATIONS.json;
- PREV/INVARIANTS.md i SOURCE_MODEL_BINDING.md;
- PREV/formal/ForwardProgress.lean, Pipeline.lean, InverseGlobal.lean;
- potrzebne definicje SourceModel, Stages, Layouts, Buffer i Twiddles;
- LOCAL/DERIVATION.md D5–D6 oraz konsumowane formalne fakty o tabelach;
- ARCH/documents/FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md.

Archiwum z poprzednimi etapami jest zapisane m.in. w commicie
`341d9f7ec0111dfa3d360b378de8f50cd9dcb857`. Piny matematycznych wejść:

```text
PREV/REPORT.md
d5e5dc7cc65f2d12ade4e1928cc705b947e0203657decac59b352ff8fd1d56e8

PREV/OUTPUTS.sha256
6095dbfbb616d901e5a7991f608b94bbd7c916167f16baf7d2f50fc3e353b129

PREV/source/falcon-vrfy.c
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42

PREV/formal/ForwardProgress.lean
ac4cc1a2a8abb7c52ef53ab98f48a3bb94a59aa1a0aa5f06de41ecfefb7c5a5b

PREV/formal/InverseGlobal.lean
b47e946cdc92b33825d075fcf37709fa7ed114680448bf4fcf0da8a4dec44c8e

PREV/formal/Pipeline.lean
f8d06c187c79c75d1e2b725728cd11b15b3f2663da621ad306d4dc1b09430874

PREV/formal/SourceModel.lean
2067c0851d41992ecdc97311e3e496a71d47f272f14867ba508cb91faf97d24f

PREV/INVARIANTS.md
20b7f16e58bd66c744ca573e3f2ccd196397d7dbbc906fe920bc2868a91a90fc

PREV/SOURCE_MODEL_BINDING.md
891596976f3b79afff55690a8568fde54786945c9caae73794c823ab1649a42a
```

Sprawdź piny i faktycznie konsumowane kopie. Pozostałe pliki wiąż z OUTPUTS.
Przenieś potrzebne źródła formalne, certyfikaty i 17 niezmienionych plików C
do W. Manifest źródeł kandydata zachowuje SHA-256
`2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.

Nie konsumuj plików olean/cache jako substytutu sprawdzenia źródeł. Nie
uruchamiaj wcześniejszych runnerów w ich zamrożonych katalogach. Jeśli W
zawiera wcześniejsze wyniki, ustal ich stan przed wznowieniem.

## 2. Co jest już wejściem dowodu

Konsumuj, z dokładnymi typami i źródłowym bindingiem:

- prefix/frame rzeczywistych sekwencyjnych stores i rozłączne layouty;
- canonical range całych forward/inverse;
- `inverseMem_forwardMem`, `inverseC_forwardC` i `inverse_forward`;
- `canonical_fixed`, `liftForward_agrees`, `liftInverse_agrees`;
- `root_coefficients` i `binary_coefficients` z ForwardProgress;
- `toMontC_eq`, `montPointC_eq`, `subtractC_eq`, `pipelineC_lift`;
- source-expression soundness, lookup powiązany z indeksem, twiddles
  i lokalne tożsamości bloków.

Nie redefiniuj forwardC jako idealnej ewaluacji ani inverseC jako wygodnej
funkcji odwrotnej. To konkretne, już zbudowane modele pętli C. Nowy dowód
ma dotyczyć właśnie tych funkcji. Ewentualna reorganizacja modułów wymaga
jawnego wykazania zgodności definicji i zachowania konsumowanych tez.

## 3. Dokładny cel forward

```text
N=1536, q=18433, Phi=X^1536-X^768+1
ordinary(w)=(w*5184) mod18433
alpha_i=ordinary(gmAt(512+i)), 0<=i<512
omega=14648
```

Źródło: ternary=1, logn=10, dynamiczne mq_mkgm3, ten sam GCC14.2.0/C99/LP64.
Bufory pozostają legalne, odpowiednio wyrównane i rozłączne.

**FORWARD_GLOBAL:** dla każdego canonical v i wszystkich i<512, j<3:

```text
forwardC(v)[3*i+j] = (sum_{k=0}^{1535} v[k]*(alpha_i*omega^j)^k) mod18433.
```

Zachowaj fizyczny porządek 3i+j. Dowód ma obejmować wszystkie v, a nie tylko
dwa przypadki sprawdzone poprzednio przez Sage. Poprawne przypadki kontrolne
i odwracalność nie stanowią tego twierdzenia.

## 4. Zalecany kierunek inwariantu

Rozpocznij od `binary_coefficients` (ForwardProgress.lean:27–38), a nie
od nowego modelu pamięci. Powiąż źródłowe bloki z etykietami drzewa CRT.

Możesz prowadzić inwariant współczynników reszty modulo `X^t-tau`.
Wystarcza również jawnie udowodniony inwariant ewaluacyjny prowadzący do
tej samej tezy: dla rzeczywistego bloku stopnia t z etykietą tau oraz każdego
`z in [0,q-1]` spełniającego `z^t=tau modq`, ewaluacja tego bloku w z
jest równa ewaluacji pierwotnego wielomianu v w z, modulo q.

Taki inwariant pozwala oprzeć dowód na dokładnych skończonych sumach
w Std, bez budowania ogólnej biblioteki CRT jako osobnego projektu.
Sam inwariant i jego zastosowanie do konkretnych etapów nadal wymagają dowodu.

Wymagane połączenia:

1. **Root:** wykorzystaj `root_coefficients` dla połówek długości768
   i etykiet14649 oraz1−14649. Wyprowadź odpowiednie twierdzenie o ewaluacji
   lub resztach z rzeczywistej formuły współczynników.
2. **Jeden split:** dla s^2=tau i z^(t/2)=s albo −s pokaż, że A±sB
   zachowuje wymaganą ewaluację/resztę. Uwzględnij modulo w każdym store.
3. **Osiem poziomów:** przeprowadź indukcję po faktycznym forwardSchedule.
   Powiąż numer bloku, `pairAddr`, indeks gm i znak etykiety. Konsumuj
   udowodnione source-prefix/layout facts, bez ponownego dowodzenia pamięci.
4. **Cubic:** z ostatniego bloku stopnia3 i relacji alpha_i^3=tau_i
   wyprowadź ewaluacje w alpha_i, alpha_i*omega, alpha_i*omega^2,
   dokładnie w porządku wyjścia source. Rozlicz omega^3=1 i potrzebne
   równania węzłów z już przypiętych certyfikatów.
5. **Całość:** uzyskaj FORWARD_GLOBAL dla konkretnego forwardC oraz dowód,
   że użyte węzły zerują Phi, potrzebny w następnym kroku.

Nowy certyfikat stałych wolno dodać, jeśli rzeczywiście uzupełnia brakującą
przesłankę. Musi zostać sprawdzony, związany z rzeczywistym gmAt i indeksem.
Nie przyjmuj globalnej zgodności etykiet jako hipotezy końcowego twierdzenia.

## 5. Mnożenie i domknięcie pipeline

Zachowaj definicje `FT1536Composition.productCoefficient`, `remMonomial`
i `product`. To niezależny iloczyn współczynnikowy modulo Phi.
Nie wolno zastąpić go definicją przez NTT.

Wyprowadź zachowanie ewaluacji przez sumy/iloczyny oraz redukcję monomianów
modulo Phi w węzłach z poprzedniej sekcji. Następnie rozlicz canonicalizację
liftu i dowiedź dla wszystkich wektorów całkowitych h,r:

```text
liftForward(product h r)=pointMul(liftForward h)(liftForward r).
```

To ma być nowy **dowód `forward_product`**, nie kolejny parametr.
Nie trzeba ponownie konstruować inverse lub ogólnego dowodu odwracalności
macierzy Vandermonde, jeśli wystarcza już uzyskane `inverse_forward`.

Zastosuj `Pipeline.L_NTT_pending_forward` do udowodnionego faktu i uzyskaj
końcową tezę dla konkretnych modeli źródła, dla canonical h,r,c:

```text
pipelineC h r c = (product h r, subtract (product h r) c).
```

Wyeksportuj również jasne wnioski o p,d, zakresach i podstawieniu r=rho(s)
z L_RHO. Zachowaj niezmieniony SourceModel/source binding, legalność
wykonania, przygotowanie h przez NTT/tomonty i prawidłowe reprezentacje.

Pokaż pełny typ końcowych twierdzeń (`#check @...`/`#print ...`) oraz
`#print axioms`. Sprawdź również implicit i typeclass arguments. W końcowym
L_NTT nie może pozostać nierozliczone założenie o forward_product, ewaluacji,
globalnym inwariancie lub równoważności modeli źródłowych.

## 6. Weryfikacja bez rozszerzania zakresu

- Sprawdź kernelowo nowe moduły i faktycznie konsumowane zależności.
  Nie używaj sorry/admit/native_decide ani lokalnego aksjomatu wniosku.
- Dobierz małe, dokładne kontrole do nowych połączeń: etykiet bloków,
  znaku split, kolejności cubic i redukcji remMonomial. Sage ma być
  niezależnym oracle algebraicznym, a nie wywołaniem badanego NTT.
- Jeśli dodajesz nowy checker, sprawdź rzeczywistą mutację etykiety/znaku
  lub węzła i no-op. Nie ponawiaj całej kampanii prymitywów i inverse.
- Zachowaj publiczne wejścia i przypięty kod C. Kopie obserwacyjne muszą
  mieć odwracalną instrumentację i jawny binding; nie zmieniaj badanego C.

Użyj dostępnych Sage10.9 (`sage plik.py ...`), Lean4.34.0/Std i GCC14.2.0.
Zachowaj sprawdzony profil Lean `-j1 -M2048`, a dla jego procesów właściwy
budżet address space:8GiB w poprzednim zadaniu. Nie wracaj do konfiguracji,
która powodowała `failed to create thread`, bez uzasadnienia.
W obliczeniach trace stosuj sprawdzoną materializację stanów; nie zmieniaj
przez tę optymalizację definicji funkcji będącej przedmiotem dowodu.

**Czysty log nowych i edytowanych plików Lean jest wymagany.** Używaj
aktualnych nazw lematów, zachowuj pełne stdout/stderr, nie wyciszaj ostrzeżeń.
Poprzedni GLOBAL dostarcza już czyste finalne zależności. Jeśli dostosujesz
inną historyczną kopię, zachowaj oryginał, diff, nowy hash i ponowne sprawdzenie.

Używaj skończonych limitów per job i checkpointów. Timeout/błąd elaboracji
nie jest kontrprzykładem. Nie pozostawiaj starego procesu podczas nowej próby.
Bez instalacji, nowych kluczy, sekretów, sieci badawczej i innych agentów.

## 7. Raport, replay i commit checkpointu

Zapisz w W:

- REPORT.md, RESULT.json, CLAIM.md, OBLIGATIONS.json;
- REUSED_RESULTS.md i dokładne nowe inwarianty;
- źródła, formalne certyfikaty, bindingi, checkery i logi;
- INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log;
- REPLAY.md, OUTPUT_SCOPE.md, OUTPUTS.sha256.

W macierzy oddziel odziedziczone domknięte inverse/range/prefix/lift od
nowych FORWARD_GLOBAL, forward_product i pełnej instancjacji L_NTT.
Przy niedomknięciu wskaż najbliższy konkretny brakujący lemat z jego typem,
a nie tylko ogólny zwrot „brakuje globalnego argumentu”.

Dla odtwarzania z repo przygotuj końcowy standardowy interfejs:

```text
python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256
```

DEST ma być nowym podkatalogiem tmp kopii roboczej. Skrypt ma przed
uruchomieniem zweryfikować zewnętrzny pin i członków OUTPUTS, odtwarzać
wyniki w świeżej kopii z własnym sandboxem i używać tylko zarchiwizowanych
wejść oraz przypiętego toolchainu. Nie może wymagać oryginalnych Dokumenty/H.
Nie kopiuj olean/binariów/cache jako substytutu wykonania.

Próbę przed freeze możesz przeprowadzić w jawnym trybie rehearsal,
z osobno przypiętym zestawem plików znaczeniowych. Nie należy mylić jej
kotwicy z finalnym pinem OUTPUTS ani tworzyć cyklu hashowania receipt.
Końcowy interfejs po freeze ma wymagać podanego z zewnątrz SHA-256.

Receipt udanego replayu zapisz jako `artifacts/fresh_replay.json` z listą
`matches` zawierającą względne `path` i `sha256` wszystkich porównanych plików
znaczeniowych. Te pliki i receipt mają wejść do OUTPUTS. Opisz osobno dane
zależne od czasu/cwd. Nie nadpisuj zamrożonego pakietu przy późniejszym replayu.
Późniejsze odtworzenie ma zapisać `DEST/REPLAY_RESULT.json` ze statusem
`FRESH_REPLAY_PASS` i taką samą listą `matches`; oryginalny checkpoint
pozostaje wejściem do odczytu. To protokół obsługiwany przez archiwizator repo.

Statusy końcowe:

- `L_NTT_PROVED_FOR_PINNED_MODEL` — cały poprzedni CLAIM domknięty dla tego
  źródła i modelu, z dowiedzionym forward_product;
- `PARTIAL_PROOF` — dokładna lista nowo domkniętych faktów i pozostała luka;
- `COUNTEREXAMPLE_CANONICAL_DOMAIN` — pełny przypadek związany z rzeczywistą
  tezą i kodem, nie tylko błąd pomocniczego modelu;
- `EXECUTION_BLOCKED` — konkretna przeszkoda techniczna.

Zachowaj `source_integrated=false`, `owner_accepted=false`,
`full_L_V_proved=false`. Pełny parser, centrowanie C, dokładność normy,
ścisły próg i bezpieczeństwo schematu pozostają kolejnymi obowiązkami.

Po freeze podaj użytkownikowi zakres wyniku, dokładny następny krok,
pełną ścieżkę REPORT.md i SHA-256 raportu oraz OUTPUTS. W aktualnym podziale
pracy **prowadzący sesję** wykona import i osobny commit, następnie aktualizację
lokalnego main. Nie wykonuj równoległych operacji na indeksie Git.
