# Konsumpcja audytu przy bieżącym stanie dowodów

Ocena prowadzącego na bazie `24f925ef63e5f9eede54c4d12d3c1f695678640a`.
Audyt FPEMU powstał z bootstrapu bazującego na `b5805ba`; jego wzmianka
o aktywnym NODE2 jest historyczna. Nie zmienia się zamrożonej macierzy audytu.

## Potwierdzone ustalenia i zależności

| Ustalenie | Obecna konsumpcja |
|---|---|
| F01: numeric `fpr_lt(-0,+0)` zwraca1 | Potwierdzone dla generic numeric API. W Gate00 druga strona to dodatnie1/2; selector porównuje dodatni dss z dodatnimi niezerowymi coefficients. Para dwóch zer nie jest przesłanką odebranych lokalnych wyników. |
| F02: compiled floor branch od exponent<1022 | Potwierdzone w niesanitizowanym GCC14.2/-O, także original sampler_large i BerExp. Arytmetyczna wartość floor jest oddzielona od branch trace. Obecne M0 nie udostępnia czasu; nie ma tu nowej zmierzonej straty lub ataku. |
| F03/F05: half/primitive/caller domains | NODE2 ma późniejszy kernelowy opis half dla wszystkich finite words oraz własne związanie domen na level8. Domeny dalszych poziomów i pozostałych callers nadal wymagają dowodów. |
| F04: mixed kernel/analytical boundary | Zachowana w każdym odbiorze. Replay audytu nie jest pełnym replayem wszystkich poprzedników ani dowodem kompilatora. |
| F06: exponential certificate | Luka konsumpcji w wybranym bootstrapie audytu. Nie jest stwierdzeniem nieistnienia historycznego dowodu ani kontrprzykładem do jego tezy. Przed Sign-law trzeba odnaleźć i przypiąć właściwy whole-domain certificate/source binding. |
| F07: dudect/ctgrind | NOT_RUN, zero prób czasowych. Statyczny F02 nie jest statystyką timing leakage. |
| F08: finite coverage | Brak wykrytego naruszenia ZERO/ROOT/NODE3 w tej kampanii nie jest nowym dowodem całego FPEMU lub wszystkich KeyGen/Sign paths. |

L_RHO/L_NTT/L_V są całkowitoliczbowymi wynikami dla przypiętego verifiera
i nie konsumują błędnego porównania zer lub fixed-trace floor. M0 capacity
pozostaje warunkowym faktem po defined norm acceptance. Znalezione F01/F02
nie stanowią podstawy do wycofania tych twierdzeń.

## Późniejszy NODE2

NODE2 odebrano w commicie `b27a0557f785eabd30632eeea9da6b9cf170a7d0`:

- REPORT SHA-256:
  `ff405298926bcb2f75e15f9fb4577d76dea524b38071d9e652e4ac80969a2aba`;
- OUTPUTS SHA-256:
  `5601c991b2b27b639ff57708ed3d82fb4f167a25a156e886d7a9fb0bf0eacbf6`;
- Half.lean:
  `685bb4bacd1cd92e3f53953f50e63097d7c646c3468667471def2f4c5c0e91ee`.

Half: e0→raw+0, e1 może dać subnormal, e≥2 daje exact x/2; finite value
error≤2^-1023. Ten wynik i lokalne div-domain derivations rozliczają część
obowiązku wymienionego w audycie jako następny. Nie rozliczają automatycznie
sqrt/rint, normalizacji liści, wszystkich niższych levels lub całego Reach.

## BINARY_TOWER — zgodność przygotowanego zlecenia

Zlecenie ma SHA-256
`5d00e65d8a7f59d9b46e6d133eb81de1da374d6764b4600183e018710931cc14`.
Przejrzano jego wersjonowaną kopię; aktywnego W wykonawcy nie odczytywano
ani nie modyfikowano.

Zlecenie już wymaga jawnego przeniesienia/rozszerzenia div domain,
uwzględnienia subnormal outputs po half i ustalenia każdego marginu przed
konsumującą go instrukcją. Nie zakłada whole-backend IEEE, generic numeric
fpr_lt na wszystkich bitach, CT ani poprawności normalizacji przez samą
nazwę H4. Badana rekurencja split/LDL nie wykonuje sampler_large/BerExp.

Na podstawie potwierdzonych F01/F02 **nie wskazano naruszonej przesłanki
arytmetycznej tego zadania**. Może ono kontynuować obecny zakres. Każde
przyszłe użycie fpr_lt musi jednak mieć właściwą domenę; nierówność o val
w analizie nie jest twierdzeniem o generic source comparator.

## Konkretny dalszy obowiązek implementacyjny

Osobny etap powinien rozliczyć compiled branch floor: zachowanie bitowej
semantyki (w tym -0), wymagany model niezależności trace, oryginalne miejsca
inline, kompilator/flagę i dokładne bajty kandydata. Comparator potrzebuje
jawnego wyboru kontraktu i dowodu dla finite signed zeros. Każda poprawka C
oznacza nowy pin oraz sprawdzenie funkcjonalnej równoważności w używanych
domenach i konsekwencji dla KeyGen/Sign law; ten odbiór nie integruje poprawki.

Kontrolowany dudect/ctgrind wymaga osobnego przypiętego narzędzia/harnessu
i pomiarów z udokumentowanymi warunkami. Przepis audytu pozostaje wejściem
do takiego etapu, a nie wynikiem już wykonanej kampanii.
