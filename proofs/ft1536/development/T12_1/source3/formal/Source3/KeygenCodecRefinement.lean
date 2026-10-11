import Source3.KeygenCodecExecution
import Source3.KeygenCodecFootprint

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Erase evaluated values, local updates and branch tests from finite
   typed reference executions. The heap is identical on both sides.
   Projection execution and the desired frame are conclusions. -/
namespace FT1536.Source3.KeygenCodecRefinement
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

def flow : KeygenCodecExecution.Flow → KeygenCodecFootprint.Flow
  | .normal => .normal | .returned _ => .returned

/-- NULL and uninitialized buf impose no abstract pointer requirement;
    every actual non-NULL buf must match the projected pointer exactly.
    In particular a NULL dry run can never use the projected store rule. -/
structure Match (s : State) (p : KeygenCodecFootprint.State) : Prop where
  heap : p.heap=s.heap
  buffer : ∀ b, s.buf=some (some b) → p.buf=some b

def Out (args : Args) (dst : ArrayPointer) : Prop := ∀ p, args.out=some p → p=dst

theorem match_locals (s : State) (p : KeygenCodecFootprint.State) (locals : Locals)
    (matched : Match s p) : Match (withLocals s locals) p := ⟨matched.heap,matched.buffer⟩

theorem match_initial (args : Args) (heap : Memory) (p : KeygenCodecFootprint.State)
    (same : p.heap=heap) : Match (initial args heap) p :=
  ⟨same,by intro b held; cases held⟩

theorem body_project (destination : Callee) :
    KeygenCodecFootprint.project (KeygenCodecExecution.body destination)=
      some (KeygenCodecFootprint.body destination) := by
  cases destination
  · exact KeygenCodecFootprint.none_complete
  · exact KeygenCodecFootprint.static_complete

theorem desugar_project (initial : Stmt) (test : Option Expr) (increment body : Stmt)
    (code : KeygenCodecFootprint.Code)
    (projected : KeygenCodecFootprint.project (.loop initial test increment body)=some code) :
    KeygenCodecFootprint.project (desugar initial test increment body)=some code := by
  cases ha : KeygenCodecFootprint.project initial <;>
    cases hb : KeygenCodecFootprint.project body <;>
    cases hc : KeygenCodecFootprint.project increment <;>
    cases test <;> simp_all [desugar,testExpr,KeygenCodecFootprint.project,KeygenCodecFootprint.readEffect]

theorem branch_project (test : Expr) (a b : Stmt) (code : KeygenCodecFootprint.Code)
    (projected : KeygenCodecFootprint.project (.branch test a b)=some code) :
    ∃ ca cb, KeygenCodecFootprint.project a=some ca ∧ KeygenCodecFootprint.project b=some cb ∧ code=.either ca cb := by
  cases ht : KeygenCodecFootprint.readEffect test <;>
    cases ha : KeygenCodecFootprint.project a <;> cases hb : KeygenCodecFootprint.project b <;>
    simp_all [KeygenCodecFootprint.project]

theorem while_project (test : Expr) (a : Stmt) (code : KeygenCodecFootprint.Code)
    (projected : KeygenCodecFootprint.project (.whileLoop test a)=some code) :
    ∃ ca, KeygenCodecFootprint.project a=some ca ∧ code=.loop ca := by
  cases ht : KeygenCodecFootprint.readEffect test <;> cases ha : KeygenCodecFootprint.project a <;>
    simp_all [KeygenCodecFootprint.project]

theorem switch_project (test : Expr) (a b c : Stmt) (code : KeygenCodecFootprint.Code)
    (projected : KeygenCodecFootprint.project (.switch test a b c)=some code) :
    ∃ ca cb cc, KeygenCodecFootprint.project a=some ca ∧ KeygenCodecFootprint.project b=some cb ∧
      KeygenCodecFootprint.project c=some cc ∧ code=.either ca (.either cb cc) := by
  cases ht : KeygenCodecFootprint.readEffect test <;> cases ha : KeygenCodecFootprint.project a <;>
    cases hb : KeygenCodecFootprint.project b <;> cases hc : KeygenCodecFootprint.project c <;>
    simp_all [KeygenCodecFootprint.project]

/-- Every supported typed execution has a projected execution on the SAME
    before/after heaps. Neither the path, return value nor write frame is
    supplied to the target semantics. The Out premise only identifies the
    actual destination pointer; for a NULL dry run it is vacuous. -/
theorem exec_projection (args : Args) (statement : Stmt) (s t : State)
    (result : KeygenCodecExecution.Flow) (source : Exec args statement s t result) :
    ∀ dst, Out args dst → ∀ code, KeygenCodecFootprint.project statement=some code →
      ∀ p, Match s p → ∃ q, KeygenCodecFootprint.Exec dst code p q (flow result) ∧ Match t q := by
  induction source with
  | skip args s =>
    intro dst output code projected p matched
    have equal : code=.idle := Option.some.inj projected.symm
    subst code
    exact ⟨p,.idle p,matched.heap,matched.buffer⟩
  | declare args s objects locals declarations =>
    intro dst output code projected p matched
    by_cases has : hasBuf objects=true
    · have equal : code=.clear := by
        change some (if hasBuf objects then .clear else .idle)=some code at projected
        rw [has] at projected
        exact Option.some.inj projected.symm
      subst code
      refine ⟨{p with buf := none},.clear p,matched.heap,?_⟩
      intro b held
      simp [declared,has] at held
    · have no : hasBuf objects=false := Bool.eq_false_iff.mpr has
      have equal : code=.idle := by
        change some (if hasBuf objects then .clear else .idle)=some code at projected
        rw [no] at projected
        exact Option.some.inj projected.symm
      subst code
      exact ⟨p,.idle p,matched.heap,by simpa [declared,no] using matched.buffer⟩
  | bind args s =>
    intro dst output code projected p matched
    have equal : code=.bind := by simpa [KeygenCodecFootprint.project] using projected.symm
    subst code
    refine ⟨{p with buf := some dst},.bind p,matched.heap,?_⟩
    intro b held
    have actual : args.out=some b := Option.some.inj held
    rw [output b actual]
  | scalar args s name op rhs ty old value assignedValue locals notBuf notOut declared evaluated assigned =>
    intro dst output code projected p matched
    have equal : code=.idle := by
      simp only [KeygenCodecFootprint.project,notBuf,ite_false] at projected
      split at projected <;> simp_all
    subst code
    exact ⟨p,.idle p,matched.heap,matched.buffer⟩
  | store args s index rhs m t ptr offset value after buffer indexValue nonnegative rhsValue write =>
    intro dst output code projected p matched
    have equal : code=.store := by
      simp only [KeygenCodecFootprint.project] at projected
      split at projected <;> simp_all
    subst code
    refine ⟨⟨after,p.buf⟩,KeygenCodecFootprint.Exec.store p ptr offset.integer.toNat
      (BitVec.ofInt 8 value.integer) after (matched.buffer ptr buffer) ?_,rfl,matched.buffer⟩
    simpa only [StoreByte,byteOff,KeygenMakeInvocation.StoreByte,KeygenMakeInvocation.byteOff,matched.heap] using write
  | increment args s name locals old value step =>
    intro dst output code projected p matched
    have equal : code=.idle := by
      simp only [KeygenCodecFootprint.project] at projected
      split at projected <;> simp_all
    subst code
    exact ⟨p,.idle p,matched.heap,matched.buffer⟩
  | evaluate args s e value locals evaluated =>
    intro dst output code projected p matched
    have equal : code=.idle := by
      simp only [KeygenCodecFootprint.project] at projected
      split at projected <;> simp_all
    subst code
    exact ⟨p,.idle p,matched.heap,matched.buffer⟩
  | seq args a b s m t result first second ih1 ih2 =>
    intro dst output code projected p matched
    cases ha : KeygenCodecFootprint.project a with
    | none => simp [KeygenCodecFootprint.project,ha] at projected
    | some ca =>
      cases hb : KeygenCodecFootprint.project b with
      | none => simp [KeygenCodecFootprint.project,ha,hb] at projected
      | some cb =>
        have equal : code=.seq ca cb := by simpa [KeygenCodecFootprint.project,ha,hb] using projected.symm
        subst code
        obtain ⟨middle,exec1,match1⟩ := ih1 dst output ca ha p matched
        obtain ⟨last,exec2,match2⟩ := ih2 dst output cb hb middle match1
        exact ⟨last,.seq ca cb p middle last (flow result) exec1 exec2,match2⟩
  | seqReturn args a b s t value first ih =>
    intro dst output code projected p matched
    cases ha : KeygenCodecFootprint.project a with
    | none => simp [KeygenCodecFootprint.project,ha] at projected
    | some ca =>
      cases hb : KeygenCodecFootprint.project b with
      | none => simp [KeygenCodecFootprint.project,ha,hb] at projected
      | some cb =>
        have equal : code=.seq ca cb := by simpa [KeygenCodecFootprint.project,ha,hb] using projected.symm
        subst code
        obtain ⟨last,execution,matchLast⟩ := ih dst output ca ha p matched
        exact ⟨last,.seqReturn ca cb p last execution,matchLast⟩
  | scope args a s t result noBufShadow inside ih =>
    intro dst output code projected p matched
    obtain ⟨last,execution,matchLast⟩ := ih dst output code projected p matched
    refine ⟨last,execution,matchLast.heap,?_⟩
    intro b held
    by_cases has : hasBuf (scopeObjects a)=true
    · have absent := noBufShadow has
      simp [scopeExit,has,absent] at held
    · have no : hasBuf (scopeObjects a)=false := Bool.eq_false_iff.mpr has
      exact matchLast.buffer b (by simpa [scopeExit,no] using held)
  | branchTrue args test a b s t result value locals evaluated yes selected ih =>
    intro dst output code projected p matched
    obtain ⟨ca,cb,ha,hb,equal⟩ := branch_project test a b code projected
    subst code
    obtain ⟨last,execution,matchLast⟩ := ih dst output ca ha p (match_locals s p locals matched)
    exact ⟨last,.left ca cb p last (flow result) execution,matchLast⟩
  | branchFalse args test a b s t result value locals evaluated no selected ih =>
    intro dst output code projected p matched
    obtain ⟨ca,cb,ha,hb,equal⟩ := branch_project test a b code projected
    subst code
    obtain ⟨last,execution,matchLast⟩ := ih dst output cb hb p (match_locals s p locals matched)
    exact ⟨last,.right ca cb p last (flow result) execution,matchLast⟩
  | whileDone args test a s value locals evaluated no =>
    intro dst output code projected p matched
    obtain ⟨ca,ha,equal⟩ := while_project test a code projected
    subst code
    exact ⟨p,.loopDone ca p,matched.heap,matched.buffer⟩
  | whileNext args test a s m t result value locals evaluated yes iteration rest ih1 ih2 =>
    intro dst output code projected p matched
    have original := projected
    obtain ⟨ca,ha,equal⟩ := while_project test a code projected
    subst code
    obtain ⟨middle,exec1,match1⟩ := ih1 dst output ca ha p (match_locals s p locals matched)
    obtain ⟨last,exec2,match2⟩ := ih2 dst output (.loop ca) original middle match1
    exact ⟨last,.loopNext ca p middle last (flow result) exec1 exec2,match2⟩
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    intro dst output code projected p matched
    obtain ⟨ca,ha,equal⟩ := while_project test a code projected
    subst code
    obtain ⟨last,execution,matchLast⟩ := ih dst output ca ha p (match_locals s p locals matched)
    exact ⟨last,.loopReturn ca p last execution,matchLast⟩
  | forLoop args initial test increment body s t result expanded ih =>
    intro dst output code projected p matched
    exact ih dst output code (desugar_project initial test increment body code projected) p matched
  | switchNone args test a b c s t result value locals evaluated zero selected ih =>
    intro dst output code projected p matched
    obtain ⟨ca,cb,cc,ha,hb,hc,equal⟩ := switch_project test a b c code projected
    subst code
    obtain ⟨last,execution,matchLast⟩ := ih dst output ca ha p (match_locals s p locals matched)
    exact ⟨last,.left ca (.either cb cc) p last (flow result) execution,matchLast⟩
  | switchStatic args test a b c s t result value locals evaluated one selected ih =>
    intro dst output code projected p matched
    obtain ⟨ca,cb,cc,ha,hb,hc,equal⟩ := switch_project test a b c code projected
    subst code
    obtain ⟨last,execution,matchLast⟩ := ih dst output cb hb p (match_locals s p locals matched)
    exact ⟨last,.right ca (.either cb cc) p last (flow result) (.left cb cc p last (flow result) execution),matchLast⟩
  | switchOther args test a b c s t result value locals evaluated notZero notOne selected ih =>
    intro dst output code projected p matched
    obtain ⟨ca,cb,cc,ha,hb,hc,equal⟩ := switch_project test a b c code projected
    subst code
    obtain ⟨last,execution,matchLast⟩ := ih dst output cc hc p (match_locals s p locals matched)
    exact ⟨last,.right ca (.either cb cc) p last (flow result) (.right cb cc p last (flow result) execution),matchLast⟩
  | ret args s e value locals evaluated =>
    intro dst output code projected p matched
    have notCall : ∀ destination arguments, e≠.call destination arguments := by
      intro destination arguments equal
      subst e
      cases evaluated
    have equal : code=.ret := by
      cases e <;> simp only [KeygenCodecFootprint.project] at projected
      all_goals first
        | exact False.elim (notCall _ _ rfl)
        | (split at projected <;> simp_all)
    subst code
    exact ⟨p,.ret p,matched.heap,matched.buffer⟩
  | call args called destination s t ret arguments execution ih =>
    intro dst output code projected p matched
    have equal : code=.call destination := by simpa [KeygenCodecFootprint.project,KeygenCodecValues.calleeArgs,KeygenCodecFootprint.calleeArgs] using projected.symm
    subst code
    have calledOut : Out called dst := by
      intro b held
      exact output b (arguments.out.symm.trans held)
    obtain ⟨last,executed,matchedLast⟩ := ih dst calledOut (KeygenCodecFootprint.body destination)
      (body_project destination) p (match_initial called s.heap p matched.heap)
    exact ⟨last,.call destination p last .returned executed,matchedLast⟩

theorem call_projection (args : Args) (before after : Memory) (ret : BitVec 64)
    (source : Call args before after ret) (dst : ArrayPointer) (output : Out args dst) :
    KeygenCodecFootprint.Run dst before after := by
  obtain ⟨last,execution,same⟩ := source
  obtain ⟨projected,run,matched⟩ := exec_projection args _ _ _ _ execution dst output
    KeygenCodecFootprint.dispatchCode KeygenCodecFootprint.dispatch_complete ⟨before,none⟩
    (match_initial args before _ rfl)
  exact ⟨projected,.returned,run,matched.heap.trans same⟩

theorem call_frame (args : Args) (before after : Memory) (ret : BitVec 64)
    (source : Call args before after ret) (dst : ArrayPointer) (output : Out args dst) :
    KeygenCodecFootprint.Frame dst before after :=
  KeygenCodecFootprint.run_frame dst before after (call_projection args before after ret source dst output)

end FT1536.Source3.KeygenCodecRefinement
