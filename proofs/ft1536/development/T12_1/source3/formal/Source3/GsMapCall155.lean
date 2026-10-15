import Source3.GsMapCallee155
import Source3.FprOfModulus155
import Source3.C99Load64Frame148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsMapCall155
open C99ArrayReference (State Name bindValue bindPointer Bind)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents element)

def empty (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def full (s : State) := bindValue (empty s) "full".toList .uint32 (.int32 1)
def dimensions (s : State) := bindValue (full s) "logn".toList .uint32 (.uint32 10)
def adjointBound (s : State) (base : ArrayPointer) := bindPointer (dimensions s) "a".toList base
def factorBound (s : State) := bindValue (dimensions s) "x".toList .uint64 (.uint64 FprOfModulus155.word)
def scaleBound (s : State) (base : ArrayPointer) := bindPointer (factorBound s) "a".toList base

theorem pointer (s : State) (name : String) (base : ArrayPointer)
    (binding : s.arrays name.toList=some base) (capacity : base.index+1536 ≤ base.count) :
    C99ArrayReference.Pointer s name.toList (.literal .u64 0) base :=
  C99PointerNat141.source s name.toList (.literal .u64 0) base 0 (by decide) (by omega) binding (.literal .uint64 0)

theorem adjoint_binding (s : State) (name : String) (base : ArrayPointer)
    (binding : s.arrays name.toList=some base) (capacity : base.index+1536 ≤ base.count)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    Bind s GsMapShape155.adjointFunction.params (FftShape138.args name) (adjointBound s base) :=
  .pointer "a".toList name.toList (.literal .u64 0) base _ _ (dimensions s) (pointer s name base binding capacity)
    (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ (full s) (.uint32 10)
      (.variable "logn".toList .uint32 (.uint32 10) logn)
      (.scalar .uint32 "full".toList (.literal .i32 1) [] [] (empty s) (.int32 1) (.literal .int32 1) .nil))

theorem scale_binding (s : State) (name : String) (base : ArrayPointer)
    (binding : s.arrays name.toList=some base) (capacity : base.index+1536 ≤ base.count)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    Bind s KeygenAttemptFft.params (KeygenAttemptFft.arguments name) (scaleBound s base) :=
  .pointer "a".toList name.toList (.literal .u64 0) base _ _ (factorBound s) (pointer s name base binding capacity)
    (.scalar .uint64 "x".toList _ _ _ (dimensions s) (.uint64 FprOfModulus155.word)
      (.call1 _ _ (.int32 18433) _ (.literal .int32 18433) FprOfModulus155.source)
      (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ (full s) (.uint32 10)
        (.variable "logn".toList .uint32 (.uint32 10) logn)
        (.scalar .uint32 "full".toList (.literal .i32 1) [] [] (empty s) (.int32 1) (.literal .int32 1) .nil)))

theorem adjoint (s : State) (name : String) (base : ArrayPointer) (input : Fin 1536 → BitVec 64)
    (binding : s.arrays name.toList=some base) (capacity : base.index+1536 ≤ base.count)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (width : base.elementBytes=8) (writable : s.heap.writable base.block=true)
    (represented : Represents s.heap base input) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program
      (.call "falcon_poly_adj_fft3".toList (FftShape138.args name) .discard) s ⟨after,.normal⟩ ∧
      Represents after.heap base (GsMapLoop155.image .adjoint 0 768 input) ∧ FftGroupFrame143.Frame base 1536 s after := by
  obtain ⟨callee,body,image,frame⟩ := GsMapCallee155.adjoint (adjointBound s base) base input rfl rfl width capacity rfl writable represented
  let after : State := {s with heap := callee.heap}
  refine ⟨after,?_,image,⟨rfl,rfl,rfl,rfl,frame.sizes,frame.writable,frame.bytes⟩⟩
  exact .call "falcon_poly_adj_fft3".toList (FftShape138.args name) .discard GsMapShape155.adjointFunction
    s (adjointBound s base) after ⟨callee,.normal⟩ none GsMapShape155.adjoint_source
    (adjoint_binding s name base binding capacity logn) body .voidEnd (.discard _ none)

theorem scale (s : State) (name : String) (base : ArrayPointer) (input : Fin 1536 → BitVec 64)
    (binding : s.arrays name.toList=some base) (capacity : base.index+1536 ≤ base.count)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (width : base.elementBytes=8) (writable : s.heap.writable base.block=true)
    (represented : Represents s.heap base input) :
    ∃ after, KeygenAttemptFft.Call s (KeygenAttemptFft.arguments name) after ∧
      Represents after.heap base (GsMapLoop155.image .scale FprOfModulus155.word 0 input) ∧ FftGroupFrame143.Frame base 1536 s after := by
  obtain ⟨callee,body,image,frame⟩ := GsMapCallee155.scale (scaleBound s base) base FprOfModulus155.word input
    rfl rfl rfl width capacity rfl writable represented
  exact ⟨{s with heap := callee.heap},.run (scaleBound s base) ⟨callee,.normal⟩
    (scale_binding s name base binding capacity logn) body .voidEnd,image,
    ⟨rfl,rfl,rfl,rfl,frame.sizes,frame.writable,frame.bytes⟩⟩

theorem preserve_image {n m : Nat} (s t : State) (base other : ArrayPointer) (input : Fin m → BitVec 64)
    (frame : FftGroupFrame143.Frame base n s t)
    (outside : ∀ (i : Fin m) (j : Fin 8), FftLoopFrame141.Outside base n (element other i).block ((element other i).offset+j.val))
    (image : Represents s.heap other input) : Represents t.heap other input := by
  intro i
  exact C99Load64Frame148.source s.heap t.heap (element other i) (input i) frame.sizes
    (fun j => frame.bytes _ _ (outside i j)) (image i)

end FT1536.Source3.GsMapCall155
