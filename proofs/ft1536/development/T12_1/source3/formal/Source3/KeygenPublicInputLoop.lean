import Source3.KeygenPublicInputAtoms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- All 3072 conversion stores arise from the SAME actual for-loop. Neither
   canonical output nor equality with an abstract material is a premise. -/
namespace FT1536.Source3.KeygenPublicInputLoop
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicInputProgram (signed body loop increment)
open KeygenPublicInputCells (Signed Cells TailEmpty)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableControl (supported writes)
open KeygenPublicAlgebra (R)

structure Pointers where
  f : ArrayPointer
  g : ArrayPointer
  t : ArrayPointer
  h : ArrayPointer
structure Layout (p : Pointers) : Prop where
  tw : p.t.elementBytes=2
  hw : p.h.elementBytes=2
  different : p.t.block≠p.h.block
  tf : p.t.block≠p.f.block
  tg : p.t.block≠p.g.block
  hf : p.h.block≠p.f.block
  hg : p.h.block≠p.g.block
structure Fixed (p : Pointers) (s : State) : Prop where
  f : s.arrays "f".toList=some p.f
  g : s.arrays "g".toList=some p.g
  t : s.arrays "t".toList=some p.t
  h : s.arrays "h".toList=some p.h
  n : USlot s "n" 1536
  q : Slot s "q" 18433
structure Data (p : Pointers) (f g : Nat → Int) (i : Nat) (s : State) : Prop where
  bound : i≤1536
  fixed : Fixed p s
  inputF : Signed s.heap p.f f
  inputG : Signed s.heap p.g g
  t : Cells s.heap p.t i (fun j => (f j : R))
  h : Cells s.heap p.h i (fun j => (g j : R))
  tail : TailEmpty s.heap p.t
structure Invariant (p : Pointers) (f g : Nat → Int) (i : Nat) (s : State) : Prop extends Data p f g i s where
  counter : USlot s "u" i

theorem fixed_after (code : Stmt) (s : State) (out : Result) (p : Pointers) (fixed : Fixed p s)
    (ok : supported code=true) (keep : "n".toList∉writes code ∧ "q".toList∉writes code)
    (source : Exec KeygenPublicSource.program signed code s out) : Fixed p out.state := by
  obtain ⟨_,arrays,locals⟩ := KeygenPublicTableControl.frame _ _ _ _ _ ok source
  exact ⟨by rw [arrays]; exact fixed.f,by rw [arrays]; exact fixed.g,
    by rw [arrays]; exact fixed.t,by rw [arrays]; exact fixed.h,
    (locals _ keep.1).trans fixed.n,(locals _ keep.2).trans fixed.q⟩

theorem body_data (s : State) (out : Result) (p : Pointers) (f g : Nat → Int) (i : Nat)
    (hi : i<1536) (layout : Layout p) (inv : Invariant p f g i s)
    (source : Exec KeygenPublicSource.program signed body s out) :
    Data p f g (i+1) out.state ∧ USlot out.state "u" i := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rw [KeygenPublicForwardCall.restore_empty]
      obtain ⟨s1,first,rest⟩ := KeygenPublicInputAtoms.seq_inv signed _ _ s inner (by decide) executed
      obtain ⟨s2,second,last⟩ := KeygenPublicInputAtoms.seq_inv signed _ _ s1 inner (by decide) rest
      cases last
      obtain ⟨tw,tr,te,tStore⟩ := KeygenPublicInputAtoms.store s ⟨s1,.normal⟩ "t" "f" p.t p.f f i hi (by decide)
        inv.fixed.t inv.fixed.f inv.counter inv.fixed.q inv.inputF first
      have fixed1 := fixed_after _ s ⟨s1,.normal⟩ p inv.fixed (by decide) (by decide) first
      have u1 : USlot s1 "u" i :=
        (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) first).2.2 _ (by decide) |>.trans inv.counter
      have f1 := KeygenPublicInputCells.signed_other _ _ _ _ _ _ f layout.tf tStore inv.inputF
      have g1 := KeygenPublicInputCells.signed_other _ _ _ _ _ _ g layout.tg tStore inv.inputG
      obtain ⟨hw,hr,he,hStore⟩ := KeygenPublicInputAtoms.store s1 ⟨s2,.normal⟩ "h" "g" p.h p.g g i hi (by decide)
        fixed1.h fixed1.g u1 fixed1.q g1 second
      have fixed2 := fixed_after _ s1 ⟨s2,.normal⟩ p fixed1 (by decide) (by decide) second
      have u2 : USlot s2 "u" i :=
        (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) second).2.2 _ (by decide) |>.trans u1
      refine ⟨⟨by omega,fixed2,
        KeygenPublicInputCells.signed_other _ _ _ _ _ _ f layout.hf hStore f1,
        KeygenPublicInputCells.signed_other _ _ _ _ _ _ g layout.hg hStore g1,?_,?_,?_⟩,u2⟩
      · intro j hj
        by_cases same : j=i
        · subst j
          exact KeygenPublicInputCells.other_block _ _ p.h p.t i i _ _ (Ne.symm layout.different) hStore
            (KeygenPublicInputCells.written _ _ p.t i tw _ tr te tStore)
        · exact KeygenPublicInputCells.other_block _ _ p.h p.t i j _ _ (Ne.symm layout.different) hStore
            (KeygenPublicInputCells.preserves _ _ p.t layout.tw i j (by omega) _ _ tStore (inv.t j (by omega)))
      · intro j hj
        by_cases same : j=i
        · subst j
          exact KeygenPublicInputCells.written _ _ p.h i hw _ hr he hStore
        · exact KeygenPublicInputCells.preserves _ _ p.h layout.hw i j (by omega) _ _ hStore
            (KeygenPublicInputCells.other_block _ _ p.t p.h i j _ _ layout.different tStore (inv.h j (by omega)))
      · exact KeygenPublicInputCells.tail_store _ _ p.h p.t i _ layout.tw hi
          (Or.inr (Ne.symm layout.different)) hStore
          (KeygenPublicInputCells.tail_store _ _ p.t p.t i _ layout.tw hi (Or.inl rfl) tStore inv.tail)

theorem step (s middle next : State) (p : Pointers) (f g : Nat → Int) (i : Nat)
    (hi : i<1536) (layout : Layout p) (inv : Invariant p f g i s)
    (iteration : Exec KeygenPublicSource.program signed body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program signed increment middle ⟨next,.normal⟩) :
    Invariant p f g (i+1) next := by
  obtain ⟨data,u⟩ := body_data s ⟨middle,.normal⟩ p f g i hi layout inv iteration
  have fixed := fixed_after increment middle ⟨next,.normal⟩ p data.fixed (by decide) (by decide) update
  have state := congrArg Result.state (KeygenPublicInputAtoms.increment_result middle ⟨next,.normal⟩ i hi u update)
  dsimp only at state
  have heap : next.heap=middle.heap := by rw [state]; rfl
  refine ⟨⟨by omega,fixed,?_,?_,?_,?_,?_⟩,?_⟩
  · rw [heap]; exact data.inputF
  · rw [heap]; exact data.inputG
  · rw [heap]; exact data.t
  · rw [heap]; exact data.h
  · rw [heap]; exact data.tail
  · rw [state]; exact KeygenPublicInputAtoms.increment_counter middle i hi

theorem source_loop (s : State) (out : Result) (p : Pointers) (f g : Nat → Int) (i : Nat)
    (layout : Layout p) (inv : Invariant p f g i s)
    (source : Exec KeygenPublicSource.program signed loop s out) :
    out.flow=.normal ∧ Invariant p f g 1536 out.state := by
  generalize shape : loop=code at source
  generalize signedShape : signed=sgn at source
  induction source generalizing i with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases signedShape
      rw [KeygenPublicInputAtoms.guard before i inv.bound v inv.counter inv.fixed.n guard] at zero
      have done : i=1536 := by
        have bound := inv.bound
        by_cases active : i<1536
        · simp [active,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero
        · omega
      subst i
      exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases signedShape
      rw [KeygenPublicInputAtoms.guard before i inv.bound v inv.counter inv.fixed.n guard] at nonzero
      have active : i<1536 := by
        by_contra h
        simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
      exact ih3 (i+1) (step before middle next p f g i active layout inv iteration update) rfl rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

end FT1536.Source3.KeygenPublicInputLoop
