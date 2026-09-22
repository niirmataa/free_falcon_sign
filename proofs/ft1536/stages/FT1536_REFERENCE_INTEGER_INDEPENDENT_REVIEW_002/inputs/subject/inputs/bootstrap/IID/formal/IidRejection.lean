import IidCDF
import IidHighWord
namespace ScalarIID
def geometricCount (d r : Int) : Nat → Int
  | 0=>0
  | n+1=>d*geometricCount d r n+r^n
theorem finite_geometric_count (d r a : Int) (h : a+r=d) (n : Nat) :
    a*geometricCount d r n+r^n=d^n := by
  induction n with
  | zero => simp [geometricCount]
  | succ n ih => simp only [geometricCount,Int.pow_succ];grind
theorem normalized_mass_integer (weights : List Nat) (a c : Nat) (h : weights.sum=a) :
    (weights.map fun w=>w*c).sum=a*c := by
  subst a
  induction weights with
  | nil => simp
  | cons w ws ih => simp only [List.map_cons,List.sum_cons,ih,Nat.add_mul]
theorem positive_normalizer (a d : Nat) (hd : 0<d) (ha : d≤256*a) : 0<a := by omega
theorem strict_reject_fraction (a d : Nat) (hd : 0<d) (ha : 0<a ∧ a≤d) :
    d-a<d ∧ 256*(d-a)≤255*d ↔ d≤256*a := by omega
theorem source_return_injective_left (s : Int) (k l : Nat) : s-(k:Int)=s-(l:Int) ↔ k=l := by omega
theorem source_return_injective_right (s : Int) (k l : Nat) : s+1+(k:Int)=s+1+(l:Int) ↔ k=l := by omega
theorem normal_zero_is_not_fault : OrderedReach.Outcome.normal 0≠OrderedReach.Outcome.fault := by decide
end ScalarIID
