# FT1536 — zamrożony punkt pracy po M0

**Identyfikator:** FT1536_POST_M0_FREEZE_RUN_001  
**Data:** 2026-09-19  
**Autor projektu:** Niirmata  
**Wynik tego pakietu:** `RESEARCH_STATE_FROZEN_POST_M0`

To obszerny punkt odniesienia dla kontynuacji prac: stan kodu, mapa dowodów,
decyzje protokołu, granice osiągniętych wyników, odtwarzalność i dalsze
zależności. Jest zamrożeniem dokumentacyjnym, nie nowym dowodem EUF-CMA
i nie automatyczną akceptacją wszystkich wcześniejszych kandydatów.

## 1. Kotwica Git i zawartość zamrożenia

Stan bazowy publicznego main opisany w tym dokumencie:

```text
2959064e8132443649de50600b20bfc32ed618cb
feat: make the proved L_RHO candidate the default FT1536 build
```

Ten commit zawiera już M0, nowy główny README.md, dokładnego kandydata L_RHO
w Extra/c, FPEMU, domyślny build FT1536 oraz zapis jego kontroli.
Commit samego zamrożenia dodaje
niniejszy pakiet i odsyłacze; nie musi być własnym wejściem.

- `STATE.json` zapisuje bazowy commit/tree, wersje źródeł i stany wyników.
- `CHECKPOINTS.json` zawiera piny raportów i manifestów ośmiu etapów.
- `DEPENDENCIES.json` rozróżnia ukończone wyniki, warunkowe interfejsy,
  otwarte obowiązki oraz zależności między nimi.
- `INPUTS.sha256` wskazuje publiczne wejścia przez `git:<commit>:<path>`.
  Ich dokładne kopie są w `inputs/`, a po imporcie również w content-addressed
  objects repozytorium. Nie są to odwołania do ruchomego katalogu roboczego.
- `OUTPUTS.sha256` obejmuje dokładnie ten zamrożony pakiet, bez hashowania
  samego siebie. Jego zewnętrzny pin jest w wpisie katalogu checkpointu.

Kopie wcześniejszych manifestów są świadectwami tożsamości ich pakietów.
Ich właściwe bazy pozostają w oryginalnych `stages/<id>/` lub `validation/`,
nie w katalogu kopii dokumentacyjnej. Weryfikacja starego checkpointu odbywa
się względem jego własnego katalogu i oryginalnego pinu.

## 2. Podsumowanie wykonawcze

Osiągnięto trzy kolejne źródłowo związane wyniki dla poprawionego kandydata:

```text
L_RHO -> pełne L_NTT -> pełne bajtowe L_V.
```

M0 następnie zdefiniowało dokładny profil i grę oraz dowiodło pojemności
STATIC. To wykonanie zgodne ze zleceniem; `security_reduction_proved=false`
jest właściwym zakresem, a nie niepowodzeniem M0.

Zachowane są również dwa wcześniejsze wyniki analityczne:

- **T2C3:** sharply truncated image energy dla jednej kanonicznej instancji;
- **T5:** pure/untruncated graph-dual theta dla każdego successful-KeyGen output.

Nie ma jeszcze kompletnej redukcji źródłowego FT1536 do właściwego MT-ISIS,
zamkniętego prawa rzeczywistego Sign ani deklaracji konkretnego poziomu
bezpieczeństwa całego schematu. Pozostałe obowiązki są jawnie wskazane.

## 3. Parametry i trzy odrębne tożsamości

| Własność | Wartość |
|---|---|
| Pierścień | Z[X]/(X^1536-X^768+1) |
| N / wymiar pary | 1536 / 3072 |
| Modulus | q=18433 |
| API | logn=10, ternary=1 |
| Signing sigma | 768 |
| Ścisły próg | B=2093922385, akceptacja Q<B |
| Metryka | Q0(a)=sum(i=0..767,a_i^2+a_i*a_(i+768)+a_(i+768)^2); Q=Q0+Q0 |
| Sekret | full ternary coefficient proposal; successful law obejmuje wszystkie gates |
| Uczciwe kodowanie | COMP_STATIC, zmienna długość |
| Język Verify | NONE i STATIC z rzeczywistymi guards/dekoderami |
| Backend / model | FPEMU; GCC14.2.0/C99/Linux x86_64 LP64 |
| Limity źródłowe | 3000000 outer KeyGen attempts; 16 outer Sign attempts |

### 3.1. Aktywny build na main: dokładny kandydat L_RHO

`Extra/c/` zawiera dokładne 17 plików kandydata wybranego przez właściciela
jako domyślny, widoczny na main build badawczy.
FT1536 jest nazwą profilu/builda, nie przemianowaniem katalogu Extra.

```text
manifest kandydata:
2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a
falcon-vrfy.c:
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42
```

To dokładnie źródło użyte przez L_RHO/L_NTT/L_V/M0. Wszystkie17 plików
sprawdzono względem manifestu, a build/check potwierdził odrzucenie starego
świadka: verify=raw=0, norm43058711057 i normalized_s0=16866, w trybie plain
i z obserwatorem rzeczywistych argumentów normy. FPEMU i adaptive CDF są
fizycznie częścią main, z zachowaną atrybucją.

Historyczne raporty mają `source_integrated=false` z chwili wykonania.
Nie zostały przepisane. Późniejsza integracja jest osobnym zdarzeniem Git;
bieżący stan integracji kandydata w tym punkcie wynosi **true**.

### 3.2. Historyczna referencja S17

```text
manifest S17:
03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589
falcon-vrfy.c S17:
01c496e5626a37b9d29848c596f0e0efaa328bf9b328649eea4bd1a45fa47f78
```

S17 jest zachowane w archiwum reference/ L_RHO i w historii, w tym w commicie
e8aa0fbb61cf3402a4069b1be84973db0058f406. Aktywny kandydat różni się od niego
wyłącznie lokalną poprawką falcon-vrfy.c; pozostałe16 plików są identyczne.
Oryginalny kontrprzykład do Ext0 pozostaje wynikiem o S17. Dawne reference
build/check receipts oraz nieudana próba wykorzystania starego S17-only
harnessu do testu nowego kandydata są zachowane jako historia.

### 3.3. M0 jako kontrakt callera i gry

`FT1536-M0-r40-static4096-parametric-v1` określa caller z pojemnością4096
i dokładnie40 bajtami nonce. `protocol_wrapper_integrated=false`.
Stary tool.c ma sig[2049] i zmienne external rlen; nowy opis protokołu nie
zmienia jego zachowania. Integracja opakowania ma własny przyszły binding.

Historyczne progi `2137772974` i `2138725304` istniały w przeglądach innych
profili, około sigma776. Nie zastępują B/sigma użytych w aktualnym łańcuchu.

## 4. Łańcuch verifiera: od kontrprzykładu do L_V

| Etap | Dokładny zakres | Commit |
|---|---|---|
| L_V-STATIC S17 | Kontrprzykład do krótkości Ext0 w required domain | 0b7cc0d |
| Blue | Niezależne potwierdzenie świadka i jego granic | bf4fb40 |
| L_RHO | Canonical residue każdego signed int16 | 5c2cdcc |
| L_NTT local | Słowa, tablice, bloki, kompozycja warunkowa | 1d78645 |
| L_NTT_GLOBAL | Prefix/frame, zakresy, globalny inverse | d67228d |
| L_NTT_FORWARD | Forward/CRT, iloczyn i pełna kompozycja | 71bbb35 |
| L_V_BRIDGE | Parser/loader, centrowanie, Q, strict B, pełna ekstrakcja | 17f8f8b |
| M0 | Kontrakt gry, zasoby, ledger, framing i pojemność | 95f8015 |

### 4.1. Co obalił pierwotny świadek

Publiczne h* i syntetyczny s2=(-20000,0,...) przy c=8670*h* dają w S17
preNTT0=63969, a nie poprawne residue16866. Source Verify akceptuje z normą
400000000, podczas gdy dokładne Q(Ext0)=43058711057>B.
To kontrprzykład do wskazanego lematu, nie znalezienie preimage H2P lub
efektywnego EUF-CMA forgery. Kandydat odrzuca ten sam świadek.

### 4.2. L_RHO i L_NTT

Poprawka `(x+36866)%18433` daje canonical residue dla wszystkich int16,
z wykazanymi zakresami. L_NTT obejmuje rzeczywisty porządek stores, dynamiczne
twiddles i wynik forward w indeksach3i+j. Iloczyn jest niezależnym
productCoefficient/remMonomial modulo Phi, nie definicją przez NTT.

```text
CanonVec h -> CanonVec r -> CanonVec c ->
pipelineC h r c=(product h r,subtract(product h r)c).
```

W końcowej tezie nie pozostaje hipoteza forward_product lub globalnego
inwariantu. L_NTT_rho wiąże ją z dowolnym signed int16 s.

### 4.3. Pełne L_V dla kandydata

```text
V_CAND(h,c,b)=1 =>
  s(b) i Ext0 są zdefiniowane,
  z1+h*z2=c modulo(q,Phi),
  Q(z1,z2)<2093922385,
  (z1,z2)=(center_q(c-h*s(b)),s(b)).
```

Dziedzina: wszystkie canonical h,c i legalne skończone b w przypiętym
modelu. Jest szersza od samych kluczy KeyGen i uczciwych podpisów.
Nie ma capu2049 lub4096 po stronie fałszerza.

Rozliczono signed narrowing GCC, dowolnie długi skończony unary z uint32
wrap, inicjalizację1536 wartości, oba tryby, header/padding/length guards,
loader i jego rzeczywiste trailing-PK behavior. Center C jest negacją
pierwszego składnika Ext0; Q0(-a)=Q0(a) zachowuje cały cross term.
Norma ternary ma int64 accumulator: każdy int32 iloczyn i każdy prefiks
zostały ograniczone, a końcowa suma jest dokładnie Q, z porównaniem `<B`.

Tezy L_V_BYTES/L_V_LOADED/L_V_SOURCE nie mają otwartych przesłanek poprawności
tego mostu. Jawna translacja C/model, ABI i legalne obiekty pozostają zakresem
twierdzenia; nie jest to formalna weryfikacja kompilatora lub wszystkich API.

## 5. Pełna mapa historycznego T2C3

Oryginalny wynik dotyczy jednej instancji K0, związanej publicznym PK/h,
commitmentem uporządkowanej czwórki, źródłami S17 i konkretną redukcją bazy.
Publiczny PK ma hash57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f.
Prywatnych współczynników nie ujawnia się przez kopiowanie publicznych certyfikatów.

```text
K0 + foundation (graf, Frobenius, metryka i znaki)
  -> raw coherence -> deterministyczna definicja reduktora
  -> zastosowanie: companion552238 ->448642, te same f,g i krata
  -> cumulative coherence -> D2 (tilt beta)

A/B/C1/C2/C3 + D1: wspólne interfejsy analityczne i źródłowa mapa
D5 + kanoniczny D7 -> D8 -> D9/D10 -> E_h*^0<2^-90
D3 + A/B/C3 + D7/D9 + D11D1 -> D11E2
  -> globalna mean energy<2^-79 -> T_h*<2^-99

E_h*^0 + T_h* + p_T<2^-24 + dokładne Route C
  -> final composition -> E_h*^Q<2^-89
```

Dokładna ostatnia kompozycja:

```text
E_h^Q <= (sqrt(E_h^0)+sqrt(T_h))^2/(1-p_T)^2
E_h*^Q < 4489/[2^54*(2^24-1)^2] <2^-89
integer gap: (2^24-1)^2 -4489*2^35 =127234077622273>0.
```

Kanoniczne dane mają Q(f,g)=2044 i konserwatywne endpointy113/9923.
Stare2087/9860 nie są zamiennikami tych danych. D2 przy beta i D9 przy skali
sigma są różnymi obiektami. Starsze D4/J oraz selected-major D11E1 nie są
automatycznymi lukami końcowej drogi D11E2. D11E1 V2 to osobna poprawka
raw-count normalization, nie „D11E2 V2”.

Historia integracji w historycznym repo H: b478ba359cfea7b18243c95a9705351491bb167b;
późniejszy research freeze d641ab1037c2fa1dd4a22c258854d79d67b9b46b.
Final-composition manifest:852659713bc97c881606ee8fe53cb14f39b5e5351c1ec0cc028c4fafab41cd9c.
Są to historyczne identyfikatory H, nie deklaracja ich obecności w historii
obecnego GitHub main.

Szczegółowy ledger31 pakietów i rozróżnienie krawędzi matematycznych,
źródłowych, proweniencyjnych i kolejki zachowuje
[audyt ciągłości](../../documents/FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md).
[Późniejsza kontrola D11E2](../../documents/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md)
rozlicza pytanie o ogólny most analityczny. Starszych uwag nie odczytuje się
jako automatycznego cofnięcia późniejszego wyniku.

## 6. T5 — oddzielna droga i kwantyfikator

```text
successful S17 KeyGen + obowiązkowy source leaf gate
 -> FPEMU/FFT numerical soundness i publiczny twiddle audit
 -> exact leaves i baza kraty grafowej
 -> integralny coefficient tower: jeden ternary i osiem binary splits
 -> block LDL + reciprocal q^2/lambda reversal
 -> shifted-theta induction i1536 czynników A2
 -> rho(L_h)-1<2^-40 dla każdego successful output.
```

Przykładowa końcowa obwiednia użyta przez ten wynik:

```text
(1+6*2^-65/(1-2^-65)^2)^1536-1 <2^-40.
```

Good-key set to pełny successful-output support dla TEGO pure/untruncated
twierdzenia. delta_key=0 nie oznacza zerowej szansy niepowodzenia KeyGen,
źródłowego samplera idealnego ani populacyjnego sharp-truncation theorem.
Poprawiona wersja a2 zachowuje wspierane podwyniki a1 i ma osobną historyczną
akceptację. Manifest a2:4dc5051289736004f5729c645c194beeb983a9203a3f79e38a0465d395dd0819.

[Mapa T2C3/T5](../../documents/FT1536_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md)
opisuje theorem-to-artifact bindings i publiczny zakres odtwarzania.
Pełny samowystarczalny eksport dawnych certyfikatów/runnerów jest nadal pracą
publikacyjną; obecność audytów nie jest deklaracją wykonania wszystkich
historycznych prywatnych producentów lub wszystkich replayów Sage9.5.

## 7. M0: dokładny nowy kontrakt

Właściciel wybrał4096 bajtów payloadu uczciwego Sign oraz bound parametryczny.
Nonce40 pozostaje osobno; faktyczna długość b jest zmienna.

| Element | Kontrakt M0 |
|---|---|
| KeyGen | Jeden capped call, success całego wywołania i serializacji |
| Prawo | K_seed[E]=Law(output|E_K), przy p_K>0 |
| Wspólny klucz | Jedna para dla wszystkich queries; nie nowe conditioning przy Sign |
| Środowisko | Publiczny plan usług E; E0 all-success jako wyróżniony model |
| Sign | Świeży kontekst, ten sam wyemitowany sk, m ustalone przed nonce |
| Odpowiedzi | PRE_ABORT, (r,POST_ABORT), (r,b); bez partial buffer/reason/timing |
| Framing | Dokładnie40 bajtów r; transport r[40]||b z długością rekordu |
| Cel | Ordinary classical EUF-CMA w direct-output ROM |
| Świeżość | m* nie było żadnym Sign query, także query z abortem |
| Fałszerz | Pełny legalny język Verify, bez honest-cap4096 |
| Zasoby | Q_s,Q_H,t,w,L; bit-step work, memory bits, interface bytes |
| MT-ISIS | Jeden klucz K_seed[E], Q_H+1 uniform celów; bez centered z2 |

`Adv_uncond=p_K*Adv_cond` płaci warunkowanie KeyGen dokładnie raz.
K_seed, K_iid, raw ternary proposal i h* są odrębnymi obiektami.
Brak powrotu z uncapped loop i nieokreślona operacja STUCK nie są darmowym
źródłowym bot. H3/terminacja/budżety mają własne obowiązki.

Źródłowy parent SHAKE budżet świeżego Sign:40+16*56=936 bajtów.
56 bytes to key32+IV16+counter8 exact Falcon PRNG, nie448-bitowy klucz ChaCha.
Capacity512 oznacza SHAKE-256. Uniform nonce320 jest cechą odpowiedniej gry
po hopie RNG, nie statystyczną własnością ekspansji source seed256.

Pełne definicje: [GAME](../FT1536_M0_CONTRACT_RUN_001/GAME.md),
[RESOURCE_MODEL](../FT1536_M0_CONTRACT_RUN_001/RESOURCE_MODEL.md),
[TARGET_TYPE](../FT1536_M0_CONTRACT_RUN_001/TARGET_TYPE.md).

## 8. Dowód pojemności i jego praktyczne znaczenie

Z Q(s1,s2)<B, całkowitoliczbowości i dodatniości A2:

```text
sum s2_i^2 <=2Q0(s2)<=2(B-1)
3302|x|<=x^2+2725801
sum |s2_i|<=2536243
sum floor(|s2_i|/256)<=9907
STATIC bits<=10*1536+9907=25267
payload<=1+ceil(25267/8)=3160<4096.
```

Kernelowy EncoderCount rozlicza9-bitowy prefix, unary terminator, drain,
padding i guards każdego zapisu. `STATIC_FITS_4096` konsumuje source norm
acceptance i używa4095 bajtów data+1 header. To dowód pojemności/control-flow
z jawnym bindingiem C; universal byte-value correctness całego Sign jest
odrębnym obowiązkiem.

Rzeczywisty koder potwierdził s1=0, s2=(x,-x), x=330×1792 i438×1536:
Q=2093088768<B, payload3156. Bufory2049/3073 zawodzą,4096 przechodzi
round-trip/canaries i ASan/UBSan. To syntetyczny wektor, nie podpis
wylosowany przez Sign.3160 jest bezpiecznym boundem, nie deklarowanym optimum.

Usunięto jedną przeszkodę: przy legalnym callerze4096 po zdefiniowanym source
norm acceptance brak miejsca nie powoduje failure STATIC. Nie usunięto
faultów, loader/entropy errors, norm exhaustion ani pre-cast/geometry losses.
Raw transport udanego podpisu M0 ma z tego boundu <=3200 bajtów z nonce40;
nie jest to stała długość ani limit wejść przeciwnika.

## 9. Poprawa analizy strat: TV, chi-square i właściwy kierunek

Stara tabela TV opisywała konserwatywną technikę, nie barierę konstrukcji.
Przy wspólnym prawie początkowym i pełnych warunkowych jądrach S_i<<R_i:

```text
chi2(S_i(.|history)||R_i(.|history))<=e
Delta=(1+e)^n-1
p=R(win), r=S(win)
(p-r)^2<=Delta*p*(1-p)
p<=Phi_Delta(r)
Phi_Delta(r)=[2r+Delta+sqrt(Delta^2+4Delta*r(1-r))]/[2(1+Delta)].
```

Iloraz wiarygodności składa się przez warunkowy drugi moment, nie przez
założenie niezależności adaptacyjnych odpowiedzi. Dla tego kierunku D2
zwykły Hölder ogranicza r przez sqrt(1+Delta)*sqrt(p), a nie potrzebne p
przez r. Mały logarytm mnożnika sam nie rozstrzyga całej straty.

Warunkowy przykład e=2^-106, n=2^20, r<=2^-128 daje około2^-86,
wobec liniowego składnika TV2^-34. Różnica około52 bitów dotyczy jednego
porównania. Dla r=0 ogólna granica Delta/(1+Delta) jest osiągalna przez
prawa Bernoulliego; lepszy wynik wymaga mocniejszej przesłanki lub struktury.

W FT1536 nadal trzeba związać pełne kernels po historii, nonce/freshness
gates, serializację i aborty. Nie przenosić automatycznie tej metryki na H1R
z innymi prawami i brakującymi atomami. M0 nie instancjuje e/gamma/epsilon
wartościami rzekomo już dowiedzionymi dla całego źródłowego schematu.

## 10. Dalsze zależności — konkretna kolejność

```text
M0 [ZDEFINIOWANE] -> M1 H3 range
                         -> M2 scalar + pełna joint geometria
                         -> M3 pre-cast/bajty/fault/retry

T5 + uniwersalne analytic interfaces -> M4 spójny R5T -> image bound e
idealne wspólne kernels + e -> M5 event-transfer chi-square
framing + publiczny sampler + M5 -> M6 klasyczna symulacja ROM
M3 + M4 + M6 + L_V + prymitywy/MT + zasoby -> M7 kompozycja
```

| Obowiązek | Co dokładnie ma dostarczyć |
|---|---|
| M1/H3 | Osiągalne centra dla emitted keys; poprawne floor/conversion i s+z |
| M2 | Związanie scalar kernels, computed dss i całej geometrii próby z właściwym prawem joint |
| M3 | Faktyczne pre-cast/bytes/stopping, observable failures i poprawność uczciwych wyjść |
| M4/R5T | Spójny nowy pakiet istniejącego warunkowego sharp-tail argumentu i konsumpcja jego przesłanek |
| M5 | Poprawny conditional R/S kernel transfer z pełnymi odpowiedziami i właściwą orientacją |
| M6 | Publiczny sampler D^B, time/error budgets, freshness/programming i assignment celów |
| M7 | Złożenie bez podwójnych kosztów, z zasobami i jawnymi założeniami trudności |
| XOF/QROM | Odrębne późniejsze modele/hopy, nie konsekwencja klasycznego ROM |

### H3 jako następny wąski krok

[H3_INTERFACE](../FT1536_M0_CONTRACT_RUN_001/H3_INTERFACE.md) zachowuje
emitted-key support, wszystkie wymagane historie/próby/scalar prefixes i cel:

```text
floor(mu) in [-2147483283,2147483281]
z in [-365,366]
poprawna konwersja oraz zdefiniowane s+z.
```

Sama skończoność mu, poprawne liście lub skończona kampania nie wystarczą.
Potrzebny jest source-bound argument o FFT/LDL, multipliers, residuach i FPEMU.
Szerszy zbiór wejść prywatnego loadera nie jest populacją emitowaną przez
KeyGen. Prototyp H3G nie jest źródłową przesłanką; rounded rhat=1 było już
uwzględnione w istniejącym warunkowym H3 arithmetic.

### R5T i pozostałe liczby warunkowe

R5T ma argument do mean<2^-118, T_h<2^-138, E_acc,h<2^-106 dla successful
support pod przypiętymi interfejsami. Stary OUTPUTS279dce... nie odpowiada
czterem sprawdzonym plikom po odpowiedzi na recenzję. Wymagany jest nowy
spójny pakiet, nie zmiana starego manifestu i nie odkrywanie metody od zera.

H1R ma użyteczny direct-TV finite-exact→infinite-exact, a R3G poprawną
warunkową kolejność likelihood+TV. Ich source/geometry/byte instancjacje
pozostają. H6P pokazuje, że scalar summaries nie wyznaczają eta_pre.
Nowy bound pojemności nie dostarcza brakującego joint law.

## 11. Ledger i typ końcowego twierdzenia

M0 ma22 wiersze z parami praw, kierunkiem, metryką, conditioning, zakresem
historii, kosztami i właścicielem każdego zdarzenia. [HOP_LEDGER](../FT1536_M0_CONTRACT_RUN_001/HOP_LEDGER.md)
jest właściwym miejscem konsumpcji kolejnych wyników.

Przyszły M7 ma wyprowadzić istnienie reduktora MT z ograniczonymi zasobami
i upper boundem na Adv, z konkretnych certyfikatów M1–M6. M7 nie jest
założeniem tego rekordu. Source-byte/RNG/budget, exp(Q_s gamma3), H1R/geometry,
freshness/retry i Phi_Delta mają określoną kolejność. Przesunięcie błędu
przez exp/Phi wymaga innego udowodnionego porównania.

Nie wybrano konkretnego Q_s/Q_H/t/w/L lub lambda. Estymator kratowy nie jest
theorem hardness, a hipotetyczne wartości epsilon nie są obecnym wynikiem.
Następne prace mają dostarczać brakujące interfejsy, nie tylko większą liczbę
PASS lub formalnie poprawny bound obcięty ostatecznie do1.

## 12. Odtwarzalność i wykonane odbiory

| Odtwarzany etap | Zgodne pliki znaczeniowe |
|---|---:|
| L_V-STATIC | 10 |
| L_RHO | 64 |
| L_NTT local | 98 |
| L_NTT_GLOBAL | 103 |
| L_NTT_FORWARD | 217 |
| L_V_BRIDGE | 402 |
| M0 | 273 |

Blue ma archiwum niezależnej recenzji, bez jednego pełnego runnera.
Najpóźniejsze odbiory ponownie budowały źródła Lean i wykonywały właściwe
C/Sage/sanitizer controls w nowych sandboxach. Dokumenty definicyjne M0
były kopiowane jako definicje, nie przedstawiane jako odkryte dowody.
Liczby twierdzeń dotyczą różnych domknięć zależności, więc ich nie sumujemy.

Z czystego checkoutu z dostępnym przypiętym toolchainem:

```sh
python3 -B proofs/ft1536/tools/archive.py verify
python3 -B proofs/ft1536/tools/archive.py replay FT1536_M0_CONTRACT_RUN_001 --run reader-001 --timeout 1200 --hide-originals
make verify-FT1536-sources
make check-FT1536
```

Replay wymaga Linux/GCC14.2/Sage10.9/Lean4.34/Std i ścieżek opisanych
w archiwum. Repo nie zawiera ich dystrybucji. Nie uruchamiać runnerów
w zamrożonych stages; fresh DEST i zewnętrzny pin są częścią protokołu.
Sam ten dokumentacyjny freeze ma `replay=none`: jego kontrolą jest
integralność, zgodność z bazą Git i przegląd stanu, nie kolejny dowód.

## 13. Publikacja, kod i powrót do pracy

Główna strona repo wskazuje aktualne wyniki i ten punkt pracy. Dawny README
zachowano jako niezmienioną historię. Build FT1536 jest poza źródłami,
sprawdza17 pinów S17 i zachowuje receipts. Domyślne sprawdzenie używa publicznych
syntetycznych danych, bez KeyGen/Sign lub prywatnych plików.

Poprawiony verifier jest już aktywnym kodem main. Do dalszej integracji
pozostaje rzeczywisty wrapper M0. Kolejne zmiany mają własne wersje i bindings;
nie nadaje się ich wstecznie archiwalnym raportom. Historyczne S17 pozostaje
rozpoznawalną referencją.

Ten punkt opisuje committed main na wskazanej bazie. Nie jest kopią lokalnych
cache, aktywnych prac, prywatnych danych lub zastanego niecommitowanego indeksu.
Odtwarzanie na innej maszynie należy prowadzić w nowym checkout/worktree,
zamiast resetować istniejącą pracę w celu dopasowania jej do dokumentu.

Przy wznowieniu: sprawdzić STATE/CHECKPOINTS/INPUTS i pin OUTPUTS, odczytać
M0 GAME/ledger/H3_INTERFACE, wskazać konkretny nowy lemat, utworzyć nowe W
i zachować użyteczne ukończone zależności. Następny etap wymaga odrębnego
zlecenia. Niniejszy freeze nie uruchamia H3 ani innych zadań automatycznie.
