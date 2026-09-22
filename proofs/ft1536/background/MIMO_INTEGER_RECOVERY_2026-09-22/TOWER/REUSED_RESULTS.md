# Reuse i dokładne granice upstream

Bootstrap MANIFEST9bd79a0179910af92457ce6db5419aa859017499a79c575fb8256b5bfc92d7a1:
137 członków,135 publicznych ORIGINS. INPUTS/provenance ma141 records z
TASK/AGENTS/manifestem. Oryginalne OUTPUTS/VALIDATION zachowują własne bazy.

| Wynik | Pin / konsumpcja |
|---|---|
| NODE2 REPORT | ff405298926bcb2f75e15f9fb4577d76dea524b38071d9e652e4ac80969a2aba; przyjęty pierwszy binary level |
| NODE2 OUTPUTS | 5601c991b2b27b639ff57708ed3d82fb4f167a25a156e886d7a9fb0bf0eacbf6; projekcja i proweniencja |
| NODE2 NEXT_INTERFACE | 0f05306a0b5680ec9ef2e1e25a8e8ccdce4150e8c235626ebbbc452252385029; dokładny level7 |
| NODE2 UPSTREAM_REFINEMENT | 040975e5653d79e82eb3584a1732791931ca890302c6dfbeb33a30ee3a5da742; root imag<1 i NODE3 wspólne tau |
| NODE2 Half.lean | 685bb4bacd1cd92e3f53953f50e63097d7c646c3468667471def2f4c5c0e91ee; all-finite half bound, e0/e1/raw classes |
| NODE2 ANALYTIC_PROOF | 188f532df7c2706cdd53066bccfdf70975e9bd3c2795a4be8a5b1ca3a0e6b0d0; paired identity, local source-to-H errors |
| NODE3 ANALYTIC_PROOF | 181cbabf6f2648cd241cc482fad7519dd9068465675227299faaa667d434116e; pointwise64U*h/65536U*h errors, cubic unitary comparison |
| ROOT ANALYTIC_PROOF | e2caa8b9d7996a241bee2e6bb8a478eadf031279860cdaf586daa3473ed69ef7; actual root real bounds, primitive domains, exact reference maxima |
| ROOT emitted/frame | pełne piny w MANIFEST; unchanged P_key/same decode i chronological source buffers |
| review/VALIDATION | 0ffdd46f3ac99c333518c171548d6d1de851c0c868787affeddf9b4a38fea7dc; niezależny odbiór NODE2 |

U=2^-48,eta=2^-900,scalar cap2^100 i div[1/16,2^35] są konsumowane tylko po
udowodnieniu aktualnych operands/domain. Stare coarse c2 nie są iterowane:
nowy INIT i silniejszy d11 transfer mają własny dowód w INDUCTION.
Nie zmieniono wcześniejszych certyfikatów i nie powtórzono całego KeyGen/
FFT/NTT zadania. Legacy complete-IEEE/leaf normalization nie są przesłankami.

24 konsumowane inherited Lean sources są byte-identical i przebudowane,
bez olean/cache/bin. Helpery backend/fp_literal/half/dyadic/root/node3/node2/
fixtures/lean/replaylib/toolchain/check_lean_values mają piny w reuse.json.
Działają w nowym cwd; historyczne kontrolery nie są uruchamiane w bootstrapie.
Nowe kontrolery mają jawne diffs i piny do odpowiednich NODE2 poprzedników.

Nowe TowerShape/Order/Margin/Execution wspierają structured proof, ale nie
ukrywają analitycznych upstream contracts w aksjomatach. Source/error/full
actual recursive composition jest mixed proof. Aktywny FPEMU_AUDIT nie
był czytany, importowany ani uruchamiany i nie jest zależnością replayu.
Global assembly/normalization/targets/Reach/law zachowują status OPEN.
