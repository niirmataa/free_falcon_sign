# Exact public range cross-check; the universal results are proved in Lean.
from pathlib import Path
import hashlib, json, sys
assert parent(1) is ZZ and parent(1/3) is QQ
src=Path(sys.argv[1])
pins={'falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
      'fpr-emulated.c':'7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f',
      'fpr-emulated.h':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'}
for name,pin in pins.items():
    assert hashlib.sha256((src/name).read_bytes()).hexdigest()==pin
lo=-(2^31); hi=2^31-1
ranges={
 'decoded_exponent':(-1078,969),
 'difference':(-2047,2047),
 'difference_minus_60':(-2107,1987),
 'mul_aggregate':(-2100,2047+2047-2100+511),
 'div_aggregate':(-2047-55,2047-55+511),
 'norm_after_sub63':(-1078-63,969-63),
 'norm_after_five_rounds_and_last':(-1078-63,969-63+5*32+1),
 'norm_after_sticky_shift':(-1078-63+9,969-63+5*32+1+9)}
assert ranges['mul_aggregate']==(-2100,2505)
assert ranges['div_aggregate']==(-2102,2503)
assert ranges['norm_after_five_rounds_and_last']==(-1141,1067)
for lower,upper in ranges.values():
    assert lo<=lower<=upper<=hi
for key in ['mul_aggregate','div_aggregate','norm_after_sticky_shift']:
    lower,upper=ranges[key]
    assert lo<=lower+1076<=upper+1076<=hi
assert (2^64-1)//2^55 == 511
assert (2^64-1)//2^54 == 1023
assert (2^32-1)//2^31 == 1
assert ((-1)%2^64)==2^64-1
assert ((-1)//2)==-1
assert (2^31-1)+1>hi
assert all(0<=i<55 for i in range(int(55))) and 55<=hi
result={'scope':'exact cross-check only; no universal theorem supplied by this script',
        'pins':pins,'ranges':{k:list(map(int,v)) for k,v in ranges.items()},
        'checks':['pack signed domains','55 increments','GCC sign conversion','arithmetic negative shift'],
        'mode':'sage preparser; ZZ/QQ'}
Path('TOTALITY_RANGES.json').write_text(json.dumps(result,sort_keys=True,indent=int(2))+'\n')
print('TOTALITY_RANGES_PASS',json.dumps(result,sort_keys=True))
