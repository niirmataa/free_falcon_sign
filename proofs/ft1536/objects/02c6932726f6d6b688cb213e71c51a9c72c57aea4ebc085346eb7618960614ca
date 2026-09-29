# HANDOFF — T03 / FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001

TASK_ID / rola / autor / czas UTC:
FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 (ROADMAP_ID=T03, one-root tranche) /
wykonawca MiMo 2.6 Pro (jeden ręcznie uruchomiony worker) / projekt: Niirmata /
2026-09-22.

REPO / branch / TASK / piny:
REPO=/home/footfalcon/free_falcon_sign (kanoniczne), branch=main /
TASK=proofs/ft1536/documents/FT1536_ZADANIE_MIMO_REFERENCE_INTEGER_RECOVERY_2026-09-22.md,
SHA bbd1f59e795beb3bb7e46e62d0ae86f4f1aa7464c9cc70f9f074d86b83af6169 (zweryfikowany) /
BASE=1aed8adebb68105e1517ab441046a0bbc6c424e7 /
bootstrap MANIFEST c9695c8032faa84f03e254370e5420254d8b96951e95d75e605fe382107a0e2b
(1275 członków, exact set + hashe: 0 mismatch, brak symlinków/escapes;
ORIGINS 1273 git) / source-17 CANDIDATE 56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.
Weryfikacja: logs/01_verify_inputs.log (SUMMARY: 0 checks failed).

WYNIK: **PARTIAL_PROOF** (szczegóły REPORT.md/CLAIM.md; format §11 u prowadzącego):
A PROVED (v_ref = [c,0] − Z(Y)B niezależne od source output; mapping 3072 calls;
integrality; congruence v1+h·v2=c mod (q,Phi)); B OPEN (uniform gap bound
6086.4 ≥ 1/2; dominanty i progi SOURCE_ERROR.md/.json); C lemma PROVED
(nearest-even + tie/parity, oba znaki) — zastosowanie warunkowe od B;
D consumer warunkowy + jawne zobowiązania Verify (Safe16; center/norm
compatibility — lokalny kontrprzykład monotonicity w COUNTERMODELS.md).

Formalizacja: Lean 4.34.0, formal/{SkeletonCancel,RintGap}.lean — 15 named
theorems, czyste logi (logs/06,07), aksjomaty tylko [propext, Quot.sound].
Kontrole: checks/* (exact ring QQ/Z, skeleton exact rational + mutacje,
gap ledger outward, rint tie 1078 cases), checks/c_slice (fpr_rint
normal/ASan/UBSan, 60384 cases vs niezależny oryginał: 0 mismatch).

REPLAYE: rehearsal-001 FRESH_REPLAY_PASS 11/11 (sealed artifacts/fresh_replay.json);
post-freeze v2 FRESH_REPLAY_PASS 11/11; finalny v3 replay w nowym DEST
(W/tmp/postfreeze-002), wynik raportowany w §11 (po freeze zapis tylko do DEST).
Manifest OUTPUTS: 62+ członków (v3), zewnętrzny SHA w §11/REPLAY.md.

NASTĘPNY KROK: tranche „B-gap fix" — certyfikat uniformnych residualów immutable
sk FFT words (~2^-52 rel.; progi: ε_fg ≲ 3.3e-13, ε_FG ≲ 6.8e-10), defektu
(δ, eroot) ≲ (3.3e-6, 3.7e-5) i transportu ηt ≲ 3.2e-8 (SOURCE_ERROR §3);
wtedy C domyka się istniejącym lemma bez nowych pomysłów.

Statusy: source_changed=false; production_source_changed=false;
new_source_patch_integrated=false; owner_accepted=false; new_M0_eta_pre=null.
Brak aktywnych jobów; nie uruchamiano Astry/dudect/relay/publikacji; brak Git.
Wszystkie zapisy pod W; zamrożone bajty upstream nietknięte; inputy/source RO.
Właściciel przekazuje końcowy handoff do niezależnego odbioru (inny model).
