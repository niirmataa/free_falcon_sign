import Source3.C99NatWord141
import Source3.C99LoopScalar141
import Source3.KeygenPublicInputProgram
import Source3.FftLocalCells140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicNat158
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenPublicInputProgram (signed)

theorem guard (s : State) (u n : Nat) (uBound : u<2^64) (nBound : n<2^64)
    (uCell : Cell s "u".toList u) (nCell : Cell s "n".toList n) :
    KeygenPublicWord.Eval signed s KeygenPublicInputProgram.condition (C99ScalarReference.boolean (decide (u<n))) :=
  .cmp .lt _ _ _ _ _ (.scalar _ _ (.variable _ _ _ uCell)) (.scalar _ _ (.variable _ _ _ nCell))
    (C99NatWord141.less u n uBound nBound)

theorem address (s : State) (name : Name) (base : ArrayPointer) (u : Nat)
    (bound : u<2^64) (capacity : base.index+u ≤ base.count)
    (binding : s.arrays name=some base) (counter : Cell s "u".toList u) :
    KeygenPublicWord.Address s name KeygenPublicInputProgram.index {base with index := base.index+u} := by
  refine .add name _ base _ (.uint64 (word u)) binding (.variable _ _ _ counter) ?_ ?_
  · rw [C99NatWord141.integer u bound]
    omega
  · rw [C99NatWord141.integer u bound]
    exact .within base u capacity

theorem initial (s : State) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old)) :
    KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.initial s
      ⟨FftLocalCells140.put s "u".toList 0,.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))

theorem increment (s : State) (u : Nat) (bound : u<2^64) (counter : Cell s "u".toList u) :
    KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.increment s
      ⟨FftLocalCells140.put s "u".toList (word (u+1)),.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .scalar _ _ _ (.assign _ _ _ .uint64 (some (.uint64 (word u))) (.uint64 (word (u+1))) counter
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 1) (C99NatWord141.add_one u bound)))

theorem address_heap (s : State) (heap : C99MemoryReference.Memory) (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
    (source : KeygenPublicWord.Address s name index p) : KeygenPublicWord.Address {s with heap := heap} name index p := by
  cases source with
  | add base _ v binding value positive within => exact .add _ _ base p v binding value positive within

end FT1536.Source3.PublicNat158
