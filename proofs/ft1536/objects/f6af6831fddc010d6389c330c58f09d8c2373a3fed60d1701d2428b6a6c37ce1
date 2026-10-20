import Source3.KeygenPublicSuffixBody

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete executed loop either returns the source failure0 or tests
   ALL1536 f values and stores ALL1536 g/f quotients before the inverse. -/
namespace FT1536.Source3.KeygenPublicSuffixLoop
open C99ArrayReference (State bindValue)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed condition increment initial)
open KeygenPublicInputLoop (Pointers Layout Fixed)
open KeygenPublicInputCells (Cells)
open KeygenPublicAlgebra (R)
open KeygenPublicSuffixProgram (body loop pass)
open KeygenPublicSuffixAtoms (Failure)
open KeygenPublicSuffixBody (Data Inv image)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)

theorem step (s middle next : State) (p : Pointers) (f g : Nat → R) (i : Nat) (hi : i<1536)
    (layout : Layout p) (inv : Inv p f g i s)
    (iteration : Exec KeygenPublicSource.program signed body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program signed increment middle ⟨next,.normal⟩) : Inv p f g (i+1) next := by
  obtain ⟨data,u⟩ := KeygenPublicSuffixBody.body_data s ⟨middle,.normal⟩ p f g i hi layout inv rfl iteration
  have fixed := KeygenPublicInputLoop.fixed_after increment middle ⟨next,.normal⟩ p data.fixed (by decide) (by decide) update
  have state := congrArg Result.state (KeygenPublicInputAtoms.increment_result middle ⟨next,.normal⟩ i hi u update)
  dsimp only at state
  have heap : next.heap=middle.heap := by rw [state]; rfl
  have frame := KeygenPublicTableControl.frame _ signed increment middle ⟨next,.normal⟩ (by decide) update
  refine ⟨⟨by omega,fixed,?_,?_,?_,?_,data.tested⟩,?_⟩
  · exact (frame.2.2 _ (by decide)).trans data.profile
  · exact (frame.2.2 _ (by decide)).trans data.ternary
  · rw [heap]; exact data.t
  · rw [heap]; exact data.h
  · rw [state]; exact KeygenPublicInputAtoms.increment_counter middle i hi

theorem source_loop (s : State) (out : Result) (p : Pointers) (f g : Nat → R) (i : Nat)
    (layout : Layout p) (inv : Inv p f g i s)
    (source : Exec KeygenPublicSource.program signed loop s out) :
    out.flow=Failure ∨ (out.flow=.normal ∧ Inv p f g 1536 out.state) := by
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
      exact Or.inr ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases signedShape
      rw [KeygenPublicInputAtoms.guard before i inv.bound v inv.counter inv.fixed.n guard] at nonzero
      have active : i<1536 := by
        by_contra h
        simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
      exact ih3 (i+1) (step before middle next p f g i active layout inv iteration update) rfl rfl
  | loopReturn _ _ _ before after v ret guard nonzero iteration ih =>
      cases shape; cases signedShape
      have failed := (KeygenPublicSuffixBody.body_flow before ⟨after,.returned ret⟩ iteration).resolve_left (by intro eq; cases eq)
      exact Or.inl failed
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem initial_result (s : State) (out : Result) (counter : USlot s "u" 1536)
    (source : Exec KeygenPublicSource.program signed initial s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 0),.normal⟩ := by
  cases source with
  | assign _ _ _ ty old v declared evaluated =>
      have te := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
      dsimp only at te
      subst ty
      rw [KeygenPublicTableAtoms.literal_value signed s 0 v evaluated]
      rfl

theorem source_pass (s : State) (out : Result) (p : Pointers) (f g : Nat → R)
    (layout : Layout p) (header : KeygenPublicCommonCalls.Header p s)
    (tCells : Cells s.heap p.t 1536 f) (hCells : Cells s.heap p.h 1536 g)
    (source : Exec KeygenPublicSource.program signed pass s out) :
    out.flow=Failure ∨ (out.flow=.normal ∧ Inv p f g 1536 out.state) := by
  obtain ⟨entry,initialized,loopExec⟩ := KeygenPublicInputAtoms.seq_inv signed initial loop s out (by decide) source
  have state := congrArg Result.state (initial_result s ⟨entry,.normal⟩ header.counter initialized)
  dsimp only at state
  have fixed := KeygenPublicInputLoop.fixed_after initial s ⟨entry,.normal⟩ p header.fixed (by decide) (by decide) initialized
  have frame := KeygenPublicTableControl.frame _ signed initial s ⟨entry,.normal⟩ (by decide) initialized
  have heap : entry.heap=s.heap := by rw [state]; rfl
  have inv : Inv p f g 0 entry := by
    refine ⟨⟨by decide,fixed,(frame.2.2 _ (by decide)).trans header.profile,
      (frame.2.2 _ (by decide)).trans header.ternary,?_,?_,?_⟩,?_⟩
    · rw [heap]; exact tCells
    · rw [heap]
      intro j hj
      simpa only [image,Nat.not_lt_zero,ite_false] using hCells j hj
    · intro j hj; omega
    · rw [state]; rfl
  exact source_loop entry out p f g 0 layout inv loopExec

end FT1536.Source3.KeygenPublicSuffixLoop
