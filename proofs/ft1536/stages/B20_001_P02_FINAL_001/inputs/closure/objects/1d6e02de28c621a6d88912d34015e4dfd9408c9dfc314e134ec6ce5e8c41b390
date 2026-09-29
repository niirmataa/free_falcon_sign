import json
from pathlib import Path
W=Path.cwd();d=json.loads((W/'REDUCTION_DOMAIN.json').read_text());text='''import GaussianMetrics
set_option maxRecDepth 16384
set_option maxHeartbeats 5000000
namespace GaussianComparison
structure Bucket where
  e : Nat
  lo : Nat
  hi : Nat
  c : Nat
  rlo : Nat
  rhi : Nat
  deriving DecidableEq
def buckets : List Bucket := [\n'''
text+=',\n'.join('  ⟨'+','.join(map(str,[r['e']]+[int(r[k],16) for k in ['x_first','x_last','source_e_log2','rB_first','rB_last']]))+'⟩' for r in d['buckets'])+']\n'
text+='''def good (r : Bucket) : Bool := decide (r.lo≤r.hi ∧ r.rlo≤r.rhi ∧ r.rhi<9223372036854775808 ∧
  (r.e=0 ∨ (r.c≤r.lo ∧ r.hi≤r.c+4503599627370496 ∧ r.c-4503599627370496≤r.lo)))
def linked : List Bucket → Bool
  | []=>true
  | [_]=>true
  | a::b::xs=>decide (a.hi+1=b.lo ∧ a.e+1=b.e) && linked (b::xs)
theorem all_bucket_instances : buckets.all good=true := by decide
theorem all_brackets_contiguous : linked buckets=true := by decide
theorem bucket_count : buckets.length=394 := by decide
theorem nominal_domain_overruns : (buckets.filter fun r=>r.rhi>4604418534313441775).length=63 := by decide
end GaussianComparison
'''
# The literal log2 word is used, never a decimal approximation.
assert 4604418534313441775==0x3fe62e42fefa39ef
(W/'formal/GaussianData.lean').write_text(text);print('GENERATED_KERNEL_BUCKET_INSTANCES',len(d['buckets']))
