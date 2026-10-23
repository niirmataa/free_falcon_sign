# PROMPT — T11: publiczna ceremonia keygen NTRU + pełny Beaver w złocie

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Stan wejścia:** łańcuch F2→…→T10 PASS — suite **400/400**.

---

## Cel T11

Domknąć **najbliższy brak T10** (meldunek zdanie 2):

1. **Pełna ceremonia publicznego keygen NTRU** — check (`ntru_fg_gf_check_weighted_shares`) **weryfikuje wynik**; teraz ma **generować sumę poprawnych wkładów**: strony publicznie zobowiązują wkłady (digest SHA3-256), suma ważona przechodzi `fG−gF=q` **i** powstaje w jednej ceremonii (nie „ktoś podłożył gotowe f,F i check przeszedł”).
2. **Pełny Beaver w złocie** — `i_poly_mul_ring_shares_auth` (4N² reshare) w torze `s1,s2` zamiast tańszego wariantu MAC-liniowości (T9) — albo pomiar + retained, jeśli suite >2× wolniej.
3. Domknięcie notki H1: ceremonia = weighted DKG T9 + offline NTRU T10 + digesty T10.

To **NIE** jest malicious-secure / UC / EUF-CMA / CDI proof.

---

## Obowiązkowe ft-skills (właściciel — NA STARCIE)

1. **`/ft-tryb-pracy`** — role, raporty z dowodami, retained.
2. **`/ft-historia`** — **wczytaj historię toru z akt** (commity, meldunki,
   TABLICA_TOROW, SERCE, MPS_*_NOTES) — nie odtwarzaj z domysłu;
   **zaktualizuj historię po zadaniu**.
3. `/ft-prawda-przed-tempem` — statusy uczciwe, trzy zdania.
4. `/ft-window-discipline` — stop-and-report przy drift.
5. `/ft-secrets-hygiene` — brak sekretów w aktach.
6. `/ft-suplementy-i-pulapki` — retained przez suplementy.
7. `/ft-sage-lean` — Extra/c, KEYGEN_* **read-only**.

**Po zadaniu:** `MPS_T11_NOTES.md`, `TESTS.md`, `REPORT.md`,
`PACKAGE_INDEX.md`, `Y13_MALICIOUS_MAP.md`, **historia** (ft-historia).

---

## Kontekst — co już jest (NIE psuć)

| Element | Gdzie |
|---|---|
| ZŁOTO: z z udziałów → s1,s2 → engine verify==true | `ishare.rs`, `mpc_sign.rs` |
| Weighted DKG NTRU (Σ w_i·wkład_i) | T9, `dkg_trapdoor_from_weighted_contributions` |
| Offline NTRU `fG−gF=q` (open tylko różnicy) | T10, `ntru_fg_gf_check_weighted_shares` |
| Digest wkładów SHA3-256 | T10, `trapdoor_contribution_digest` |
| Range proof F, MAC na s1,s2 (ukryte δ) | T9 |
| Pełny Beaver API (retained w złocie) | `i_poly_mul_ring_shares_auth` |
| `g2_deal_trapdoor` | **retained / test-only** (T10) |

**Pin F2:** `n = 103747771` — **nietknięty**.  
**q=18433, N=1536, ternary** — `FT1536_IDENTITY.md`.

**Konwencja złota:** `s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F`,
`s2·h − s1 = t`, `encode_sig_static(s2)` → engine verify.

---

## Zakres T11

1. **Ceremonia publicznego keygen** — kolejność: digesty wkładów →
   VSS ważone → suma → offline NTRU check → (wyjście) f,F w udziałach.
   Test: cała ceremonia od nowa (nie „podłóż gotowe i sprawdź”).
2. **Zepsuta ceremonia** — wkład poza digestem / zła waga / zła suma →
   fail-closed **przed** wyjściem keygenu.
3. **Pełny Beaver w ring-mul złota** (opcjonalnie) — pomiar suite;
   jeśli >2× wolniej: retained + wariant szybki jako default.
4. **Aktualizacja** `MPS_T11_NOTES.md`, `Y13`, retained.

---

## Kryteria odbioru

1. Test: pełna ceremonia → f,F w udziałach → złoto → engine verify true.
2. Test: zepsuta ceremonia (złamanie digestu/sumy) → abort przed keygen.
3. Pin F2 `103747771`, regresja `t9_*`, `t10_*`, `t8_gold_*`, `t6_`, `mps4h`.
4. Suite ≥ 400 + nowe, 0 warningów.
5. Retained w aktach; **nie kasować** F2-1, G-*, H-*, T6–T10.

---

## Zakres plików

| IN | OUT |
|---|---|
| `spike/src/ishare.rs`, `mpc_sign.rs`, `pedersen.rs`, testy, `MPS_T11_NOTES.md`, `Y13_MALICIOUS_MAP.md` | `Obrazy/`, `Extra/c` (read-only), `[N]`, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS;
nie deklarować „malicious-secure” / „próg FT gotowy”.

---

## Testy startowe

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml
```

Spodziewane: 400/400, 0 warnings.  
Regresja złota: `t10_*`, `t9_keygen_weighted_engine_verify`, `t8_gold_*`, `t6_`, `mps4h`.

---

## Trzy zdania na start

1. **Złoto + T10 (offline NTRU, H1 domknięte) działa** — nie psuć 400.  
2. **Brak** — publiczna ceremonia keygen (nie tylko check) + ewentualnie pełny Beaver w złocie.  
3. **NIE implikuje** — malicious-secure / UC / EUF-CMA / CDI proof.
