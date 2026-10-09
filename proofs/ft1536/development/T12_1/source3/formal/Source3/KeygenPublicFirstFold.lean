import Source3.KeygenPublicFirstPolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Fold the complete FIRST butterfly loop (768 iterations) of the public
   forward NTT into the low/high coefficient images of the ORIGINAL reduced
   CoefficientQuotient polynomial. This composes the SAME first-body value
   results across the whole executed loop; no canonicality, generated image,
   transform correctness, nonzero test or polynomial evaluation at
   KeygenPublicRoots.point is a premise. Entry domains (u=0, hn=768, seeded
   r = radix*firstRoot, converted input cells) remain explicit local caller
   domains, exactly as in the per-butterfly `source_original_coefficients`. -/
namespace FT1536.Source3.KeygenPublicFirstFold
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval)
open KeygenPublicValueExpr (Local)
open KeygenPublicInputCells (Cell Cells)
open KeygenPublicInputMaterial (reduced coefficient)
open KeygenPublicFirstPolynomial (low high)
open KeygenPublicAlgebra (R radix)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableAtoms (var)
open KeygenSmallOutput (Store16 element)

open KeygenPublicFirstValues (Fixed PairUpdate body firstLoop)

def root : R := KeygenPublicRoots.firstRoot
noncomputable def lowP (original : Geometry.Vec) : Polynomial R := low (Relation.reduceVec original) root
noncomputable def highP (original : Geometry.Vec) : Polynomial R := high (Relation.reduceVec original) root

/- Physical cell j after k first butterflies: low half (j<768) holds lowP
   coefficients once written, high half (768<=j) holds highP coefficients at
   j-768 once written; unwritten cells retain the ORIGINAL reduced input. -/
noncomputable def image (original : Geometry.Vec) (k j : Nat) : R :=
  if j < 768 then (if j < k then (lowP original).coeff j else reduced original j)
  else if j < 768 + k then (highP original).coeff (j - 768) else reduced original j

theorem reduced_low (original : Geometry.Vec) (i : Nat) (hi : i<768) :
    reduced original i = (Relation.reduceVec original ⟨i,hi⟩).1 := by
  simp only [reduced,coefficient,hi,reduceDIte,Relation.reduceVec]
theorem reduced_high (original : Geometry.Vec) (i : Nat) (hi : i<768) :
    reduced original (i+768) = (Relation.reduceVec original ⟨i,hi⟩).2 := by
  simp only [reduced,coefficient,show ¬i+768<768 from by omega,reduceDIte,
    show i+768<1536 from by omega,show i+768-768=i from by omega,Relation.reduceVec]

theorem lowP_coeff (original : Geometry.Vec) (k : Nat) (hk : k<768) :
    (lowP original).coeff k = reduced original k + reduced original (k+768) * root := by
  have lc := KeygenPublicFirstPolynomial.low_coefficient (Relation.reduceVec original) root ⟨k,hk⟩
  have rl := reduced_low original k hk
  have rh := reduced_high original k hk
  simp only [lowP] at lc ⊢
  rw [lc, ← rl, ← rh]
theorem highP_coeff (original : Geometry.Vec) (k : Nat) (hk : k<768) :
    (highP original).coeff k = reduced original k + reduced original (k+768) - reduced original (k+768) * root := by
  have hc := KeygenPublicFirstPolynomial.high_coefficient (Relation.reduceVec original) root ⟨k,hk⟩
  have rl := reduced_low original k hk
  have rh := reduced_high original k hk
  simp only [highP] at hc ⊢
  rw [hc, ← rl, ← rh]

/- image unfolding, all four physical cases. -/
theorem image_low (original : Geometry.Vec) (k j : Nat) (h768 : j<768) (hlt : j<k) :
    image original k j = (lowP original).coeff j := by simp [image, h768, hlt]
theorem image_low_un (original : Geometry.Vec) (k j : Nat) (h768 : j<768) (hge : k≤j) :
    image original k j = reduced original j := by
  simp [image, h768, show ¬(j<k) from by omega]
theorem image_high (original : Geometry.Vec) (k j : Nat) (h768 : 768≤j) (hlt : j<768+k) :
    image original k j = (highP original).coeff (j - 768) := by
  simp [image, show ¬(j<768) from by omega, hlt]
theorem image_high_un (original : Geometry.Vec) (k j : Nat) (h768 : 768≤j) (hge : 768+k≤j) :
    image original k j = reduced original j := by
  simp [image, show ¬(j<768) from by omega, show ¬(j<768+k) from by omega]

theorem image_zero (original : Geometry.Vec) (j : Nat) : image original 0 j = reduced original j := by
  by_cases h : j<768
  · exact image_low_un original 0 j h (by omega)
  · exact image_high_un original 0 j (by omega) (by omega)
theorem image_advance (original : Geometry.Vec) (k : Nat) (hk : k<768) :
    image original (k+1) k = (lowP original).coeff k :=
  image_low original (k+1) k hk (by omega)
theorem image_advance_high (original : Geometry.Vec) (k : Nat) (hk : k<768) :
    image original (k+1) (k+768) = (highP original).coeff k := by
  rw [image_high original (k+1) (k+768) (by omega) (by omega), Nat.add_sub_cancel]
theorem image_input_low (original : Geometry.Vec) (k : Nat) (hk : k<768) :
    image original k k = reduced original k :=
  image_low_un original k k hk (by omega)
theorem image_input_high (original : Geometry.Vec) (k : Nat) (hk : k<768) :
    image original k (k+768) = reduced original (k+768) :=
  image_high_un original k (k+768) (by omega) (by omega)
theorem image_unchanged (original : Geometry.Vec) (k j : Nat) (ji : j≠k) (jh : j≠k+768) :
    image original k j = image original (k+1) j := by
  by_cases h768 : j<768
  · by_cases hlt : j<k
    · rw [image_low original k j h768 hlt, image_low original (k+1) j h768 (by omega)]
    · rw [image_low_un original k j h768 (by omega), image_low_un original (k+1) j h768 (by omega)]
  · have lo : 768≤j := by omega
    by_cases hlt : j<768+k
    · rw [image_high original k j lo hlt, image_high original (k+1) j lo (by omega)]
    · rw [image_high_un original k j lo (by omega), image_high_un original (k+1) j lo (by omega)]

theorem guard_cmp (s : State) (k : Nat) (hi : k≤768) (v : Value)
    (u : USlot s "u" k) (hn : USlot s "hn" 768)
    (source : Eval [] s (.cmp .lt (var "u") (var "hn")) v) :
    v = C99ScalarReference.boolean (decide (k<768)) := by
  cases source with
  | cmp _ _ _ a b _ first second op =>
      have ae := KeygenPublicInputAtoms.word64 [] s "u" k a u first
      have be := KeygenPublicInputAtoms.word64 [] s "hn" 768 b hn second
      subst a; subst b
      have equal := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .lt
        (C99IntegerReference.convert .uint64 (u64 k).integer).integer
        (C99IntegerReference.convert .uint64 (u64 768).integer).integer) at equal
      rw [KeygenNttLoopSupport.convert_u64_self k (by omega),
        KeygenNttLoopSupport.convert_u64_self 768 (by decide),
        KeygenNttLoopSupport.u64_integer k (by omega),KeygenNttLoopSupport.u64_integer 768 (by decide)] at equal
      have comparison : (((k : Nat) : Int)<((768 : Nat) : Int)) ↔ k<768 := by omega
      simpa only [C99IntegerReference.compare,comparison] using equal

theorem increment_result (s : State) (out : Result) (i : Nat) (hi : i<768)
    (counter : USlot s "u" i)
    (source : Exec KeygenPublicSource.program [] (.scalar (.update "u".toList .add (.literal .i32 1))) s out) :
    out = ⟨bindValue s "u".toList .uint64 (u64 (i+1)),.normal⟩ := by
  cases source with
  | scalar _ before env executed =>
      cases executed with
      | assign _ _ _ ty old v declared evaluated =>
          have slot := Option.some.inj (declared.symm.trans counter)
          have te := congrArg Prod.fst slot
          dsimp only at te
          subst ty
          cases evaluated with
          | arithmetic _ _ _ a b _ left right operation =>
              have ae := KeygenPublicTableIndex.variable64 s "u" i a counter left
              subst a
              cases right
              have equal := KeygenNttLoopSupport.add_one_literal i (by omega) v operation
              rw [equal]
              rfl
theorem increment_counter (s : State) (i : Nat) (hi : i<768) :
    USlot (bindValue s "u".toList .uint64 (u64 (i+1))) "u" (i+1) := by
  simp only [USlot,bindValue,C99ScalarReference.set,ite_true,
    KeygenNttLoopSupport.convert_u64_self (i+1) (by omega)]

/- Preserve a cell across the paired low/high stores of one butterfly. -/
theorem preserve_pair (a : ArrayPointer) (width : a.elementBytes=2) (i j : Nat) (z : R)
    (before middle after : Memory) (lw hw : BitVec 16)
    (lowStore : Store16 before (element a i) lw middle)
    (highStore : Store16 middle (element a (i+768)) hw after)
    (ji : j≠i) (jh : j≠i+768) (cell : Cell before a j z) : Cell after a j z := by
  have c1 := KeygenPublicInputCells.preserves before middle a width i j (Ne.symm ji) lw z lowStore cell
  exact KeygenPublicInputCells.preserves middle after a width (i+768) j (Ne.symm jh) hw z highStore c1

structure Data (original : Geometry.Vec) (a : ArrayPointer) (k : Nat) (s : State) : Prop where
  bound : k≤768
  pointer : s.arrays "a".toList = some a
  hn : USlot s "hn" 768
  width : a.elementBytes = 2
  r : Local s "r" (radix*root)
  cells : ∀ j < 1536, Cell s.heap a j (image original k j)
structure Inv (original : Geometry.Vec) (a : ArrayPointer) (k : Nat) (s : State) : Prop
    extends Data original a k s where
  counter : USlot s "u" k

/- One executed first butterfly advances the image to k+1 with u still k. -/
theorem body_data (original : Geometry.Vec) (a : ArrayPointer) (k : Nat) (s : State) (out : Result)
    (hk : k<768) (inv : Inv original a k s)
    (source : Exec KeygenPublicSource.program [] body s out) :
    Data original a (k+1) out.state ∧ USlot out.state "u" k := by
  have fixed : Fixed s a k := ⟨inv.pointer, inv.counter, inv.hn⟩
  have first : Cell s.heap a k (reduced original k) := by
    have c := inv.cells k (by omega : k<1536)
    rwa [image_input_low original k hk] at c
  have second : Cell s.heap a (k+768) (reduced original (k+768)) := by
    have c := inv.cells (k+768) (by omega : k+768<1536)
    rwa [image_input_high original k hk] at c
  obtain ⟨lowFinal, highFinal, mid, lw, hw, lowStore, highStore⟩ :=
    KeygenPublicFirstValues.source_body s out a k (reduced original k) (reduced original (k+768)) root
      hk inv.width fixed first second inv.r source
  have fixedAfter : Fixed out.state a k :=
    KeygenPublicFirstValues.fixed_after body s out a k fixed KeygenPublicFirstValues.body_supported (by decide) source
  have rAfter : Local out.state "r" (radix*root) :=
    KeygenPublicValueExpr.local_after body s out "r" (radix*root)
      KeygenPublicFirstValues.body_supported (by decide) inv.r source
  refine ⟨⟨by omega, fixedAfter.pointer, fixedAfter.hn, inv.width, rAfter, ?_⟩, fixedAfter.u⟩
  intro j hj
  by_cases c1 : j=k
  · subst j
    rw [image_advance original k hk, lowP_coeff original k hk]
    exact lowFinal
  · by_cases c2 : j=k+768
    · subst j
      rw [image_advance_high original k hk, highP_coeff original k hk]
      exact highFinal
    · have preserved : Cell out.state.heap a j (image original k j) :=
        preserve_pair a inv.width k j _ s.heap mid out.state.heap lw hw
          lowStore highStore c1 c2 (inv.cells j hj)
      rwa [image_unchanged original k j c1 c2] at preserved

/- Body then increment: one loop iteration advances to k+1 with u=k+1. -/
theorem step (original : Geometry.Vec) (a : ArrayPointer) (k : Nat) (hk : k<768)
    (s middle next : State) (inv : Inv original a k s)
    (iteration : Exec KeygenPublicSource.program [] body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program []
      (.scalar (.update "u".toList .add (.literal .i32 1))) middle ⟨next,.normal⟩) :
    Inv original a (k+1) next := by
  obtain ⟨data,u⟩ := body_data original a k s ⟨middle,.normal⟩ hk inv iteration
  have state := congrArg Result.state (increment_result middle ⟨next,.normal⟩ k hk u update)
  dsimp only at state
  have heap : next.heap = middle.heap := by rw [state]; rfl
  have arrays : next.arrays = middle.arrays := by rw [state]; rfl
  have frame := KeygenPublicTableControl.frame _ _
    (.scalar (.update "u".toList .add (.literal .i32 1))) middle ⟨next,.normal⟩ (by decide) update
  refine ⟨⟨by omega, ?_, ?_, data.width, ?_, ?_⟩, ?_⟩
  · rw [arrays]; exact data.pointer
  · exact (frame.2.2 "hn".toList (by decide)).trans data.hn
  · exact KeygenPublicValueExpr.local_after (.scalar (.update "u".toList .add (.literal .i32 1)))
      middle ⟨next,.normal⟩ "r" (radix*root) (by decide) (by decide) data.r update
  · intro j hj; rw [heap]; exact data.cells j hj
  · rw [state]; exact increment_counter middle k hk

/- The complete first loop folds to the terminal counter 768. -/
theorem loop_result (original : Geometry.Vec) (a : ArrayPointer) (code : Stmt)
    (before : State) (result : Result)
    (source : Exec KeygenPublicSource.program [] code before result)
    (shape : code = firstLoop) (k : Nat) (inv : Inv original a k before) :
    result.flow=.normal ∧ Inv original a 768 result.state := by
  generalize sgnEq : ([] : List Name) = sgn at source
  induction source generalizing k with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      rw [guard_cmp before k inv.bound v inv.counter inv.hn guard] at zero
      have nk : ¬(k<768) := by
        by_contra h
        simp [h, C99ScalarReference.boolean, C99IntegerReference.Value.integer] at zero
      have kb : k≤768 := inv.bound
      have eq : k=768 := by omega
      subst eq
      exact ⟨rfl, inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      rw [guard_cmp before k inv.bound v inv.counter inv.hn guard] at nonzero
      have active : k<768 := by
        by_contra h
        simp [h, C99ScalarReference.boolean, C99IntegerReference.Value.integer] at nonzero
      exact ih3 rfl (k+1) (step original a k active before middle next inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

/- Extract all 768 low/high coefficient cells at any terminal counter >=768. -/
theorem folded (original : Geometry.Vec) (a : ArrayPointer) (k : Nat) (hk : 768≤k)
    (s : State) (inv : Inv original a k s) (i : Nat) (hi : i<768) :
    Cell s.heap a i ((lowP original).coeff i) ∧ Cell s.heap a (i+768) ((highP original).coeff i) := by
  refine ⟨?_,?_⟩
  · have c := inv.cells i (by omega : i<1536)
    rwa [image_low original k i hi (by omega : i<k)] at c
  · have c := inv.cells (i+768) (by omega : i+768<1536)
    rw [image_high original k (i+768) (by omega) (by omega : i+768<768+k)] at c
    rw [show (i+768)-768 = i from by omega] at c
    exact c

/- Headline: from the entry domains (u=0, hn=768, seeded r, converted input
   cells) the whole first loop yields all 768 low/high coefficient images of
   the ORIGINAL reduced CoefficientQuotient polynomial. -/
theorem source_first_fold (original : Geometry.Vec) (a : ArrayPointer) (s : State) (out : Result)
    (width : a.elementBytes=2) (pointer : s.arrays "a".toList=some a)
    (hn : USlot s "hn" 768) (r : Local s "r" (radix*root))
    (u0 : USlot s "u" 0) (input : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] firstLoop s out) :
    out.flow=.normal ∧ ∀ i<768,
      Cell out.state.heap a i ((lowP original).coeff i) ∧
        Cell out.state.heap a (i+768) ((highP original).coeff i) := by
  have inv0 : Inv original a 0 s := by
    refine ⟨⟨by omega, pointer, hn, width, r, ?_⟩, u0⟩
    intro j hj
    rw [image_zero original j]
    exact input j hj
  obtain ⟨flow, inv⟩ := loop_result original a firstLoop s out source rfl 0 inv0
  exact ⟨flow, fun i hi => folded original a 768 (by omega) out.state inv i hi⟩

end FT1536.Source3.KeygenPublicFirstFold
