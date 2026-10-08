"""Public synthetic M0 root traces and exact retained-material controls.

Sage ZZ is authoritative for the polynomial checks. Instrumented source is
retained beside raw normal/UBSan logs; this is a finite control, not a proof
of the pre-solver attempt, termination, distributions or compiler behavior.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile = json.loads((root/'PROFILE.json').read_text())
def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
for name, pin in profile['core']['source_files'].items():
    assert digest(root/name) == pin, name
source = (root/'falcon-keygen.c').read_text()
lines = source.splitlines(keepends=True)
body = ''.join(lines[int(7277):int(7397)])
assert source.count(body) == 1
def once(text, old, new):
    assert text.count(old) == 1, old
    return text.replace(old, new, int(1))
def plain(value):
    if isinstance(value, dict): return {str(k):plain(v) for k,v in value.items()}
    if isinstance(value, (list,tuple)): return [plain(v) for v in value]
    if isinstance(value, (str,bool)) or value is None: return value
    return int(value)
n = ZZ(1536)
R = PolynomialRing(ZZ, 'X'); X = R.gen(); phi = X^n-X^(n//2)+1
fixtures = []
for i in range(12):
    label = 'FT1536 public B1.05 root fixture 030/' + str(i)
    raw = hashlib.shake_256(label.encode()).digest(int(2*n))
    f = [ZZ(v%3)-1 for v in raw[:int(n)]]
    g = [ZZ(v%3)-1 for v in raw[int(n):]]
    fixtures.append({'label':label,'f':f,'g':g,'mode1_range':True})
fixtures += [
    {'label':'public constant rejection, MODE1 range','f':[1]+[0]*(n-1),'g':[1]+[0]*(n-1),'mode1_range':True},
    {'label':'public successful helper control outside MODE1 range','f':[5]+[0]*(n-1),'g':[7]+[0]*(n-1),'mode1_range':False}]
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixtures),indent=2)+'\n')
data = 'static const int16_t fixture_f[][1536]={' + ','.join('{'+','.join(map(str,x['f']))+'}' for x in fixtures) + '};\n'
data += 'static const int16_t fixture_g[][1536]={' + ','.join('{'+','.join(map(str,x['g']))+'}' for x in fixtures) + '};\n'
instrumented = body
instrumented = once(instrumented,'solve_NTRU_deepest(fk, f, g))', '(root_trace[root_count++]=100, solve_NTRU_deepest(fk, f, g)))')
assert instrumented.count('solve_NTRU_intermediate(fk, f, g, depth))') == 3
instrumented = instrumented.replace('solve_NTRU_intermediate(fk, f, g, depth))',
    '(root_trace[root_count++]=(int)depth, solve_NTRU_intermediate(fk, f, g, depth)))')
instrumented = once(instrumented,'if (!solve_NTRU_ternary_depth0(fk, f, g))',
    'root_terminal=(int)depth;\n\t\t\tif (!(root_trace[root_count++]=0, solve_NTRU_ternary_depth0(fk, f, g)))')
root_globals = 'static int root_trace[64],root_count,root_terminal;\n'
main = r'''
#include <stdio.h>
int main(void) {
  setvbuf(stdout,NULL,_IONBF,0);
  for (size_t c=0;c<sizeof fixture_f/sizeof fixture_f[0];c++) {
    uint32_t scratch[65540]={0};
    int16_t f[1536],g[1536],F[1538],G[1538]; falcon_keygen fk,old;
    memcpy(f,fixture_f[c],sizeof f);memcpy(g,fixture_g[c],sizeof g);
    for(size_t i=0;i<1538;i++) F[i]=G[i]=12345;
    memset(&fk,0,sizeof fk);fk.logn=10;fk.ternary=1;fk.tmp=scratch+2;fk.tmp_len=65536;
    memcpy(&old,&fk,sizeof fk);scratch[0]=scratch[65539]=0x12345678;
    root_count=0;root_terminal=999;
    int good=solve_NTRU(&fk,F+1,G+1,f,g);
    int changed=memcmp(f,fixture_f[c],sizeof f)!=0 || memcmp(g,fixture_g[c],sizeof g)!=0 || memcmp(&fk,&old,sizeof fk)!=0;
    changed |= scratch[0]!=0x12345678 || scratch[65539]!=0x12345678;
    changed |= F[0]!=12345 || G[0]!=12345 || F[1537]!=12345 || G[1537]!=12345;
    printf("R %zu %d %d %d %d",c,good,changed,root_terminal,root_count);
    for(int i=0;i<root_count;i++) printf(" %d",root_trace[i]);
    for(size_t i=1;i<=1536;i++) printf(" %d",(int)F[i]);
    for(size_t i=1;i<=1536;i++) printf(" %d",(int)G[i]);
    printf("\n");
  }
  return 0;
}
'''
variants = {
    'baseline':instrumented,
    'skip_depth_one':once(instrumented,'while (depth -- > 1)', 'while (depth -- > 2)'),
    'wrong_target':once(instrumented,'r = modp_montymul(18433, 1, p, p0i);','r = modp_montymul(18434, 1, p, p0i);'),
    'overwrite_input':once(instrumented,'return 1;', '((int16_t *)f)[0] ^= 1; return 1;'),
    'swapped_outputs':once(instrumented,'poly_big_to_small(F, fk->tmp, logn, fk->ternary)',
        'poly_big_to_small(F, fk->tmp + n, logn, fk->ternary)')}
records = []
baseline = None
expected_trace = [100]+list(range(9,0,-1))+[0]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,code in variants.items():
        label=mode+'_'+variant
        cfile=Path(label+'.c'); binary=Path(label+'.bin')
        cfile.write_text(once(source,body,root_globals+code)+data+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
            '-I',str(root),str(cfile),str(root/'falcon-fft.c'),str(root/'fpr-emulated.c'),'-Wl,--gc-sections','-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
        Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
        assert ran.returncode==0 and not ran.stderr,label
        results=[];differences=[]
        for line in ran.stdout.decode().splitlines():
            tag,c,*payload=line.split();c=int(c);v=[ZZ(z) for z in payload]
            assert tag=='R' and c==len(results)
            good,changed,terminal,count=v[:4];trace=v[4:int(4+count)];words=v[int(4+count):]
            assert len(words)==2*n
            F=words[:int(n)];G=words[int(n):]
            exact=(R(fixtures[c]['f'])*R(G)-R(fixtures[c]['g'])*R(F))%phi
            valid_equation=exact==18433
            valid_bounds=max(abs(z) for z in words)<=2047
            trace_valid=trace==expected_trace[:len(trace)] and (0 not in trace or terminal==0)
            ok=not changed and trace_valid and (not good or (valid_equation and valid_bounds and trace==expected_trace))
            record={'case':c,'return':good,'changed':changed,'terminal_depth':terminal,'trace':trace,
                'exact_equation_if_success':not good or valid_equation,'bounds_if_success':not good or valid_bounds}
            results.append(plain(record))
            if not ok: differences.append({'case':c,'kind':'frame/trace/equation/bounds'})
        assert len(results)==len(fixtures)
        if variant=='baseline':
            assert not differences,(label,differences)
            assert sum(r['return']==1 for r in results)>0
            if baseline is None: baseline=results
            else: assert results==baseline
        else:
            differences += [{'case':i,'kind':'baseline result/trace changed'} for i,r in enumerate(results) if r!=baseline[i]]
            assert differences,label
        artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'results':results,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
Path('ROOT_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
    'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),
    'source_pins':profile['core']['source_files'],'synthetic_mode1_successes':sum(r['return']==1 for r in baseline[:-1]),
    'scope':'Instrumented fixed M0 root calls with public synthetic inputs, actual depth trace/terminal update, common material frames, exact ZZ NTRU for success, rejection exits and four detected mutations. Finite controls; no complete pre-solver attempt or probability theorem.'},indent=2)+'\n')
