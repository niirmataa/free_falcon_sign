import datetime,hashlib,json
from pathlib import Path
W=Path.cwd()
def read(rel):return (W/rel).read_bytes()
def load(rel):return json.loads(read(rel))
def sha(rel):return hashlib.sha256(read(rel)).hexdigest()
def put(rel,obj):
    with (W/rel).open('x') as f:json.dump(obj,f,indent=2);f.write('\n')
audit=load('artifacts/audit.json');ob=load('OBLIGATIONS.json');test=load('artifacts/test_suite.json')
assert audit['total_theorems']==186 and audit['permitted_main_verdict']=='PARTIAL_PROOF'
fresh=W/'tmp/replay_002';replay=json.loads((fresh/'REPLAY_RESULT.json').read_text());assert replay['status']=='FRESH_REPLAY_PASS' and len(replay['matches'])==98
for item in replay['matches']:assert sha(item['path'])==item['sha256']
archive=W/'artifacts/replay_logs';archive.mkdir()
log=(fresh/'COMMANDS.log').read_bytes()
(W/'artifacts/replay_COMMANDS.log').write_bytes(log)
streams=[]
for row in map(json.loads,log.splitlines()):
    for key in ['stdout','stderr']:
        src=fresh/row[key];dst=archive/src.name
        with dst.open('xb') as f:f.write(src.read_bytes())
        h=hashlib.sha256(dst.read_bytes()).hexdigest();assert h==row['stream_sha256'][key]
        streams.append(dict(original=row[key],archive=str(dst.relative_to(W)),sha256=h))
replay['archived_streams']=streams;replay['archived_commands']='artifacts/replay_COMMANDS.log'
put('artifacts/fresh_replay.json',replay)
failed=W/'tmp/replay_001/COMMANDS.log'
if failed.exists():
    target=W/'artifacts/failed_replay_001';target.mkdir()
    (target/'COMMANDS.log').write_bytes(failed.read_bytes())
    for row in map(json.loads,failed.read_text().splitlines()):
        for key in ['stdout','stderr']:
            src=failed.parent/row[key]
            (target/src.name).write_bytes(src.read_bytes())
commands=[json.loads(l) for l in read('COMMANDS.log').splitlines()]
gcc=next(read(r['stdout']).decode() for r in commands if r['argv']==['/usr/bin/gcc','--version'] and r['exit_code']==0)
lean=next(read(r['stdout']).decode() for r in commands if '/lean' in r['argv'][0] and r['argv'][-1:]==['--version'] and r['exit_code']==0)
certificate=load('artifacts/constants_certificate.json')
with (W/'TOOLCHAIN.txt').open('x') as f:
    f.write(gcc+'\n'+lean+'\nSage version: '+certificate['sage_version']+'\nSage Python: '+certificate['python_version']+'\n')
    f.write('GCC/C99/x86_64/LP64; 8-bit bytes, uint32/int32 32, uint16/int16 16, long/size_t 64.\n')
    f.write('Flags copied from source/Makefile plus -std=c99. Full argv: artifacts/build-*.json.\n')
    f.write('ASan/UBSan enabled, detect_leaks=1; no automatic disabling of LSan.\n')
    f.write('Sage invoked by /home/footfalcon/.local/bin/sage scripts/certify.py; actual sage.all imports.\n')
    f.write('Write-isolated bwrap: read-only root/source, writable W, unshared network and PID namespace.\n')
    f.write('Finite wall/CPU limits in COMMANDS; no dependency installation or mathlib.\n')
sources={n:h for h,n in (l.split() for l in read('inputs/source_hashes.sha256').decode().splitlines())}
out=dict(schema='FT1536_L_NTT_RESULT_V1',created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
 result='PARTIAL_PROOF',lemma='L_NTT',source_integrated=False,owner_accepted=False,full_L_V_proved=False,
 claim='CLAIM.md',derivation='DERIVATION.md',obligations='OBLIGATIONS.json',
 parameters={'ternary':1,'logn':10,'N':1536,'q':18433,'Phi':'X^1536-X^768+1','R_M':65536,'Rt':10237,'R2t':4564,'Q0It':18431},
 quantifier='all canonical h,r,c, legal aligned sufficiently sized buffers and required nonaliasing; not restricted to KeyGen support',
 consumed_L_RHO={'result':'L_RHO_PROVED_FOR_PINNED_MODEL','report_sha256':'ca0e3fb23542656b16c61495506db5956b3d6043d5ef26fd56396502c0b444e3',
  'outputs_sha256':'d5cabfdaf69f080bf31b9e1903bacc4a319f87cd38cb4b643ff5e98f1240f687','candidate_manifest_sha256':'2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a',
  'Rho_lean_sha256':'daa68021e0f5bac53cf0384a5e10b0537eb6a8ca9d02f0f2970c6ff6eefc7fe8'},
 source_sha256=sources['falcon-vrfy.c'],source_hashes=sources,source_unchanged=True,
 model={'compiler':'GCC 14.2.0','language':'C99','platform':'Linux x86_64 LP64','unsigned_wrap':'explicitly modeled; not assumed absent','compiler_formalized':False},
 formal={'total_declarations':186,'modules':audit['formal'],'final_theorem':'FT1536Composition.L_NTT_after_global_interfaces',
  'final_scope':'CONDITIONAL_NOT_INSTANTIATED_FOR_SOURCE','open_hypotheses':['forward_product','inverse_forward'],
  'no_sorry_or_local_goal_axiom_in_final_files':True},
 constants={'dynamic_generator':'mq_mkgm3(logn=10)','used_indices':[0,1023],'uninitialized_tail_not_exported':[1024,2047],
  'required_division_denominators':[1874,8479,1536],'inverse_scale_word':6187,
  'kernel_record_counts':audit['kernel_constant_record_counts'],'primality':'kernel small-divisor and factorization proof'},
 implementation_checks={'status':'PASS','primitive_cases':737,'unsigned_product_wrap_cases':605,'all_nonzero_division_denominators':18432,
  'baseline_pipeline_runs':28,'cases':7,'normal_ASan_UBSan_observed_and_plain':True,'leak_detection':'enabled and passed',
  'mutants_rejected':4,'noop_passed':True,'counterexample_found':False,'record':'artifacts/test_suite.json'},
 closed_local_obligations=['W_ADD','W_SUB','W_MONT','PRIME_ROOT','DIV_USED','GEN10','LOCAL_BLOCKS'],
 global_open=['FORWARD_GLOBAL','INVERSE_GLOBAL','SOURCE_GLOBAL_INSTANTIATION','PRODUCT'],
 exact_gap='No closed global source-buffer/CRT model instance establishes forward_product and inverse_forward for the in-place C functions. Local matrices, fixed index checks and empirical agreement do not remove these premises.',
 RHO_substitution='r=rho(s) gives canonical r congruent to s; identification d=canonical(h*s-c) remains conditional on L_NTT',
 fresh_replay={'status':'PASS','semantic_files_identical':98,'receipt':'artifacts/fresh_replay.json','phase':'PRE_FREEZE_REHEARSAL'},
 technical_events=['initial Words/Linear proof drafts failed and are retained outside final proof scope','first fresh replay failed on copied derived slices directory; preserved, corrected copy recipe, new replay_002 passed','helper harness compiler indentation warnings retained'],
 next_recommendation='Instantiate a global source/CRT buffer invariant for forward and inverse with exact physical ordering; discharge forward_product and inverse_forward and then instantiate the existing final composition.',
 report='REPORT.md',report_sha256=sha('REPORT.md'),output_scope='OUTPUT_SCOPE.md',output_manifest='OUTPUTS.sha256')
put('RESULT.json',out)
print(json.dumps({'result':out['result'],'report_sha256':out['report_sha256'],'formal_declarations':186,'global_open':out['global_open']},indent=2))
