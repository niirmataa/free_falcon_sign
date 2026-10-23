# Spike 013 — pełne trójki Beaver (bez sacrifice-mul)

**Status: PROTOTYP.** Mnożenie Shamir k=2 przez **ważone Lagrange'em re-deal**.

## Protokół (`src/mul.rs`)

```
strona i: u_i = λ_i · a_i · b_i     // λ_i = Lagrange w 0
strona i: re-deal Shamir(u_i)      // i jest dealerem tylko u_i
strona j: c_j = ⊕_i share_j(u_i)   // udziały c = a·b
```

Inwariant: `Σ λ_i a_i b_i = f(0)·g(0) = a·b`.
**Nikt nie rekonstruuje a ani b**; strona i widzi tylko własne u_i (nie c).

## Wynik: 56/56 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 41 unit + 5 isolation + 10 integration

cargo run --bin iso -- full-triples /tmp/iso-ft
→ TRIPLE_PARTY_DONE p=0..2 / FULL_TRIPLES_OK
```

| # | Test | Twierdzenie |
|---|---|---|
| m1 | λ rekonstruuje stałą | Σ λ_i f(x_i) = f(0) |
| m2 | mul == gf_mul | 32 losowe pary |
| m3 | a,b nieotwierane w mul | kontrakt API |
| s13 | `iso full-triples` | DKG a,b + mul, brak sacrifice-mul |

## Zaufanie (uczciwie)

| | |
|---|---|
| brak centralnego dealera a,b,c | **TAK** |
| brak sacrifice-mul (jednego mnożenia) | **TAK** — to była poprawa vs spike 011 |
| strona i zna u_i = λ_i a_i b_i | **TAK** — lokalnie; nie zna a,b,c |
| pełne BGW / OT / SPDZ | **NIE** |

Ryzyko: strona i może wywnioskować coś z u_i przy dodatkowej wiedzy —
brak dowodu UC; semi-honest.

## Zastosowanie w torze

Gotowe jako **preprocessing trójek** do `G_frag`/Beaver w `iso` (podmień
`triple-dealer` / `sacrifice-mul` na `mul_shamir_reshare` na DKG a,b).
