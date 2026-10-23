# PROMPT — T10: offline NTRU fG−gF=q na ważonej sumie + domknięcie H1

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Stan wejścia:** łańcuch F2→G→H→G-2→T6→T7→T8→T9 PASS — suite **394/394**.

---

## Cel T10

Domknąć **najbliższy brak T9** (meldunek zdanie 2):

1. **Ważny NTRU `fG − gF = q = 18433` na ważonej sumie**  
   (Σ w_i·wkład_i z T9.1) — procedura offline: strony weryfikują
   relację na udziałach / przez zobowiązania, **bez otwierania f,g,F,G**
   (albo jawne otwarcie tylko wartości kontrolnej 18433, jak
   `ntru_fg_gf_check_shares` / `ntru_relation_check` w U2/W1).
2. **Domknięcie H1** — `g2_deal_trapdoor` (clear f,F w setupie) zostaje
   **tylko** jako retained / test-only; tor produkcyjny = weighted DKG T9
   + offline NTRU check. Notka: co jeszcze „moment”, a co nie.
3. **Opcjonalnie:** pełne Beaver na ring-mul (`i_poly_mul_ring_shares_auth`)
   w torze złota zamiast tańszego wariantu — jeśli nie spowolni suite
   >2×, w przeciwnym razie retained + pomiar.

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
7. `/ft-sage-lean` — Extra/c, KEYGEN_* **read-only** (bez zapisu w R1).

**Po zadaniu:** `MPS_T10_NOTES.md`, `TESTS.md`, `REPORT.md`,
`PACKAGE_INDEX.md`, `Y13_MALICIOUS_MAP.md`, **historia** (ft-historia).

---

## Kontekst — co już jest (NIE psuć)

| Element | Gdzie |
|---|---|
| ZŁOTO: z z udziałów → s1,s2 → engine verify==true | `ishare.rs`, `mpc_sign.rs` |
| Weighted DKG NTRU (Σ w_i·wkład_i), VSS ważone | `MPS_T9_NOTES.md`, `dkg_trapdoor_from_weighted_contributions` |
| Range proof F (`max\|F\|<q/2` na udziałach) | `validate_f_bound_shares` |
| MAC na s1,s2 po ring-mul (ukryte δ) | `i_poly_mul_ring_shares_auth`, `MPS_T9_NOTES.md` |
| Relacja NTRU w modelu U2/W1 | `ntru_fg_gf_check_shares`, `ntru_relation_check` (mul.rs) |
| Pairwise PRSS, DKG z wkładów | `MPS_T8_PRSS_CDI_NOTES.md` |
| q=**18433**, N=1536, ternary | `FT1536_IDENTITY.md` |

**Pin F2:** `n = 103747771` — **nietknięty**.  
**Konwencja złota:** `s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F`,
`s2·h − s1 = t`, `encode_sig_static(s2)` → engine verify.

---

## Zakres T10

1. **Offline NTRU check na ważonej sumie** — `fG − gF = q` (stała 18433)
   weryfikowana bez clear f,g,F,G w torze (kontrola wartości / zobowiązania
   / jak W1 ale na udziałach ważonego keygenu).
2. **H1 domknięte** — `g2_deal_trapdoor` oznaczony retained/test-only;
   notka w `MPS_T10_NOTES.md`: co jest „momentem”, co nie.
3. **(opcjonalnie)** pełne Beaver w ring-mul złota — pomiar czasu suite.
4. **Matrix fałszerstw** — zła relacja NTRU, F poza bound, tamper wkładu
   ważonego → fail-closed.
5. **Aktualizacja** `MPS_T10_NOTES.md`, `Y13_MALICIOUS_MAP.md`, retained.

---

## Kryteria odbioru

1. Test: ważony keygen + offline NTRU check → relacja trzyma
   (`fG−gF ≡ 0` w R_q / `= q` w Z).
2. Test: zepsuta relacja (np. zły wkład) → **MacFail / CommitmentMismatch**.
3. `g2_deal_trapdoor` = retained / test-only (nie tor produkcyjny).
4. Regresja złota: pin F2 `103747771`, `t9_*`, `t8_gold_*`, `t6_`, `mps4h` zielone.
5. Suite ≥ 394 + nowe, 0 warningów.
6. Retained w aktach; **nie kasować** F2-1, G-*, H-*, T6, T7, T8, T9.

---

## Zakres plików

| IN | OUT |
|---|---|
| `spike/src/ishare.rs`, `mpc_sign.rs`, `mul.rs`, `pedersen.rs`, testy, `MPS_T10_NOTES.md`, `Y13_MALICIOUS_MAP.md` | `Obrazy/`, `Extra/c` (read-only), `[N]`, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS;
nie deklarować „malicious-secure” / „próg FT gotowy” / „brak dealera
klucza” w pełnym sensie (H1 retained do czasu aż T10 zamknie „moment”).

---

## Testy startowe

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml
```

Spodziewane: 394/394, 0 warnings.  
Regresja złota: `t9_*`, `t8_gold_*`, `t7_gold_*`, `t6_`, `mps4h`.

---

## Trzy zdania na start

1. **Złoto + T9 (weighted keygen, bound F, MAC s1,s2) działa** — nie psuć 394.  
2. **Brak** — offline NTRU `fG−gF=q` na ważonej sumie + domknięcie H1.  
3. **NIE implikuje** — malicious-secure / UC / EUF-CMA / CDI proof.
