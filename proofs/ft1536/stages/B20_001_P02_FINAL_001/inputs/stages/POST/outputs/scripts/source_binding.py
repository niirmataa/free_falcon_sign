"""Extract exact original slices; observer additions have explicit diffs/pins."""
import difflib,json,re
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=W/'checks';D.mkdir(exist_ok=True)
sign=(W/'source/falcon-sign.c').read_text().splitlines(True);fft=(W/'source/falcon-fft.c').read_text().splitlines(True);enc=(W/'source/falcon-enc.c').read_text().splitlines(True)
slices={'suffix_original.inc':('falcon-sign.c',1902,1934,sign),'ifft_original.inc':('falcon-fft.c',853,965,fft),'caller_original.inc':('falcon-sign.c',3411,3421,sign),'norm_original.inc':('falcon-enc.c',609,623,enc)}
rows=[]
for name,(src,lo,hi,lines) in slices.items():
 text=''.join(lines[lo-1:hi]);(D/name).write_text(text);rows.append(dict(source='source/'+src,source_sha256=sha(W/'source'/src),first=lo,last=hi,copy='checks/'+name,copy_sha256=sha(D/name),exact_bytes=True))
assert 'falcon_iFFT3' in (D/'ifft_original.inc').read_text()
obs=''.join(fft[852:965]).replace('falcon_iFFT3(', 'observed_iFFT3(',1)
obs=obs.replace('\n\t\t}\n\t}\n\n\t/*\n\t * Intermediate', '\n\t\t}\n\t}\n\tsnapshot("cubic",0,a,1536);\n\n\t/*\n\t * Intermediate',1)
obs=obs.replace('\n\t\tt <<= 1;', '\n\t\tsnapshot("binary",(unsigned)t,a,1536);\n\t\tt <<= 1;',1)
obs=obs.replace('\n\tni = fpr_inverse_of', '\n\tsnapshot("terminal",0,a,1536);\n\tni = fpr_inverse_of',1)
obs=obs[:-2]+'\tsnapshot("scale",0,a,1536);\n}\n'
assert obs.count('snapshot(')==4
(D/'ifft_observer.inc').write_text(obs)
labels={1902:('copy_t0_tx','t0'),1903:('copy_t1_ty','t1'),1904:('mul_tx_b00','tx'),1905:('mul_ty_b10','ty'),1906:('add_tx_ty','tx'),1907:('copy_ty_t0','ty'),1908:('mul_ty_b01','ty'),1910:('copy_t0_tx','t0'),1911:('mul_t1_b11','t1'),1912:('add_t1_ty','t1')}
obs=''
for n in range(1902,1935):
 obs+=sign[n-1].replace('falcon_iFFT3(', 'observed_iFFT3(')
 if n in labels:
  tag,a=labels[n];obs+='snapshot("'+tag+'",0,'+a+',1536);\n'
(D/'suffix_observer.inc').write_text(obs)
for stem in ['ifft','suffix']:
 a=(D/(stem+'_original.inc')).read_text();b=(D/(stem+'_observer.inc')).read_text();(W/'artifacts/diffs'/(stem+'_observer.patch')).write_text(''.join(difflib.unified_diff(a.splitlines(True),b.splitlines(True),fromfile=stem+'_original.inc',tofile=stem+'_observer.inc')))
out=dict(status='PASS_EXACT_ORIGINAL_SLICES',slices=rows,observers={s:sha(D/(s+'_observer.inc')) for s in ['ifft','suffix']},production_source_changed=False,full_do_sign_called=False,probe_active=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
