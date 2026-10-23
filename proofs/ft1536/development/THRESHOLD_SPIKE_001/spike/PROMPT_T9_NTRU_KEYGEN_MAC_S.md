# PROMPT — T9: bezdealerowy keygen NTRU + auth triples na s1,s2 (R-G2-2)

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Stan wejścia:** łańcuch F2→G→H→G-2→T6→T7→T8 PASS — suite **384/384**.

---

## Cel T9

Domknąć **najbliższy brak T8** (meldunek zdanie 2):

1. **Pełny bezdealerowy keygen NTRU** — ważony wkład offline
   (weighted contributions), range proof `max|F| < q/2` w MPC
   (na realnych ~54–65 ≪ 9216); nikt nie widzi pełnego f,F w clear
   (kontynuacja `dkg_trapdoor_from_contributions`; `g2_deal_trapdoor`
   zostaje retained).
2. **Auth triples / MAC na s1,s2 po ring-mulach (R-G2-2)** —
   `s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F` z kontrolą MAC
   (ukryte δ, jak Y6/U4), nie tylko na wejściach.

To **NIE** jest malicious-secure / UC / EUF-CMA / CDI proof.
Ma być: bezdealerowy keygen + MAC na wyjściach ring-mul + regresja złota.

---

## Kontekst — co już jest (NIE psuć)

| Element | Gdzie |
|---|---|
| ZŁOTO: z z udziałów → s1,s2 → `Ft1536Signature::verify==true` | `ishare.rs`, `mpc_sign.rs` |
| Pairwise PRSS (osobne rng), DKG trapdoora z wkładów + Pedersen | `MPS_T8_PRSS_CDI_NOTES.md` |
| SPDZ-MAC ukryte δ, DKG δ, auth triples | `lib.rs` (Y6–Y10, U4) |
| Szum DGDG H≈0.95 | `MPS_T6_GAUSS_NOTES.md` |
| Shamir i16 (P=2^61−1) | `ishare.rs` |

**Konwencja złota:** `z1 = round((t·f + g)/q)`, `z0 = round((−t·F + g')/q)`;  
`s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F`; `s2·h − s1 = t`;  
`encode_sig_static(s2)` → engine verify. **Pin F2:** `n = 103747771`.

---

## Zakres T9 (kolejność)

1. **Weighted keygen NTRU offline** — wkłady ważone (np. udział w
   generowaniu f,F), brak pełnego f,F w clear w torze setupu;
   `g2_deal_trapdoor` = retained / test-only.
2. **Range proof `max|F| < q/2` w MPC** — sprawdzenie na udziałach
   (porównanie / bound-check jak `cmp` / `verify_cols`), fail-closed
   przy naruszeniu.
3. **Auth triples / MAC na s1,s2 po ring-mulach (R-G2-2)** —
   MAC (ukryte δ) na wynikach `z0·g + z1·G` i `z0·f + z1·F`;
   tamper ring-mul → MacFail; regresja: MAC OK → engine verify.
4. **Matrix fałszerstw** — tamper: wkład keygen, F poza bound,
   s1/s2 po ring-mul, MAC → detekcja.
5. **Aktualizacja** `MPS_T9_NOTES.md` + `Y13_MALICIOUS_MAP.md` + retained.

---

## Kryteria odbioru

1. Keygen: brak pełnego f,F w clear w torze (test + notka);
   `g2_deal_trapdoor` retained.
2. `max|F| < q/2` — test pozytywny (realne F) + negatywny (F ≥ q/2 → abort).
3. MAC na s1,s2 po ring-mul: OK → engine verify true; tamper → MacFail.
4. Regresja złota: pin F2 `103747771`, `t8_gold_*`, `t6_`, `t7_`, `mps4h` zielone.
5. Suite ≥ 384 + nowe, 0 warningów.
6. Retained w aktach; **nie kasować** F2-1, G-1..3, H-1..4, T6, T7, T8.

---

## Zakres plików

| IN | OUT |
|---|---|
| `spike/src/ishare.rs`, `mpc_sign.rs`, `lib.rs` (MAC), `pedersen.rs`, testy, `MPS_T9_NOTES.md`, `Y13_MALICIOUS_MAP.md` | `Obrazy/`, `Extra/c` (read-only), `[N]`, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS;
nie deklarować „malicious-secure”, „próg FT gotowy”, „brak dealera klucza”
w pełnym sensie (H1 retained).

---

## Testy startowe

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml
```

Spodziewane: 384/384, 0 warnings.  
Regresja złota: `t8_gold_*`, `t7_gold_*`, `t6_`, `mps4h`.

---

## Trzy zdania na start

1. **Złoto + T8 (pairwise PRSS, DKG z wkładów) działa** — nie psuć 384.  
2. **Brak** — ważony keygen NTRU + range proof F + MAC na s1,s2 (R-G2-2).  
3. **NIE implikuje** — malicious-secure / UC / EUF-CMA / CDI proof.

---

## Obowiązkowe ft-skills (właściciel — przy każdym zadaniu)

**Na STARCIE zadania uruchom:**
1. `/ft-tryb-pracy` — rygor ról (IMPLEMENTATOR / WERYFIKATOR / RECENZENT),
   raporty z dowodami, retained failures.
2. **`/ft-historia`** — wczytaj historię toru z akt (commity, receipty,
   meldunki, TABLICA_TOROW, SERCE) — **nie odtwarzaj historii z domysłu**;
   aktualizuj historię po zakończeniu zadania (meldunek → akta).
3. `/ft-prawda-przed-tempem` — statusy uczciwe; trzy zdania w meldunku.
4. `/ft-window-discipline` — jeden etap na okno; stop-and-report przy drift.
5. `/ft-sage-lean` — jeśli dotykasz markerów/Lean/Sage (tu: tylko odczyt
   Extra/c i KEYGEN_* w torze R1 — **bez zapisu w R1**).
6. `/ft-secrets-hygiene` — brak sekretów w aktach; dane syntetyczne.
7. `/ft-suplementy-i-pulapki` — retained przez suplementy, księga pułapek.

**Po zakończeniu:** zaktualizuj `MPS_T9_NOTES.md`, `TESTS.md`,
`REPORT.md`, `PACKAGE_INDEX.md`, `Y13_MALICIOUS_MAP.md`,
**historię** (ft-historia / TABLICA_TOROW) — meldunek 3 zdania.
