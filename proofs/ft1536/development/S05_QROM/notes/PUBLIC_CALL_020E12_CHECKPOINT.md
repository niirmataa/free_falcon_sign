# TODO020E12 — pełne publiczne wywołanie, EveryTape i J/P

**KERNEL_SCOPED / CONDITIONAL_M / NOT_REVIEWED / WARUNKOWY.** Zamknięto
pełne wywołanie w jawnym modelu poniżej, zgodność dla każdej taśmy oraz
transport pełnego J/P pod niezmienionym(M), z publicznym initial.
Nie jest to twierdzenie bezpieczeństwa FT1536 w QROM ani wynik native.

Baza: `1557890a252d137842a5da81a133111e07e99406` (E11).
Źródła: `0e98c225bb14ab86705fe759f3e03c52d0f8f45b`,
`073c72bd0b1b30d1e14f7802cbe984b25a6820d6`.
Runtime: `.build/pair_machine_020/public_call_001/`.
Jedno okno, jeden ciężki proces, lokalny main, bez push. Monitor ROM PAUSED.

## Co jest rzeczywiście wykonywane w modelu

Pipeline korzysta z konkretnych, skończonych maszyn E5 FillMachine i
IndexedParser. Taśma idealna, ROM z rezydentnych danych publicznych i porty
są materializowane jawnymi pętlami. Kodowanie portów nie jest dostarczoną
przesłanką; jego zgodność z dawnymi widokami ma dowód.

Nowy **stały program startowy w IR E6** odczytuje publiczny root i emituje
polecenia inicjalizacji. Sprawdzany konsument E11 wykonuje je na jawnie
wyzerowanym banku. Dowód daje dokładnie CoreStartup.ready: publiczny initial,
ramkę wejściową, oryginalny limit i puste wartości/pending. Wywołanie nie
przyjmuje prywatnego Core ani historii wcześniejszych zapytań.

Następnie pracuje surowy driver E11, a końcowy odbiór odpowiedzi wykonuje
pętlę kopiowania wyjścia. Runtime nie używa starego CoreRun jako implementacji
rdzenia, kanonicznej listy dowodowej ani witness/ofData jako dostarczonego
orakulum. Witness służy tylko porównaniu już zbudowanych portów.

**Wybrana droga jest jawnie mieszana:** konkretne pętle przygotowania/parsera
E5 oraz zapisany startup E6 i surowy rdzeń/konsument E11. Wspólna kompilacja
fill/parser do tego samego backendu poleceń pozostaje osobnym obowiązkiem.
To nie luka w udowodnionej równości tego pipeline'u, ale nie wolno oznaczać
tej kompilacji jako ukończonej. Ładowanie kodu, materializacje, kopie i życie
danych nadal wymagają wspólnego rachunku czasu i peak.

## Główne eksporty

- `PublicCall020E12.run_eq`: dla **każdego rezydentnego publicznego Data i
  każdej taśmy** nowe wywołanie daje `some (ResidentCall020E5.run d coins)`.
  Nie zakłada poprawnego parsera, pojedynczego rootu ani sukcesu rdzenia.
- `PublicCall020E12.every_tape`: dla konkretnego prepared key/programu,
  **dla każdej taśmy**, wynik to `some (some (MachineLaw020D.code h initial coins))`.
  Publiczny klucz jest ten sam przez CostInput.same_key.
- `full_response` i `PublicCallFailures020E12.abort_retained`: otrzymujemy
  bezstratne kodowanie wcześniejszej pełnej odpowiedzi **Rq × Option BoxVec**.
  Abort `(c,none)` zachowuje challenge c i pozostaje odpowiedzią; nie jest
  odfiltrowany. Iniektywność wire jest wcześniej dowiedziona w WireFormat020D.
- `PublicCallLaw020E12.law_eq/full_law`: całe prawo wyjścia jest dokładnie
  wcześniejszym prawem przy publicznym initial, również na gałęzi none.
- `all_h_ac/certificate/same_key_law`: pełne AC i kierunkowy moment, także
  dla tego samego pokrytego prawa kluczy, bez nowej straty.

Zewnętrzne None oznacza błąd startowego/core konsumenta; `some none` zachowuje
wcześniejszą porażkę infrastruktury modelu: parsera, rootu albo rdzenia.
`no_transport_failure` wyklucza pierwszy przypadek nawet dla dowolnego Data.
Dla kanonicznego prepared programu EveryTape wyklucza oba wrapperowe fallbacki,
lecz **nie usuwa porażek algorytmu samplera zakodowanych w pełnej odpowiedzi**.
Totalizacja kodu nie zmienia prawa, ponieważ jej fallback jest już dowiedziony
jako nieosiągalny. Nie ma warunkowania na sukces ani renormalizacji.

## Dokładnie to samo(M) i kierunek J/P

Niech J_h oznacza prawo nowego wywołania przy jednostajnej idealnej taśmie,
a P_h = MachineCertificate020D.reference h — to samo wcześniejsze pełne
prawo odniesienia, zakodowane przez tę samą lossless wire.

Kernel daje dla każdego h: **J_h ≪ P_h**. Pod dokładnie
`SamplerMassCondition014.MassCondition h` daje dodatkowo:

`Σ J_h²/P_h ≤ 1 + 1/2^47`.

Nie odwrócono ilorazu ani nie zastąpiono momentu przez TV. Sam(M) pozostaje
przesłanką: istnieje K>0, a dla wszystkich c i trzech temperatur
`{1, 1811939328/2093922385, 9/16}` pełna nieskończona masa przy szybkości
`t/1179648` leży między
`(1−2^-34)(t^-1)^1536 K` i `(1+2^-34)(t^-1)^1536 K`.
Nie zmieniono go na test skończony, mocniejsze założenie lub dowolny certyfikat.
Piny dokładnej definicji(M), referencji i wire są w CHECKS.

Dla joint h/odpowiedź użyto **identycznego mu po obu stronach**, z jawnymi
Covered mu domain oraz(M) dla h w domain. Nie skonstruowano nowego świadka
pokrycia rzeczywistego KeyGen; źródłowe pokrycie(M) nadal jest OPEN.
To transport klasycznego pełnego prawa, nie automatyczny lemat kompozycji
przeciw kwantowemu przeciwnikowi.

## Mapa murów

| Obowiązek | Stan |
|---|---|
| Producent/konsument i wielokrokowy surowy rdzeń | KERNEL, E7–E11 |
| Konkretne przygotowanie/parser, porty i odbiór w wybranym modelu | **KERNEL, E12** |
| Publiczny reset i stały producent startowy | **KERNEL, E12** |
| Całe wywołanie i EveryTape z publicznym initial | **KERNEL, E12** |
| Pełne prawo, AC i moment J/P | **KERNEL pod tym samym(M), E12** |
| Jednolita kompilacja fill/parser do backendu poleceń | OPEN, osobny zakres |
| Pełny czas/peak wszystkich faz i materializacji | **OPEN — następny tor wykonawczy** |
| Źródłowe(M) na nośniku rzeczywistego prawa kluczy | OPEN, bez zmian |
| Rzeczywiste KeyGen/Sign/PRG, QROM i pozostały TARGET_CONTRACT | OPEN, bez zmian |

Następne prace: pełny rachunek zasobów całego publicznego pipeline'u i pozostałe
obniżenie fill/parser do backendu; niezależnie źródłowe pokrycie(M) i wymagania
redukcji QROM. Nie przenosić dawnych cen na nowy pipeline bez dowodu obejmującego
wszystkie kopie, kody, porty i okresy życia.

## Kontrole i zachowane próby

**12 modułów wynikowych,52 twierdzenia, audyt83 eksportów,781 pinów.**
Wszystkie13 końcowych logów modułów i audytu są czyste. Aksjomaty wyłącznie
propext/Classical.choice/Quot.sound. Bez sorry/admit, nowych aksjomatów,
native_decide/bv_decide i wyciszania linterów w wyniku.

Zachowano39 uruchomień:13 końcowych czystych,3 czyste próby diagnostyczne/częściowe
i23 nieudane. Wśród nieudanych jest7 kontrolowanych przerwań interpretera Lean
po osiągnięciu limitu4096MiB. Nie instalowano ich artefaktów, nawet gdy parser
liczby błędów w receipcie pokazywał0 przy ujemnym exit code.

Bezpośrednia specjalizacja projekcji wyniku VM wywoływała nadmierną redukcję.
Ogólna równość funkcji i dopiero jej zastosowanie punktowe zamknęły dowód
przy tych samych limitach. Podobnie użyto ogólnego lematu paliwa i kontrolowanej
równości materializacji. Pozostałe problemy dotyczyły typów, koercji i nazw;
jedna próba miała niegotową zależność. Nie znaleziono kontrprzykładu.
[CHECKS](PUBLIC_CALL_020E12_CHECKS.json) zawiera przyczyny, receipty i piny.

Limity kompilacji: Lean4096MiB, AS8GiB, jeden rdzeń. To nie pomiar samplera.
Nie wykonywano ogromnej taśmy ani całego wielkiego przebiegu. Nie wprowadzono
nowego rachunku numerycznego wymagającego Sage: nierówność odziedziczono przez
równość praw, a wszystkie nowe równości są kernelowe.

[Kontrola autora](PUBLIC_CALL_020E12_SELF_REVIEW.md),
[klasy warunków](CERTIFICATE_CLASSES_020E12.json), [kolejka](KERNEL_QUEUE_020E12.json).
Brak niezależnego odbioru, pełnej praktycznej wydajności, dowodu native lub
deklaracji bezpieczeństwa FT1536 w QROM. Status WARUNKOWY pozostaje.

OUTPUTS pomija żywy README. RUNTIME zamraża pliki przy freeze, włącznie z
nieudanymi próbami i częściowymi źródłami; późniejsze plany/receipty commita
dokumentów i POSTCOMMIT są operacyjnymi dopiskami poza manifestem.
