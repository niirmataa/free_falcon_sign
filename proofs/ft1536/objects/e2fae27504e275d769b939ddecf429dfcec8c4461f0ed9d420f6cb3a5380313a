# GPT-ASTRA — L_NTT_GLOBAL: globalny inwariant buforów i domknięcie kompozycji

Data: 2026-09-18. Kontynuacja ukończonego `L_NTT_RUN_001 / PARTIAL_PROOF`.

## 0. Karta zadania

- **Cel:** zinstancjować globalne forward i inverse dla rzeczywistych pętli
  in-place C, następnie domknąć iloczyn i końcową tezę L_NTT.
- **Po co teraz:** kontrakty słów, generatora i lokalnych bloków już istnieją.
  Brakuje dowodu, że wszystkie aktualizacje bufora składają się na wymagane
  funkcje globalne. To obecny blokujący obowiązek, a nie brak kolejnych testów.
- **Odczyt:** zamrożony wynik częściowy i konsumowane przezeń L_RHO.
- **Zapis:** tylko `/home/footfalcon/Dokumenty/FT1536_L_NTT_GLOBAL_RUN_001`.
- **Wynik:** źródłowe instancje globalnych interfejsów, zastosowanie kompozycji,
  zaktualizowana macierz obowiązków i sprawdzalny raport.
- **Warunek końca:** rozstrzygnięcie dokładnego L_NTT dla przypiętego kandydata.
  Dodatni wynik nie jest założony; niedomknięte obowiązki muszą pozostać jawne.

Kontynuuj pracę do raportu, nie poprzestawaj na przepisaniu planu lub
dotychczasowej listy luk. Głównym produktem mają być nowe globalne dowody.

## 1. Zachowanie kontekstu i nowy obszar pracy

```text
DOC = /home/footfalcon/Dokumenty
PREV = DOC/FT1536_L_NTT_RUN_001
RHO = DOC/FT1536_L_RHO_RUN_001
W = DOC/FT1536_L_NTT_GLOBAL_RUN_001
```

Możesz kontynuować **w obecnej rozmowie Astry**. Zachowaj znajomość źródła
i dotychczasowych prób, ale ustaw nowe cwd oraz rzeczywisty sandbox zapisu
na W. Samo wpisanie nowej ścieżki w instrukcji nie zmienia sandboxa klienta.
Jeżeli technicznie nie możesz przenieść zapisu, zgłoś tę konkretną przeszkodę.

Przeczytaj lokalny `W/AGENTS.md`, nadrzędne instrukcje oraz:

1. `DOC/FT1536_PODSUMOWANIE_L_NTT_PARTIAL_2026-09-18.md`;
2. `PREV/REPORT.md`, `CLAIM.md`, `RESULT.json`, `OBLIGATIONS.json`;
3. `PREV/DERIVATION.md`, szczególnie D5–D6;
4. cztery finalne moduły `PREV/formal/`;
5. `DOC/FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md`.

PREV i RHO są zamrożonymi wejściami. Nie wznawiaj ich runnerów w oryginalnych
katalogach, nie dopisuj ich dzienników ani nie zmieniaj manifestów. Jeśli
w nowym W istnieją już wyniki, ustal ich stan i wznów bez nadpisania historii.

Piny SHA-256:

```text
DOC/FT1536_PODSUMOWANIE_L_NTT_PARTIAL_2026-09-18.md
6a3b1699290448ccb02256ff06be978abb7f6b4b35fcfe45a85ec4b95d69394d

DOC/FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md
9f6b0731263853867914f5d1227ba62dd1059e8a79623d987204c3f4aa3d5da1

PREV/REPORT.md
b89d618d7c1d3992fa1a9ea0ae8c84dcc348448f035905b87a03c37e20dfd650

PREV/OUTPUTS.sha256
f23358ce0426f04196bbd8fd4e814afb2b14541c6df13854a67c994f6074771f

PREV/CLAIM.md
c8e62a9d55cb8922d6cc3c673c249452983879329f92ab4ab79ab1eeb07c65c6

PREV/DERIVATION.md
f91c0052528f84f85b2379dfc9c9c1df3c34f352836d2535ca88c25e7a9ab367

PREV/OBLIGATIONS.json
5467801aac9c25f3c1f757f3c640fefcbb6074524874da0312a6e97aaa163bd8

PREV/source/falcon-vrfy.c
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42

PREV/formal/Words.lean
4630b8b49186ccbf49a074e7e684e8125bbf14e6aadfc5443be8e2cbedb7f52b

PREV/formal/Linear.lean
60b843d305f264d47b9411f479d83f647e747b9e9bd7763fa43f27d198336dd5

PREV/formal/Tables.lean
ee668bf1b63a8cb9a3192b39fee68347ed67481d4c73e948372ffc1db203821e

PREV/formal/Composition.lean
0ee19f21c9acdb4361d862905d7ab090ed3bb904066a22059cf7688948a34772
```

Sprawdź piny i hashe faktycznie konsumowanych plików. Skopiuj 17 plików
`PREV/source/` do `W/source/`, względem przypiętego manifestu kandydata
L_RHO (SHA-256 `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`).
Źródła C zachowaj bajtowo. Potrzebne certyfikaty, modele, wycinki i dane
przenieś jako przypięte wejścia do nowego W. Nie ponawiaj całego audytu
708 artefaktów w miejsce pracy nad brakującym inwariantem.

## 2. Teza docelowa pozostaje L_NTT

Zachowaj parametry, model i dziedzinę poprzedniego CLAIM:

```text
N=1536, ternary=1, logn=10, q=18433
Phi=X^1536-X^768+1, R_q=(Z/qZ)[X]/(Phi)
R_M=65536, Rt=10237, R2t=4564, Q0It=18431, Rinv=5184
```

Model: GCC 14.2.0 / C99 / Linux x86_64 LP64; bajt 8-bitowy, int/unsigned
i int32_t/uint32_t 32-bitowe, int16_t/uint16_t 16-bitowe, long/size_t
64-bitowe; legalne bufory, wyrównanie i wymagane niealiasowanie.

Dla wszystkich canonical `h,r,c in [0,q-1]^1536` rzeczywista kompozycja:

```text
H := kopia h
mq_NTT(H,10,1)
mq_poly_tomonty(H,10,1)
a := kopia r
mq_NTT(a,10,1)
mq_poly_montymul_ntt(a,H,10,1)
mq_iNTT(a,10,1)
p := snapshot a
mq_poly_sub(a,c,10,1)
d := snapshot a
```

ma kończyć się z legalnym wykonaniem, poprawnymi zakresami oraz:

```text
p=canonical_q(h*r mod Phi)
d=canonical_q(h*r-c mod Phi).
```

Nie zmieniaj tego celu na roundtrip, test jednego klucza lub poprawność
innej implementacji NTT. Pełne L_V, parser, centrowanie C, norma i ścisły B
pozostają poza tym etapem. Konsumowane L_RHO nadal daje canonical r=rho(s)
oraz r≡s; po domknięciu L_NTT wyprowadź odpowiednie podstawienie.

## 3. Konsumpcja ukończonych wyników

Utwórz `REUSED_RESULTS.md`: dla każdego użytego faktu podaj oryginalny pin,
nazwę twierdzenia/certyfikatu, przesłanki oraz miejsce zastosowania w nowym
dowodzie. Zachowaj rozróżnienie kernel proof, uzasadnienia C→model oraz
kontroli wykonania.

Wykorzystaj przede wszystkim:

- Words: canonical add/sub, Montgomery, low16 przy uint32 wrap i zakresy;
- Tables: dynamiczny generator logn=10, użyty prefiks 0..1023, rev10,
  jednostki, relacje drzewa i certyfikaty bloków;
- Linear: symboliczne działania i kompozycje lokalnych wierszy 2/3 oraz scaling;
- Composition: rzeczywisty iloczyn współczynnikowy przez remMonomial,
  toMont/montPoint i warunkowy lemat końcowy;
- DERIVATION D3–D6: dokładne harmonogramy, specjalny pierwszy blok i plan CRT.

Nie zakładaj nieistniejącego globalnego twierdzenia na podstawie samego
statusu lokalnego obowiązku. Jeśli potrzebny szczegół nie wynika z zachowanej
tezy, uzupełnij go jawnie. Nie zastępuj dynamicznego mq_mkgm3 tablicami
statycznej gałęzi logn<=9. Nie czytaj niezainicjalizowanego ogona tablic.

## 4. Obowiązek A — konkretny model stanów bufora

Zdefiniuj wykonywalne modele forward i inverse odpowiadające przypiętym
pętlom C. Powiąż każdą aktualizację z instrukcjami źródła: zmienne pętli,
indeksy, odczyt starych wartości do temporaries, kolejność zapisów,
prymitywy modularne i reprezentacje.

Wykaż, kiedy operacje na rozłącznych parach/trójkach można potraktować jako
równoczesny etap matematyczny mimo wykonania in-place. Inwariant ma obejmować
również częściowo przetworzony etap, a nie tylko stan przed/po idealnej mapie.
Udowodnij initialization-before-read, legalność indeksów, zakończenie
i utrzymanie zakresów wymaganych przez prymitywy oraz casty do uint16.

Nie definiuj modelu źródłowego jako idealnej ewaluacji wielomianu, a następnie
nie ogłaszaj ich zgodności przez rozwinięcie definicji. Model przejść pętli
i specyfikacja matematyczna mają być połączone rzeczywistym dowodem.

## 5. Obowiązek B — FORWARD_GLOBAL

Udowodnij dla każdego canonical v interpretację kolejnych stanów jako
współczynników reszt w drzewie CRT. Korzystaj z inwariantu DERIVATION D5:

1. Po pierwszym bloku: reszty f modulo `X^768-a_root` i
   `X^768-(1-a_root)`, gdzie ordinary `a_root=14649`.
2. Przy rozszczepieniu bloku stopnia t z etykietą tau i `s^2=tau`:
   `A+sB` oraz `A-sB` są resztami modulo `X^(t/2)-s` i `X^(t/2)+s`.
   Powiąż dokładnie etykiety dzieci z fizycznymi adresami i użytym gm.
3. Obsłuż specjalne równania pierwszego poziomu binarnego, a następnie
   wszystkie osiem poziomów `(m,t)=(2,768),...,(256,6)`.
4. Poziom cubic ma 512 bloków. Dla `alpha_i` odpowiadającego ordinary
   `gm[512+i]` i `omega=14648` wyprowadź, w rzeczywistym porządku:

```text
F_C(v)[3*i+j] = sum_{k=0}^{1535} v[k]*(alpha_i*omega^j)^k mod q
0<=i<512, 0<=j<3.
```

Wartości i relacje tablic są konsumowanymi certyfikatami; nowym obowiązkiem
jest globalne zastosowanie ich do dowolnych danych v i stanów pętli.

## 6. Obowiązek C — INVERSE_GLOBAL

Powiąż source inverse z odwróceniem tych samych bloków i fizycznych adresów.
Przenoś lokalne tożsamości inverse*forward wraz z narastającym skalowaniem.
Rozlicz `3*2^8*2=1536` oraz `ni=6187`, reprezentujące ordinary
`18421=1536^(-1) mod q`.

Udowodnij dla każdego canonical v:

```text
G_C(F_C(v))=v.
```

Zachowaj legalność stanów i canonical range. Samo pokazanie odwracalności
abstrakcyjnych macierzy, bez związania kolejności ich zastosowania z C,
nie zamyka tego obowiązku.

## 7. Obowiązek D — dziedziny, iloczyn i instancjacja kompozycji

Obecne `Composition.lean` ma `Vec := Fin 1536 -> Int` i interfejsy dla
wszystkich takich wektorów. Kontrakty wejściowe C wymagają canonical danych.
Jawnie dopasuj te dziedziny.

Naturalnym rozwiązaniem jest formalne podniesienie:

```text
F(v)=F_C(canonical(v))
G(v)=G_C(canonical(v)).
```

Jeśli wybierzesz tę konwencję, udowodnij jej zgodność z tezą dla canonical
wejść oraz potrzebną niezmienniczość iloczynu przy canonicalizacji.
Równie poprawne jest użycie jawnie ograniczonej kompozycji z przesłankami
canonical i dowodem zastosowania do dokładnego CLAIM. Żadna konwencja nie
uprawnia do dopisania normalizacji lub innych operacji do rzeczywistego C.

Wyprowadź z FORWARD_GLOBAL, własności węzłów względem Phi i rzeczywistej
definicji product:

```text
forward_product : forall h r, F(product h r)=pointMul(F h,F r)
inverse_forward : forall a, G(F a)=canonical a.
```

W formule powyżej użyj właściwego uzasadnionego liftu albo jawnej wersji
restricted-domain. `product` pozostaje iloczynem współczynnikowym modulo
Phi; nie wolno zdefiniować go przez badany NTT.

Następnie zastosuj istniejącą kompozycję do konkretnych F/G i otrzymaj
końcowy lemat dla source pipeline, p oraz d. Wykorzystaj udowodnione
usuwanie czynnika Montgomery i kontrakt odejmowania. Wyprowadź podstawienie
r=rho(s) z L_RHO.

Końcowe twierdzenie nie może nadal przyjmować poprawności forward/inverse,
globalnego inwariantu, source/model equivalence lub poprawności iloczynu
jako nierozliczonych parametrów. Sprawdź **pełny typ i wszystkie argumenty**,
także implicit i typeclass; samo `#print axioms` nie ujawnia wszystkich
założeń twierdzenia.

## 8. Weryfikacja i czysty log

Użyj Lean 4.34.0/Std, Sage 10.9 przez `sage plik.py ...` i GCC 14.2.0,
zgodnie z dotychczasowym modelem. Nie instaluj zależności. Przypnij wersje,
pełne źródło, rzeczywiście użyte modele i certyfikaty.

- Sprawdź kernelowo nowe dowody i konsumowane formalne zależności.
  Pokaż pełne typy końcowych tez i `#print axioms`; bez `sorry`, `admit`,
  `native_decide` lub lokalnych aksjomatów brakujących globalnych faktów.
- Każdy nowy checker certyfikatu musi mieć uzasadnioną poprawność i wiązać
  dane z właściwymi definicjami, kolejnością i źródłem.
- Ograniczone kontrole porównawcze C/model/Sage dobierz do nowych miejsc
  powiązania: prefiksy etapów, granice bloków, kolejność cubic i scaling.
  Konsumuj wcześniejsze wyniki zamiast powtarzać całą kampanię prymitywów.
- Jeśli dodajesz nowy walidator, sprawdź wykrywanie rzeczywistej zmiany
  kolejności/etykiety/skali i przejście no-op. Sama zgodność roundtrip
  nie zapewnia właściwej interpretacji iloczynu i porządku source buffers.
- Instrumentacja wyłącznie w opisanych kopiach testowych: usunięcie
  wstawki ma przywracać pin. Źródło produkcyjnej kopii pozostaje niezmienione.

**Wymóg użytkownika: czysty log nowych i modyfikowanych plików Lean.**
Stosuj aktualne nazwy lematów, w szczególności `ite_eq_left`/`ite_eq_right`
oraz `Int.natCast_nonneg`. Zachowuj pełne stdout/stderr; nie wyciszaj
ostrzeżeń ani nie filtruj logu w celu uzyskania pozornego czystego wyniku.

Przypięte historyczne kopie zachowaj w inputs/ bez zmian. Jeśli dla importu
tworzysz dostosowaną roboczą kopię formalnej zależności, zapisz jej diff
i nowy hash, wykaż niezmienność tez i ponownie ją sprawdź. `Words.lean:99`
używa starego `Int.ofNat_nonneg`; tę kosmetykę można poprawić wyłącznie
w takiej nowej kopii. Ostrzeżenia z niezmienianych wejść/dependencies
oznacz jawnie wraz z pochodzeniem.

## 9. Wykonanie, artefakty i werdykt

Pracuj wyłącznie w W, z rzeczywistym ograniczeniem zapisu narzędzi do W.
Kopię source/ montuj/traktuj jako tylko do odczytu. Cache, HOME, TMPDIR,
DOT_SAGE i XDG_CACHE_HOME kieruj pod W. Nie wykonuj operacji na sekretach,
nowego KeyGen, instalacji, sieci badawczej, innych agentów, commitów i publikacji.

Używaj jawnych budżetów czasu/pamięci poszczególnych sprawdzeń. Zachowuj
checkpoints i nieudane próby poza finalnym zakresem dowodu. Timeout,
przerwanie usługi lub błąd taktyki nie są kontrprzykładami matematycznymi.
Nie pozostawiaj wcześniejszego procesu obliczeniowego podczas nowej próby.

Wymagane wyjścia:

- `REPORT.md`, `RESULT.json`, `CLAIM.md`, `OBLIGATIONS.json`;
- `REUSED_RESULTS.md`, source/model binding i dokładne globalne inwarianty;
- własne moduły formalne, konsumowane certyfikaty, checkery i receipts;
- `INPUTS.sha256`, `TOOLCHAIN.txt`, `COMMANDS.log`, pełne logi;
- `REPLAY.md`, `OUTPUT_SCOPE.md`, `OUTPUTS.sha256`.

Macierz ma pokazać, które wcześniejsze wyniki są konsumowane i które nowe
obowiązki zostały faktycznie domknięte. Dla pozostałej luki podaj konkretną
tezę, jej najbliższe zależności i miejsce w źródle/modelu. Liczba nowych
deklaracji ani testów nie zastępuje stanu tych obowiązków.

Statusy:

- `L_NTT_PROVED_FOR_PINNED_MODEL` — pełne poprzednie CLAIM domknięte dla
  konkretnego źródła, z globalną instancjacją i rozliczonymi zakresami;
- `PARTIAL_PROOF` — dokładny wykaz nowych wyników i wciąż otwartych interfejsów;
- `COUNTEREXAMPLE_CANONICAL_DOMAIN` — odtwarzalna rozbieżność w dokładnej
  dziedzinie tezy, związana z rzeczywistym kodem, nie tylko błędnym modelem;
- `EXECUTION_BLOCKED` — konkretny problem wykonania bez rozstrzygnięcia tezy.

Zachowaj `source_integrated=false`, `owner_accepted=false`,
`full_L_V_proved=false`. Zidentyfikuj konsumowane PREV/L_RHO, piny i ewentualne
dostosowania formalnych zależności. Zamroź nowy manifest, zakres i prefiks
dziennika; replay wykonuj w świeżej kopii i rozlicz pliki znaczeniowe.

Na końcu podaj po polsku wynik, dokładnie zamknięte i otwarte obowiązki,
jedną następną rekomendację, pełną ścieżkę REPORT.md oraz SHA-256 raportu
i OUTPUTS.sha256. Zakończ przed dowodem pozostałych części L_V lub integracją.
