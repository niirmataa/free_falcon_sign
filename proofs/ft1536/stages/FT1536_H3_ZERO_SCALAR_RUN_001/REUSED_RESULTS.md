# Konsumowane wejścia i warunki

Bootstrap MANIFEST SHA-256:
`e8eb2b091e9396d08afbdd3f8b4adebbebf97e7a0890306c5cf07c8e7beb4099`.
Sprawdzono wszystkie73 wpisy,71 publicznych oryginałów Git z ORIGINS i17 C files.
To projekcja, nie pełny stary replay tree. Stare OUTPUTS/VALIDATION są
proweniencją w pierwotnych bazach. Nie uruchamiano skryptów w bootstrapie.

| Wejście | Przesłanka / status | Użycie |
|---|---|---|
| H3/REPORT e808b0ec… / OUTPUTS91127651… | Odebrany PARTIAL_PROOF, nie globalny Reach | Zachowana granica nowego etapu |
| H3/Floor.lean cf4e4442… | floor_refinement z exponent<=1053 i NotNegZero; negative_zero_exception; integer_safety | ValueDomain najpierw wyprowadza exponent, następnie oddziela−0 i składa zero-aware formułę |
| H3/GuardPrefix edb8a786… | Stary CenterClass i source guard order | Jawna relacja starej i nowej domeny; definicja niezmieniona |
| H3/Proposal/CDF/Comparator | Wszystkie banki i z∈[-365,366], first-match i comparators | Zachowany support do local integer/residual bridge; nie ponowiono kampanii samplera |
| H3/OrderedResidual c937e2e6… | Warunkowe signed-error ordered lemmas ze strict fractional premise | Nowy namespace zmienia lokalną przesłankę na closed rho<=1 i podstawia rzeczywiste E_res |
| H3/fpr_analysis 88eaa7d6… | Diagnostic−0 i underflow, bez required-reachability witness | Powód jawnego exp0/pack proof; nie użyte jako uniwersalny IEEE model |
| M0/REPORT b71d71e8… / OUTPUTS08c9b6af… | Kontrakt4096/r40, jedenK_seed[E], parametryczny cel | Pełna zgodność profilu; bez zmiany source/caller lub zamknięciaM7 |
| review/VALIDATION0235a83e… | Niezależny odbiór H3_RANGE | Pochodzenie/status poprzednika, nie nowy dowód B |

Pełne piny są w INPUTS.sha256, bootstrap/MANIFEST i artifacts/reuse_layout.json.
Sześć modułów H3 skopiowano bajtowo do formal/ z tymi samymi import names;
przebudowano ze źródeł, bez olean/cache. Nie zmieniono H3Range namespaces/tez.

lean.py, dyadic.py i replaylib.py są byte-identical kopiami helperów H3.
Nie zmieniono ich źródeł; wykonują się wyłącznie w nowym cwd W. Ich zależne
od cwd ścieżki odnoszą się teraz do formal/logs/artifacts tego pakietu.
Nowy run.py zapewnia własny sandbox, bootstrap/source read-only i limity.
fp_literal.py, model/controls/certificate i dowody ZeroScalar są nowe.
Nie ma historycznej adaptacji Lean wymagającej diffu; nieudane własne próby
mają osobne copies w attempts, a historia bootstrap pozostaje nietknięta.

Poprzedni complete-IEEE error premise NIE jest konsumowany. B dowodzi tylko
potrzebnego lokalnego add/of/sub po wszystkich klasach NumericCenter.
Mul/div/sqrt/half/global LDL nie stały się przez ten wynik pełnymi IEEE ops.
T2C3/T5/L_RHO/L_NTT/L_V/M0 zachowują historyczne zakresy, a global H3_RANGE
pozostaje PARTIAL_PROOF. Nie odczytano sekretów ani seedów.
