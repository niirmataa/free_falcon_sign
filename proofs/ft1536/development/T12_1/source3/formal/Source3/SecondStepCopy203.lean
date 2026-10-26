import Source3.SecondStepBasic203
import Source3.StepCopyAllKeep203
import Source3.MakeFgGsShape194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepCopy203
open C99ArrayReference (State Name bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (u64)
open StepCopyBody190 (addr elem)
open StepCopyFixed203 (Fixed PrefixImage)
open SecondStepLayout197 (fs gs t1)
open SecondStepBasic203 (Basic)

inductive Side where | f | g

def name : Side → String | .f => "fs" | .g => "gs"
def root : Side → ArrayPointer | .f => fs | .g => gs

def initCode (side : Side) : C99ModularReference.Stmt :=
  .seq (.assign "v".toList (.scalar (MakeFgTailShape190.num 0)))
    (.base (.bindPtr "x".toList (name side).toList MakeFgTailShape190.varU))
def initial (side : Side) : KeygenMakeFgSource.Stmt := .level (.modular (initCode side))
def code (side : Side) : KeygenMakeFgSource.Stmt := .seq (initial side) MakeFgTailShape190.copyLoop

theorem f_shape : code .f=MakeFgTailShape190.copyF := rfl
theorem g_shape : code .g=MakeFgTailShape190.s4 := MakeFgGsShape194.s4_shape.symm

def mid (side : Side) (s : State) (u : Nat) :=
  bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "x".toList (addr (root side) u 0 2)

theorem mid_locals (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"v".toList) :
    (mid side s u).locals name=s.locals name := FftLocalCells140.outside s "v".toList name _ different

theorem mid_arrays (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"x".toList) :
    (mid side s u).arrays name=s.arrays name := StepCopyFixed190.bindPointer_arrays _ _ _ _ different

theorem binding (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    s.arrays (name side).toList=some (root side) := by cases side <;> first | exact h.fsBinding | exact h.gsBinding

theorem initial_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<2) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) : Exec (initial side) s ⟨mid side s u,.normal⟩ := by
  have assign : C99ModularReference.Exec (.assign "v".toList (.scalar (MakeFgTailShape190.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have uCell : Cell (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "u".toList u :=
    (FftLocalCells140.outside s "v".toList "u".toList _ (by decide)).trans h.uCell
  have capacity : (root side).index+u ≤ (root side).count := by
    cases side
    · change 1438+u ≤ 71680; omega
    · change 1950+u ≤ 71680; omega
  have address : C99ArrayReference.Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      (name side).toList MakeFgTailShape190.varU (addr (root side) u 0 2) :=
    .add _ _ (root side) _ (u64 u) (binding side s u p p0i r2 h)
      (C99LoopScalar141.read _ _ _ uCell) (by rw [KeygenNttLoopSupport.u64_integer u (by omega)]; omega)
      (by rw [KeygenNttLoopSupport.u64_toNat u (by omega)]; exact .within (root side) u capacity)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ assign (.base _ _ _ (.bindPtr _ _ _ _ _ address))))

theorem fixed (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<2) (fv : Fin 256 → BitVec 32)
    (data : ∀ i, Load32 s.heap (addr (root side) u i.val 2) (fv i)) :
    Fixed (mid side s u) (root side) t1 u 2 256 fv := by
  refine ⟨by decide,by decide,by omega,?_,rfl,?_,by decide,h.writable,?_,?_,?_,?_,?_,?_,data⟩
  · cases side <;> rfl
  · cases side
    · change 1438+u+256*2 ≤ 71680; omega
    · change 1950+u+256*2 ≤ 71680; omega
  · exact (mid_arrays side s u "t1".toList (by decide)).trans h.t1Binding
  · exact (mid_locals side s u "n".toList (by decide)).trans h.nCell
  · exact (mid_locals side s u "slen".toList (by decide)).trans h.slenCell
  · intro i
    exact h.allocated (2974+i.val) (by have a:=i.isLt; omega)
  · intro v i
    cases side
    · change 31≠31 ∨ 0+4*(2974+v.val)+4 ≤ 0+4*(1438+u+i.val*2) ∨
        0+4*(1438+u+i.val*2)+4 ≤ 0+4*(2974+v.val)
      right; right; have a:=v.isLt; have b:=i.isLt; omega
    · change 31≠31 ∨ 0+4*(2974+v.val)+4 ≤ 0+4*(1950+u+i.val*2) ∨
        0+4*(1950+u+i.val*2)+4 ≤ 0+4*(2974+v.val)
      right; right; have a:=v.isLt; have b:=i.isLt; omega
  · intro i j different
    exact StepCopyFixed190.elem_separate t1 rfl i.val j.val (fun equal => different (Fin.ext equal))

theorem source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<2) (fv : Fin 256 → BitVec 32)
    (data : ∀ i, Load32 s.heap (addr (root side) u i.val 2) (fv i))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      Cell out "v".toList 256 ∧ PrefixImage out t1 fv 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Fin 256, Word32Memory176.Separate (elem t1 i.val) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  have init := initial_source side s u p p0i r2 h bound old declared
  obtain ⟨out,loopRun,outFixed,v,x,copied,locals,arrays,keeps⟩ := StepCopyAllKeep203.source
    (mid side s u) (root side) t1 u 2 256 fv (fixed side s u p p0i r2 h bound fv data)
    (FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)) rfl
    (fun _ impossible => absurd impossible (by omega))
  have run : Exec (code side) s ⟨out,.normal⟩ := .seqNormal _ _ s (mid side s u) _ init loopRun
  have loc (name : Name) (different : name≠"v".toList) : out.locals name=s.locals name :=
    (locals name different).trans (mid_locals side s u name different)
  have arr (name : Name) (different : name≠"x".toList) : out.arrays name=s.arrays name :=
    (arrays name different).trans (mid_arrays side s u name different)
  exact ⟨out,run,SecondStepBasic203.transport h run loc arr,v,copied,loc,arr,keeps⟩

def skipped (side : Side) : KeygenMakeFgSource.Stmt := match side with
  | .f => MakeFgTailShape190.s1
  | .g => MakeFgTailShape190.s5

theorem skip_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    Exec (skipped side) s ⟨s,.normal⟩ := by
  have guard : C99ArrayReference.scalar s (.lnot MakeFgTailShape190.inNtt) (.int32 0) :=
    .logicalNot _ (.int32 1) (.variable _ _ _ h.inCell)
  have run : Exec KeygenMakeFgSource.skip s ⟨s,.normal⟩ := SelectedStepAddPrime195.skip_run s
  cases side
  · rw [skipped,MakeFgTailShape190.s1_shape]
    exact .branchFalse _ _ _ s _ (.int32 0) guard rfl run
  · rw [skipped,MakeFgGsShape194.s5_shape]
    exact .branchFalse _ _ _ s _ (.int32 0) guard rfl run

end FT1536.Source3.SecondStepCopy203
