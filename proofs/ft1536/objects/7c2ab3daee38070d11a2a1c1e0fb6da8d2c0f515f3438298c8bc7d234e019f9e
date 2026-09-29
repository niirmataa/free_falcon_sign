#!/usr/bin/env python3
"""Validate completed jobs, write truthful blocked handoff, then seal exact outputs."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import re
import shutil

W=Path(__file__).resolve().parents[1]

def sha(p):
    with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()

def write(name,value):
    (W/name).write_text(json.dumps(value,indent=2,sort_keys=True)+'\n')

assert not (W/'OUTPUTS.sha256').exists(), 'already frozen'
success=['run/final_002','run/ubsan_002','run/asan_002','replay/fresh_002']
for rel in success:
    r=json.loads((W/rel/'receipt.json').read_text())
    assert r['exit_code']==0 and r['sources_unchanged'],rel
    assert all(s['exit_code']==0 and s['clean_log'] for s in r['steps']),rel
fresh=json.loads((W/'replay/fresh_002/REPLAY_RESULT.json').read_text())
assert fresh['status']=='FRESH_REPLAY_PASS' and len(fresh['matches'])==10
assert fresh['sources_unchanged']
for part,manifest in fresh['source_after'].items():
    for rel,h in manifest.items():assert sha(W/part/rel)==h,(part,rel)
for p in Path('/proc').iterdir():
    if p.name.isdigit():
        try:
            cmd=(p/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
            if str(W) in cmd:
                assert not any(x in cmd for x in ['/bin/sage ', '/bin/lean ', '/usr/bin/bwrap ']),cmd
        except (OSError,PermissionError):pass

base=W/'run/final_002'
for name in ['BUDGET_ANALYSIS.json','C_DOMAIN_PREFLIGHT.json','C_SLICES_CHECK.json',
             'C_SOURCE_BINDING.json','TOOLCHAIN_GATE.json','LEAN_RUNTIME.sha256','FORMAL_TYPES_TERMS.txt']:
    shutil.copyfile(base/'build'/name,W/'artifacts'/name)
shutil.copyfile(W/'replay/fresh_002/REPLAY_RESULT.json',W/'artifacts/fresh_replay.json')
analysis=json.loads((W/'artifacts/BUDGET_ANALYSIS.json').read_text())
text=(W/'artifacts/FORMAL_TYPES_TERMS.txt').read_text()
assert 'warning:' not in text
assert 'sorryAx' not in text and 'Lean.ofReduceBool' not in text
assert '⋯' not in text and '\n...\n' not in text, 'truncated term output'
names=re.findall(r'^theorem (Run002\.[\w]+)',text,re.M)
assert len(names)==len(set(names))==15,names
exports=[]; axioms={}
for name in names:
    typ=re.search(r'^theorem '+re.escape(name)+r'(.*?) :=\n',text,re.M|re.S)
    assert typ,name
    ax=re.search("'"+re.escape(name)+r"' depends on axioms: \[([^\]]*)\]",text)
    if ax:
        used=[s.strip() for s in ax.group(1).split(',') if s.strip()]
    else:
        assert "'"+name+"' does not depend on any axioms" in text,name
        used=[]
    assert set(used)<={'propext','Classical.choice','Quot.sound'},(name,used)
    axioms[name]=used
    exports.append({'name':name,'printed_type':'theorem '+name+typ.group(1),
                    'proof_terms':'artifacts/FORMAL_TYPES_TERMS.txt',
                    'module':'formal/Ledger.lean','module_sha256':sha(W/'formal/Ledger.lean'),
                    'status':'KERNEL_CHECKED_ALGEBRA_ONLY',
                    'source_instantiated':False})
for p in (W/'formal').glob('*.lean'):
    code=p.read_text()
    assert not re.search(r'\b(sorry|admit|native_decide|axiom)\b|Lean\.ofReduceBool',code),p
write('AXIOMS.json',{'exports':axioms,'forbidden_axioms':[],
      'audit_log':'artifacts/FORMAL_TYPES_TERMS.txt','audit_log_sha256':sha(W/'artifacts/FORMAL_TYPES_TERMS.txt')})
write('FORMAL_EXPORTS.json',{'exports':exports,'export_count':len(exports),
      'source_bound_exports':[],'B0_complete':False,'B5_complete':False})

receipts=[]; sages=[];commands=[]
for parent in ['run','replay']:
    for rp in sorted((W/parent).glob('*/receipt.json')):
        r=json.loads(rp.read_text())
        rel=rp.parent.relative_to(W).as_posix()
        receipts.append({'path':rp.relative_to(W).as_posix(),'sha256':sha(rp),
                         'exit_code':r['exit_code'],'steps':len(r['steps']),
                         'sources_unchanged':r['sources_unchanged']})
        for index,s in enumerate(r['steps']):
            for key in ['stdout','stderr']:
                assert sha(rp.parent/s[key])==s[key+'_sha256'],(rel,key)
            commands.append(json.dumps({'run':rel,'step':index,**s},sort_keys=True))
            if any(a.endswith('/bin/sage') for a in s['argv']):
                sages.append({'run':rel,'step':index,'argv':s['argv'],'exit_code':s['exit_code'],
                              'stdout':rel+'/'+s['stdout'],'stderr':rel+'/'+s['stderr'],
                              'stdout_sha256':s['stdout_sha256'],'stderr_sha256':s['stderr_sha256']})
write('EXECUTION_RECEIPTS.json',{'runs':receipts,'external_interruption':'artifacts/initial_001_EXTERNAL_TERMINATION.json',
                              'own_jobs_completed':True})
write('SAGE_RUNS.json',{'sage_version':'10.9','preparser_required':True,'runs':sages})
(W/'COMMANDS.log').write_text('# Actual receipt-backed bounded commands; failed steps retained.\n'+'\n'.join(commands)+'\n')

write('SOURCE_ERROR.json',{'schema':'T03_RUN002_SOURCE_ERROR_V1','status':'OPEN',
      'exact_algebraic_ledger':'LEDGER_TERM_BINDINGS.json',
      'historical_majorant_diagnostic':analysis['historical_majorant'],
      'conditional_D_per_vector':analysis['D_per_vector_conditional'],
      'conditional_A3_raw':analysis['A3_raw_conditional'],
      'conditional_A1_A3raw_Dpervector_E':analysis['A1_A3raw_Dpervector_E_conditional'],
      'new_uniform_source_gap_bound':None,'source_kernel_bound_proved':False,
      'required_domain_counterexample':False,'source_changed':False,'owner_accepted':False})
utc=datetime.datetime.now(datetime.timezone.utc).isoformat()
result={'task_id':'FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002','roadmap_id':'T03',
        'status':'BLOCKED_UPSTREAM_EXPORTS','partial_result':'KERNEL_ALGEBRA_AND_B0_B1_DIAGNOSIS',
        'frozen_utc':utc,'executor':'openai/gpt-6-astra-fast',
        'session_id':'ses_f13640949ffeJ0RtC7tFAz07UR','formal_theorems':len(exports),
        'B0':'PARTIAL_EXACT_ALGEBRA_SOURCE_BRIDGE_OPEN',
        'B1':'PARTIAL_EXACT_RESIDUAL_MAP_AND_INSUFFICIENT_CONDITIONAL_BOUNDS',
        'B2':'OPEN_UNIFORM_SOURCE_BASIS_RESIDUALS',
        'B3':'BLOCKED_INTEGER_DEFECT_METRIC_BRIDGE',
        'B4':'BLOCKED_3072_OLD_TARGET_DEFECT_TRANSPORT',
        'B5':'BLOCKED_SOURCE_GAP_AND_REAL_RINT_BRIDGE',
        'new_uniform_source_gap_bound':None,'historical_majorant_diagnostic':analysis['historical_majorant'],
        'full_recovery_proved':False,'fresh_replay':'FRESH_REPLAY_PASS','semantic_matches':10,
        'source_changed':False,'production_source_changed':False,'new_source_patch_integrated':False,
        'new_M0_eta_pre':None,'required_domain_counterexample':False,'owner_accepted':False,
        'independent_review_performed':False,'own_jobs_completed':True}
write('RESULT.json',result)

(W/'TOOLCHAIN.txt').write_text(
    'Lean4.34.0; Mathlib4@5ed2965256430c3649e86755f9576b54eca72435; SageMath10.9\n'
    'Sage invoked as /home/footfalcon/miniforge3/envs/sage/bin/sage <name>.sage with standard preparser.\n'
    'Lean /home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean -j1 -M2048.\n'
    'Pinned library provenance: inputs/supplemental/library_provenance; verified all source/cache hashes.\n'
    'Runtime closure: artifacts/LEAN_RUNTIME.sha256; library gate: artifacts/TOOLCHAIN_GATE.json.\n'
    'Cached libraries reused; own formal modules freshly rebuilt. No network/Git commands.\n'
    'C gcc14.2 (Debian host), C99, literal pinned Makefile CFLAGS/-O, FPEMU.\n'
    'Normal8GiB, wall1800s/step, one worker. ASan separate shadow with2GiB runtime RSS cap.\n'
    'All project writes HOME/TMP/cache/build under each W/DEST; source/inputs read-only.\n')
(W/'CLAIM.md').write_text('''# Zakres wyniku RUN_002

**BLOCKED_UPSTREAM_EXPORTS**; częściowy wynik algebraiczny i diagnostyczny.
15 lokalnych twierdzeń Lean ma czysty kernel build i wydrukowane typy/terms/
aksjomaty. Obejmują dwa dokładne ledger identities, zachowane correlations,
residuals CM/suffix/terminal, transport sumy i rachunek proponowanego budżetu.
Nie mają jeszcze source-refinement instancji i nie dowodzą pełnego B0–B5.

Literalne publiczne C slices normal/UBSan/ASan i QQ oracle potwierdzają m.in.
pominięty przy zmianie ramy update-add defect ±2^-25. To świadek lokalnego
obowiązku, nie emitted-key/history counterexample. 768 complex suffix slots
obu wektorów,27 rint cases z parity/±0/subnormal oraz3 terminale są kontrolami.

Nie uzyskano nowego uniform source boundu. Historyczny rachunek≈6086.40076165;
warunkowe D≈11.07859487,A3≈0.42676412 nadal nie domykają celu. Nie użyto ich
jako założonych przesłanek recovery. Task domain/gates są niezmienione.

P02 add/mul/div/sqrt/caller-real contracts, P06 reference/source mapping,
integer-defect transport, inverse/iFFT i real-rint bridge pozostają otwarte.
owner_accepted=false; niezależny odbiór ma zostać zlecony osobno.
''')
(W/'NEXT_INTERFACE.md').write_text('''# Następny konkretny krok

1. Dostarczyć odebrany pin albo nowy lokalny proof **P02_ARITH**: literalne
   fpr_add/fpr_mul (a dla całej domeny także div/sqrt), z finite/result/domain
   oraz real-error refinement. P02 freeze4e8942cc… jest PARTIAL, bez odbioru;
   same PrimObligation/word rint nie stanowią tych twierdzeń.
2. Związać P06 source-call3072 mapping/Z, exact ring/inverse i emitted frame.
3. Na tej podstawie skonstruować `INTEGER_DEFECT_TRANSPORT`: od starego
   targetu, przez actual downward split/update i upward merge/sub, dla tego
   samego Y. Terminal1643 eadd oraz identyczne recomputed product snapshots
   są obowiązkami jawnymi; lokalne lematy RUN_002 nadają się do tej kompozycji.
4. Dopiero potem wyprowadzić ciaśniejsze source D/A3, uniform basis residuals,
   wspólną metrykę δ/eroot, transport3072 defektów i końcowy strict gap/rint.

Konsumowalne teraz:15 kernelowych TOŻSAMOŚCI algebraicznych z
FORMAL_EXPORTS.json, nie source error exports; dokładny ledger i otwarte
interfejsy z EXPORT_DEPENDENCIES.json. Rebuild/audit oraz piny są w pakiecie.
Nie ma upoważnienia do wznowienia innych W/modeli ani zmiany statusów B20.
''')
report=f'''# T03-B / REFERENCE_INTEGER_RECOVERY_RUN_002 — raport końcowy

**Status: BLOCKED_UPSTREAM_EXPORTS.** Częściowy wynik: kernelowa algebra B0/B1,
diagnoza mostu integer-reference i świeżo odtworzone niewystarczające majoranty.
Freeze UTC: {utc}. Autor projektu: Niirmata; wykonawca GPT-6 Astra Fast,
sesja `ses_f13640949ffeJ0RtC7tFAz07UR`. Falcon Project / Thomas Pornin oraz
licencje pozostają zachowane. owner_accepted=false.

## Co wykazano

- Zweryfikowano1396/1396 bootstrap members,32721541 B, exact set/hashe/no
  symlink/escape; source17 także exact set i wszystkie SHA. HEAD odczytany
  bez Git:9e958a3b8df0ca00f621f976c292b30adfa4b670,main; źródła z pinów TASK.
- {len(exports)} twierdzeń Lean4.34+przypięty Mathlib ma czyste logi i aksjomaty
  wyłącznie z allowlist propext/Classical.choice/Quot.sound. To dokładne
  identities w pierścieniu, a nie kernel refinement C. Typy i pełne terms:
  `artifacts/FORMAL_TYPES_TERMS.txt`; eksporty: `FORMAL_EXPORTS.json`.
- Rozpisano10 termów z source spans/read-time snapshots. A4+B grupuje się
  dokładnie do −Z DeltaB. Suma D drugiego wektora ma literalny porządek
  y*w11+x*w01; używa starego x, nie nadpisanego tx. Common reciprocal image
  ma zerową drugą składową — korelacja zachowana algebraicznie.
- W terminalu relative-to-old-target residual zawiera eadd1643. Ten sam
  stored rx się anuluje, niezależnie od jego half rounding. H6P xi używa już
  updated mu0; jego3 innovation defects nie zamykają tego mostu. Literalne
  C local controls potwierdzają niezerowy defekt±1/33554432 przy zerowych
  pozostałych subtraction/half defects w2 publicznych przykładach. rx/sub0
  są ponownie policzone pure primitives z actual callback mu0/returned z1,
  z kontrolą identycznego final raw z0; to nie kernel frame proof. **Brak
  emitted/full-history membership: to nie kontrprzykład celu.**

## Osiągnięte liczby i ich znaczenie

| Rachunek | Wynik (przybliżenie; dokładne QQ/RIF w JSON) |
|---|---:|
| Historyczna suma10 majorant |6086.40076164597|
| Stara ablacja A2/A4/B/C1/C2/C3 |16.10835955645|
| Warunkowe D, pojedynczy wektor/A2 |11.07859486908|
| Warunkowe A3, pełne rho i modulus caps |0.42676412142|
| Warunkowa pozostała suma A1+A3raw+Dpervector+E |11.51331244515|
| Proponowany budżet (TYLKO CEL) |6557/16000=0.4098125|

**Nowy udowodniony uniform source gap bound: brak (null).** Nie przenoszę
historycznych mixed certyfikatów do nowej source formalizacji przez etykietę.
Poprawy arytmetyczne B1 są niewystarczające nawet warunkowo. Duża majoranta
nie jest dolnym ograniczeniem rzeczywistego błędu i nie obala recovery.

## B0–B5 i rzeczywista blokada

B0: exact root-space algebra wykonana; physical inverse/source instancja
otwarta. B1: literalny residual ledger D i target/rho oraz wspólna korelacja
reciprocal rozliczone, ciaśniejszy source bound nieudowodniony. B2: algebra
korelacji jest dostępna, uniform FFT basis residuals otwarte. B3/B4:
H6P reconstruction/innovation frame wymaga pełnego mostu do integer reference,
obejmującego downward split/update i wszystkie3072 actual defects. B5:
tylko arytmetyka docelowej sumy w kernelu; actual strict gap i rint OPEN.

P02 local freeze manifest `4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01`
jest zgodny68/68, ale bez V02 acceptance i z jawnymi brakami add/mul/div/sqrt
real contracts. Snapshot STATUS: P02 IN_PROGRESS,V02 BLOCKED_PRODUCER_FREEZE,
P06 BLOCKED_UPSTREAM_EXPORTS. Nie konsumowano nieodebranych twierdzeń.
7 dokładnie opisanych missing interfaces: `EXPORT_DEPENDENCIES.json`.

## Wykonanie i odtwarzalność

Sage10.9 przez rzeczywiste `sage *.sage`, preparser ZZ/QQ/RIF256. Lean-j1/-M2048,
network-off,1800s/krok/8GiB; ASan osobno zgodnie z shadow policy. Własne
HOME/TMP/cache/build pod W, RO source/inputs. TOOLCHAIN_GATE weryfikuje pełne
source/cache manifests bibliotek; runtime closure jest przypięta. Biblioteki
reuse, własne moduły fresh build. Nie wykonano Git/push, innych modeli/sesji,
KeyGen, private loadera, pełnego Sign ani nowych sekretów.

Final baseline7/7 kroków exit0. Normal/UBSan/ASan local C controls PASS.
Fresh replay: **FRESH_REPLAY_PASS,10/10 recomputed semantic matches**, osobny
absent DEST, fresh build/cache, hashe źródeł przed/po zgodne. Raw stdout/stderr,
argv, wyjścia i producent każdego pliku pozostają w receiptach. `REPLAY.md`
podaje komendę po freeze. Failed initial_001 harness-timeout oraz normal_001
Sage-JSON serialization zachowane w całości; nie zastępują ich nowe logi.

Kontrole wykonane: missing-D/A3, double A_total, component/modulus, shrink
endpoint, stale operand, wrong suffix sign, omitted terminal update, no-op,
obie granice rint/parity/±0/subnormals. **Nie wykonano nowego kernelowego
twiddle/order refinement ani uniform iFFT proofu**; ich kontrola pozostaje
w odpowiednich otwartych interfejsach, a historycznych testów nie zaliczam
jako nowych PASS. Nie zmieniono żadnej source implementacji.

## Własna ocena i następny krok

RUN_002 usuwa niejednoznaczność ledgeru i precyzuje brakujący most. Pokazuje,
dlaczego samo zmniejszanie3 starych stałych nie domyka problemu. Najważniejszy
nowy wynik to source-located old-target update obligation, poparty algebraicznym
proofem i literalnym lokalnym C. Nie uzyskano integer recovery i nie ma nowego
wniosku bezpieczeństwa. Najbliższy konkretny krok: P02 literal add/mul
real-error+caller-domain export oraz P06 mapping; potem source-bound pełny
INTEGER_DEFECT_TRANSPORT, dopiero dalej poprawa B1–B5. Wszystkie moje joby
są zakończone. Niezależny odbiór zostanie zlecony osobno.

Piny: TASK `c10d50304e8272df1f8367c5e19a432a0746e1239d1d7029c4447b20df75781a`;
bootstrap `a47dc77e48fb521b17de30115be67dca9e97221063e6b001af5cb4db4bc63f9f`;
source17 `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
source_changed=false; production_source_changed=false;
new_source_patch_integrated=false; new_M0_eta_pre=null; owner_accepted=false.
'''
(W/'REPORT.md').write_text(report)
handoff=(W/'HANDOFF.md').read_text()
handoff+=f'''\n## Finalny frozen handoff — {utc}\n
- Status: **FROZEN / BLOCKED_UPSTREAM_EXPORTS**. Jedyny wykonawca:
  GPT-6 Astra Fast, `ses_f13640949ffeJ0RtC7tFAz07UR`.
-15 kernel-checked algebraic identities; source B0–B5 niezamknięte.
- Brak nowego uniform source boundu; historyczny rachunek6086.40076165.
  Warunkowe D11.07859487/A3 0.42676412 nadal niewystarczające.
- P02/P06 i INTEGER_DEFECT_TRANSPORT: dokładne typy w EXPORT_DEPENDENCIES.
- Fresh replay10/10, normal/UBSan/ASan PASS; failed attempts zachowane.
- Wszystkie własne joby zakończone. Brak Git/push/relay/innych wykonawców.
- REPORT_SHA256={sha(W/'REPORT.md')}
- OUTPUTS_SHA256 podany zewnętrznie po zapisaniu manifestu (bez cyklu hasha).
- owner_accepted=false; niezależny odbiór nie został wykonany.
- Nie wznawiać frozen runów. Nowy replay tylko do nowego absent DEST.
'''
(W/'HANDOFF.md').write_text(handoff)
(W/'OUTPUT_SCOPE.md').write_text('''# Dokładny zakres OUTPUTS.sha256

Manifest obejmuje wszystkie pliki inputs (publiczny bootstrap + read-only
supplemental provenance), formal/scripts/checks, artefakty, top-level raporty
oraz zachowane źródłowe snapshoty/raw logs/receipty zakończonych runów.
Manifest nie obejmuje siebie. Dla run/build obejmuje tekstowe dowody,
matematyczne JSON/NDJSON i C inputs/harness/provenance/logi, nie binaria.

Wyłączone celowo: home,tmp,cache,config,data,sage, .olean/.ir/executables,
preparsed tymczasowe .sage.py i pozostałe working caches. Żaden wyłączony
plik nie stanowi dowodu lub required semantic result; własne formalne
moduły i C harness są odbudowywane przez replay. Biblioteki to external RO
pinned closure, z pełnymi source/build/runtime manifests i pochodzeniem;
pakiet nie duplikuje wielu GiB bibliotek. Nie zawiera nowych sekretów.

Nieudany initial_001 nie ma zmyślonego internal exit/receipt: jego source/logs
oraz zewnętrzny timeout record są objęte manifestem. Po freeze żadna
przypięta zawartość nie jest modyfikowana. Nowe replaye mają osobny DEST
i nie są automatycznie dodawane do tego frozen manifestu.
''')

selected=[]
for p in W.iterdir():
    if p.is_file() and p.name!='OUTPUTS.sha256': selected.append(p)
for part in ['inputs','scripts','formal','checks','artifacts']:
    selected.extend(p for p in (W/part).rglob('*') if p.is_file())
build_allow={'TOOLCHAIN_GATE.json','LEAN_RUNTIME.sha256','BUDGET_ANALYSIS.json',
 'C_DOMAIN_PREFLIGHT.json','C_SLICES_CHECK.json','C_SOURCE_BINDING.json','C_SLICES.ndjson',
 'public_cases.h','local_slices.c','FORMAL_TYPES_TERMS.txt','C_COMMANDS.json',
 'c_version.stdout','version.stderr','c_compile.stdout','compile.stderr','run.stderr','check_bounds.sage','check_slices.sage'}
for parent in ['run','replay']:
    for dest in (W/parent).iterdir():
        if not dest.is_dir():continue
        for p in dest.rglob('*'):
            if not p.is_file():continue
            rel=p.relative_to(dest)
            if rel.parts[0] in ['source','logs'] or rel.as_posix() in ['receipt.json','REPLAY_RESULT.json'] or (rel.parts[0]=='build' and len(rel.parts)==2 and p.name in build_allow):
                selected.append(p)
selected=sorted(set(selected))
for p in selected:
    assert not p.is_symlink() and p.resolve().is_relative_to(W)
manifest=''.join(sha(p)+'  '+p.relative_to(W).as_posix()+'\n' for p in selected)
(W/'OUTPUTS.sha256').write_text(manifest)
for p in selected+[W/'OUTPUTS.sha256']:p.chmod(0o444)
for line in (W/'OUTPUTS.sha256').read_text().splitlines():
    h,rel=line.split('  ',1);assert sha(W/rel)==h,rel
print('FROZEN_BLOCKED_UPSTREAM_EXPORTS',len(selected),'members')
print('REPORT_SHA256='+sha(W/'REPORT.md'))
print('OUTPUTS_SHA256='+sha(W/'OUTPUTS.sha256'))
print('owner_accepted=false; own_jobs_completed=true')
