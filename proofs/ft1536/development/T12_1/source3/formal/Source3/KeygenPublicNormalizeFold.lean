import Source3.KeygenPublicNormalizeAtoms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete1536-store normalization fold, with explicit ordinary values
   and preservation of every not-yet-written or already-written cell. -/
namespace FT1536.Source3.KeygenPublicNormalizeFold
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R radix)
open KeygenPublicValueExpr (Local)
open KeygenPublicInputCells (Cell Cells)
open KeygenNttLoopSupport (USlot)
open KeygenPublicNormalizeProgram (body loop increment)

def image (a : Nat → R) (z : R) (k j : Nat) : R := if j<k then a j*z else a j
theorem image_zero (a : Nat → R) (z : R) (j : Nat) : image a z 0 j=a j := by simp only [image,Nat.not_lt_zero,ite_false]
theorem image_input (a : Nat → R) (z : R) (k : Nat) : image a z k k=a k := by simp only [image,Nat.lt_irrefl,ite_false]
theorem image_written (a : Nat → R) (z : R) (n i : Nat) (hi : i<n) : image a z n i=a i*z := by simp only [image,hi,ite_true]
theorem image_unchanged (a : Nat → R) (z : R) (k j : Nat) (different : j≠k) : image a z k j=image a z (k+1) j := by
  have same : (j<k) ↔ j<k+1 := by omega
  simp only [image,same]

structure Data (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (s : State) : Prop where
  bound : k≤1536
  width : p.elementBytes=2
  pointer : s.arrays "a".toList=some p
  n : USlot s "n" 1536
  ni : Local s "ni" (radix*z)
  cells : Cells s.heap p 1536 (image a z k)
structure Inv (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (s : State) : Prop
    extends Data a p z k s where
  counter : USlot s "u" k

theorem body_data (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (s : State) (out : Result)
    (hk : k<1536) (inv : Inv a p z k s) (source : Exec KeygenPublicSource.program [] body s out) :
    Data a p z (k+1) out.state ∧ USlot out.state "u" k := by
  have input : Cell s.heap p k (a k) := by
    have c := inv.cells k hk; rwa [image_input] at c
  obtain ⟨written,w,store⟩ := KeygenPublicNormalizeAtoms.source_body s out p k (a k) z hk inv.pointer inv.counter input inv.ni source
  have f := KeygenPublicTableControl.frame _ [] body s out (by decide) source
  refine ⟨⟨by omega,inv.width,?_,?_,?_,?_⟩,?_⟩
  · rw [f.2.1]; exact inv.pointer
  · exact (f.2.2 _ (by decide)).trans inv.n
  · exact KeygenPublicValueExpr.local_after body s out "ni" _ (by decide) (by decide) inv.ni source
  · intro j hj
    by_cases equal : j=k
    · subst j; rw [image_written a z (k+1) k (by omega)]; exact written
    · have kept := KeygenPublicInputCells.preserves s.heap out.state.heap p inv.width k j (Ne.symm equal) w _ store (inv.cells j hj)
      rwa [image_unchanged a z k j equal] at kept
  · exact (f.2.2 _ (by decide)).trans inv.counter

theorem step (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (hk : k<1536)
    (s middle next : State) (inv : Inv a p z k s)
    (iteration : Exec KeygenPublicSource.program [] body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] increment middle ⟨next,.normal⟩) : Inv a p z (k+1) next := by
  obtain ⟨data,counter⟩ := body_data a p z k s ⟨middle,.normal⟩ hk inv iteration
  obtain ⟨count,heap⟩ := KeygenPublicSizeOps.increment middle ⟨next,.normal⟩ "u" k hk counter update
  have f := KeygenPublicTableControl.frame _ [] increment middle ⟨next,.normal⟩ (by decide) update
  refine ⟨⟨data.bound,data.width,?_,?_,?_,?_⟩,count⟩
  · rw [f.2.1]; exact data.pointer
  · exact (f.2.2 _ (by decide)).trans data.n
  · exact KeygenPublicValueExpr.local_after increment middle ⟨next,.normal⟩ "ni" _ (by decide) (by decide) data.ni update
  · rw [heap]; exact data.cells

theorem loop_result (a : Nat → R) (p : ArrayPointer) (z : R) (code : Stmt)
    (before : State) (result : Result) (source : Exec KeygenPublicSource.program [] code before result)
    (shape : code=loop) (k : Nat) (inv : Inv a p z k before) :
    result.flow=.normal ∧ Inv a p z 1536 result.state := by
  generalize sgnEq : ([] : List Name)=sgn at source
  induction source generalizing k with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      rw [KeygenPublicSizeOps.lt before "u" "n" k 1536 inv.bound (by decide) v inv.counter inv.n guard] at zero
      have no : ¬k<1536 := by
        by_contra active
        simp [active,C99ScalarReference.boolean,Value.integer] at zero
      have bound := inv.bound
      have equal : k=1536 := by omega
      subst k; exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      rw [KeygenPublicSizeOps.lt before "u" "n" k 1536 inv.bound (by decide) v inv.counter inv.n guard] at nonzero
      have active : k<1536 := by
        by_contra inactive
        simp [inactive,C99ScalarReference.boolean,Value.integer] at nonzero
      exact ih3 rfl (k+1) (step a p z k active before middle next inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem source_loop (a : Nat → R) (p : ArrayPointer) (z : R) (s : State) (out : Result)
    (width : p.elementBytes=2) (pointer : s.arrays "a".toList=some p) (n : USlot s "n" 1536)
    (ni : Local s "ni" (radix*z)) (counter : USlot s "u" 0) (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] loop s out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (fun j => a j*z) := by
  have initial : Inv a p z 0 s := by
    refine ⟨⟨by decide,width,pointer,n,ni,?_⟩,counter⟩
    intro j hj; rw [image_zero]; exact cells j hj
  obtain ⟨flow,final⟩ := loop_result a p z loop s out source rfl 0 initial
  refine ⟨flow,?_⟩
  intro j hj
  have c := final.cells j hj; rwa [image_written a z 1536 j hj] at c

end FT1536.Source3.KeygenPublicNormalizeFold
