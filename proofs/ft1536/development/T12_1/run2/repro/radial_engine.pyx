
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
