# M6 — Failure → abort (fail-closed)

Ans 7: `Failure` = **abort protokołu** (nie retry, nie cicha kontynuacja).

| Formal (R5) | Spike | Semantyka |
|---|---|---|
| `Outcome = Failure ⊕ Packet` | `SpikeError` + `Err` | fail-closed |
| `evaluate = some (.inr packet)` | `Ok(...)` | jawny sukces |
| abort | `std::process::exit` / `Err` | odmowa/rozłączenie |

**Zasada:** przy niepewności (MAC fail, spójność, pin) — **abort**, zero continue.
Powtórki samplera przy `AllRejected` = nowe okno (TT-51), nie „cichy sukces".
