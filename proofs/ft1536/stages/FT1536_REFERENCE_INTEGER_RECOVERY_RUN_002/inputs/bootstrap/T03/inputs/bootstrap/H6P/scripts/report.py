import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();c=json.loads((W/'H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json').read_text());r=json.loads((W/'artifacts/fresh_replay.json').read_text());assert r['status']=='FRESH_REPLAY_PASS' and r['matches'] and r['matched']==r['expected_files']
assert json.loads((W/'artifacts/replay_negative.json').read_text())['destination_created'] is False
result=dict(c);result.update(fresh_replay=dict(status=r['status'],matched=r['matched'],expected=r['expected_files'],receipt='artifacts/fresh_replay.json',receipt_sha256=sha(W/'artifacts/fresh_replay.json'),external_anchor_sha256=r['external_manifest_sha256']),certificate_sha256=sha(W/'H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json'),postfreeze_recipe='scripts/replay_controller.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA, new DEST writes only',own_jobs='completed bounded work; no background worker,nightly run or next task launched')
(W/'RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
text=f'''# FT1536 — H6P_REFERENCE_BAD_EVENT

Autor projektu: **Niirmata**. Zachowano Falcon Project / Thomas Pornin
attribution i licencje. Data:2026-09-22.
TASK_ID=FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001,sprawdzony z CURRENT_TASK.

## Rzeczywisty status i wynik

**H6P_REFERENCE_BAD_EVENT_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

Dla KAŻDEGO required emitted/canonical normalized root entry e i legalnej
entry PAST,wyłącznie w **IID_BUFFER**, z referencją **Q_S** z JOINT:

```
B_e = Live AND not Safe16(w1,w2),
w1,w2: BOTH1536 source int64 rint outputs BEFORE narrowing,
q_e=Q_S(B_e|entry PAST) <= beta_outward <= 2^-119,
p_e=P_IID(B_e|entry PAST) <= p_outward <= 2^-84.
```

To **ONE ROOT**, nie16 attempts/whole Sign/real PRNG lub eta_pre M0.
Exact expressions i mocniejsze outward rational bounds są w JOINT_TAIL_BOUND.json.
EXIT jest wyłączony z B i nie wykonuje suffixu. Q_stop(B)≤Q_S(B) można skonsumować
bez dodatkowego exit kosztu; Q_S nie jest Q_stop conditioned on whole-call survival.

## Co rzeczywiście domknięto

1. Source noise map od actual adaptive innovations xi=val(mu_h)−Y,
   z fixed-entry actual-L/basis coefficients dla wszystkich3072 outputs,
   paired-before-stored order i **d_e,r=0**. Target rounding jest w actual mu,
   nie przemilczanym deterministic drift lub reference integer recovery.
2. **Coefficientwise variance proxy V<5 462 457**. Wyprowadzony z rational
   raw-L/stable-D factors,root rounded Gram/det,basis transport,terminal A2/
   paired3/4 i actual sqrt/div/IW1I widths. Nie przyjęto ideal-L/covariance identity.
3. **Pełny source error E<1095**: terminal returns/Half/sub,obie reconstructions,
   root CM/sub,rounded-basis/cross terms,post CM/add i source iFFT1/128.
   Samo1/128 ani POST energy10436770873344 nie zostało użyte jako full error/variance.
4. Conditional Gaussian MGF z uniform discrete-normalizer ratio i actual
   local support-conditioning factor. Adaptacyjne tower composition3072
   steps bez independence i bez exact mean-zero premise.
5. Correct asymmetric rint ties:−32768.5 SAFE,+32767.5 BAD; conservative
   symmetric threshold32767.5−E. Union obejmuje **6144 signed tails** obu vectors.
6. Poprawny forward JOINT event-transfer consumer z q<=beta<1/2 i Delta_exact,
   z wyprowadzoną monotonicity q(1−q); wynik one-root IID<=2^-84.

## Niewygodne wyniki i granice

- Poprawny niezależny product-box error około **3.681×10^9** dawał tylkoq<=1.
  To za luźny estimate,nie kontrprzykład. Correlated operator/error bridge
  jest niezbędny; wszystkie coarse numbers i failed routes zachowano.
- Local controls pokazują nonzero source roundoff,raw L różne od idealnego,
  nonzero conditional innovation means i joint MGF różne od iloczynu marginals.
  Normalizer ratio jest strictly>1. Pominięcie tych czynników nie jest premise.
- Synthetic trees/basis/terminal i toy probability examples **nie mają
  Emitted/canonical-key membership**. Nie zgłoszono required-domain counterexample
  lub ataku. Bound nie został wyprowadzony z ich sample maxima.
- Small probability nie daje universal Safe16,integer recovery lub Sign→Verify.
  Real PRNG,retry/whole real Sign,security/CT pozostają OPEN. Single K_seed[E]
  i p_K,source gates/success event/abort/bytes,M0 bez zmian; eta_pre nie nadano.

## Weryfikacja i zakres formalizacji

- **48 Lean modules,327 theorems,26 nowych**,42 selected inherited modules
  rebuilt from source. Clean final logs,full new types/terms i axioms audit;
  standardowe propext/Classical.choice/Quot.sound,bez sorry/admit/native_decide/
  ofReduceBool/aksjomatu celu/warning suppression.
- Normal i **ASan/UBSan**:7 native cases/build,2 complete root maps+source
  suffix/rint,2 signed-zero terminals i rint tie neighbors. Exact words,
  snapshots,frame/canaries obu vectors zgodne; LSan nie deklarowany.
- Independent RBF forward/direct inverse/adjoint checks:3072 coefficients
  każdego z2 fixtures,36 complete selected rows,32 impulse checks i niezależna
  closed-form constant-basis variance.1209 adaptive Gaussian atoms w MGF controls.
- **12 meaningful mutations +no-op**, exact two-point event-transfer controls
  i pełny zapis failed formal draft. Szczegóły COUNTERMODELS/FAILED_ROUTES.
- **FRESH_REPLAY_PASS {r['matched']}/{r['expected_files']}** regenerated path/SHA matches,
  bez project cache/olean/bin,package RO,originals hidden,network-off i trwałe W.
  Sealed artifacts/fresh_replay.json ma matches[{{path,sha256}}] oraz game/reference/
  event/scope. Wrong external pin odrzucony przed DEST.

Proof kind: **mixed universal source/analytical/kernel/QQ-RBF**. Real operator/
Loewner,Poisson/conditional probability/Chernoff i konkretne source instances
są jawnie analityczne. fully_kernelized=false,C_compiler_verified=false.
Generic lemmas nie są przedstawione jako source theorem bez V/E discharge.

## Piny i handoff

TASK SHA-256: `cdaa0ed0ce877774e5ba914329d6ceb71b7df756152ab47c8c2006d47683c9c7`.
Bootstrap SHA-256: `4e66e844d425ab9cd8cc6441f4852101f48acfcc178de0d6988f0ec785e42369`.
BASE: `22e6dd41507a0e990b584dad8d1f4c8834d4c289` (odebrany JOINT).
Source17-file pin: `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json SHA-256: `{sha(W/'H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json')}`.
Fresh anchor SHA-256: `{r['external_manifest_sha256']}`.

source_changed=false,production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Pracowano tylko w nowym trwałym W; JOINT nie był wznawiany.
Brak Git/importu,nowych keys/seeds,KeyGen/private loadera/pełnego Sign/do_sign,
real seeded PRNG,sieci/instalacji/dudect. REPORT/OUTPUTS z external SHA w handoffie.

## Własne podsumowanie po polsku

**Osiągnięcie:** otwarte q w interfejsie JOINT dostało source-instantiated,
uniform bound dla obu pre-cast vectors. To nie założona idealna wariancja:
rzeczywiste rounded tree/basis,widths i cały error budget zostały rozliczone.

**Co nie wyszło / pozostaje otwarte:** proste independent boxes były zbyt luźne;
ideal identity,normalizer1,mean-zero i independent marginals nie są uprawnione.
Real PRNG i whole-call/retry oraz integer/sign correctness nie są domknięte.
Mały bound nie zmienia tego w universal Safe16.

**Znaczenie:** dalszy proof ma teraz ilościowy one-root IID BadPrecast consumer,
z poprawnym joint eventem,kierunkiem miary i source rounding. Nie dodano
hipotetycznego lossu do M0 ani nowego source zachowania.

**Następny krok:** osobna retry/whole-call reference composition i
PRNG_REAL_TO_IID_BUFFER,oraz reference integer recovery/Sign→Verify według
NEXT_INTERFACE. Obliczenia kończą się na tym handoffie; kolejne zadanie i nocny
dudect uruchamia osobno właściciel.
'''
(W/'REPORT.md').write_text(text);print(json.dumps(dict(status=c['status'],report_sha256=sha(W/'REPORT.md'),fresh_matches=r['matched']),indent=2))
