# REPORT — FT1536_ADAPTIVE_PROPOSAL_RUN_001

Autor projektu: Niirmata. Status: **PARTIAL_PROOF**.
Zakres: pokrycie nośnika proposal adaptacyjnego i koszt ogona celu
obciętego; dziury w oknie i bound ilorazu M jawnie otwarte.

## Wejścia (mrożone piny)
- `stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/formal/CDF.lean`
  `d21ee929b96189fc2fd7d98930ac66b0daa78d14cab6cbe98b8319ffa134a035`
  (bank nonzero 29/59/118/235/365).
- `stages/.../formal/GaussianMetrics.lean`
  `61c695e4265d8f38de21faa97e653667a43580c93a259cd6bb3263f460ef172b`
  (`finite_support_reverse_failure`).
- `stages/.../SUPPORT_AND_METRICS.md`
  `17e5eaef31ba23596e673e79aba72ba6bb9235413ba1bffb16d49048ee44701a`
  (S skończony, G dodatni na całym Z, świadek s_C+367, koszt t=G(S^c)).
- `stages/.../ERROR_LEDGER.json`
  `5fbeee60d4da281443e0eef54d2b76147eb5a1392c8dbad40ecbed0da62738ae`
  (`tail_upper` ~2^-52, TV 1/2^36, chi2(G||K)=infinity).
- `stages/.../REFERENCE_LAWS.md`
  `9e6c5e1fe84ed7bfeb11c8b86729c2078ed6e80c14b9567af6adb13c8ae3f094`
  (rho_true w [0,1]).
- `stages/.../source/ft1536-adaptive-cdf-tables.h`
  `c16f041a64aba25991b5473111675f1c046ebc38285fca6c052124cf3b7fdf4f`
  (poziomy [5,20,80,320,768]).

## Udowodnione tezy
1. Żądane uniwersalne pokrycie `target>0 -> proposal>0` jest FAŁSZYWE:
   kontrprzykład z=1000 (poza najszerszym oknem 365), cel=1>0, proposal=0.
   (`AdaptiveProposal.lean: proposal_covers_support_false`).
2. Prawdziwy kierunek `proposal>0 -> target>0` (mrożone K_C<<G).
3. Pokrycie celu obciętego G_S z definicji (`conditioned_covers`).
4. Rygorystyczne ogony `t_sigma` dla 5 poziomów (RealBallField(256),
   majoranta geometryczna reszty): wszystkie `t <= ~2^-112..2^-122`,
   poniżej mrożonego `tail_upper` (~2^-52) i poniżej głównego TV 2^-36.

## Weryfikacja (exit 0)
- `lean AdaptiveProposal.lean`: czysty log, zero `sorry/admit/native_decide`,
  aksjomaty standardowe (`propext`, `Quot.sound`, `Classical.choice`).
- `sage check_support.sage` (exact ZZ): SUPPORT_CHECK_PASS.
- `sage check_tail.sage` (RBF(256)): TAIL_CHECK_PASS.

## Jawnie otwarte (nie część tezy)
- Dziury w oknie (`n_j,k=0`, zera kwantyzacji, cutoff e>=64);
  odwrotne `chi2(G_S||K)` nie dowiedzione ani skończone.
- Bound ilorazu gęstości M / stała akceptacji rejection samplingu.
- Rozbicie `TV(K,G) <= TV(K,G_S) + t` jest tożsamością księgową:
  Lean dowodzi pokrycie, Sage dowodzi liczbę t. Bez podmiany dowodu.
