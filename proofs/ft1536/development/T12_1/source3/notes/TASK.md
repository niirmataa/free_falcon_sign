# T12.1 / RUN_003 — M6 source-bound, następnie C Sign i M7

Polecenie właściciela2026-09-29: „idziemy do pełnego source-bound twierdzenia”.
Doprecyzowanie odpowiedzią: **„Oba, najpierw M6”**.
TASK_ID=FT1536_MATH_EUFCMA_MTISIS_RUN_003; ROADMAP_ID=T12.1.
Kontynuacja przypiętego RUN_002 TASK
`b4c11e3cf2a8cf3939a88400a2ea157b9d835e52c02aa974494b93b5f1376e45`.

## Cel pierwszy — M6

Dla każdego klucza h rzeczywiście wyemitowanego przez przypięty profil
C-KeyGen wyprowadzić kernelowo, w niezmienionym finite-box G16:

```
1265 / 10^27 < CorrectnessProbability.delta h
CorrectnessProbability.delta h < 1275 / 10^27
```

Populacja pochodzi z wykonania źródłowego i dekodowania tego samego klucza.
Nie może być zdefiniowana przez NTRU/FiniteFlat/leaf bounds/żądaną tezę.
Zachować N1536,q18433,Phi, sigma768,B2093922385, cap16, Emit i właściwą miarę.

Obowiązki według istniejącego NEXT_INTERFACE:
1. Successful source KeyGen → ten sam materiał klucza, public relation,
   exact NTRU, mandatory gate i odpowiedni stan pamięci.
2. Source FPEMU/FFT/stable operations → exact Gram/leaves i jawne domeny/
   błędy, bez założenia IEEE RN na podstawie komentarza.
3. Konsumpcja właściwych wież/T5 i transport poza box. Osobny T5 W jest RO;
   nie przejmować jego wykonania. Ewentualne wejście wymaga źródeł, pinów,
   dokładnych typów i świeżego kernelowego bindingu we własnej closure.
4. Kernelowe hbLo/hbHi i potrzebne fakty ogonowe dla dokładnego rawBad.
   Counts-fold, testy i rejestr interwałów nie zastępują tego dowodu.
5. Złożyć istniejące warunkowe konsumenty, bez dodania finalnej tezy jako
   lokalnego certyfikatu lub nowej selekcji dobrych kluczy.

## Cel następny — pełna redukcja źródłowego C Sign

Po M6: prowadzić source bindings do rzeczywistych KeyGen/Sign/Verify,
kompletnych praw i obserwacji, lokalnego publicznego samplera i błędów,
następnie złożyć istniejącą redukcję A3 z jawnymi zasobowymi założeniami
PRNG i MT-ISIS według T02–T14. Wykonane Phi/chi²/interpretery/resources
pozostają zależnościami; nie wyprowadzać ich od nowa.
Ten cel nie jest bezwarunkową obietnicą bezpieczeństwa, QROM lub CT.

## Baza i źródła

RUN_002/output wariant002 jest frozen RO:
- REPORT e944b6278cf1d186ded469737cdd144e2749c6496a176664dc6150debb6ef527
- OUTPUTS 6400ec7850bda22609dd52c261285149b170777c64b7e2b07a9394c4a54d6d59
- Zakończony replay130 modułów/1125 eksportów; przy konsumpcji zachować
  mapę aktualnego źródła, receiptu i artefaktu z właściwym pinem.

M6 kontynuuje przypięty M0 PROFILE/source17. KeyGen SHA256:
0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf.
Porównania do nowszego profilu są osobnym transportem źródłowym; nie
podmieniać bazy na zastane Extra/c. P02 jest dependency RO/PARTIAL bez
domkniętych add/mul/div/sqrt; jego braków nie przyjmować jako proved.

## Wykonanie i wynik

Własny W: `continuations/FT1536_MATH_EUFCMA_MTISIS_RUN_003` pod W RUN_002.
Jedna sesja/jeden wykonawca. Obowiązuje lokalny AGENTS, limity i czyste logi.
Przy kolejnych krokach aktualizować WORK_STATE: ostatni wynik, piny, procesy
i następny missing type. Nie uznawać samej listy obligations za postęp proofu.
Zmiany kolejności/zakresu rozwijają T12.1 i są zapisywane w ROADMAP_DELTA.md
do przeniesienia przez koordynatora, bez jego Git w sesji wykonawcy.

Kryterium sukcesu M6: domknięty typ z przesłanką źródłowego success i
wyprowadzonymi, a nie założonymi, raw/flat/reject; dokładne cyfry i pełny
aktualny replay z formalnym source bindingiem. Dalej analogiczny kompletny
typ bezpieczeństwa konkretnego profilu z wyłącznie jawnymi właściwymi
założeniami kryptograficznymi/środowiskowymi.
Przy rzeczywistej blokadzie zachować osiągnięty wynik i dokładny brakujący
typ; nie zmieniać definicji celu, zakresu kluczy ani miary w celu uzyskania PASS.
