# Organization only: pin the actual preprocessed M0 call graph. No source
# correctness assertion is inferred from parsing or hashing this inventory.
from pathlib import Path
import hashlib,json,os,re,subprocess
src=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
def sha(b): return hashlib.sha256(b).hexdigest()
profile=json.loads((src/'PROFILE.json').read_text())
assert sha((src/'PROFILE.json').read_bytes())=='55dc91b373858ddaab78ac4f125538505279c5f74ac3d4e4569a02164ebb1e56'
for name,pin in profile['core']['source_files'].items(): assert sha((src/name).read_bytes())==pin,name
flags=[f for f in profile['core']['Makefile_flags'] if f.startswith('-D')]
files=['falcon-keygen.c','falcon-fft.c','fpr-emulated.c','falcon-enc.c','falcon-vrfy.c','frng.c','shake.c']
symbols={};globals={};preprocessed=[]
skip={'if','for','while','switch','sizeof','return','_Alignof','__attribute__'}
for file in files:
    cmd=['gcc','-std=c99','-E','-P','-I'+str(src)]+flags+[str(src/file)]
    p=subprocess.run(cmd,capture_output=True,check=False)
    stem=Path(file+'.preprocessed')
    stem.with_suffix('.stdout').write_bytes(p.stdout);stem.with_suffix('.stderr').write_bytes(p.stderr)
    assert p.returncode==0 and not p.stderr,(file,p.stderr.decode())
    text=p.stdout.decode();preprocessed.append({'file':file,'sha256':sha(p.stdout)})
    # Keep string sizes and brace positions, but do not parse text in strings
    # as executable calls. Preprocessing has already removed C comments.
    masked=re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',lambda m:' '*len(m.group(0)),text)
    pattern=re.compile(r'\b([A-Za-z_]\w*)\s*\([^;{}]*\)\s*\{')
    pos=0
    while True:
        m=pattern.search(masked,pos)
        if m is None: break
        name=m.group(1);start=m.end()-1;depth=1;end=start+1
        while depth:
            assert end<len(masked),(file,name)
            depth += (masked[end]=='{')-(masked[end]=='}');end+=1
        pos=end
        if name in skip: continue
        begin=max(masked.rfind(';',0,m.start()),masked.rfind('}',0,m.start()))+1
        signature=text[begin:start].strip()
        static=bool(re.search(r'\bstatic\b',signature))
        calls=sorted(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',masked[start:end]))-skip)
        key=file+':'+name
        symbols[key]={'file':file,'name':name,'static':static,'signature':signature,
                      'body_sha256':sha(text[start:end].encode()),'callees':calls}
        if not static: globals.setdefault(name,[]).append(key)

roots={'make':'falcon-keygen.c:falcon_keygen_make',
       'certificate':'falcon-keygen.c:ft_keygen_leaf_certificate',
       'public':'falcon-vrfy.c:falcon_compute_public',
       'decode_sk':'falcon-enc.c:falcon_decode_small',
       'decode_pk':'falcon-enc.c:falcon_decode_18433'}
graphs={}
for label,root in roots.items():
    seen=set();external=set();edges=[]
    def visit(key):
        if key in seen:return
        assert key in symbols,key
        seen.add(key);row=symbols[key]
        for name in row['callees']:
            same=row['file']+':'+name
            if same in symbols: dest=same
            else:
                candidates=globals.get(name,[])
                assert len(candidates)<=1,(key,name,candidates)
                dest=candidates[0] if candidates else 'external:'+name
            edges.append([key,dest])
            if dest.startswith('external:'):external.add(dest)
            else:visit(dest)
    visit(root)
    graphs[label]={'root':root,'functions':sorted(seen),'edges':sorted(edges),'external':sorted(external)}
assert roots['certificate'] in graphs['make']['functions']
assert 'falcon-keygen.c:solve_NTRU' in graphs['make']['functions']
assert 'falcon-keygen.c:modp_NTT3_ext' in graphs['make']['functions']
assert 'falcon-enc.c:compress_static' in graphs['make']['functions']
assert roots['public'] in graphs['make']['functions']
Path('KEYGEN_SOURCE_CALLGRAPH.json').write_text(json.dumps({'scope':'preprocessed inventory; not a kernel execution/adequacy theorem',
    'profile_sha256':sha((src/'PROFILE.json').read_bytes()),'source_pins':profile['core']['source_files'],
    'preprocessed':preprocessed,'graphs':graphs,'symbols':symbols},indent=2)+'\n')
print('KEYGEN_SOURCE_CALLGRAPH_PINS_PASS', {k:len(v['functions']) for k,v in graphs.items()})
