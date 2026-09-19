# FT1536 L_V_BRIDGE — raport

Data zadania:2026-09-19. Autor projektu: Niirmata. Wykonawca: GPT-ASTRA.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_L_V_BRIDGE_RUN_001`.

## 1. Werdykt i zakres

**L_V_PROVED_FOR_PINNED_MODEL.** Domknięto raw verifier, oba dekodery,
guards/loader i pełną implikację bajtową dla przypiętego kandydata L_RHO.

Teza obejmuje wszystkie canonical h,c i wszystkie skończone b reprezentowalne
w legalnym API modelu GCC14.2.0/C99/Linux x86_64 LP64:

```
V_CAND(h,c,b)=1 ⇒ s(b), Ext0 są zdefiniowane,
z1+h*z2=c modulo(q,Phi), Q(z1,z2)<2093922385,
(z1,z2)=(center_q(c-h*s(b)), s(b)).
```

To silniejsza dziedzina h niż required successful-KeyGen support. s(b) jest
signed int16 rzeczywiście zapisanym przez parser, nie jego centered lub unsigned
zamiennikiem. B, sigma768, N1536, q18433, Phi, Q oraz full ternary secret/COMP_STATIC
zachowano. Verify obejmuje NONE i STATIC. Nie ma ograniczenia b do2049 bajtów.

`full_L_V_proved=true` dotyczy WYŁĄCZNIE falcon-vrfy.c o SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
`source_integrated=false`, `owner_accepted=false`.

## 2. Piny i konsumpcja rdzenia

- TASK: `571aaab4ca8d1255bcb649b9e28fb5c3de60e98e9c30d4bb1fdef5a1a9bf4b65`.
- PREV/REPORT: `ff172360348004527b7ef2a68c3f70967463619f039145d856f1969d69b866eb`.
- PREV/OUTPUTS: `32147f114b448a1e1c2659b45ed3e69bfac02c44164ac380001df39c98fb498e`.
- Manifest17 źródeł: `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.

Zweryfikowano15 wymaganych pinów i124 konsumowane kopie. Source i59 formalnych
zależności L_NTT_rho są bajtowo identyczne; ponownie sprawdzono ich źródła,
bez starych olean/cache. Product/remMonomial/pipelineC/rhoVec pozostają tymi
samymi obiektami. REUSED_RESULTS.md wskazuje dokładne typy, piny i zastosowania.

Raw model otrzymuje prepared H=NTT(h)/tomonty. raw_before_eq konsumuje
L_NTT_rho i daje canonical d=h*s−c. Nie dowodzono ponownie NTT ani nie użyto
dawnych testów parsera/normy jako uniwersalnych faktów.

## 3. Raw verifier — nowy dowód

**CENTER_C.** Jawnie odtworzono uint32 subtraction/shift/mask, int32 casts,
int16 store i reprezentację unsigned pamięci. Dla każdego d w[0,18432]
zapis to center_q(d) w[-9216,9216]. center_prefix/center_unread rozliczają
wszystkie prefiksy in-place. Corresponding short/unsigned-short aliasing
jest dozwolony w C99; równe wyrównanie/rozmiar i typy sprawdza native harness.

**SIGN_BRIDGE.** C liczy center(h*s−c), Ext0 center(c−h*s). Antysymetria
centrowania i Q0_neg dotyczą całego pierwszego wektora i obu czynników
cross term. Wyprowadzono kongruencję ekstraktora współczynnik po współczynniku.

**NORM64_EXACT.** Norm64 zachowuje oba source loops, kolejność3072 squares
i1536 cross terms oraz offset768. Każdy int32 product ma moduł<=2^30.
Każdy prefiks int64 mieści się w±4947802324992<2^63, również przy ujemnych
cross terms. Casts są dokładne; nie ma signed overflow. Końcowy normAcc
jest dokładnie Q0(s1)+Q0(s2), nie binary saturation.

**STRICT_B.** Dla logn10 bound to2093922385, a return jest równoważny Q<B.
Q=B daje odrzucenie. Złożenie z L_NTT_rho daje RAW_VERIFIER_SOUND dla
canonical h,c oraz DOWOLNEGO signed int16 s, bez założenia o jego kodowaniu.

## 4. Bajty, długi unary i loader

ByteCursor to wykonywalna maszyna pos/db/db_len z unsigned32 db. Operacje
shift/mask/add/OR są związane z bitami przez MachineBindings i byte_concat.

**NONE:** rzeczywisty big-endian, sign extension, uint32 wrap i dwie różnice
z AND/shift31. Test implikuje centered domain i dokładny końcowy cast.
Zwrócone3072 bajty są porównywane z całym payload length.

**STATIC:** j8, source sign/lo, retained db i uzupełnienia są zachowane.
Filly wymagają najwyżej2 bajtów; FillRun equivalence dowodzi, że to nie jest
arbitralny limit. UnaryRun ma miarę8*(len−v)+db_len malejącą na każdym bicie.
unary_source/unary_unique/unary_terminates dowodzą dokładnej, zakończonej
interpretacji wszystkich skończonych wejść. ZeroPrefix/unary_skip_zeros i
unary_wrap dają k mod2^32 po k zerach. Test ne>255 jest dopiero po terminatorze.
Nie zmaterializowano dużego payloadu jako substytutu tego dowodu.

Narrowing32768..65535 jest jawną konwencją GCC. Negacja jest po promocji do
int32, ponowny store int16 jest rozliczony, w tym magnitude32768 dla obu znaków.
Negative zero, rzeczywisty padding i zwracane v są zachowane. Nie założono
kanoniczności kodowania. static_loop_spec/DECODE_STATIC dowodzą pełnego wyniku.

**Inicjalizacja/guards:** oba dekodery zwracają dokładnie1536 wartości;
writeDecoded/signature_initializes dowodzą źródłowych stores niezależnych
od starej zawartości bufora. Obecne są len<=2, reserved bit, zgodność profilu,
reserved compression, dodatni payload length i rozróżnienie failure0/success.
Trailing signature bytes są odrzucane. Liczniki i przesunięcia są legalne
dla wszystkich LegalBytes(length<2^64); ghost measure nie jest licznikiem C.

**PK_PREPARATION:** zaakceptowany decoder daje canonical h, a loader stosuje
rzeczywiste NTT/tomonty. PK_CONSUMED dowodzi2880 przeczytanych bajtów dla FT,
ale DECODE_PK zwraca pełne len. Nieczytane trailing PK bytes mogą być dowolne
i native kontrola potwierdza ich akceptację. loadFT jest projekcją na FT1536;
nie deklaruje odrzucania innych poprawnych profili przez ogólny loader C.

## 5. Końcowe tezy i granica modelu

Wyeksportowano L_V_BYTES, L_V_LOADED i L_V_SOURCE. Pierwsza dotyczy
V_CAND z prepared h; druga łączy rzeczywisty FT loader z Verify i wyprowadza
canonical h; trzecia dodaje jawne wykonanie wszystkich output stores.
Ich przesłanki to canonical h/c (lub tylko c przy loaderze), legalne długości
i obserwacja akceptacji. Nie zawierają hipotez poprawności parsera, normy,
centrowania, inwariantu ani translacji. V_CAND nie jest definicją Q(Ext0)<B.

Pełne typy z implicit/typeclass arguments i termy: logs/final/BridgeTypes.stdout.
Jawny C/model binding, ABI i legalne obiekty/lifecycle są przypiętym zakresem
platformy, nie deklaracją zweryfikowanego kompilatora. Szczegóły wszystkich
połączeń i adresów: SOURCE_MODEL_BINDING.md i artifacts/source_bindings.json.

## 6. Weryfikacja i kontrole

- Lean4.34.0/Std, commit293d5d0c0c3f3dded4688b3ccd6a33939ac5102b;
  GCC14.2.0; Sage10.9/Python3.14.7; systemowy Python3.13.5.
- **73 moduły,570 twierdzeń**, w tym104 nowe. Finalne pełne logi czyste,
  bez sorry/admit/native_decide/lokalnych aksjomatów. Tylko standardowe
  propext, Classical.choice, Quot.sound.
- Audit.stdout: `fe9fba25bd81959847d21d1cbb290088e82de720094163c5251cd166ad1de2ff`.
  Pełne typy/termy: `fed4e938e4b274a123929c6e390af4b98b4e581b968c9cb91b53f5f19790380d`.
-55 przypadków bajtowych,8 normowych,4 centrowania. Rzeczywiste C i
  wykonywalne modele Lean zgadzają się, a Sage liczy niezależny iloczyn
  modulo Phi, center i dokładną normę A2. Obie kompresje, extrema narrowing,
  negative zero, ne255/256, truncation/padding/trailing, nagłówki i PK są objęte.
- Normal oraz ASan/UBSan zgodne; decyzje plain i observer zgodne.
  Instrumentacja obserwuje tylko normę i jest odwracalna. Wspólny hook H2P
  podaje jawne c, czyli dziedzinę zadania, bez preimage claim.
- Wykryto5 rzeczywistych mutacji źródłowych: center boundary, offset768,
  znak cross term, `<`→`<=`, saturation zamiast signed narrowing. No-op PASS.
  Zmiany wyników i pełne strumienie są zachowane, nie tylko nazwy mutantów.
- B−1/B/B+1 z OLD sprawdzono na rzeczywistych wektorach, w obu kompresjach;
  akceptacje1/0/0. Nie podstawiano sztucznego akumulatora.
- Historyczny publiczny świadek OLD: Verify kandydata=0,
  Q=43058711057; oryginalny S17 pozostaje historycznym kontrprzykładem.
- **Fresh rehearsal PASS:402/402 pliki znaczeniowe identyczne**, z ponownym
  normal i ASan/UBSan, bez starych olean/cache i bez Dokumenty/H.
  Standardowy replay wymaga finalnego zewnętrznego OUTPUTS pin i nowego DEST;
  wynik FRESH_REPLAY_PASS ma tę samą listę matches, bez zmiany checkpointu.

Finite controls wspierają source binding; uniwersalność wynika z dowodów,
nie z liczby testów. Nie powtórzono pełnej kampanii NTT/rho.

## 7. Wykonanie, historia i następny krok

Potwierdzono sandbox tylko W; stages, repo AGENTS i TASK miały EROFS przy
próbie O_WRONLY bez zapisu. Source montowano read-only. HOME/TMPDIR/DOT_SAGE/
LEAN_PATH i wyjścia były w W. Nie było agentów, instalacji, sieci badawczej,
nowych kluczy/sekretów ani operacji na Git.

Lean: -j1 -M2048, address space8GiB; wszystkie joby miały skończony limit.
ASan działa osobno bez ograniczenia virtual address space ze względu na shadow,
przy nadal ograniczonym wall/CPU. Wcześniejsze błędy taktyk i timeouty zachowano.
Duże delta-unfolding normy ograniczono lokalną wskazówką reducibility i jawnymi
argumentami; importowana definicja sumN nie została zmieniona. Pierwszy rehearsal
nie skopiował provenance-only helpera; po poprawce wykonano nowy, kompletny
seed. To nie były kontrprzykłady ani finalne proof modules.

Macierz14 obowiązków jest zamknięta dla tego kandydata. Prowadzący sesję
powinien zweryfikować piny, wykonać import z --replay standard i osobny commit.
Następny etap badawczy wymaga osobnego zlecenia; nie rozpoczęto go tutaj.

L_V nie dowodzi samplerów, EUF-CMA, trudności MT-ISIS, rozkładu kluczy ani
preimage H2P. Nie rozszerza historycznych zakresów T2C3/T5. Konserwatywna
tabela strat TV nie staje się granicą bezpieczeństwa konstrukcji; transfer
warunkowy chi-square wymaga własnych obowiązków po historiach, abortach,
serializacji i programowaniu wyroczni. Przykład52-bitowej poprawy nie został
uznany za wynik dla całego schematu.

CLAIM.md określa tezę; RESULT.json i OBLIGATIONS.json status; REPLAY.md przepis;
OUTPUT_SCOPE.md i OUTPUTS.sha256 zamrożone bajty oraz prefiks dziennika.
