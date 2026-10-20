import Source3.KeygenPublicInputLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicInputMaterial
open C99MemoryReference (Memory ArrayPointer Allocated)
open C99ArrayReference (State bindValue)
open C99ProcedureReference (Result)
open KeygenPublicInputLoop (Pointers Layout Fixed Invariant Data)
open KeygenPublicInputCells (Signed Cells TailEmpty)
open KeygenPublicInputProgram (signed initial conversion)
open KeygenPublicExec (Exec)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicAlgebra (R)

def coefficient (v : Geometry.Vec) (i : Nat) : Int :=
  if hi : i<768 then (v ⟨i,hi⟩).1 else
  if hj : i<1536 then (v ⟨i-768,by omega⟩).2 else 0
def reduced (v : Geometry.Vec) (i : Nat) : R := coefficient v i
def Legal (heap : Memory) (p : ArrayPointer) : Prop :=
  p.elementBytes=2 ∧ ∀ i<1536, Allocated heap (KeygenSmallOutput.element p i)

theorem signed_material (heap : Memory) (p : ArrayPointer) (v : Geometry.Vec)
    (legal : Legal heap p) (represented : KeygenMaterial.Represents heap p v)
    (bound : KeygenIntegerLift.Bound v 1) : Signed heap p (coefficient v) := by
  intro i hi
  have stored : KeygenSmallOutput.Stored heap (KeygenSmallOutput.element p i) (BitVec.ofInt 16 (coefficient v i)) := by
    unfold coefficient
    split_ifs with low
    · exact (represented ⟨i,low⟩).1
    · have equal : i-768+768=i := by omega
      simpa only [equal] using (represented ⟨i-768,by omega⟩).2
  have small : -1≤coefficient v i ∧ coefficient v i≤1 := by
    unfold coefficient
    split_ifs with low
    · exact abs_le.mp (bound ⟨i,low⟩).1
    · exact abs_le.mp (bound ⟨i-768,by omega⟩).2
  have read := C99NarrowReads.Load16.load heap (KeygenSmallOutput.element p i)
    (KeygenSmallOutput.byte16 (BitVec.ofInt 16 (coefficient v i))) (legal.2 i hi) legal.1 stored
  rw [KeygenResidueVectors.join_bytes] at read
  refine ⟨_,read,KeygenSmallOutput.narrowed_exact _ (by dsimp [KeygenSmallOutput.accepted]; omega),by omega,by omega⟩

theorem initial_result (s : State) (out : Result) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old))
    (source : Exec KeygenPublicSource.program signed initial s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 0),.normal⟩ := by
  cases source with
  | assign _ _ _ ty previous v slot evaluated =>
      have te := congrArg Prod.fst (Option.some.inj (slot.symm.trans declared))
      dsimp only at te
      subst ty
      have ve := KeygenPublicTableAtoms.literal_value signed s 0 v evaluated
      subst v
      rfl

theorem source_conversion (s : State) (out : Result) (p : Pointers) (f g : Nat → Int)
    (layout : Layout p) (fixed : Fixed p s) (inputF : Signed s.heap p.f f) (inputG : Signed s.heap p.g g)
    (tail : TailEmpty s.heap p.t) (old : Option C99IntegerReference.Value)
    (counter : s.locals "u".toList=some (.uint64,old))
    (source : Exec KeygenPublicSource.program signed conversion s out) :
    out.flow=.normal ∧ Invariant p f g 1536 out.state := by
  obtain ⟨ready,init,loop⟩ := KeygenPublicInputAtoms.seq_inv signed initial KeygenPublicInputProgram.loop s out rfl source
  have state := congrArg Result.state (initial_result s ⟨ready,.normal⟩ old counter init)
  dsimp only at state
  have heap : ready.heap=s.heap := by rw [state]; rfl
  have fixedReady := KeygenPublicInputLoop.fixed_after initial s ⟨ready,.normal⟩ p fixed rfl (by decide) init
  have inv : Invariant p f g 0 ready := by
    refine ⟨⟨by decide,fixedReady,?_,?_,?_,?_,?_⟩,?_⟩
    · rw [heap]; exact inputF
    · rw [heap]; exact inputG
    · intro i hi; omega
    · intro i hi; omega
    · rw [heap]; exact tail
    · rw [state]
      simp only [USlot,bindValue,C99ScalarReference.set,ite_true,KeygenNttLoopSupport.convert_u64_self 0 (by decide)]
  exact KeygenPublicInputLoop.source_loop ready out p f g 0 layout inv loop

theorem source_vectors (s : State) (out : Result) (p : Pointers) (f g : Geometry.Vec)
    (layout : Layout p) (fixed : Fixed p s) (legalF : Legal s.heap p.f) (legalG : Legal s.heap p.g)
    (materialF : KeygenMaterial.Represents s.heap p.f f) (materialG : KeygenMaterial.Represents s.heap p.g g)
    (boundF : KeygenIntegerLift.Bound f 1) (boundG : KeygenIntegerLift.Bound g 1)
    (tail : TailEmpty s.heap p.t) (old : Option C99IntegerReference.Value)
    (counter : s.locals "u".toList=some (.uint64,old))
    (source : Exec KeygenPublicSource.program signed conversion s out) :
    out.flow=.normal ∧ Invariant p (coefficient f) (coefficient g) 1536 out.state :=
  source_conversion s out p _ _ layout fixed (signed_material _ _ f legalF materialF boundF)
    (signed_material _ _ g legalG materialG boundG) tail old counter source

end FT1536.Source3.KeygenPublicInputMaterial
