import Source3.FifthStepExtraPrime217
import Source3.SignedWalkWhole212
import Source3.NttForwardBranch211

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The d=5 signed-store walks and ternary forward call over32 words,
   with the original product march at stride22 and any index u<22. -/
namespace FT1536.Source3.FifthStepExtraSide217
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)
open KeygenNttLoopSupport (u64)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open FifthStepProduct217 (root)
open StepProductFixed203 (Fixed Image)
open FifthStepLayout217 (t1 gm)
open SecondStepGeometry203 (scratch ordered)
open FifthStepGenerator217 (Basic)
open ZintNormWalkFlat208 (Data)
open SignedWalkFixed212 (words)

/- Scratch separation at word granularity. -/
theorem sep_at {a b : Nat} (h : a≠b) : Separate (scratch a) (scratch b) := by
  by_cases lt : a<b
  · exact ordered a b lt
  · exact StepCopyFixed190.separate_symm (ordered b a (by omega))

/- The side walk pointers at the d=5 layout (the shared FirstStep copy
   names "fs"/"gs" point at the d=5 views fs@1374/gs@1758). -/
def croot : Side → ArrayPointer | .f => FifthStepLayout217.fs | .g => FifthStepLayout217.gs

abbrev product_source := FifthStepProduct217.source

/- The signed walk of one side over the 384 reassembled words. -/
def walkCode : Side → KeygenMakeFgSource.Stmt
  | .f => MakeFgAddPrimeShape194.walkFs
  | .g => MakeFgAddPrimeShape194.walkGs

theorem walk_shape (side : Side) : walkCode side=MakeFgAddPrimeShape194.walkF (SecondStepCopy203.name side) := by
  cases side
  · exact MakeFgAddPrimeShape194.walkFs_shape
  · exact MakeFgAddPrimeShape194.walkGs_shape

theorem walk_fixed (side : Side) (s : State) (u : Nat) (p pi r2 rx : BitVec 32) (W : Nat → BitVec 32)
    (h : Basic s u p pi r2) (rxCell : Slot s "Rx" rx) (data : Data s (croot side) 384 W) :
    SignedWalkFixed212.Fixed s (croot side) t1 32 12 W p pi r2 rx := by
  refine ⟨by decide,by decide,h.nCell,h.slenCell,h.pCell,h.iCell,h.r2Cell,rxCell,h.t1Binding,?_,by decide,rfl,h.writable,?_,data,?_⟩
  · cases side <;> decide
  · intro i bound
    exact h.allocated (2206+i) (by omega)
  · intro v i vb ib
    cases side
    · change Separate (⟨31,0,71680,4,2206+v⟩ : ArrayPointer) ⟨31,0,71680,4,1374+i⟩
      exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))
    · change Separate (⟨31,0,71680,4,2206+v⟩ : ArrayPointer) ⟨31,0,71680,4,1758+i⟩
      exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))

theorem walk_source (side : Side) (s : State) (u : Nat) (p pi r2 rx : BitVec 32) (W : Nat → BitVec 32)
    (h : Basic s u p pi r2) (rxCell : Slot s "Rx" rx) (data : Data s (croot side) 384 W)
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (walkCode side) s ⟨out,.normal⟩ ∧ Basic out u p pi r2 ∧ Slot out "Rx" rx ∧
      Cell out "v".toList 32 ∧
      Data out t1 32 (fun v => words W 12 v p pi r2 rx) ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < 32 → Separate (elem t1 i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have binding : s.arrays (SecondStepCopy203.name side).toList=some (croot side) := by
    cases side <;> first | exact h.fsBinding | exact h.gsBinding
  obtain ⟨out,run,_,v,_,image,ls,ars,keep⟩ := SignedWalkWhole212.source (SecondStepCopy203.name side) s
    (croot side) t1 32 12 W p pi r2 rx (walk_fixed side s u p pi r2 rx W h rxCell data)
    old declared binding
  refine ⟨out,by rw [walk_shape]; exact run,FifthStepGenerator217.transport h run ls ars,
    (ls _ (by decide)).trans rxCell,v,image,ls,ars,keep⟩

/- The ter modp_NTT3 forward at Level 4 over the 32 t1 words. -/
theorem forward_source (s : State) (u : Nat) (p pi r2 : BitVec 32) (fv gvs : Fin 32 → BitVec 32)
    (h : Basic s u p pi r2)
    (data : ∀ i, Load32 s.heap (elem t1 i.val) (fv i))
    (gloads : ∀ i, Load32 s.heap (elem gm i.val) (gvs i)) :
    ∃ out, Exec MakeFgAddPrimeShape194.nttBranch s ⟨out,.normal⟩ ∧ Basic out u p pi r2 ∧
      Data out t1 32 (NttForwardWhole211.words 4 fv gvs p pi) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i : Fin 4, MakeFgConversionFrame176.Outside t1 32 q.block (q.offset+i.val)) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have apart (i j : Fin 32) : Word32Memory176.Separate (elem gm i.val) (elem t1 j.val) := by
    change Separate (⟨31,0,71680,4,2142+i.val⟩ : ArrayPointer) ⟨31,0,71680,4,2206+j.val⟩
    exact ordered _ _ (by have b:=i.isLt; have c:=j.isLt; omega)
  obtain ⟨out,_,run,image,ls,ars,keep⟩ := NttForwardCall211.source 4 s t1 gm fv gvs p pi
    h.lognCell h.pCell h.iCell h.t1Binding h.gmBinding rfl (by decide) h.writable apart gloads data
  have branch := NttForwardBranch211.source s out h.terCell run
  exact ⟨out,branch,FifthStepGenerator217.transport h branch (fun name _ => congrFun ls name)
    (fun name _ => congrFun ars name),image,ls,ars,keep⟩

end FT1536.Source3.FifthStepExtraSide217
