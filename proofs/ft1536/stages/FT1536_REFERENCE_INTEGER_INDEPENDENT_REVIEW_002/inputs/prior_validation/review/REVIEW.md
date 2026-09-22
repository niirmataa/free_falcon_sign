# Niezależny odbiór T03 — REFERENCE_INTEGER_RECOVERY

REVIEW_ID=FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001. Recenzent niezależny,
wybrany i ręcznie uruchomiony przez właściciela (model: Muse Spark 1.3 Free).
Autor projektu: Niirmata; Falcon Project / Thomas Pornin attribution zachowana.
SOURCE_W (RO): `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001`.
Werdykt: **PASS_SCOPED_REVIEW** — wyłącznie zadeklarowany zakres PARTIAL_PROOF.

## Integralność (niezależna, nie receipt autora)

- REPORT `e01a0978…7785c`, OUTPUTS `0cafdbb2…57b7df6de`, TASK `bbd1f59e…6169`,
  bootstrap MANIFEST `c9695c80…107a0e2b`, CANDIDATE `56974571…a0985`,
  POLICY `b6afcdca…e241` — wszystkie zgodne przed i po moim replayu.
- OUTPUTS: 85/85 członków, 0 traversal/symlink/duplikat/mismatch.
- INPUTS: 29 rekordów = 28 istniejących ścieżek (wszystkie zgodne) + alias
  `TASK_DOCUMENT_provenance` (plik literalnie nie istnieje w SOURCE_W; jego hash
  = kanoniczne TASK). Nie raportuję 29/29 literalnych ścieżek. Własny seed ma
  jawną kopię transportową aliasu z notą receipt; manifestu autora nie poprawiano.
- Bootstrap: 1275/1275, source17 bez rozbieżności. Zamknięcie: 85 outputs + 29
  INPUTS to nie samowystarczalna kopia — import wymaga closure bootstrapu.
- Postfreeze autora (`tmp/postfreeze-003`): SAGE_RUNS `0445a721…`, fresh_replay
  `b62c222e…`, REPLAY_RESULT `b7fa9690…` — zgodne; to zapisana historia, nie mój
  replay. Szczegóły: INTEGRITY.json.

## Mój świeży replay (nie receipt autora)

- `python3 -B seed/scripts/replay.py REVIEW_W/seed/tmp/independent-001 0cafdbb2…`,
  bwrap net-off, SOURCE_W ukryte RO-pustym katalogiem, świeży cache/build/Lean,
  HOME/TMPDIR/XDG/DOT_SAGE pod REVIEW_W, single-worker, Lean `-j1 -M2048`.
- Wynik: **FRESH_REPLAY_PASS 11/11, exit 0, ~12 s** (mały 11-plikowy pakiet;
  limit 1800 s). SAGE_RUNS odzwierciedla mój run (4 × `sage …sage`, v10.9).
- Bajty 11/11 identyczne z SOURCE_W niezależnie od napisu PASS. COMMANDS.log
  zachowany w seed (członek manifestu); replay.py nie otwiera go (tylko
  docstring) — roszczenie o odtwarzaniu z pustym dziennikiem jest prawdziwe na
  poziomie logiki, a pieczęć manifestu chroni go przed cichą zmianą.
- Outer stderr puste; runner scala stdout+stderr każdego kroku do
  `DEST/logs/r*.log` (wszystkie niepuste, z rzeczywistym przeliczeniem) —
  nic nie zaginęło. Pierwsza próba przeszła; brak ukrytych failed attempts.
- Bez importu do stages, bez Git/push/relay/subagentów/KeyGen/secrets/pełnego
  Sign/seeded PRNG/sieci/instalacji. Obok pracował job T02.1 w innym W
  (nie T03); mój replay jedno-workerowy, bez kolizji. Szczegóły: REPLAY_CHECKS.json.

## Mój Sage (POLICY: `sage lemma.sage`, preparser, ZZ/QQ/RIF256)

- Trzy nowe autorytatywne checkery (źródła w `sage_checks/`, wykonane
  `sage sage_checks/*.sage`, SageMath 10.9, preflight `ZZ/QQ/2^10`):
  1. `review_gap_recompute.sage` (SHA `8357f942…`) — dokładna rekompozycja QQ:
     TOTAL = suma składników, float 6086.40076…, gap_met=false; 16/16 terminów
     portu zgodnych w float ≤1e-9 rel, 12 różnic exact wyłącznie reprezentacją
     (obie strony outward, bound²≥p sprawdzone); tie 880/198; progi w tym
     etaT == 1/31457280. PASS, exit 0.
  2. `review_zmap_bijection.sage` (SHA `ebdb6208…`) — 3072 wiersze, bijekcja
     (sloty a/b po 0..1535 dokładnie raz), znaki +1, kolejność root-prawy /
     cubic 2→1→0 / terminal mu1→mu0; wiersze identyczne z py, całe pliki różnią
     się tylko metadanymi (`engine`). PASS, exit 0.
  3. `review_ring_independent.sage` (SHA `7cf23506…`) — świeża instancja
     (LCG 987654321, nie fixtures autora): det/h/ring/congruence/target.
     PASS, exit 0 (3 s).
- Cztery `.sage` autora to rzeczywisty rachunek (preflight, ZZ/QQ, RIF256 +
  exact `bound²≥p`, jawne `int()` po konwersji Sage→JSON); Python organizuje
  wykonanie. Równość przybliżeń float nie była mylona z równoważnością
  certyfikatów — rekord portu trzyma obie reprezentacje outward.

## A — referencja i mapping: scope POTWIERDZONY

v_ref=[c,0]−Z(Y)B niezależne od source output; mapping 3072 (signed permutation,
kolejność literalna root-prawy/cubic-2→1→0/binary-prawy/terminal-mu1→mu0,
merge out[2i]/out[3i+c], znaki +1); exact cancellation (E1/E1b/E2 + kernel
per-slot Int); integrality + kongruencja v1+h·v2=c z h tego samego klucza
(klucze z niejedynkowym f, hf−g=q·k≠0). Granica jawna: kernel per-slot,
merge/placement w checks (mixed, nie kernelizacja C/kompilatora); klucze
syntetyczne bez Emitted membership. Bijekcja 3072 nie zastępuje argumentu
uniform — uniformność wynika z konstrukcji placementu + tożsamości, nie z
samej tabeli.

## B — source error: OPEN (uczciwie, z liczbą)

Składnia outward dokładnie przeliczona (mój checker 1): **6086.4008 ≥ 1/2**,
dominanty B_wordres 4489.9 / C1 1078.7 / A2 332.5; luźne trasy zachowane
(887.0 / 1165.4 / 160471 / 3.681e9). Brak ciasnego boundu to brak dowodu, nie
dowód nieistnienia ciasnego boundu ani witness przeciw równości. Dokładny
missing type: residualy stored words ~2^-52 (ε_fg ≲ 3.32e-13, ε_FG ≲ 6.80e-10)
+ (δ,eroot) ≲ (3.3e-6,3.7e-5; delta-floor 0 bo sam eroot przekracza udział) +
ηt ≲ 3.18e-8 z korelacyjnym transportem 3072 defektów (sam box C2=3.0
przekracza 1/2). Nie wykonywałem tranche B-gap za autora.

## C — rounding-gap: lemma POTWIERDZONE, zastosowanie WARUNKOWE od B

15 twierdzeń Lean w 2 modułach, czyste logi, aksjomaty [propext, Quot.sound],
bez sorry/admit/native_decide/ofReduceBool/aksjomatu celu/supresji. Orientacja
tie poprawna (nieparzyste v ⇒ v+1, parzysty sąsiad), oba znaki i ±0 przez
T∈ℤ. Kontrole: **20110 różnych fixture words vs 60384 wykonań** (20128/tryb ×
normal/ASan/UBSan, byte-identic, stderr puste, preflight ex≤1072 przed native
call) vs niezależny oryginał QQ — 0 mismatch; osobno 1078 cases modelu
(880 strict/198 tie) — to inny zakres niż 60384; mutacje meaningful wykryte,
no-op czyste. Skończone kontrole to kontrola uniform lemma, nie zastępstwo.

## D — consumer warunkowy: ZAKRES POTWIERDZONY

`recovery ∧ joint Safe16 ⇒ stored pair=v_ref ⇒ congruence` z zachowaną
kolejnością wide-rint/narrow16/stored-norm; Safe16 nie wywiedzione ze stored
norm; lokalny kontrprzykład center_q/A2-cross-term (4.6→8.6) poprawny i
jawnie lokalny (nie witness przeciw Sign→Verify); center/norm/bytes otwarte.
Flagi: whole_Sign/real_PRNG/security/retry/Sign_to_Verify=false,
new_M0_eta_pre=null, source_changed=false, owner_accepted=false.

## Port/proweniencja: rozliczone, z dwoma uwagami low

- v3→v4: 17 dawnych ścieżek zmienionych/nieobecnych (13 zmienionych + 3
  przeniesione skrypty + replay.py), 24 nowe, 5 wyników checks z nowymi hashami
  — wszystko z obu hashy + zachowanymi py_* kopiami; stare receipty to historia,
  nie dowód nienaruszenia freeze (autor ich tak nie używa — receipts rozdzielone
  fresh_replay vs fresh_replay_sage). Ocena poprawności v4 i ocena proceduralna
  v3→v4 osobno: v4 poprawne w zakresie PARTIAL; v3 zmienione, nie „nietknięte".
- UWAGA low/wording (PROVENANCE_AND_PORT.json): „3 należące do freeze v3" —
  manifest v3 zawiera wszystkie 5 regenerowanych plików; poprawnie: 5.
- UWAGA low/wording: „tabela Z bajtowo identyczna (3072 wierszy)" — identyczne
  są wiersze; całe pliki różnią się metadanymi `engine`. Granica wiersze-vs-plik
  sprawdzalna z obu hashy.
- Fixtures MT→LCG i usunięty `tie_odd_case` (=0, schema-only): rozliczone,
  werdykty zgodne. Enclosures: 12 różnic wyłącznie reprezentacją, obie outward.

## Co rzeczywiście odebrać i następny krok

Odebrać dokładnie ten PARTIAL: niezależną integralną referencję + mapping 3072
+ kongruencję (A), lemma rounding-gap z tie/parity (C-lemma), warunkowego
consumera (D) — przy otwartym B-gap ≈6086.4 (brak uniform <1/2), Safe16,
center/norm compatibility i bytes. Następny krok: poprawki review nie są
wymagane do tego werdyktu (dwie uwagi low do jednej linijki portu); właściwy
missing type to certyfikat B-gap z SOURCE_ERROR §3 — bez automatycznego startu.
Własne obliczenia zakończone; joby zakończone; owner_accepted=false.
Nie uruchamiałem Astry/dudect/relay/publikacji ani nie zmieniałem pakietu.
