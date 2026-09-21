import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();c=json.loads((W/'SCALAR_GAUSSIAN_CERTIFICATE.json').read_text());r=json.loads((W/'artifacts/fresh_replay.json').read_text());assert r['status']=='FRESH_REPLAY_PASS' and r['matches'] and r['matched']==r['expected_files']
assert json.loads((W/'artifacts/replay_negative.json').read_text())['destination_created'] is False
result=dict(c);result.update(fresh_replay=dict(status=r['status'],matched=r['matched'],expected=r['expected_files'],receipt='artifacts/fresh_replay.json',receipt_sha256=sha(W/'artifacts/fresh_replay.json'),external_anchor_sha256=r['external_manifest_sha256']),certificate_sha256=sha(W/'SCALAR_GAUSSIAN_CERTIFICATE.json'),postfreeze_recipe='scripts/replay_controller.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA; all later writes in fresh DEST',own_jobs='completed bounded work; no background worker or nightly RUN_002 launched')
(W/'RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
report=f'''# FT1536 — SCALAR_GAUSSIAN_COMPARISON

Autor projektu: **Niirmata**. Data: 2026-09-21.

## Rzeczywisty status

**H3_SCALAR_GAUSSIAN_COMPARISON_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

Wyłącznie w **IID_BUFFER**, dla required scalar entries D_cert oraz jawnego
nadzbioru D_env, warunkowo względem legalnej PAST, dowiedziono porównania exact
source K_C z niezależnym, NIEODCIĘTYM Gaussianem na całym Z:

```
m = val(mu_word), v = val(sigma_word)^2,
G(y) = exp(-(y-m)^2/(2v)) / sum_z_in_Z exp(-(z-m)^2/(2v)),
TV(K_C,G) <= 2^-36,
chi2(K_C||G) <= 2^-60,
chi2(G||K_C) = infinity.
```

To lokalna sigma danego call,nie globalne sigma_sign768. Machine-parameter Ghat
ma osobną definicję i jawny transport. **Realny ChaCha/SHAKE→IID_BUFFER pozostaje
OPEN**; nie nadano statusu pełnego prawa source Sign/termination/security/CT.

## Co zamknięto

- D_cert⊆D_env,per-bank/class first-selector coupling i actual source x/e/rB
  domains. Uniform **x<273,e<=393**, bez użycia komentarza393 jako premise.
- Whole-word394 bracket proof z normal-mul/RNE/Sterbenz source refinement:
  **rB>=0**, ale63 buckets przekraczają literal binary64(log2).
- Nowy expm accuracy na całym actual[0,R],R=12193974156573/17592186044416:
  source trunc do<2^63 (z count0 endpoint),high-word/Horner,256 exact QQ
  Bernstein cells,Taylor/integer/count/reduction errors. Relative noncutoff
  BerExp error<=2^-44,bez postulatu Beta=exp(-x).
- Literal dyadic CDF versus infinite half-line q_j: **L1<=2^-121**,
  **chi2(p_j||q_j)<=2^-125**,threshold error<=2^-128,zero/duplicate/tail handling.
- Source center/delta error<=2^-51,precision relative error<=2^-45,correction
  i Ghat→G parameter transport. Accepted normalizer z nowym **A>=1/8**.
- Normalization,cutoff/infinite/support tails oraz poprawnie skierowane TV,
  forward chi2 i likelihood. G_S conditioning loss jest jawny,nie ukrywa ogona.

## Zachowane niewygodne wyniki

1. Nominalna premise rB<=log2_C jest fałszywa w D_env. Trzy source scalar
   witnesses po standalone leaf normalization są potwierdzone native. Pierwszy:
   mu3fe944a55eca5136,sigma3ff5555555555555,D331776,k4,b0 daje
   x4013687a9f1af2b1,e6,rB3fe62e42fefa39f0, o1ULP ponad log2_C.
   **Emitted/D_cert history membership nie zostało wykazane**. Rozszerzono
   dowód domain,nie poprawiano C i nie ogłoszono ataku na schemat.
2. Extended input samego expm rB=−2^-50 daje certified gap **>3/5** wobec
   exp(-rB), przez unsigned argument folding. Actual certified source reduction
   wyklucza rB<0; nie jest to source scalar counterexample w wymaganej domenie.
3. **Reverse chi2(G||K)=∞** uniwersalnie, mimo małego forward boundu, bo G ma
   dodatnią masę poza skończonym S. Nie wolno zamienić kierunku change-of-measure.
4. Saturation-removal mutation jest równoważna na nowo dowiedzionym source
   Z<=2^55. Ten wynik zachowano zamiast deklarować fikcyjne wykrycie.

FAILED_ROUTES/COUNTERMODELS zawierają pełne scopes,failed Lean/metadata drafts,
native evidence i certified reference intervals. Brak counterexample do
podanych TV/forward-chi bounds w required domain.

## Weryfikacja i granica dowodu

- **36 Lean modules,234 theorems,26 nowych**;30 inherited dependencies freshly
  rebuilt,czyste final logs,pełne new types/terms i axioms audit. Tylko
  propext/Classical.choice/Quot.sound,bez sorry/admit/native_decide/ofReduceBool
  lub warning suppression.
- **30 native batches w każdym buildzie normal i ASan/UBSan**: wszystkie
  reduction bracket boundaries/neighbors,normal mul/center/expm/leaf controls
  i **36 464 scalar atoms** są word-exact. LSan nie deklarowany.
- **101 rigorous RBF384 Gaussian comparisons** z infinite-tail bounds,
 54 zgodne odebrane exact PMFs i47 nowych boundary/witness cases.
-12 detected meaningful model mutations,no-op i1 proved source-range
  equivalence; pełne baseline/changed evidence.
- **FRESH_REPLAY_PASS {r['matched']}/{r['expected_files']}**: pełny fresh build bez project
  cache/olean/bin,package RO,originals hidden,network-off,single bounded worker.
  Sealed artifacts/fresh_replay.json z matches[{{path,sha256}}]. Wrong external
  pin odrzucony PRZED utworzeniem DEST.

**Mixed kernel/universal analytical source/QQ-RBF proof**. Floating source
instantiation,real Gaussian/Taylor/integral/tail arguments są jawnie analityczne;
fully_kernelized=false,C_compiler_verified=false. Uniform bound nie pochodzi
z maxima101 points. Obserwowane intervals służą niezależnej kontroli bindingu.

## Piny i zakres

TASK: `610f1dc0d5fc27ba4b0bedf2e66cafc8bd7e05035e4192cae026c85cd3361029`.
Bootstrap: `30721120fb8ed7721aa4fe14f960fe90a0614221e58cbb3d7bd523fedc25de27`.
BASE: `6f1f34cb63ad34315fb306f1f4117fec48cfd7cc`.
Source17-file pin: `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
SCALAR_GAUSSIAN_CERTIFICATE.json SHA-256: `{sha(W/'SCALAR_GAUSSIAN_CERTIFICATE.json')}`.
Fresh anchor SHA-256: `{r['external_manifest_sha256']}`.

Wszystko pod trwałym W/ext4;source/bootstrap RO. source_changed=false,
production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Bez Git/importu,keys/seeds/KeyGen/private loadera/Sign/
do_sign/real seeded PRNG/dudect. Nocny RUN_002 nieuruchomiony. REPORT i OUTPUTS
mają zewnętrzne SHA-256 przekazane po freeze.

## Własna ocena dla właściciela

**Osiągnięcie:** exact scalar kernel w IID_BUFFER jest teraz ilościowo bliski
właściwemu Gaussianowi z rzeczywistych input words. Dowód rozlicza source
rounding,nieidealne tables,remainder poza nominalnym interval,normalizer i ogony.

**Niewygodne wyniki / otwarte:** reverse chi2 jest nieskończona,nominalny
remainder-domain transfer był za wąski,a negative extended expm ma duży błąd.
Nie wykazano emitted membership lokalnych witnesses. Real-PRNG bridge oraz
ordered joint/H6P,BadPrecast/Safe16,reference recovery i Sign→Verify są osobne.

**Znaczenie:** powstał mały,jawny lokalny bound i poprawny kierunek jego użycia.
To nie deklaracja globalnego poziomu bezpieczeństwa;2^-36 nie może zostać
automatycznie wpisane jako whole-call loss lub eta_pre.

**Następny krok:** ORDERED_JOINT_KERNEL/H6P z conditional kernels/legal shared
histories i rozliczeniem reference support/domain exits; osobno
PRNG_REAL_TO_IID_BUFFER z rzeczywistym source/resource/computational loss.
Single K_seed[E]/p_K,M0 i source success/abort/bytes zachowane. POST pozostaje
PARTIAL_PROOF. Własne obliczenia kończą się na tym handoffie.
'''
(W/'REPORT.md').write_text(report);print(json.dumps(dict(status=c['status'],report_sha256=sha(W/'REPORT.md'),fresh_matches=r['matched']),indent=2))
