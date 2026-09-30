# FT1536_T5_FLAT_REJECT_RUN_001

Jeden wykonawca wybrany i uruchomiony przez właściciela. Osobne W,
bez subagentów/relay i bez systemowego tmp/tmpfs. Wszystkie zapisy
wyłącznie pod W w repo.
REPO=/home/footfalcon/free_falcon_sign
W=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_T5_FLAT_REJECT_RUN_001
TASK=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_T5_FLAT_REJECT_RUN_001/TASK.md
TASK SHA=09d60050d7f65f6e0d85747f7c51e1c17f5f963a271d04880f3e4459ce8c7060
BASE=5992d48416496020b51dab183982698def65a425

ROADMAP_ID=T12.1 (ciąg dalszy toru matematycznego); STATUS=READY_OWNER_START.
CURRENT_TASK=/home/footfalcon/free_falcon_sign/proofs/ft1536/CURRENT_MATH_TASK.md
RUN=W/run; OUTPUT_DIR=W/output; devlib=W/run/devlib (pełne closure Run2, 124 olean).
LIB (współdzielone)=proofs/ft1536/work/B20_001/P01/bootstrap/mathlib4.

Jedno zlecenie: T5 → flatness/rejection dla wszystkich successfulKeyGen
(TASK.md §1-2). Jedna sesja i końcowy handoff; brak administracyjnych
odbiorów po każdym lemacie. Nie powtarzać zamkniętych dowodów z RUN_002
(TASK.md §3).

Zależności READ-ONLY (nic nie modyfikować):
- dep/run2_formal → RUN_002/run/formal (źródła Run2; importy rozwiązywane
  przez oleany w run/devlib),
- dep/run2_WORK_STATE.md → RUN_002/WORK_STATE.md (stan, piny, lekcje),
- dep/run2_B_CERTIFICATE_PACKAGE.md → pakiet (b),
- inputs → RUN_002/inputs (kontekst T5, MANIFEST).
W poprzedników (RUN_001) i B20 nie modyfikować.

Lean4+Mathlib kernel; rachunek sage <nazwa>.sage (exact ZZ/QQ; real
balls przez rygorystyczne Arb). Historyczny przegląd Astry Pro jest
materiałem do formalizacji, nie zastępuje świeżego sprawdzenia kernela.

Twarde zasady dowodowe: bez sorry/sorryAx/admit/native_decide/
Lean.ofReduceBool; `-DwarningAsError=true` (runner); czyste logi;
higiena instancji w każdym module sądowym (`attribute [-instance]` —
patrz run/LEAN_INSTANCE_HYGIENE.md); rytm procesów i kontrola tła wg
ustaleń właściciela dla tej sesji.

Uczciwe raportowanie: rozróżniać brak dowodu / zbyt luźne oszacowanie /
zakres poza zadaniem; nie ogłaszać freeze; po etapie wpis w WORK_STATE.md
i krótkie podsumowanie dla właściciela po polsku.

Bez Git/push; import/commit wyłącznie przez właściciela lub koordynatora.
