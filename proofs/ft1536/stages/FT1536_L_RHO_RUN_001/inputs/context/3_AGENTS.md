# FT1536 — aktywne zadanie GPT-ASTRA: L_RHO

## Aktualny etap i pierwszeństwo instrukcji

Aktualne polecenie użytkownika jest zapisane w:

`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_L_RHO_2026-09-18.md`.

Przeczytaj nadrzędny `/home/footfalcon/Dokumenty/AGENTS.md`. Jego ogólne zasady
dotyczące projektu, danych, dowodów i sandboxa nadal obowiązują. Niniejszy
lokalny plik i nowe zlecenie aktualizują etap, wykonawcę, katalog zapisu oraz
zakres dopuszczalnej pracy na kandydacie:

- Odbiór Blue jest ukończony: `CONFIRMED_COUNTEREXAMPLE_REQUIRED_DOMAIN`.
- Wykonawcą nowego zadania jest GPT-ASTRA.
- Nowy i jedyny katalog zapisu zadania:
  `/home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001`.
- Dozwolone są własne checkery, formalny model i minimalny kandydat
  normalizacji w lokalnej kopii źródeł zgodnie ze zleceniem L_RHO.
- Referencja i kandydat mają być rozdzielone i osobno przypięte hashami.

Nie stosuj historycznej wartości W wskazującej katalog odbioru Blue.
Stare prompty i nota przekazania są kontekstem wykonanych prac, nie
poleceniem ich ponownego uruchomienia. Nowe zlecenie L_RHO jest aktualną
decyzją o rozpoczęciu następnego etapu.

## Zamrożone wejścia

Tylko do odczytu:

- `/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001`;
- `/home/footfalcon/Dokumenty/FT1536_LV_STATIC_ODBIOR_BLUE_001`;
- historyczne H/S17, USB i wcześniejsze raporty;
- nadrzędny AGENTS.md i plik nowego zlecenia.

Nadrzędny AGENTS.md jest przypiętym wejściem odbioru Blue. Zachowaj go.
Przyszły wynik zapisuj tutaj, bez uruchamiania starych finalizerów/runnerów
w ich oryginalnych katalogach.

## Praca i zakres wniosku

- Zachowaj FT1536 full ternary secret, uczciwe COMP_STATIC, N, q, Phi, Q i B.
- W Verify pozostają oba tryby dekodowania. Nie ograniczaj STATIC do
  centered współczynników ani do wyników uczciwego Sign.
- Przed NTT wolno zmienić reprezentację modularną s, natomiast rzeczywisty
  zdekodowany s pozostaje argumentem normy.
- Kontrprzykład do Ext0 w S17 pozostaje wynikiem zamkniętym. Kandydat jest
  nowym, lokalnym obiektem z własnym hashem; nie jest wdrożeniem ani nowym S17.
- Wynik zadania obejmuje L_RHO, zgodność modelu z lokalnym fragmentem C
  oraz jawnie ograniczone regresje. Pełne L_V i bezpieczeństwo EUF-CMA
  pozostają odrębnymi obowiązkami.
- Używaj istniejących publicznych h, PK, c i payloadu. Bez nowego KeyGen,
  sekretów, instalacji, sieci badawczej, commitów, podpisów i publikacji.
- Jedna sesja wykonawcza; nie uruchamiaj równoległych agentów.
- Przed obliczeniami sprawdź sandbox ograniczający zapis narzędzi do tego
  katalogu. Cache i pliki tymczasowe również kieruj tutaj. AGENTS.md sam
  nie ustanawia ograniczeń systemowych.
- Potwierdź wersje narzędzi. Sage uruchamiaj przez dostępny wrapper `sage`;
  osobno zapisz rzeczywistą wersję Sage i wersję jego Pythona.
- Raportuj wykonane kontrole, błędy i brakujące dowody wprost. Nie utożsamiaj
  powodzenia kompilacji, enumeracji C lub opinii modelu z dowodem całego C.

Ten AGENTS.md jest przygotowaną instrukcją startową. W chwili przygotowania
katalog nie zawiera wyniku L_RHO.
