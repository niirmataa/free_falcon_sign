# TESTS.md — rejestr (U refresh)

Wygenerowano: **262** testów (238 lib + 14 iso + 10 spike).
`cargo test --manifest-path spike/Cargo.toml` → 262/262 PASS
(iso flake F-18: serial `--test-threads=1`).

Nowe w Y/S/U: SHAKE FIPS, Q73, Klein MPC, G(seed*) circuit, tor sign v2,
SPDZ-MAC ukryte δ, auth triples (U4), EntryPin (U3).
Poprzednie rejestry zostają poniżej jako historia.

## cmp (6)

- `cmp::tests_k3::k3_shake_stub_fail_closed`
- `cmp::tests::r1_accept_boundaries`
- `cmp::tests::r1_accept_zero_and_max`
- `cmp::tests::r1_forged_u_share_detected`
- `cmp::tests::r1_step_poly_matches_int_order`
- `cmp::tests::r1_w_256_err_and_guards`

## cost (8)

- `cost::tests::i1_accept_bit_cost_is_255_beaver_muls`
- `cost::tests::i1_accept_bit_w0_is_zero_muls`
- `cost::tests::i1_counter_sees_raw_mul_calls`
- `cost::tests::i1_g_frag_cost_is_64_reshare_muls`
- `cost::tests::i1_hfold_cost_is_16_beaver_muls`
- `cost::tests::i1_key_material_native_cost_is_128_reshare_muls`
- `cost::tests_m4::m4_butterfly_chain_cost_matches_map`
- `cost::tests_n3::n3_region3_chain_cost`

## h2_ped_demo_iso (1)

- `h2_ped_demo_iso`

## mul (15)

- `mul::tests_3of5::m4_mul_3of5`
- `mul::tests_h28::h28_mul_guards`
- `mul::tests_lagrange_edge::lagrange_symmetric_pairs`
- `mul::tests_lagrange_edge::lagrange_x0_in_list_rejected`
- `mul::tests::m1_lagrange_reconstructs_constant`
- `mul::tests::m2_mul_matches_gf_mul`
- `mul::tests::m3_mul_output_len_and_check`
- `mul::tests_mutation::mut1_corrupt_c_detected`
- `mul::tests_p7::p7_butterfly_matches_clear`
- `mul::tests_p7::p7_chain_768_cost_model`
- `mul::tests_p8::p8_mid_pass_count_matches_map`
- `mul::tests_p9::p9_div_const_matches_clear`
- `mul::tests_p9::p9_div_zero_const_rejected`
- `mul::tests_pin::mul_vector_fnv_pin`
- `mul::tests_w1::w1_ntru_relation_model`

## o1_pipeline_iso (1)

- `o1_pipeline_iso`

## pedersen (5)

- `pedersen::tests::h1_deterministic_seed`
- `pedersen::tests::h1_pedersen_detects_forge`
- `pedersen::tests::h1_pedersen_verify_ok`
- `pedersen::tests::h1_pedersen_x_zero_rejected`
- `pedersen::tests_h3::h3_reconstruct_attempt_panics`

## prss (7)

- `prss::tests_n5::missing_pair_seed_panics_path`
- `prss::tests_n5::zero_shares_n5_sum_to_zero`
- `prss::tests::p1_pair_seed_symmetric`
- `prss::tests::p2_zero_shares_sum_to_zero`
- `prss::tests::p3_masked_open_preserves_secret`
- `prss::tests::p4_prf_deterministic`
- `prss::tests_pin::prss_key_pin`

## r2_mac_demo_iso (1)

- `r2_mac_demo_iso`

## rejection (23)

- `rejection::tests_gauss_edge::gauss_w0_is_max`
- `rejection::tests_gauss_edge::sample_gauss_deterministic_seed`
- `rejection::tests::r1_clear_sampler_in_range`
- `rejection::tests::r2_naive_exposes_attempt_trace`
- `rejection::tests::r3_fixed_window_no_free_running_loop`
- `rejection::tests::r4_attempts_uncorrelated_with_absx_independent_reject`
- `rejection::tests::r5_naive_trace_is_full_leak`
- `rejection::tests::r6_attempts_leak_secret_accept_rate`
- `rejection::tests_s007::s7_bias_vs_target_small_tv`
- `rejection::tests_s007::s7_deterministic_vector_stable`
- `rejection::tests_s007::s7_target_pmf_sums_to_one`
- `rejection::tests_s007::s7_vector_fingerprint_pin`
- `rejection::tests_s014::g1_gauss_weight_decreasing`
- `rejection::tests_s014::g2_gaussian_sums_pmf`
- `rejection::tests_s014::g3_gauss_vs_target_tv`
- `rejection::tests_s014::g4_sample_in_range`
- `rejection::tests_x1::x1_exp_neg_q16_basic`
- `rejection::tests_x1::x1_fail_closed_edges`
- `rejection::tests_x1::x1_gauss_weight_q_monotone_in_absx`
- `rejection::tests_x1::x1_gauss_weight_q_x0_is_q_one`
- `rejection::tests_x1::x1_sample_gaussian_q_deterministic`
- `rejection::tests_x1::x1_sample_gaussian_q_vs_target_tv`
- `rejection::tests_x1::x1_target_pmf_q_sums_to_q_one`

## s10_dkg_seed_no_dealer_secret (1)

- `s10_dkg_seed_no_dealer_secret`

## s11_triples_sacrifice (1)

- `s11_triples_sacrifice`

## s13_full_triples_no_sacrifice (1)

- `s13_full_triples_no_sacrifice`

## s31_audit_no_foreign_reads (1)

- `s31_audit_no_foreign_reads`

## s31b_audit_dkg5 (1)

- `s31b_audit_dkg5`

## s32_dkg5_3of5 (1)

- `s32_dkg5_3of5`

## s33_forged_col_detected (1)

- `s33_forged_col_detected`

## s8_process_isolation_demo (1)

- `s8_process_isolation_demo`

## s9_g_frag_across_processes (1)

- `s9_g_frag_across_processes`

## select (26)

- `select::tests_first_wins3::first_of_three_accepts`
- `select::tests_i2::i2_probed_select_matches_clear`
- `select::tests_j2::j2_gauss_probed_select_matches_clear`
- `select::tests_m3::m3_no_panic_empty_params`
- `select::tests_m3::m3_sample_gauss_native_matches_clear`
- `select::tests_more_guards::more_empty_accept_bits`
- `select::tests_mut_select::mut_forced_reject_first_moves_selection`
- `select::tests_nonbit2::nonbit_255_rejected`
- `select::tests_p6::p6_klein_lite_three_windows`
- `select::tests_s006::s6_abort_retry_bias_smoke`
- `select::tests_s006::s6_checked_accepts_honest_bits`
- `select::tests_s006::s6_forged_accept_share_detected`
- `select::tests_s006::s6_nonbit_accept_rejected`
- `select::tests_s014_select::gs1_gauss_select_matches_clear`
- `select::tests::s5_all_rejected_flag`
- `select::tests::s5_bias_report_smoke`
- `select::tests::s5_encode_range_guard`
- `select::tests::s5_first_accept_wins`
- `select::tests::s5_opened_select_contract`
- `select::tests::s5_select_matches_clear_first_accepted`
- `select::tests_sel_empty::sel_empty_inputs`
- `select::tests_tt41_guards::tt41_bad_len_and_w`
- `select::tests_tt41_guards::tt41_boundary_u_eq_w`
- `select::tests_tt41_integ::tt41_select_from_shared_u_accept_bits`
- `select::tests_tt41::tt41_accept_bit_from_u_shares`
- `select::tests_tt51::tt51_retry_vs_gauss_target`

## spike02_t1_happy_all_pairs (1)

- `spike02_t1_happy_all_pairs`

## spike02_t2_local_oracle (1)

- `spike02_t2_local_oracle`

## spike02_t3_drop_one_party (1)

- `spike02_t3_drop_one_party`

## spike02_t4_single_share_insufficient (1)

- `spike02_t4_single_share_insufficient`

## spike02_t5_forged_detected (1)

- `spike02_t5_forged_detected`

## spike02_t6_forged_blocks_derive (1)

- `spike02_t6_forged_blocks_derive`

## spike02_t7_h28_guards (1)

- `spike02_t7_h28_guards`

## spike03_s1_g_frag_oracle (1)

- `spike03_s1_g_frag_oracle`

## spike03_s2_stays_shared (1)

- `spike03_s2_stays_shared`

## spike03_s3_forged_detected (1)

- `spike03_s3_forged_detected`

## tests (12)

- `tests::commits_bind_coefficients`
- `tests::s1_g_frag_matches_local_oracle`
- `tests::s2_g_frag_stays_shared_until_open`
- `tests::s3_g_frag_forged_seed_share_detected`
- `tests::s4_g_frag_local_deterministic`
- `tests::t1_happy_2of3_all_pairs`
- `tests::t2_matches_local_oracle`
- `tests::t3_drop_one_party_still_works`
- `tests::t4_single_share_insufficient`
- `tests::t5_forged_share_detected`
- `tests::t6_forged_share_blocks_derive`
- `tests::t7_h28_guards`

## tests_boundary (2)

- `tests_boundary::b1_consistency_never_evaluates_at_zero`
- `tests_boundary::b2_party_view_single_column`

## tests_consist5 (1)

- `tests_consist5::consistency_3of5_detects_forge`

## tests_cross (1)

- `tests_cross::x1_g_frag_2of3_matches_3of5`

## tests_cross_consist (1)

- `tests_cross_consist::consist_2of3_and_3of5`

## tests_gfrag_guards (1)

- `tests_gfrag_guards::g_frag_bad_seed_len`

## tests_gfrag_mac_tamper (2)

- `tests_gfrag_mac_tamper::g_frag_mac_tamper_mac_detected`
- `tests_gfrag_mac_tamper::g_frag_mac_tamper_share_detected`

## tests_h4 (2)

- `tests_h4::h4_native_derives_128_without_seed_reconstruct`
- `tests_h4::h4_one_share_cannot_open_material`

## tests_hfold_pin2 (1)

- `tests_hfold_pin2::h_fold_empty_ish_seed`

## tests_m5_pins (2)

- `tests_m5_pins::m5_packet_len_contract`
- `tests_m5_pins::m5_synthetic_seed_pin`

## tests_m6 (1)

- `tests_m6::m6_errors_are_err_not_silent`

## tests_mac3of5 (1)

- `tests_mac3of5::mac_3of5_open_and_tamper`

## tests_mac_cross (1)

- `tests_mac_cross::mac_2of3_and_3of5_same_value`

## tests_mac_matrix (3)

- `tests_mac_matrix::mac_matrix_all_mac_positions`
- `tests_mac_matrix::mac_matrix_all_share_positions`
- `tests_mac_matrix::mac_matrix_delta_mismatch`

## tests_mink (3)

- `tests_mink::mul_party_count_mismatch`
- `tests_mink::open_mac_rejects_short`
- `tests_mink::verify_consistency_n_lt_k`

## tests_more_guards2 (2)

- `tests_more_guards2::open_g_frag_insufficient`
- `tests_more_guards2::reconstruct_empty_and_dup`

## tests_mut_gfrag (2)

- `tests_mut_gfrag::mut3_gfrag_flip_out_share_bit_oracle_mismatch`
- `tests_mut_gfrag::mut4_gfrag_corrupt_seed_share_fails_oracle`

## tests_mut_mac (1)

- `tests_mut_mac::mut2_bad_mac_detected`

## tests_n2 (2)

- `tests_n2::n2_entry_pins_stable`
- `tests_n2::n2_pattern_changes_pin`

## tests_p2 (2)

- `tests_p2::p2_nonce_one_share_insufficient`
- `tests_p2::p2_nonce_shares_oracle`

## tests_p4 (1)

- `tests_p4::p4_sygnet_deterministic_for_seed_and_msg`

## tests_partyview (2)

- `tests_partyview::macshare_open_roundtrip_no_zeroize_claim`
- `tests_partyview::partyview_len_and_get`

## tests_refresh_gfrag (1)

- `tests_refresh_gfrag::refresh_then_g_frag_oracle`

## tests_tt50 (2)

- `tests_tt50::tt50_g_frag_runs_and_counts_rounds`
- `tests_tt50::tt50_mul_count_g_frag`

## tests_tt52 (1)

- `tests_tt52::tt52_refresh_preserves_secret`

## tests_tt53 (1)

- `tests_tt53::tt53_mac_open_ok_and_detects_tamper`

## tests_tt53_gfrag (1)

- `tests_tt53_gfrag::tt53_g_frag_mac_open`

## tests_tt54 (1)

- `tests_tt54::tt54_mem_mailbox_roundtrip`

## tests_vectors (3)

- `tests_vectors::v1_h_fold_vector_pin`
- `tests_vectors::v2_g_frag_vector_pin`
- `tests_vectors::v3_mul_vector_stable`

## tests_w3 (1)

- `tests_w3::w3_chain_l0_l4`

## w2_sign_demo_iso (1)

- `w2_sign_demo_iso`

---

## ZŁOTO MPS4-H refresh — 319 testów

`cargo test --manifest-path spike/Cargo.toml` → **319/319**
(294 lib + 14 iso + 1 flag + 10 spike), 0 warnings.

Nowe: `ishare.rs` (Shamir i16, rounding w MPC, bit-decomp),
`mpc_sign.rs` (ffsampling, trapdoor, codec), testy złota
(engine verify na pełnym N=1536). Pin `103747771`.

---

## T6 / R-G2-1 refresh — 349 testów

Suite: **349/349** (łańcuch F2→G→H→G-2→T6). Nowe: `t6_` 8/8
(DGDG szum w Babai, H≈0.95 bita), regresja `mps4h` 8/8, pin F2 nietknięty.

---

## T7 refresh — 365 testów

Suite: **365/365**, 0 warnings. Nowe: `t7_prss_bit_mask_*`, `prss_dgdg_*`,
`t7_gold_with_prss_*_engine_verify`. Pin F2 `103747771` nietknięty.

---

## T8 refresh — 384 testów

Suite: **384/384**, 0 warnings (359 lib + 14 iso + 1 measure + 10 spike).
Wejście T8: 365/365.

Nowe (19):
- T8.1 pairwise PRSS: `t8_pairwise_prss_zero_shares_sum_zero`,
  `t8_pairwise_prss_zero_shares_independent_streams`,
  `t8_pairwise_prss_bit_masks_separate_rngs` (prss.rs),
  `t8_pairwise_prss_bit_masks_separate_rngs` (ishare.rs),
  `t8_pairwise_prss_independent_party_coins`.
- T8.2 pairwise DGDG/złoto: `t8_pairwise_dgdg_range_and_secrecy`,
  `t8_pairwise_dgdg_matches_clear_formula`, `t8_pairwise_dgdg_mac_consistent`,
  `t8_gold_pairwise_prss_engine_verify`, `t8_gold_pairwise_dgdg_engine_verify`.
- T8.3 keygen bez clear: `t8_keygen_no_clear_dkg_shares_never_full`,
  `t8_keygen_no_clear_dkg_engine_verify`, `t8_keygen_no_clear_dkg_g2_engine_verify`.
- T8.4 tamper: `t8_tamper_prss_pairwise_mask_macfail`,
  `t8_tamper_prss_pairwise_noise_macfail`,
  `t8_tamper_dkg_contribution_vss_detected`,
  `t8_tamper_dkg_joint_share_detected`, `t8_tamper_dkg_share_sign_macfail`,
  `t8_tamper_prss_zero_share_sum_detected`.

Regresja złota: `t7_gold_*`, `t6_*`, `mps4h_*` zielone; pin F2 `103747771`.
API: `pairwise_prss_bit_masks`, `pairwise_zero_streams`, `*_pairwise`,
`dkg_trapdoor_from_contributions`. Notatki: `MPS_T8_PRSS_CDI_NOTES.md`, Y13 upd.

---

## T9.2 range proof F — 390 testów

Suite: **390/390**, 0 warnings (365 lib + 14 iso + 1 measure + 10 spike).
Wejście T9.1: 387/387 (362 lib).

Nowe (3):
- `t9_fbound_ok_real_f` — realne F przechodzi range proof na udziałach.
- `t9_fbound_violation_aborts` — F = ±q/2 → `SpikeError::FBoundViolation`.
- `t9_fbound_dkg_weighted_ok` — ważony DKG + range proof; F ≥ q/2
  w sumie wkładów → fail-closed w torze DKG (bez clear F).

Regresja złota: `t8_*`, `t9_keygen_*`, `t7_gold_*`, `t6_*`, `mps4h_*`
zielone; pin F2 `103747771` nietknięty. `validate_f_bound` (clear)
zachowuje `InconsistentShare` — stare testy g2_f_bound bez zmian.
Notatki: `MPS_T9_NOTES.md` sekcja T9.2. Y13 nietknięte (T9.4).

---

## T9 refresh — 394 testów

Suite: **394/394** (369 lib + 14 iso + 1 measure + 10 spike), 0 warnings.
Nowe: `t9_keygen_*`, `t9_fbound_*`, `t9_mac_s_*` (10).
Pin F2 `103747771` nietknięty. API: `dkg_trapdoor_from_weighted_contributions`,
`validate_f_bound_shares`, `i_poly_mul_ring_shares_auth`.

---

## T10 offline NTRU + H1 — 400 testów

Suite: **400/400** (375 lib + 14 iso + 1 measure + 10 spike), 0 warnings.
Wejście T10: 394/394.

Nowe (6):
- `t10_ntru_weighted_shares_ok` — ważony DKG klucza NTRU → offline check true.
- `t10_ntru_open_delta_is_constant_q` — fG−gF = [18433,0,…,0].
- `t10_ntru_bad_relation_detected` — tamper f share → check false.
- `t10_ntru_wrong_contribution_detected` — zepsuty wkład G → false.
- `t10_contribution_digest_agreement` — SHA3-256 digest wkładów (zgoda).
- `t10_h1_g2_deal_retained_test_only` — produkcja bez `g2_deal_trapdoor`.

API: `ntru_fg_gf_open_delta`, `ntru_fg_gf_check_weighted_shares`,
`trapdoor_contribution_digest`. H1: `g2_deal_trapdoor` = retained/test-only.
Regresja złota: `t9_*`, `t8_gold_*`, `t7_gold_*`, `t6_`, `mps4h` zielone;
pin F2 `103747771` nietknięty. Notatki: `MPS_T10_NOTES.md`, Y13 upd.

---

## T13 audyt fixes (#16, #2, #9) — 414 testów

Suite: **414/414** (389 lib + 14 iso + 1 measure + 10 spike), 0 warnings.
Wejście T13: 403/403.

Nowe (11):
- `t13_uniform_range_no_modulo_bias` — pomiar rozkładu span=3 bez biasu %.
- `t13_uniform_range_covers_span` — pełne pokrycie [-8,8].
- `t13_q16_exhaustion_is_err` — wyczerpanie Q16 → `AttemptsExhausted`.
- `t13_q73_exhaustion_is_err` — wyczerpanie Q73 → `AttemptsExhausted`.
- `t13_q73_honest_path_still_ok` — uczciwy sampling nietknięty.
- `t13_beaver_wrong_c_with_valid_mac_rejected` — zepsute c (MAC zgodny
  z złą wartością) → MacFail (#2).
- `t13_beaver_good_c_ok_and_c_mac_in_dataflow` — dobre c OK; c.mac w dataflow.
- `t13_beaver_tamper_c_share_without_mac_rejected` — share bez MAC.
- `t13_correlated_forgery_without_delta_detected` — skorelowane bez δ → MacFail.
- `t13_correlated_forgery_with_known_delta_is_retained` — skorelowane
  z δ przechodzi (**RETAINED** granica G-2; pilnuje statusu #9).
- `t13_value_only_and_mac_only_detected` — value-only / MAC-only → MacFail.

API: `check_zp_auth_triple`, `GaussQError::AttemptsExhausted`,
`uniform_range_pub` (unbiased). Regresja złota: pin F2 `103747771`,
`t12_*`, `t10_*`, `t9_*`, `t8_gold_*`, `t6_`, `mps4h` zielone.
Notatki: `MPS_T13_NOTES.md`, `AUDYT_WEWNĘTRZNY_T12.md` (statusy).
