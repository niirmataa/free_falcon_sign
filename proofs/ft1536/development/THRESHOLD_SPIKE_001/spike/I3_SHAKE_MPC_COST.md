# I3 — SHAKE/Keccak-f[1600] koszt w MPC (szacunek)

**Status: ORDER-OF-MAGNITUDE.** Brak lokalnej literatury z liczbą bramek SHAKE w MPC.
Wg I3 (TODO): rząd wielkości + odniesienia. Nie benchmark, nie dowód bezpieczeństwa.

## Źródła lokalne (znalezione)
- eprint **2026/1300** (Thresholdizing Standardized FALCON, CCS 2026) + **ATMACA** —
  MPC Klein / rundy samplera (dziesiątki–setki; ATMACA <180), **nie** koszt SHAKE.
- Ballpark projektu: „SHAKE w MPC ~10^8 bramek" (TODO.md H, H5_PAPER_SKETCH.md:26).
- paper/sec_08: brak exact gate-cost estimate dla SHAKE. R5: `G(seed*)` = KeygenByteGame134 (R1).

## 1) Keccak-f[1600] — ballpark bramek (standard, nie lokalne źródło)
- Stan 1600 b, **24 rundy**; nieliniowy tylko **chi**: ~1600 AND2/rundę → **~3.8×10^4 AND**.
- theta/rho/pi/iota = liniowe (XOR/perm); pełne boolean (AND+XOR) rzędu **10^5** bramek/permutacja.
- SHAKE256: rate 136 B; 1–2 permutacje na krótki absorb+squeeze → **~4×10^4 AND** lub **~10^5** bramek.
- Głębokość multiplikatywna ≈ **24** (1 warstwa chi/rundę) → rzędu **25–50 rund MPC** przy batchu.

## 2) × narzut MPC
- Boolean SPDZ / GC: **1 AND ≈ 1 triple** (Beaver) + otwarcia; XOR lokalny/free.
- 1 permutacja SHAKE256 ≈ **4×10^4 triple'i**; KDF multi-blokowy (XOF na kB) liniowo w blokach.
- Rundy = głębokość obwodu (~25–50), **nie** liczba bramek — pasmo/preprocessing dominują.
- 10^8 lokalne = raczej bit-blast + XOR-count + pełny `G(seed*)` (pk 2881 B + secret ≤10370 B ≈ 10^2 bloków), nie jedna permutacja. **Do pomiaru w I1.**

## 3) vs liniowe `G_frag` (share-native, tanie)
- `G_frag` 32→64 B: **64 muls** (Beaver / `mul_shamir_reshare`) + lokalne ⊕ (SPIKE003/009/010).
- `H_fold`: 16 muls; H4 `derive_key_material_native` 128 B — ten sam rząd.
- **1× SHAKE256 ≈ 10^3 × koszt G_frag** w trójkach; full XOF KDF 10^4–10^5 × (zależnie od wyjścia).
- Implikacja: share-native KDF (algebraiczna ekspansja na udziałach) zostaje tania;
  pełny SHAKE w MPC = wykonalny, ale preprocessing/bandwidth, nie latency (batch).
  Preferować hibryd: tani łańcuch liniowy + SHAKE tylko gdy kontrakt R1 go wymaga.
  Warunek „klucz nie w całości" przetrwa oba — koszt zmienia się o 3–5 rzędów.

## 4) Pytania do R1 / kernela
1. Czy `G(seed*)` to SHAKE/SHAKE256, czy mapa algebraiczna (inny koszt)?
2. Ile bajtów XOF/`secretBytes`+`publicBytes` trzeba wyprowadzić w MPC (= liczba permutacji)?
3. Czy wolno liczyć mnożenia na udziałach w regionach 2–4 (jak w R5 §3) — pin kosztu?
4. `Failure` (.inl) fail-closed dla obwodu MPC — domknięta postać?
5. Kto rozstrzyga rozjazd pinów/semantyki G(seed*) vs G_frag — stop-and-report (TT-55).
