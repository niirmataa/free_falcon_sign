# CHECKLIST — FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002 (T03)

REVIEW_ID=FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002. Model: Muse Spark 1.3 Free
(OpenCode; UWAGA: ten sam model co REVIEW_001 — wymóg „inny model” niespełniony, patrz REVIEW.md).

## A — reference / mapping / cancellation / congruence
- [x] v_ref=[c,0]-Z(Y)B niezależne od source output (EXACT_SKELETON §1; REFERENCE_INTEGER_MAP).
- [x] Literalny order: root-prawy→lewy, cubic 2→1→0, binary prawy→lewy, terminal mu1→mu0 (EXACT_SKELETON §2; własny checker zmap: 3072 wiersze, pary mu1/mu0, root b/a połowy, cubic 1024×3).
- [x] Bijekcja 3072 → 2×1536 slotów, znaki +1, merge out[2i]/out[3i+c] (własny checker zmap PASS; seed/z_map_full.json 4bfab5cb…).
- [x] Exact cancellation r=t-Z(Y) z actual L jako stałymi, recomputed products równe (kernel per-slot Int 9 thm; E1/E1b/E2 exact rational w checks/skeleton_cancellation.json 9aa537fe…).
- [x] Integrality obu wektorów + kongruencja v1+h·v2=c z h tego samego klucza (CONGRUENCE.md; własny checker ring PASS na świeżym LCG 20260923: det/target/ring/congruence + mutacje).
- [x] Granica: kernel per-slot, merge/placement w checks (mixed, nie kernelizacja C); klucze syntetyczne bez Emitted membership.
- Werdykt A: PROVED w zakresie PARTIAL (pozytywne subclaims potwierdzone).

## B — error do referencji (outward ledger, missing type)
- [x] Składnia outward przeliczona niezależnie (własny checker gap PASS): TOTAL = suma składników = 6086.4007616… ≥1/2, A_refined=A1+A2+A3+A4, sqrt43 outward (bound²≥4/3, RIF256), 16/16 float ≤1e-9, tie 880/198, etaT próg 1/31457280.
- [x] Dominanty: B_wordres 4489.9 / C1 1078.7 / A2 332.5; luźne trasy 887.0/1165.4/160471/3.681e9 zachowane (SOURCE_ERROR §2).
- [x] Missing type dokładny: residualy stored words ~2^-52 (eps_fg 3.32e-13, eps_FG 6.80e-10) + (δ,eroot)≲4e-5 + ηt≲3.18e-8 z transportem korelacyjnym (SOURCE_ERROR §3; C2=3.0 już >1/2 w boxie).
- [x] Nie wykonano nowego tranche B-gap za autora; brak ciasnego boundu = brak dowodu, nie witness przeciw równości.
- Werdykt B: OPEN (uczciwie, z liczbą 6086.4008).

## C — rounding-gap / rint refinement
- [x] Lemma PROVED: |t-v|<1/2⇒w=v; tie |t-v|=1/2 parzystość (v parz.⇒v, v nieparz.⇒v+1), oba znaki/±0, oba vectory postacią parową (formal/RintGap.lean 6 thm, czysty log, aksjomaty [propext,Quot.sound], bez sorry/admit/native_decide/ofReduceBool/celu/supresji).
- [x] Kontrole: 20110 różnych fixture words vs 60384 wykonań (20128/tryb × normal/ASan/UBSan, byte-identic 481b76c6…, stderr puste, preflight ex≤1072) vs niezależny QQ oracle 0 mismatch (oracle_result.json a0dec47e…); osobno 1078 cases modelu (880 strict/198 tie) — inny zakres niż 60384.
- [x] Mutacje meaningful wykryte, no-op czyste (checks).
- [x] Zastosowanie do actual wide rint WARUNKOWE od B (gap<1/2 nie wykazane uniformnie).
- Werdykt C: LEMMA_PROVED, APPLICATION_CONDITIONAL_ON_B.

## D — conditional Verify consumer
- [x] recovery∧Safe16⇒stored=v_ref⇒congruence z kolejnością wide-rint/narrow16/stored-norm (ROUNDING_RECOVERY §4, VERIFY_NEXT_INTERFACE).
- [x] Safe16 nie wywiedzione ze stored norm (POST precast.Safe16_proved=false; brak witnessa = missing proof).
- [x] Lokalny kontrprzykład center_q/A2-cross-term (4.6→8.6) poprawny i jawnie lokalny (COUNTERMODELS.md); center/norm/bytes otwarte.
- [x] Flagi: whole_Sign/real_PRNG/security/retry/Sign_to_Verify=false, new_M0_eta_pre=null, source_changed=false, owner_accepted=false.
- Werdykt D: CONDITIONAL potwierdzony; pozostałe typy otwarte.

## Integralność / replay / Sage binding
- [x] Bundle 1429 (1364/62/3), 36095923 B, 0 dups/bad/symlink/traversal; OUTPUTS 85/85; INPUTS 29 (28+alias TASK bbd1f59e…); bootstrap 1275/1275; source17; closure 1278 (INTEGRITY.json).
- [x] Własny fresh replay 11/11 exit0 15s, bwrap net-off, stare W ukryte, HOME/TMPDIR pod W, bajty identyczne niezależnie od PASS (REPLAY_CHECKS.json; DEST seed/tmp/independent-001).
- [x] Własne 3 checkery .sage via sage lemma.sage, preparser, ZZ/QQ/RIF256, exit0, pełne binding source→execution→output (SAGE_RUNS/EXECUTION_RECEIPTS.json); failed attempts zachowane (3).
- [x] Hash cytowany = uruchomiona/zapieczętowana wersja (gap a27021f0…, zmap 2ae23ed2…, ring 759c11b7…; outputs fbdad760…, 2c20bb0a…, a5d41d7c…).
- [x] Poprzedni PASS i 3 mismatche ocenione osobno (PRIOR_REVIEW_ASSESSMENT.md); własny werdykt ma samodzielną podstawę.
- [x] PARTIAL pozostaje PARTIAL; publikacja/Git/import/push nie wykonane; joby zakończone.
