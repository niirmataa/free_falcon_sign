import Source3.ThirdStepExtraPrime215
import Source3.SignedWalkWhole212
import Source3.NttForwardBranch211

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The d=3 additional-prime side layer: the three engines one part-4
   iteration runs per side — the zint_mod_small_signed walk over the
   reassembled fs/gs rows at slen = 3 (128 words), the taken ter
   modp_NTT3 forward at Level 6 (logn 7, 128 words), and the
   Montgomery product march into the fd/gd column u at tlen = 6 /
   hn = 64. The product march is the same source shape as the first
   loop's, re-instantiated for the additional loop indices u < 6 (the
   ThirdStepProduct215 instance pinned u < 3). Executed words only;
   no Montgomery/NTT/table law is claimed. -/
namespace FT1536.Source3.ThirdStepExtraSide215
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)
open KeygenNttLoopSupport (u64)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (root)
open StepProductFixed203 (Fixed Image)
open ThirdStepLayout215 (t1 gm)
open SecondStepGeometry203 (scratch ordered)
open ThirdStepGenerator215 (Basic)
open ZintNormWalkFlat208 (Data)
open SignedWalkFixed212 (words)

/- Scratch separation at word granularity. -/
theorem sep_at {a b : Nat} (h : a≠b) : Separate (scratch a) (scratch b) := by
  by_cases lt : a<b
  · exact ordered a b lt
  · exact StepCopyFixed190.separate_symm (ordered b a (by omega))

/- The side walk pointers at the d=3 layout (the shared FirstStep copy
   names "fs"/"gs" point at the d=3 views fs@1438/gs@1822). -/
def croot : Side → ArrayPointer | .f => ThirdStepLayout215.fs | .g => ThirdStepLayout215.gs

/- One product march at any additional loop index u < 6. -/
theorem product_initial (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<6) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) :
    Exec (SecondStepProduct203.initial side) s ⟨ThirdStepProduct215.mid side s u,.normal⟩ := by
  have assign : C99ModularReference.Exec (.assign "v".toList (.scalar (MakeFgTailShape190.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have uCell : Cell (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "u".toList u :=
    (FftLocalCells140.outside s "v".toList "u".toList _ (by decide)).trans h.uCell
  have capacity : (root side).index+u ≤ (root side).count := by
    cases side
    · change 670+u ≤ 71680; omega
    · change 1054+u ≤ 71680; omega
  have address : C99ArrayReference.Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      (SecondStepProduct203.name side).toList MakeFgTailShape190.varU (addr (root side) u 0 6) :=
    .add _ _ (root side) _ (u64 u) (ThirdStepProduct215.binding side s u p p0i r2 h)
      (C99LoopScalar141.read _ _ _ uCell) (by rw [KeygenNttLoopSupport.u64_integer u (by omega)]; omega)
      (by rw [KeygenNttLoopSupport.u64_toNat u (by omega)]; exact .within (root side) u capacity)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ assign (.base _ _ _ (.bindPtr _ _ _ _ _ address))))

theorem product_fixed (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<6) (fv : Nat → BitVec 32)
    (data : ∀ i : Fin 128, Load32 s.heap (elem t1 i.val) (fv i.val)) :
    Fixed (ThirdStepProduct215.mid side s u) (root side) t1 u 6 64 p p0i r2 fv := by
  refine ⟨by decide,by decide,by decide,by omega,?_,?_,(by cases side <;> exact h.writable),?_,?_,?_,?_,?_,?_,?_,?_,?_,data⟩
  · cases side <;> rfl
  · cases side
    · change 670+u+64*6 ≤ 71680; omega
    · change 1054+u+64*6 ≤ 71680; omega
  · exact (ThirdStepProduct215.mid_arrays side s u "t1".toList (by decide)).trans h.t1Binding
  · exact (ThirdStepProduct215.mid_locals side s u "hn".toList (by decide)).trans h.hnCell
  · exact (ThirdStepProduct215.mid_locals side s u "tlen".toList (by decide)).trans h.tlenCell
  · exact (ThirdStepProduct215.mid_locals side s u "p".toList (by decide)).trans h.pCell
  · exact (ThirdStepProduct215.mid_locals side s u "p0i".toList (by decide)).trans h.iCell
  · exact (ThirdStepProduct215.mid_locals side s u "R2".toList (by decide)).trans h.r2Cell
  · intro i
    cases side
    · exact h.allocated (670+u+i.val*6) (by have b:=i.isLt; omega)
    · exact h.allocated (1054+u+i.val*6) (by have b:=i.isLt; omega)
  · intro i j
    cases side
    · change 31≠31 ∨ 0+4*(670+u+i.val*6)+4 ≤ 0+4*(2462+j.val) ∨
        0+4*(2462+j.val)+4 ≤ 0+4*(670+u+i.val*6)
      right; left; have a:=i.isLt; have b:=j.isLt; omega
    · change 31≠31 ∨ 0+4*(1054+u+i.val*6)+4 ≤ 0+4*(2462+j.val) ∨
        0+4*(2462+j.val)+4 ≤ 0+4*(1054+u+i.val*6)
      right; left; have a:=i.isLt; have b:=j.isLt; omega
  · intro i j different
    have ne : i.val≠j.val := fun equal => different (Fin.ext equal)
    cases side
    · change 31≠31 ∨ 0+4*(670+u+i.val*6)+4 ≤ 0+4*(670+u+j.val*6) ∨
        0+4*(670+u+j.val*6)+4 ≤ 0+4*(670+u+i.val*6)
      omega
    · change 31≠31 ∨ 0+4*(1054+u+i.val*6)+4 ≤ 0+4*(1054+u+j.val*6) ∨
        0+4*(1054+u+j.val*6)+4 ≤ 0+4*(1054+u+i.val*6)
      omega

theorem product_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<6) (fv : Nat → BitVec 32)
    (data : ∀ i : Fin 128, Load32 s.heap (elem t1 i.val) (fv i.val))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (SecondStepProduct203.code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      Cell out "v".toList 64 ∧ Image out (root side) u 6 64 p p0i r2 fv 64 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Fin 64, Separate (addr (root side) u i.val 6) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  have init := product_initial side s u p p0i r2 h bound old declared
  obtain ⟨out,loopRun,outFixed,v,x,image,locals,arrays,keeps⟩ := StepProductAllKeep203.source
    (ThirdStepProduct215.mid side s u) (root side) t1 u 6 64 p p0i r2 fv
    (product_fixed side s u p p0i r2 h bound fv data)
    (FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)) rfl
    (fun _ impossible => absurd impossible (by omega))
  have run : Exec (SecondStepProduct203.code side) s ⟨out,.normal⟩ :=
    .seqNormal _ _ s (ThirdStepProduct215.mid side s u) _ init loopRun
  have loc (name : Name) (different : name≠"v".toList) : out.locals name=s.locals name :=
    (locals name different).trans (ThirdStepProduct215.mid_locals side s u name different)
  have arr (name : Name) (different : name≠"x".toList) : out.arrays name=s.arrays name :=
    (arrays name different).trans (ThirdStepProduct215.mid_arrays side s u name different)
  exact ⟨out,run,ThirdStepGenerator215.transport h run loc arr,v,image,loc,arr,keeps⟩

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
    SignedWalkFixed212.Fixed s (croot side) t1 128 3 W p pi r2 rx := by
  refine ⟨by decide,by decide,h.nCell,h.slenCell,h.pCell,h.iCell,h.r2Cell,rxCell,h.t1Binding,?_,by decide,rfl,h.writable,?_,data,?_⟩
  · cases side <;> decide
  · intro i bound
    exact h.allocated (2462+i) (by omega)
  · intro v i vb ib
    cases side
    · change Separate (⟨31,0,71680,4,2462+v⟩ : ArrayPointer) ⟨31,0,71680,4,1438+i⟩
      exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))
    · change Separate (⟨31,0,71680,4,2462+v⟩ : ArrayPointer) ⟨31,0,71680,4,1822+i⟩
      exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))

theorem walk_source (side : Side) (s : State) (u : Nat) (p pi r2 rx : BitVec 32) (W : Nat → BitVec 32)
    (h : Basic s u p pi r2) (rxCell : Slot s "Rx" rx) (data : Data s (croot side) 384 W)
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (walkCode side) s ⟨out,.normal⟩ ∧ Basic out u p pi r2 ∧ Slot out "Rx" rx ∧
      Cell out "v".toList 128 ∧
      Data out t1 128 (fun v => words W 3 v p pi r2 rx) ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < 128 → Separate (elem t1 i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have binding : s.arrays (SecondStepCopy203.name side).toList=some (croot side) := by
    cases side <;> first | exact h.fsBinding | exact h.gsBinding
  obtain ⟨out,run,_,v,_,image,ls,ars,keep⟩ := SignedWalkWhole212.source (SecondStepCopy203.name side) s
    (croot side) t1 128 3 W p pi r2 rx (walk_fixed side s u p pi r2 rx W h rxCell data)
    old declared binding
  refine ⟨out,by rw [walk_shape]; exact run,ThirdStepGenerator215.transport h run ls ars,
    (ls _ (by decide)).trans rxCell,v,image,ls,ars,keep⟩

/- The ter modp_NTT3 forward at Level 6 over the 128 t1 words. -/
theorem forward_source (s : State) (u : Nat) (p pi r2 : BitVec 32) (fv gvs : Fin 128 → BitVec 32)
    (h : Basic s u p pi r2)
    (data : ∀ i, Load32 s.heap (elem t1 i.val) (fv i))
    (gloads : ∀ i, Load32 s.heap (elem gm i.val) (gvs i)) :
    ∃ out, Exec MakeFgAddPrimeShape194.nttBranch s ⟨out,.normal⟩ ∧ Basic out u p pi r2 ∧
      Data out t1 128 (NttForwardWhole211.words 6 fv gvs p pi) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i : Fin 4, MakeFgConversionFrame176.Outside t1 128 q.block (q.offset+i.val)) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have apart (i j : Fin 128) : Word32Memory176.Separate (elem gm i.val) (elem t1 j.val) := by
    change Separate (⟨31,0,71680,4,2206+i.val⟩ : ArrayPointer) ⟨31,0,71680,4,2462+j.val⟩
    exact ordered _ _ (by have b:=i.isLt; have c:=j.isLt; omega)
  obtain ⟨out,_,run,image,ls,ars,keep⟩ := NttForwardCall211.source 6 s t1 gm fv gvs p pi
    h.lognCell h.pCell h.iCell h.t1Binding h.gmBinding rfl (by decide) h.writable apart gloads data
  have branch := NttForwardBranch211.source s out h.terCell run
  exact ⟨out,branch,ThirdStepGenerator215.transport h branch (fun name _ => congrFun ls name)
    (fun name _ => congrFun ars name),image,ls,ars,keep⟩

end FT1536.Source3.ThirdStepExtraSide215
