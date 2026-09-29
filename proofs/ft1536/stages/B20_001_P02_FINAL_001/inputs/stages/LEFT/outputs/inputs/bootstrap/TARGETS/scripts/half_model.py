"""Literal fpr-emulated.h165-174, including unsigned wrap and correction mask."""
from fp_literal import u64
def half(x):
 x=u64(x-(1<<52));t=(((x>>52)&2047)+1)>>11
 return x&u64(t-1)
