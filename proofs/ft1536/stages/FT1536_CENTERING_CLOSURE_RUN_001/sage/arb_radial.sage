# Authoritative Sage entry; generated Cython below only drives exact integer
# enumeration and FLINT/Arb interval operations. No floating-point FFT is used.
from pathlib import Path
import argparse,json,time,sys,sysconfig,subprocess,importlib.util,hashlib
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10==1024
ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['test','bench','full'],nargs='?',default='test')
ap.add_argument('exponent',type=int,nargs='?',default=25);ap.add_argument('bin',type=int,nargs='?',default=16)
args=ap.parse_args()
CODE=r'''
# distutils: libraries = flint
from libc.stdint cimport uint32_t, int64_t
from libc.stdlib cimport calloc, free
from sage.libs.flint.types cimport acb_ptr, acb_dft_rad2_t, slong
from sage.libs.flint.acb cimport *
from sage.libs.flint.arb cimport *
from sage.libs.flint.acb_dft cimport acb_dft_rad2_init, acb_dft_rad2_clear
from sage.libs.flint.flint cimport flint_set_num_threads
from sage.rings.real_arb cimport RealBall
from sage.rings.complex_arb cimport ComplexBall
from cysignals.signals cimport sig_on, sig_off
cdef extern from "flint/acb_dft.h":
    void acb_dft_rad2_precomp_inplace(acb_ptr, const acb_dft_rad2_t, slong)
    void acb_dft_inverse_rad2_precomp_inplace(acb_ptr, const acb_dft_rad2_t, slong)
import time

cdef class BallRadial:
    cdef acb_ptr data
    cdef slong size, precision
    cdef int exponent
    def __cinit__(self, int exponent, slong precision):
        self.data=NULL
        self.size=(<slong>1)<<exponent
        self.exponent=exponent;self.precision=precision
        flint_set_num_threads(1)
        self.data=_acb_vec_init(self.size)
    def __dealloc__(self):
        if self.data!=NULL:_acb_vec_clear(self.data,self.size)
    def fill(self, long cutoff, long bound, long width, RealBall t, RealBall normalizer):
        cdef uint32_t *counts=<uint32_t*>calloc(cutoff+1,sizeof(uint32_t))
        cdef long x,y,n,j,r,idx
        cdef int64_t norm
        cdef arb_t wp,step,tmp,total
        cdef acb_ptr powers=_acb_vec_init(width)
        if counts==NULL:raise MemoryError()
        arb_init(wp);arb_init(step);arb_init(tmp);arb_init(total)
        arb_one(wp);arb_pow_ui(step,t.value,width,self.precision)
        arb_one(acb_realref(powers))
        for r in range(1,width):
            arb_mul(acb_realref(powers+r),acb_realref(powers+r-1),t.value,self.precision)
        start=time.monotonic()
        try:
            sig_on()
            for x in range(-bound,bound+1):
                for y in range(-bound,bound+1):
                    norm=(<int64_t>x)*x+(<int64_t>x)*y+(<int64_t>y)*y
                    if norm<=cutoff:counts[norm]+=1
            sig_off()
            print('COUNTS_DONE',cutoff,round(time.monotonic()-start,3),flush=True)
            sig_on()
            for j in range(cutoff//width+1):
                arb_zero(total)
                for r in range(width):
                    n=j*width+r
                    if n<=cutoff and counts[n]!=0:
                        arb_mul_ui(tmp,acb_realref(powers+r),counts[n],self.precision)
                        arb_add(total,total,tmp,self.precision)
                arb_mul(tmp,total,wp,self.precision)
                arb_div(tmp,tmp,normalizer.value,self.precision)
                idx=j % self.size
                arb_add(acb_realref(self.data+idx),acb_realref(self.data+idx),tmp,self.precision)
                arb_mul(wp,wp,step,self.precision)
            sig_off()
            print('INPUT_INTERVALS_DONE',round(time.monotonic()-start,3),flush=True)
        finally:
            free(counts);_acb_vec_clear(powers,width)
            arb_clear(wp);arb_clear(step);arb_clear(tmp);arb_clear(total)
    def convolve(self, unsigned long blocks):
        cdef acb_dft_rad2_t roots
        cdef slong i
        cdef arb_t cumulative
        start=time.monotonic()
        sig_on();acb_dft_rad2_init(roots,self.exponent,self.precision);sig_off()
        print('ROOTS_DONE',round(time.monotonic()-start,3),flush=True)
        sig_on();acb_dft_rad2_precomp_inplace(self.data,roots,self.precision);sig_off()
        print('DFT_DONE',round(time.monotonic()-start,3),flush=True)
        sig_on()
        for i in range(self.size):acb_pow_ui(self.data+i,self.data+i,blocks,self.precision)
        sig_off()
        print('POWER_DONE',round(time.monotonic()-start,3),flush=True)
        sig_on();acb_dft_inverse_rad2_precomp_inplace(self.data,roots,self.precision);sig_off()
        acb_dft_rad2_clear(roots)
        print('INVERSE_DONE',round(time.monotonic()-start,3),flush=True)
        arb_init(cumulative);arb_zero(cumulative)
        for i in range(self.size):
            if not arb_contains_zero(acb_imagref(self.data+i)):
                arb_clear(cumulative);raise ArithmeticError('imaginary component excludes zero')
            arb_add(cumulative,cumulative,acb_realref(self.data+i),self.precision)
            arb_set(acb_realref(self.data+i),cumulative)
        arb_clear(cumulative)
        print('CDF_DONE',round(time.monotonic()-start,3),flush=True)
    def cdf(self,long i,R):
        cdef RealBall ans=R(0)
        if i<0:return ans
        if i>=self.size:raise IndexError()
        arb_set(ans.value,acb_realref(self.data+i));return ans
    def triangle(self, long width, long blocks, RealBall t, RealBall normalizer, R):
        cdef long a,b,hi,q=18433,half=9216,B=2093922385,Q,Qc
        cdef long llo,lhi,ulo,uhi,base,idx
        cdef arb_t low,up,weight,ratio,ratio_step,first,row_step,tmp,gap
        cdef RealBall anslow=R(0),ansup=R(0)
        arb_init(low);arb_init(up);arb_init(weight);arb_init(ratio);arb_init(ratio_step)
        arb_init(first);arb_init(row_step);arb_init(tmp);arb_init(gap)
        arb_zero(low);arb_zero(up)
        arb_pow_ui(ratio_step,t.value,2,self.precision)
        arb_pow_ui(first,t.value,9217*9217-9217*9216+9216*9216,self.precision)
        arb_div(first,first,normalizer.value,self.precision)
        arb_pow_ui(row_step,t.value,2*9217-9216+1,self.precision)
        try:
            sig_on()
            for a in range(9217,13825):
                hi=18432-2*a
                arb_set(weight,first)
                # Ratio for incrementing b from -9216; signed exponent.
                arb_pow_ui(ratio,t.value,18431-a,self.precision)
                arb_inv(ratio,ratio,self.precision)
                for b in range(-9216,hi+1):
                    Q=a*a+a*b+b*b
                    Qc=(a-q)*(a-q)+(a-q)*b+b*b
                    llo=(B-Qc+width-1)//width
                    lhi=(B-Q-1-blocks*(width-1))//width
                    ulo=(B-Qc-blocks*(width-1)+width-1)//width
                    uhi=(B-Q-1)//width
                    base=(ulo//self.size)*self.size
                    if llo>=base+self.size or lhi>=base+self.size or uhi>=base+self.size:
                        sig_off();raise ArithmeticError('interval crosses modular period')
                    if lhi>=llo:
                        arb_sub(gap,acb_realref(self.data+lhi-base),acb_realref(self.data+llo-1-base),self.precision)
                        arb_mul(tmp,weight,gap,self.precision);arb_add(low,low,tmp,self.precision)
                    arb_sub(gap,acb_realref(self.data+uhi-base),acb_realref(self.data+ulo-1-base),self.precision)
                    arb_mul(tmp,weight,gap,self.precision);arb_add(up,up,tmp,self.precision)
                    arb_mul(weight,weight,ratio,self.precision)
                    arb_mul(ratio,ratio,ratio_step,self.precision)
                arb_mul(first,first,row_step,self.precision)
                arb_mul(row_step,row_step,ratio_step,self.precision)
            sig_off()
            arb_mul_ui(anslow.value,low,4*768,self.precision)
            arb_mul_ui(ansup.value,up,4*768,self.precision)
            return anslow,ansup
        finally:
            arb_clear(low);arb_clear(up);arb_clear(weight);arb_clear(ratio);arb_clear(ratio_step)
            arb_clear(first);arb_clear(row_step);arb_clear(tmp);arb_clear(gap)
'''
Path('radial_engine.pyx').write_text(CODE)
# This Sage installation has no setuptools/distutils. Invoke the already
# installed Cython compiler and C compiler directly; do not install packages.
from Cython.Compiler.Main import compile as compile_cython, CompilationOptions, default_options
from sage.config import get_include_dirs
site=Path(sys.prefix)/('lib/python'+str(sys.version_info.major)+'.'+str(sys.version_info.minor)+'/site-packages')
options=CompilationOptions(default_options,include_path=[str(site)],
    compiler_directives={'language_level':int(3),'cdivision':True},
    output_file=str(Path('radial_engine.c').resolve()))
compiled=compile_cython(str(Path('radial_engine.pyx').resolve()),options=options)
assert compiled.num_errors==0
so=Path('radial_engine'+sysconfig.get_config_var('EXT_SUFFIX')).resolve()
incs=[sysconfig.get_path('include'),str(Path(sys.prefix)/'include'),str(site),
      str(site/'cysignals'),str(site/'sage/libs/flint'),str(site/'sage/ext'),
      str(site/'sage/cpython')]+[str(p) for p in get_include_dirs()]
cmd=['gcc','-O2','-fPIC','-shared']+['-I'+p for p in incs]+['radial_engine.c','-o',str(so),
    '-L'+str(Path(sys.prefix)/'lib'),'-Wl,-rpath,'+str(Path(sys.prefix)/'lib'),'-lflint','-lgmp','-lmpfr']
with open('engine_build.stdout','wb') as out,open('engine_build.stderr','wb') as err:
    build=subprocess.run(cmd,stdout=out,stderr=err,timeout=int(300))
Path('engine_build_receipt.json').write_text(json.dumps(dict(argv=cmd,exit_code=build.returncode,
    generated_source_sha256=hashlib.sha256(Path('radial_engine.pyx').read_bytes()).hexdigest(),
    source_of_math='original arb_radial.sage',network='inherited bwrap --unshare-net'),indent=int(2))+'\n')
assert build.returncode==0,Path('engine_build.stderr').read_text()
spec=importlib.util.spec_from_file_location('radial_engine',so)
engine=importlib.util.module_from_spec(spec);spec.loader.exec_module(engine)
if args.mode=='test':
    R=RealBallField(128);cut=ZZ(24);bound=ceil(sqrt(QQ(4)*cut/3))
    counts=[sum(ZZ(x*x+x*y+y*y==n) for x in range(-bound,bound+1) for y in range(-bound,bound+1)) for n in range(cut+1)]
    t=QQ(1/2);Z=sum(counts[n]*t^n for n in range(cut+1))
    P=PolynomialRing(QQ,'X');X=P.gen()
    p=sum(counts[n]*t^n/Z*X^(n//2) for n in range(cut+1))
    exact=p^3
    fft=engine.BallRadial(6,128)
    fft.fill(int(cut),int(bound),2,R(t),R(Z));fft.convolve(3)
    acc=QQ(0)
    for i in range(64):
        acc+=exact[i]
        assert R(acc).overlaps(fft.cdf(i,R))
        assert fft.cdf(i,R).is_finite() and fft.cdf(i,R).contains_exact(acc)
    result=dict(mode='test',exact_QQ_CDF_matches=int(64),status='PASS')
else:
    R=RealBallField(128);HR=RealBallField(512);C=ComplexBallField(512)
    sig=ZZ(768);cut=ZZ(64)*2*sig^2;width=ZZ(args.bin)
    bound=ceil(sqrt(QQ(4)*cut/3));exponent=ZZ(18 if args.mode=='bench' else args.exponent)
    assert (2*bound+1)^2<2^32 and 3*bound^2<2^63
    assert 1<=width<=128 and exponent<=25
    alpha=HR(1)/(2*sig^2);tau=C(0,1)*C(alpha/HR.pi())
    th=C(0).jacobi_theta(tau);th3=C(0).jacobi_theta(3*tau)
    G=(th[2]*th3[2]+th[1]*th3[1]).real()
    # Safe rectangle tail (from the separately checked series calculation).
    L=ZZ(65536);beta=3*alpha/4;rr=(-beta*(2*L+1)).exp()
    tailG=4*(1+(2*HR.pi()).sqrt()*sig)*(-beta*L^2).exp()/(1-rr)
    G=G.add_error(tailG)
    fft=engine.BallRadial(int(exponent),128)
    fft.fill(int(cut),int(bound),int(width),R((-alpha).exp()),R(G))
    fft.convolve(1535)
    mass=fft.cdf(int(2^exponent-1),R)
    assert mass.is_finite() and mass>1-QQ(1)/10^10 and mass<1+QQ(1)/10^10
    result=dict(mode=args.mode,status='INTERVAL_COMPUTATION_COMPLETED',exponent=int(exponent),bin_width=int(width),
        cutoff=str(cut),precision_bits=int(128),mass_interval=str(mass))
    if args.mode=='full':
        lower,upper=fft.triangle(int(width),1535,R((-alpha).exp()),R(G),R)
        result.update(single_change_modular_lower=str(lower),single_change_modular_upper=str(upper),
            lower_endpoint=str(lower.lower().exact_rational()),upper_endpoint=str(upper.upper().exact_rational()),
            not_final_probability=True,pending=['alias and omitted-block tails','multiple changes','legal-key/retry bridge'])
        print('TRIANGLE_INTERVAL_RAW',lower,upper,flush=True)
Path('arb_radial_result.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('ARB_RADIAL_RESULT',json.dumps(result,sort_keys=True),flush=True)
