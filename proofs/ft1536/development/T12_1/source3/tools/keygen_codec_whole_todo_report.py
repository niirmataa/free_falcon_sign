#!/usr/bin/env python3
"""Generate the owner's one complete codec-TODO report and evidence index."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,re,subprocess,sys
ROOT=Path(__file__).resolve().parents[1];REPO=ROOT.parents[4]
BASE='3619a22d'
PREFIX=str(ROOT.relative_to(REPO))
POST='.build/levels_078/WHOLE_TODO_POSTSEAL_001.json'
POST_SHA='ca4997f13d817764049272551ba5d7eb8ae5cf6bfe22ffa39c31382a3a8c6df7'
AUDIT='.build/jobs/keygen_codec_final_078_001/SEARCH_AUDIT.json'
STEM='notes/run/KEYGEN_SOURCE_TO_FIBER_001_CODEC_WHOLE_TODO'
CORE={
 'NONE':['KeygenDecodeNoneComplete.source_outcome','KeygenDecodeNoneComplete.decoder_exists','KeygenCodecNoneCallRoundtrip.source_call_roundtrip','KeygenCodecNoneCallRoundtrip.call_roundtrip_exists','KeygenCodecNoneMemoryIdentity.source_in_place_identity','KeygenCodecNoneMemoryIdentity.in_place_exists'],
 'STATIC':['KeygenDecodeStaticComplete.source_outcome','KeygenDecodeStaticComplete.decoder_exists','KeygenCodecStaticCallRoundtrip.source_call_roundtrip','KeygenCodecStaticCallRoundtrip.call_roundtrip_exists','KeygenCodecStaticMemoryIdentity.source_in_place_identity','KeygenCodecStaticMemoryIdentity.in_place_exists'],
 'Vector/int16':['KeygenInt16Vector076.signedEquiv','KeygenInt16Representation076.represents_iff_words','KeygenInt16Construct076.mathematical_array_exists','KeygenInt16CodecMath076.static_roundtrip','KeygenInt16CodecMath076.none_roundtrip','KeygenInt16Caller076.witness_transport','KeygenInt16CallerDecode076.witness_decoders'],
 'Public':['KeygenPublicEncodeComplete077.source_outcome','KeygenPublicEncodeComplete077.encoder_exists','KeygenPublicDecodeComplete077.source_outcome','KeygenPublicDecodeComplete077.decoder_exists','KeygenPublicRoundtrip077.honest_roundtrip_exists','KeygenPublicRoundtrip077.in_place_identity','KeygenPublicMath077.from_witness','KeygenPublicPacket077.DecodePublic','KeygenPublicPacket077.decode_honest','KeygenPublicObserved077.ObservedPublic','KeygenPublicCallerComplete077.actual_observed_decode','KeygenPublicCallerComplete077.from_witness']}
def path(p):
 p=Path(p);return p if p.is_absolute() else ROOT/p
def sha(p):return hashlib.sha256(path(p).read_bytes()).hexdigest()
def pin(p):
 p=path(p);return {'path':str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p),'sha256':sha(p),'bytes':p.stat().st_size}
def read(p):return json.loads(path(p).read_text())
def write(p,text):
 with path(p).open('x') as stream:stream.write(text)
def link(p,label=None):return '['+(label or str(p))+']('+str(path(p))+')'
def main():
 head=sys.argv[1] if len(sys.argv)>1 else subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip()
 assert sha(POST)==POST_SHA
 post=read(POST);assert post['distinct_pinned_files']==len(post['checked'])==20619
 for p,h in post['checked'].items():assert sha(p)==h,('final pin mismatch',p)
 rows=read(AUDIT);assert len(rows)==1990
 names={r['name'] for r in rows}
 for group,decls in CORE.items():
  for n in decls:assert 'FT1536.Source3.'+n in names,(group,n)
 files=[REPO/p for p in subprocess.check_output(['git','diff','--name-only','--diff-filter=A',BASE+'..'+head,'--',PREFIX+'/formal/Source3'],cwd=REPO,text=True).splitlines()]
 proofs=[];expected=set()
 for p in files:
  if 'Audit' in p.name:continue
  source=p.read_text();ns=re.search(r'^namespace (FT1536\.Source3\.\w+)',source,re.M).group(1)
  decls=re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)',source,re.M)
  theorems=re.findall(r'^theorem\s+(\w+)',source,re.M)
  expected.update(ns+'.'+n for n in decls)
  proofs.append({'module':'Source3.'+p.stem,'source':pin(p),'namespace':ns,'declarations':decls,'named_theorems':len(theorems)})
 assert len(proofs)==186 and len(expected)==1986 and expected<=names and sum(p['named_theorems'] for p in proofs)==1002
 manifests=sorted(p for p in (ROOT/'notes/run').glob('KEYGEN_SOURCE_TO_FIBER_001_BATCH_*.json') if re.search(r'_BATCH_0(?:73|74|75|76|77)(?:_|\.)',p.name))
 causes={}
 for p in manifests:
  for record in read(p).get('history',[]):
   if record.get('cause'):causes[record['job']]=record['cause']
 jobs=[];statistics=[]
 batches=[('073','keygen_decode_none_073_'),('074','keygen_decode_none_074_'),('075','keygen_decode_static_075_'),('076','keygen_transport_076_'),('077','keygen_public_077_'),('078 audit','keygen_codec_final_078_')]
 for batch,prefix in batches:
  records=[]
  for directory in sorted((ROOT/'.build/jobs').glob(prefix+'*')):
   if not re.fullmatch(prefix+r'\d{3}',directory.name):continue
   rs=read(directory/'RECEIPTS.json');accepted=all(r['accepted'] for r in rs)
   cause=causes.get(directory.name)
   if not accepted and not cause:
    failed=next(r for r in rs if not r['accepted']);lines=(directory/failed['stdout']).read_text().splitlines()
    cause='Native diagnostic: '+next((line.split(': error',1)[-1] for line in lines if ': error' in line),'see pinned stderr and native receipt')
   records+=rs
   jobs.append({'batch':batch,'job':directory.name,'status':'ACCEPTED' if accepted else 'FAILED_RETAINED','cause':cause,
    'receipts':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
    'steps':len(rs),'accepted_steps':sum(r['accepted'] for r in rs)})
  group=[j for j in jobs if j['batch']==batch]
  statistics.append({'batch':batch,'jobs':len(group),'accepted_jobs':sum(j['status']=='ACCEPTED' for j in group),'failed_jobs':sum(j['status']=='FAILED_RETAINED' for j in group),
   'steps':len(records),'accepted_steps':sum(r['accepted'] for r in records),'maxrss_kib':max(r['cumulative_child_maxrss_kib'] for r in records),
   'native_child_elapsed_sum_s':round(sum(r['elapsed_s'] for r in records),3)})
 assert len(jobs)==214 and sum(j['status']=='FAILED_RETAINED' for j in jobs)==105
 checkpoints=[]
 for n in range(73,79):
  for p in sorted((ROOT/f'.build/levels_{n:03d}').glob('*.json')):
   if 'ENTRY_PINS' in p.name or 'POSTSEAL' in p.name:
    r=read(p);checkpoints.append({**pin(p),'distinct_pinned_files':r.get('distinct_pinned_files')})
 auditPins=read('.build/levels_078/AUDIT_COVERAGE_GAP_001.json')['prior_audits']+[{'module':'KeygenCodecWholeTodo078Audit','job':'keygen_codec_final_078_001','path':AUDIT,'sha256':sha(AUDIT),'entries':1990}]
 commits=[]
 for line in subprocess.check_output(['git','log','--reverse','--format=%H%x09%s',BASE+'..'+head,'--',PREFIX],cwd=REPO,text=True).splitlines():
  commit,subject=line.split('\t',1);commits.append({'commit':commit,'subject':subject})
 supplement=read('notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_073_SEAL_SUPPLEMENT_001.json')
 result={'generated_utc':datetime.now(timezone.utc).isoformat(),'asof_head':head,'base_checkpoint':'52R / pairs072','base_head':subprocess.check_output(['git','rev-parse',BASE],cwd=REPO,text=True).strip(),
  'status':'FOUR_LOCAL_TODO_COMPONENTS_PROVED_KERNEL_SCOPED / NOT_REVIEWED; WHOLE_ROOT_ACCEPTANCE_NOT_MET',
  'all_file_pins':pin(POST),'all_file_pin_count':20619,'final_audit':pin(AUDIT),
  'counts':{'proof_modules':186,'named_declarations':1986,'named_theorems':1002,'audit_modules':18,'final_audit_entries':1990,'full_terms':1941,'kernel_inductives':49,'jobs':214,'accepted_jobs':109,'failed_jobs_retained':105,'native_steps':586,'accepted_native_steps':481},
  'core_declarations':CORE,'proof_inventory':proofs,'statistics':statistics,'jobs':jobs,
  'checkpoints':checkpoints,'manifests':[pin(p) for p in manifests]+[pin('notes/run/KEYGEN_SOURCE_TO_FIBER_001_CODEC_WHOLE_TODO_SEAL_001.json')],
  'audits':auditPins,'commits':commits,'supplement073':pin('notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_073_SEAL_SUPPLEMENT_001.json'),
  'supplement_correction':supplement['correction'],'retained_refusal':supplement['retained_refusal'],
  'coverage_gap':pin('.build/levels_078/AUDIT_COVERAGE_GAP_001.json'),'coverage_gap_closed':True,
  'C_sources':[pin(REPO/'Extra/c/falcon-enc.c'),pin(REPO/'Extra/c/falcon-keygen.c')],
  'report_generator':pin(Path(__file__)),'push':False,'independent_review':False,'root_B1_07_acceptance':'NOT MET','root_B1_08_acceptance':'NOT MET','root_B1_09_acceptance':'NOT MET; LOCAL PUBLIC SUFFIX PROVED'}
 indexPath=STEM+'_INDEX_001.json';write(indexPath,json.dumps(result,indent=2)+'\n')
 lines=['# Complete owner codec TODO after checkpoint52R','',
 'All four requested local source-codec/transport components are now PROVED_KERNEL_SCOPED / NOT_REVIEWED. The final source public suffix is included. This is the one final report, not a midpoint report. Whole KeyGen acceptance remains open for the separate assembly obligations stated below.','',
 f'Base:52R, pairs072, commit `{result["base_head"]}`. Initial ENTRY073:15,815 pins. Final whole-TODO postseal:20,619 checked files, zero hash mismatches. '+link(POST,'Complete per-file SHA-256 ledger')+'; SHA256 `'+POST_SHA+'`. The tables below are navigation pins; the linked ledger contains every one of the20,619 file pins.','',
 'There are186 new proof modules,1,986 named declarations and1,002 named theorems. Eighteen audit modules include the final coherent audit of all1,986 new declarations plus4 inherited boundary declarations:1,990 complete entries,1,941 full terms and49 kernel inductives. '+link(AUDIT,'All exact declaration types, bodies and axiom lists')+'; SHA256 `'+sha(AUDIT)+'`. These are kernel proofs over the pinned C99/GCC LP64, little-endian reference semantics, not compiler or ISO-C certification.','',
 '**What is proved**','',
 '| Component | Proof modules / declarations / named theorems | Concrete result |','|---|---:|---|',
 '|073 foundation and authorized supplement|13 /92 /50|Source decoder/store/frame primitives and original NONE encoder bytes; historical stop retained.|',
 '|NONE074|33 /233 /156|Complete source prologue,1,536 decoded stores, return3072, actual dispatchers and honest decoder existence; exact original coefficient memory identity.|',
 '|STATIC075|68 /771 /376|Complete decoder, sign/low bits/unary loops,1,536 stores, independent padding and consumed return; all-int16 round-trip including−32768.|',
 '|Vector/int16076|10 /78 /60|Exact bounded bijection and physical transport both directions, then SAME f/g/F/G through all4 actual call boundaries.|',
 '|Public077|62 /812 /360|Both full source bodies and honest executions,1,536 canonical coefficients,2,880 payload bytes, actual header0x8a and2,881-byte observed public output decoding to SAME h.|','',
 'NONE is on its explicit centered carrier[−9216,9216]; the existing source f/g bounds1 and F/G bounds2047 discharge that domain. Memory identity means that the original coefficient array is recovered exactly and in-place decoding leaves the encoded heap unchanged; output-buffer writes remain part of that heap. STATIC covers every raw int16 word, with source-derived honest lengths1920–26496 and a uniform legal capacity26496. Source f/g costs1920 and F/G budgets3264 are separately proved, without assuming observed lengths.','',
 'The mathematical vector is the EXISTING `Geometry.Vec = Fin768 → Int × Int`, in source order:768 first coordinates followed by768 second coordinates. The exact integer transport domain is signed16, not unbounded integers. Physical allocation, initialized reads, writable destinations and required block separation are explicit legal-memory conditions. Output values, codec returns, encoded lengths and memory frames are conclusions.','',
 'The public encoder/decoder use the actual four C arguments, unsigned16-bit input promotion and real pointer-lvalue stores. The decoder returns its supplied length; honest trailing bytes remain accepted. `ObservedPublic` mentions only physical length/byte loads, and `DecodePublic` independently parses the bytes. The final theorem derives `DecodePublic packet = some h` for independently observed output, preserving the SAME local source material/public/inverse equations. The enclosing caller return1 is an observed source-success premise; no desired codec return is a premise.','']
 for title,decls in CORE.items():
  lines+=['**'+title+' exports**','']+[ '- `FT1536.Source3.'+n+'`' for n in decls]+['']
 lines+=['**Open obligations and acceptance**','',
 '| Interface | Status | Exact remaining obligation |','|---|---|---|',
 '|B1.07|PARTIAL_PROOF; Acceptance NOT MET|Connect the final accepted attempt to the actual serialization-entry heap/material, with legal workspace, relocation, shared call identity, globals/snapshots and lifetime obligations.|',
 '|B1.08|PARTIAL_PROOF; Acceptance NOT MET|The source segment codecs, SAME four-vector transport and local calls are proved; the exact final secret blob with header0xaa, all lengths/frames and final observation/lifetime assembly still needs composition.|',
 '|B1.09|Local public suffix PROVED; whole-root Acceptance NOT MET|The exact observed public packet decodes to SAME h at the source suffix entry; the connection of that entry to the same final accepted attempt is the remaining root dependency.|',
 '|B1.10 and B4/B5|Not claimed by this TODO|Whole emitted-to-fiber assembly and probability/security laws require the remaining root obligations and their own evidence.|','',
 'These are missing assembly proofs, not demonstrated C bugs or mathematical impossibility. No result/length/frame assumption was added to close them. Legal-capacity and memory domains remain visible in the exact theorem types. No independent reviewer was started, and no REVIEWED or owner-acceptance status was assigned.','',
 '**Integrity correction and retained unfavorable evidence**','',
 'The only encountered pin-integrity wall was the historical073 organizer mismatch. The owner-authorized NEW supplement leaves the010 manifest and both historical audit states frozen. Its exact recorded reason is: “organizer połączył wyniki mieszanego jobu010 z poprawionym audytem011”. The selected audit-source pin at `/sources/8/sha256` is overlaid from `'+supplement['correction']['old_sha256']+'` to `'+supplement['correction']['new_sha256']+'`; old job `keygen_decode_none_073_010`, accepted job `keygen_decode_none_073_011`. The correction-diff SHA256 is `'+supplement['correction']['correction_diff']['sha256']+'`.','',
 'The supplement scanner verified all15,815 input pins and all970 scanned Lean/Sage/C source files unchanged. The correction changes only audit-pin reconciliation, with zero source or theorem byte changes. The refusal is retained at '+link(supplement['retained_refusal']['record']['path'])+'; SHA256 `'+supplement['retained_refusal']['record']['sha256']+'`. Supplement073 is followed by its successful postseal and only then ENTRY074. The frozen073 stop report remains a historical stop report.','',
 'Retained counterexamples include `KeygenDecodeNoneScalar.outside_carrier_rejected`/`unrestricted_pair_roundtrip_false` (9217 lies outside the NONE carrier), `KeygenCodecStaticSuffix.whole_word_bound_false` (the old whole-accumulator bound is false), and `KeygenInt16Vector076.unbounded_integer_transport_false` (65536 and0 have the same raw16-bit encoding). `halves_are_not_interleaved` records the correct source layout. These limitations are not promoted to source-code failures.','',
 'All failed jobs, mixed jobs, raw diagnostics, source snapshots, receipts and reasons remain pinned. The075 occupied-slot postseal refusal and077 precommit whitespace refusal remain documented. The final census additionally found18 old073 helper bodies missing from the prior audit inventories; their native proofs were already accepted and their pins matched. The new additive078 audit closes this inventory gap without editing any historical proof or seal. '+link('.build/levels_078/AUDIT_COVERAGE_GAP_001.json','Exact retained coverage-gap record')+'.','',
 '**Native verification**','',
 '| Batch | Jobs | Wholly accepted | Failed, retained | Native steps | Accepted steps |','|---|---:|---:|---:|---:|---:|']
 for r in statistics:lines.append('|'+r['batch']+'|'+'|'.join(str(r[k]) for k in ['jobs','accepted_jobs','failed_jobs','steps','accepted_steps'])+'|')
 lines+=['|Total|214|109|105|586|481|','',
 'Accepted final selections have empty stdout/stderr and0 errors/0 warnings. Guards remain j1,−M6144,12GiB address-space ceiling,8GiB normal RSS budget,1800s wall limit and2,000,000 heartbeats, with warnings treated as errors. Failed authoring attempts remain failures. '+link(indexPath,'Machine-readable index')+' lists every job, cause, receipt pin, source-input pin, proof file and declaration name.','',
 '**All entry and postseal checkpoint pins**','',
 '| Checkpoint | Files checked | SHA-256 |','|---|---:|---|']
 for p in checkpoints:lines.append('|'+link(p['path'])+'|'+str(p['distinct_pinned_files'])+'|`'+p['sha256']+'`|')
 lines+=['','**All batch/step/supplement manifest pins**','','| Manifest | SHA-256 |','|---|---|']
 for p in result['manifests']:lines.append('|'+link(p['path'])+'|`'+p['sha256']+'`|')
 lines+=['','**All full-body audit pins**','','| Audit | Entries | SHA-256 |','|---|---:|---|']
 for p in auditPins:lines.append('|'+link(p['path'],p['module'])+'|'+str(p['entries'])+'|`'+p['sha256']+'`|')
 lines+=['','**Every own local commit after52R**','',
 'The list includes proof, supplement, refusal, postseal and audit commits under this source3 scope through the report-generation commit. Other workstreams on shared main are preserved and excluded from this ownership list. The final report/index commit is identified in the final owner message, avoiding a self-referential commit hash. No push was performed.','',
 '| Commit | Subject |','|---|---|']
 for c in commits:lines.append('|`'+c['commit']+'`|'+c['subject']+'|')
 lines+=['','**Assessment — three sentences**','',
 'The mathematics-to-bytes bridge now carries the same source-produced coefficients through complete checked codecs, rather than stopping at scalar identities. Its strongest new endpoint is the independently observed public packet decoding to the same h, while the original coefficient-memory round-trips and exact representation domains remain explicit. The project still needs the whole-KeyGen material-entry and final secret-blob/lifetime assembly before the local bridge can support a full emitted-to-fiber or security claim.','']
 reportPath=STEM+'_REPORT_001.md';write(reportPath,'\n'.join(lines))
 receipt={'utc':datetime.now(timezone.utc).isoformat(),'status':'WHOLE_OWNER_TODO_LOCAL_COMPONENTS_COMPLETE / NOT_REVIEWED / ROOT_ACCEPTANCE_NOT_MET','asof_head':head,
  'report':pin(reportPath),'index':pin(indexPath),'whole_postseal':pin(POST),'all_checked_files':20619,'complete_audit':pin(AUDIT),
  'source_C_unchanged':True,'historical_manifests_unchanged':True,'push':False,'next_work':'Remaining B1 root/secret-blob assembly is explicitly open; no new work started.'}
 write(STEM+'_CLOSEOUT_001.json',json.dumps(receipt,indent=2)+'\n')
 print(json.dumps({'report':pin(reportPath),'index':pin(indexPath),'closeout':pin(STEM+'_CLOSEOUT_001.json'),'commits_listed':len(commits),'jobs':len(jobs)}))
if __name__=='__main__':main()
