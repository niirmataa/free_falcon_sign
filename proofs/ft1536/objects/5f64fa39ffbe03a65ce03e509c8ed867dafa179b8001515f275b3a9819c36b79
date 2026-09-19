# Niezależny odbiór H3_NODE2 — 2026-09-19

**PASS: H3_NODE2_PROVED_FOR_PINNED_MODEL**, dokładnie dla pierwszego poziomu
SplitDeep(logn9) → Adj → LDL_dim2(logn8,full0), sześciu grup i 128 pozycji każdej.
Zakres pozostaje mieszany: kernel Half i lematy, analityczna kompozycja
źródłowa oraz dokładne QQ/RBF certificates.

Baza odbioru: `9533f5ddba4020f82849be21d6960c6416b49f6b`.
REPORT: `ff405298926bcb2f75e15f9fb4577d76dea524b38071d9e652e4ac80969a2aba`.
OUTPUTS: `5601c991b2b27b639ff57708ed3d82fb4f167a25a156e886d7a9fb0bf0eacbf6`.
Import potwierdził 817 członków OUTPUTS i 124 publiczne records INPUTS.

## Niezależny replay

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_NODE2_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Świeża kopia, bez wcześniejszych olean/bin/cache; Dokumenty/H ukryte,
sieć odłączona, zapis tylko w kopii roboczej. Exit0, 39.544 s,
**160/160 plików znaczeniowych zgodnych** z zamrożonym receipt.

- 26 modułów Lean4.34/Std, 131 twierdzeń (16 nowych), pełne czyste logi;
  19 odziedziczonych modułów identycznych z NODE3, przebudowanych.
- C normal/ASan/UBSan: 2×3×128 pozycji i 6144 raw output words, native parent
  dumps, 98 half boundary words, 768 root-imag controls, trzy inner8 frame cases.
- Post-half subnormal control: s0.imag raw1, późniejszy d11.imag raw0,
  zgodność C/model. QQ/RBF oracle: 768 cases, 3072 complex outputs.
- Mutacje, no-op, canaries i preflight invalid divisor; osobny jawny
  coarse-box countermodel z legalnym pierwszym dzielnikiem.

[Execution](execution.json), [review checks](review_checks.json),
[formal audit](artifacts/formal_audit.json), [replay result](REPLAY_RESULT.json).
Wszystkie streams wskazane przez receipts/drivery sprawdzono hashami i
zachowano. [VALIDATION.sha256](VALIDATION.sha256) obejmuje 198 plików;
SHA-256: `0ffdd46f3ac99c333518c171548d6d1de851c0c868787affeddf9b4a38fea7dc`.

## Przegląd twierdzeń i ich granic

Przejrzano [ANALYTIC_PROOF](../../stages/FT1536_H3_NODE2_RUN_001/ANALYTIC_PROOF.md),
[UPSTREAM_REFINEMENT](../../stages/FT1536_H3_NODE2_RUN_001/UPSTREAM_REFINEMENT.md),
[NODE2_FRAME](../../stages/FT1536_H3_NODE2_RUN_001/NODE2_FRAME.md), Half.lean,
powiązanie ze źródłem i exact certificates. Piny są w review_checks.

1. Nowy root imaginary bound porównuje actual Lroot z c0/a0 tych samych
   computed operands: Im(c0*conj(c0/a0))=0. Div/muladj/neg/add i correlated
   Gram bounds dają |Im(D_ROOT_C)|<8U*j<1. Nie użyto całego real Schur error.
2. Nowe NODE3 imaginary bounds wykorzystują wspólne tau i silniejsze
   source-to-H relations: branch0 (0,1/262144,1/262144), branch1
   (17/16,545/512,545/512). Historyczne certyfikaty są niezmienione.
3. Half.lean kernelowo dowodzi bitów/fields/value/error. Interpretacja
   dotyczy finite words; e0→raw+0, e1 może dać subnormal, e≥2 daje exact x/2.
   Błąd wartości ≤2^-1023 nie jest założeniem pełnego IEEE half.
4. Paired determinant zachowuje `(tau_a-tau_b)^2`. Margin i primitive
   domain są wyprowadzone przed division; późniejszy pivot nie uzasadnia
   własnych wcześniejszych instrukcji. Po half nie zakłada się raw-preservation.
5. Frame dotyczy defined prefixes i właściwych momentów odczytu/scratch reuse.
   Totalność wcześniejszej i niższej rekurencji pozostaje osobną kompozycją.

| Eksport, wspólny dla k=0,1,2 | Branch0 | Branch1 |
|---|---|---|
| Re(s0) lower / upper | 1/16 / 2^26 | 4 / 2^35 |
| Re(d11) lower / upper | 1/32 / 2^27 | 2 / 2^36 |
| abs Im(s0),abs Im(d11) | ≤1/8192 | ≤9/8 |
| Norma L | <2 | <2 |

Pełne c2/error bounds: [NODE2_CERTIFICATE.json](NODE2_CERTIFICATE.json).
Para 9±34i daje ujemny source pivot i jest wyłącznie kontrmodelem dawnych
niezależnych przedziałów. Nie wykazano dla niej P_key/emitted membership;
nowy refinement wyklucza ją z badanej dziedziny bez zmiany P_key lub C.

`full_node2_theorem_kernelized=false`: upstream refinement i complex source
composition są analityczne, a nie pełnym theorem C/GCC. Skończone kontrole
i odtworzenie tekstu nie zastępują tej warstwy argumentu. Level7–1, cała
kompozycja internal tree, initial targets, global Reach i sampler law są
otwarte. Odpowiadające flagi oraz security_reduction_proved pozostają false.
Odbiór nie nadaje owner acceptance i nie zastępuje odrębnego audytu FPEMU.

Przypięte kopie, slices i surowe logi zachowano bajtowo; nową dokumentację
sprawdzono osobno od whitespace w zamrożonych artefaktach.
