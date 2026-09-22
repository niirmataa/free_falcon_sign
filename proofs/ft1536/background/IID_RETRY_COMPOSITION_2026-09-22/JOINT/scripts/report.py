import json
from pathlib import Path
from replaylib import sha
W=Path.cwd();c=json.loads((W/'ORDERED_JOINT_CERTIFICATE.json').read_text());r=json.loads((W/'artifacts/fresh_replay.json').read_text());assert r['status']=='FRESH_REPLAY_PASS' and r['matches'] and r['matched']==r['expected_files']
assert json.loads((W/'artifacts/replay_negative.json').read_text())['destination_created'] is False
for p,h in c['proof_documents'].items():assert sha(W/p)==h
result=dict(c);result.update(fresh_replay=dict(status=r['status'],matched=r['matched'],expected=r['expected_files'],receipt='artifacts/fresh_replay.json',receipt_sha256=sha(W/'artifacts/fresh_replay.json'),external_anchor_sha256=r['external_manifest_sha256']),certificate_sha256=sha(W/'ORDERED_JOINT_CERTIFICATE.json'),postfreeze_recipe='scripts/replay_controller.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA; later writes only in new DEST',own_jobs='bounded single-worker work; no nightly RUN_002/dudect or subsequent research task launched')
(W/'RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
text=f'''# FT1536 — ORDERED_JOINT_KERNEL

Autor projektu: **Niirmata**. Atrybucja źródeł: Falcon Project / Thomas Pornin,
licencje zachowane. Zadanie z 2026-09-21; zakończenie 2026-09-22.

## Rzeczywisty status

**H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

Udowodniono dokładne adaptacyjne prawo jednego pełnego root sampling invocation
oraz jego ilościowe porównanie z dwiema jawnymi referencjami. Zakres to wyłącznie
**IID_BUFFER**, każde wymagane emitted/canonical normalized entry i legalna
entry PAST. Most od rzeczywistego SHAKE/ChaCha do tej gry pozostaje **OPEN**.

## Co rzeczywiście wykazano

1. Literalny scheduler ma **3072 scalar calls**: root i binary right-before-left,
   cubic 2→1→0, terminal mu1 przed updated mu0. Liczba wynika z rekurencji,
   nie z wpisanej premise lub samej listy testów.
2. **Każdy positive-support prefix** ma skończony actual source witness.
   Source frame i ORDERED/LEFT/NORMALIZED, w tym actual first-bank oraz
   correlated terminal A2 budgets, dają current domains przed następnymi
   instrukcjami. Nie założono przyszłego NumericCenter, fault-free execution,
   termination lub norm acceptance. Rejection stutters nie wykonują caller stores.
3. Exact value law to **iloczyn kernelów warunkowych na tym samym prefiksie**,
   a nie niezależne marginals. Wyprowadzono także joint N/Y, pointer/refill/drop,
   pełne ujawnione 33-byte proposal atoms i stopped fresh-tail. Root wraca
   **prawie na pewno w IID_BUFFER**.
4. Q_S używa lokalnego Gaussa conditioned on dokładnym positive source support.
   Q_stop używa nieodciętego Gaussa na ℤ i kończy **EXIT przed C conversion/update**
   poza tym supportem. Żadna referencja nie jest tu idealnym globalnym lattice Gaussian.

## Ilościowe porównanie ordered VALUE trace

Dla Q∈{{Q_S,Q_stop}}, zawsze od źródłowego P do referencji Q:

```
chi2(P || Q) <= (1+2^-60)^3072-1
             <= 3/(2^50-3) < 2^-48,
TV(P,Q) <= 2^-25.
TV(Q_S,Q_stop) = Q_stop(EXIT) <= 3072*tau < 2^-50.
```

Tau jest dokładnym przypiętym rationalem z GAUSS/ERROR_LEDGER, bez pominięcia
table holes, cutoff i infinite tails. EXIT cost nie został dodany drugi raz do
forward chi2/TV. Machine/source parametry obu local factors pochodzą z TEGO SAMEGO h.

**Kierunki odwrotne są różne:** chi2(Q_stop||P)=∞ przez positive EXIT.
Q_S i P mają ten sam finite support; wyprowadzono finite reverse upper
2^811008−1. Jest on bardzo luźny i nie daje użytecznego małego lossu.

## Zasoby i postprocessing

- E[T]≤**24576** proposals, E[returned bytes]≤811008.
- Conditional moment/tower proof, bez independence Ni, daje
  **Pr[T>49152]<2^-1024**. Na tym ghost budżecie: ≤1622016 returned bytes,
  ≤397 nowych refills, ≤3573 discarded bytes. Literal ptr≥4087 zachowany.
  Ghost cap jest zdarzeniem analizy, a nie nowym abortem C.
- Exact resource/revealed-byte law jest osobnym exportem. Zdefiniowany wspólny
  source-conditional ghost lift referencji zachowuje TV/forward chi2 dokładnie;
  nie jest implementacją Gaussa ani mostem do realnego seeded transcriptu.
- Actual POST basis/iFFT/rint, oba pre-narrow vectors, narrowing, stored norm
  i właściwy STATIC branch są deterministic pushforward. EXIT pozostaje tagiem.
  Dla joint BadPrecast: **p≤q+min(2^-25,sqrt(Delta*q*(1-q)))**, z oczywistym cap1.
  **Reference q pozostaje nieudowodnione**. Nie wpisano eta_pre ani nowej straty do M0.

## Niewygodne wyniki i ograniczenia

- **Q_S nie jest na ogół Q_stop conditioned on whole-call survival.** Dokładna
  relacja ma history-dependent survival tilt. Wykonany QQ countermodel daje
  TV=1/10; to abstrakcyjne adaptive tree, nie emitted-source atak.
- Proposal window jest większe od positive accepted support: lokalny input
  mu0,sigmaRN(4/3),k29 ma positive proposal count i forced cutoff. Jego Emitted
  membership nie wykazano; EXIT nie oznacza automatycznie UB.
- Dwie synthetic native root traces miały te same 3072 values/centers/widths
  i POST bytes, ale **3147 versus 6219 proposals**. Sam value trace nie
  identyfikuje resources; dlatego ich law i reference lift są jawnie osobne.
- Luźne reverse/union bounds oraz failed reuse/link/no-op harness drafts
  zostały zachowane w FAILED_ROUTES, artifacts/attempts i pełnych logs.

## Weryfikacja i mixed boundary

- **114 Lean modules, 884 twierdzenia, 37 nowych**, 107 inherited modules
  świeżo zbudowanych. Clean final logs, new full types/terms i all-axioms audit;
  tylko propext/Classical.choice/Quot.sound. Bez sorry/admit/native_decide/
  Lean.ofReduceBool, aksjomatu celu i warning suppression.
- **9 native batches w każdym buildzie normalnym i ASan/UBSan**: 6148 actual
  scalar calls, 9376 proposals, {c['checks']['cutoff_rejections']} cutoff rejections,
  wszystkie4096 start ptrs plus final-byte u8, signed±0, obie root branches,
  cubic snapshots, pełne suffix/codec words/bytes/frames. Original scalar jest
  porównany z obserwatorem na każdym callbacku. LSan nie deklarowany.
- Cztery niezależne exact Sage QQ adaptive trees; wszystkie event subsets
  dla małych trees, local-conditioning identities, moment chain, direction,
  pushforward i common lift. **12 meaningful mutations + no-op** wykonane.
- **Fresh replay {r['matched']}/{r['expected_files']}**, bez project cache/bin/olean,
  package RO, originals hidden, network-off, bounded single worker. Sealed
  artifacts/fresh_replay.json ma actual FRESH_REPLAY_PASS i matches[{{path,sha256}}].
  Błędny external pin odrzucony przed utworzeniem DEST.

Dowód jest **mixed kernel / universal analytical source / product measure**.
Concrete C simulation, all-history closure instantiation, real/countable
probability, stopping times i directed metric composition są jawnie analityczne.
Kernel sprawdza wskazane induction/algebra/count/resource/POST lemmas;
**fully_kernelized=false, C_compiler_verified=false**. Finite tests i hash
agreement nie są podnoszone do brakującego universal theorem.

## Piny i ścieżki

TASK SHA-256: `35e7ccd932be795569a7464a55bbbf2c85e3fe9c0919f9220e0d92bbf796be61`.
Bootstrap SHA-256: `90f866ed86bf3d8b95903a666338f7b659bbd4cf519f27abba2f63708fa11a87`.
BASE: `64af4cbd4280f45f28f8f160b7ebdacebdf29734`.
Source17-file pin: `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
ORDERED_JOINT_CERTIFICATE.json: `{sha(W/'ORDERED_JOINT_CERTIFICATE.json')}`.
Fresh anchor: `{r['external_manifest_sha256']}`.

Zweryfikowano exact755 members/753 public origin records/18250111bytes;
workspace ext4,W-only/network-off. Wszystkie nowe pliki/cache/wyniki wW.
Source17files i bootstrap RO. source_changed=false, production_source_changed=false,
new_source_patch_integrated=false, owner_accepted=false. Bez subagentów,
KeyGen/keys/seeds/private loadera, real PRNG/full Sign/do_sign, instalacji i dudect.
Import/commit/publikacja pakietu pozostają prowadzącemu sesję.

## Własna ocena dla właściciela

**Co się udało:** scalar results są teraz poprawnie złożone w pełną adaptacyjną
próbę root. Zależność późniejszych centrów od wcześniejszych zwrotów, source
domains, resources oraz support exits zostały jawnie rozliczone. Jest dostępny
mały, kierunkowo poprawny joint loss i typed transfer do dalszych prac H6P.

**Co pozostaje otwarte:** realny PRNG→IID_BUFFER, oszacowanie reference joint
BadPrecast, Safe16, global lattice reference/recovery/integrality/tie gap,
retry composition, Sign→Verify oraz całe real Sign termination/security/CT.
Historyczny POST pozostaje PARTIAL_PROOF. Nie wygenerowano emitted witness
dla syntetycznych kontroli i nie ogłoszono ataku.

**Znaczenie:** zamknięto etap adaptacyjnej kompozycji jednego root invocation
w określonej grze. TV2^-25 nie jest deklaracją poziomu bezpieczeństwa całego
schematu ani prawdopodobieństwem BadPrecast. Reverse chi2 i survival tilt
wyznaczają rzeczywiste ograniczenia sposobu dalszego użycia.

**Następny krok:** H6P/source-map reference bad-event analysis albo osobny
PRNG_REAL_TO_IID_BUFFER z finite-resource/computational loss. WholeCallBad
wymaga późniejszej conditional retry kompozycji; single K_seed[E]/p_K raz,
source cap16,nonce40 i STATIC4096 zachowane. Następny etap oraz nocny dudect
uruchamia właściciel osobno; ten etap kończy się na handoffie.
'''
(W/'REPORT.md').write_text(text);print(json.dumps(dict(status=c['status'],report_sha256=sha(W/'REPORT.md'),fresh_matches=r['matched']),indent=2))
