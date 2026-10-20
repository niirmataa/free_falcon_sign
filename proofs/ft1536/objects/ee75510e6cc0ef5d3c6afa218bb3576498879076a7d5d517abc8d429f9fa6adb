import Source3.KeygenPublicRootInverseValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- All768 actual first-root butterflies, with untouched-cell preservation.
   This unnormalized image is derived, not an inverse-correctness premise. -/
namespace FT1536.Source3.KeygenPublicRootInverseFold
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicValueExpr (Local)
open KeygenPublicInputCells (Cell Cells)
open KeygenPublicAlgebra (R radix)
open KeygenNttLoopSupport (USlot)
open KeygenPublicRootInverseProgram (body loop increment)

def low (a : Nat → R) (z : R) (i : Nat) : R := a i+a (i+768)-z*(a i-a (i+768))
def high (a : Nat → R) (z : R) (i : Nat) : R := z*(a i-a (i+768))+z*(a i-a (i+768))
def image (a : Nat → R) (z : R) (k j : Nat) : R :=
  if j<k then low a z j else if 768≤j ∧ j<768+k then high a z (j-768) else a j

theorem image_zero (a : Nat → R) (z : R) (j : Nat) : image a z 0 j=a j := by
  simp only [image,Nat.not_lt_zero,ite_false,Nat.add_zero,
    show ¬(768≤j ∧ j<768) from by omega]
theorem image_input_low (a : Nat → R) (z : R) (k : Nat) (hk : k<768) : image a z k k=a k := by
  simp only [image,Nat.lt_irrefl,ite_false,show ¬(768≤k ∧ k<768+k) from by omega]
theorem image_input_high (a : Nat → R) (z : R) (k : Nat) : image a z k (k+768)=a (k+768) := by
  simp only [image,show ¬(k+768<k) from by omega,show ¬(768≤k+768 ∧ k+768<768+k) from by omega,ite_false]
theorem image_low (a : Nat → R) (z : R) (n i : Nat) (hi : i<n) : image a z n i=low a z i := by
  simp only [image,hi,ite_true]
theorem image_high (a : Nat → R) (z : R) (n i : Nat) (hn : n≤768) (hi : i<n) :
    image a z n (i+768)=high a z i := by
  simp only [image,show ¬(i+768<n) from by omega,ite_false,
    show (768 ≤ i + 768 ∧ i + 768 < 768 + n) from by omega,and_self,ite_true,Nat.add_sub_cancel]
theorem image_unchanged (a : Nat → R) (z : R) (k j : Nat) (lo : j≠k) (hi : j≠k+768) :
    image a z k j=image a z (k+1) j := by
  have first : (j<k) ↔ j<k+1 := by omega
  have second : (768≤j ∧ j<768+k) ↔ (768≤j ∧ j<768+(k+1)) := by omega
  simp only [image,first,second]

structure Data (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (s : State) : Prop where
  bound : k≤768
  width : p.elementBytes=2
  pointer : s.arrays "a".toList=some p
  hn : USlot s "hn" 768
  r : Local s "r" (radix*z)
  cells : Cells s.heap p 1536 (image a z k)
structure Inv (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (s : State) : Prop
    extends Data a p z k s where
  counter : USlot s "u" k

theorem body_data (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (s : State) (out : Result)
    (hk : k<768) (inv : Inv a p z k s) (source : Exec KeygenPublicSource.program [] body s out) :
    Data a p z (k+1) out.state ∧ USlot out.state "u" k := by
  have lo : Cell s.heap p k (a k) := by
    have c := inv.cells k (by omega); rwa [image_input_low a z k hk] at c
  have hi : Cell s.heap p (k+768) (a (k+768)) := by
    have c := inv.cells (k+768) (by omega); rwa [image_input_high] at c
  obtain ⟨lowCell,highCell,middle,lw,hw,store1,store2⟩ := KeygenPublicRootInverseValues.source_body s out p k
    (a k) (a (k+768)) z hk inv.width ⟨inv.pointer,inv.counter,inv.hn⟩ lo hi inv.r source
  have f := KeygenPublicTableControl.frame _ [] body s out (by decide) source
  refine ⟨⟨by omega,inv.width,?_,?_,?_,?_⟩,?_⟩
  · rw [f.2.1]; exact inv.pointer
  · exact (f.2.2 _ (by decide)).trans inv.hn
  · exact KeygenPublicValueExpr.local_after body s out "r" _ (by decide) (by decide) inv.r source
  · intro j hj
    by_cases equal : j=k
    · subst j; rw [image_low a z (k+1) k (by omega)]; exact lowCell
    · by_cases highEqual : j=k+768
      · subst j; rw [image_high a z (k+1) k (by omega) (by omega)]; exact highCell
      · have kept := KeygenPublicFirstFold.preserve_pair p inv.width k j _ s.heap middle out.state.heap
          lw hw store1 store2 equal highEqual (inv.cells j hj)
        rwa [image_unchanged a z k j equal highEqual] at kept
  · exact (f.2.2 _ (by decide)).trans inv.counter

theorem step (a : Nat → R) (p : ArrayPointer) (z : R) (k : Nat) (hk : k<768)
    (s middle next : State) (inv : Inv a p z k s)
    (iteration : Exec KeygenPublicSource.program [] body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] increment middle ⟨next,.normal⟩) : Inv a p z (k+1) next := by
  obtain ⟨data,counter⟩ := body_data a p z k s ⟨middle,.normal⟩ hk inv iteration
  have state := congrArg Result.state (KeygenPublicFirstFold.increment_result middle ⟨next,.normal⟩ k hk counter update)
  dsimp only at state
  have f := KeygenPublicTableControl.frame _ [] increment middle ⟨next,.normal⟩ (by decide) update
  refine ⟨⟨data.bound,data.width,?_,?_,?_,?_⟩,?_⟩
  · rw [state]; exact data.pointer
  · exact (f.2.2 _ (by decide)).trans data.hn
  · exact KeygenPublicValueExpr.local_after increment middle ⟨next,.normal⟩ "r" _ (by decide) (by decide) data.r update
  · rw [state]; exact data.cells
  · rw [state]; exact KeygenPublicFirstFold.increment_counter middle k hk

theorem loop_result (a : Nat → R) (p : ArrayPointer) (z : R) (code : Stmt)
    (before : State) (result : Result) (source : Exec KeygenPublicSource.program [] code before result)
    (shape : code=loop) (k : Nat) (inv : Inv a p z k before) :
    result.flow=.normal ∧ Inv a p z 768 result.state := by
  generalize sgnEq : ([] : List Name)=sgn at source
  induction source generalizing k with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      rw [KeygenPublicFirstFold.guard_cmp before k inv.bound v inv.counter inv.hn guard] at zero
      have no : ¬k<768 := by
        by_contra active
        simp [active,C99ScalarReference.boolean,Value.integer] at zero
      have bound := inv.bound
      have equal : k=768 := by omega
      subst k
      exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      rw [KeygenPublicFirstFold.guard_cmp before k inv.bound v inv.counter inv.hn guard] at nonzero
      have active : k<768 := by
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
    (width : p.elementBytes=2) (pointer : s.arrays "a".toList=some p) (hn : USlot s "hn" 768)
    (r : Local s "r" (radix*z)) (counter : USlot s "u" 0) (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] loop s out) :
    out.flow=.normal ∧ Inv a p z 768 out.state := by
  have initial : Inv a p z 0 s := by
    refine ⟨⟨by decide,width,pointer,hn,r,?_⟩,counter⟩
    intro j hj; rw [image_zero]; exact cells j hj
  exact loop_result a p z loop s out source rfl 0 initial

end FT1536.Source3.KeygenPublicRootInverseFold
