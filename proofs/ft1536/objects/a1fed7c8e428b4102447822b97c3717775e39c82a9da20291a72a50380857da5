# FT1536 — zakończone L_RHO i następny interfejs dowodu

Data: 2026-09-18. Kontrola po otrzymaniu końcowego raportu Astry.

## Karta dla autora

- **Cel:** sprawdzić ukończone L_RHO i zapisać jego dokładny zakres.
- **Wejście:** `FT1536_L_RHO_RUN_001`, od tej chwili zamrożony pakiet do odczytu.
- **Zapis:** niniejsza nowa nota w Dokumenty.
- **Wynik:** zgodność pakietu, ponowne sprawdzenie Lean i kontrola zapisanych
  tablic/regresji; rekomendacja następnego twierdzenia NTT/Montgomery.
- **Warunek końca:** przekazanie podsumowania. Następnego dowodu jeszcze
  nie uruchomiono.

## 1. Rozstrzygnięcie i piny

Astra zakończyła zadanie jako **`L_RHO_PROVED_FOR_PINNED_MODEL`**.
Przegląd poniżej jest zgodny z tym rozstrzygnięciem w deklarowanym zakresie.

```text
W = /home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001

W/REPORT.md
ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3

W/OUTPUTS.sha256
d5cabfdaf69f080bf31b9e1903bacc4a319f87cd38cb4b643ff5e98f1240f687

W/candidate/falcon-vrfy.c
3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42

W/CANDIDATE.sha256
2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a

W/candidate.patch
cb7833fce99eb68e671928b71ea28536acfc5f440babfc7b035196050a2c6060

W/formal/Rho.lean
daa68021e0f5bac53cf0384a5e10b0537eb6a8ca9d02f0f2970c6ff6eefc7fe8
```

Stan końcowy zachowuje:

```text
source_integrated = false
owner_accepted = false
candidate_L_V = OPEN_FOR_CANDIDATE
```

## 2. Własne kontrole po zakończeniu zadania

Wykonano odczytowo, bez uruchamiania finalizerów lub zmiany pakietu:

- zgodność hashy raportu i OUTPUTS z przekazaniem użytkownika;
- **610/610** wpisów OUTPUTS, dokładny zakres z OUTPUT_SCOPE, brak
  duplikatów, niedozwolonych ścieżek i symlinków w sprawdzanym zakresie;
- **34/34** oryginalnych wejść z INPUTS;
- **17/17** plików referencji względem historycznego manifestu S17 oraz
  **17/17** plików kandydata względem CANDIDATE.sha256;
- tylko `falcon-vrfy.c` różni się między referencją a kandydatem;
- diff jest dokładnie różnicą tych plików; sprawdzono też, że usunięcie
  opisanej wstawki obserwatora przywraca oba właściwe pliki bajtowo;
- powiązanie RESULT z raportem, certyfikatem, źródłami, diffem i manifestem;
- zamrożony prefiks COMMANDS: **87361 bajtów, 101 rekordów**,
  SHA-256 `69ca26296d2ee83f501ae9b98977d0779459e8b48ef8d070658060cd654f5a34`;
- prefiks jest zachowany w żywym dzienniku, mającym w chwili kontroli
  91242 bajty; wszystkie strumienie zapisane w prefiksie mają zgodne hashe;
- 64 ścieżki znaczeniowe wymienione w receipt replayu są zgodne z pinami;
  sprawdzono także **184** przypięte archiwalne strumienie replayu.

Po przejrzeniu finalnego źródła **ponownie uruchomiono Lean**:

```bash
/usr/bin/bwrap --die-with-parent --unshare-net --ro-bind / / \
  --proc /proc --dev /dev -- \
  /usr/bin/env -i PATH=/usr/bin:/bin \
  /home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean \
  /home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001/formal/Rho.lean
```

Wynik: **exit 0**, 12 deklaracji i 12 odpowiedzi `#print axioms`.
Zależności to standardowe `propext`, `Classical.choice`, `Quot.sound`.
Końcowy plik nie używa `sorry`, `admit`, lokalnego aksjomatu wniosku,
`unsafe` lub `native_decide`. Pozostają ostrzeżenia o przestarzałych aliasach
`if_pos`/`if_neg`, zgodnie z raportem.

Własny kontroler dokładnej arytmetyki całkowitej ponownie odczytał wszystkie
wiersze siedmiu tablic CSV. Potwierdził kompletność 65536 wejść każdej tablicy,
zero błędów obu buildów kandydata i no-op oraz deklarowane liczby błędów
czterech mutantów: 28670, 4098, 51202, 32767.

Niezależnie przeliczono też zapisane regresje: iloczyn wielomianów przez
splot całkowitoliczbowy i redukcję według `X^1536-X^768+1`, centrowanie,
pełne wektory wejścia NTT i argumentów normy oraz wartości Q. Zgodne są
**wszystkie 56 zapisanych wyników** (7 przypadków, dwie wersje, dwa buildy,
z obserwatorem i bez). Normy dodatnich przypadków to 7, 296 i 80.

To nowe sprawdzenie Lean i niezależna kontrola zapisanych danych. Nie
wykonywano tutaj kolejnej kompilacji C, nowej sesji Sage ani całego replayu;
te wykonania i ich receipts pochodzą z ukończonej pracy Astry.

## 3. Dlaczego lokalny kontrakt jest domknięty

Przypięty helper:

```c
static uint16_t
ft1536_normalize_s2(int16_t x)
{
    int32_t t;
    t = (int32_t)x + 36866;
    return (uint16_t)(t % 18433);
}
```

Dla każdego signed int16:

1. Rozszerzenie do int32 zachowuje x.
2. `t=x+2q` należy do `[4098,69633]`; dodawanie nie przepełnia int32.
3. Oba argumenty `%` są dodatnie. Reszta C99 jest tutaj zwykłą nieujemną
   resztą matematyczną i należy do `[0,18432]`.
4. Dodano wielokrotność q, więc wynik jest kongruentny z x.
5. Wynik mieści się w uint16, zatem końcowa konwersja jest dokładna.

Lean dowodzi uniwersalnego kontraktu tego modelu, zakresów pośrednich,
jednoznaczności reprezentanta, wersji wektorowej, postępu pętli i
antysymetrii center. Raport jawnie rozlicza translację małego fragmentu C
oraz przesłanki legalności buforów. Nie jest to formalizacja kompilatora
ani całej pamięci/verifiera C.

Zmiana dotyczy wyłącznie gałęzi `ternary == 1 && logn == 10` przed NTT.
Pętla zapisuje lokalne x, a norma nadal otrzymuje oryginalny signed s2.
Nie zmieniono parsera, Q, B, parametrów ani uczciwego COMP_STATIC.

Dokładne dziedziny starej mapy w obrębie int16:

- poprawna kongruencja: `[-18433,32767]` — 51201 wartości;
- canonical residue: `[-18433,18432]` — 36866 wartości;
- na całej drugiej dziedzinie stara i nowa mapa są zgodne.

Regresja istniejącego świadka daje w kandydacie rzeczywiste słowo 16866,
`s[0]=-20000`, normę 43058711057 oraz `verify=raw=0`. Referencja S17
zachowuje słowo 63969, normę 400000000 i akceptację. Jest to usunięcie tej
konkretnej rozbieżności w kandydacie, przy zachowaniu historycznego wyniku S17.

## 4. Następny obowiązek: kanoniczna ścieżka NTT/Montgomery

Rekomendowana kolejna praca konsumuje powyższy **konkretny kandydat i L_RHO**.
Robocza teza, dla `N=1536`, `q=18433`, `Phi=X^1536-X^768+1`:

Dla dowolnych kanonicznych wektorów `h,r,c in [0,q-1]^N`, przy legalnych
buforach i przypiętym modelu wykonania, rzeczywiste funkcje źródłowe:

```text
H := mq_poly_tomonty(mq_NTT(h))
P := mq_iNTT(mq_poly_montymul_ntt(mq_NTT(r), H))
d := mq_poly_sub(P, c)
```

mają zdefiniowane wykonanie, poprawne zakresy i zwracają odpowiednio:

```text
P = canonical_q(h*r mod Phi)
d = canonical_q(h*r-c mod Phi)
```

Zapis powyżej jest kompozycją matematyczną źródłowych operacji in-place,
nie deklaracją ich sygnatur C. Trzeba wykazać kolejność, reprezentację
Montgomery i wszystkie skalowania, zamiast przekazać raw Verify surowe h.

Zakres dowodu powinien objąć prymitywy modularne, stałe i tablice pierwiastków,
indeksowanie, etapy transformacji i legalność działań słowowych. L_RHO
zapewnia przesłankę `r=rho(s)` z canonical residues. Związek bajtowego loadera
h z takim wejściem oraz cały parser podpisu pozostają jawnie oddzielone.

Testy na wybranych wektorach nie zamykają tej tezy. Nawet sprawdzenie bazy
wymaga wcześniej dowodu odpowiedniej liniowości rzeczywistej funkcji słowowej
i spełnienia zakresów; sama algebra abstrakcyjnego NTT nie wystarcza.

Po tym interfejsie nadal trzeba rozliczyć pełne dekodowanie, centrowanie,
normę i ścisły próg, aby otrzymać pełne L_V dla kandydata. T2C3/T5 zachowują
dotychczasowe zakresy. L_RHO samo nie ustala liczbowego poziomu bezpieczeństwa.

## 5. Kontekst następnej sesji

Zakończone W i poprzednie RUN_001/ODBIOR_BLUE_001 są teraz wejściami tylko
do odczytu. Kolejny dowód powinien mieć osobny katalog i osobne zlecenie;
nadrzędny oraz lokalny AGENTS zadania L_RHO są już przypięte w INPUTS.

Awaryjny plan przekazania wykonania L_RHO do Daybreak nie był potrzebny do
dokończenia tego etapu. Podstawą kolejnej pracy jest ukończony pakiet Astry.

Praktyczne ustalenia środowiskowe do zachowania:

- zainstalowany frontend Sage działa jako `sage plik.py ...`; próba
  `sage -python` była nieobsługiwana i została poprawnie odnotowana;
- Sage 10.9 i jego Python 3.14.7 są teraz zapisane w osobnych polach;
- w wykonaniu Astry LSan z `detect_leaks=1` działał, więc nie należy
  automatycznie przenosić wcześniejszej blokady LSan/ptrace z sesji Blue;
- nieudany początkowy szkic Lean pozostaje historią, a wejściem nowego dowodu
  jest wyłącznie finalny, przypięty i poprawnie sprawdzony certyfikat.
