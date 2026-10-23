# Spike 002 — notatki

**Status: PROTOTYP.** 2-z-3 + kontrola spójności udziałów. Nie threshold FT.

## Co działa (15/15 PASS)

```
cargo test --manifest-path spike/Cargo.toml
→ 8 unit + 7 integration: ALL PASS
```

| # | Test | Wynik |
|---|---|---|
| t1 | happy 2-z-3 (pary {0,1},{0,2},{1,2}) | PASS |
| t2 | wierność vs `H_fold(seed)` | PASS |
| t3 | padnięcie jednej strony — nadal działa | PASS |
| t4 | 1-z-3 nie wystarczy | PASS |
| t5 | **fałszywy udział → WYKRYTY** (`InconsistentShare`) | PASS |
| t6 | **derive blokowany** (fail-closed, nie cichy `K[0]`) | PASS |
| t7 | guardy H-28 (puste, k=0/1, x=0, duplikat) | PASS |
| + | zobowiązania `mix_commit` spina współczynniki | PASS |

## 2-z-3 vs 2-z-2

- **2-z-2** (spike 001): quorum „obaj albo nikt" — nie próg tolerancji padającego.
- **2-z-3** (spike 002): **próg** — dowolne 2 z 3 stron wyprowadzają `K[0]`;
  jedna może paść. Jedna strona nie odtwarza sekretu.

## Kontrola spójności — zakres (uczciwie)

Zamiast klasycznego Feldmana na GF(256)* (DL trywialne w małej grupie,
nie ukrywa) używamy **kontroli algebraicznej z nadmiaru** n=k+1:

- 3 punkty przy k=2 muszą leżeć na wielomianie stopnia <2.
- Jeden przekłamany udział → `verify_consistency` = `InconsistentShare`.
- Przy dokładnie n=k detekcja **nie działa** (każdy zbiór k punktów jest spójny).

**To NIE jest pełne VSS:** nie ukrywa sekretu przed dealerem w sensie DL,
nie zastępuje Pedersen/Feldman na grupie DL-trudnej, nie daje malicious-secure
MPC. Kierunek produkcyjny: Pedersen VSS (san-dkg) lub Feldman na grupie
odpowiedniej — patrz `RESEARCH.md` P0.4.

Zobowiązania `CoeffCommit` (`mix_commit`) = commit-and-open do współczynników
(salt + FNV-like mix). To spinanie dealera z audytem po otwarciu — **nie**
zobowiązanie w sensie kryptograficznym (brak SHA/Grupy w spiku, bez nowych dep).

## Guardy H-28 (w kopii)

Publiczne API zwraca `Result<SpikeError>` zamiast paniki/zawieszeń:
`EmptyXs`, `ThresholdTooLow`, `NotEnoughPoints`, `XZero`, `DuplicateX`,
`EmptyShares`, `InsufficientShares`, `InconsistentShare`, `PartyCountMismatch`,
`WrongThreshold`, `CommitmentMismatch`. Fail-closed — brak cichych kontynuacji.

## Zeroizacja (H-31 w kopii)

`Share`, `Polynomial`, `BeaverTriple`, `MaskedTriple`, `TripleShares`,
`SharedByte` — Drop zeroizuje; brak `derive(Clone, Copy)` na sekretach.

## Czego to NIE implikuje

- nie threshold signing FT1536 / Falcon
- nie Klein-sampler, nie rejection sampling, nie pełne `G(seed*))`
- nie DKG (dealer zaufany — model testowy!)
- nie SPDZ-MAC / malicious-secure MPC
- nie produkcyjna VSS (patrz wyżej)
- nie gotowość progi ani integracji FTKEY/[N]/NXMS
