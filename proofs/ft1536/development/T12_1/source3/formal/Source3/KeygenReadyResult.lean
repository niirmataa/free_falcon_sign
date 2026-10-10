import Source3.KeygenRngFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Outcomes and flags are derived from the COMPLETE ready body, not the
   former already-ready subset. Entropy failure remains a source return0. -/
namespace FT1536.Source3.KeygenReadyResult
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenReadyFast (Flag field)
open KeygenRngProgram
open KeygenRngReference

def flagPresent (ctx : Context) (heap : Memory) (f : Flag) : Prop :=
  ∃ w : BitVec 32, Load32 heap (field ctx f) w ∧ (Value.int32 w).integer≠0
def returnsOnly (allowed : List (Option Nat)) : Stmt → Bool
  | .ret v => decide (v∈allowed)
  | .seq a b | .branchScalar _ a b | .branchFlag _ _ a b | .branchEntropy a b => returnsOnly allowed a && returnsOnly allowed b
  | .scope body | .auto32 body => returnsOnly allowed body
  | _ => true
def returnedFlow (v : Option Nat) : Flow := .returned (v.map (fun n => C99IntegerReference.convert .int32 n))
theorem outcomes (ctx : Context) (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx code before events out) (allowed : List (Option Nat)) (checked : returnsOnly allowed code=true) :
    out.flow=.normal ∨ ∃ v∈allowed, out.flow=returnedFlow v := by
  induction source with
  | skip | init | inject | extractTmp | flip | setSeed | storeFlag => exact Or.inl rfl
  | ret s value => exact Or.inr ⟨value,of_decide_eq_true checked,rfl⟩
  | seqNormal a b before middle events1 events2 out first second ih1 ih2 => exact ih2 (Bool.and_eq_true_iff.mp checked).2
  | seqExit a b before events out first exit ih =>
    rcases ih (Bool.and_eq_true_iff.mp checked).1 with h | h
    · exact False.elim (exit h)
    · exact Or.inr h
  | branchScalarTrue _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchScalarFalse _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | branchFlagTrue _ _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFlagFalse _ _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | branchEntropyTrue _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchEntropyFalse _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | scope _ _ _ _ _ ih | auto32 _ _ _ _ _ _ _ ih => exact ih checked
theorem normal_only (ctx : Context) (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx code before events out) (checked : returnsOnly [] code=true) : out.flow=.normal := by
  rcases outcomes ctx code before events out source [] checked with h | ⟨v,h,_⟩
  · exact h
  · cases h
theorem seed_outcome (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx seedStage before events out) : out.flow=.normal ∨ out.flow=.returned (some (.int32 0)) := by
  rcases outcomes ctx seedStage before events out source [some 0] (by decide) with h | ⟨v,h,flow⟩
  · exact Or.inl h
  · have equal : v=some 0 := by simpa only [List.mem_singleton] using h
    subst v; exact Or.inr flow
theorem flip_normal (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx flipStage before events out) : out.flow=.normal := normal_only ctx _ _ _ _ source (by decide)
theorem normal_split (ctx : Context) (a b : Stmt) (before after : State) (events : List KeygenEntropySource.Event)
    (source : Exec ctx (.seq a b) before events ⟨after,.normal⟩) :
    ∃ middle first last, events=first++last ∧ Exec ctx a before first ⟨middle,.normal⟩ ∧ Exec ctx b middle last ⟨after,.normal⟩ := by
  cases source with
  | seqNormal a b before middle first last out head tail => exact ⟨middle,first,last,rfl,head,tail⟩
  | seqExit a b before events out first exit => exact False.elim (exit rfl)
theorem skip_result (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx .skip before events out) : out=⟨before,.normal⟩ := by cases source; rfl
theorem return_tail (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx (.seq (.ret (some 1)) .skip) before events out) : out=returned before (some 1) := by
  cases source with
  | seqNormal a b before middle first last out head tail => cases head
  | seqExit a b before events out head exit => cases head; rfl
theorem ready_flow (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx readyCode before events out) :
    out.flow=.returned (some (.int32 0)) ∨ out.flow=.returned (some (.int32 1)) := by
  cases source with
  | seqExit a b before events out first exit =>
    rcases seed_outcome ctx before events out first with h | h
    · exact False.elim (exit h)
    · exact Or.inl h
  | seqNormal a b before middle first last out head tail =>
    cases tail with
    | seqExit a b before events out first exit => exact False.elim (exit (flip_normal ctx _ _ _ first))
    | seqNormal a b before middle first last out head tail => exact Or.inr (congrArg Result.flow (return_tail ctx middle last out tail))
theorem ready_success_split (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx readyCode before events out) (success : out.flow=.returned (some (.int32 1))) :
    ∃ seeded flipped first last, Exec ctx seedStage before first ⟨seeded,.normal⟩ ∧
      Exec ctx flipStage seeded last ⟨flipped,.normal⟩ ∧ out.state=flipped := by
  cases source with
  | seqExit a b before events out first exit =>
    rcases seed_outcome ctx before events out first with h | h
    · exact False.elim (exit h)
    · have bad : (Value.int32 0)=(Value.int32 1) := Option.some.inj (Flow.returned.inj (h.symm.trans success))
      cases bad
  | seqNormal a b before middle first last out head tail =>
    cases tail with
    | seqExit a b before events out first exit => exact False.elim (exit (flip_normal ctx _ _ _ first))
    | seqNormal a b before next first' last' out firstFlip tail =>
      exact ⟨middle,next,first,first',head,firstFlip,congrArg Result.state (return_tail ctx next last' out tail)⟩
theorem call_value (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : Value)
    (source : Call ctx before events after v) : v=.int32 0 ∨ v=.int32 1 := by
  cases source with
  | run =>
    rename_i entry result binding body conversion
    rcases ready_flow ctx entry events result body with h | h
    · rw [h] at conversion; cases conversion; exact Or.inl rfl
    · rw [h] at conversion; cases conversion; exact Or.inr rfl

theorem skipped_flag (ctx : Context) (s : State) (f : Flag) (v : Value)
    (guard : FlagTest ctx s f true v) (zero : v.integer=0) : flagPresent ctx s.heap f := by
  cases guard with
  | load word v read evaluated =>
    have h : KeygenReadyFast.NotTest s word v := evaluated
    have nonzero := KeygenReadyFast.skipped_nonzero s word v h zero
    cases read with | load binding legal bytes => exact ⟨word,bytes,nonzero⟩
theorem flag_test_legal (ctx : Context) (s : State) (f : Flag) (negated : Bool) (v : Value)
    (guard : FlagTest ctx s f negated v) : KeygenSearchContext.ObjectLegal s.heap ctx := by
  cases guard with | load word v read evaluated => cases read; assumption
theorem stored_one (ctx : Context) (f : Flag) (before after : State) (events : List KeygenEntropySource.Event)
    (source : Exec ctx (.storeFlag f (num 1)) before events ⟨after,.normal⟩) : flagPresent ctx after.heap f := by
  cases source with
  | storeFlag before flag value v heap binding evaluated write =>
    cases evaluated
    exact ⟨1,Gate00Memory.stored32_load _ _ _ _ write,by decide⟩
theorem auto_split (ctx : Context) (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx (.auto32 code) before events out) :
    ∃ block inner, KeygenRngSource.Fresh before.heap block ∧
      Exec ctx code (entered before block) events inner ∧ out=closed before inner block := by
  cases source with | auto32 code before block events inner fresh source => exact ⟨block,inner,fresh,source,rfl⟩
theorem normal_form (ctx : Context) (code : Stmt) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx code before events out) (normal : out.flow=.normal) : Exec ctx code before events ⟨out.state,.normal⟩ := by
  cases out with | mk s flow => change flow=.normal at normal; subst flow; exact source
theorem closed_flag (ctx : Context) (before : State) (out : Result) (block : Nat) (f : Flag)
    (live : KeygenSearchContext.ObjectLegal before.heap ctx) (fresh : KeygenRngSource.Fresh before.heap block)
    (flag : flagPresent ctx out.state.heap f) : flagPresent ctx (closed before out block).state.heap f := by
  have different : ctx.object.block≠block := by
    intro equal
    have extent := live.2.1
    rw [equal,fresh.1] at extent
    omega
  obtain ⟨w,bytes,nonzero⟩ := flag
  refine ⟨w,KeygenMakeEntry.load32_block out.state.heap (closed before out block).state.heap _ _ ?_ bytes,nonzero⟩
  exact ⟨by simp [closed,KeygenRngSource.disposed,field,KeygenSearchContext.field,different],
    by simp [closed,KeygenRngSource.disposed,field,KeygenSearchContext.field,different],
    fun _ => by simp [closed,KeygenRngSource.disposed,field,KeygenSearchContext.field,different]⟩
theorem seed_flag (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event)
    (source : Exec ctx seedStage before events ⟨after,.normal⟩) : flagPresent ctx after.heap .seeded := by
  cases source with
  | branchFlagFalse f negated yes no before events out v guard zero source =>
    cases source
    exact skipped_flag ctx before .seeded v guard zero
  | branchFlagTrue f negated yes no before events out v guard nonzero source =>
    have legal := flag_test_legal ctx before .seeded true v guard
    cases source with
    | scope code before events out source =>
      obtain ⟨block,inner,fresh,body,equal⟩ := auto_split ctx _ _ _ _ source
      have normal : inner.flow=.normal := (congrArg Result.flow equal).symm
      have body' := normal_form ctx _ _ _ inner body normal
      obtain ⟨middle,first,last,he,head,tail⟩ := normal_split ctx _ _ _ _ _ body'
      obtain ⟨next,first',last',he',head',tail'⟩ := normal_split ctx _ _ _ _ _ tail
      obtain ⟨stored,first'',last'',he'',head'',tail''⟩ := normal_split ctx _ _ _ _ _ tail'
      have storedEq : inner.state=stored := congrArg Result.state (skip_result ctx stored last'' ⟨inner.state,.normal⟩ tail'')
      have flag : flagPresent ctx inner.state.heap .seeded := by rw [storedEq]; exact stored_one ctx .seeded next stored first'' head''
      have final := closed_flag ctx before inner block .seeded legal fresh flag
      have stateEq := congrArg Result.state equal
      rw [← stateEq] at final
      exact final
theorem other_flag (ctx : Context) (before after : Memory) (f g : Flag) (w v : BitVec 32)
    (different : f≠g) (read : Load32 before (field ctx f) w) (write : Store32 before (field ctx g) v after) :
    Load32 after (field ctx f) w := by
  apply Gate00Memory.load32_transport _ _ _ _ read write.2.2.2.1
  intro i
  apply write.2.2.2.2.2.2
  have hi := i.isLt
  cases f <;> cases g <;> first
    | exact False.elim (different rfl)
    | dsimp [field,KeygenReadyFast.offset,KeygenSearchContext.field,ArrayPointer.offset]; omega
theorem flip_preserves_seed (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event)
    (source : Exec ctx .flip before events ⟨after,.normal⟩) (flag : flagPresent ctx before.heap .seeded) : flagPresent ctx after.heap .seeded := by
  cases source with
  | flip before after resolved source =>
    obtain ⟨w,bytes,nonzero⟩ := flag
    have keep : ∀ i : Fin 4, ShakePointFrame.Same before.heap after.heap ctx.object.block ((field ctx .seeded).offset+i.val) := by
      intro i
      exact ShakeSeedReference.flip_frame _ _ _ source _ _ (KeygenSamplerContext.fields_outside ctx _ (Or.inr (by
        dsimp [field,KeygenReadyFast.offset,KeygenSearchContext.field,ArrayPointer.offset]; omega)))
    refine ⟨w,Gate00Memory.load32_transport _ _ _ _ bytes (keep 0).1 (fun i => (keep i).2.2),nonzero⟩
theorem flip_flags (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event)
    (source : Exec ctx flipStage before events ⟨after,.normal⟩) (seeded : flagPresent ctx before.heap .seeded) :
    flagPresent ctx after.heap .seeded ∧ flagPresent ctx after.heap .flipped := by
  cases source with
  | branchFlagFalse f negated yes no before events out v guard zero source =>
    cases source; exact ⟨seeded,skipped_flag ctx before .flipped v guard zero⟩
  | branchFlagTrue f negated yes no before events out v guard nonzero source =>
    cases source with
    | scope code before events out source =>
      obtain ⟨middle,first,last,he,head,tail⟩ := normal_split ctx _ _ _ _ _ source
      obtain ⟨stored,first',last',he',head',tail'⟩ := normal_split ctx _ _ _ _ _ tail
      have equal : after=stored := congrArg Result.state (skip_result ctx stored last' ⟨after,.normal⟩ tail')
      subst after
      have firstSeed := flip_preserves_seed ctx before middle first head seeded
      have flipped := stored_one ctx .flipped middle stored first' head'
      cases head' with
      | storeFlag before flag value v heap binding evaluated write =>
        obtain ⟨w,bytes,nonzero⟩ := firstSeed
        exact ⟨⟨w,other_flag ctx _ _ .seeded .flipped w _ (by decide) bytes write,nonzero⟩,flipped⟩
theorem ready_flags (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx readyCode before events out) (success : out.flow=.returned (some (.int32 1))) :
    flagPresent ctx out.state.heap .seeded ∧ flagPresent ctx out.state.heap .flipped := by
  obtain ⟨seeded,flipped,first,last,head,tail,equal⟩ := ready_success_split ctx before events out source success
  rw [equal]
  exact flip_flags ctx seeded flipped last tail (seed_flag ctx before seeded first head)
theorem call_flags (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event)
    (source : Call ctx before events after (.int32 1)) :
    flagPresent ctx after.heap .seeded ∧ flagPresent ctx after.heap .flipped := by
  cases source with
  | run =>
    rename_i entry result binding body conversion
    have success : result.flow=.returned (some (.int32 1)) := by
      rcases ready_flow ctx entry events result body with h | h
      · rw [h] at conversion; cases conversion
      · exact h
    exact ready_flags ctx entry events result body success

end FT1536.Source3.KeygenReadyResult
