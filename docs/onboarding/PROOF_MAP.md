# Mapa pojęć i dowodów — czytanie na żądanie

To skrót orientacyjny, nie nowy dowód ani zmiana historycznych statusów.
Pełny katalog: [proofs README](../../proofs/ft1536/README.md).
Główna ścieżka dalszych twierdzeń i lista zadań: [ROADMAP](ROADMAP.md).

## Stałe i semantyka

N=1536,q=18433,logn10,ter1,MODE1/FPEMU, Phi=X^1536−X^768+1,
sigma_sign768, B=2093922385, strict Q<B.
Q0(a)=sum(i<768)(a_i²+a_i*a_(i+768)+a_(i+768)²), Q=Q0(z1)+Q0(z2).
Ext0(h,c,b)=(center_q(c−h*s(b)),s(b)).

P_key obejmuje ternarne f,g, |F_i|,|G_i|≤2047, exact fG−gF=q mod Phi,
actual mandatory Gate00_C. Emitted/same-STATIC decode wiążą te same vectors.
Nie dodawaj nowej bramki, aby ułatwić dowód. All-P_key definedness loadera
nie jest all-P_key narrow stable-gate acceptance; ten drugi gap jest OPEN.
Emitted gate bridge jest osobno wyprowadzony z istniejącego KeyGen check.

M0: klasyczny EUF-CMA/direct-output ROM, jeden K_seed[E], p_K raz, budżety
(Q_s,Q_H,t,w,L), nonce40, uczciwy STATIC payload4096, verifier NONE/STATIC bez
tego limitu dla przeciwnika. PRE_ABORT/(r,POST_ABORT)/(r,b), bez timing.
QROM osobno. UB=STUCK, nie return0; inner nonreturn nie jest timeout-bot.
Opakowanie M0 nie jest zintegrowane ze starym CLI(sig[2049]/variable nonce).

## Łańcuch odebranych etapów

Ścieżki niżej są względem `proofs/ft1536/stages/`; zacznij od REPORT,
CLAIM/certificate i NEXT_INTERFACE danego etapu, dopiero potem formal/scripts.

| Etap | Użyteczny wynik / granica |
|---|---|
| `FT1536_L_RHO_RUN_001` | int16→modq verifier correction; historyczny S17 nie jest forgery |
| `FT1536_L_NTT_FORWARD_RUN_001` | pełny NTT/product composition w pinned model |
| `FT1536_L_V_BRIDGE_RUN_001` | Verify accepts→Ext0 defined, congruence i Q<B; nie odwrotny Sign theorem |
| `FT1536_M0_CONTRACT_RUN_001` | GAME, PROFILE, TARGET_TYPE i ordered ledger; wrapper/reduction osobno |
| `FT1536_H3_ZERO_SCALAR_RUN_001` | zero-aware floor/s+z i lokalna NumericCenter konsumpcja |
| ROOT_LDL→NODE3→NODE2→BINARY_TOWER→RAW_ASSEMBLY | źródłowe FFT/Gram/LDL/layout/domain certificates; każdy z prefiksem `FT1536_H3_`, sufiksem `_RUN_001` |
| `FT1536_H3_STABLE_NORMALIZATION_RUN_001` | actual widths oraz Emitted gate bridge, raw-L/basis frame |
| `FT1536_H3_INITIAL_TARGETS_RUN_001` | canonical target prefix i source error |
| `FT1536_H3_ORDERED_REACH_RUN_001` | historyczne PARTIAL: pierwsza prawa gałąź,1536calls |
| `FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001` | pełne ordered NumericCenter, |mu|≤937866518, raw−0; mixed proof |
| `FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001` | PARTIAL: actual suffix/iFFT/rint/narrowing/stored norm/STATIC; universal Safe16 OPEN |
| `FT1536_H3_SCALAR_KERNEL_IID_RUN_001` | dokładny scalar conditional kernel/getters/rejection/fresh-tail w IID_BUFFER |
| `FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001` | TV≤2^-36, forward chi2≤2^-60, A≥1/8, explicit support gap |
| `FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001` |3072-call conditional joint law, Q_S/Q_stop, source closure, a.s. IID return/resources |
| `FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001` | one-root joint BadPrecast Q_S≤2^-119, P_IID≤2^-84, source V/E/MGF |

Najkrótsze ścieżki do kontekstu bieżącego retry:
- [H6P NEXT](../../proofs/ft1536/stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/NEXT_INTERFACE.md)
- [JOINT H6P interface](../../proofs/ft1536/stages/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001/H6P_INTERFACE.md)
- [POST caller/norm](../../proofs/ft1536/stages/FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001/NORM_AND_CALLER_BINDING.md)
- [M0 GAME](../../proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/GAME.md)

## Najważniejsze granice, których nie wolno zgubić

- NumericCenter: finite Word64(mu), −2147483283≤val(mu)<2147483282.
  floor_C(mu)=floor(val(mu))−eps0, eps0=1 wyłącznie dla raw−0.
  NormalResult sam nie zawiera ukrytej NumericCenter; normal0≠fault0.
- Source arithmetic contracts U=2^-48,eta=2^-900 z własnymi domenami;
  to nie ogólne twierdzenie „FPEMU=IEEE”. Half/subnormals mają osobne boundy.
- Sampler zwraca residual arrays, nie tablice integer samples.
  Terminal: paired samp(mu1,IW1I*sigma), half residual1, updatedmu0,
  stored samp(mu0,sigma), final subtraction; rzeczywisty order jest istotny.
- POST: oba wide rint w są przed int16 stores; |w|≤4572095 daje definedness,
  nie Safe16. Późniejsza norma czyta **stored** int16, nie w.
- IID_BUFFER: świeże niezależne4096-byte bloki; PAST nie obejmuje unread/future
  tape. Real SHAKE/ChaCha→IID i computational loss nadal OPEN.
- Q_S to lokalny Gaussian conditioned on positive source support; Q_stop
  wychodzi przed C update poza support. Q_S nie jest ogólnie Q_stop conditioned
  on whole-call survival. Reverse chi2(Q_stop||P)=∞; nie odwracaj metryki.
- Joint comparison na tym samym prefixie nie jest globalnym lattice Gaussian.
  H6P coefficients są entry-fixed, centers adapted; brak independence/mean-zero
  assumption. Exact rational beta/Delta ważniejsze od samych rounded exponents.
- H6P nie rozwiązuje integer recovery/congruence/rounding-gap/Sign→Verify.
  Retry w toku nie jest jeszcze wynikiem odebranym. Whole real Sign/security/CT
  i ROM/QROM composition pozostają dalszymi obowiązkami.

## Historia, do której sięgać tylko gdy potrzebna

- [Snapshot po M0](../../proofs/ft1536/stages/FT1536_POST_M0_FREEZE_RUN_001/REPORT.md)
  i [paper v0.2](../paper/README.md) są starsze od najnowszych H3/H6P.
- [Mapa dalszych działań po L_V](../../proofs/ft1536/documents/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md)
  ma starszy porządek obowiązków; status aktualizuje STATE/katalog.
- T2C3 dotyczy ustalonego klucza, nie populacji. T5 untruncated nie jest
  truncated-tail theorem. R5T wymaga spójnego nowego freeze; nie naprawiaj
  historycznego manifestu w miejscu. Estimator output jest diagnostyką,
  nie reklamowaną liczbą bitów bezpieczeństwa.
- [MiMo research/review](../../proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/README.md)
  jest odrębnym torem FT768/1536/3072, nie źródłem nowych przesłanek H6P.
