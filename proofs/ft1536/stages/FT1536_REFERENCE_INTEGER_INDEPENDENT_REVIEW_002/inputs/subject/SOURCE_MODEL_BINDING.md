# SOURCE_MODEL_BINDING — wiązanie modelem źródłowym

- Piny: source 17 (CANDIDATE 56974571…), bootstrap MANIFEST c9695c80…,
  TASK bbd1f59e… — zweryfikowane exact (logs/01).
- Literalna semantyka wejściowa: falcon-sign.c 1563–1934 (ffSampling_fft3/
  depth1/inner, terminal, do_sign suffix), falcon-fft.c merge/split (konwencje
  placementu), fpr-emulated.h 99–115 (rint). Cytowania wierszy w EXACT_SKELETON/
  ROUNDING_RECOVERY.
- Silnik rachunku: SageMath 10.9 przez `sage lemma.sage` (checks/sage/*.sage,
  preparser wg zasady 2026-09-22; port z v3 `.py`/fractions z diffem i zgodnością
  certyfikatów: checks/sage/PORT_PY_TO_SAGE.md/.json, każdy mismatch zachowany).
- Lokalne wykonanie source: checks/c_slice (fpr-emulated.c + harness) normal/
  ASan/UBSan — wyniki byte-identic vs niezależny oryginał Fraction/QQ;
  domain preflight (ex ≤ 1072) przed native call.
- Zakotwiczone pinami, nie przeliczane: tapes JOINT (3147/6219 proposals),
  suite rint POST (32224 cases), recurrence LEFT/H6P, FFT error ROOT.
- Modelem nieobjęte/założone: exact-real skeleton z actual L jako fixed
  constants (dozwolone TASK §3); recomputed products bitowo równe (JOINT
  equal-word frame, read-time operands); FPEMU rounding semantics zgodne z
  pinned refinement (nie blanket IEEE).
- Fixtures są syntetyczne (brak Emitted membership); nie są używane jako
  uniform bound ani jako witness wymaganej domeny.
