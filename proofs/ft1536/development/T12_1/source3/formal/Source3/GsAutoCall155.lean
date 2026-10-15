import Source3.GsAutoLoop155
import Source3.GsMapCall155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsAutoCall155
open C99ArrayReference (State bindPointer Bind)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)

def image (multiplier : Fin 768 → BitVec 64) (input : Fin 1536 → BitVec 64) :=
  GsAutoValues155.image 1536 768 (by decide) multiplier 768 0 input

theorem callee (s : State) (a b : ArrayPointer) (input : Fin 1536 → BitVec 64) (multiplier : Fin 768 → BitVec 64)
    (full : s.locals "full".toList=some (.uint32,some (.uint32 1)))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (width : a.elementBytes=8) (capacityA : a.index+1536 ≤ a.count) (capacityB : b.index+768 ≤ b.count)
    (bindingA : s.arrays "a".toList=some a) (bindingB : s.arrays "b".toList=some b)
    (writable : s.heap.writable a.block=true) (represented : Represents s.heap a input) (multiplierImage : Represents s.heap b multiplier)
    (separate : ∀ (i : Fin 1536) (j : Fin 768), C99WordRead140.Separate (C99WordBuffer140.element a i) (C99WordBuffer140.element b j)) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program GsAutoShape155.function.body s ⟨after,.normal⟩ ∧
      Represents after.heap a (image multiplier input) ∧ Represents after.heap b multiplier ∧
      FftFirstFrame149.Frame a 1536 (GsInvNormSetup154.initial s) after := by
  have fixed : GsAutoLoop155.Fixed (GsInvNormSetup154.initial s) a b 1536 768 multiplier :=
    ⟨by decide,by decide,capacityA,capacityB,width,bindingA,bindingB,GsInvNormSetup154.hn_cell s,writable,multiplierImage,separate⟩
  obtain ⟨after,loop,lastFixed,image,frame⟩ := GsAutoLoop155.source (GsInvNormSetup154.initial s) a b 1536 768 multiplier input
    fixed represented (GsInvNormSetup154.u_cell s)
  refine ⟨after,?_,image,lastFixed.multiplierImage,frame⟩
  exact .seqNormal _ _ _ _ _ (GsInvNormSetup154.declaration s)
    (.seqNormal _ _ _ _ _ (GsInvNormSetup154.size s full logn)
      (.seqNormal _ _ _ _ _ (GsInvNormSetup154.half_size s)
        (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ (GsInvNormSetup154.initialization s) loop) (.base _ _ _ (.skip _)))))

def arguments (name : String) : List C99ArrayReference.Arg :=
  [.pointer name.toList (.literal .u64 0),.pointer "rt3".toList (.literal .u64 0),.scalar (.var "logn".toList),.scalar (.literal .i32 1)]
def withB (s : State) (b : ArrayPointer) := bindPointer (GsMapCall155.dimensions s) "b".toList b
def bound (s : State) (a b : ArrayPointer) := bindPointer (withB s b) "a".toList a

theorem binding (s : State) (name : String) (a b : ArrayPointer)
    (bindingA : s.arrays name.toList=some a) (bindingB : s.arrays "rt3".toList=some b)
    (capacityA : a.index+1536 ≤ a.count) (capacityB : b.index+768 ≤ b.count)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    Bind s GsAutoShape155.function.params (arguments name) (bound s a b) := by
  have addressB : C99ArrayReference.Pointer s "rt3".toList (.literal .u64 0) b :=
    C99PointerNat141.source s _ _ b 0 (by decide) (by omega) bindingB (.literal .uint64 0)
  exact .pointer "a".toList name.toList (.literal .u64 0) a _ _ (withB s b) (GsMapCall155.pointer s name a bindingA capacityA)
    (.pointer "b".toList "rt3".toList (.literal .u64 0) b _ _ (GsMapCall155.dimensions s) addressB
      (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ (GsMapCall155.full s) (.uint32 10)
        (.variable "logn".toList .uint32 (.uint32 10) logn)
        (.scalar .uint32 "full".toList (.literal .i32 1) [] [] (GsMapCall155.empty s) (.int32 1) (.literal .int32 1) .nil)))

theorem source (s : State) (name : String) (a b : ArrayPointer) (input : Fin 1536 → BitVec 64) (multiplier : Fin 768 → BitVec 64)
    (bindingA : s.arrays name.toList=some a) (bindingB : s.arrays "rt3".toList=some b)
    (capacityA : a.index+1536 ≤ a.count) (capacityB : b.index+768 ≤ b.count)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) (width : a.elementBytes=8)
    (writable : s.heap.writable a.block=true) (represented : Represents s.heap a input) (multiplierImage : Represents s.heap b multiplier)
    (separate : ∀ (i : Fin 1536) (j : Fin 768), C99WordRead140.Separate (C99WordBuffer140.element a i) (C99WordBuffer140.element b j)) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program
      (.call "falcon_poly_mul_autoadj_fft3".toList (arguments name) .discard) s ⟨after,.normal⟩ ∧
      Represents after.heap a (image multiplier input) ∧ Represents after.heap b multiplier ∧ FftGroupFrame143.Frame a 1536 s after := by
  obtain ⟨callee,body,image,multiplierImage,frame⟩ := callee (bound s a b) a b input multiplier rfl rfl width capacityA capacityB
    rfl rfl writable represented multiplierImage separate
  let after : State := {s with heap := callee.heap}
  refine ⟨after,?_,image,multiplierImage,⟨rfl,rfl,rfl,rfl,frame.sizes,frame.writable,frame.bytes⟩⟩
  exact .call "falcon_poly_mul_autoadj_fft3".toList (arguments name) .discard GsAutoShape155.function
    s (bound s a b) after ⟨callee,.normal⟩ none GsAutoShape155.source
    (binding s name a b bindingA bindingB capacityA capacityB logn) body .voidEnd (.discard _ none)

theorem separate_symm (p q : ArrayPointer) (h : C99WordRead140.Separate p q) : C99WordRead140.Separate q p := by
  unfold C99WordRead140.Separate at *
  omega

end FT1536.Source3.GsAutoCall155
