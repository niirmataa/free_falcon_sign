# Exact scalar consequences of kernel-proved symbolic counts; standard preparser.
# Not a sampler execution, total time bound, memory peak or security estimate.
from pathlib import Path
from sage.version import version as sage_version
import hashlib,json,re,sys
s=Path('proofs/ft1536/development/S05_QROM')
files=[s/'formal/ProducerNumbers020E6.lean',s/'formal/ProducerCoreExecution020E11.lean',s/'formal/CoreRank020E5.lean']
pn,ce,cr=[p.read_text() for p in files]
w=ZZ(re.search(r'theorem window_size .*?=(\d+) :=',pn).group(1))
c=ZZ(re.search(r'theorem slot_size .*?=(\d+) :=',pn).group(1))
m=re.search(r'def budget : Nat := (\d+)\*CoreRank020E5.cycle (\d+)\+1',ce)
limit,cap=ZZ(m.group(1)),ZZ(m.group(2))
assert 'def cycle (cap : Nat) : Nat := 2*cap+8' in cr
cycles=w+c
budget=limit*(2*cap+8)+1
values={'producer_cycles_per_round':cycles,'fetch_execute_transitions_per_round':2*cycles,
 'consumer_steps_per_round':ZZ(32),'core_round_budget':budget,
 'producer_cycles_upper':cycles*budget,'fetch_execute_transitions_upper':2*cycles*budget,
 'consumer_steps_upper':32*budget,'target_writes_upper':32*budget,'driver_tests_upper':budget}
assert w==3469 and c==11264 and cycles==14733
assert all(v>=0 for v in values.values())
out=Path(sys.argv[1]);assert out.is_dir()
receipt={'sage':sage_version,'domain':'ZZ','status':'EXACT_SCALAR_COUNTS_ONLY',
 'values':{k:str(v) for k,v in values.items()},
 'inputs':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in files],
 'scope':'Scalar arithmetic from pinned definitions. Universal execution bounds are separate Lean theorems. No full primitive time/peak/native claim.'}
p=out/'numbers.json';assert not p.exists();p.write_text(json.dumps(receipt,indent=2)+'\n')
code='''import PublicCallCount020E13

namespace FT1536.S05.ExecutionCountNumbers020E13
open WordRAM020 JointInterface019

theorem budget_value : ProducerCoreExecution020E11.budget=%s := by
  norm_num [ProducerCoreExecution020E11.budget,CoreRank020E5.cycle]

theorem public_bounds (d : PublicData020E5.Data) (coins : Bits tapeSize) :
    (PublicCallCount020E13.run d coins).counts.cycles≤%s ∧
    (PublicCallCount020E13.run d coins).counts.slots≤%s ∧
    (PublicCallCount020E13.run d coins).counts.writes≤%s ∧
    (PublicCallCount020E13.run d coins).counts.tests≤%s := by
  have h := PublicCallCount020E13.core_bound d coins
  exact ⟨h.1.trans_eq (by rw [budget_value]),h.2.1.trans_eq (by rw [budget_value]),
    h.2.2.1.trans_eq (by rw [budget_value]),h.2.2.2.trans_eq budget_value⟩

end FT1536.S05.ExecutionCountNumbers020E13
'''%(budget,values['producer_cycles_upper'],values['consumer_steps_upper'],values['target_writes_upper'],budget)
p=out/'ExecutionCountNumbers020E13.lean';assert not p.exists();p.write_text(code)
print(json.dumps(receipt,indent=2))
