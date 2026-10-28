import Source3.EighthStepGeometry217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d8 copy layer of the original first-prime source loop. -/
namespace FT1536.Source3.EighthStepMarch217
open C99ArrayReference (State Name bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open StepCopyFixed203 (PrefixImage)
open StepProductFixed203 (Image)
open EighthStepLayout217 (fd gd fs gs gm igm t1)
open EighthStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open EighthStepProduct217 (root)

/- The copy marches: x = fs/gs + u over n = 4 words into t1. -/
def midC (side : Side) (s : State) (u : Nat) :=
  bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "x".toList (addr (croot side) u 0 82)

theorem midC_locals (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"v".toList) :
    (midC side s u).locals name=s.locals name := FftLocalCells140.outside s "v".toList name _ different

theorem midC_arrays (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"x".toList) :
    (midC side s u).arrays name=s.arrays name := StepCopyFixed190.bindPointer_arrays _ _ _ _ different

theorem bindingC (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    s.arrays (SecondStepCopy203.name side).toList=some (croot side) := by
  cases side <;> first | exact h.fsBinding | exact h.gsBinding

theorem initialC_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<82) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) :
    Exec (SecondStepCopy203.initial side) s ⟨midC side s u,.normal⟩ := by
  have assign : C99ModularReference.Exec (.assign "v".toList (.scalar (MakeFgTailShape190.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have uCell : Cell (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "u".toList u :=
    (FftLocalCells140.outside s "v".toList "u".toList _ (by decide)).trans h.uCell
  have capacity : (croot side).index+u ≤ (croot side).count := by
    cases side
    · change 1334+u ≤ 71680; omega
    · change 1662+u ≤ 71680; omega
  have address : C99ArrayReference.Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      (SecondStepCopy203.name side).toList MakeFgTailShape190.varU (addr (croot side) u 0 82) :=
    .add _ _ (croot side) _ (u64 u) (bindingC side s u p p0i r2 h)
      (C99LoopScalar141.read _ _ _ uCell) (by rw [KeygenNttLoopSupport.u64_integer u (by omega)]; omega)
      (by rw [KeygenNttLoopSupport.u64_toNat u (by omega)]; exact .within (croot side) u capacity)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ assign (.base _ _ _ (.bindPtr _ _ _ _ _ address))))

theorem fixedC (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<82) (fv : Fin 4 → BitVec 32)
    (data : ∀ i, Load32 s.heap (addr (croot side) u i.val 82) (fv i)) :
    StepCopyFixed203.Fixed (midC side s u) (croot side) t1 u 82 4 fv := by
  refine ⟨by decide,by decide,by omega,?_,rfl,?_,by decide,h.writable,?_,?_,?_,?_,?_,?_,data⟩
  · cases side <;> rfl
  · cases side
    · change 1334+u+4*82 ≤ 71680; omega
    · change 1662+u+4*82 ≤ 71680; omega
  · exact (midC_arrays side s u "t1".toList (by decide)).trans h.t1Binding
  · exact (midC_locals side s u "n".toList (by decide)).trans h.nCell
  · exact (midC_locals side s u "slen".toList (by decide)).trans h.slenCell
  · intro i
    exact h.allocated (1998+i.val) (by have a:=i.isLt; omega)
  · intro v i
    cases side
    · change 31≠31 ∨ 0+4*(1998+v.val)+4 ≤ 0+4*(1334+u+i.val*82) ∨
        0+4*(1334+u+i.val*82)+4 ≤ 0+4*(1998+v.val)
      right; right; have a:=v.isLt; have b:=i.isLt; omega
    · change 31≠31 ∨ 0+4*(1998+v.val)+4 ≤ 0+4*(1662+u+i.val*82) ∨
        0+4*(1662+u+i.val*82)+4 ≤ 0+4*(1998+v.val)
      right; right; have a:=v.isLt; have b:=i.isLt; omega
  · intro i j different
    exact StepCopyFixed190.elem_separate t1 rfl i.val j.val (fun equal => different (Fin.ext equal))

theorem sourceC (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<82) (fv : Fin 4 → BitVec 32)
    (data : ∀ i, Load32 s.heap (addr (croot side) u i.val 82) (fv i))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (SecondStepCopy203.code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      Cell out "v".toList 4 ∧ PrefixImage out t1 fv 4 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Fin 4, Separate (elem t1 i.val) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  have init := initialC_source side s u p p0i r2 h bound old declared
  obtain ⟨out,loopRun,outFixed,v,x,copied,locals,arrays,keeps⟩ := StepCopyAllKeep203.source
    (midC side s u) (croot side) t1 u 82 4 fv (fixedC side s u p p0i r2 h bound fv data)
    (FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)) rfl
    (fun _ impossible => absurd impossible (by omega))
  have run : Exec (SecondStepCopy203.code side) s ⟨out,.normal⟩ := .seqNormal _ _ s (midC side s u) _ init loopRun
  have loc (name : Name) (different : name≠"v".toList) : out.locals name=s.locals name :=
    (locals name different).trans (midC_locals side s u name different)
  have arr (name : Name) (different : name≠"x".toList) : out.arrays name=s.arrays name :=
    (arrays name different).trans (midC_arrays side s u name different)
  exact ⟨out,run,EighthStepGenerator217.transport h run loc arr,v,copied,loc,arr,keeps⟩

theorem skipC_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    Exec (SecondStepCopy203.skipped side) s ⟨s,.normal⟩ := by
  have guard : C99ArrayReference.scalar s (.lnot MakeFgTailShape190.inNtt) (.int32 0) :=
    .logicalNot _ (.int32 1) (.variable _ _ _ h.inCell)
  have run : Exec KeygenMakeFgSource.skip s ⟨s,.normal⟩ := SelectedStepAddPrime195.skip_run s
  cases side
  · rw [SecondStepCopy203.skipped,MakeFgTailShape190.s1_shape]
    exact .branchFalse _ _ _ s _ (.int32 0) guard rfl run
  · rw [SecondStepCopy203.skipped,MakeFgGsShape194.s5_shape]
    exact .branchFalse _ _ _ s _ (.int32 0) guard rfl run


end FT1536.Source3.EighthStepMarch217
