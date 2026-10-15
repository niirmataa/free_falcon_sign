import Source3.KeygenNormStep151

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormInduction151
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open KeygenNormInvariant151 (Fixed Norm names)

def sum {n : Nat} (f g : Fin n → BitVec 64) : Nat → Nat → BitVec 64 → BitVec 64
  | 0,_,acc => acc
  | count+1,u,acc => sum f g count (u+1) (KeygenNormStep151.advance f g u acc)

/-- The original ordered accumulation, including all guards and the final false guard. -/
theorem source (ctx : KeygenSearchContext.Context) (s : State) (p q : ArrayPointer) (n u count : Nat)
    (f g : Fin n → BitVec 64) (acc : BitVec 64) (fixed : Fixed s p q n f g)
    (counter : Cell s "u".toList u) (norm : Norm s acc) (remaining : u+count=n) :
    ∃ after, KeygenSearchExec.Exec ctx KeygenNormShape151.loop s ⟨after,.normal⟩ ∧ Fixed after p q n f g ∧
      Cell after "u".toList n ∧ Norm after (sum f g count u acc) ∧ C99ScopeFrame147.Frame names s after ∧ after.heap=s.heap := by
  induction count generalizing s u acc with
  | zero =>
    have same : u=n := by omega
    have guard : C99ArrayReference.scalar s KeygenNormShape151.condition (.int32 0) := by
      have evaluated := KeygenNormInvariant151.guard s p q n u f g fixed counter (by omega)
      simpa [same,C99ScalarReference.boolean] using evaluated
    exact ⟨s,.loopFalse _ _ _ s (.int32 0) guard (by decide),fixed,same ▸ counter,norm,C99ScopeFrame147.refl names s,rfl⟩
  | succ count ih =>
    have range : u<n := by omega
    obtain ⟨middle,next,body,increment,nextFixed,nextCounter,nextNorm,stepFrame,stepHeap⟩ :=
      KeygenNormStep151.source ctx s p q n u f g acc fixed counter norm range
    obtain ⟨after,tail,lastFixed,lastCounter,lastNorm,tailFrame,tailHeap⟩ :=
      ih next (u+1) _ nextFixed nextCounter nextNorm (by omega)
    have guard : C99ArrayReference.scalar s KeygenNormShape151.condition (.int32 1) := by
      have evaluated := KeygenNormInvariant151.guard s p q n u f g fixed counter (by omega)
      simpa [range,C99ScalarReference.boolean] using evaluated
    exact ⟨after,.loopNormal _ _ _ s middle next _ (.int32 1) guard (by decide) body increment tail,lastFixed,lastCounter,lastNorm,
      C99ScopeFrame147.trans names s next after stepFrame tailFrame,tailHeap.trans stepHeap⟩

end FT1536.Source3.KeygenNormInduction151
