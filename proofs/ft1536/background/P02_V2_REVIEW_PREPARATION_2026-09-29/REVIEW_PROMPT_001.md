# V02 — Słowa maszynowe i kontrakty FPEMU powiązane z C — niezależna weryfikacja

Autor projektu Niirmata. Pakiet B20_001, rewizja 2.
Rola: RECENZENT. ROADMAP_ID=F03–F06; formalny primitive/source binding. TASK_ID=B20_001_V02_WORD_FPEMU_REFINEMENT. Para=P02.
Nie jesteś wykonawcą dowodu. Ocenasz wynik, odtwarzasz obliczenia i szukasz luk;
nie dążysz do PASS za wszelką cenę.

## 1. Identyfikacja

```text
REPO=/home/footfalcon/free_falcon_sign
SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V02
TASK=/media/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/batches/B20_001/reviews/V02/REVIEW_TASK.md
TASK_SHA256=cfd4d2eb1e4806a6772b6013ad34a6d9d086b906a4bf9cd96f81dc1e0fa4a382
PEER_TASK=/media/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/batches/B20_001/tasks/P02/TASK.md
PEER_TASK_SHA256=9954a8b1b2a73a4f3e475ab45bb7bfe8b9a646b109a8989659a61aa933e5ef1f
```

Czytaj REPO/AGENTS.md, START_HERE, STATE i AGENT_GIT_PROTOCOL.md wyłącznie dla
orientacji; potem własny TASK, kontrakt wejść i handoff autora. Wszystkie zapisy
tylko pod W; bez systemowego tmp/tmpfs. Jeden recenzent/jeden job naraz, bez
subagentów/relay/drugiej sesji. Bez Git push, publikacji, dudect i sieci.

## 2. Zewnętrzne piny przekazane przez właściciela

```text
P02 REPORT_SHA256: ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5
P02 OUTPUTS_SHA256: af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e
P02 HEAD: 41216bb8d61004bb941a8d1b276f43346df11ce8
P02 REPORT: /media/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_P02_FREEZE_CLOSURE_RUN_001/output/REPORT.md
P02 OUTPUTS: /media/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_P02_FREEZE_CLOSURE_RUN_001/output/OUTPUTS.sha256
```

Piny pochodzą z handoffu autora. Zweryfikuj je niezależnie przed i po własnym
replayu; rozbieżność = raport, nie ciche dopasowanie.

## 3. Tezy do oceny

Zakres i wymagane eksporty definiuje proofs/ft1536/batches/B20_001/reviews/V02/REVIEW_TASK.md oraz
INPUT_CONTRACT. Na wejściu traktuj deklaracje autora wyłącznie jako deklaracje.
Oceń: kompletność eksportów kontraktu, poprawność dowodu w zadeklarowanym
zakresie (SageMath/Lean4/Mathlib, kernelowo, bez mixed-proof substytutu),
integralność OUTPUTS/INPUTS oraz świeży replay we własnym W.

## 4. Integralność i replay

Zweryfikuj pełny OUTPUTS autora (manifest + bajty), TASK, INPUTS i bootstrap;
brak traversal/symlinków/duplikatów/mismatchów. Wykonaj własny replay zgodnie
z REPLAY etapu i porównaj semantyczne pliki z zarchiwizowanym receiptem.
Wyniki nieudanych tras zachowuj — są częścią raportu.

## 5. Format odpowiedzi

- VERDICT: PASS_SCOPED_REVIEW / CHANGES_REQUIRED / INTEGRITY_FAIL /
  REPLAY_FAIL / EXECUTION_BLOCKED / BLOCKED (+ dokładny zakres)
- Binding: wszystkie piny i HEAD, które potwierdziłeś
- Replay: liczba plików semantic, exit code, czas
- Luki: numerowana lista z kontrprzykładami lub wskazaniem brakującego lematu

Oddaj REVIEW.md, REVIEW_RESULT.json, INPUTS.sha256 i REVIEW_OUTPUTS.sha256
z checkerami,receiptami i raw logs według REVIEW_TASK. Manifesty mają dokładne
ścieżki względne (bez `./`),bez samoodwołań. W REVIEW_RESULT.json obowiązkowo:

```json
{
  "review_id": "B20_001_V02_WORD_FPEMU_REFINEMENT",
  "source_task": "B20_001_P02_WORD_FPEMU_REFINEMENT",
  "source_report_sha256": "ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5",
  "source_outputs_sha256": "af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e",
  "verdict": "<rzeczywisty werdykt>",
  "verdict_scope": "<dokładny odebrany zakres i otwarte obowiązki>"
}
```

Pozostałe dowody,eksporty i pola określa TASK. Recenzja powstaje w W;
po zaakceptowaniu zakresu prowadzący importuje parę do stages i commituje na main.
