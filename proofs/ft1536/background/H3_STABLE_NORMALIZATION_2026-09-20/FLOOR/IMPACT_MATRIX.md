# Transport źródłowy i wpływ patcha

Stary17-file pin2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a
oraz wszystkie historyczne reports/certificates pozostają zapisami starego
builda. Nowy pin:56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.
To jawny replacement bridge, nie podmiana hashy w historii lub owner acceptance.

## Pure replacement argument

Floor_old i floor_candidate są total na Word64 w zadanym integer ABI,
z identycznymi long bits i bez memory/IO/random effects. Dla fixed external
inputs i tych samych jawnie modelowanych coins każda defined source execution
może zastąpić floor call przez candidate: stuttering w wewnętrznych krokach,
ten sam wynik i następny C state. Indukcja po call occurrences zachowuje
outputs, subsequent guards/abort decisions, retries i pobór randomness.
Nie transportuje UB callerów spoza ich domen ani nie dowodzi osiągalności
wymaganej domeny. Nie dowodzi też równego czasu/instruction cost.

| Interfejs | Użycie floor / transport | Pozostały zakres |
|---|---|---|
| L_RHO/L_NTT/L_V | Integer normalizacja/NTT/Verify; nie używają tej primitive. Pozostałe źródła identyczne. | Historyczne piny i ich C/API scope zachowane; nowy packaging pin wymaga bridge, nie edycji raportu. |
| M0 | Obserwacje wyłączają timing; framing/capacity/attempt accounting pozostają. | Cost/runtime nie jest identyczne; konkretny koszt floor oraz t/resource instancja wymagają aktualizacji, bez nowego epsilon. |
| ZERO | Bezpośredni floor consumer; kernel equality daje floorVal−eps0, ranges i int bridge w niezmienionym NumericCenter. | −0 pozostaje−1; r/residual i pozostałe primitive inputs bit-identical przy tych samych z. |
| ROOT | Tree numeric slice nie używa floor; of/add/mul/div/FFT bytes i semantics niezmienione. | Analytic/kernel boundary i open assembly nie stają się full proof. |
| NODE3 | split/Adj/LDL i inverse3 nie używają floor. | Exact bounds/domains i dalsze obligations zachowane. |
| NODE2 | half/split/LDL i imaginary refinement nie używają floor. | Half/raw classes nie są naprawiane przez tę zmianę. |
| BINARY_TOWER | Recursive builder używa niezmienionych split/LDL/half. | Odrębny raw assembly/normalization handoff zachowany. |
| Loader / normalization | Obecne inspected call inventory nie zawiera floor w tych ścieżkach. | Otwarte source/domain/sqrt/width composition pozostają otwarte. |
| Initial targets / Reach | Target transforms same; sampler center floor bit-equivalent. | Global Reach→NumericCenter nadal do dowiedzenia, nie wynik lokalnej CT poprawki. |
| BerExp/sampler/sampler_large | Wszystkie aktywne floor sites objęte compiled review i replacement lemma. | Pozostałe instructions, PRNG/refill, rejection/abort traces mają osobne CT/law obligations. |
| Source Sign-law | Same values/branches/coins dla defined modeled executions; interfejs źródłowy transportowany. | Nie dowodzi idealnego prawa, BerExp accuracy, H1R/FFO/R5T/M7 lub full Sign CT. |

## K_seed i resources

Aktywny KeyGen MODE1 nie ma call fpr_floor; jego source success predicates,
serializers i random consumption są niezmienione. Jeden K_seed[E] warunkowany
sukcesem CAŁEGO KeyGen i p_K pozostają tym samym law. Nie wprowadzono iid
replacement ani dodatkowego warunkowania przy kolejnych queries.

Sign functional law dla fixed coins jest zachowana w opisanym defined-domain
modelu przez bit-equivalence; timing jest osobną obserwacją, wyłączoną w M0.
Zmieniają się instruction count, register allocation i możliwy runtime/cost.
Jeżeli model zasobu ogranicza rzeczywisty wall time lub liczbę instrukcji,
nie wolno użyć samej równości wartości do uznania identycznego budżetu t.
ABI signature/long widths pozostają; compiler evidence dotyczy GCC14.2 -O.
Unsigned C idiom nie gwarantuje CT dla innego kompilatora lub architektury.

Known fpr_lt(-0,+0)=1 i half boundary pozostają osobnymi ustaleniami. Nie
przypisano nowego abortu, epsilon, owner acceptance lub bezpieczeństwa schematu.
