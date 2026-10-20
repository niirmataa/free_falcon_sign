# ZADANIE: R1 — CRT część 3 (suffix 512, restart po awarii providera)

Wznowienie po awarii okna (provider padł w trakcie okna 512).
Zamknięte wcześniej: fs/fd transport (joby 507/509) + mapy CRT
(joby 510/511) — batch 091. Następny wolny suffix joba: 512.
Wejście: piny 194 (ENTRY_PINS 99ac47a1…, 73564 ścieżek — weryfikacja
na starcie; 0 braków/0 zmian albo stop-and-report).

## Obowiązek 0 (restart)
W source3/formal/Source3 leżą 3 niezacommitowane szkice z przerwanego
okna: SelectedStepCrtWord194.lean, StepCopyKeepCell194.lean,
StepProductKeepCell194.lean. Rozpoznaj: albo wciągnij jako małe
commity z opisem pochodienia (kontynuacja), albo usuń z uzasadnieniem
w meldunku. Żadnego „leży i czeka".

## Zakres okna (wg KEYGEN_STEP_GS_194_NEXT_ROUTE.md)
Wykonanie obu zint_rebuild_CRT części 3 wg gotowej mapy z raportu:
1. transport słowa tabeli primes[0].p przez blok 21 (mkgm3/s0/s2/s3) —
   keepy fs/fd-nazwowe lub generyczny block-keep;
2. normZero-engine: ciała zint_norm_zero/zint_sub przy len=1
   z zależnymi od danych rozgałęzieniami porównań — eksport
   normWord p0 x = if x < p0>>>1 then x else if p0>>>1 < x
   then x-p0 else x (rozstrzygalne case-splity);
3. pętla 512 kroków normalizacji + montaż part 3.

## Zasady (bez zmian)
Wartości wyłącznie jako wykonane słowa; bez własności NTT, prawa
tabeli, dodatniości, Z>0/p_accept/p_K. Standardowe 3 aksjomaty;
logi 0/0; jeden proces Lean; retained failures z przyczynami
(25 w aktach — dopisuj). Małe commity lokalne BEZ push. Jeden etap
na okno; budżet domykany w bezpiecznym punkcie z meldunkiem.
Stop-and-report tylko przy realnej integralności/ścianie.
Żelazne zasady: run2/notes/B1_STAGED_ROADMAP.md.

## Na końcu
Meldunek: co zamknięte (moduły/joby), co otwarte, akta, następny
suffix, trzy zdania (co wykazane / najbliższy brak / czego nie
implikuje).
