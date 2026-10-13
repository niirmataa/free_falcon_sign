import Source3.KeygenPublicCallerSite077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicForeign081
open C99MemoryReference
open KeygenCodecSyntax
open KeygenPublicEncodeValues077
open KeygenPublicEncodeExecution077
open ShakeExtractFrame (SameBlock)

def BufferOutside (s : State) (block : Nat) : Prop :=
  ∀ p, s.buf=some (some p) → p.block≠block

theorem same_trans (a b c : Memory) (block : Nat)
    (first : SameBlock a b block) (second : SameBlock b c block) : SameBlock a c block :=
  ⟨second.1.trans first.1,second.2.1.trans first.2.1,
    fun offset => (second.2.2 offset).trans (first.2.2 offset)⟩

/-- The actual public body writes only through its output buffer. This
    proof covers arbitrary source returns and does not assume capacity,
    encoded length, input values or a desired write trace. -/
theorem execution (args : Args) (code : Stmt) (s t : State) (flow : Flow)
    (source : Exec args code s t flow) (block : Nat)
    (output : ∀ p, args.out=some p → p.block≠block) :
    BufferOutside s block → SameBlock s.heap t.heap block ∧ BufferOutside t block := by
  induction source with
  | skip | scalar | increment | evaluate | whileDone | ret =>
    intro shield
    exact ⟨⟨rfl,rfl,fun _ => rfl⟩,shield⟩
  | declare s objects locals declarations =>
    intro shield
    refine ⟨⟨rfl,rfl,fun _ => rfl⟩,?_⟩
    intro p cell
    change (if hasBuf objects then none else s.buf)=some (some p) at cell
    split at cell
    · cases cell
    · exact shield p cell
  | bind s =>
    intro shield
    refine ⟨⟨rfl,rfl,fun _ => rfl⟩,?_⟩
    intro p cell
    exact output p (Option.some.inj cell)
  | store s index rhs m locals p offset value after buffer indexValue nonnegative rhsValue write =>
    intro shield
    have away : block≠p.block := Ne.symm (shield p buffer)
    exact ⟨⟨write.2.2.2.1,write.2.2.2.2.1,
      fun pointOffset => write.2.2.2.2.2.2 block pointOffset (Or.inl away)⟩,shield⟩
  | seq a b s m t flow first second ih1 ih2 =>
    intro shield
    obtain ⟨firstFrame,middle⟩ := ih1 shield
    obtain ⟨secondFrame,last⟩ := ih2 middle
    exact ⟨same_trans _ _ _ block firstFrame secondFrame,last⟩
  | seqReturn a b s t ret first ih => exact ih
  | scope a s t flow noShadow inside ih =>
    intro shield
    obtain ⟨frame,last⟩ := ih shield
    refine ⟨frame,?_⟩
    intro p cell
    change (if hasBuf (scopeObjects a) then s.buf else t.buf)=some (some p) at cell
    split at cell
    · exact shield p cell
    · exact last p cell
  | branchTrue test a b s t flow value locals evaluated yes selected ih => exact ih
  | branchFalse test a b s t flow value locals evaluated no selected ih => exact ih
  | whileNext test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    intro shield
    obtain ⟨firstFrame,middle⟩ := ih1 shield
    obtain ⟨secondFrame,last⟩ := ih2 middle
    exact ⟨same_trans _ _ _ block firstFrame secondFrame,last⟩
  | whileReturn test a s t ret value locals evaluated yes iteration ih => exact ih
  | forLoop a test b c s t flow expanded ih => exact ih

theorem call (args : Args) (before after : Memory) (ret : BitVec 64)
    (source : Call args before after ret) (block : Nat)
    (output : ∀ p, args.out=some p → p.block≠block) : SameBlock before after block := by
  obtain ⟨final,run,heap⟩ := source
  have frame := (execution args _ _ final (.returned ret) run block output (by intro p bad; cases bad)).1
  rw [heap] at frame
  exact frame

theorem site (env : KeygenMakeInvocation.Env) (c : KeygenPublicCallerSite077.Site env) (block : Nat)
    (separate : block≠env.args.pubkey.block) : SameBlock c.before.heap c.after block := by
  apply call _ _ _ _ c.execution block
  intro p bound
  have equal : KeygenMakeInvocation.byteOff env.args.pubkey 1=p := Option.some.inj bound
  subst p
  exact Ne.symm separate

end FT1536.Source3.KeygenPublicForeign081
