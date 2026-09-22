# Confirm finite-instance enclosure despite non-exact QQ(RealNumber) conversion.
# Run by the native Sage preparser; output is a fresh per-run certificate.
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import os,json
from pathlib import Path
from sage.env import SAGE_VERSION
x = QQ(2093922385)/1179648
A = RealBallField(256)
e = A(-x).exp()
m_exact = e.mid().exact_rational()
r_exact = e.rad().exact_rational()
qm = QQ(e.mid())
qr = QQ(e.rad())
conversion_error = abs(qm-m_exact)
slack = 2*qr-r_exact-conversion_error
assert r_exact > 0 and qr > 0 and slack > 0
# Thus [qm-2qr,qm+2qr] contains Arb's certified [m-r,m+r].
assert qm-2*qr <= m_exact-r_exact
assert qm+2*qr >= m_exact+r_exact
# Separate exact finite-sum check by a second recurrence in reverse order.
n = ZZ(1536)
last = x^(n-1)/factorial(n-1)
acc = last
for k in range(n-1,0,-1):
    last = last*k/x
    acc += last
assert last == 1
radius = 2*qr*acc
assert radius > QQ(1)/10^305
I = RealIntervalField(512)
out = {'sage_version':SAGE_VERSION,'mode':'sage lemma.sage',
       'QQ_mid_exact_binary':bool(qm == m_exact),
       'QQ_rad_exact_binary':bool(qr == r_exact),
       'conversion_mid_error_over_arb_radius':str(I(conversion_error/r_exact)),
       'remaining_outward_slack_over_arb_radius':str(I(slack/r_exact)),
       'author_2rad_encloses_arb_interval_for_this_x':True,
       'author_tail_radius_display':str(I(radius)),
       'claimed_radius_1e_minus305_not_supported_by_author_code':True,
       'scope':'finite pinned x; correct numeric tail bounds, inaccurate exact-conversion/precision wording'}
O=Path(os.environ['FT_REVIEW_OUTPUT']);O.mkdir(parents=True,exist_ok=True)
(O/'rounding_enclosure.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print(json.dumps(out,indent=2,sort_keys=True))
print('PASS_FINITE_OUTWARD_ENCLOSURE_WITH_PRECISION_FINDING')
