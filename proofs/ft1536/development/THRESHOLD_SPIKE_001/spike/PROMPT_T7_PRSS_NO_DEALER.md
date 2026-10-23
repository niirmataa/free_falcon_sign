# PROMPT — T7: PRSS / MPC rejection bez dealera (tor sign FT1536)

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Stan wejścia:** łańcuch F2→G→H→G-2→T6 PASS — suite **349/349**.

---

## Cel T7

Usunąć **zaufanego dealera** z toru złota MPS4-H/T6:
szum DGDG(σ), maski bit-decomp i udziały i16 f,F mają powstawać
przez **PRSS / MPC** (współdzielone zero, re-deal), nie przez dealera
widzącego sekret.

To **NIE** jest pełne malicious-secure ani UC. Ma być: brak dealera
w setupie toru sign + regresja złota (engine verify).

---

## Kontekst — co już jest (NIE psuć)

| Element | Gdzie |
|---|---|
| ZŁOTO: z z udziałów → s1,s2 → `Ft1536Signature::verify==true` | `ishare.rs`, `mpc_sign.rs`, `MPS_H_NOTES.md` |
| Tajny szum DGDG(σ) w Babai (H≈0.95 bita) | `MPS_T6_GAUSS_NOTES.md` |
| PRSS-lite (udziały zera, masked open) | `prss.rs` (spike 012) |
| Shamir i16 (P=2^61−1), rounding w MPC | `ishare.rs` |
| SPDZ-MAC ukryte δ, DKG δ bez dealera | `lib.rs` (Y6–Y10) |
| Auth triples | `lib.rs` (U4) |

**Konwencja złota (zachowaj):**  
`z1 = round((t·f + g)/q)`, `z0 = round((−t·F + g')/q)` (szum w liczniku);  
`s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F`;  
`verify_sign_equation`: `s2·h − s1 = t`;  
`encode_sig_static(s2)` + nonce → engine verify.

---

## Zakres T7 (kolejność)

1. **PRSS zera dla masek W-bitowych** — jak `prss.rs` / `ZeroShareStream`;
   strony nie widzą maski w clear; brak dealera.
2. **PRSS / re-deal dla szumu DGDG(σ)** — wspólny los zamiast dealera;
   zachować rozkład (H≈0.95 bita, var 0.25 — nie psuć T6).
3. **Re-deal udziałów i16 f,F** — H1 setup bez dealera (jak DKG seeda
   w `iso dkg`, spike 010) lub jawne zastrzeżenie że H1 = „moment”.
4. **Matrix fałszerstw** — tamper PRSS / maski / szumu → MacFail/abort.
5. **Aktualizacja** `MPS_T7_PRSS_NOTES.md` + `Y13_MALICIOUS_MAP.md` + retained.

---

## Kryteria odbioru

1. Tor sign **bez dealera** w setupie masek/szumu (test: brak plików
   `delta.txt` / `contrib*` w stylu iso; PRSS zamiast deal).
2. Regresja złota: `Ft1536Signature::verify==true` (n < 2.09e9),
   pin F2 nietknięty, `mps4h`/`t6_` zielone.
3. Szum DGDG: H≈0.95 bita, var≈0.25 (jak T6) — pomiar, nie twierdzenie.
4. Tamper PRSS/maska → detekcja (fail-closed).
5. Suite ≥ 349 + nowe, 0 warningów.
6. Retained w aktach; **nie kasować** F2-1, G-1..G-3, H-1..H-4, T6.

---

## Zakres plików

| IN | OUT |
|---|---|
| `spike/src/ishare.rs`, `prss.rs`, `mpc_sign.rs`, testy, `MPS_T7_PRSS_NOTES.md`, `Y13_MALICIOUS_MAP.md` | `Obrazy/`, `Extra/c` (read-only), `[N]`, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS;
nie deklarować „malicious-secure” ani „próg FT gotowy”.

---

## Testy startowe

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml
```

Spodziewane: 349/349, 0 warnings.  
Regresja złota: testy engine verify z MPS4-H/T6.

---

## Trzy zdania na start

1. **Złoto + szum T6 działa** — nie psuć regresji 349.  
2. **Brak** — brak dealera w setupie (PRSS zera / wspólny los).  
3. **NIE implikuje** — malicious-secure / UC / EUF-CMA.

---

## Alternatywa (jeśli T7 szybko zamknięte)

Klein/ffLDL sampler `D_Λ` (pełny dyskretny Gauss z kraty) zamiast
DGDG w liczniku — osobny prompt.

---

## Obowiązkowe ft-skills (właściciel)

Na starcie: `/ft-tryb-pracy`, **`/ft-historia`** (wczytaj historię toru,
aktualizuj po zadaniu), `/ft-prawda-przed-tempem`, `/ft-window-discipline`,
`/ft-secrets-hygiene`, `/ft-suplementy-i-pulapki`. Po zadaniu: TESTS,
REPORT, PACKAGE_INDEX, Y13, **historia** (TABLICA_TOROW/SERCE).
