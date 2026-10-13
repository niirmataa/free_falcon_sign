import Source3.KeygenDecodeNoneIteration

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete NONE while-loop source proof: exact remaining input suffix,
   actual counter progression, real ordered stores and constructive existence.
   Local prologue cells are not asserted as the whole decoder's final premises. -/
namespace FT1536.Source3.KeygenDecodeNoneLoop
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneScalar KeygenDecodeNoneReady
open KeygenDecodeNoneMemory KeygenDecodeNoneImages KeygenDecodeNoneCounter
open KeygenDecodeNonePairs (CarrierList)

theorem source_loop (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) : stmt=loopCode →
    ∀ n : Nat, n≤1536 → ∀ src dst : ArrayPointer, ∀ inputs : List (BitVec 16),
      n+inputs.length=1536 → CarrierList inputs → Ready args n src dst s →
      ImagesAt s.heap src n inputs → WritableArray s.heap dst 1536 → src.block≠dst.block →
      flow=.normal ∧ Trace dst s.heap t.heap n inputs ∧ Ready args 1536 src dst t := by
  induction source with
  | whileDone condition body s value locals evaluated no =>
    intro shape n bound src dst inputs count carrier ready images legal separate
    cases shape
    obtain ⟨testValue,last⟩ := test_eval args s locals value n bound src dst ready evaluated
    have done : n=1536 := by
      rw [testValue] at no
      have notLess : ¬n<1536 := by simpa only [decide_eq_false_iff_not] using no
      omega
    have empty : inputs=[] := by
      cases inputs with
      | nil => rfl
      | cons input rest => simp only [List.length_cons] at count; omega
    subst inputs; subst n; subst locals
    exact ⟨rfl,.nil _ _,ready⟩
  | whileNext condition body s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    intro shape n bound src dst inputs count carrier ready images legal separate
    cases shape
    obtain ⟨testValue,last⟩ := test_eval args s locals value n bound src dst ready evaluated
    have less : n<1536 := by rw [testValue] at yes; simpa only [decide_eq_true_eq] using yes
    subst locals
    cases inputs with
    | nil => simp only [List.length_nil,Nat.add_zero] at count; omega
    | cons input inputs =>
      have firstCarrier := carrier input List.mem_cons_self
      have laterCarrier : CarrierList inputs := fun word member => carrier word (List.mem_cons_of_mem input member)
      obtain ⟨_,stored,nextReady,nextLegal,nextImages⟩ :=
        KeygenDecodeNoneIteration.source_iteration args s middle .normal n less src dst input inputs firstCarrier
          ready images legal separate iteration
      obtain ⟨normal,tail,lastReady⟩ := ih2 rfl (n+1) (by omega) src dst inputs
        (by simp only [List.length_cons] at count; omega) laterCarrier nextReady nextImages nextLegal separate
      exact ⟨normal,.cons _ _ _ n input inputs stored tail,lastReady⟩
  | whileReturn condition body s t ret value locals evaluated yes iteration ih =>
    intro shape n bound src dst inputs count carrier ready images legal separate
    cases shape
    obtain ⟨testValue,last⟩ := test_eval args s locals value n bound src dst ready evaluated
    have less : n<1536 := by rw [testValue] at yes; simpa only [decide_eq_true_eq] using yes
    subst locals
    cases inputs with
    | nil => simp only [List.length_nil,Nat.add_zero] at count; omega
    | cons input inputs =>
      have normal := (KeygenDecodeNoneIteration.source_iteration args s t (.returned ret) n less src dst input inputs
        (carrier input List.mem_cons_self) ready images legal separate iteration).1
      cases normal
  | skip | declare | bind | scalar | store | increment | evaluate | seq | seqReturn | scope | branchTrue | branchFalse | forLoop | ret =>
    intro shape
    cases shape

/-- The source loop has a finite honest execution on all centered physical
    inputs and legal writable destination arrays, regardless of their old values. -/
theorem loop_exists (args : Args) (s : State) (n : Nat) (src dst : ArrayPointer)
    (inputs : List (BitVec 16)) (count : n+inputs.length=1536) (carrier : CarrierList inputs)
    (ready : Ready args n src dst s) (images : ImagesAt s.heap src n inputs)
    (legal : WritableArray s.heap dst 1536) (separate : src.block≠dst.block) :
    ∃ after, Exec args loopCode s after .normal := by
  induction inputs generalizing n s with
  | nil =>
    simp only [List.length_nil,Nat.add_zero] at count
    subst n
    have calculated := computes_exists args s.heap s.buf s.locals _ _
      (test_calculation args s 1536 (by decide +kernel) src dst ready)
    have evaluated : Eval args s.heap s.buf test s.locals (.integer (.int32 0)) s.locals := by
      simpa only [show ¬(1536 : Nat)<1536 by decide +kernel,ite_false] using calculated
    exact ⟨s,.whileDone args _ _ s (.integer (.int32 0)) s.locals evaluated rfl⟩
  | cons input rest ih =>
    have less : n<1536 := by simp only [List.length_cons] at count; omega
    have firstCarrier := carrier input List.mem_cons_self
    have laterCarrier : CarrierList rest := fun word member => carrier word (List.mem_cons_of_mem input member)
    obtain ⟨middle,iteration,_,nextReady,nextLegal,nextImages⟩ :=
      KeygenDecodeNoneIteration.iteration_exists args s n less src dst input rest firstCarrier ready images legal separate
    obtain ⟨after,remaining⟩ := ih middle (n+1) (by simp only [List.length_cons] at count; omega)
      laterCarrier nextReady nextImages nextLegal
    have calculated := computes_exists args s.heap s.buf s.locals _ _
      (test_calculation args s n (by omega) src dst ready)
    have evaluated : Eval args s.heap s.buf test s.locals (.integer (.int32 1)) s.locals := by
      simpa only [less,ite_true] using calculated
    exact ⟨after,.whileNext args _ _ s middle after .normal (.integer (.int32 1)) s.locals evaluated rfl iteration remaining⟩

end FT1536.Source3.KeygenDecodeNoneLoop
