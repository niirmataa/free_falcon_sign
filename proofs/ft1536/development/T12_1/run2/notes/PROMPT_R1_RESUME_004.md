# ZADANIE: R1 — s3 ciąg dalszy: finalPass → part 2 → korpus 192

Wznowienie od checkpointu 192 (pętla stopnia-1 ZAMKNIĘTA: moduły
NttInverseFinalBody192/Exec192/Loop192, joby 412/415/420).
Następny wolny suffix joba: 421. Wejście: żywe rejestry
(KEYGEN_R1_TAIL_TODO, KEYGEN_STEP_INVERSE_192_REPORT/_FAILURES,
WORK_STATE) + piny 192 → ENTRY_PINS kolejnego poziomu.

## Kolejność (meldunek po etapie)

1. Part 3 — kompozycja finalPass (job 421): wAssign igm[0] +
   init u/r1/r2 + pętla + skip. UWAGA: wymaga reguły Eval dla
   literałów u64 (historycznie 2-4 iteracje warsztatowe —
   zachowuj porażki z przyczynami).
2. Part 2 — przejścia pośrednie: 8 odwróconych rund, 2048 motyli,
   pętle zagnieżdżone u1/v — NAJWIĘKSZY pozostały kawałek;
   dziel na moduły (runda/pas/helper), reuse motyli i helperów
   o zgodnych typach; jedna instancja na raz.
3. Kompozycja korpusu (NttInverseWhole192) + instancja
   SelectedStepInverse192 (s3 na wyjściu produktu 191) +
   audyt + seal 192.
4. Potem wg mapy: g s4–s7, !out_ntt s8 (wariant logn 8), ogon
   pętli zewnętrznej, CRT/reszta, poziomy/root/certyfikat/codec
   → świadek KeygenProbability134 (G(seed*)).

## Zasady (bez zmian)

Wszystko wartościowo wolne (dokładne słowa wykonanych operacji);
standardowe 3 aksjomaty; logi 0/0; jeden proces Lean naraz;
retained failures z przyczynami (33 już w aktach — dopisuj);
małe commity BEZ push (14 czeka na sygnał właściciela);
stop-and-report tylko przy realnej integralności/ścianie
matematycznej; budżet okna kończ w bezpiecznym punkcie
z meldunkiem (jak teraz). Bezwarunkowe Z>0/p_accept/p_K
pozostają OPEN — nie deklarować.

## Na końcu etapu

Meldunek: co zamknięte (moduły/joby), co otwarte, akta,
następny suffix, trzy zdania (co udowodnione / najbliższy brak /
czego nie implikuje).

Żelazne zasady: run2/notes/B1_STAGED_ROADMAP.md.
