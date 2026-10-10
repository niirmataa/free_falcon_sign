# sage CHECK_PAIR_BUDGET_017.sage OUTPUT_JSON
from pathlib import Path
import json,sys
b=QQ(1)/2^115; d=QQ(1)/2^108; tau=QQ(1)/2^130
cp=(1+b)^2*(1+d)^2; cm=(1-b)^2*(1-d)^3
rejection_margin=cm*(1-tau)*4200000/2723^2-QQ(9)/16
density_margin=(1+QQ(1)/2^100)*cm*(1-tau)-cp
assert rejection_margin>0 and density_margin>0
p=Path(sys.argv[1]);assert not p.exists()
p.write_text(json.dumps({'status':'EXACT_QQ_PASS','cp':str(cp),'cm':str(cm),
 'rejection_margin':str(rejection_margin),'density_margin':str(density_margin)},indent=2)+'\n')
print('PASS exact rejection and normalized density margins')
