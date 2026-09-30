# T12.1 / RUN_003 — STABLE_BINARY_002

**PARTIAL_PROOF / WORKING_NOT_FROZEN**, GPT-6 Sol (`openai/gpt-6-sol`,
`ses_f12636605ffeL1FZg4teLUwUf5`). To wynik pracy autora, nie niezależny
odbiór, nie frozen stage ani owner acceptance. Raport poprzedniego kroku,
`STABLE_BINARY_001_REPORT.md` SHA256
`5506e59eb94fa83cd718140edf78c3da03d46223998c9de5546e44edace93c7b`,
został zachowany bez zmian.

## Przypięte wejścia i faktyczna gałąź

| Wejście w `inputs/source/` | SHA256 | Zakres |
|---|---|---|
| `falcon-keygen.c` | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` | cały helper 7491–7514 |
| `fpr-emulated.c` | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` | M0: add 449–554, mul 681–774, div 916–1000; makro norm 21–54 |
| `fpr-emulated.h` | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` | typedef i inline ursh 18–23, ulsh 32–37, FPR 39–55, dotychczasowe half/double |
| `Makefile` | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` | brak override `FALCON_ASM_CORTEXM4` |

`sage pin_fpr_c_source.sage` ze standardowym preparserem, dokładnie w
`stable_binary_fpr_transport_003`, sprawdził te cztery piny, M0 #ifndef/#else
i granice funkcji; wygenerował literalne 1259 linii C jako
`run/formal/Source3/FprCSource.lean` SHA256
`cf1e1703a7611f47efc640ffc4f994421511c3c4c2412036e4f630f234ae7072`.
W Lean `m0_active` dodatkowo sprawdza #if/#else/#endif i M0 typedef
`fpr=uint64_t`. Nie zastosowano nowszego nagłówka P02.

## Dowiedzione w tej kontynuacji

`FprPrimitives.lean` parsuje kompletne trzy *aktywne* funkcje ze źródła,
nie przyjmuje podanych z góry funkcji matematycznych. Instrukcje skalarne
wykonuje istniejąca typowana semantyka `B20.C`/`CLogic`; rozszerzenie obsługuje
`FPR_NORM64` z rzeczywistą substytucją `m/e`, przy zachowaniu lokalnego `nt`,
oraz `for (i=0; i<55; i++)`: 55 sprawdzeń warunku, 55 wykonań ciała,
55 inkrementacji i końcowy fałszywy warunek. Po odkryciu błędu na drugim
obiegu poprawiono zakres życia lokalnego `b`, deklarowanego ponownie w
każdym obiegu. `FPR`, `fpr_ulsh` i `fpr_ursh` są parsowane i uruchamiane
z *przypiętego* M0 headera. Wynik C-fragmentu to dokładne słowo64 albo
`none` dla niezdefiniowanego/odrzuconego przez interpreter przebiegu;
nie zamienia się UB na wynik0. Typy, konwersje, promocje, dzielenie zakresów
32/64, przesunięcia, signed-overflow są rozliczane przez ten fragment
semantyki P02. GCC-LP64 arithmetic signed-right-shift i reprezentacja
two's complement są częścią jego jawnego profilu.

`FprPrimitives.caller_frame` oraz osobne source-add/mul/div frame
dowodzą, że wykonanie **tego typowanego interpretera** zachowuje dowolną
pamięć wywołującego: parametry i lokalne zmienne to wartości, a gramatyka
callee nie ma wskaźników ani zapisów poza lokalnym środowiskiem. To nie
jest jeszcze twierdzenie o niezależnej bajtowej semantyce C.

`StableBinaryFpr.boundOps` wstawia te trzy sparsowane wykonania do
`FprCalls`; `bound_{add,mul,div}_exec_and_frame` wyprowadzają z każdego
zdefiniowanego wyniku dokładny program AST, argumenty `[.u64 x,.u64 y]`,
wynik `.u64 z` i ramę pamięci interpretera. Z tymi konkretnymi operacjami
`bound_model_outcome` dowodzi dla `n=2^k`, `k≤8` w **modelu helpera**:
final bad0 ⇒ initial bad0, wszystkie faktycznie zapisane wejścia sześciu
kontroli na iterację positive-finite, żaden ich fallback nie podmienił słowa
na1; słowa i flagi poza regionami pozostają bez zmian. Osobne
`bound_model_any_prior_bad` obejmuje *każdą* początkową niezerową flagę,
nie tylko wartość1. W `StableBinary.Memory.initialized` naprawiono
nieuzasadniony filtr: model `Layout` wyznacza rozłączne, zapisywalne komórki
scratch bez przesłanki początkowej inicjalizacji; helper zapisuje oba jego
zakresy przed pierwszym odczytem `memcpy`. Oryginalny raport `_001` opisuje
ówczesną, węższą wersję predykatu.

**Dokładny typ końcowego eksportu** w `Source3/StableBinaryFpr.lean`:

```lean
theorem bound_model_outcome (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (s : StableBinary.State l m)
    (hl : l.wellFormed k) (hm : m.initialized l)
    (hrun : StableBinary.run l boundOps k m=some s)
    (hclear : s.memory.flags l.bad=some 0#32) :
    m.flags l.bad=some 0#32 ∧
    (∀ w∈s.checks,
      Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) ∧
    (∀ a, ¬l.allowed a → s.memory.words a=m.words a) ∧
    (∀ a, a≠l.bad → s.memory.flags a=m.flags a) ∧
    StableBinary.execute l boundOps StableBinary.program m k l.values l.scratch
      {firstBad := s.firstBad, badInitially := s.badInitially}=some s
```

`hrun` to **wykonanie modelu**, nie wykonanie przypiętego całego helpera C.
Żadnego twierdzenia źródłowego o pełnym `ft_stable_binary_inplace_keygen`
z tego eksportu nie wynika. Kernelowe `#check`, `#print` termu i transitive
`#print axioms` są w surowym stdout jobu kompozycji; nowe eksporty używają
jedynie `propext`, `Classical.choice`, `Quot.sound` (lub ich podzbioru).

## Nierozwiązany konkretny typ

Brakuje niezależnego, źródłowego wykonania **całego** 24-liniowego
`falcon-keygen.c:7491–7514` z C99/LP64 byte-heap oraz twierdzenia:

```text
∀ k≤8, n=2^k, legalne i rozłączne values[n], scratch[n], bad[1],
  każdy zdefiniowany przebieg C99_M0(helper, byteHeap, n) = (byteHeap', trace)
  ⇒ ∃ s, StableBinary.run l boundOps k (typedView byteHeap) = some s
          ∧ typedView byteHeap' = s.memory
          ∧ rzeczywiste kontrole(trace) = s.checks.reverse
          ∧ zapis poza dozwolonymi regionami byteHeap' = byteHeap.
```

W tym wymaganym typie muszą zostać wyprowadzone: legalność wskaźników,
odczyty/pary wejść i sześć kontroli, oba zapisy scratch, niepokrywające
się `memcpy`, lewa i prawa rekurencja, aktualizacje `*bad` i wierność
typed-object view względem bajtowej pamięci. Dotychczasowy
`StableBinary.source_parses` porównuje tokeny z pinem; sam nie dowodzi
zgodności semantyki helpera. Ponadto nie ma uniwersalnego dowodu, że
każde *zdefiniowane* wywołanie C add/mul/div i inline helperów będzie
zaakceptowane przez ograniczony interpreter (`none` nie może być filtrem
zgubionego przebiegu C). Obecne source-fragment frame/konkretne
`boundOps` nie zastępują tych dwóch obowiązków. Nie dodano założeń
selekcji kluczy, poprawności FPEMU, domeny Grama/delty ani bezdowodowej
równości source→model.

## Kontrole i historia prób

Syntetyczne uruchomienia dały add(1,2)=3, mul(2,3)=6,
div(6,2)=3 i div(0,1)=0 **w interpreterze**. Mutacje:
`ulsh <<32→<<31`, `mul` warunkowa→bezwarunkowa normalizacja oraz
`div` 55→54 zmieniają wyniki na publicznych słowach; ich nierówne,
źródłowo sparsowane wyniki są dowiedzione kernelowo w
`FprPrimitivesAudit`. Mutant `add` usuwa korektę znaków: diagnostyczne
wykonanie(2,−1) daje3 zamiast1; próba kernelowej pełnej redukcji
`stable_binary_fpr_audit_010` przekroczyła limit pamięci kernela.
Zachowano jej raw log, bez dopisywania twierdzenia lub wyciszenia.
Poprzednie kernelowe mutanty reset bad i zły adres prawej rekurencji
zachowano w `StableBinaryAudit`.

Pierwszy transport Sage `_002` zapisał generated plik, ale zakończył się
błędem serializacji obiektów ZZ do JSON; poprawiony `_003` zaakceptowano.
Preflight `_001` omyłkowo uznał listę plików `git add` zawierającą
`job.py` za proces runnera; poprawka w *tym W* sprawdza wyłącznie slot
skryptu `python[3] [-B]`. Osobne preflighty wstrzymały joby podczas cudzych
aktywności Lean. Wszystkie próby i logi zostały zachowane.

## Receipty zamkniętej closure

Po ostatnim rechecku osobnych jobów (każdy `warningAsError=true`, `-j1`,
`-M6144`, network-off, exit0/accepted/clean) wiązanie jest następujące:

| Źródło/product | SHA256 źródła | Job | SHA256 `RECEIPTS.json` |
|---|---|---|---|
| `Source3/FprCSource.lean` | `cf1e1703a7611f47efc640ffc4f994421511c3c4c2412036e4f630f234ae7072` | `stable_binary_fpr_c_source_001` | `fb94f973785c30f8d33095499f9c0e0f8c9464630143e62a6bdfc1d092d7ac0e` |
| `Source3/StableBinary.lean` | `8aaa66792bf8a6d6d9fba294bc98d570ec0c3548c5b73352586d7babd5342d48` | `stable_binary_relaxed_scratch_001` | `cd9940540b339480fb6e351fbe16dc9e00f652eb79dad2a3ec18dc929035592f` |
| `Source3/FprPrimitives.lean` | `221220c948d003d4896e2a4b7bf1779c2f3be83c626b3ae98185a99fd953da14` | `stable_binary_fpr_primitive_008` | `8baa1c0555b725489ba77871176470c982c0812e64d7343de9529fd698c5d2c5` |
| `Source3/StableBinaryFpr.lean` | `95438e4d3d01b4b6da61bddfeceab962ee75f24a3138ed730b6e240116e91900` | `stable_binary_fpr_compose_004` | `8a6dfb3b87e1307669324ed5f7efd4785e1ee06daa7d5d70c53b27d2bfee602d` |
| `Source3/FprPrimitivesAudit.lean` | `8284c02a4d0490791be02927c74b4d7f2202696fa6b5d5515fa9ace20b427510` | `stable_binary_fpr_audit_012` | `cf9e43763df31eec4f309acac99d65b4ded2133272d6179126268e687c5422e2` |
| `Source3/StableBinaryAudit.lean` | `3e76ad5bcfd3fb798cbee99e9898f4de62e17d9022df42fb1cfc0780d4a3c746` | `stable_binary_audit_006` | `8e06a0c0b4bf987ad5ea2ed5300075ba0d7103d0feaaf16be8c6eb4609a9043e` |

`sage` source SHA256 `91f52cf0b6d7a9ca99556269ba136ced8f5e0ce897e4a070cd55db6ed32962d7`,
transport receipt SHA256
`d9160bf2ac9d0d63b82c5637c10e91c1cf2b874a2374e605b5c210f0a8081390`.
Poprzedni raport i frozen obce W pozostały read-only. Brak freeze,
niezależnego odbioru, Git/commita i push.
