import difflib,hashlib,json,re,shlex,subprocess,time
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';boot=verify_manifest(I,'MANIFEST.sha256','58f027900b3283bdf6f488ddb4fdeaa1e6c80b69253cf7d03a7855d3898478f7')
assert len(boot)==272 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(boot)|{'MANIFEST.sha256'}
for r in json.loads((W/'inputs/provenance.json').read_text()):assert sha(W/r['copy'])==r['sha256']
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h
sign=(W/'source/falcon-sign.c').read_text();key=(W/'source/falcon-keygen.c').read_text();sl=sign.splitlines(True);kl=key.splitlines(True)
def func(text,name):
 m=re.search(r'^'+re.escape(name)+r'\s*\([^;{}]*\)\s*\{',text,re.M);assert m,name
 i=m.end();d=1
 while d:d+=(text[i]=='{')-(text[i]=='}');i+=1
 return text[m.start():i]
def canon(s):return re.sub(r'\s+','',re.sub(r'/\*.*?\*/|//[^\n]*','',s,flags=re.S))
matches=[]
for name in ['ft_fpr_bits','ft_fpr_from_bits','ft_fpr_is_positive_finite','ft_stable_positive','ft_stable_binary_inplace','ft_stable_top_branch','smallints_to_fpr']:
 a=func(sign,name);b=func(key,name+'_keygen').replace('_keygen','');assert canon(a)==canon(b),name
 matches.append(dict(function=name,signer_body_sha256=hashlib.sha256(a.encode()).hexdigest(),keygen_renamed_body_sha256=hashlib.sha256(b.encode()).hexdigest(),tokens_equal=True))
first_a=''.join(sl[859:871]);first_b=''.join(kl[7745:7756]).replace('_keygen','').replace('g00','f');assert canon(first_a)==canon(first_b)
rev_a=''.join(sl[875:880]);rev_b=''.join(kl[7759:7764]).replace('_keygen','').replace('FT1536_KEYGEN_Q_SQUARED','FT1536_Q_SQUARED');assert canon(rev_a)==canon(rev_b)
scan_a=''.join(sl[882:892]);scan_b=''.join(kl[7764:7775]).replace('_keygen','');assert canon(scan_a)==canon(scan_b)
mirror=''.join(kl[7443:7542]);(W/'checks/keygen_stable.inc').write_text(mirror)
tail=''.join(kl[7745:7776]);slice='''static int keygen_stable_slice(const fpr *roots, fpr *output)
{
 size_t n=1536,hn=768,u;
 uint32_t bad=0;
 fpr q_squared, g00buf[1536];
 fpr *g00=g00buf,*t3=output,*leaves,*scratch;
 memcpy(g00,roots,sizeof g00buf);
'''+tail+'}\n'
(W/'checks/keygen_tail.inc').write_text(slice)
signer_tail=''.join(sl[859:894]);signer_slice='''static int signer_roots_slice(fpr *tmp, fpr **leaves_out, const fpr *roots)
{
 size_t n=1536,hn=768,u;
 uint32_t bad=0;
 fpr q_squared,*f=tmp,*leaves,*scratch;
 memcpy(f,roots,1536*sizeof(fpr));
'''+signer_tail+'}\n'
(W/'checks/signer_tail.inc').write_text(signer_slice)
(W/'artifacts/diffs/signer_tail.patch').write_text(''.join(difflib.unified_diff(signer_tail.splitlines(True),signer_slice.splitlines(True),fromfile='source/falcon-sign.c:860-894',tofile='checks/signer_tail.inc')))
suffix=''.join(sl[1260:1268]);wrapped='''static int normalization_suffix_slice(fpr *sk, fpr *tmp,
 const int16_t *f_src,const int16_t *g_src,unsigned logn)
{
 size_t n=MKN(logn,1),leaf_count,tree_words;
 fpr *tree=sk+skoff_tree(logn,1),*stable_leaves,sigma;
 int stable_ok;
'''+suffix+'}\n'
(W/'checks/suffix.inc').write_text(wrapped)
for name,old,new in [('keygen_tail',tail,slice),('suffix',suffix,wrapped)]:
 (W/'artifacts/diffs'/(name+'.patch')).write_text(''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='source/'+('falcon-keygen.c:7746-7776' if name=='keygen_tail' else 'falcon-sign.c:1261-1268'),tofile='checks/'+name+'.inc')))
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
out=W/'artifacts/preprocessed';out.mkdir(exist_ok=True);commands=[]
for i,unit in enumerate(['source/falcon-sign.c','source/falcon-keygen.c','source/fpr-emulated.c','source/falcon-fft.c']):
 cmd=['/usr/bin/gcc']+flags+['-E','-P',unit];t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=60)
 so=out/f'unit{i}.i';se=out/f'unit{i}.stderr';so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,limit=60,elapsed=time.monotonic()-t,stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (out/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0 and not p.stderr
p_sign=(out/'unit0.i').read_text();p_key=(out/'unit1.i').read_text();p_fp=(out/'unit2.i').read_text()
for n in ['ft_stable_positive','ft_stable_binary_inplace','ft_stable_top_branch']:
 assert canon(func(p_sign,n))==canon(func(p_key,n+'_keygen').replace('_keygen',''))
sqrt_body=func(p_fp,'fpr_sqrt');assert 'i < 54' in sqrt_body and 'q |= (xu | -xu) >> 63;' in sqrt_body and '__asm__' not in sqrt_body
assert 'ft_ffldl_probe_record_leaf' not in func(p_sign,'ffLDL_ternary_normalize_inner')
assert 'if (ter && logn == 10 && n == 1536)' in key and 'if (!ft_keygen_leaf_certificate' in key and 'continue;' in ''.join(kl[8109:8120])
assert 'break;' in ''.join(kl[8130:8135]) and 'return 1;' in ''.join(kl[8182:8187])
assert 'fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)))' in ''.join(sl[2863:2867])
result=dict(status='PASS_ACTIVE_SOURCE_STABLE_HELPERS_SCANS_AND_SUFFIX_BINDING',source_manifest_sha256=sha(I/'CANDIDATE.sha256'),matched_bodies=matches,
 gate00_tokens_equal_after_name_map=True,reverse_reciprocal_tokens_equal=True,aggregate_scan_tokens_equal=True,portable_sqrt54_active=True,probe_disabled=True,
 mandatory_success_path=dict(certificate_call=[8110,8120],accepted_break=8134,serializers=[8145,8181],success_return=8186,
  meaning='Only the final successful attempt and both serializers are Emitted; no new success event or conditioning'),
 suffix=dict(first=1261,last=1268,copy='checks/suffix.inc',sha256=sha(W/'checks/suffix.inc'),normalization_unconditional=True),
 mirror=dict(helpers_span=[7444,7542],scan_span=[7746,7776],whole_KeyGen_executed=False),
 signer_roots_control=dict(span=[860,894],copy='checks/signer_tail.inc',sha256=sha(W/'checks/signer_tail.inc')),
 different_root_expressions=dict(keygen='selfadj(FFT(g))+selfadj(-FFT(f))',signer='selfadj(FFT(f))+selfadj(FFT(g))',requires='StableBits plus source sqrt/div/domain and sign/selfadj/add binding; not ideal equality alone'),
 snapshots=dict(keygen_g00_preserved_until_gate='ROOT/EMITTED_BINDING and RAW root-frame transport; successful defined prefix',signer_tmp_recomputed=True),
 consumer_spans=dict(leaf_sigma=[1633,1645],dss=2866,selector=[2804,2828]),flags=flags,
 spans={n:sha(W/'source'/n) for n in ['falcon-sign.c','falcon-keygen.c','falcon-fft.c','fpr-emulated.c','fpr-emulated.h','ft1536-adaptive-cdf-tables.h']},
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(dict(status=result['status'],matched_bodies=len(matches),sqrt54=True,unconditional_suffix=True),indent=2))
