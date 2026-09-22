# T03 — suplement powiązania wykonań trzech checkerów recenzenta

2026-09-22. Autor projektu Niirmata. Zadanie dla recenzenta wybranego przez
właściciela; poprzedni odbiór wykonał Muse Spark1.3Free. Ręczny start jednego
wykonawcy,bez relay/subagentów/innych modeli. Prowadzący sprawdził wyłącznie
piny i zapisane receipty; nie wykonał nowego rachunku lub replayu.

```text
ROADMAP_ID=T03 (uzupełnienie odbioru)
SUPPLEMENT_ID=FT1536_T03_REVIEW_SAGE_BINDING_SUPPLEMENT_001
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_T03_REVIEW_SAGE_BINDING_SUPPLEMENT_001
OLD_REVIEW_W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001
V=proofs/ft1536/validation/2026-09-22-integer-recovery-independent
```

Czytaj REPO/AGENTS,START_HERE,CURRENT_REVIEW_TASK,ten prompt,V/README oraz
oryginalny REVIEW. Własne zapisy tylko pod nowym W. Stare REVIEW_W i W autora,
stages/validation/documents są RO. Nie nadpisuj zakończonego freeze.

## 1. Zewnętrzne piny

```text
Author REPORT e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c
Author OUTPUTS 0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de
Review REVIEW.md 0d9402eeef00994a54cf58fb656092501bf599b13c10a9fead7b94d2b82c6e36
Review REVIEW_OUTPUTS.sha256 9ba196b04a95ec2fa4dadda06d6dabc50c99a2313f6a370e488e9065cb423ccd
V/VALIDATION.sha256 d639ae245ace0fb2cc425710420338a5fe1baf4864c565df38d3dea0212e1e7e
Sage POLICY b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241
```

Źródła checkerów są w V/review/sage_checks. REVIEW_OUTPUTS jest zgodny z
plikami, lecz COMMANDS.log,sage_inputs_sha.txt i skróty w REVIEW wskazują
inne wersje. Pełna lista:

| Plik | Zapisany hash wykonania | Hash zamrożonego źródła |
|---|---|---|
| review_gap_recompute.sage | `8357f9426959f1c069d967248fb5a8a670f963b471f64128b0979246da2cd38c` | `c38cc42d5166cc4bd9d1a45189ff2d32029960a282d973201f8c82cd74123d73` |
| review_ring_independent.sage | `7cf23506872c86edf52018ca7cc6dcde0107ee23d425cea4a65aa45d14e38b35` | `0838dc9cab9d32cc41195508b9a631b368c4154923f60115d0dc1b7bc320c723` |
| review_zmap_bijection.sage | `ebdb6208f44b8d230a18c41377c0e2207bfa86f8e5e4d56df55d5943b0a90cf4` | `0b4406680a588308fb395e51974cee127ee70c4914d3cca224b3d55aadd8fa10` |

To konkretna luka powiązania source→execution→output; nie werdykt o błędzie
matematycznym. Oryginalny PASS_SCOPED_REVIEW zachowano. T03 ma status
REVIEW_RECEIVED_SAGE_BINDING_PENDING do rozliczenia tego suplementu.

## 2. Wyjaśnienie proweniencji

- Ustal przyczynę różnic na podstawie dostępnych zapisów. Jeśli zachowały się
  stare wersje,sprawdź ich podane hashe i zachowaj old→new diff. Odtworzona
  hipotetyczna wersja nie jest automatycznie oryginałem historycznym.
- Jeśli starych wersji lub failed logs brak,napisz to wprost. Nie produkuj
  wstecznego receiptu. Mtime ani stdout PASS nie wiążą wersji skryptu.
- Rozlicz zdanie „brak failed attempts” we właściwym zakresie: replay11/11
  versus opracowanie trzech checkerów. Zachowaj dostępne nieudane próby.
- Podaj erratę do starych hashy i zakres faktycznie wykonanych kontroli.
  Opis w REVIEW ma odpowiadać czynnościom skryptów; same sprawdzone flagi
  zaimportowanego JSON nie są niezależnym przeliczeniem ukrytego rachunku.

## 3. Trzy nowe,ściśle powiązane wykonania

1. Zweryfikuj piny oryginalnego review i jego32 członków,VALIDATION oraz
   używane inputs. Skopiuj dokładnie trzy zamrożone źródła o hashach prawej
   kolumny do nowego roboczego projektu pod W. Przypnij potrzebne wejścia
   z author stage oraz INPUT_CLOSURE; nie używaj cache/bin/olean autora.
2. Skrypty mają zakodowane absolute OLD_REVIEW_W/seed i ścieżki zapisów JSON.
   Zastosuj jawny transport przez sandbox: roboczy projekt pod nowym W
   wystaw logicznie pod OLD_REVIEW_W wewnątrz namespace. Oryginalne fizyczne
   OLD_REVIEW_W pozostaje RO/ukryte. Zapisz pełne mapowanie logical→physical
   i argv bwrap; zachowaj dokładne bajty `.sage`,bez zmieniania ich hashy.
3. Rzeczywisty rachunek wykonaj przez pinned launcher:

```text
/home/footfalcon/.local/bin/sage sage_checks/review_gap_recompute.sage
/home/footfalcon/.local/bin/sage sage_checks/review_zmap_bijection.sage
/home/footfalcon/.local/bin/sage sage_checks/review_ring_independent.sage
```

   Cwd musi być logicznym korzeniem roboczego projektu. Preparsing/cache
   i wygenerowane JSON mają powstawać fizycznie wyłącznie pod nowym W.
4. Dla każdego runu zapisz faktyczne argv (bez placeholderów),cwd,mapowanie,
   Sage version,hash `.sage` przed/po,czas start/stop,exit,raw stdout/stderr
   oraz hashe wygenerowanych wyników. Hash wejściowego `.sage` musi być
   dokładnie równy prawej kolumnie i pozostać identyczny po wykonaniu.
5. Porównaj trzy wyniki JSON z tymi przypiętymi w starym REVIEW_OUTPUTS.
   Zachowaj każdy mismatch. Jeżeli potrzebna poprawka kodu,stara wersja i
   failure pozostają,a poprawiona ma osobny plik/diff/hash/run i nowy werdykt.
   Nie zastępuj zgodności przez zmianę expected output.

Własny pełny replay11/11 jest już zachowany w V/replay; ten suplement dotyczy
trzech dodatkowych checkerów i ich raportowania. Pełny replay powtarzaj tylko
jeśli nowa zmiana/failure ujawni taką potrzebę, z jawną przyczyną.

## 4. Środowisko i wynik

Bounded single-worker,normal8GiB,wall timeout300s na checker,network-off,
jedyny trwały zapis W. HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG_CACHE_HOME pod W;
bez systemowego /tmp,/tmp/opencode,tmpfs. Bez instalacji/Git/importu/push,
KeyGen/secrets/pełnego Sign/dudect. Przy aktywnej kampanii timingowej odłóż
obciążające prace w porozumieniu z właścicielem.

Artefakty: SUPPLEMENT.md,SUPPLEMENT_RESULT.json,INPUTS.sha256,
SAGE_RUNS.json,porównanie wyników,errata/provenance,źródła/checkery,diffs,
pełne logi i SUPPLEMENT_OUTPUTS.sha256. Zewnętrzne piny oryginalnych pakietów
wpisz do wyniku. Zachowaj author PARTIAL_PROOF,B-gap OPEN,Safe16/center/norm/
bytes OPEN,owner_accepted=false. To nie nowy tranche B-gap.

Werdykt suplementu: **PASS_SAGE_EXECUTION_BINDING** dopiero po zgodnych
pinach,3 wykonaniach,związaniu wyników i rzetelnym wyjaśnieniu proweniencji;
inaczej CHANGES_REQUIRED/REPLAY_FAIL/EXECUTION_BLOCKED z konkretem.
Jeśli zmienia się ocena starego PASS,podaj to jawnie w SUPPLEMENT_RESULT.

Końcowy handoff po polsku: ID/model,werdykt,przyczyna rozbieżności,3×argv/
hash przed-po/exit,porównania wyników,errata/ograniczenia,historia failed prób,
czy stary scoped PASS nadal podtrzymany,W oraz pełne SHA SUPPLEMENT.md i
SUPPLEMENT_OUTPUTS.sha256. Zakończ joby. Właściciel przekazuje handoff
prowadzącemu; nie używaj opencode run --session lub relay.
