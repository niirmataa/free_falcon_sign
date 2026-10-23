# Spike 003 — G_frag (kawałek P0.3)

**Status: PROTOTYP.** Syntetyczny łańcuch w miejscu formalnego `G(seed*)`
(źródła R1 **nie są lokalne** — R1/s3 osobny tor). Nie threshold FT.

## Co robi

`G_frag`: 32 B seeda → **64 B materiału klucza** w formie udziałów:
```
etap 1: out[i]    = seed[i] ⊕ (seed[(i+1)%32] ⊗ seed[(i+13)%32])
etap 2: out[32+i] = out[i]  ⊕ (out[i] ⊗ seed[i])
```
⊗ = mnożenie progowe (Beaver, 2-z-3). ⊕ = lokalne XOR udziałów.

**Klucz nigdy nie istnieje w całości** — tor progowy zwraca udziały 64 B;
otwarcie (`open_g_frag_byte`) wymaga k udziałów i jest „momentem" tylko gdy
kontrakt każe bajt uczynić jawnym (testy oracle).

## Wynik: 22/22 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 12 unit + 10 integration: ALL PASS
```

| # | Test | Wynik |
|---|---|---|
| s1 | 64 B == `g_frag_local` (oracle, każdy bajt) | PASS |
| s2 | 1 udział nie otwiera (`InsufficientShares`) | PASS |
| s3 | fałszywy udział seeda → `InconsistentShare` | PASS |
| s4 | determinizm lokalny | PASS |
| t* | spike 001/002 bez regresji | PASS |

## Czego to NIE jest

- **NIE** formalnym `G(seed*)` z R1 (KeygenByteGame134) — to inny obiekt
- **NIE** wyprowadzaniem klucza FT1536 / Falcon
- **NIE** Klein-samplerem, nie rejection samplingiem
- **NIE** pełnym VSS / DKG / SPDZ-MAC
- Nie implikuje MPC-90 ani gotowości progi

## Związek z P0.3

Odpowiada na wąski kawałek „obwód `G(seed*)` w MPC": da się utrzymać
cały łańcuch wyprowadzania na udziałach bez rekonstrukcji pośredniej.
Reszta P0.3 (zgodność z formalnym R1, fixed-point FT, rundy/koszt) — otwarta.
