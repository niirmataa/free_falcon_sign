# FT1536 — kontynuacja GPT-ASTRA: L_NTT_GLOBAL

Aktualne zlecenie:

`/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_L_NTT_GLOBAL_2026-09-18.md`.

## Bieżący etap

Kontynuuj w tej samej rozmowie Astry, zachowując użyteczny kontekst L_NTT.
Nowy i jedyny katalog zapisu:

`/home/footfalcon/Dokumenty/FT1536_L_NTT_GLOBAL_RUN_001`.

Przed pierwszym zapisem narzędzi potwierdź ich cwd i rzeczywisty sandbox
dla tego katalogu. Jeśli klient nie pozwala przenieść granicy zapisu,
zapisz konkretną przeszkodę techniczną i poproś o uruchomienie w poprawnym
katalogu; nie zapisuj w zamrożonym poprzednim W.

Przeczytaj nadrzędny `/home/footfalcon/Dokumenty/AGENTS.md`. Jego ogólne
zasady pozostają w mocy. Nowe zlecenie i ten lokalny plik aktualizują etap,
wykonawcę, katalog zapisu i badaną bazę. Stare wskazania odbioru Blue,
wykonywania L_RHO lub pierwszego L_NTT są historią.

## Wejścia

- `FT1536_L_RHO_RUN_001`: zamknięte lokalne L_RHO.
- `FT1536_L_NTT_RUN_001`: zamrożone **PARTIAL_PROOF**, z ukończonymi
  kontraktami słów, certyfikatami tablic i lokalnych bloków.
- Badane źródło nadal ma SHA-256
  `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
- Wszystkie ukończone pakiety, ich instrukcje, H/S17 i wcześniejsze
  checkouty pozostają tylko do odczytu.

Pracuj na niezmienionej kopii źródeł w nowym `source/`. Nie poprawiaj C
ani nie regeneruj manifestów poprzednich wykonań. Własne formalne modele,
harnessy i jawne kopie obserwacyjne wolno tworzyć w bieżącym W.

## Przedmiot kontynuacji

Domknij `FORWARD_GLOBAL`, `INVERSE_GLOBAL` i wynikający z nich `PRODUCT`
dla konkretnych modeli pętli in-place. Dostarcz instancje przesłanek
`forward_product` i `inverse_forward` istniejącej kompozycji.

Nie zastępuj modelu pętli definicją idealnej ewaluacji. Udowodnij ich
zgodność, fizyczną kolejność współczynników i potrzebne zakresy.
Jawnie dopasuj `Fin 1536 -> Int` do canonical wejść C.

Zachowaj N=1536, q=18433, Phi, Q, B, full ternary secret, COMP_STATIC
i dokładną tezę poprzedniego L_NTT. Pełne L_V pozostaje osobnym etapem.

## Rygor i wykonanie

- Konsumuj istniejące certyfikaty z ich pinami i przesłankami. Nie odtwarzaj
  szerokiej kampanii przypadków w miejsce brakującego globalnego dowodu.
- Pokaż pełne typy końcowych twierdzeń oraz `#print axioms`.
- Nowe i edytowane pliki Lean mają przechodzić bez własnych ostrzeżeń.
  Stosuj regułę `FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md`.
- Historyczne kopie wejść zachowuj bajtowo. Ewentualne dostosowanie aliasów
  w roboczych kopiach formalnych zależności wymaga diffu, nowych hashy
  i ponownego sprawdzenia, bez zmiany tez.
- Zapis narzędzi, cache, HOME, TMPDIR i DOT_SAGE ogranicz do bieżącego W.
- Sage uruchamiaj jako `sage plik.py ...`. Zapisuj wersje, komendy,
  ograniczenia zasobów, kody wyjścia oraz pełne stdout/stderr.
- Bez instalacji, nowych kluczy, sekretów, sieci badawczej, innych agentów,
  commitów, podpisów i publikacji.
- Każdy wynik częściowy ma wskazywać dokładną pozostałą lukę. Dodatni
  werdykt wymaga zamknięcia globalnych przesłanek dla badanego źródła.

Ten plik jest instrukcją startową, nie wynikiem wykonania L_NTT_GLOBAL.
