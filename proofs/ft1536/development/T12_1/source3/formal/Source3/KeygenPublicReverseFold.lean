import Source3.KeygenPublicReverseValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete reverse-radix v-loop. Every untouched cell is preserved;
   low/high outputs are explicit unnormalized values of the actual input. -/
namespace FT1536.Source3.KeygenPublicReverseFold
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicValueExpr (Local)
open KeygenPublicInputCells (Cell Cells)
open KeygenPublicAlgebra (R radix)
open KeygenNttLoopSupport (USlot)
open KeygenPublicReverseProgram (body loop increment)

def low (a : Nat → R) (base h : Nat) (k : Nat) : R := a (base+k)+a (base+h+k)
def high (a : Nat → R) (base h : Nat) (z : R) (k : Nat) : R := (a (base+k)-a (base+h+k))*z
def image (a : Nat → R) (base h : Nat) (z : R) (k j : Nat) : R :=
  if base≤j ∧ j<base+k then low a base h (j-base)
  else if base+h≤j ∧ j<base+h+k then high a base h z (j-(base+h)) else a j

theorem image_zero (a : Nat → R) (base h : Nat) (z : R) (j : Nat) : image a base h z 0 j=a j := by
  simp only [image,Nat.add_zero,show ¬(base≤j ∧ j<base) from by omega,
    show ¬(base+h≤j ∧ j<base+h) from by omega,ite_false]
theorem image_input_low (a : Nat → R) (base h k : Nat) (z : R) (hk : k<h) :
    image a base h z k (base+k)=a (base+k) := by
  simp only [image,show ¬(base≤base+k ∧ base+k<base+k) from by omega,
    show ¬(base+h≤base+k ∧ base+k<base+h+k) from by omega,ite_false]
theorem image_input_high (a : Nat → R) (base h k : Nat) (z : R) (hk : k<h) :
    image a base h z k (base+h+k)=a (base+h+k) := by
  simp only [image,show ¬(base≤base+h+k ∧ base+h+k<base+k) from by omega,
    show ¬(base+h≤base+h+k ∧ base+h+k<base+h+k) from by omega,ite_false]
theorem image_low (a : Nat → R) (base h n k : Nat) (z : R) (hk : k<n) :
    image a base h z n (base+k)=low a base h k := by
  simp only [image,show base≤base+k ∧ base+k<base+n from by omega,and_self,ite_true,Nat.add_sub_cancel_left]
theorem image_high (a : Nat → R) (base h n k : Nat) (z : R) (hn : n≤h) (hk : k<n) :
    image a base h z n (base+h+k)=high a base h z k := by
  simp only [image,show ¬(base≤base+h+k ∧ base+h+k<base+n) from by omega,ite_false,
    show base+h≤base+h+k ∧ base+h+k<base+h+n from by omega,and_self,ite_true,Nat.add_sub_cancel_left]
theorem image_unchanged (a : Nat → R) (base h k j : Nat) (z : R)
    (lo : j≠base+k) (hi : j≠base+h+k) : image a base h z k j=image a base h z (k+1) j := by
  have first : (base≤j ∧ j<base+k) ↔ (base≤j ∧ j<base+(k+1)) := by omega
  have second : (base+h≤j ∧ j<base+h+k) ↔ (base+h≤j ∧ j<base+h+(k+1)) := by omega
  simp only [image,first,second]

structure Data (a : Nat → R) (p : ArrayPointer) (base h : Nat) (z : R) (k : Nat) (s : State) : Prop where
  count : k≤h
  positive : 0 < h
  extent : base+2*h≤1536
  width : p.elementBytes=2
  pointer : s.arrays "a".toList=some p
  ht : USlot s "ht" h
  limit : USlot s "v2" (base+h)
  twiddle : Local s "s" (radix*z)
  cells : Cells s.heap p 1536 (image a base h z k)
structure Inv (a : Nat → R) (p : ArrayPointer) (base h : Nat) (z : R) (k : Nat) (s : State) : Prop
    extends Data a p base h z k s where
  counter : USlot s "v" (base+k)

theorem body_data (a : Nat → R) (p : ArrayPointer) (base h k : Nat) (z : R) (s : State) (out : Result)
    (hk : k<h) (inv : Inv a p base h z k s) (source : Exec KeygenPublicSource.program [] body s out) :
    Data a p base h z (k+1) out.state ∧ USlot out.state "v" (base+k) := by
  have extent := inv.extent
  have lowCell : Cell s.heap p (base+k) (a (base+k)) := by
    have c := inv.cells (base+k) (by omega); rwa [image_input_low a base h k z hk] at c
  have highCell : Cell s.heap p (base+h+k) (a (base+h+k)) := by
    have c := inv.cells (base+h+k) (by omega); rwa [image_input_high a base h k z hk] at c
  have index : base+k+h=base+h+k := by omega
  obtain ⟨lo,hi,middle,lw,hw,store1,store2⟩ := KeygenPublicReverseValues.source_body s out p (base+k) h
    (a (base+k)) (a (base+h+k)) z inv.positive (by omega) inv.width ⟨inv.pointer,inv.counter,inv.ht⟩
    lowCell (by rw [index]; exact highCell) inv.twiddle source
  rw [index] at hi store2
  have frame := KeygenPublicTableControl.frame _ [] body s out KeygenPublicReverseProgram.body_supported source
  refine ⟨⟨by omega,inv.positive,extent,inv.width,?_,?_,?_,?_,?_⟩,?_⟩
  · rw [frame.2.1]; exact inv.pointer
  · exact (frame.2.2 _ (by decide)).trans inv.ht
  · exact (frame.2.2 _ (by decide)).trans inv.limit
  · exact KeygenPublicValueExpr.local_after body s out "s" _ (by decide) (by decide) inv.twiddle source
  · intro j hj
    by_cases jl : j=base+k
    · subst j; rw [image_low a base h (k+1) k z (by omega)]; exact lo
    · by_cases jh : j=base+h+k
      · subst j; rw [image_high a base h (k+1) k z (by omega) (by omega)]; exact hi
      · have kept := KeygenPublicInputCells.preserves s.heap middle p inv.width (base+k) j (Ne.symm jl) lw _ store1 (inv.cells j hj)
        have kept2 := KeygenPublicInputCells.preserves middle out.state.heap p inv.width (base+h+k) j (Ne.symm jh) hw _ store2 kept
        rwa [image_unchanged a base h k j z jl jh] at kept2
  · exact (frame.2.2 _ (by decide)).trans inv.counter

theorem step (a : Nat → R) (p : ArrayPointer) (base h k : Nat) (z : R) (hk : k<h)
    (s middle next : State) (inv : Inv a p base h z k s)
    (iteration : Exec KeygenPublicSource.program [] body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] increment middle ⟨next,.normal⟩) : Inv a p base h z (k+1) next := by
  obtain ⟨data,counter⟩ := body_data a p base h k z s ⟨middle,.normal⟩ hk inv iteration
  have extent := inv.extent
  have state := congrArg Result.state (KeygenPublicRadixFold.increment_result middle ⟨next,.normal⟩ (base+k) (by omega) counter update)
  dsimp only at state
  have frame := KeygenPublicTableControl.frame _ [] increment middle ⟨next,.normal⟩ (by decide) update
  refine ⟨⟨data.count,data.positive,data.extent,data.width,?_,?_,?_,?_,?_⟩,?_⟩
  · rw [state]; exact data.pointer
  · exact (frame.2.2 _ (by decide)).trans data.ht
  · exact (frame.2.2 _ (by decide)).trans data.limit
  · exact KeygenPublicValueExpr.local_after increment middle ⟨next,.normal⟩ "s" _ (by decide) (by decide) data.twiddle update
  · rw [state]; exact data.cells
  · rw [state]
    simp only [USlot,C99ArrayReference.bindValue,C99ScalarReference.set,ite_true,Nat.add_assoc]
    rw [KeygenNttLoopSupport.convert_u64_self (base+(k+1)) (by omega)]

theorem loop_result (a : Nat → R) (p : ArrayPointer) (base h : Nat) (z : R) (code : Stmt)
    (before : State) (result : Result) (source : Exec KeygenPublicSource.program [] code before result)
    (shape : code=loop) (k : Nat) (inv : Inv a p base h z k before) :
    result.flow=.normal ∧ Inv a p base h z h result.state := by
  generalize sgnEq : ([] : List Name)=sgn at source
  induction source generalizing k with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      have extent := inv.extent
      have count := inv.count
      rw [KeygenPublicRadixFold.guard_value before (base+k) (base+h) (by omega) (by omega) v inv.counter inv.limit guard] at zero
      have no : ¬base+k<base+h := by
        by_contra active
        simp [active,C99ScalarReference.boolean,Value.integer] at zero
      have eq : k=h := by omega
      subst k
      exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      have extent := inv.extent
      have count := inv.count
      rw [KeygenPublicRadixFold.guard_value before (base+k) (base+h) (by omega) (by omega) v inv.counter inv.limit guard] at nonzero
      have active : k<h := by
        by_contra inactive
        have no : ¬base+k<base+h := by omega
        simp [no,C99ScalarReference.boolean,Value.integer] at nonzero
      exact ih3 rfl (k+1) (step a p base h k z active before middle next inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem source_loop (a : Nat → R) (p : ArrayPointer) (base h : Nat) (z : R) (s : State) (out : Result)
    (positive : 0 < h) (extent : base+2*h≤1536) (width : p.elementBytes=2)
    (pointer : s.arrays "a".toList=some p) (ht : USlot s "ht" h)
    (limit : USlot s "v2" (base+h)) (counter : USlot s "v" base)
    (twiddle : Local s "s" (radix*z)) (input : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] loop s out) :
    out.flow=.normal ∧ Inv a p base h z h out.state := by
  have initial : Inv a p base h z 0 s := by
    refine ⟨⟨by omega,positive,extent,width,pointer,ht,limit,twiddle,?_⟩,?_⟩
    · intro j hj; rw [image_zero]; exact input j hj
    · simpa only [Nat.add_zero] using counter
  exact loop_result a p base h z loop s out source rfl 0 initial

end FT1536.Source3.KeygenPublicReverseFold
