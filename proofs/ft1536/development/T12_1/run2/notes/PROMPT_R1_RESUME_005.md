# ZADANIE: R1 — ścieżka gs s4–s7 ze zmontowanego stanu after

Wznowienie od checkpointu 193 (montaż kroku ZAMKNIĘTY: keeps
copy/product + SelectedStepChain193 z rozliczonymi hipotezami s3,
joby 460/461/465/466). Pierwsza ścieżka prime (s0–s3) to jeden
bezwarunkowy łańcuch wykonania od wybranego stanu seed9.
Następny wolny suffix joba: 467. Wejście: żywe rejestry
(KEYGEN_R1_TAIL_TODO, KEYGEN_STEP_INVERSE_192_REPORT/_FAILURES,
WORK_STATE) + piny 193 → ENTRY_PINS kolejnego poziomu
(postseal 386e4cbc…, receipt 1d6f11ec…, entry e18c7612…).

## Kolejność (meldunek po etapie)

0. Na starcie ROZPOZNANIE niezacommitowanych szkiców w
   source3/formal/Source3: FirstBlockCertificate170_1/2/3.lean,
   KeygenKernel129AuditProbe.lean, KeygenKernel159AuditV2Part000.lean.
   Każdy plik: albo wciągnięty jako mały commit (własny, z opisem
   pochodowania), albo usunięty z uzasadnieniem w meldunku.
   Żadnego „leży i czeka”. Osobno: catalog/FT1536_PREMISE_AUDIT_20261011_001.json
   NIE ruszać (chroniony katalog — decyzja właściciela).
1. Region gs s4–s7 z zmontowanego stanu after — te same moduły
   keeps (StepCopy/StepProductKeep193) wielokrotnego użytku:
   strzeżone obrazy przez zapisy regionu gs, wartości jako wykonane
   słowa (modp_add/sub/montymul/R/div), bez własności tablicy.
2. s8 — fałszywa ochrona !out_ntt: para fd/gd przy logn−1=8;
   UWAGA: potrzebny wariant kontrolny prologu dla logn-8
   (osobny moduł, nie modyfikować zaplombowanych 192/193).
3. Ogon pętli zewnętrznej, CRT / dodatkowa liczba pierwsza,
   poziomy d, root/certificate/codec → świadek G(seed*)
   (KeygenProbability134) — tylko jeśli zmieści się w budżecie
   okna; jeden etap na okno ma pierwszeństwo.

## Zasady (bez zmian)

Wszystko wartościowo wolne (dokładne słowa wykonanych operacji);
standardowe 3 aksjomaty; logi 0/0; jeden proces Lean naraz;
retained failures z przyczynami (61 już w aktach — dopisuj;
DIAGNOSTIC oddzielone od porażek); małe commity LOKALNE bez push
(4 czeka na sygnał właściciela); stop-and-report tylko przy realnej
integralności/ścianie matematycznej; budżet okna kończ w bezpiecznym
punkcie z meldunkiem. Bezwarunkowe Z>0/p_accept/p_K pozostają OPEN
— nie deklarować. Obce procesy (np. ftkey-vm sign) i niezależne
zmiany w repo: nie ruszać.

## Na końcu etapu

Meldunek: co zamknięte (moduły/joby), co otwarte, akta,
następny suffix, trzy zdania (co udowodnione / najbliższy brak /
czego nie implikuje).

Żelazne zasady: run2/notes/B1_STAGED_ROADMAP.md.
