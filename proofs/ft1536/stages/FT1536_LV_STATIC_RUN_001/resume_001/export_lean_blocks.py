"""Same 768 A2 pairs, kernel-checked in blocks; preserve the array attempt."""
import hashlib
import json
from pathlib import Path

W=Path.cwd(); path=W/"artifacts/witness.json"; w=json.loads(path.read_text())
z=w["z1"];assert len(z)==1536
pairs=list(zip(z[:768],z[768:])); assert len(pairs)==768
parts=["""import Std
set_option maxRecDepth 8192
set_option maxHeartbeats 20000000

def pairEnergy (p : Int × Int) : Int := p.1*p.1 + p.1*p.2 + p.2*p.2
def energy : List (Int × Int) → Int
  | [] => 0
  | p :: ps => pairEnergy p + energy ps

theorem energy_append (a b : List (Int × Int)) :
    energy (a ++ b) = energy a + energy b := by
  induction a with
  | nil => simp [energy]
  | cons p ps ih => simp [energy, ih, Int.add_assoc]
"""]
sums=[]
for k in range(12):
    block=pairs[64*k:64*(k+1)]
    value=sum(x*x+x*y+y*y for x,y in block);sums.append(value)
    parts.append("def block_"+str(k)+" : List (Int × Int) := ["+
                 ", ".join("("+str(x)+", "+str(y)+")" for x,y in block)+"]\n")
    parts.append(f"theorem block_{k}_norm : energy block_{k} = {value} := by decide\n")
parts.append("def firstPairs : List (Int × Int) := "+" ++ ".join("block_"+str(k) for k in range(12))+"\n")
parts.append("""
def secondPairs : List (Int × Int) := (-20000, 0) :: List.replicate 767 (0, 0)
def machinePairs : List (Int × Int) := List.replicate 768 (0, 0)

theorem pair_counts : firstPairs.length = 768 ∧ secondPairs.length = 768 ∧ machinePairs.length = 768 := by decide

theorem first_total : energy firstPairs = 42658711057 := by
  simp only [firstPairs, energy_append,"""+
             ", ".join("block_"+str(k)+"_norm" for k in range(12))+"]\n  decide\n")
parts.append("""
theorem second_total : energy secondPairs = 400000000 := by decide
theorem machine_first_total : energy machinePairs = 0 := by decide

theorem full_extractor_norm : energy firstPairs + energy secondPairs = 43058711057 := by
  rw [first_total, second_total]
  decide

theorem machine_pair_short : energy machinePairs + energy secondPairs < 2093922385 := by
  rw [machine_first_total, second_total]
  decide

theorem extractor_pair_not_short : ¬ energy firstPairs + energy secondPairs < 2093922385 := by
  rw [full_extractor_norm]
  decide

theorem extractor_excess : energy firstPairs + energy secondPairs - 2093922385 = 40964788672 := by
  rw [full_extractor_norm]
  decide

theorem pre_ntt_word : ((-20000 : Int) + 18433) % 65536 = 63969 := by decide
theorem distinct_residues : (-20000 : Int) % 18433 = 16866 ∧ (63969 : Int) % 18433 = 8670 := by decide
theorem long_unary_counter_wrap : ((2 : Nat)^32) % (2^32) = 0 := by decide
theorem long_unary_accept_boundary : (((2 : Nat)^32 + 255) % (2^32)) ≤ 255 := by decide
theorem long_unary_reject_boundary : ¬ (((2 : Nat)^32 + 256) % (2^32)) ≤ 255 := by decide

#print axioms energy_append
""")
for k in range(12): parts.append(f"#print axioms block_{k}_norm\n")
for name in ["pair_counts","first_total","second_total","machine_first_total",
             "full_extractor_norm","machine_pair_short","extractor_pair_not_short",
             "extractor_excess","pre_ntt_word","distinct_residues",
             "long_unary_counter_wrap","long_unary_accept_boundary","long_unary_reject_boundary"]:
    parts.append("#print axioms "+name+"\n")
source="\n".join(parts)
target=W/"formal/WitnessBlocks.lean"
with target.open("x") as f:f.write(source)
assert sum(sums)==42658711057
binding=dict(witness_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
             lean_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),
             pairs=768,block_size=64,block_sums=sums,
             ordered_pairs_sha256=hashlib.sha256(json.dumps(pairs,separators=(",",":")).encode()).hexdigest(),
             offset=768,
             scope="kernel checks every literal A2 pair energy, append grouping and exact inequalities; Sage checks the extractor identity; C acceptance separately replayed",
             prior_attempt_preserved="formal/Witness.lean")
with (W/"artifacts/lean_blocks_binding.json").open("x") as f:json.dump(binding,f,indent=2);f.write("\n")
print(json.dumps(binding,indent=2))
