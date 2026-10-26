import Source3.SignedWalkWhole212
import Source3.SecondExtraProduct212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraWalk212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open SecondStepBasic203 (Basic)
open SecondStepCopy203 (Side name root)
open SecondStepLayout197 (t1)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintNormWalkFlat208 (Data)

def code : Side → KeygenMakeFgSource.Stmt
  | .f => MakeFgAddPrimeShape194.walkFs
  | .g => MakeFgAddPrimeShape194.walkGs

theorem shape (side : Side) : code side=MakeFgAddPrimeShape194.walkF (name side) := by
  cases side
  · exact MakeFgAddPrimeShape194.walkFs_shape
  · exact MakeFgAddPrimeShape194.walkGs_shape

theorem fixed (side : Side) (s : State) (p pi r2 rx : BitVec 32) (W : Nat → BitVec 32)
    (h : Basic s 2 p pi r2) (rxCell : Slot s "Rx" rx) (data : Data s (root side) 512 W) :
    SignedWalkFixed212.Fixed s (root side) t1 256 2 W p pi r2 rx := by
  refine ⟨by decide,by decide,h.nCell,h.slenCell,h.pCell,h.iCell,h.r2Cell,rxCell,h.t1Binding,?_,by decide,rfl,h.writable,?_,data,?_⟩
  · cases side <;> decide
  · intro i bound
    exact h.allocated (2974+i) (by omega)
  · intro v i vb ib
    cases side
    · change Separate (⟨31,0,71680,4,2974+v⟩ : ArrayPointer) ⟨31,0,71680,4,1438+i⟩
      exact StepCopyFixed190.separate_symm (SecondStepGeometry203.ordered _ _ (by omega))
    · change Separate (⟨31,0,71680,4,2974+v⟩ : ArrayPointer) ⟨31,0,71680,4,1950+i⟩
      exact StepCopyFixed190.separate_symm (SecondStepGeometry203.ordered _ _ (by omega))

theorem source (side : Side) (s : State) (p pi r2 rx : BitVec 32) (W : Nat → BitVec 32)
    (h : Basic s 2 p pi r2) (rxCell : Slot s "Rx" rx) (data : Data s (root side) 512 W)
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (code side) s ⟨out,.normal⟩ ∧ Basic out 2 p pi r2 ∧ Slot out "Rx" rx ∧
      Cell out "v".toList 256 ∧
      Data out t1 256 (fun v => SignedWalkFixed212.words W 2 v p pi r2 rx) ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < 256 → Separate (elem t1 i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have binding : s.arrays (name side).toList=some (root side) := by
    cases side <;> first | exact h.fsBinding | exact h.gsBinding
  obtain ⟨out,run,_,v,_,image,ls,ars,keep⟩:=SignedWalkWhole212.source (name side) s (root side) t1 256 2 W p pi r2 rx
    (fixed side s p pi r2 rx W h rxCell data) old declared binding
  refine ⟨out,by rw [shape]; exact run,SecondStepBasic203.transport h run ls ars,(ls _ (by decide)).trans rxCell,
    v,image,ls,ars,keep⟩

end FT1536.Source3.SecondExtraWalk212
