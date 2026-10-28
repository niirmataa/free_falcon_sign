import Source3.SeventhStepGenerator217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The d=7 Montgomery product marches (the iloczyny layer of the body):
   the original fd/gd pair-product loops `for (v = 0, x = fd + u; v < hn;
   v ++, x += tlen)` at the d=7 geometry — tlen = 82, hn = 4, the 8
   t1 words — for any loop index u < 82 and any current row words. The
   march writes the exact nested montymul words of the two source loads
   per step; the images are executed words, no Montgomery/NTT/table law
   is claimed. The same layer serves the additional-prime loop. -/
namespace FT1536.Source3.SeventhStepProduct217
open C99ArrayReference (State Name bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (u64)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (name)
open SeventhStepLayout217 (fd gd)
open StepProductFixed203 (Fixed Image)
open SeventhStepLayout217 (t1)
open SeventhStepGenerator217 (Basic)

def root : Side → ArrayPointer | .f => fd | .g => gd

def mid (side : Side) (s : State) (u : Nat) :=
  bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "x".toList (addr (root side) u 0 82)

theorem mid_locals (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"v".toList) :
    (mid side s u).locals name=s.locals name := FftLocalCells140.outside s "v".toList name _ different

theorem mid_arrays (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"x".toList) :
    (mid side s u).arrays name=s.arrays name := StepCopyFixed190.bindPointer_arrays _ _ _ _ different

theorem binding (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    s.arrays (name side).toList=some (root side) := by cases side <;> first | exact h.fdBinding | exact h.gdBinding

theorem initial_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<82) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) : Exec (SecondStepProduct203.initial side) s ⟨mid side s u,.normal⟩ := by
  have assign : C99ModularReference.Exec (.assign "v".toList (.scalar (MakeFgTailShape190.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have uCell : Cell (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "u".toList u :=
    (FftLocalCells140.outside s "v".toList "u".toList _ (by decide)).trans h.uCell
  have capacity : (root side).index+u ≤ (root side).count := by
    cases side
    · change 670+u ≤ 71680; omega
    · change 998+u ≤ 71680; omega
  have address : C99ArrayReference.Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      (name side).toList MakeFgTailShape190.varU (addr (root side) u 0 82) :=
    .add _ _ (root side) _ (u64 u) (binding side s u p p0i r2 h)
      (C99LoopScalar141.read _ _ _ uCell) (by rw [KeygenNttLoopSupport.u64_integer u (by omega)]; omega)
      (by rw [KeygenNttLoopSupport.u64_toNat u (by omega)]; exact .within (root side) u capacity)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ assign (.base _ _ _ (.bindPtr _ _ _ _ _ address))))

theorem fixed (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<82) (fv : Nat → BitVec 32)
    (data : ∀ i : Fin 8, Load32 s.heap (elem t1 i.val) (fv i.val)) :
    Fixed (mid side s u) (root side) t1 u 82 4 p p0i r2 fv := by
  refine ⟨by decide,by decide,by decide,by omega,?_,?_,(by cases side <;> exact h.writable),?_,?_,?_,?_,?_,?_,?_,?_,?_,data⟩
  · cases side <;> rfl
  · cases side
    · change 670+u+4*82 ≤ 71680; omega
    · change 998+u+4*82 ≤ 71680; omega
  · exact (mid_arrays side s u "t1".toList (by decide)).trans h.t1Binding
  · exact (mid_locals side s u "hn".toList (by decide)).trans h.hnCell
  · exact (mid_locals side s u "tlen".toList (by decide)).trans h.tlenCell
  · exact (mid_locals side s u "p".toList (by decide)).trans h.pCell
  · exact (mid_locals side s u "p0i".toList (by decide)).trans h.iCell
  · exact (mid_locals side s u "R2".toList (by decide)).trans h.r2Cell
  · intro i
    cases side
    · exact h.allocated (670+u+i.val*82) (by have b:=i.isLt; omega)
    · exact h.allocated (998+u+i.val*82) (by have b:=i.isLt; omega)
  · intro i j
    cases side
    · change 31≠31 ∨ 0+4*(670+u+i.val*82)+4 ≤ 0+4*(2014+j.val) ∨
        0+4*(2014+j.val)+4 ≤ 0+4*(670+u+i.val*82)
      right; left; have a:=i.isLt; have b:=j.isLt; omega
    · change 31≠31 ∨ 0+4*(998+u+i.val*82)+4 ≤ 0+4*(2014+j.val) ∨
        0+4*(2014+j.val)+4 ≤ 0+4*(998+u+i.val*82)
      right; left; have a:=i.isLt; have b:=j.isLt; omega
  · intro i j different
    have ne : i.val≠j.val := fun equal => different (Fin.ext equal)
    cases side
    · change 31≠31 ∨ 0+4*(670+u+i.val*82)+4 ≤ 0+4*(670+u+j.val*82) ∨
        0+4*(670+u+j.val*82)+4 ≤ 0+4*(670+u+i.val*82)
      omega
    · change 31≠31 ∨ 0+4*(998+u+i.val*82)+4 ≤ 0+4*(998+u+j.val*82) ∨
        0+4*(998+u+j.val*82)+4 ≤ 0+4*(998+u+i.val*82)
      omega

theorem source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<82) (fv : Nat → BitVec 32)
    (data : ∀ i : Fin 8, Load32 s.heap (elem t1 i.val) (fv i.val))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (SecondStepProduct203.code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      Cell out "v".toList 4 ∧ Image out (root side) u 82 4 p p0i r2 fv 4 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Fin 4, Separate (addr (root side) u i.val 82) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  have init := initial_source side s u p p0i r2 h bound old declared
  obtain ⟨out,loopRun,outFixed,v,x,image,locals,arrays,keeps⟩ := StepProductAllKeep203.source
    (mid side s u) (root side) t1 u 82 4 p p0i r2 fv (fixed side s u p p0i r2 h bound fv data)
    (FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)) rfl
    (fun _ impossible => absurd impossible (by omega))
  have run : Exec (SecondStepProduct203.code side) s ⟨out,.normal⟩ := .seqNormal _ _ s (mid side s u) _ init loopRun
  have loc (name : Name) (different : name≠"v".toList) : out.locals name=s.locals name :=
    (locals name different).trans (mid_locals side s u name different)
  have arr (name : Name) (different : name≠"x".toList) : out.arrays name=s.arrays name :=
    (arrays name different).trans (mid_arrays side s u name different)
  exact ⟨out,run,SeventhStepGenerator217.transport h run loc arr,v,image,loc,arr,keeps⟩

end FT1536.Source3.SeventhStepProduct217
