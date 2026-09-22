# FAILED_ROUTES — zachowane ślepe próby i findings (RUN_003)

Suplement F1–F5 do odbioru RUN_002 (matematyka bez zmian). Historia RUN_001
i RUN_002 (w tym naprawy `^`/`int()`/wrapu i strażnicy rehearsal) dziedziczona
poniżej w pełnym brzmieniu.

## 8. RUN_002: Classical.choice w równoważności wrapu — NAPRAWIONE

Pierwsza wersja `wrap_iff_last_lt_first (↔)` ciągnęła `Classical.choice`
przez `omega` (asercja `#print axioms` to wykazała). Rozbito na dwie
implikacje (`wrap_of_last_lt_first`, `last_lt_first_of_wrap`) — aksjomaty
wróciły do [propext, Quot.sound]. Standard: kernel bez wyborów klasycznych.

## 1. C-style `^` jako XOR w `.sage` — ZNALEZIONE I NAPRAWIONE PRZED FREEZE

Pierwszy model zapisał operacje Word/XOR/shift w `model/*.sage` operatorem
`^` w stylu C. Pod `sage file.sage` preparser czyta `^` jako POTĘGĘ (dowód:
preflight `2^10 == 1024`). Skutki: (a) na danych all-zero `x^0 == 1` —
szybkie lecz CAŁKIEM ZŁE wartości (ciche); (b) na niezerowych licznikach
`st[14]**lo` z wykładnikiem do 2^32 — nieograniczony bigint hang (run
09:48 wisiał 25+ min bez artefaktów). Naprawa: `^^` (Sage xor) na 18 liniach
modelu + 8 liniach checkera; preflight `2^10` nietknięty; dopisana nota
semantyczna w docstringu modelu. Po naprawie: pełny KAT 5/5 w ~2 s.
Lekcja POLICY: zmiana semantyki `^` przy przenoszeniu do `.sage` MUSI być
rozliczona — tu wykryta empirycznie (bisekcja do 1 bloku) przed freeze.

## 2. Sage Integer nie jest JSON-serializable — NAPRAWIONE

`bytearray * Integer` (TypeError), literały `0/1/56/64` w słownikach do JSON,
`sum(1 for …)` (suma Sage Integer), `7*192`, `64*r` — owinięte w jawne
`int()` (ten sam wymóg co w odbiorze T03). Wykryte trzema kolejnymi failami
`run_sage.py`; każdy zachowany w COMMANDS.log / `logs/sage_*.stderr`.

## 3. Błędna rederywacja flag wrapu w checkerze — NAPRAWIONA

Checker liczył crossing jako `cc0+64s+63 >= 2^64` bez redukcji startu mod 2^64
(F4 dawał fałszywe refill1/2). Model miał rację; poprawiono rederywację na
`((cc0+64s) mod 2^64)+63 >= 2^64` (= `cc_last < cc_start`). Asercja padła na
słusznym rozjeździe — system zadziałał.

## 4. Nadmierne roszczenie o gałęzi FALCON_LE_U — ZAWĘŻONE

Model głosił równość bajtów z buildem `FALCON_LE_U=1` „na dowolnym hoście".
Fałsz dla big-endian (gałąź 1 to memcpy + natywny odczyt u64 — z projektu
LE-only). Zawężono do hostów LE (pinned model) + analityczna przenośność
gałęzi 0. Kontrola altbranch na hoście LE: różni się TYLKO bajtem tagu
`falcon_le_u` (stdout `72401466…` vs `b0dee8bc…`, diff = 1 bajt: `1` vs `0`).

## 5. Komentarz frng.c:198 vs instrukcje — FINDING (bez zmiany C)

„Counter XORed into the FIRST 8 bytes of the IV" — instrukcje XORują
state[14]/state[15] = offsets 40..47 (OSTATNIE 8 bajtów IV). Zachowane jako
finding w LAYOUT.md i modelu; źródła nietknięte.

## 6. Równoważności low-counter — nie awarie

`xor_to_add` ≡ na F0 (same zera); `counter32` ≡ na F0/F2 (licznik < 2^32).
Oczekiwane klasy równoważności (`KILLED_WITH_LOW_COUNTER_EQUIVALENCE`),
nie przeoczone wykrycia. No-op `bytewise_le`/`feedforward_order` czyste na 7/7.

## 8. Nieudane próby rehearsal (strażnicy zadziałali, zachowane)

- Literówka SHA kotwicy (78 znaków): `replay.py` odrzucił przed utworzeniem
  DEST (`ValueError: external SHA256 required`). Dowód, że kotwica jest
  walidowana przed DEST.
- Log konsoli przekierowany do `logs/` (członek manifestu): replay padł
  `member set vs manifest` PRZED jakimkolwiek zapisem. Po usunięciu pliku
  zbiór W == kotwicy (sprawdzone niezależnie) i rehearsal ponowiono z logiem
  w `tmp/` (poza manifestem). Dowód, że manifest jest weryfikowany w całości.

## 7. Brakujące pokrycie (jawnie poza zakresem)

F5 wrap MIĘDZY refillami (nie wewnątrz stage) — flaga per-stage poprawnie `[]`;
typy spoza {0,1,2,3,−1,99,2^20} objęte strukturą switcha (5 próbek wiążących);
BE-hardware, OS entropy, KeyGen, pełny Sign — nigdy nie uruchamiane.
