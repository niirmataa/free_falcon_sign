# Do świeżej sesji GPT-6.1 Sol — VARIANT max (dostosowane 2026-09-30)

Rozpocznij niezależny audyt **FT1536_SOL61_DEVELOPMENT_T03_AUDIT_001**.
Projekt Niirmata/free_falcon_sign; zachowaj Falcon Project/Thomas Pornin i licencje.

```
REPO=/media/footfalcon/FT1536_DATA/free_falcon_sign
W=REPO/proofs/ft1536/work/FT1536_SOL61_DEVELOPMENT_T03_AUDIT_001
TASK=W/TASK.md
TASK_SHA256=65b7e63b15a8810774bb0a5e2d92a6af3ddf0e53aad3af15a6ef1fc5c9056191
INPUT_MANIFEST_SHA256=c7ca6aa42abc2885259618cf20712744284d2698e8cbd6aa97b3abc3634f5a5e
INPUT_BINDING_SHA256=1e31bfbadbcaec67df410b47cfa79b409076278e35a00481afc0515d24556232
ROADMAP_ID=T12.1/T5 oraz T03-B
MODEL=openai/gpt-6.1-sol
VARIANT=max (zapisz rzeczywiście uruchomiony wariant)
```

Czytaj AGENTS, START_HERE, STATE, CURRENT_SOL61_AUDIT_TASK oraz własne
AGENTS/TASK/HANDOFF/INPUT_BINDING/PATH_RESOLUTION_SUPPLEMENT/REPLAY_RUNBOOK.
Sprawdź ownership, piny i procesy; zapisz rzeczywisty model/variant,
session ID oraz UTC. Jeden audytor, świeży kontekst.

## 0. MIARA KOŃCOWEGO TWIERDZENIA (dodane 2026-09-30 — czytaj przed oceną)

Właściciel zatwierdził w dniu audytu wiążący **kształt tezy docelowej
i drabinkę implikacji** w
`proofs/ft1536/development/T12_1/END_TO_END_SCOPE.md` (pin: commit
1ec29f7b; jeśli HEAD jest późniejszy, zapisz drift i odnoś się do
zpinowanego). To jest miara, wobec której oceniasz „brakujące połączenia":

- teza docelowa: `AdvEUF <= min{1, eps_coll^cond + Phi((1+e^cond)^q_s - 1,
  AdvMT)} + Adv_PRG(ChaCha20)` — dla prawa klucza WARUNKOWEGO i realnego
  PRNG (trasa (b), zapisana);
- decyzje modelowe D1–D3 z doprecyzowaniami D1 (warunkowanie per-attempt,
  ranga A1 = założenie nośne jak PRF, strażnik próżności `1/p_accept`);
  **sprawdź te doprecyzowania jako przesłanki końcowego twierdzenia**;
- jawne założenia A1–A5 i drabinka brakujących implikacji **B1–B5**
  (B1 = source3/KEYGEN_SOURCE_TO_FIBER_001, B3 = BINBIND/FftBind,
  B4 = certyfikat `LocalJointCertificate S e`, B5 = montaż
  `ConcreteReduction`). Wymagane: mapuj FINAL_THEOREM_AUDIT, FINDINGS
  i MISSING_TYPES **na szczeble B1–B5** — potwierdź drabinkę albo wskaż
  sprzeczności; sprzeczność wobec kształtu tezy jest findingiem do decyzji
  właściciela, nie cichym przedefiniowaniem zakresu.
- żywy kontrakt B1 dla Astry (ten sam dokument scope, sekcja cross-lane):
  przy ocenie source3 traktuj go jako zamówiony interfejs (predykaty pętli
  prób jako punkt zaczepienia dla `p_accept`).

**Świeżość pinów:** snapshot development obejmuje 523 pliki i może
poprzedniać wieczorne commity 2026-09-30 (łańcuch wieży A2 w ConvStruct,
END_TO_END_SCOPE, prompt B1). Przed audytem wykonaj ponowne przypięcie do
aktualnego HEAD (integralność ponów) ALBO zapisz dokładny zakres driftu
(commity od snapshotu) i ogranicz werdykt do pinów z jawną adnotacją,
które szczeble drabinki w ogóle wchodzą w snapshot.

## Główny cel

Oceń całe przypięte development — run2/source3/t5 i potrzebne
archiwalne źródła — jako jedno końcowe połączenie dowodów. Sporządź pełną
mapę wersji/importów/producers/consumers, sprawdź realne zastosowania
eksportów, końcowy typ z zasobami i wszystkie pozostające premises.
Brakująca krawędź ma dostać dokładny typ i lokalizację, nie assumed-small
premise. Własny IntegrationAudit.lean i clean replay efektywnej closure.

## Drugi cel

Własny audyt T03-B/REFERENCE_INTEGER_RECOVERY_RUN_002:
15 algebra-only identities, 10-termowy ledger, old-target eadd1643,
warunkowe liczby i rzeczywiste brakujące source interfaces. Pełny autor
jest w inputs/t03. T03 ma już starszy scoped PASS; nie przyjmuj go jako
przesłanki i nie promuj do recovery. Późniejszy P02/V02 scope jest przypięty.

Snapshot zawiera 3669 plików/348698480 B, w tym 523 pliki development.
Siedem repo-relative źródeł w pierwotnym bindingu miało błędną bazę ścieżki;
supplement wiąże je z już obecnymi, zgodnymi bajtami, bez zmiany manifestu.
source3 jest IN_PROGRESS; datowane CURRENT/README mogą być starsze.
Zapisz snapshot/current drift; końcowy werdykt dotyczy konkretnych pinów.

Wykonaj własny fresh replay, własne Sage 10.9 przez `sage nazwa.sage`,
Lean 4.34+przypięty Mathlib i potrzebne literal C controls
normal/UBSan/ASan. Zachowaj pełne source/argv/exit/raw log/result bindings
oraz failed attempts. Stary cache własnych modułów lub historyczne receipts
nie są własnym replayem.

Wszystkie zapisy wyłącznie pod W, inputs RO, network-off i limity TASK.
MIGRATION_HOLD obowiązuje: audyt nie uruchamia migracji/scalania live
źródeł. Bez Git/push, innych modeli/subagentów/relay, przejmowania aktywnych
autorów, KeyGen/private loadera/pełnego Sign/nowych sekretów.

Oddaj jeden frozen handoff w W/output: AUDIT.md/AUDIT_RESULT.json,
DEVELOPMENT_REVIEW, T03_RUN002_REVIEW, INTEGRATION_MAP, FINAL_THEOREM_AUDIT,
FINDINGS, MISSING_TYPES, COVERAGE, REPLAY_RESULT i pełne evidence według TASK.
Osobno audit_verdict i integration_verdict. Mapowanie na B1–B5 (patrz §0)
w FINAL_THEOREM_AUDIT i MISSING_TYPES jest obowiązkowe. Podaj pełne SHA256
AUDIT.md/AUDIT_OUTPUTS.sha256, po polsku co się rzeczywiście łączy i co
blokuje końcowy claim. Zakończ własne joby; owner_accepted=false.
