# FT1536 L_V-STATIC RUN_001 — niezależny odbiór Daybreak

## Rozstrzygnięcie

**Werdykt odbioru: `CONFIRMED_COUNTEREXAMPLE_REQUIRED_DOMAIN`.**

Niezależne kontrole potwierdzają zadeklarowany kontrprzykład do lematu
L_V-STATIC dla ustalonego ekstraktora

```text
Ext0(h,c,b) = (center_q(c-h*s(b)), s(b))
```

przy `N=1536`, `q=18433`, `Phi=X^1536-X^768+1`, `B=2093922385` i
offsetowej formie A2 `Q`. Dla przypiętego publicznego h, kanonicznego c i
istniejącego payloadu STATIC źródłowy Verify akceptuje, lecz
`Q(Ext0)=43058711057 >= B`. Nie znaleziono rozbieżności z wynikiem RUN_001.
To nie jest owner acceptance ani zmiana statusu projektu.

## Karta sprawdzanej tezy

- Obiekty: h z successful-output support S17 KeyGen, kanoniczne
  `c in [0,18432]^1536` i skończony payload akceptowany przez Verify.
- Wniosek obalany przez jeden świadek: `V_S17(h,c,b)=1` implikuje
  `Q(Ext0(h,c,b)) < B`.
- `s(b)` oznacza faktyczny wektor `int16_t` dekodera. Uczciwy profil pozostaje
  `FALCON_COMP_STATIC`; zakres lematu i harnessu nie został zmieniony.
- Współczynniki są indeksowane od 0, `center_q` ma zakres `[-9216,9216]`, a
  `Q0(a)=sum_{i=0}^{767}(a_i^2+a_i*a_{i+768}+a_{i+768}^2)`.

## Integralność i proweniencja

Piny wejścia są zgodne:

```text
REPORT.md       c19cda58e928d585bed8c64745ea165b4dce0fbabee2e51edb40d6392a825cfd
OUTPUTS.sha256  0223beb04591bd45908c1b167f4bda89b8666ef40901bde7d502f10088c23f87
```

Własny checker manifestu potwierdził 170/170 wpisów: brak duplikatów,
ścieżek absolutnych, `..`, symlinków i pozycji poza zakresem OUTPUT_SCOPE;
wszystkie hashe są zgodne. Zamrożony prefiks COMMANDS ma 36428 bajtów i
pozostaje dokładnym prefiksem żywego dziennika R.

Obiekt Git `d641ab1037c2fa1dd4a22c258854d79d67b9b46b` istnieje, a plik
`evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256` pobrany
z tego obiektu ma SHA-256
`03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589`.
Wszystkie 17 źródeł są zgodne z manifestem zarówno w historycznym `H/build`,
jak i w kopii odbiorczej. Aktualny HEAD H to nowszy `01408683...` i nie był
użyty jako pin. Wszystkie 26 publicznych oryginalnych wejść z `INPUTS.sha256`
zachowuje deklarowane hashe.

Publiczny klucz ma SHA-256 `57c49f...afc6f`, a tekstowe h
`ce1aef...d17f2`. Własny dekoder 15-bitowego publicznego klucza uzyskał
dokładnie 1536 współczynników tekstowego h. `KEY_COMMITMENT.json`, publiczny
manifest KeyGen, `KEYGEN_ATTEMPT.json` i historyczny raport są zgodne z
pinami. Jest to potwierdzenie powiązania z istniejącym publicznym zapisem
jednego udanego KeyGen, nie nowy prywatny replay. Nie odczytano klucza
prywatnego, seedu ani prywatnych współczynników i nie wygenerowano klucza.

## Niezależne dekodowanie i dokładny rachunek

Checker `checkers/independent_check.py` nie importuje modelu, checkera ani
wektorów obliczeniowych Astry. Dekoduje PK i STATIC z bajtów, wykonuje własny
całkowitoliczbowy splot oraz redukcję w
`(Z/18433Z)[X]/(X^1536-X^768+1)`, a następnie liczy Q w liczbach całkowitych.
Ustandaryzowany bounded-run zakończył się w 0.117 s, exit 0, przy limitach:
30 s wall, 20 s CPU, 1 GiB pamięci, 1 rdzeń i 1 wątek. Manifest v2 przeszedł
oficjalny walidator computation-audit.

Wyniki:

| Kontrola | Wynik |
|---|---:|
| długość payloadu / danych po nagłówku | 1931 / 1930 bajtów |
| końcowy padding | 2 bity zerowe |
| `s[0]`, pozostałe s | -20000, same zera |
| źródłowe słowo `uint16_t` przed NTT | 63969 |
| `63969 mod q` / `(-20000) mod q` | 8670 / 16866 |
| specyfikacja c | `c_i=(8670*h_i) mod q` — zgodna |
| `Q0(z1)` | 42658711057 |
| `Q0(s)` | 400000000 |
| `Q(Ext0)` | 43058711057 |
| `Q(Ext0)-B` | 40964788672 |
| kongruencja `z1+h*s=c` | zgodna dla 1536 współczynników |
| pierwszy komponent ścieżki źródłowej | 1536 zer |
| źródłowa norma pary | 400000000, zatem `< B` |

Wszystkie h, c, s, z1, pierwszy komponent maszyny i wartości norm zostały
następnie porównane z utrwalonym `witness.json`; wszystkie są identyczne.
Drugi, ortogonalny checker użył dokładnych wielomianów Sage 10.9 nad
`GF(18433)` i niezależnego dekodera bitów; uzyskał te same normy, c i
kongruencję.

## Decyzja źródłowego C i wierność harnessu

Przejrzano niezmieniony `scripts/harness.c` (SHA-256
`d9addf...bd79`) oraz odpowiednie fragmenty `falcon-vrfy.c` i
`falcon-enc.c`. Harness:

- włącza hash-sprawdzony `falcon-vrfy.c`, podmieniając wyłącznie
  `falcon_hash_to_point` na kopiowanie jawnego c;
- ładuje PK przez rzeczywiste `falcon_vrfy_set_public_key`, więc h przechodzi
  źródłowe NTT i reprezentację Montgomery;
- wywołuje pełny `falcon_vrfy_verify`, zachowując kontrole nagłówka, stopnia,
  pierścienia, reserved bit, pełne dekodowanie i zużycie długości;
- przekazuje faktyczny zdekodowany `int16_t s2` do niezmienionego raw Verify i
  `falcon_is_short` ze ścisłym porównaniem `< B`.

Na hash-sprawdzonej kopii zbudowano GCC 14.2.0/C99 dwa standalone:
normalny i ASan/UBSan. Oba (dla sanitizera po wyłączeniu tylko LSana) zwróciły:

```json
{"loader":1,"payload_bytes":1931,"decoded_bytes":1930,"point_calls":1,"verify":1,"raw":1,"machine_norm":400000000,"s0":-20000,"preNTT0":63969,"cast65535":-1,"cast32768":-32768}
```

Kompilacja powtórzyła ostrzeżenie `-Wmisleading-indentation` w pomocniczym
harnessie, bez zmiany kodu i bez wpływu na rozpatrywaną instrukcję. Pierwsza
próba sanitizera zakończyła się technicznym exit 1, ponieważ LeakSanitizer nie
działa pod `ptrace` sandboxa. Powtórzenie z `ASAN_OPTIONS=detect_leaks=0`
pozostawiło AddressSanitizer i UBSan aktywne, przeszło z exit 0 i pustym
stderr. Nie jest to uniwersalny dowód braku UB ani kontrola wycieków.

## Certyfikat Lean — claim card i macierz obowiązków

Znormalizowana teza certyfikatu: dla 768 konkretnych par offset-768 zapisanych
w 12 blokach energia pierwszego komponentu wynosi 42658711057; po dodaniu
konkretnego drugiego komponentu energia wynosi 43058711057, więc nie jest
mniejsza od B; konkretna para maszynowa ma energię 400000000 i jest mniejsza
od B. **Werdykt proof-audit dla tej tezy: proved as written.**

| Obowiązek | Status |
|---|---|
| 12 bloków po 64 pary, razem 768 | passed |
| każda para identyczna z `(z1[i],z1[i+768])` | passed |
| definicja energii zgodna z Q0 | passed |
| sumy bloków i suma 42658711057 | passed |
| drugi komponent, pełna norma i nierówności | passed |
| słowo 63969 i dwie reszty modulo q | passed |
| brak `sorry`, `admit`, lokalnego `axiom`, `unsafe`, `native_decide` | passed |
| 26 deklaracji objętych 26 `#print axioms` | passed |
| formalizacja całej semantyki C i support KeyGen | not addressed / poza zakresem |

Lean 4.34.0/Std zakończył się exit 0. Twierdzenia blokowe są bez aksjomatów;
`energy_append` i zależne sumy wskazują standardowe `propext`. Certyfikat jest
formalnym dowodem arytmetyki jednego świadka, a nie formalizacją C, kompilatora,
NTT/Montgomery, loadera PK, KeyGen support lub EUF-CMA.

## Zależności i interpretacja

Łańcuch rozstrzygający jest następujący:

1. hash-piny wiążą S17, publiczne h/PK, payload i c;
2. historyczny publiczny receipt KeyGen jest przesłanką membership h w
   successful-output support;
3. własny dekoder i dwa dokładne rachunki wiążą payload z s oraz wyliczają
   Ext0, kongruencję i Q;
4. świeżo zbudowany oryginalny Verify potwierdza akceptację i normę ścieżki C;
5. Lean dowodzi konkretnego rachunku normy i nierówności.

Punkty 3–5 wzajemnie się uzupełniają, ale nie są trzema formalizacjami tej
samej pełnej tezy. C jest obserwacją konkretnego modelu wykonania, Python/Sage
są dokładnym rachunkiem matematycznym, a Lean certyfikuje arytmetykę wektorów.
Nowy replay nie jest historycznym replayem Sage 9.5/Lean 4.30.0 ani prywatnym
replayem KeyGen.

## Rozbieżności, ograniczenia i niewykonane kontrole

Nie znaleziono rozbieżności zmieniającej wynik. Odnotowano:

- bieżący HEAD H różni się od historycznego pinu; użyto istniejącego obiektu
  commit i hash-sprawdzonych plików S17, więc nie zmienia to kontrolowanego kodu;
- bezpośredni import Sage poza wrapperem próbował pisać do `~/.sage` i został
  zablokowany przez EROFS; właściwy wrapper z cache w W działał poprawnie;
- LeakSanitizer jest niewykonalny pod ptrace tej sesji; ASan/UBSan bez LSana
  przeszedł;
- nie wykonano nowego/private KeyGen ani nie odczytano sekretów — zgodnie z
  zakresem; membership support pozostaje oparty na przypiętym publicznym
  historycznym zapisie;
- nie uruchamiano całego replay_fresh Astry jako substytutu niezależności;
  wykonano własny build C, własne checkery i własny Lean replay w W.

Kontrprzykład obala wymaganą krótkość wyłącznie dla ustalonego Ext0 i pełnej
dziedziny rzeczywistego Verify. Nie dowodzi nieistnienia innego ekstraktora,
nie znajduje preimage HashToPoint, nie jest efektywnym fałszerstwem EUF-CMA i
nie obala ani nie otwiera T2C3/T5. Kongruencja Ext0 pozostaje prawdziwa.

## Artefakty

Najważniejsze niezależne wyniki są w `computations/independent-001/`,
`replay/` i `formal/`. Wszystkie komendy, kody wyjścia, środowisko oraz surowe
stdout/stderr znajdują się w `COMMANDS.log` i `logs/`. Dokładny zakres
końcowego manifestu opisuje `OUTPUT_SCOPE.md`; cache, pliki tymczasowe i
binaria są jawnie wyłączone.
