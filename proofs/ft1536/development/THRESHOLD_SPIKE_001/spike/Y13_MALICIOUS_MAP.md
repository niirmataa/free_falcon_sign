# Y13 — model złośliwy: mapa (audyt, nie deklaracja)

**Status: AUDYT / mapa luk.** To **nie** jest malicious-secure MPC.
Zamyka pkt 4 `SECURITY_POSITION` w zakresie **opisu i detekcji**, nie
dowodu bezpieczeństwa w modelu złośliwym.

## Co już łapiemy (fail-closed / detekcja)

| Atak | Mechanizm | Dowód |
|---|---|---|
| Fałszywy udział wartości | SPDZ-MAC ukryte δ (Y6–Y9) | `y6_*_tamper_*` |
| Fałszywy MAC | `z ≠ 0` → `MacFail` | `y6_hidden_delta_tamper_mac_fails` |
| Fałszywy udział δ | `MacFail` | `y6_hidden_delta_tamper_delta_share_fails` |
| Fałszywa kolumna G_frag | spójność / MAC / verify-cols exit 3 | `s33_forged_col_detected`, Q3 |
| Flip bitu SHAKE | ≠ FIPS | `y12_single_bit_flip_in_output_detected` |
| Brak quorum | `InsufficientShares` / `NotEnoughPoints` | guardy `k` |
| Reconstruct w torze | H3 panic / API bez reconstruct | `BOUNDARY_NO_FULL_MATERIAL` |
| **Fałszerstwo w mul / triple** | **U4 auth triple + MAC na mul** | `u4_auth_triple_*`, `u4_mul_auth_*` |
| **Fałszywy udział f/F (VSS)** | **Pedersen VSS → CommitmentMismatch** | `g2_vss_poly_forge_*`, `g2_sign_forge_share_*` |
| **Fałszywy udział f/F w torze sign** | **VSS w deal → abort** | `g2_sign_forge_share_*_aborts` |
| **Fałszywy MAC f w torze sign** | **MAC na open maski → MacFail** | `g2_sign_forge_mac_f_detected` |
| **Fałszywa maska W-bitowa** | **MAC na open d=X−r → MacFail** | `g2_mac_forge_w_mask_detected` |
| **Fałszywy bit-decomp open** | **MAC na open d → MacFail** | `g2_mac_forge_bit_decomp_open_detected` |
| **Fałszywy s1/s2 open (komponent)** | **Z_P MAC ukryte δ → MacFail** | `g2_mac_forge_s1_s2_open_detected` |
| **max\|F\| ≥ q/2** | **validate_f_bound → abort** | `g2_f_bound_violation_aborts`, `g2_deal_f_bound_violation_aborts` |
| **Tamper maski PRSS pairwise** | **MAC → MacFail** | `t8_tamper_prss_pairwise_mask_macfail` |
| **Tamper szumu PRSS pairwise** | **MAC → MacFail** | `t8_tamper_prss_pairwise_noise_macfail` |
| **Fałszywy wkład DKG (VSS)** | **Pedersen VSS → CommitmentMismatch** | `t8_tamper_dkg_contribution_vss_detected` |
| **Fałszywy joint share DKG** | **VSS sumy → CommitmentMismatch** | `t8_tamper_dkg_joint_share_detected` |
| **Fałszywy udział sign z DKG** | **MAC → MacFail** | `t8_tamper_dkg_share_sign_macfail` |
| **Suma zero-shares ≠ 0** | **assert / fail-closed** | `t8_tamper_prss_zero_share_sum_detected` |
| **Fałszywy ważony wkład keygen** | **Pedersen VSS ważone → CommitmentMismatch** | `t9_tamper_weighted_contribution_vss_detected` |
| **max\|F\| ≥ q/2 bez clear F** | **range proof MPC → FBoundViolation** | `t9_fbound_violation_aborts` |
| **MAC na s1,s2 po ring-mulach** | **MAC na wynikach + open z kontrolą δ** | `t9_mac_s_*` |
| **Tamper ring-mul / MAC s1,s2** | **MacFail** | `t9_mac_s_tamper_*` |
| **Zła relacja NTRU na ważonej sumie** | **offline check fG−gF=q → false** | `t10_ntru_bad_relation_detected` |
| **Zepsuty wkład G w ważonej sumie** | **offline check → false** | `t10_ntru_wrong_contribution_detected` |
| **Brak zgody na wkład trapdoora** | **SHA3-256 digest ≠** | `t10_contribution_digest_agreement` |

## Czego NIE łapiemy (luka — otwarte)

| Luka | Skutek |
|---|---|
| Złośliwy dealer w `share_*` / `g2_deal_trapdoor` (H1) | **T8/T10 domykają tor** — weighted DKG + offline NTRU fG−gF=q; `g2_deal_trapdoor` = retained/test-only (`MPS_T10_NOTES.md`) |
| Korelowane fałszerstwa ≥k | rekonstrukcja fałszywego sekretu bez wykrycia |
| Brak UC / symulowalności | brak dowodu redukcji |
| Aktywne przerwanie (abort) | DoS, nie ciche fałszerstwo |
| Wyciek przez timing / kanały boczne | poza modelem |
| Pełny SPDZ (MAC na mnożeniach, triples auth) | tylko open-path MAC; **T9.3:** auth triples Z_P + MAC na wynikach ring-mul; **T10.3:** pełny Beaver w złocie retained |
| **Bity po AND-ach w obwodzie** | **wymaga GF auth triples (R-G2-2)** |
| **Wyciek Babai (Nguyen–Regev)** | **T6/T7: szum DGDG przed round — łagodzenie, nie proof (MPS_T6_GAUSS_NOTES, MPS_T7_PRSS_NOTES)** |
| **Tamper szumu bez G-2** | brak MAC na `g` w torze bez G-2 — `t7_no_g2_noise_tamper_retained_gap` |
| **`delta_known` przy tworzeniu MAC** | szczątkowy model testowy dealera MAC |

## Co T7 domyka w detekcji / setupie (2026-10-21)

| Atak / luka | Mechanizm T7 | Dowód |
|---|---|---|
| Dealer maski W-bit (clear bit) | `paired_bit_mask_prss` — `b=⊕β_i` bez clear | `t7_prss_bit_mask_*`, `t7_gold_with_prss_masks_engine_verify` |
| Dealer pełnego szumu DGDG | `prss_dgdg_*` — suma wkładów `σ/√n` | `t7_prss_dgdg_*`, `t7_gold_with_prss_noise_engine_verify` |
| Tamper maski PRSS (G-2) | MAC open → `MacFail` | `t7_tamper_prss_mask_g2_macfail` |
| Tamper szumu (G-2) | MAC → `MacFail` | `t7_tamper_noise_g2_macfail` |

## Co T8 domyka w detekcji / setupie (2026-10-21)

| Atak / luka | Mechanizm T8 | Dowód |
|---|---|---|
| In-process rng wkładów PRSS | pairwise: osobny rng per partia | `t8_pairwise_prss_*`, `t8_pairwise_prss_independent_party_coins` |
| Clear f,F w setupie (jeden deal) | `dkg_trapdoor_from_contributions` — suma wkładów + VSS | `t8_keygen_no_clear_*` |
| Fałszywy wkład DKG | Pedersen VSS → `CommitmentMismatch` | `t8_tamper_dkg_contribution_vss_detected`, `t8_tamper_dkg_joint_share_detected` |
| Tamper PRSS pairwise | MAC → `MacFail` | `t8_tamper_prss_pairwise_*` |
| Suma zer ≠ 0 | fail-closed | `t8_tamper_prss_zero_share_sum_detected` |

## Co T9 domyka w detekcji / setupie (2026-10-22)

| Atak / luka | Mechanizm T9 | Dowód |
|---|---|---|
| Ważony keygen (inny udział niż wagi) | Shamir liniowy Σ w_i·wkład_i + VSS ważone | `t9_keygen_weighted_*` |
| Fałszywy ważony wkład keygen | Pedersen VSS → `CommitmentMismatch` | `t9_tamper_weighted_contribution_vss_detected` |
| F ≥ q/2 bez clear F | range proof `validate_f_bound_shares` → `FBoundViolation` | `t9_fbound_violation_aborts`, `t9_fbound_dkg_weighted_ok` |
| **MAC na s1,s2 po ring-mulach (R-G2-2)** | **MAC na wynikach ring-mul + open z kontrolą δ** | `t9_mac_s_ok_engine_verify` |
| Tamper ring-mul (f share) | MacFail | `t9_mac_s_tamper_ring_mul_macfail` |
| Tamper MAC na s1/s2 | MacFail | `t9_mac_s_tamper_mac_macfail` |
| Tamper produktu / wejścia auth mul | MacFail (open ε/ρ lub produkt) | `t9_mac_s_auth_triple_mul_ok_and_tamper` |

## Wnioski

1. **Semi-honest + VSS/MAC na otwieraniach** = to, co mamy; to **nie**
   jest model złośliwy.
2. Droga do malicious: authenticated triples, MAC na każdej linii
   (mul, cmp, select), UC-argument — osobny tor, nie Y-pakiet.
3. Póki co: **nie deklarować** „odporny na złośliwych uczestników”.
4. **G-2 (2026-10-21):** VSS f/F + MAC na otwarciach maski domykają
   lukę półuczciwy→detekcja fałszerstw w torze sign. Zobacz
   `MPS_G2_NOTES.md` — retained R-G2-1..4.
5. **T7 (2026-10-21):** brak centralnego dealera masek i pełnego szumu
   w ścieżce złota; H1 klucza dalej jawnym momentem setupu.
   `MPS_T7_PRSS_NOTES.md`. **Nie** malicious-secure.
6. **T8 (2026-10-21):** pairwise PRSS (osobne rng) + DKG f,F bez clear
   w torze setup. Zamyka lukę „in-process rng" i „jeden deal f,F".
   **Retained:** ważny NTRU offline, bound F bez clear, `delta_known`,
   `g2_deal_trapdoor` jako model testowy. `MPS_T8_PRSS_CDI_NOTES.md`.
   **Nadal nie** malicious-secure / UC / pełny CDI proof.
7. **T9 (2026-10-22):** ważony keygen + range proof `max|F|<q/2` w MPC
   + **MAC na s1,s2 po ring-mulach (R-G2-2)**. Zamyka lukę „MAC tylko
   na wejściach" i „bound F bez clear". **Retained:** ważny NTRU offline
   (fG−gF=q), pełne Beaver-triples na 4N² w złocie (wariant `*_auth`
   jest API), `delta_known`, H1. `MPS_T9_NOTES.md`. **Nadal nie**
   malicious-secure / UC / „próg FT gotowy".
8. **T10 (2026-10-22):** offline NTRU `fG−gF=q=18433` na ważonej sumie
   (`ntru_fg_gf_check_weighted_shares`, open tylko różnicy) + zgoda na
   wkłady (SHA3-256 digest). **H1 domknięte w sensie spiku:**
   `g2_deal_trapdoor` = retained/test-only; tor = weighted DKG + offline
   check. **Retained:** pełna ceremonia publicznego keygen NTRU (wkłady
   muszą sumować się do poprawnego NTRU — check weryfikuje wynik),
   pełne Beaver w złocie, `delta_known`. `MPS_T10_NOTES.md`.
   **Nadal nie** malicious-secure / UC / „brak dealera" w pełnym sensie.

*Audyt Y13 — 2026-10-21 (upd. G-2 + T7 + T8 + T9 + T10 2026-10-22). Powiązane: SECURITY_POSITION, Q3, Y6–Y12, MPS_G2_NOTES, MPS_T7_PRSS_NOTES, MPS_T8_PRSS_CDI_NOTES, MPS_T9_NOTES, MPS_T10_NOTES.*
