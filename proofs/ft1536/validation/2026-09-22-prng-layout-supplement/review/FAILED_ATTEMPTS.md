# FAILED ATTEMPTS — nieudane próby i incydenty podczas odbioru

**REVIEW_ID:** `FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001`

Zasada: zachowuję **wszystkie** nieudane próby i incydenty; nie czyszczę ich
i nie kasuję artefaktów pośrednich. Żadna z poniższych sytuacji **nie obciąża
pakietu `RUN_003`** — to były moje błędy proceduralne/prefixowe lub incydenty
środowiskowe, naprawione bez wpływu na werdykt.

---

## A. Locale: fałszywy alarm `0/141` (DOBRZE vs „OK")

**Co:** pierwsze `sha256sum -c OUTPUTS.sha256` zwróciło `0/141` i komunikaty
`…: NIEPOWODZENIE`.
**Przyczyna:** licznik czytał `: OK` (ang.), a locale systemu zwraca **`DOBRZE`** —
pass/fail liczyłem po `OK`.
**Skutek:** brak — poprawiłem licznik na `DOBRZE`. Prawidłowo: **141/141 DOBRZE**
(uznane w `INTEGRITY.json`).
**Wniosek:** przy `sha256sum -c` w tym środowisku raportuję **DOBRZE**, nie „OK".

## B. Anchor sprawdzony z błędnego katalogu: `0/17` → `17/17`

**Co:** pierwsze sprawdzenie `SRC_SHA256` zwróciło `0/17`.
**Przyczyna:** uruchomione z katalogu nadrzędnego, a `source/` ma podkatalog
`source/.source` (recaster) — hasła odnoszą się do `source/` (PREFIX=`source/`).
**Skutek:** brak — powtórzone z katalogu `source/`: **17/17 DOBRZE**.
**Wniosek:** kontekst katalogowy ma znaczenie; użyłem pinu z dokumentu (`5697…052b`).

## C. Kotwica użyta jako manifest DEST: `131/136`

**Co:** próbowałem zweryfikować kopię `seed/pkg_003` pinem `e37b1e97…` → `131/136`.
**Przyczyna:** `e37b1e97…` to `OUTPUTS.sha256` **twardo przypięte do `source/`**,
a moja kopia DEST to `seed/pkg_003` — prefiksy się nie zgadzają (inny katalog).
**Skutek:** brak — DEST zweryfikowałem **własnym manifestem** z `rsync`-a:
**141/141 DOBRZE** + input closure **61/61 DOBRZE**. Anchor `e37b1e97…` użyty
zgodnie z przeznaczeniem: jako kontrola wejścia replaya.
**Wniosek:** pin manifestu nie jest uniwersalnym manifestem innej ścieżki.

## D. Mój checker `check_numbers.sage`: 2× FAIL (bug prefiksów `flat()`)

**Co:** pierwsze uruchomienia `sage check_numbers.sage` dały **2 FAIL** (m.in. `61320`).
**Przyczyna:** bug **po mojej stronie** — składnia listy prefiksów w `flat()`
generowała zła ścieżki (odwrotne prefiksowanie `w/`), więc liczniki czytały złe pliki.
**Skutek:** brak dla pakietu — poprawiłem składnię i ponownie: **13/13 PASS,
exit 0, stderr pusty**.
**Wniosek:** nieudane przebiegi własnych checkerów zachowuję jako dowód procesu
(log z FAIL w historii rozmo-wanej; końcowy log `check_numbers.log` = PASS).

## E. `raise SystemExit(0)` w Sage → exit 1 (stderr `0\n`)

**Co:** wariant kodu kończącego `raise SystemExit(0)` zwracał **exit 1** i `stderr = "0\n"`.
**Przyczyna:** **preparser Sage** — literał `0` jest mapowany na `Integer(0)`, więc
`SystemExit` dostawał `Integer(0)` i traktowany był jako niezerowy kod wyjścia.
**Skutek:** brak — zamiast `SystemExit` kończę kod przez **`assert`**
(zgodnie z zasadą Sage z `AGENTS.md`); przebieg końcowy: exit 0, stderr pusty.
**Wniosek:** w `.sage` nie używam `raise SystemExit(...)`; kończę przez `assert`.

## F. Restart sesji w trakcie replaya (bez drugiego workera)

**Co:** w trakcie trwania replaya (525 s) nastąpił **restart sesji OCP**; moja
sesja została przerwana, a proces replaya **przeżył** (wrapper `timeout …`).
**Reakcja:** **nie uruchamiałem drugiego workera** tego samego W (zakaz: jeden
wykonawca naraz na W) — odczekałem i odebrałem wynik istniejącego procesu:
**`FRESH_REPLAY_PASS`, 17/17, exit 0, elapsed 525.24 s**.
**Skutek:** brak dla pakietu; receipt i logi kompletne (`receipts/…REPLAY_RESULT.json`,
`checkers/REPLAY_CHECKS.json`, `logs/replay_stderr.log` pusty).
**Wniosek:** proces przeżył, wynik zweryfikowany trójstronnie; incydent odnotowany
dla pełnej historii (żeby restartu nie czytać jako „ponownego replaya").

---

## G. Fałszywe ogony hash w moich szkicach dokumentów — pełna rekalibracja pinów

**Co:** w pierwszej wersji szkiców `REVIEW.md` podałem pełne SHA-256, których
**ogonów nie było w plikach** (dopisywane z pamięci podsumowania sesji, np.
`f861be764812…`, `e37b1e973f58…`, `2984b2ae…` dla `RUN_001/OUTPUTS`); część z nich
miała zgodny tylko8-znakowy prefiks, reszta błędna. Wpadka ujawniona przy
konfrontacji z `AGENTS.md` W (`PROMPT_SHA256=f861be76aae6…`) i rutynowym
przeliczeniu pinów przed zamknięciem.
**Przyczyna:** zaufanie do skondensowanego podsumowania zamiast ponownego
`sha256sum` każdego pliku.
**Skutek:** **żaden dla pakietu ani werdyktu** — `INTEGRITY.json` (generowany z
rzeczywistych przebiegów) miał prawidłowe wartości; wykryte **przed** wygenerowaniem
`REVIEW_OUTPUTS.sha256`. Wszystkie piny w `REVIEW.md`/`DIFF_AUDIT.md`/
`CHECKLIST_F1_F5.md` przeliczone od nowa bezpośrednio z plików; szkice przepisane
w całości na zweryfikowanych danych; diff drzewa przeklasyfikowany programowo
z `checkers/diff_r2_r3_tree.txt` (92 =85 +7), a nie z pamięci.
**Wniosek:** ogon hash nigdy nie pochodzi z pamięci — tylko z `sha256sum`;
liczby diffu tylko z parsowania dowodów surowych.

---

## Podsumowanie

| # | Incydent | Status końcowy |
|---|---|---|
| A | locale `DOBRZE` vs `OK` | 141/141 DOBRZE |
| B | anchor z błędnego cwd | 17/17 DOBRZE |
| C | anchor jako manifest DEST | DEST 141/141 własnym manifestem |
| D | bug `flat()` w checkerze | `sage check_numbers.sage` 13/13 PASS |
| E | `SystemExit(Integer(0))` | kod przez `assert`, exit 0 |
| F | restart sesji w replayu | proces przeżył, 17/17 PASS, brak 2. workera |
| G | fałszywe ogony hash w szkicach | pełne przeliczenie pinów z plików; szkice przepisane |

**Zero z tych incydentów nie wpłynęło na pakiety zamrożone ani na werdykt.**
`git_used=false`, `push_authorized=false`, `owner_accepted=false`.
