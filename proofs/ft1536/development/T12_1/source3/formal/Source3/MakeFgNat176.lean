import Source3.MakeFgConversionShape176
import Source3.C99LoopScalar141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgNat176
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenMakeFgSource (Exec)

theorem address (s : State) (name : Name) (base : ArrayPointer) (u : Nat)
    (bound : u<2^64) (capacity : base.index+u≤base.count)
    (binding : s.arrays name=some base) (counter : Cell s "u".toList u) :
    C99ArrayReference.Pointer s name MakeFgConversionShape176.index {base with index:=base.index+u} := by
  refine .add _ _ base _ (.uint64 (word u)) binding (.variable _ _ _ counter) ?_ ?_
  · rw [C99NatWord141.integer u bound]; omega
  · rw [C99NatWord141.integer u bound]
    exact .within base u capacity

theorem guard (s : State) (u n : Nat) (uBound : u<2^64) (nBound : n<2^64)
    (uCell : Cell s "u".toList u) (nCell : Cell s "n".toList n) :
    C99ArrayReference.scalar s MakeFgConversionShape176.condition (C99ScalarReference.boolean (decide (u<n))) :=
  C99LoopScalar141.less s _ _ u n uBound nBound (.variable _ _ _ uCell) (.variable _ _ _ nCell)

theorem initial (s : State) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old)) :
    Exec MakeFgConversionShape176.initial s ⟨FftLocalCells140.put s "u".toList 0,.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 old (.int32 0) declared
    (.scalar _ _ (.literal .int32 0))))

theorem increment (s : State) (u : Nat) (bound : u<2^64) (counter : Cell s "u".toList u) :
    Exec MakeFgConversionShape176.increment s ⟨FftLocalCells140.put s "u".toList (word (u+1)),.normal⟩ := by
  have run := C99LoopScalar141.increment (fun _ => none) s "u".toList u bound counter
  cases run with
  | base _ _ _ source =>
    exact MakeFgDeclarations176.array_source _ _ _ source

end FT1536.Source3.MakeFgNat176
