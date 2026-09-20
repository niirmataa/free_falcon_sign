"""Literal integer transcription of active C FPEMU scaled/add/sub/floor.
This module performs no host floating arithmetic. It is a source model,
distinct from the independent exact dyadic interpretation in dyadic.py.
"""
MASK=(1<<64)-1;U32=(1<<32)-1
def u64(x):return x&MASK
def u32(x):return x&U32
def i64(x):return (x+(1<<63))%(1<<64)-(1<<63)
def irsh(x,n):
    x=i64(x)^((i64(x)^(i64(x)>>32))&(-1 if n>>5 else 0))
    return i64(x)>>(n&31)
def norm64(m,e):
    m=u64(m);e-=63
    for shift in [32,16,8,4,2,1]:
        nt=u32(m>>(64-shift));nt=u32(nt|u32(-nt))>>31
        m=u64(m^((m^u64(m<<shift))&u64(nt-1)))
        e+=nt*shift
    return m,e
def pack(s,e,m):
    e+=1076;t=u32(e)>>31;m &=u64(t-1);t=m>>54;e &= -t
    x=u64(((s<<63)|(m>>2))+(u32(e)<<52));f=m&7
    return u64(x+((0xC8>>f)&1))
def of(i):
    assert -(1<<63)<i<(1<<63)
    s=u64(i)>>63;i=(i^(-s))+s
    m,e=norm64(u64(i),9)
    m|=(u32(m)&0x1ff)+0x1ff;m>>=9
    t=u32(u64(i|-i)>>63);m&=u64(-t);e &= -t
    return pack(s,e,m)
def floor(x):
    e=(x>>52)&2047;t=x>>63;xi=((u64(x<<10)|(1<<62))&((1<<63)-1));xi=(xi^(-t))+t
    cc=1085-e;xi=irsh(xi,cc&63)
    xi^=(xi^(-t))&(-(u32(63-cc)>>31))
    return xi
def add(x,y,trace=False):
    mask=(1<<63)-1;za=u64((x&mask)-(y&mask));cs=(za>>63)|((1-(u64(-za)>>63))&(x>>63))
    m=(x^y)&u64(-cs);x^=m;y^=m
    ex=x>>52;sx=ex>>11;ex&=2047;m=((ex+2047)>>11)<<52;xu=((x&((1<<52)-1))|m)<<3;ex-=1078
    ey=y>>52;sy=ey>>11;ey&=2047;m=((ey+2047)>>11)<<52;yu=((y&((1<<52)-1))|m)<<3;ey-=1078
    raw_xu,raw_yu=xu,yu;cc=ex-ey;shift=cc
    yu&=u64(-(u32(cc-60)>>31));cc&=63;m=(1<<cc)-1;yu|=(yu&m)+m;yu>>=cc
    aligned=yu;xu=u64(xu+yu-((yu<<1)&u64(-(sx^sy))));T=xu
    xu,en=norm64(xu,ex);normal=xu;xu|=(u32(xu)&0x1ff)+0x1ff;xu>>=9;en+=9
    out=pack(sx,en,xu)
    if trace:return out,dict(sorted_x=x,sorted_y=y,ex=ex,ey=ey,shift=shift,sx=sx,sy=sy,raw_xu=raw_xu,raw_yu=raw_yu,
         aligned=aligned,T=T,normal=normal,m=xu,e=en,output=out)
    return out
def sub(x,y,trace=False):return add(x,y^(1<<63),trace)
def center(x):return sub(x,of(floor(x)))
def residual(x,z):return sub(x,of(floor(x)+z))
