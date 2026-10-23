# PROMPT — G-2: VSS / malicious model dla toru sign FT1536 (MPS4-H)

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Stan wejścia:** ZŁOTO MPS4-H domknięte — 319/319 (294 lib + 14 iso + 1 flag + 10 spike).

---

## Cel G-2

Zamknąć lukę **semi-honest → detekcja fałszerstw** w torze złota MPS4-H:
uczestnik nie może bezkarnie przekłamać udziału f/F/maski w torze sign
bez wykrycia (fail-closed), tak jak w Y6/Y10 (SPDZ-MAC ukryte δ, DKG δ).

To **NIE** jest pełne malicious-secure / UC ani dowód EUF-CMA→MT-ISIS.
Ma być: **VSS + MAC na otwieraniach w torze sign** + matrix fałszerstw.

---

## Kontekst — co już jest (NIE psuć)

| Element | Gdzie |
|---|---|
| ZŁOTO: z z udziałów f,F → s1,s2 → engine verify==true | `ishare.rs`, `mpc_sign.rs`, `MPS_H_NOTES.md` |
| Shamir i16 (P=2^61−1), rounding w MPC, bit-decomp | `ishare.rs` |
| SPDZ-MAC ukryte δ, DKG δ bez dealera | `lib.rs` (Y6–Y10) |
| Auth triples + MAC na mul | `lib.rs` (U4) |
| Pedersen VSS | `pedersen.rs` (H1 spike) |
| Mapa modelu złośliwego | `Y13_MALICIOUS_MAP.md` |
| Retained | F2-1, G-1..G-3, H-1..H-4, Y1-RF-1..3, F-01..F-25 |

**Konwencja złota (zachowaj):**  
`z1 = round(t·f/q)`, `z0 = round(−t·F/q)` w Z[X]/(φ);  
`s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F`;  
`verify_sign_equation`: `s2·h − s1 = t`;  
`encode_sig_static(s2)` + nonce → `Ft1536Signature::verify`.

---

## Zakres G-2 (kolejność)

1. **VSS udziałów f,F (i16, ishare)** — Pedersen/Feldman na DL-trudnej
   grupie (jak `pedersen.rs` / H1), nie interpolacja kontrolna.
   Fałszywy udział → `MacFail` / `InconsistentShare` (fail-closed).
2. **MAC na otwieraniach w torze sign** — otwarcie s1,s2 i masek
   bit-decomp przez ukryte δ (jak Y6), nie jawne.
3. **Matrix fałszerstw** — tamper: udział f, udział F, maska W-bitowa,
   bit-decomp, s1/s2 → każdy wykryty (testy jak `u4_*`, `y6_*`).
4. **Warunek max|F| < q/2** — jawna walidacja (retained H: ~54–65 ≪ 9216);
   naruszenie = abort, nie cicha kontynuacja.
5. **Aktualizacja** `Y13_MALICIOUS_MAP.md` + `MPS_G2_NOTES.md` + retained.

---

## Kryteria odbioru

1. Test: fałszywy udział f lub F w torze sign → **MacFail/abort** (nie
   engine verify true).
2. Test: fałszywy udział f,F **poprawny MAC** (uczciwy dealer) →
   engine verify==true (regresja złota — nie psuć 319).
3. Test: tamper masy W / bit-decomp → detekcja.
4. Test: max|F| ≥ q/2 → fail-closed.
5. Suite ≥ 319 + nowe, 0 warningów.
6. Retained w aktach; **nie kasować** G-1/H-1..H-4/F2-1.

---

## Zakres plików

| IN | OUT |
|---|---|
| `spike/src/ishare.rs`, `mpc_sign.rs`, `pedersen.rs`, testy, `MPS_G2_NOTES.md`, `Y13_MALICIOUS_MAP.md` | `Obrazy/`, `Extra/c` (read-only), `[N]`, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS;
nie deklarować „malicious-secure” ani „próg FT gotowy”.

---

## Testy startowe

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml
```

Spodziewane: 319/319 (294+14+1+10), 0 warnings.  
Złoto regresja: `mps4e_sk_share_ceremony_real_sig`, testy engine verify z MPS4-H.

---

## Trzy zdania na start

1. **Złoto działa** — z z udziałów, engine verify true; nie psuć regresji.  
2. **Brak** — detekcja fałszerstw w torze sign (VSS + MAC na otwieraniach).  
3. **NIE implikuje** — malicious-secure / UC / EUF-CMA; to semi-honest + fail-closed.
