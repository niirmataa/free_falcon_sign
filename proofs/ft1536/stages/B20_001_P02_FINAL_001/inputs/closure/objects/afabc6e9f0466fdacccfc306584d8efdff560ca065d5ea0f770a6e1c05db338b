"""Exact old/new pin bridge, active preprocessing/call graph, and literal raw cut."""
import difflib,hashlib,json,re,shlex,subprocess,time
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','5d6f264525141744278d7944f344190f990f143ab4ecf8d76671da00422ff0a4')
def manifest(p):return {n:h for h,n in (s.split('  ',1) for s in p.read_text().splitlines())}
old=manifest(I/'PREVIOUS_SOURCE.sha256');new=manifest(I/'CANDIDATE.sha256');assert set(old)==set(new) and len(new)==17
assert sha(I/'PREVIOUS_SOURCE.sha256')=='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
for n,h in new.items():assert sha(W/'source'/n)==h
assert [n for n in new if old[n]!=new[n]]==['fpr-emulated.h']
header=(W/'source/fpr-emulated.h').read_text();start='static inline long\nfpr_floor(fpr x)\n';end='\nstatic inline int64_t\nfpr_trunc(fpr x)'
before,rest=header.split(start,1);body,after=rest.split(end,1)
ob=body.replace('uint64_t t, mask;','uint64_t t;').replace('\t/* FT1536: preserve the raw-word result with an unsigned selection. */\n\tmask = -(uint64_t)((uint32_t)(63 - cc) >> 31);\n\txi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));','\txi ^= (xi ^ -(int64_t)t) & -(int64_t)((uint32_t)(63 - cc) >> 31);')
previous=before+start+ob+end+after
assert hashlib.sha256(previous.encode()).hexdigest()==old['fpr-emulated.h']
patch=''.join(difflib.unified_diff(previous.splitlines(True),header.splitlines(True),fromfile='baseline/source/fpr-emulated.h',tofile='candidate/source/fpr-emulated.h'))
assert patch==(I/'FLOOR/PATCH.diff').read_text()
(W/'inputs/previous_fpr-emulated.h').write_text(previous)
src=W/'source/falcon-sign.c';lines=src.read_text().splitlines(True);original=''.join(lines[1157:1253]);cut=original.replace('load_skey(', 'raw_prefix_slice(',1)
for decl in ['\tfpr sigma;\n','\t\tfpr *stable_leaves;\n','\t\tsize_t leaf_count, tree_words;\n','\t\tint stable_ok;\n']:cut=cut.replace(decl,'')
cut+='\t\treturn 1; /* observation cut immediately after source1253 */\n\t}\n\treturn 0;\n}\n'
assert 'ft_build_stable_certified_leaves' not in cut and 'ffLDL_ternary_normalize' not in cut
(W/'checks/raw_prefix.inc').write_text(cut)
(W/'artifacts/diffs/raw_prefix.patch').write_text(''.join(difflib.unified_diff(original.splitlines(True),cut.splitlines(True),fromfile='source/falcon-sign.c:1158-1253',tofile='checks/raw_prefix.inc')))
(W/'checks/transport_unit.c').write_text('#include "../source/falcon-sign.c"\n#include "raw_prefix.inc"\n')
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M).group(1));flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
outdir=W/'artifacts/preprocessed';outdir.mkdir(exist_ok=True);commands=[];functions={};owners={}
def extract(text):
 text=re.sub(r'/\*.*?\*/|//[^\n]*','',text,flags=re.S);ans={}
 for m in re.finditer(r'\b([A-Za-z_]\w*)\s*\(([^;{}]*)\)\s*\{',text):
  name=m[1]
  if name in ['if','while','for','switch','sizeof','__attribute__']:continue
  i=m.end();depth=1
  while depth and i<len(text):
   depth+=(text[i]=='{')-(text[i]=='}');i+=1
  if depth==0:ans[name]=text[m.start():i]
 return ans
units=['checks/transport_unit.c','source/falcon-fft.c','source/fpr-emulated.c','source/falcon-keygen.c','source/falcon-enc.c','source/frng.c','source/shake.c']
for index,unit in enumerate(units):
 cmd=['/usr/bin/gcc']+flags+['-E','-P',unit];tick=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=60)
 so=outdir/f'unit{index}.i';se=outdir/f'unit{index}.stderr';so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,elapsed=time.monotonic()-tick,limit=60,stdout=so.relative_to(W).as_posix(),stderr=se.relative_to(W).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (outdir/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0 and not p.stderr
 for name,definition in extract(p.stdout.decode()).items():
  functions.setdefault(name,[]).append(definition);owners.setdefault(name,[]).append(unit)
def calls(body):return sorted(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',body.split('{',1)[1]))&functions.keys())
graph={n:sorted({c for d in ds for c in calls(d)}) for n,ds in functions.items()}
def closure(seeds):
 todo=list(seeds);seen=set()
 while todo:
  n=todo.pop();assert n in graph,n
  if n not in seen:seen.add(n);todo+=graph[n]
 return sorted(seen)
raw=closure(['raw_prefix_slice']);emitted=closure(['falcon_keygen_make'])
assert 'fpr_floor' not in raw and 'fpr_floor' not in emitted
assert not set(raw)&{'load_skey','ft_build_stable_certified_leaves','ffLDL_ternary_normalize','BerExp','sampler','sampler_large'}
assert {'ffLDL_fft3','ffLDL_depth1_fft3','ffLDL_inner_fft3','LDL_dim2_fft3','LDL_dim3_fft3','falcon_FFT3','fpr_add','fpr_mul','fpr_div'}<=set(raw)
direct=sorted(n for n,cs in graph.items() if 'fpr_floor' in cs);assert direct==['BerExp','sampler','sampler_large']
table_names=['fpr_gm3_square','fpr_gm3_cubic'];tables={}
for n in table_names:
 pat=r'static const fpr '+n+r'\[\] = \{.*?\n\};';a=re.search(pat,header,re.S)[0];b=re.search(pat,previous,re.S)[0];assert a==b;tables[n]=hashlib.sha256(a.encode()).hexdigest()
out=dict(status='PASS_SOURCE_TRANSPORT_AND_RAW_CUT',baseline_manifest_sha256=sha(I/'PREVIOUS_SOURCE.sha256'),candidate_manifest_sha256=sha(I/'CANDIDATE.sha256'),
 changed_file='fpr-emulated.h',only_changed_function='fpr_floor',other_source_files_identical=16,remaining_header_bytes_identical=True,
 old_header_sha256=old['fpr-emulated.h'],candidate_header_sha256=new['fpr-emulated.h'],floor_patch_sha256=sha(I/'FLOOR/PATCH.diff'),
 raw_prefix_source=dict(path='source/falcon-sign.c',sha256=sha(src),first=1158,last=1253,copy='checks/raw_prefix.inc',copy_sha256=sha(W/'checks/raw_prefix.inc'),diff='artifacts/diffs/raw_prefix.patch',
  changes=['function renamed','four post-cut-only declarations removed','closing scopes and return at observation cut added'],guard_after_FFT_preserved=True),
 active_preprocessing_flags=flags,call_graph=graph,raw_prefix_transitive_functions=raw,emitted_transitive_functions=emitted,all_floor_callers=direct,
 floor_unreachable_in_both=True,graph_is_syntactic_overapproximation_including_inactive_ter_zero_arm=True,
 tables_sha256=tables,consumed_body_hashes={n:[dict(unit=u,sha256=hashlib.sha256(d.encode()).hexdigest()) for u,d in zip(owners[n],functions[n])] for n in sorted(set(raw+emitted))},
 static_name_collisions_handled_by_union=True,
 proof_binding='Same sixteen files and every header byte outside the sole unreachable floor body; same preprocessor profile and pure table/function semantics. No compiler or runtime equality theorem.',
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_transport.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(status=out['status'],raw_functions=len(raw),emitted_functions=len(emitted),floor_callers=direct,cut_sha256=out['raw_prefix_source']['copy_sha256']),indent=2))
