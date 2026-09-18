"""Independent exact certificates and test oracle; no tested NTT for mathematics."""
import csv,hashlib,json,re,sys
from pathlib import Path
import sage.version
from sage.all import ZZ,GF,PolynomialRing,matrix,identity_matrix
W=Path.cwd();q=18433;N=1536;R=65536;Rt=10237;R2=4564;Ri=5184
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def put(rel,x):
    with (W/rel).open('x') as f:json.dump(x,f,indent=2);f.write('\n')
def rev(x,k):return int(format(x,'0'+str(k)+'b')[::-1],2) if k else 0
def mm(x,y):return int(ZZ(x)*ZZ(y)*Ri%q)
def exponent(i):
    if i>=512:u=rev(i-512,9);return 3*u+1+(u%2)
    k=i.bit_length()-1;u=rev(i-(1<<k),k);return 3*(1<<(8-k))*(3*u+1+(u%2))
def tables_expected():
    g=pow(25,2,q); gm=[0]*1024;igm=[0]*1024
    for i in range(1,1024):
        x=pow(g,exponent(i),q);gm[i]=x*Rt%q;igm[i]=int(ZZ(x).inverse_mod(q))*Rt%q
    gm[0]=gm[1];a=gm[1]*Ri%q;igm[0]=int(ZZ(2*a-1).inverse_mod(q))*Rt%q
    return gm,igm
def roots_ordered(gm):
    a=gm[1]*Ri%q;w=a*a%q
    return [(gm[512+i]*Ri*pow(w,j,q))%q for i in range(512) for j in range(3)]

mode=sys.argv[1]
if mode=='constants':
    c=json.loads((W/'artifacts/tables_C.json').read_text());gm,igm=tables_expected()
    assert c['gm']==gm and c['igm']==igm
    assert all(0<=v<q for v in gm+igm)
    F=GF(q);a=F(gm[1])*F(Ri);w=a*a
    assert a*a-a+1==0 and w**3==1 and w!=1 and 2*a-1!=0
    roots=roots_ordered(gm)
    assert len(set(roots))==N and all((pow(x,1536,q)-pow(x,768,q)+1)%q==0 for x in roots)
    source=(W/'inputs/slices/division.c.txt').read_text()
    source=re.sub(r'/\*.*?\*/','',source,flags=re.S)
    assignments=re.findall(r'(y\d+)\s*=\s*mq_(montymul|montysqr)\(([^;]+)\);',source)
    powers={};schedule=[]
    for lhs,op,argstr in assignments:
        args=[v.strip() for v in argstr.split(',')]
        if lhs=='y0':assert op=='montymul' and args==['y','R2t','Qt','Q0It'];e=1
        elif op=='montysqr':assert args[1:]==['Qt','Q0It'];e=2*powers[args[0]]
        else:assert args[2:]==['Qt','Q0It'];e=powers[args[0]]+powers[args[1]]
        powers[lhs]=e;schedule.append(dict(output=lhs,operation=op,arguments=args,exponent=e))
    assert len(schedule)==19 and powers['y18']==18431
    divs=[]
    for x,y,z in c['div_calls']:
        assert y!=0 and z*y%q==x and pow(y,q-1,q)==1
        vals={}
        for row in schedule:
            lhs=row['output'];args=row['arguments']
            if lhs=='y0':value=mm(y,R2)
            elif row['operation']=='montysqr':value=mm(vals[args[0]],vals[args[0]])
            else:value=mm(vals[args[0]],vals[args[1]])
            vals[lhs]=value
            assert value==pow(y,row['exponent'],q)*Rt%q
        assert mm(vals['y18'],x)==z
        divs.append(dict(x=x,y=y,result=z,chain=[vals['y'+str(i)] for i in range(19)]))
    assert c['ni']*1536%q==Rt
    g=gm[512];ig=igm[512];g2=mm(g,g);g4=mm(g2,g2);ig2=mm(ig,ig);ig4=mm(ig2,ig2)
    rows=[]
    for u in range(0,512,2):
        i0=512+rev(u,9);i1=512+rev(u+1,9)
        nxt=gm[512+rev(u+2,9)] if u+2<512 else mm(gm[i1],g2)
        inxt=igm[512+rev(u+2,9)] if u+2<512 else mm(igm[i1],ig2)
        assert mm(gm[i0],g4)==gm[i1] and mm(gm[i1],g2)==nxt
        assert mm(igm[i0],ig4)==igm[i1] and mm(igm[i1],ig2)==inxt
        rows.append([u,i0,i1,gm[i0],gm[i1],nxt,igm[i0],igm[i1],inxt])
    # Fixed index schedule, including initialization, not uninitialized tails.
    initialized=set();reads=[];writes=[]
    for row in rows:
        for i in row[1:3]:assert i not in initialized;initialized.add(i);writes.append(i)
    for i in range(256,512):assert 2*i in initialized;reads.append(2*i);initialized.add(i);writes.append(i)
    for i in range(255,0,-1):assert 2*i in initialized;reads.append(2*i);initialized.add(i);writes.append(i)
    assert 1 in initialized;reads.append(1);initialized.add(0);writes.append(0)
    assert initialized==set(range(1024)) and len(writes)==1024
    stages=[];t=768;m=2
    while t>3:
        pairs=[(j*t+k,j*t+k+t//2,m+j) for j in range(m) for k in range(t//2)]
        assert sorted(i for p in pairs for i in p[:2])==list(range(N))
        assert all(1<=p[2]<=511 for p in pairs)
        stages.append(dict(direction='forward',m=m,t=t,half=t//2,butterflies=len(pairs),table_range=[m,2*m-1],input_output_indices=[0,1535]))
        t//=2;m*=2
    t=6;m=256
    while t<N:
        pairs=[(j*t+k,j*t+k+t//2,m+j) for j in range(m) for k in range(t//2)]
        assert sorted(i for p in pairs for i in p[:2])==list(range(N))
        stages.append(dict(direction='inverse',m=m,t=t,half=t//2,butterflies=len(pairs),table_range=[m,2*m-1],input_output_indices=[0,1535]))
        t*=2;m//=2
    assert len(stages)==16
    # Constant middle matrices; diagonal alpha factors are handled by unit certificates.
    H2=matrix(F,[[1,1],[1,-1]])
    D3=matrix(F,[[1,1,1],[1,w,w*w],[1,w*w,w]])
    D3i=matrix(F,[[1,1,1],[1,w**(-1),w**(-2)],[1,w**(-2),w**(-1)]])
    rr=F(igm[0])*F(Ri)
    A2=matrix(F,[[1,a],[1,1-a]])
    I2=matrix(F,[[1-rr,1+rr],[2*rr,-2*rr]])
    assert H2*H2==2*identity_matrix(F,2)
    assert D3i*D3==3*identity_matrix(F,3)
    assert I2*A2==2*identity_matrix(F,2)
    cert=dict(schema='FT1536_NTT_CONSTANT_CERT_V1',sage_version=sage.version.version,python_version=sys.version,
      q=q,radix=R,Rt=Rt,R2t=R2,Rinv=Ri,q0i=18431,prime_trial_divisors=[d for d in range(2,136) if q%d==0],
      root25_checks={'9216':pow(25,9216,q),'4608':pow(25,4608,q),'3072':pow(25,3072,q)},
      root625=pow(25,2,q),root625_checks={'4608':pow(625,4608,q),'2304':pow(625,2304,q),'1536':pow(625,1536,q)},
      gm=gm,igm=igm,a=int(a),w=int(w),delta_inverse=int(rr),ni=c['ni'],
      roots=roots,root_exponents=[exponent(512+i)+1536*j for i in range(512) for j in range(3)],
      division_schedule=schedule,division_calls=divs,
      generator_scalars={'g':g,'ig':ig,'g2':g2,'g4':g4,'ig2':ig2,'ig4':ig4},generator_rows=rows,
      generator_reads=reads,generator_writes=writes,initialized_indices=list(range(1024)),
      binary_stages=stages,forward_cubic_blocks=512,quadratic_pairs=768,
      ordinary_matrices={'H2':[[int(x) for x in row] for row in H2.rows()],
       'D3':[[int(x) for x in row] for row in D3.rows()], 'D3i':[[int(x) for x in row] for row in D3i.rows()],
       'A2':[[int(x) for x in row] for row in A2.rows()], 'I2':[[int(x) for x in row] for row in I2.rows()]},
      source_tables_sha256=sha(W/'artifacts/tables_C.json'),source_sha256=sha(W/'source/falcon-vrfy.c'))
    assert not cert['prime_trial_divisors']
    put('artifacts/constants_certificate.json',cert)
    print(json.dumps({k:cert[k] for k in ['q','root625','a','w','delta_inverse','ni','generator_scalars','root25_checks','root625_checks']},indent=2))
    print('all 1024 initialized gm/igm words, 1536 distinct Phi roots, 19 chain exponents, 16 binary stages: CHECKED')
elif mode=='fixtures':
    gm,igm=tables_expected();roots=roots_ordered(gm)
    P=PolynomialRing(GF(q),'X');X=P.gen();phi=X**N-X**768+1
    d=W/'fixtures';d.mkdir();cases=[]
    def unit(i,value=1):a=[0]*N;a[i]=value;return a
    zero=[0]*N
    data=[('zero',zero,[q-1]*N,[(19*i+7)%q for i in range(N)]),
      ('units',unit(0),unit(0),unit(0)),('wrap',unit(N-1),unit(1),zero),
      ('high_square',unit(N-1),unit(N-1),unit(768,q-1)),
      ('max', [q-1]*N,[q-1]*N,[q-1]*N),
      ('dense',[(i*i+17*i+29)%q for i in range(N)],[(31*i*i*i+3*i+11)%q for i in range(N)],[(73*i+9)%q for i in range(N)])]
    old=json.loads((W/'inputs/public/witness.json').read_text())
    data.append(('rho_witness',old['h'],[x%q for x in old['s']],old['c']))
    for name,h,r,c in data:
        hp=P(h);rp=P(r);cp=P(c);pp=(hp*rp)%phi;dd=(pp-cp)%phi
        Hf=[int(hp(a)) for a in roots];rf=[int(rp(a)) for a in roots]
        expected=dict(h_ntt=Hf,H_mont=[x*Rt%q for x in Hf],r_ntt=rf,
          point_product=[x*y%q for x,y in zip(Hf,rf)],p=[int(pp[i]) for i in range(N)],d=[int(dd[i]) for i in range(N)],roundtrip=r)
        (d/(name+'.txt')).write_text(''.join(str(x)+'\n' for v in [h,r,c] for x in v))
        put('fixtures/'+name+'.json',dict(name=name,h=h,r=r,c=c,expected=expected))
        cases.append(dict(name=name,input='fixtures/'+name+'.txt',oracle='fixtures/'+name+'.json'))
    put('fixtures/index.json',cases)
    edges=[0,1,2,3,4,4095,4096,8191,8192,10237,18428,18429,18430,18431,18432]
    pairs=sorted(set((x,y) for x in edges for y in edges)|{((i*97+11)%q,(i*i*131+17)%q) for i in range(512)})
    (d/'primitive_pairs.txt').write_text(''.join(f'{x} {y}\n' for x,y in pairs))
    print(json.dumps(dict(cases=len(cases),primitive_pairs=len(pairs),sage_version=sage.version.version,python_version=sys.version)))
elif mode=='primitives':
    rows=list(csv.DictReader((W/sys.argv[2]).open()));bad=[];branches=set();wrapped=0
    for row in rows:
        x,y=int(row['x']),int(row['y']);k=int(row['k']);z=x*y
        expected={'add':(x+y)%q,'sub':(x-y)%q,'half':int(GF(q)(x)/2),'mont':x*y*Ri%q,'square':x*x*Ri%q,
          'div':int(GF(q)(x)/GF(q)(y)) if y else 0,'z':z,'zq0_word':z*18431%(2**32),'k':z*18431%65536,
          'w':k*q,'total':z+k*q,'shift':(z+k*q)//65536}
        t=expected['shift'];expected['d_word']=(t-q)%(2**32);expected['trace_result']=expected['mont']
        for key,v in expected.items():
            if int(row[key])!=v:bad.append([x,y,key,int(row[key]),v])
        branches.add(t>=q);wrapped+=int(z*18431>=2**32)
    assert branches=={False,True} and wrapped>0
    div=list(csv.DictReader((W/'artifacts/division_C.csv').open()));assert [int(r['y']) for r in div]==list(range(1,q))
    assert all(0<=int(r['inverse'])<q and int(r['inverse'])*int(r['y'])%q==1 for r in div)
    result=dict(status='PASS' if not bad else 'FAIL',cases=len(rows),both_correction_branches=True,unsigned_product_wrap_cases=wrapped,
      nonzero_denominators_checked=len(div),errors=bad,sage_version=sage.version.version,python_version=sys.version)
    put(sys.argv[3],result);print(json.dumps(result,indent=2));sys.exit(bool(bad))
elif mode=='pipeline':
    actual=json.loads((W/sys.argv[2]).read_text());expected=json.loads((W/sys.argv[3]).read_text())['expected'];bad=[]
    for key,vec in expected.items():
        arr=actual[key]
        if len(arr)!=N:bad.append([key,'length',len(arr)]);continue
        if any(not 0<=x<q for x in arr):bad.append([key,'noncanonical'])
        mismatch=next((i for i,(x,y) in enumerate(zip(arr,vec)) if x!=y),None)
        if mismatch is not None:bad.append([key,mismatch,arr[mismatch],vec[mismatch]])
    if 'dynamic_generator_calls' in actual:
        gm,igm=tables_expected()
        if actual['dynamic_generator_calls']!=5 or actual['tables_identical']!=1:bad.append(['generator_calls'])
        if actual['observed_gm']!=gm or actual['observed_igm']!=igm:bad.append(['observed_tables'])
    out=dict(status='PASS' if not bad else 'FAIL',errors=bad,input_sha256=sha(W/sys.argv[2]),oracle_sha256=sha(W/sys.argv[3]),
             sage_version=sage.version.version,python_version=sys.version)
    put(sys.argv[4],out);print(json.dumps(out,indent=2));sys.exit(bool(bad))
else:raise SystemExit('unknown mode')
