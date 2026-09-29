# GOAL / type audit V02

| Rodzina z REVIEW_TASK §3 | Dosłowna forma i werdykt |
|---|---|
| `Word.load_store_le_refines` | `WriteRegion m p →` parse `LE.slice shakeLines 56 15` i `75 15`; obie równoważności `CExec ↔` wartość + pamięć; 8-byte frame i round-trip. Kernelowo zamknięty w tym modelu, nie dowód ISO-C→machine. |
| `Fpr.add_sub_mul_div_sqrt_refines` | Brak pełnego eksportu i real-error; `sub_refines_via_add_obligation` zakłada `AddCallObligation x (y^^^sign) w`; `shiftCalls fpr_add = none`, więc reviewer `no_add_dispatch` neguje przesłankę dla wszystkich słów. Pozostałe Mul/Div/Sqrt tylko nazwane obligation types bez instancji. Cała rodzina OPEN. |
| `Fpr.floor_rint_refines` | Istnieją `rint_execution` pod `rintDomain x` = pole wykładnika `≤1072`; `floor_execution` pod `floorDomain x` = rintDomain i `x≠raw−0`. Konkluzje to `Scalar.execute shiftCalls Parsed.*Program = some (.i64 literalBitVecSpec)`. Brak twierdzenia o real-nearest-even, błędzie rzeczywistym, wszystkich finite i raw−0 floor. PROVED tylko literalny podzakres. |
| `Fpr.reachable_domain_interfaces` | `ShiftCountDomain c := c.toNat<64`; rint-ulsh z przesłanką `he2`, rint-ursh/floor-irsh bezwarunkowo. Rejestr czterech parsed sites, ostatni fpr_sub→fpr_add unresolved. Brak caller-domain wszystkich przyszłych konsumentów. PROVED tylko trzy shift instancje. |

`FORMAL_EXPORTS.json` wymienia 13 primary exports i 4 jawne unresolved types.
Własny Lean wydruk potwierdza dokładne kwantyfikatory/premises dla czterech
krytycznych theoremów; fresh `AuditExports` i `AuditTerms` powtarzają 16
przypiętych produktów. `WriteRegion` oznacza block/offset, długość<2^64,
osiem zainicjowanych bajtów i flagę writable; jest to formalny model pamięci,
nie przesłanka o dowolnych realnych wskaźnikach C. `packDomain` wymusza
signed add e+1076 w zakresie; signed right shift irsh jest jawnym modelem
GCC LP64. Dodatkowy `rintDomain` jest istotnym zawężeniem wejść, nie
instancją dla kolejnych callerów.
