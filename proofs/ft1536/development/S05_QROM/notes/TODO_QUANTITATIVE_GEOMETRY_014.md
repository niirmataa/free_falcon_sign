# S05 — większy pakiet geometrii ilościowej014+

Baza `bc9decf3c4f6d23d9e8982a361bae2f5f582c2ba`.
Decyzja właściciela: większy pakiet pracy bez kończenia po każdym lemacie.
Małe lokalne commity są checkpointami w toku, nie pytaniami o kontynuację.
Obowiązują piny, zachowanie prób, jeden writer Git, bez push i bez zmian
torów T12.1/B20. Status tezy QROM pozostaje WARUNKOWY.

## Zakres wykonania

- [x] Dokładna izometria `Q0` dla mnożenia przez X i każdy monomian,
      z właściwym zawinięciem modulo `X^1536−X^768+1`.
- [x] Przekątne rzeczywistego bloku pierwotnego z013:
      `Q0(f)+Q0(g)≤4608` dla współczynników ternarnych.
- [x] Jawny porządek dwóch bloków1536, macierze A/C/D, dodatniość
      i zachowanie pełnej energii. Transport sumowania jest kolejną częścią konsumpcji.
- [x] Powiązanie widmowe: zidentyfikować dokładny potrzebny eksport
      Parsevala/evaluacji i wyprowadzić reciprocal Schur dla tej samej bazy.
      Dowód z jawnym wejściem musi pozostać odróżniony od jego instancji.
- [x] Zastosować gotowe lematy012/T5 do rzeczywistych A/C/D i wskazać
      dokładnie, które przesłanki (M) samplera są dostarczone.
- [x] Wspólny receipt, kontrole negatywne, mapa kernela i checkpoint pakietu;
      nie zastępować kosztu samplera czasem kompilacji.

## Nie powtarzamy

Mapa `REUSE_MAP_013.md` jest punktem wejścia. Poisson, ogólna masa wieży,
Cholesky → wieża, ogólne skalowanie temperaturą, bijekcja całego włókna
oraz istniejące ogony są gotowymi zależnościami. Nie rozszerzamy ich
zakresu ani nie podmieniamy progu1023 budżetem991.

## Otwarte poza tym pakietem

Pełny source harmonic/emitted KeyGen/codec, rzeczywisty Sign/PRG,
kernelowy wykonywalny007 i pełny moment wszystkich odpowiedzi oraz
mechanizmy kwantowe. Konstrukcja sekretnej bazy w dowodzie nie jest
dodatkowym wejściem wykonawczym publicznego samplera.

## Stan prób

Rozpoczęto `MonomialIsometry014`; pierwsza elaboracja zachowana w
`.build/primary_014/runs/monomial_001`. Wykryła błędy API i składni
sumowania, nie matematyczny kontrprzykład. Dalsze próby zawsze w nowych
katalogach. Indeksy i wpisy tej listy są żywym stanem do wspólnego zamknięcia.

Kernel: `monomial_003` (10 twierdzeń) i `primary_003` (14 twierdzeń),
czyste logi. Granica pierwotna4608 wynika z rzeczywistych kolumn bazy;
nie ma przesłanki FFT ani `ldl_shape`. Przystępujemy do transportu całej
masy przez jawny podział i do części widmowej; nie kończymy okna na tym kroku.

Domknięcie matematyki: `RootMoments014` konstruuje kanoniczne pierwiastki,
`Parseval014` dowodzi ich dokładnej tożsamości metrycznej, `Evaluation014`
i `FullEvaluation014` wiążą je z rzeczywistym mnożeniem/bazą. Następnie
`SpectralBlocks014` i `ReciprocalSchur014` wyprowadzają widmowe bloki i
dopełnienie Schura. `mass_from_actual_harmonic` nie przyjmuje już Grama,
Parsevala ani równości widmowej jako wejściowych certyfikatów.

`SamplerMassCondition014.sampler007_mass_condition` dostarcza dokładne
(M) dla temperatur1,1811939328/2093922385,9/16, z jednym K i budżetem2^-34.
Pozostają zwykłe równania NTRU/public/inverse, ternarność oraz **jawny
bound harmoniczny≥991 na kanonicznych ewaluacjach**. Nie wykazano tu tego
boundu kernelowo z całego rzeczywistego emitted KeyGen ani pełnego J/P007.
Wspólny receipt/manifest/checkpoint kończy ten większy pakiet, nie kampanię QROM.

Kontrola końcowa: świeży wspólny build108 deklaracji i osobnego modułu
interfejsu zakończony czysto;11/11 stdout zgodnych bajtowo z finalnymi runami.
Kontrole Sage002:9 przypadków spektralnych i792 przesunięcia. Negatywna
kontrola normy z Sage001 zachowana z wyjaśnieniem. Po zamknięciu tego pakietu
kolejne większe TODO otrzymuje nowy numer; nie przepisujemy tej historii.
