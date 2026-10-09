import Source3.KeygenPublicSuffixAtoms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One actual successful iteration: tested nonzero f value, ternary quotient
   store, all untouched h cells and every f/t cell preserved. -/
namespace FT1536.Source3.KeygenPublicSuffixBody
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicInputProgram (signed index)
open KeygenPublicInputLoop (Pointers Layout Fixed)
open KeygenPublicInputCells (Cell Cells)
open KeygenPublicAlgebra (R)
open KeygenPublicSuffixProgram (test divide body)
open KeygenPublicSuffixAtoms (Failure)
open KeygenPublicForwardWrapper (Ternary)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot)

def image (f g : Nat → R) (i j : Nat) : R := if j < i then g j*(f j)⁻¹ else g j

structure Data (p : Pointers) (f g : Nat → R) (i : Nat) (s : State) : Prop where
  bound : i≤1536
  fixed : Fixed p s
  profile : Slot s "logn" 10
  ternary : Ternary s
  t : Cells s.heap p.t 1536 f
  h : Cells s.heap p.h 1536 (image f g i)
  tested : ∀ j < i, f j≠0
structure Inv (p : Pointers) (f g : Nat → R) (i : Nat) (s : State) : Prop extends Data p f g i s where
  counter : USlot s "u" i

theorem normal_seq (a b : Stmt) (s after : State)
    (source : Exec KeygenPublicSource.program signed (.seq a b) s ⟨after,.normal⟩) :
    ∃ middle, Exec KeygenPublicSource.program signed a s ⟨middle,.normal⟩ ∧
      Exec KeygenPublicSource.program signed b middle ⟨after,.normal⟩ := by
  cases source with
  | seqNormal _ _ _ middle _ first last => exact ⟨middle,first,last⟩
  | seqExit _ _ _ _ first exit => exact (exit rfl).elim

theorem body_flow (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program signed body s out) : out.flow=.normal ∨ out.flow=Failure := by
  cases source with
  | scope _ _ _ _ inner executed =>
      cases executed with
      | seqNormal _ _ _ middle _ first last =>
          exact Or.inl (KeygenPublicTableControl.frame _ signed _ middle inner (by decide) last).1
      | seqExit _ _ _ _ first exit =>
          exact Or.inr ((KeygenPublicSuffixAtoms.test_flow s inner first).resolve_left exit)

theorem division_store (s : State) (out : Result) (p : Pointers) (i : Nat) (x y : R) (hi : i<1536)
    (fixed : Fixed p s) (counter : USlot s "u" i) (ternary : Ternary s)
    (hCell : Cell s.heap p.h i x) (tCell : Cell s.heap p.t i y) (nonzero : y≠0)
    (source : Exec KeygenPublicSource.program signed divide s out) :
    Cell out.state.heap p.h i (x*y⁻¹) ∧
      ∃ w, KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element p.h i) w out.state.heap := by
  cases source with
  | branchTrue _ _ _ _ _ v guard active inner =>
      cases inner with
      | store _ _ _ _ before heap actual result address evaluated write =>
          rw [KeygenPublicInputAtoms.index_address s "h" p.h actual i (by omega) fixed.h counter address] at write
          obtain ⟨w,eq,range,value⟩ := KeygenPublicSuffixAtoms.quotient_value s p.h p.t i x y hi fixed.h fixed.t counter hCell tCell nonzero result evaluated
          subst result
          exact ⟨KeygenPublicInputCells.written _ _ p.h i w _ range value write,_,write⟩
  | branchFalse _ _ _ _ _ v guard zero inner =>
      rw [KeygenPublicInputSetup.ternary_value s v ternary guard] at zero
      contradiction

theorem body_data (s : State) (out : Result) (p : Pointers) (f g : Nat → R) (i : Nat) (hi : i<1536)
    (layout : Layout p) (inv : Inv p f g i s)
    (normal : out.flow=.normal) (source : Exec KeygenPublicSource.program signed body s out) :
    Data p f g (i+1) out.state ∧ USlot out.state "u" i := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rcases inner with ⟨after,flow⟩
      change flow=.normal at normal
      subst flow
      rw [KeygenPublicForwardCall.restore_empty]
      obtain ⟨middle,testExec,rest⟩ := normal_seq test _ s after executed
      obtain ⟨same,nonzero⟩ := KeygenPublicSuffixAtoms.test_normal s middle p.t i (f i) hi inv.fixed.t inv.counter (inv.t i hi) testExec
      subst middle
      obtain ⟨last,division,done⟩ := normal_seq divide .skip s after rest
      cases done
      have current : Cell s.heap p.h i (g i) := by simpa only [image,lt_self_iff_false,ite_false] using inv.h i hi
      obtain ⟨newCell,w,write⟩ := division_store s ⟨after,.normal⟩ p i (g i) (f i) hi inv.fixed inv.counter inv.ternary current (inv.t i hi) nonzero division
      have frame := KeygenPublicTableControl.frame _ signed divide s ⟨after,.normal⟩ (by decide) division
      have locals : after.locals=s.locals := funext fun n => frame.2.2 n (by
        rw [KeygenPublicSuffixProgram.division_writes]; exact List.not_mem_nil)
      have fixed : Fixed p after := by
        refine ⟨by rw [frame.2.1]; exact inv.fixed.f,by rw [frame.2.1]; exact inv.fixed.g,
          by rw [frame.2.1]; exact inv.fixed.t,by rw [frame.2.1]; exact inv.fixed.h,?_,?_⟩
        · unfold USlot; rw [locals]; exact inv.fixed.n
        · unfold Slot; rw [locals]; exact inv.fixed.q
      refine ⟨⟨by omega,fixed,?_,?_,?_,?_,?_⟩,?_⟩
      · unfold Slot; rw [locals]; exact inv.profile
      · unfold Ternary; rw [locals]; exact inv.ternary
      · intro j hj
        exact KeygenPublicInputCells.other_block _ _ p.h p.t i j w _ (Ne.symm layout.different) write (inv.t j hj)
      · intro j hj
        by_cases same : j=i
        · subst j; simpa only [image,Nat.lt_succ_self,ite_true] using newCell
        · have cell := KeygenPublicInputCells.preserves _ _ p.h layout.hw i j (Ne.symm same) w _ write (inv.h j hj)
          have equal : image f g i j=image f g (i+1) j := by
            unfold image
            have compare : j < i ↔ j < i+1 := by omega
            simp only [compare]
          rwa [equal] at cell
      · intro j hj
        by_cases same : j=i
        · subst j; exact nonzero
        · exact inv.tested j (by omega)
      · unfold USlot; rw [locals]; exact inv.counter

end FT1536.Source3.KeygenPublicSuffixBody
