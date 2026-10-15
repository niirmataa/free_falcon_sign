import Source3.C99FourWordBuffer140
import Source3.FftButterflyClosed140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftButterflyBuffer140
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (element Represents)

def operands {n : Nat} (v : Fin n → BitVec 64) (slots : Fin 4 → Fin n) : FftMulStates140.Words :=
  ⟨v (slots 0),v (slots 1),v (slots 2),v (slots 3)⟩

def nextValues {n : Nat} (v : Fin n → BitVec 64) (slots : Fin 4 → Fin n) (sr si : BitVec 64) : Fin n → BitVec 64 :=
  C99FourWordBuffer140.values v slots (FftButterflyStates140.resultWords (operands v slots) sr si)

def nextState {n : Nat} (before : State) (base : ArrayPointer) (v : Fin n → BitVec 64)
    (slots : Fin 4 → Fin n) (sr si : BitVec 64) : State :=
  FftButterflyStates140.output before (operands v slots) (fun i => element base (slots i)) sr si

theorem entry {n : Nat} (before : State) (base : ArrayPointer) (v : Fin n → BitVec 64)
    (slots : Fin 4 → Fin n) (sr si : BitVec 64)
    (represented : Represents before.heap base v) (writable : before.heap.writable base.block=true)
    (addresses : ∀ i, C99ArrayReference.Pointer before "a".toList (FftLoadShape140.index i) (element base (slots i)))
    (realCell : before.locals "sr".toList=some (.uint64,some (.uint64 sr)))
    (imagCell : before.locals "si".toList=some (.uint64,some (.uint64 si))) :
    FftLoadExec140.Entry before (operands v slots) (fun i => element base (slots i)) sr si := by
  refine ⟨addresses,?_,fun _ => writable,realCell,imagCell⟩
  intro i
  fin_cases i
  · exact represented (slots 0)
  · exact represented (slots 1)
  · exact represented (slots 2)
  · exact represented (slots 3)

/-- A single parametric butterfly preserves the full symbolic word-buffer
    invariant. The caller must derive its actual source index judgments. -/
theorem source_and_invariant {n : Nat} (before : State) (base : ArrayPointer) (v : Fin n → BitVec 64)
    (slots : Fin 4 → Fin n) (sr si : BitVec 64)
    (represented : Represents before.heap base v) (width : base.elementBytes=8)
    (writable : before.heap.writable base.block=true)
    (addresses : ∀ i, C99ArrayReference.Pointer before "a".toList (FftLoadShape140.index i) (element base (slots i)))
    (realCell : before.locals "sr".toList=some (.uint64,some (.uint64 sr)))
    (imagCell : before.locals "si".toList=some (.uint64,some (.uint64 si))) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyBody before
      ⟨nextState before base v slots sr si,.normal⟩ ∧
    Represents (nextState before base v slots sr si).heap base (nextValues v slots sr si) :=
  ⟨FftButterflyClosed140.source before (operands v slots) (fun i => element base (slots i)) sr si
      (entry before base v slots sr si represented writable addresses realCell imagCell),
   C99FourWordBuffer140.preserves before.heap base v represented width writable slots
      (FftButterflyStates140.resultWords (operands v slots) sr si)⟩

theorem locals_same {n : Nat} (before : State) (base : ArrayPointer) (v : Fin n → BitVec 64)
    (slots : Fin 4 → Fin n) (sr si : BitVec 64) : (nextState before base v slots sr si).locals=before.locals := rfl

theorem metadata_same {n : Nat} (before : State) (base : ArrayPointer) (v : Fin n → BitVec 64)
    (slots : Fin 4 → Fin n) (sr si : BitVec 64) :
    (nextState before base v slots sr si).heap.size=before.heap.size ∧
    (nextState before base v slots sr si).heap.writable=before.heap.writable := ⟨rfl,rfl⟩

end FT1536.Source3.FftButterflyBuffer140
