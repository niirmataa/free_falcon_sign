import Source3.SixthStepInvariant217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepIteration217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open SixthStepLayout217 (fd gd fs gs)
open SixthStepLoopBase217
open SixthStepInvariant217 (Active RowImage putTables)
open SixthStepInner217 (inner_source tableWord)

theorem source (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32) (u : Nat)
    (active : Active s F G tables u) (slot : u<22) :
    ∃ (mid : State) (ivs : Fin 16 → BitVec 32),
      Exec StepPrimeShape188.body s ⟨bodyState s mid,.normal⟩ ∧
      Exec StepPrimeShape188.increment (bodyState s mid) ⟨counter s mid (u+1),.normal⟩ ∧
      Active (counter s mid (u+1)) F G (putTables tables u ivs) (u+1) := by
  have primeInput : CrtPrimePrefix214.Input s u (primeRow u) :=
    ⟨by omega,active.outer.uCell,primeRow_value u slot,active.outer.primesBinding,active.object⟩
  obtain ⟨mid,ivs,inner,basic,fdImage,gdImage,fsImage,gsImage,keep⟩ :=
    inner_source s u (primeRow u) (col F u) (col G u) active.outer primeInput slot
      active.revBinding active.revSource
      (active.pendingF u (Nat.le_refl u) slot) (active.pendingG u (Nat.le_refl u) slot)
  have objectMid:=object_keep active.object inner
  have revMid:=rev_keep active.revSource inner
  have revBMid:=revB_keep active.revBinding inner
  refine ⟨mid,ivs,scope_source s mid inner,incrementK s mid u slot basic.uCell,?_⟩
  refine ⟨outer_counter basic s (u+1),?_,?_,?_,?_,?_,?_⟩
  · rw [counter_heap]; exact objectMid
  · exact revBMid
  · rw [counter_heap]; exact revMid
  · intro k later kb j jb
    rw [counter_heap]
    exact keep_fs keep (by omega) slot kb jb _ (active.pendingF k (by omega) kb j jb)
  · intro k later kb j jb
    rw [counter_heap]
    exact keep_gs keep (by omega) slot kb jb _ (active.pendingG k (by omega) kb j jb)
  · intro k earlier kb
    by_cases same : k=u
    · subst k
      refine ⟨?_,?_,?_,?_⟩
      · intro i bound; rw [counter_heap]; exact fdImage i bound
      · intro i bound; rw [counter_heap]; exact gdImage i bound
      · intro j bound
        rw [counter_heap]
        simpa only [putTables,ite_true] using fsImage j bound
      · intro j bound
        rw [counter_heap]
        simpa only [putTables,ite_true] using gsImage j bound
    · have old:=active.written k (by omega) kb
      have tableEq : putTables tables u ivs k=tables k := by simp only [putTables,same,ite_false]
      refine ⟨?_,?_,?_,?_⟩
      · intro i bound; rw [counter_heap]
        exact keep_fd keep same slot kb i.isLt _ (old.fd i bound)
      · intro i bound; rw [counter_heap]
        exact keep_gd keep same slot kb i.isLt _ (old.gd i bound)
      · intro j bound; rw [counter_heap,tableEq]
        exact keep_fs keep same slot kb bound _ (old.fs j bound)
      · intro j bound; rw [counter_heap,tableEq]
        exact keep_gs keep same slot kb bound _ (old.gs j bound)

end FT1536.Source3.SixthStepIteration217
