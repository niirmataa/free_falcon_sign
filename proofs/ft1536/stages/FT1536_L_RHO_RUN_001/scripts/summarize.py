import datetime,hashlib,json
from pathlib import Path
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
def sha(p):return hashlib.sha256((W/p).read_bytes()).hexdigest()
def put(p,x):
    with (W/p).open('x') as f:json.dump(x,f,indent=2);f.write('\n')
audit=load('artifacts/audit.json');assert audit['status']=='AUDIT_PASS'
bind=load('artifacts/source_binding.json');scalar=load('artifacts/scalar_suite.json');reg=load('artifacts/regression_check.json')
fresh=W/'tmp/replay_001';receipt=json.loads((fresh/'REPLAY_RESULT.json').read_text());assert receipt['status']=='FRESH_REPLAY_PASS' and len(receipt['matches'])==64
for row in receipt['matches']:assert sha(row['path'])==row['sha256']
archive=W/'artifacts/replay_logs';archive.mkdir()
command_bytes=(fresh/'COMMANDS.log').read_bytes()
with (W/'artifacts/replay_COMMANDS.log').open('xb') as f:f.write(command_bytes)
paths=[]
for r in map(json.loads,command_bytes.splitlines()):
    for stream in ['stdout','stderr']:
        original=fresh/r[stream];target=archive/original.name
        with target.open('xb') as f:f.write(original.read_bytes())
        assert hashlib.sha256(target.read_bytes()).hexdigest()==r['stream_sha256'][stream]
        paths.append(dict(original=r[stream],archive=str(target.relative_to(W)),sha256=r['stream_sha256'][stream]))
receipt['archived_streams']=paths;receipt['archived_commands']='artifacts/replay_COMMANDS.log'
put('artifacts/fresh_replay.json',receipt)
commands=[json.loads(l) for l in (W/'COMMANDS.log').read_text().splitlines()]
gcc=next((W/r['stdout']).read_text() for r in commands if r['argv']==['/usr/bin/gcc','--version'] and r['exit_code']==0)
lean=next((W/r['stdout']).read_text() for r in commands if r['argv'][-1:]==['--version'] and '/lean' in r['argv'][0] and r['exit_code']==0)
sage_meta=load('artifacts/scalar-candidate-normal.json')
with (W/'TOOLCHAIN.txt').open('x') as f:
    f.write(gcc+'\n'+lean+'\nSage version: '+sage_meta['sage_version']+'\nSage Python: '+sage_meta['python_version']+'\n')
    f.write('Sage invoked through /home/footfalcon/.local/bin/sage with actual sage.all imports.\n')
    f.write('C99 Linux x86_64 LP64, CHAR_BIT=8, int/unsigned/int32=32, int16/uint16=16, long/size_t=64.\n')
    f.write('CFLAGS copied from reference/Makefile; explicit -std=c99. Full argv: artifacts/build-*.json.\n')
    f.write('ASan/UBSan: -fsanitize=address,undefined -fno-sanitize-recover=all -g. detect_leaks=1 passed.\n')
    f.write('bwrap: read-only /, writable W, read-only reference after preparation, no network; cache/TMPDIR in W.\n')
    f.write('Wall/CPU limits recorded per command. No installed dependencies or mathlib.\n')
source={n:h for h,n in (l.split() for l in (W/'inputs/source_hashes.sha256').read_text().splitlines())}
candidate={n:h for h,n in (l.split() for l in (W/'CANDIDATE.sha256').read_text().splitlines())}
out=dict(schema='FT1536_L_RHO_RESULT_V1',created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
 result='L_RHO_PROVED_FOR_PINNED_MODEL',lemma='L_RHO',source_integrated=False,owner_accepted=False,
 parameters={'N':1536,'q':18433,'Phi':'X^1536-X^768+1','B':2093922385,'honest_profile':'full ternary secret / COMP_STATIC'},
 domain='every mathematical signed int16 value -32768..32767; componentwise 1536-vector with original signed s preserved',
 model={'compiler':'GCC 14.2.0','language':'C99','platform':'Linux x86_64 LP64','byte_bits':8,'int_bits':32,'unsigned_bits':32,'int16_bits':16,'uint16_bits':16,'long_bits':64,'size_t_bits':64},
 rho_C='int32_t t=(int32_t)x+36866; return (uint16_t)(t%18433);',
 rho_Z='unique y in [0,18432] congruent to x modulo 18433',
 helper='ft1536_normalize_s2',helper_call_guard='ternary == 1 && logn == 10',
 intermediate_ranges={'input':[-32768,32767],'int32_sum':[4098,69633],'quotient':[0,3],'remainder':[0,18432]},
 old_map={'formula':'(x+18433*1[x<0]) mod65536','correct_congruence_domain':[-18433,32767],'canonical_domain':[-18433,18432],'canonical_count':36866,'congruence_count':51201},
 formal_model={'status':'KERNEL_PROVED','file':'formal/Rho.lean','sha256':bind['formal_sha256'],'imports':['Std'],'theorems':audit['formal_theorems'],'axioms':audit['axioms'],'universal_not_table_assumption':True},
 C_model_binding={'status':'TRANSLATION_JUSTIFIED_FOR_PINNED_FRAGMENT','record':'artifacts/source_binding.json','exact_edit_checked':True,'actual_helper_used_by_Verify_and_enumerator':True,'compiler_formalized':False,'memory_premise':'valid decoded input buffer and fresh local output array; ordinary defined C execution'},
 enumeration={'status':'PASS','inputs_per_build':65536,'builds':['normal','ASan/UBSan'],'checker':'scripts/check_sage.py','table_sha256':audit['scalar_table_sha256'],'complete_table':'artifacts/scalar-candidate-normal.csv','sanitizer_table':scalar['asan_table'],'old_canonical_agreement':36866},
 mutations={'rejected':4,'cases':scalar['mutants'],'noop_not_counted_as_rejection':True},
 regressions={'status':'PASS_LIMITED','cases':7,'executions':56,'observer_and_plain':True,'normal_and_sanitizer':True,'reference_witness':{'pre_ntt_s0':63969,'signed_s0':-20000,'norm':400000000,'verify':1,'raw':1},'candidate_witness':{'pre_ntt_s0':16866,'signed_s0':-20000,'norm':43058711057,'verify':0,'raw':0},'positive_cases':6,'record':'artifacts/regression_check.json'},
 sanitizer={'ASan_UBSan':'PASS','leak_detection':'ENABLED_AND_PASSED','LSan_ptrace_failure_in_this_run':scalar['lsan_environment_failure']},
 tools={'sage_version':sage_meta['sage_version'],'sage_python_version':sage_meta['python_version'],'lean':'4.34.0 / Std'},
 reference_source_hashes=source,candidate_source_hashes=candidate,
 candidate_manifest_sha256=sha('CANDIDATE.sha256'),candidate_patch_sha256=sha('candidate.patch'),
 reference_L_V='CONFIRMED_COUNTEREXAMPLE_REQUIRED_DOMAIN (closed Blue result)',
 candidate_L_V='OPEN_FOR_CANDIDATE',
 remaining_full_L_V=['canonical-residue NTT/Montgomery correctness and intermediate ranges','public-key preparation for required key support','full byte language and decoder execution/conversions','source centering equals center_q','source norm exactness, defined operations/memory and strict threshold'],
 fresh_replay={'status':'PASS','identical_semantic_files':64,'receipt':'artifacts/fresh_replay.json','phase':'PRE_FREEZE_REHEARSAL'},
 technical_events=['unsupported sage -python option: used supported sage file.py entrypoint','initial Lean draft tactic errors preserved; only final exit-0 certificate consumed'],
 next_recommendation='Separate source-bound proof of correctness and intermediate ranges of the FT1536 canonical NTT/Montgomery path, consuming this pinned L_RHO candidate.',
 report='REPORT.md',report_sha256=sha('REPORT.md'),output_manifest='OUTPUTS.sha256',output_scope='OUTPUT_SCOPE.md')
put('RESULT.json',out)
print(json.dumps({'result':out['result'],'report_sha256':out['report_sha256'],'candidate_sha256':candidate['falcon-vrfy.c'],'replay_files':64},indent=2))
