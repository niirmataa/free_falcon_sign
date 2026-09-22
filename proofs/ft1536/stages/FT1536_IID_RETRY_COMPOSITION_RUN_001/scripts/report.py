import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();C=json.loads((W/'IID_RETRY_CERTIFICATE.json').read_text());R=json.loads((W/'artifacts/fresh_replay.json').read_text())
assert R['status']=='FRESH_REPLAY_PASS' and R['matched']==R['expected_files'] and R['matches']
assert json.loads((W/'artifacts/replay_negative.json').read_text())['destination_created'] is False
result=dict(C);result.update(fresh_replay=dict(status=R['status'],matched=R['matched'],expected_files=R['expected_files'],receipt='artifacts/fresh_replay.json',receipt_sha256=sha(W/'artifacts/fresh_replay.json'),external_anchor_sha256=R['external_manifest_sha256']),certificate_sha256=sha(W/'IID_RETRY_CERTIFICATE.json'),postfreeze_replay='scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA; only new DEST written',handoff_channel='current user TUI chat only; no relay',owner_acceptance=False)
(W/'RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
text=f'''# FT1536 — IID_RETRY_COMPOSITION

Autor projektu: **Niirmata**. Zachowano Falcon Project / Thomas Pornin
attribution i licencje. Data:2026-09-22.
TASK_ID=FT1536_IID_RETRY_COMPOSITION_RUN_001.

## Rzeczywisty status

**{C['status']}**.

Dla jednego legalnego emitted/same-STATIC normalized ReadyRetryEntry po H2P,
z canonical hm i dowolną dopuszczoną entry PAST, wyłącznie w **G_retry_IID**:

```
Pr(WholeRegionBad | entry PAST)
 <= p_outward * sum_j Pr(R_j | entry PAST)
 <= 16*p_outward <= 2^-80.
```

WholeRegionBad obejmuje BOTH pre-narrow vectors WSZYSTKICH reached/completed
attempts, także norm-rejected. Pochodzi z uniform one-root H6P<=2^-84 po
source-derived re-entry/fresh-tail, nie z assumed all-future entries.
Exact rational i dodatkowy poprawny conditional-hazard bound1-(1-p)^16
są w STOPPED_COMPOSITION.json; nie przyjęto independence retry outcomes.

## Co domknięto

1. **Source applicability:** pojedynczy cut3327, counter/guard17 przed kolejnym
   init, actual fault reset/target overwrite, preserved key/hm, legal root
   domains i fresh-tail także po Bad w norm-rejected próbie.
2. **Stopped scheduler:**1..16 reached attempts, strict STORED norm, pierwszy
   acceptance, jedno encode, source ZERO/exact BYTES/NONRETURN. Region
   kończy się a.s. w IID; exceptional inner nonreturn nie został timeout0.
3. **Checked coupling:** proof-only PRECAST_EXIT przed pierwszym bad cast
   w source store order. Equal-until-bad, exact positive bytes poza eventem,
   tagged/public-result TV<=ten sam probability bound. Kod C nie dostał abortu.
4. **Resources:** E[T_region]<=393216; returned mean<=12976128. Jednoczesne
   ghost budgets:786432 proposals,6352 fresh4096-byte blocks,26017792 generated
   bytes, getter drops i osobno do61320 abandoned re-init bytes. Failure
   <2^-1020 wywiedziony z union per-root T_j>49152.56-byte source SHAKE
   requests<=896; nie nazwano tych bytes independent IID seeds.
5. **Bytes:** po stored norm acceptance STATIC4096 mieści exact payload
   z header0xaa, total<=3160, bez paddingu do4096. Nonce40 jest poza cut.

## Weryfikacja

-120 Lean modules,922 theorem declarations,26 nowych;114 unchanged inherited
  modules rebuilt. Clean final logs, pełne new types/terms i axioms audit;
  jedynie standard propext/Classical.choice/Quot.sound.
-22 scripted original-loop/codec cases w każdym normal i ASan/UBSan buildzie,
  plus6 reset/getter cases/build. Actual target prefix, initialized/frame
  canaries, branch order i exact buffer writes. Brak pełnego Sign/do_sign
  i real seeded PRNG execution. LSan nie deklarowany.
- Exact adaptive finite laws, zero-mass branches, success conditioning,
  normal/checked coupling; niezależny Sage10.9 QQ rachunek.
-11 meaningful mutations killed i2 no-ops potwierdzone. Synthetic examples
  nie mają Emitted membership i nie są atakami ani required-domain counterexamples.
- **FRESH_REPLAY_PASS {R['matched']}/{R['expected_files']}** rzeczywiście
  odtworzonych path/SHA matches z fresh project cache/bin/olean, network-off,
  RO inputs/source, originals hidden. Sealed receipt:artifacts/fresh_replay.json.
  Wrong external manifest pin odrzucony przed utworzeniem DEST.
  Po freeze ten sam recipe służy do osobnego końcowego replayu z OUTPUTS pinem;
  jego wynik i hashe są podawane w końcowym handoffie TUI.

**Proof boundary:** mixed universal source/analytical/kernel/exact-rational.
`fully_kernelized=false`, `C_compiler_verified=false`. Lean sprawdza
invariant/counter/preservation/scaled-sum/reset algebra i selected dependencies.
Konkretne C frames, conditional probability/tower, stopping i coupling/TV
instantiation są jawnymi analitycznymi dowodami w dokumentach, nie verified
C interpreterem lub Lean measure theory. Testy nie zastępują tych dowodów.

## Co nie wyszło i co pozostaje otwarte

- Pierwszy Floor build timeout180s, późniejszy pass bez zmiany źródła;
  zachowane źródło/logi. Odmowy exclusive lock były respektowane.
- Doprecyzowano wspólny resource event: każda reached próba ma T_j<=49152.
  Sam total-T bound nie uzasadnia podanego6352-block rachunku.
- Independent marginals, accepted-only Bad i small Bad|positive bez
  denominatoru są nieuprawnione; konkretne finite countermodels zachowano.
- Real SHAKE/ChaCha bridge, H2P-prefix termination, whole real Sign,
  universal Safe16, reference integer recovery, Sign→Verify/security/CT
  pozostają OPEN. Bad AND positive nie jest Bad conditioned on positive.
  Nie dowiedziono dodatniego lower boundu success probability.
- P_key/Emitted/Gate00_C,single K_seed[E]/p_K,source success/abort,nonce40,
  cap16,STATIC4096 i verifier domain bez zmiany; `new_M0_eta_pre=null`.

## Piny i handoff

BASE:`{C['base']}`.
TASK SHA-256:`{C['task_sha256']}`.
Bootstrap SHA-256:`{C['bootstrap_sha256']}`.
Source17 SHA-256:`{C['source_manifest_sha256']}`.
Certificate SHA-256:`{sha(W/'IID_RETRY_CERTIFICATE.json')}`.
Rehearsal anchor SHA-256:`{R['external_manifest_sha256']}`.

source_changed=false,production_source_changed=false,new_source_patch_integrated=false,
owner_accepted=false. Wyłącznie trwały W; bez Git/importu/pusha/instalacji/
nowych keys/seeds/KeyGen/private loadera/dudect. Wcześniejsze polecenie relay
zostało odwołane przez właściciela: końcowy output tylko w obecnym czacie TUI.

## Własna ocena

**Osiągnięcie:** wcześniejsze oszacowanie dla jednej próby można teraz
stosować do rzeczywistego maksymalnie16-próbkowego regionu. Wyprowadzono
przesłanki ponownego wejścia i uwzględniono bad także w próbach odrzuconych.
To zamyka istotną lukę pomiędzy one-root probability a source retry loop.

**Ograniczenie:** jest to idealna gra refillów po już ukończonym H2P.
Nie dowodzi bezpieczeństwa produkcji ani poprawności całego podpisu.

**Znaczenie i następny krok:** powstał ilościowy stopped-coupling i dokładny
finite resource interface dla oddzielnego PRNG_REAL_TO_IID_BUFFER. Potem
pozostaje integer recovery/Sign→Verify. Kolejny etap, dudect i publikację
uruchamia właściciel ręcznie po odbiorze; ten handoff kończy obliczenia etapu.
'''
(W/'REPORT.md').write_text(text);print('REPORT',sha(W/'REPORT.md'),'FRESH_MATCHES',R['matched'])
