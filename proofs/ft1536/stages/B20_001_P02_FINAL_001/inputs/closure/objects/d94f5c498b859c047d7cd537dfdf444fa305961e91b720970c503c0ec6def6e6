# Wpływ ustaleń na twierdzenia FT1536

Wszystkie odwołania do poprzednich etapów oznaczają przypięte kopie w
`inputs/bootstrap`, a nie aktywny katalog NODE2. Pełne piny są w MANIFEST
i AUDIT_MATRIX.json. „Brak obalenia” nie oznacza nowego pełnego dowodu.

| Interfejs / twierdzenie | Zależność od FPEMU | Wpływ findings i wymagane działanie |
|---|---|---|
| **L_RHO** — normalizacja signed16 modulo18433 | Całkowitoliczbowa; nie używa FPEMU. | F01–F08 nie podważają lokalnego lematu. Nie ma powodu do ponownego dowodzenia L_RHO z powodu porównania zer lub gałęzi floor. |
| **L_NTT** — `L_NTT`, `L_NTT_rho`, coefficient product | Całkowitoliczbowa NTT/CRT. | F01–F08 nie zmieniają lokalnego dowodu. Rozkład publicznych kluczy jest odrębnym obiektem i może zależeć od przyszłej zmiany FPEMU w KeyGen. |
| **L_V** — `RAW_VERIFIER_SOUND`, `L_V_BYTES`, `L_V_LOADED`, `L_V_SOURCE` | Twierdzenie dla wszystkich canonical h,c i legalnych przyjętych bajtów; nie zakłada rozkładu Sign. | Brak zależności od badanych błędów FPEMU. Pin verifiera `3fe78f8d…68d42` zachowany. F01/F02 nie implikują forgery ani awarii ekstrakcji. |
| **M0 specification / KEY_LAW** | Definiuje jeden wspólny `K_seed[E]`, aborts i obserwacje. Samą definicję można stosować do przypiętego programu. | F02/F07 dotyczą obserwacji czasu, których obecna gra nie ujawnia. Rozszerzenie modelu obserwacji to nowy obowiązek. Poprawka C może zmienić `E_K`, `p_K`, `K_seed[E]`, retry/fault law; trzeba ją osobno przypiąć i porównać. |
| **M0 CAPACITY** — payload STATIC ≤3160 po defined norm acceptance | Warunkowy fakt całkowitoliczbowy o signed16/encoderze i legalnym buforze4096. | F01–F08 nie obalają faktu po spełnieniu przesłanki. Nie dowodzi on, że wszystkie poprzedzające obliczenia Sign są zdefiniowane (F05/F08). |
| **H3_RANGE** — `Reach_call_C → CenterClass/NumericCenter` | Wymaga rzeczywistej osiągalności oraz domen wszystkich poprzedzających operacji. | Nadal OPEN/PARTIAL. F03 jest znane; ZERO naprawia interfejs lokalny, nie osiągalność. F05/F08 wymagają ordered caller-domain closure, bez zakładania przyszłego success/norm acceptance. |
| **ZERO** — `FLOOR_ZERO`, `C_INT_BRIDGE`, `OF_EXACT` | Konkretne source-normalized floor/of. NumericCenter finite oraz `-2147483283≤val<2147483282`; z∈[-365,366]. | Brak kontrprzykładu. F03 jest uwzględnione przez eps0. F02 nie obala arytmetyki floor: zmienia trace, nie wartość. Przebudowano historyczne moduły i ponownie sprawdzono zero/boundary kontrolami C. |
| **ZERO** — `SUB_CENTER_CONTRACT`, `SUB_RESIDUAL_CONTRACT`, `R_DELTA_DOMAIN`, `CONSUME_SUB_RESIDUAL`, `MACHINE_RESIDUAL_366`, `MACHINE_CENTER_INTERVAL`, `ORDERED_ZERO_TERMINAL` | Uniwersalna analityczna kompozycja add, normalizer/sticky/pack; kernelowi konsumenci przyjmują source-error bridge. | F04 wyznacza jawną granicę dowodu, nie wykryty fałsz. 25 594 kontrole `ZERO_add_error`, 250 actual center/delta oraz residual fixtures nie wykazały naruszenia. E_half/E_add dla dalszych centrów nie wynikają automatycznie z E_res (F03/F05). |
| **ROOT** — primitive add/mul/div envelopes i `RootCertificate` | cap2^100, U2^-48, eta2^-900; div y∈[1/2,2^23]. Korelacyjny Gram/Schur jest analityczny. | Nie znaleziono naruszenia. F03 underflow mieści się w eta; F04 zachowuje mixed-proof scope. `RootDiv.loop55` daje invariant/remainder, nie samoistny complete div theorem. `RootBounds.machine_schur_consumer` ma jawne przesłanki o błędzie. |
| **NODE3** — `inverse3_bits`, `inverse3_units`, `expanded_div_exponent`, `Node3Certificate` | ROOT envelopes plus y∈[1/16,2^35], literal kappa i source split/LDL. | 12 709 expanded-div checks i raw inverse3 nie zakwestionowały interfejsu. F01 nie jest konsumowane: divisions/pivots są dodatnie, numeric ordering obu zer nie jest przesłanką. F04 dotyczy pełnej analitycznej kompozycji, której nie należy nazywać full Lean C proof. |
| **Aktywne NODE2 / lower-tree** | Przyszła konsumpcja poprzednich lokalnych certyfikatów; half, divisions, bounds i chronologia. | Nie odczytywano stanu prac wykonawcy; nie przypisujemy mu żadnego wyniku. Następny obowiązek z audytu: przy każdym użyciu wyprowadzić denominator range i klasę input/output dla half, oddzielić primitive envelopes od positivity/composition (F03–F05). Nie ma obecnie podstawy do odrzucenia ROOT/NODE3 jako wejść. |
| **Sign-law / H3_LIKELIHOOD / PRECAST_BYTES / FULL_GEOMETRY** | Rzeczywiste sqrt/rint/FFT/LDL, reductions, exponential acceptance, joint errors, faults/retries/bytes. | F05/F06/F08 pozostawiają konkretne luki: caller domains, pełny exponential binding i joint law. F01 jest ograniczonym błędem generic API; nie wykazano jego konsumpcji przez aktywny selector. F02/F07 wymagają osobnego side-channel celu, nie dopisywania epsilon do obecnej gry M0. |

## Co rzeczywiście zakwestionowano

1. **Ogólny kontrakt `fpr_lt` w `internal.h:281-282`** jest fałszywy dla
   pary (-0,+0), jeśli `<` oznacza porządek wartości rzeczywistych (F01).
   Najbliższy potencjalny konsument to przyszły ogólny compare-refinement.
   Obecne Gate00 i adaptive selector porównują z dodatnimi niezerowymi
   stałymi; ta para nie występuje w ich lokalnej dziedzinie porównania.
2. **Ogólne odczytanie „CT-safe: -O only”** nie jest uzasadnione (F02):
   istnieje gałąź od operandu także w rzeczywistym aktywnym samplerze.
   To mocniejszy dowód braku fixed branch trace niż sam brak raportu dudect,
   ale nadal nie jest pomiarem czasu, dowodem exploitability ani wycieku klucza.
3. **Żaden z badanych lokalnych arithmetic proof interfaces ZERO/ROOT/NODE3
   nie został obalony.** Pozostają ich jawne przesłanki i mieszany zakres.

## Reguła postępowania przy przyszłym błędzie w proof domain

Najpierw minimalny raw-word reproducer i określenie naruszonego kontraktu,
następnie najbliższy konsument: ZERO ordered residual → późniejsze centra;
ROOT primitive envelope → FFT/Gram/RootCertificate → NODE3 → NODE2;
NODE3 extended-div → LDL3 pivots i kolejny lower-tree.
Wtedy należy zatrzymać konsumpcję danego błędnego interfejsu i wykonać
targeted re-review/replay zależnych etapów. Nie wolno automatycznie przenosić
skutku na niezależne integer L_RHO/L_NTT/L_V.

Nowe C oznacza nowy candidate pin/profile i ocenę K_seed/Sign-law. Historyczne
raporty i dowody pozostają niezmienne. W tym audycie `source_changed=false`,
`owner_accepted=false`, `security_reduction_proved=false`.
