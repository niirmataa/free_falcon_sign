import Source3.KeygenMkgm3Rows
import Source3.KeygenRev10Cert

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Physical gm indices. Row nine is the full ternary row; row eight
   cubes its even-address children, and rows seven through zero square.
   The finite index certificate is generated separately and kernel checked.
   These definitions do not depend on NTT loop counters or evaluations. -/
namespace FT1536.Source3.KeygenMkgm3Indices
open KeygenMkgm3Rows (exponent)

def reverse9 (u : Nat) : Nat := KeygenRev10.bitrev10 (2*u)
def lastIndex (u : Nat) : Nat := 512+reverse9 u
def level (i : Nat) : Nat := Nat.log2 (max 1 i)
def rowExponent (k j : Nat) : Nat :=
  (if k=9 then 1 else 3*2^(8-k))*exponent (KeygenRev10.bitrev k j)
def tableExponent (i : Nat) : Nat := rowExponent (level i) (max 1 i-2^level i)
def tableOrder (i : Nat) : Nat := if 512 ≤ i then 4608 else 6*2^level i

def IndexFact (i : Nat) : Prop :=
  (i<512 → reverse9 i<512 ∧ reverse9 (reverse9 i)=i ∧
    tableExponent (lastIndex i)=exponent i) ∧
  (256 ≤ i ∧ i<512 → tableExponent i=3*tableExponent (2*i)) ∧
  (1 ≤ i ∧ i<256 → tableExponent i=2*tableExponent (2*i)) ∧
  (i<1024 → 0<tableExponent i ∧ 4608/Nat.gcd 4608 (tableExponent i)=tableOrder i)

instance (i : Nat) : Decidable (IndexFact i) := by unfold IndexFact; infer_instance

theorem top_exponent : tableExponent 0=tableExponent 1 := rfl
theorem top_order : tableOrder 0=6 ∧ tableOrder 1=6 := by decide

end FT1536.Source3.KeygenMkgm3Indices
