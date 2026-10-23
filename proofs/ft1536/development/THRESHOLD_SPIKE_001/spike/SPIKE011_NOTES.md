# Spike 011 — trójki Beaver bez stojącego dealera

**Status: PROTOTYP.** Preprocessing F-13: a,b przez DKG; c=a*b przez
**jednorazowy sacrifice-mul** (osobny proces, zeroizuje a,b po mnożeniu).

## Co robi (`iso triples`)

```
triple-party p=0,1,2   — DKG a,b (wkłady, Shamir-deal; brak seed.bin)
sacrifice-mul          — rekonstruuje a,b TYLKO po to, by c=a*b,
                         zapisuje udziały c, zeroizuje, umiera
sacrifice-check        — otwarcie a,b,c: c == gf_mul(a,b)
                         fałszywe c → assert fail (wykrycie)
```

## Wynik: 48/48 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 34 unit + 4 isolation + 10 integration

cargo run --bin iso -- triples /tmp/iso-triples
→ TRIPLE_PARTY_DONE p=0..2 / SACRIFICE_MUL_DONE / TRIPLES_OK a=.. b=.. c=..
```

## Zaufanie (uczciwie)

| Element | Status |
|---|---|
| brak centralnego dealera sekretu a,b | **TAK** (DKG jak seed) |
| sacrifice-mul widzi a,b | **TAK** — jednorazowo, zeroizuje, proces umiera |
| c=a*b sprawdzalne | **TAK** (sacrifice-check) |
| fałszywa trójka wykryta | **TAK** (assert w demo) |
| pełne OT/HE triple-gen | **NIE** |

To **nie** jest SPDZ preprocess. Zaufanie: komputer, który liczy jedno
mnożenie (a,b) i znika — słabsze niż stały dealer, silniejsze niż OT.

## Retained

- F-14: mailbox `write`/`exists` — już naprawione (tmp+rename).
- F-16: mutex `PoisonError` po failu testu — `into_inner()` w `iso_lock`.
- F-17: `SACRIFICE_MUL_DONE` nie echo'owane do stdout demo — naprawione.
