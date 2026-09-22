# Niezależny odbiór T01 — IID_RETRY_COMPOSITION
REVIEW_ID=FT1536_IID_RETRY_INDEPENDENT_REVIEW_001. Recenzent niezależny, wybrany przez właściciela.
Autor projektu: Niirmata; Falcon Project / Thomas Pornin attribution zachowana.
SOURCE_W (RO): /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_IID_RETRY_COMPOSITION_RUN_001
Werdykt: **PASS_SCOPED_REVIEW** — wyłącznie zadeklarowany zakres IID post-H2P.

## Integralność (niezależna, nie receipt autora)
- REPORT `b7164d...14590`, OUTPUTS `3d6824...25074`, TASK sealed `f773b8...5bed97`, bootstrap MANIFEST `daa95b...5e9947` — wszystkie zgodne przed i po moim replayu.
- OUTPUTS: 2414/2414 członków, 0 symlink/traversal/duplikat/mismatch. SEMANTIC 492/492 spójne z OUTPUTS.
- INPUTS 1275 records: 2 rozbieżności to żywe docs (REPO/AGENTS.md, CURRENT_TASK.md) zmienione późniejszymi commitami onboardingu; kopie sealed W/AGENTS.md i W/TASK.md zgodne. Proweniencja, nie uszkodzenie pakietu.
- BASE `1ba7ae0` w logu Git. Flagi: source_changed=false, production_source_changed=false, owner_accepted=false, new_M0_eta_pre=null; real-PRNG/H2P/whole-Sign/Safe16/recovery/Verify/security/CT jawnie false/OPEN.

## Mój świeży replay (nie receipt autora)
- `scripts/replay.py REVIEW_W/seed/tmp/independent_001 <OUTPUTS_SHA>`, bwrap net-off, oryginalne drzewa ukryte, świeży cache, HOME/TMPDIR pod REVIEW_W.
- Wynik: FRESH_REPLAY_PASS 492/492, exit 0, 662.5s. Regenerated SEMANTIC_FILES.json bajtowo identyczny z sealed. Receipt: seed/tmp/independent_001/REPLAY_RESULT.json (kopia w logs/).
- Bez `archive.py import`: stages/catalog nietknięte. Frozen pakietu nie zmieniono.

## Przegląd A–F
- **A entry/scheduler/re-entry: potwierdzony.** Jeden ReadyRetryEntry (REGION_ENTRY), brak forall-future; guard17 przed init, cap16, fault/norm/codec flow (SCHEDULER); indukcja re-entry k→k+1 także po Bad/rejected (REENTRY_AND_FRAME); kernel `RetryIID.reentry_induction`, interpretacja C jawnie analityczna (mixed, CLAIM:24-28).
- **B IID filtration: potwierdzony.** Source56 SHAKE + projection state oddzielone od fresh B_m; re-init nowy ordinal, porzucone taile nieużywane; PAST bez unread/future (FILTRATION). Real-PRNG hop jawnie OPEN (PRNG_NEXT_INTERFACE).
- **C WholeRegionBad/hazard: potwierdzony.** Tower `Pr(B)<=p·E[J]<=16p<=2^-80` sound; exact racjonale niezależnie przeliczone (16p==uniform, hazard≤16p≤2^-80); obie vectors, także norm-rejected; Bad∧success vs Bad|success rozróżnione, brak claimu success-denominator (STOPPED_COMPOSITION, COUNTERMODELS:2).
- **D coupling/obserwacje: potwierdzony.** Proof-only PRECAST_EXIT przed stores, equal-until-bad, tagged/public TV tym samym boundem, exact bytes poza B; brak nowego abortu C (CHECKED_PRECAST_COUPLING).
- **E budżety/resety: potwierdzone.** Konserwacja per-root + re-init abandonment; wspólny event H (wszystkie reached T_j≤49152) implikuje JEDNOCZEŚNIE 6352/26017792 i resztę; failure <2^-1020 ze strict unii (16·2^-1024=2^-1020); liczby ghost niezależnie przeliczone. Wcześniejsza trasa total-T zachowana jako doprecyzowanie (attempts/resource_budget_clarification), nie ukryta.
- **F bajty/formalizacja: potwierdzone.** Stored-pair norm, capacity ≤3160 via POST/M0, header 0xaa tylko po sukcesie (OBSERVATIONS_AND_BYTES). Lean 120/922/26, audyt PASS, brak sorry/admit/native_decide/ofReduceBool/suppression (trafienia to identyfikatory); granica mixed jawna: fully_kernelized=false, C_compiler_verified=false.

## Kontrole i mutacje
- Receipts: probability_controls PASS (toy cap4 WholeRegionBad=198527/4194304), mutations 13 wierszy (11 KILLED + 2 NO_OP), Sage QQ PASS z exact p zgodnym z RESULT. Logi 499 plików (normal + sanitized buildy, mutacje). Mój replay wszystko przebudował i porównał bajtowo.

## Overlap/failed routes
- Zachowane: floor_start_timeout (później 34.5s PASS), odmowy executor.lock (bez forsowania), resource_budget_clarification. Mój replay na świeżym cache z ukrytym SOURCE_W wyklucza stale outputs. PID-y to historia.

## Granica i scope
- Mixed source/analytical/kernel, G_retry_IID, jeden post-H2P region cap16 + STATIC codec. Poza zakresem: real PRNG, H2P prefix, whole real Sign, universal Safe16, integer recovery, Sign→Verify, security/CT, eta_pre. PASS nie jest owner acceptance ani zgodą na publikację.

## Rekomendacja
Odebrać wyłącznie ten scope (T01). Następny krok właściciela: T02 PRNG_REAL_TO_IID_BUFFER. Drobne uwagi (INPUTS staleness żywych docsów; konwencja strict tail) nie blokują.
Własne obliczenia zakończone. Źródeł/frozen pakietu nie zmieniono. Brak Git/publikacji/relay/dudect; owner_accepted=false.
