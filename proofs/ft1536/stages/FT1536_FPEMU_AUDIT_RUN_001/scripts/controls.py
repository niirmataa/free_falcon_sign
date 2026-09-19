"""Oracle anchor and changed-value negative controls, not implementation mirrors."""
from common import W, dump, job
from arithmetic import check
from oracle import Q, SIGN, rn, sqrt_rn, value, p2

assert rn(Q(1)+p2(-53)) == 0x3ff0000000000000
assert rn(Q(1)+3*p2(-53)) == 0x3ff0000000000002
assert rn(-Q(1)-p2(-53)) == 0xbff0000000000000
assert rn(p2(-1075)) == 0
assert rn(3*p2(-1075)) == 2
assert sqrt_rn(Q(4)) == 0x4000000000000000
assert sqrt_rn(Q(2)) == 0x3ff6a09e667f3bcd
cs=[('add',rn(1),rn(1),0,'ROOT'),('div',rn(1),rn(3),0,'NODE3_div'),
    ('floor',rn(Q(-3,2)),0,0,'ZERO'),('high',(1<<64)-1,(1<<64)-1,0,'high')]
good=[(rn(2),0),(rn(Q(1,3)),0),((1<<64)-2,0),((1<<64)-2,0)]
assert not check(cs,good)['failures']
changed=[]
for i in range(len(cs)):
    out=good.copy();out[i]=(out[i][0]^1,0)
    bad=check(cs,out)['failures']
    assert bad
    changed.append(dict(operation=cs[i][0],detected_checks=[b['check'] for b in bad]))
text=b'lt 8000000000000000 0000000000000000 0\nlt 0000000000000000 8000000000000000 0\nfloor 8000000000000000 0 0\nhalf 0010000000000000 0 0\nmul 0010000000000000 3fe8000000000000 0\ndiv 8000000000000000 3ff0000000000000 0\ninverse_of 3 0 0\n'
(W/'artifacts/finding_reproducer.tsv').write_bytes(text)
outputs={}
for mode in ('normal','asan'):
    p=job('reproducer-'+mode,[f'bin/{mode}/scalar'],text)
    outputs[mode]=p.stdout.decode()
assert outputs['normal']==outputs['asan']
expected='0000000000000001 0000000000000000\n0000000000000000 0000000000000000\nffffffffffffffff 0000000000000000\n0000000000000000 0000000000000000\n0000000000000000 0000000000000000\n0000000000000000 0000000000000000\n3fd5555555555555 0000000000000000\n'
assert outputs['normal']==expected
dump('artifacts/oracle_controls.json',dict(status='PASS',anchors=7,no_op='PASS',changed_value_controls=changed,
    reproducer_stdout=outputs['normal'],numeric_lt_expected=0,numeric_lt_observed=1,
    inverse3_value=str(value(0x3fd5555555555555))))
assert (W/'artifacts/normal_arithmetic.json').read_bytes()==(W/'artifacts/asan_arithmetic.json').read_bytes()
assert (W/'artifacts/normal_scalar.stdout').read_bytes()==(W/'artifacts/asan_scalar.stdout').read_bytes()
assert (W/'artifacts/normal_delta.stdout').read_bytes()==(W/'artifacts/asan_delta.stdout').read_bytes()
print('PASS: 7 exact oracle anchors, 4 changed-value controls, normal/ASan byte agreement and 7-case reproducer')
