import NormalizeMap
import SqrtPack
namespace StableNorm
-- The source success path supplies this pre-normalization fact, not normalized conclusions.
theorem deterministic_gate_transport {R L : Type} (core : R → Option (L×Bool))
    (keyRoot signerRoot : R) (leaves : L) (hroot : keyRoot=signerRoot)
    (accepted : core keyRoot=some (leaves,true)) : core signerRoot=some (leaves,true) := by
  simpa only [←hroot] using accepted
theorem suffix_runs_before_return {L S : Type} (helper : Option (L×Bool))
    (normalize : L → Option S) (leaves : L) (ok : Bool) (state : S)
    (hh : helper=some (leaves,ok)) (hn : normalize leaves=some state) :
    (do let z←helper;let st←normalize z.1;pure (z.2,st))=some (ok,state) := by
  simp [hh,hn]
theorem mandatory_before_break (mandatory privateSerialized publicSerialized : Bool)
    (emitted : (mandatory && privateSerialized && publicSerialized)=true) : mandatory=true := by
  cases mandatory <;> simp_all
def found : List Bool → Bool
  | [] => false
  | b::bs => b || found bs
theorem last_coefficient_suffices (bs : List Bool) : found (bs++[true])=true := by
  induction bs with
  | nil => rfl
  | cons b bs ih => simp [found,ih]
theorem scoped_H4_consumer (v D : Int) (hd : 0<D)
    (h : 17763*D≤10000*v ∧ 10000*v<5759999*D) :
    17203*D≤10000*v ∧ 100*v<59519*D := by omega
theorem paired_variance_margin (v D : Int) (hd : 0<D)
    (h : 10000*v<7679999*D) : v<768*D := by omega
theorem source_suffix_count_return (ok : Bool) :
    (ok && decide ((1536:Nat)=1536) && decide ((18432:Nat)=12*1536))=ok := by simp
end StableNorm
