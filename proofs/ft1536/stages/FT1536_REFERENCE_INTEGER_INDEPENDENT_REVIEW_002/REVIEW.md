# Niezależny odbiór T03 — REFERENCE_INTEGER_RECOVERY (REVIEW_002)

REVIEW_ID=FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002, ROADMAP_ID=T03.
Recenzent: model Muse Spark 1.3 Free (OpenCode, sesja właściciela).
UWAGA proceduralna: to TEN SAM model co REVIEW_001 (Muse Spark 1.3 Free);
wymóg promptu „inny niż autor MiMo2.6Pro i poprzedni recenzent Muse” NIE jest
spełniony. Wykonanie jest niezależne (nowy seed/DEST, nowe checkery, nowy LCG,
zachowane failures), ale nie jest innym modelem — właściciel decyduje o statusie.
Autor projektu: Niirmata; Falcon Project / Thomas Pornin attribution zachowana.
Werdykt: **PASS_SCOPED_REVIEW** — wyłącznie zadeklarowany zakres PARTIAL_PROOF.

## Integralność (własna, nie receipt autora/prowadzącego)
- Bundle W/inputs: 1429 członków (subject1364/prior62/context3), suma 36095923 B,
  0 dups/bad/symlink/traversal (INTEGRITY.json). MANIFEST SHA `8019bda3…210c31e7` zgodne.
- SUBJECT: REPORT `e01a0978…7785c`, OUTPUTS `0cafdbb2…57b7df6de` (85/85, 0 mismatch);
  bootstrap MANIFEST `c9695c80…107a0e2b` 1275/1275; CANDIDATE `56974571…a0985` source17;
  TASK `bbd1f59e…6169`, POLICY `b6afcdca…e241`, FIRST_REVIEW `e11122ca…0a021` — wszystkie zgodne.
- INPUTS: 29 rekordów = 28 istniejących ścieżek (wszystkie zgodne) + alias
  `TASK_DOCUMENT_provenance` (literalnie brak w SOURCE_W; hash = kanoniczne TASK).
  Nie raportuję 29/29 literalnych ścieżek. Supplement POLICY pod inputs/supplement.
- Bootstrap closure: 85 outputs + 29 INPUTS to nie samowystarczalna kopia — import
  wymaga closure bootstrapu (1278 w INPUT_CLOSURE.json). Nie modyfikowałem oryginałów;
  wszystkie zapisy pod W, IN RO, bez Git/importu/push/sieci/instalacji/KeyGen/secrets/pełnego Sign/dudect.

## Mój świeży replay (nie receipt autora ani REVIEW_001)
- Seed: writable kopia SUBJECT (1364 pliki, OUTPUTS 85 zweryfikowane przed DEST,
  COMMANDS.log zachowany jako członek manifestu; replay.py go nie czyta — roszczenie
  o odtwarzaniu z pustym dziennikiem prawdziwe na poziomie logiki).
- `python3 -B seed/scripts/replay.py W/seed/tmp/independent-001 0cafdbb2…`
  z W/seed, bwrap --unshare-net, cała FS RO poza W, stare W autora i Muse ukryte
  RO-pustymi katalogami pod nowym W, fresh cache/build/Lean, HOME/TMPDIR/XDG/DOT_SAGE
  pod W, single-worker, Lean `-j1 -M2048`, wall 1800s (zużyto 15s).
- Wynik: **FRESH_REPLAY_PASS 11/11, exit 0, 15s** (2026-09-22T08:27:48Z→08:28:03Z).
  Runner SHA `ff4be55d5b44b48e26e61000a33b5037f29c4841d42153a7e56d5c83bb13e1b9`.
  Bajty 11/11 identyczne z seed niezależnie od napisu PASS (SEMANTIC_FILES plan
  sprzed replayu; każdy match rzeczywiście przeliczony).
- SAGE_RUNS replayu odzwierciedla mój run (4× `sage ….sage`, v10.9, hashe
  f9d4b9ea…/b2be11b5…/40add87f…/99077d9c… zgodne z sealed .sage).
- Outer stderr puste (0 B, SHA e3b0c442… — puste, nie utracone); runner scala
  stdout+stderr każdego kroku do DEST/logs/r*.log (wszystkie niepuste z realnym
  przeliczeniem: r02 766080 B, r03/r04/r05/r06/r08/r13 niepuste; r01 wersja 5 B
  „10.9” oczekiwane). Pierwsza próba replayu przeszła; brak ukrytych failures.
- Szczegóły: REPLAY_CHECKS.json, logs/replay_*.txt, logs/fresh_replay.json,
  logs/REPLAY_RESULT.json, logs/SAGE_RUNS.json.

## Mój Sage (POLICY: `sage lemma.sage`, preparser, ZZ/QQ/RIF256)
Trzy nowe autorytatywne checkery (źródła w sage_checks/, cwd=W, SageMath 10.9,
preflight ZZ/QQ/2^10 w każdym; Python tylko organizuje):
1. `sage_checks/review_gap_recompute_002.sage` SHA `a27021f011fa0b6ae5b899dcc0c615c2a9f2fa8da0a0719ce9d7b27d381575cd`
   → `sage_checks/review_gap_recompute_002.json` SHA `fbdad76031e2e900737e73f0fdecdafebeffa5cc8e6bdedc7876d13772b7a00e`,
   exit0, 3s, stderr puste. Dokładna rekompozycja QQ: TOTAL=suma składników
   6086.4007616…, A_refined=A1+A2+A3+A4, sqrt43 outward (bound²≥4/3, RIF256 upper),
   gap_met=false, TOTAL≥1/2, 16/16 float ≤1e-9, tie 880/198, etaT próg 1/31457280.
2. `sage_checks/review_zmap_bijection_002.sage` SHA `2ae23ed2ce48fc7b767dd56b1c0434e7aecbde2ce8e0d322383c493b8c134b48`
   → JSON SHA `2c20bb0ab22439cd513b890ba8ca0c441477f5541ecadd38c02420c2a1f3106f`,
   exit0, 2s. 3072 wiersze, bijekcja a/b 0..1535, znaki +1, pary mu1→mu0,
   root-prawy/cubic-2→1→0 (1024×3), binary_path 8×{R,L}.
3. `sage_checks/review_ring_independent_002.sage` SHA `759c11b76afe9262d939065f0392e50be566cc0bb3a5ed474b3f4b53b62ffb91`
   → JSON SHA `a5d41d7cbe09b5caf1ea781ddd6cb171ee3bfefa1052831b906c1302fdfc1f59`,
   exit0, 8s. Świeży LCG 20260923 (nie fixtures autora 20260922 ani prior 987654321;
   invertible retry), det/target/integrality/congruence/ring identity, mutacje wykryte.
Cztery .sage autora to rzeczywisty rachunek (preflight, ZZ/QQ, RIF256 + exact
bound²≥p, jawne int()); Python organizuje. Równość float nie mylona z równoważnością
certyfikatów (rekord portu trzyma obie reprezentacje outward).
Failed attempts zachowane: gap attempt01 (79a06ba2…, exit1, Sage Integer JSON),
ring attempt01 (d1b4d143…, exit1, FpTElement.list), ring attempt02 (bdd70a83…,
exit1, non-invertible f) — każdy z stderr/exit/source SHA w sage_checks/logs/failed_attempts.
Po zmianie checkera nowe wykonanie ma nowy receipt; wcześniejsze wersje zachowane.
Każdy hash cytowany tu = uruchomiona i zapieczętowana wersja w REVIEW_OUTPUTS.
Szczegóły: SAGE_RUNS.json, EXECUTION_RECEIPTS.json, sage_checks/logs/.

## A — referencja i mapping: scope POTWIERDZONY
v_ref=[c,0]−Z(Y)B niezależne od source output; mapping 3072 (signed permutation,
kolejność literalna, merge out[2i]/out[3i+c], znaki +1); exact cancellation
(E1/E1b/E2 + kernel per-slot Int 9 thm); integrality + kongruencja v1+h·v2=c
z h tego samego klucza (klucze z niejedynkowym f, hf−g=q·k≠0). Granica jawna:
kernel per-slot, merge/placement w checks (mixed, nie kernelizacja C/kompilatora);
klucze syntetyczne bez Emitted membership. Bijekcja nie zastępuje argumentu
uniform — uniformność z konstrukcji placementu + tożsamości. Evidence: EXACT_SKELETON.md,
CONGRUENCE.md, checks/z_map_full.json 4bfab5cb…, checks/skeleton_cancellation.json
9aa537fe…, checks/exact_ring_checks.json 0fa61d6f…, moje checkery 2/3.

## B — source error: OPEN (uczciwie, z liczbą)
Składnia outward dokładnie przeliczona (mój checker 1): **6086.4007616… ≥1/2**,
dominanty B_wordres 4489.9 / C1 1078.7 / A2 332.5; luźne trasy 887.0/1165.4/160471/
3.681e9 zachowane. Brak ciasnego boundu to brak dowodu, nie dowód nieistnienia
ciasnego boundu ani witness przeciw równości. Dokładny missing type (SOURCE_ERROR §3):
residualy stored words ~2^-52 (eps_fg 3.32e-13, eps_FG 6.80e-10) + (δ,eroot)≲4e-5
+ ηt≲3.18e-8 z transportem korelacyjnym 3072 defektów (sam box C2=3.0>1/2).
Nie wykonywałem tranche B-gap za autora. Evidence: SOURCE_ERROR.md/.json,
ERROR_LEDGER, checks/gap_composition.json 1a3ab196…, mój gap JSON fbdad760….

## C — rounding-gap: lemma POTWIERDZONE, zastosowanie WARUNKOWE od B
15 twierdzeń Lean w 2 modułach (9+6), czyste logi (a8ecbbca…/93dd2972…), aksjomaty
[propext,Quot.sound], bez sorry/admit/native_decide/ofReduceBool/aksjomatu celu/
supresji. Orientacja tie poprawna (nieparzyste v⇒v+1, parzysty sąsiad), oba znaki
i ±0 przez T∈Z. Kontrole: **20110 różnych fixture words vs 60384 wykonań**
(20128/tryb × normal/ASan/UBSan, byte-identic 481b76c6…, stderr puste 0 B,
preflight ex≤1072) vs niezależny QQ oracle 0 mismatch (a0dec47e…); osobno 1078
cases modelu (880 strict/198 tie) — inny zakres niż 60384; mutacje meaningful
wykryte, no-op czyste. Skończone kontrole to kontrola uniform lemma, nie zastępstwo.
Evidence: formal/RintGap.lean, logs/06/07, checks/c_slice/, checks/gap_composition rint_tie.

## D — consumer warunkowy: ZAKRES POTWIERDZONY
`recovery ∧ joint Safe16 ⇒ stored pair=v_ref ⇒ congruence` z zachowaną kolejnością
wide-rint/narrow16/stored-norm; Safe16 nie wywiedzione ze stored norm
(POST precast.Safe16_proved=false); lokalny kontrprzykład center_q/A2-cross-term
(4.6→8.6) poprawny i jawnie lokalny (nie witness przeciw Sign→Verify);
center/norm/bytes otwarte. Flagi whole_Sign/real_PRNG/security/retry/Sign_to_Verify=false,
new_M0_eta_pre=null, source_changed=false, owner_accepted=false.
Evidence: ROUNDING_RECOVERY.md, VERIFY_NEXT_INTERFACE.md, COUNTERMODELS.md.

## Port/proweniencja: rozliczone, z dwoma uwagami low (podtrzymuję prior)
- v3→v4: 5 wyników checks z nowymi hashami (wszystkie z obu hashy + py_* kopiami);
  17 dawnych ścieżek zmienionych/nieobecnych + 24 nowe (z OUTPUTS_v3 daf45e8a… vs v4).
  Stare receipty to historia, nie dowód nienaruszenia freeze (autor ich tak nie używa —
  receipts rozdzielone fresh_replay vs fresh_replay_sage). Poprawność v4 i proceduralna
  v3→v4 osobno: v4 poprawne w PARTIAL; v3 zmienione, nie „nietknięte”.
- UWAGA low/wording: „3 należące do freeze v3” — manifest v3 zawiera wszystkie 5
  regenerowanych plików; poprawnie: 5.
- UWAGA low/wording: „tabela Z bajtowo identyczna (3072 wierszy)” — identyczne wiersze
  (niezależnie: rows identical True), całe pliki różnią się metadanymi engine
  (eac0808a… vs 4bfab5cb…). Granica wiersze-vs-plik sprawdzalna z obu hashy.
- Fixtures MT→LCG i usunięty tie_odd_case (=0, schema-only): rozliczone, werdykty zgodne.
  Enclosures: 12 różnic wyłącznie reprezentacją, obie outward (mój gap checker).
- Poprzednia recenzja: matematyka zgodna, ale binding 3 checkerów mismatch
  (exec vs sealed) — ocenione osobno w PRIOR_REVIEW_ASSESSMENT.md; nie polegam na nich.

## Co rzeczywiście odebrać i następny krok
Odebrać dokładnie ten PARTIAL: niezależną integralną referencję + mapping 3072 +
kongruencję (A), lemma rounding-gap z tie/parity (C-lemma), warunkowego consumera (D)
— przy otwartym B-gap ≈6086.4 (brak uniform <1/2), Safe16, center/norm compatibility
i bytes. Poprawki review nie są wymagane do tego werdyktu (dwie uwagi low do jednej
linijki portu + model-diversity do decyzji właściciela); właściwy missing type to
certyfikat B-gap z SOURCE_ERROR §3 — bez automatycznego startu.
Własne obliczenia zakończone; joby zakończone; owner_accepted=false.
Nie uruchamiałem Astry/dudect/relay/publikacji/Git/importu ani nie zmieniałem pakietu.

W: /home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002
Sage: a27021f011fa0b6ae5b899dcc0c615c2a9f2fa8da0a0719ce9d7b27d381575cd,
2ae23ed2ce48fc7b767dd56b1c0434e7aecbde2ce8e0d322383c493b8c134b48,
759c11b76afe9262d939065f0392e50be566cc0bb3a5ed474b3f4b53b62ffb91.
Outputs: fbdad76031e2e900737e73f0fdecdafebeffa5cc8e6bdedc7876d13772b7a00e,
2c20bb0ab22439cd513b890ba8ca0c441477f5541ecadd38c02420c2a1f3106f,
a5d41d7cbe09b5caf1ea781ddd6cb171ee3bfefa1052831b906c1302fdfc1f59.
