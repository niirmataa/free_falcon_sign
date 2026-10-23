# Projekt progowego FT1536 — dwa warianty

**Status: PROJEKT NA PAPIERZE. Żaden wariant nie jest gotowy ani bezpieczny produkcyjnie.**
Odniesienia kierunkowe: eprint 2026/1300 (Thresholdizing Standardized FALCON, CCS 2026),
ATMACA (Mitaka/ANTRAG sampler). Techniki się przenoszą; **protokół FT1536 (F04/F05) nie jest
standardowym Falconem** — nie kopiujemy, porównujemy.

Nasza przewaga (do wykorzystania w obu wariantach): formalny opis `G(seed*)` (tor R1)
+ silnik całkowity fixed-point (MPC-friendly).

---

## Wspólna rama

| Element | Wartość |
|---|---|
| Próg | k-z-n, k≥2, n>k (próg jako taki istnieje dopiero przy n>k) |
| Uczestnicy | strony progu; żadna nie widzi pełnego klucza po dealerze/DKG |
| Model zagrożeń (docelowo) | złośliwi do t-1; **w kiełku wyłącznie semi-honest + test fałszywego udziału** |
| Komunikacja (docelowo) | GhostDB → mailboxy; w kiełku lokalny harness |
| Wymagane z kierunku 2026/1300 | MPC Klein-sampler, precision ~73 bit, kontrola rejection samplingu |

**Uwaga nazewnicza 2-z-2:** k=2, n=2 to quorum „obaj albo nikt" — nie próg w sensie
ktoś-może-paść. Kiełek używa 2-z-2 jako najmniejszego dema arytmetyki progowej.
Prawdziwy próg (tolerancja padającego) wymaga n>k, np. 2-z-3 lub 3-z-5.

---

## Wariant A — udział w pułapce (f,g,F,G) + MPC-sampler

### Zamek
Każda strona trzyma **udział pułapki** τ_i = (f_i, g_i, F_i, G_i) (lub reprezentację
wystarczającą do zadań samplera). Żadna strona nie zna τ.

### Krok wyprowadzania podpisu
1. Strony uzgadniają wiadomość μ i losowość.
2. **MPC Klein-sampler** (wg technik 2026/1300 / ATMACA): wspólne losowanie wektora
   krótkiego v z rozkładu bliskiego dyskretnej Gaussiance, na udziałach.
3. MPC oblicza podpis / nonce z v i udziałów pułapki (operacje na pierścieniu).
4. Otwarcie tylko wyniku (podpisu), nie τ.

### Próg k-z-n
Odtworzenie wymaga k udziałów pułapki do kroków samplera; poniżej k strony nie
kończą protokołu.

### Rundy (szacunek, nie pomiar)
- Sampler MPC: dominuje. 2026/1300 raportuje dziesiątki–setki rund zależnie
  od precyzji i optymalizacji; ATMACA celuje <180 rund dla Mitaka/ANTRAG.
- Do tego: setup udziałów, uzgodnienie losowości, otwarcie wyniku.
- **Nie mierzyliśmy** — to szacunek z literatury, nie nasz benchmark.

### Koszt
- Komunikacja: wysoka (roundy × strony × precyzja 73-bit).
- Lokalnie: operacje fixed-point na udziałach (u nas przyjazne — silnik całkowity).
- Preprocessing: trójki / materiał losowy — dealerski w kiełku, docelowo PRSS pairwise.

### Czego brakuje
- MPC Klein-sampler dla F04/F05 (nie standardowego Falcona) — **nie istnieje**.
- Kontrola rejection samplingu w MPC (krytyczna: bias = wyciek).
- Reprezentacja udziału pułapki zgodna z `G(seed*)` i fixed-point.
- Złośliwe bezpieczeństwo (SPDZ-MAC na całym torze, nie surowy Beaver).
- Reshare, refresh, odporność na dropout.

### Bezpieczeństwo (z ostrożnością)
- Wg 2026/1300: threshold Falcon (standardowy) osiąga bezpieczeństwo w modelu
  UC-mpc dla uczciwej większości przy założeniach o samplerze — **u nas nie wykazane**.
- ATMACA: nowoczesny sampler (Mitaka/ANTRAG) redukuje rundy; nie przenosi się
  wprost na F04/F05.
- **Nie deklarujemy** bezpieczeństwa progu FT1536. Brak dowodu, brak audytu.

---

## Wariant B — udział w seedzie + MPC-wyprowadzanie `G(seed*)`

### Zamek
Każda strona trzyma **udział seeda** s_i (Shamir lub inny). Pełny seed* istnieje
tylko w dealerze w momencie podziału (lub nigdy, przy DKG). Klucz prywatny
**nigdy nie istnieje w całości** — nie ma „momentu", w którym leży w RAM jednego hosta.

### Krok wyprowadzania podpisu
1. Strony z udziałów s_i obliczają **współdzielnie** materiał klucza przez
   `G(seed*)` zrealizowane jako obwód MPC (fixed-point / całkowity).
2. Sampler (Klein lub ekwiwalent) również na udziałach — klucz i nonce
   powstają w formie udziałów.
3. Otwarcie tylko podpisu.

### Próg k-z-n
k udziałów seeda wystarcza do uruchomienia obwodu `G` i samplera.

### Rundy (szacunek)
- Wyprowadzanie bajtu/worda klucza: runda na mnożenie MPC (Beaver) w obwodzie `G`.
- Sampler: jak w wariancie A (dominuje).
- **Przewaga:** `G` jest całkowite/fixed-point — brak kosztownej arytmetyki
  zmiennoprzecinkowej w MPC.

### Koszt
- Komunikacja: zwykle **niższa** niż A, bo brak udziału pułapki (f,g,F,G)
  i brak MPC-mnożeń na dużych wielomianach pułapki w każdej próbie samplera.
- Preprocessing: nadal potrzebny (trójki / PRSS).
- Pamięć: mniejsza (seed vs pełna pułapka).

### Czego brakuje
- Formalny obwód `G(seed*)` w MPC (tor R1 ma opis formalny — **nie jest skompilowany do MPC**).
- MPC-sampler z kontrolą rejection (jak w A).
- DKG dla seeda (w kiełku: trusted dealer — model testowy!).
- Złośliwe bezpieczeństwo, reshare, dropout.

### Bezpieczeństwo (z ostrożnością)
- Własność „klucz nie istnieje w całości" jest **konstrukcyjna** — wynika z modelu
  udziałów, nie z dowodu redukcji.
- Nie wynika z tego odporność na złośliwych, wyciek z samplera ani bezpieczeństwo
  UC. To wymaga osobnych dowodów i/lub odniesień.
- 2026/1300 dotyczy progu standardowego Falcona; **nasze `G(seed*)` i F04/F05
  różnią się** — techniki (MPC sampler, precision) tak, protokół nie.

---

## Porównanie

| | A: udział w pułapce | B: udział w seedzie |
|---|---|---|
| Moment istnienia klucza | pułapka w udziałach (zwykle bez scalania) | **klucz nigdy w całości** |
| Rozmiar udziału | duży (f,g,F,G) | mały (seed) |
| Koszt MPC | wyższy (pułapka w samplerze) | niższy (obwód `G` całkowity) |
| Zgodność z 2026/1300 | bliższy (sampler na pułapce) | dalszy (własny `G`) |
| Nasza przewaga fixed-point | częściowo | **pełniej** |
| Dojrzałość papieru | więcej literatury (Falcon) | mniej, bardziej „nasze" |
| Ryzyko | rejection bias, precision | poprawność obwodu `G` w MPC |

**Rekomendacja toru:** B jako kierunek unikalny (eliminacja „momentu"), A jako
kontrola porównawcza. Kiełek tego okna = **minimalny krok B** (patrz `spike/`).

---

## Kiełek (wariant B, minimalny krok)

**To NIE jest threshold signing.** To jeden krok wyprowadzania bajtu klucza
z udziałów seeda przez arytmetykę progową.

- 2 strony, Shamir GF(256), **k=2, n=2** („obaj albo nikt" — patrz wyżej)
- Dealer (zaufany, **model testowy**) dzieli syntetyczny 32-bajtowy seed
- Strony: 16 × MPC-mul (Beaver) + MPC-add → `K[0] = H_fold(seed)`
- `H_fold`: `acc = ⊕_{i=0..15} (seed[2i] ⊗ seed[2i+1])` w GF(256)
- Wynik: strony odtwarzają `K[0]` z udziałów; seed i `K` nie leżą w całości po dealerze

### Testy kiełka
1. **Happy path** — odtworzenie `K[0]` z udziałów
2. **Wzorzec lokalny** — `K[0] == H_fold(seed)` policzone jawnie (wierność)
3. **Brak quorum / zły próg** — 1 udział nie wystarcza
4. **Sfałszowany udział** — strona 2 fałszuje `share`; wynik **cichy zły**
   (brak VSS/MAC w kiełku) → nota do `RESEARCH.md` (po to jest Pedersen/DKG)

### Zeroization (naprawa H-31 w kopii, nie upstream)
Typy sekretów: brak `derive(Clone, Copy)`, `Drop` zeroizuje. Patrz `INVENTORY.md` §G.

### Czego kiełek NIE pokazuje
- progu n>k (2-z-2 = obaj albo nikt)
- złośliwego bezpieczeństwa (SPDZ-MAC / VSS)
- Klein-samplera, rejection samplingu, `G(seed*)` w pełni
- DKG, transportu, GhostDB/mailboxów
- gotowości produktu

---

## Spike 002 — 2-z-3 + Feldman VSS (kontynuacja)

**Cel:** prawdziwy próg (n>k, tolerancja padającego) + **detekcja fałszywego
udziału** (odpowiedź na wynik spike 001: bez VSS cichy zły wynik).

### Zamek
- Shamir k=2, n=3 na bajtach seeda; xs=[1,2,3]
- **Kontrola spójności n=k+1** (zamiast Feldman na GF(256)* — patrz niżej):
  3 punkty przy k=2 muszą leżeć na wielomianie stopnia <2
- Fałszywy udział → `InconsistentShare` → derive blokowany (nie cichy zły)
- Dodatkowo: commit-and-open (`CoeffCommit`) do współczynników — audyt po
  otwarciu; **nie** zobowiązanie DL

### Próg 2-z-3 (nazwa wprost)
Dowolne 2 z 3 stron odtwarzają i wyprowadzają `K[0]`. Jedna strona może
paść/bezczynnie — protokół kończy się. Jedna strona **nie** odtwarza sekretu.
To jest próg w sensie tolerancji padającego (w odróżnieniu od 2-z-2).

### Zakres kontroli spójności (uczciwie — korekta do implementacji)
Klasyczny Feldman VSS na GF(256)* nie ukrywa (trywialny DL) i **nie został
użyty**. Zamiast tego:
- **Daje:** detekcja jednego przekłamania udziału przy n>k; fail-closed derive.
- **NIE daje:** ukrycia przed dealerem, malicious-secure MPC, odporności na
  wielu złośliwych, zastąpienia Pedersen/Feldman na grupie DL-trudnej,
  SPDZ-MAC na otwarciach. Przy n=k detekcja nie działa.

### Testy (wymagane — wynik w `spike/SPIKE002_NOTES.md`)
1. happy 2-z-3 (wszystkie pary) — PASS
2. wzorzec lokalny `H_fold` — PASS
3. padnięcie jednej strony — nadal działa — PASS
4. 1-z-3 nie wystarczy — PASS
5. **fałszywy udział → wykryty** — PASS
6. **derive blokowany** przy fałszywym udziale — PASS
7. guardy H-28 — PASS

### Czego nadal NIE pokazuje
- Klein-samplera, rejection samplingu, `G(seed*)` w pełni
- SPDZ-MAC na otwarciach / złośliwie bezpiecznego mnożenia
- DKG (dealerski model testowy!), transportu, GhostDB
- gotowości progu FT1536
