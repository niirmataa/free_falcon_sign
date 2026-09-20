"""Prepare a source-pinned manual floor fix task and review selected raw timing records."""
import gzip
import hashlib
import itertools
import json
from pathlib import Path
import shutil
import subprocess
import sys
import time

repo=Path('/tmp/opencode/ft1536-noreply-history'); root=repo/'proofs/ft1536'
sys.path.insert(0,str(root/'tools'))
import archive
base='20ed84a86d9374b026e2ea9ab78f7656a6650a8c'
target=root/'background/FPEMU_FLOOR_CT_2026-09-20'
work=Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_FLOOR_CT_RUN_001')
old=Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_FPEMU_DUDECT_RUN_001')
scratch=Path('/tmp/opencode/ft1536-floor-ct-baseline-review')
archive.require(not work.exists() and not (target/'MANIFEST.sha256').exists() and not scratch.exists(),'Already prepared')
archive.require(subprocess.check_output(['git','rev-parse','HEAD'],cwd=repo).decode().strip()==base,'Git base')
origins=[]
def save_git(path,rel,pin=None):
    archive.checked_path(path); archive.checked_path(rel)
    data=subprocess.check_output(['git','show',base+':'+path],cwd=repo)
    if pin is not None: archive.require(archive.digest(data)==pin,'Git pin '+path)
    archive.put_once(target/rel,data)
    origins.append(dict(copy=rel,kind='git',original='git:'+base+':'+path,sha256=archive.digest(data),bytes=len(data)))
    return data
def save_external(path,rel,pin=None):
    data=archive.checked_bytes(path,pin)
    archive.put_once(target/rel,data)
    origins.append(dict(copy=rel,kind='completed_dudect',original=str(path),sha256=archive.digest(data),bytes=len(data)))
    return data
def generated(rel,value):
    data=archive.json_bytes(value); archive.put_once(target/rel,data)
    origins.append(dict(copy=rel,kind='maintainer_generated',sha256=archive.digest(data),bytes=len(data)))
def file_sha(path):
    with path.open('rb') as f: return hashlib.file_digest(f,'sha256').hexdigest()

raw=save_git('provenance/ft1536-candidate.sha256','CANDIDATE.sha256','2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a')
for name,h in archive.manifest(raw).items(): save_git('Extra/c/'+name,'source/'+name,h)
for name in ('README.md','benchmark.c','targets.c','campaign.py','prepare.py','launch.py'):
    save_git('tests/ft1536/dudect/'+name,'harness/'+name)
for name in ('dudect.h','LICENSE','README.md'):
    save_git('provenance/checks/2026-09-20-dudect-preflight/vendor/'+name,'vendor/'+name)
save_git('tests/ft1536/fpemu_smoke.c','checks/fpemu_smoke.c')
def projection(stage,group,pin,names):
    prefix='proofs/ft1536/stages/'+stage+'/'
    entries=archive.manifest(save_git(prefix+'OUTPUTS.sha256',group+'/OUTPUTS.sha256',pin))
    for name in names: save_git(prefix+name,group+'/'+name,entries[name])
zero='FT1536_H3_ZERO_SCALAR_RUN_001'
za=json.loads(archive.read(root/'stages'/zero/'artifacts/formal_audit.json'))
projection(zero,'ZERO','599b33ccaefb5109cf1ce25c2cd4cc639abb4330ea05e89f3537cf86d57900ab',
 ['REPORT.md','RESULT.json','ANALYTIC_PROOF.md','SOURCE_MODEL_BINDING.md','ERROR_LEDGER.md','M0_COMPATIBILITY.md',
  'artifacts/formal_audit.json',*za['sources_sha256'],
  *['scripts/'+n+'.py' for n in ('run','replaylib','lean','dyadic','fp_literal','audit')],
  *['logs/final/'+n+'.'+s for n in ('ZeroAudit','ZeroTypes') for s in ('stdout','stderr')]])
projection('FT1536_FPEMU_AUDIT_RUN_001','AUDIT','a20122da1d1bcca66f3c76d3590d14d46cc2342753691e544cebfd50bc930e41',
 ['REPORT.md','RESULT.json','FINDINGS.json','AUDIT_MATRIX.json','IMPACT_MATRIX.md','TIMING_REVIEW.md','TOOLCHAIN.txt',
  'checks/wrappers.c',*['scripts/'+n+'.py' for n in ('common','arithmetic','oracle','production_asm','platform_review')],
  *['artifacts/'+n for n in ('active_calls.json','production_asm.json','assembly_control_flow.json','disassembly.txt',
                            'falcon-sign.s','fpr-emulated.s','finding_reproducer.tsv')]])
for stage,group,pin,names in [
 ('FT1536_H3_ROOT_LDL_RUN_001','ROOT','9894d5f10e11f65ff7da338881c71d8008456ef4c371d45bb2119f5cd66abc48',['REPORT.md','RESULT.json','SOURCE_MODEL_BINDING.md']),
 ('FT1536_H3_NODE3_RUN_001','NODE3','a4a4116bcf1bbbdd5e73c49cf15828f81fa2eb6d7e05f6b9f81a06a2b6b7dd72',['REPORT.md','RESULT.json','SOURCE_MODEL_BINDING.md']),
 ('FT1536_H3_NODE2_RUN_001','NODE2','5601c991b2b27b639ff57708ed3d82fb4f167a25a156e886d7a9fb0bf0eacbf6',['REPORT.md','RESULT.json','SOURCE_MODEL_BINDING.md','UPSTREAM_REFINEMENT.md']),
 ('FT1536_H3_BINARY_TOWER_RUN_001','TOWER','48dadc20e00750dd4389fb49652a651cedc1645601fb1a1295cf44f57a75c26a',['REPORT.md','RESULT.json','SOURCE_MODEL_BINDING.md','NEXT_INTERFACE.md']),
 ('FT1536_M0_CONTRACT_RUN_001','M0','08c9b6afe630e11bd98f33a910476950442854e5925efaa7f8fa1d0d8c8d695d',['REPORT.md','RESULT.json','PROFILE.json','GAME.md','H3_INTERFACE.md','HOP_LEDGER.json']),
 ('FT1536_L_V_BRIDGE_RUN_001','LV','13fa5a9f706a962434c8ac479212af5ef33d91e1ececd6c948d68ed42871a74e',['REPORT.md','RESULT.json'])]:
    projection(stage,group,pin,names)
save_git('proofs/ft1536/validation/2026-09-20-fpemu-audit/CURRENT_IMPACT.md','review/PRIOR_CURRENT_IMPACT.md')

pins={'REPORT.md':'7387aa3b8aefeebb667c3ddd89608c02b81ff5f1d137dab00561a643f39d18ad',
      'RESULT.json':'a7b5ab0e090c8df72a971a80502171af6f1aa5326636c27367954cc5e14b8ec4',
      'PREPARATION.json':'ecc1c18eeff90e990c8b7bf1b8ea4e96d4887b361d715a735dfa5d3a1fe2c3b8',
      'LAUNCH.json':'adf57c412bf17e4d09c194a3773fdb9020de997732d8b54f6e2fd2b2770d33bc'}
for name,h in pins.items(): save_external(old/name,'DUD/'+name,h)
result=json.loads(archive.read(target/'DUD/RESULT.json'))
prep=json.loads(archive.read(target/'DUD/PREPARATION.json'))
archive.require(result['status']=='COMPLETED_SCHEDULE' and result['completed_rounds']==3
                and result['negative_controls_acceptable'] and len(result['trials'])==36 and len(result['controls'])==6,'Complete schedule')
archive.require(json.loads(archive.read(target/'DUD/LAUNCH.json'))['harness_git_commit']==base,'Harness commit')
for rel,h in prep['sealed_files'].items(): archive.require(file_sha(old/rel)==h,'Sealed preparation '+rel)
for name in ('controller.stdout','controller.stderr','service-start.txt','machine_launch.json','machine_final.json'):
    save_external(old/name,'DUD/'+name)
archive.require(not archive.read(old/'controller.stderr'),'Controller error')
scratch.mkdir()
binary=scratch/'baseline-replay'
shutil.copyfile(old/prep['binary'],binary); binary.chmod(0o755)
archive.require(file_sha(binary)==prep['sealed_files'][prep['binary']],'Replay executable')
selected_cases={'positive_loop','negative_floor','floor_fixed_positive','floor_fixed_negative','floor_random_signed'}
inventory=[]; reviews=[]
for item in [*result['controls'],*result['trials']]:
    rel=item['folder']; folder=old/rel
    row=json.loads(save_external(folder/'receipt.json','DUD/'+rel+'/receipt.json'))
    archive.require(row['status']==item['status'] and row['case']==item['case'] and row['result']['n']==item['n']
                    and row['raw_complete'] and row['reason'] is None and row['exit_code'] in (0,10),'Receipt consistency')
    for name in ('status.json','machine_before.json','machine_after.json'):
        save_external(folder/name,'DUD/'+rel+'/'+name)
    selected=item['case'] in selected_cases
    for name,h in row['files'].items():
        path=folder/name; archive.checked_path(rel+'/'+name)
        archive.require(path.is_file() and not path.is_symlink(),'Data file')
        checked=selected
        if checked: archive.require(file_sha(path)==h,'Raw/stream hash '+rel+'/'+name)
        included=selected and (name!='timings.bin.gz' or item['case']!='negative_floor')
        if included: save_external(path,'DUD/'+rel+'/'+name,h)
        inventory.append(dict(original=str(path),sha256=h,bytes=path.stat().st_size,hash_verified_now=checked,
                              included_in_bootstrap=included,trial=rel,role=name))
    if not selected: continue
    label=rel.replace('/','-'); out=scratch/(label+'.stdout'); err=scratch/(label+'.stderr')
    argv=['timeout','180',str(binary),'--replay']; start=time.monotonic()
    with out.open('wb') as fo,err.open('wb') as fe:
        p=subprocess.Popen(argv,stdin=subprocess.PIPE,stdout=fo,stderr=fe,cwd=scratch)
        with gzip.open(folder/'timings.bin.gz','rb') as fi:
            while data:=fi.read(1<<20): p.stdin.write(data)
        p.stdin.close(); code=p.wait(timeout=185)
    archive.require(code==0 and not err.read_bytes(),'Raw replay exit '+rel)
    def states(path):
        with path.open() as f:
            for line in f:
                if line.startswith('FT1536_BATCH '): yield json.loads(line.split(' ',1)[1])
    batches=0
    for a,b in itertools.zip_longest(states(folder/'stdout.txt'),states(out)):
        archive.require(a is not None and a==b,'Raw-statistic mismatch '+rel); batches+=1
    archive.require(batches==row['frames'],'Frame count')
    review=dict(trial=rel,case=item['case'],status=item['status'],uncropped_n=item['n'],
                max_t=row['last_batch']['max_t'],frames=batches,exit_code=code,all_102_states_exact=True,
                argv=argv,cwd=str(scratch),elapsed_seconds=time.monotonic()-start,
                engine_binary_sha256=file_sha(binary),raw_sha256=row['files']['timings.bin.gz'],
                stdout_sha256=file_sha(out),stderr_sha256=file_sha(err))
    reviews.append(review)
    generated('review/'+label+'.json',review)
    for suffix,path in (('stdout',out),('stderr',err)):
        data=path.read_bytes(); dest='review/'+label+'.'+suffix; archive.put_once(target/dest,data)
        origins.append(dict(copy=dest,kind='maintainer_recalculation_stream',sha256=archive.digest(data),bytes=len(data)))
    print(json.dumps(dict(trial=rel,frames=batches,replay='EXACT')),flush=True)
archive.require(len(reviews)==15,'Selected scope')
generated('DUD/RAW_INVENTORY.json',inventory)
generated('DUD/RECEIPT_REVIEW.json',dict(status='SELECTED_RAW_RECALCULATION_PASS',
    receipt_pairs_checked=42,selected_raw_replays=15,all_selected_raw_hashes_checked=True,
    full_campaign_raw_hashes_checked=False,full_campaign_raw_replayed=False,
    reviews=reviews,source_changed=False,host_exclusive=False,constant_time_proved=False))
builder=Path(__file__).read_bytes(); archive.put_once(target/'review/prepare_inputs.py',builder)
origins.append(dict(copy='review/prepare_inputs.py',kind='maintainer_source',sha256=archive.digest(builder),bytes=len(builder)))
readme=archive.read(target/'README.md')
origins.append(dict(copy='README.md',kind='maintainer_document',sha256=archive.digest(readme),bytes=len(readme)))
archive.put_once(target/'ORIGINS.json',archive.json_bytes(dict(schema='FT1536_FLOOR_CT_INPUTS_V1',base_commit=base,
    completed_dudect_report_sha256=pins['REPORT.md'],completed_dudect_result_sha256=pins['RESULT.json'],files=origins)))
members=archive.regular_files(target)
manifest=''.join(archive.digest(archive.read(target/p))+'  '+p+'\n' for p in sorted(members)).encode()
archive.put_once(target/'MANIFEST.sha256',manifest)
for name in sorted(archive.regular_files(target)):
    dest=work/'inputs/bootstrap'/name; archive.put_once(dest,archive.read(target/name)); dest.chmod(0o444)
print(json.dumps(dict(result='PASS',base_commit=base,members=len(members),origins=len(origins),
    bytes=sum((target/p).stat().st_size for p in members),manifest_sha256=archive.digest(manifest),work=str(work),
    key_pins={name:archive.digest(archive.read(target/name)) for name in
      ('CANDIDATE.sha256','source/fpr-emulated.h','AUDIT/REPORT.md','ZERO/formal/SourceFloor.lean',
       'DUD/REPORT.md','DUD/RESULT.json','DUD/RECEIPT_REVIEW.json','vendor/dudect.h','harness/benchmark.c')}),indent=2))
