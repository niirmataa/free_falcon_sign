import Source3.KeygenSmallSource
import Source3.KeygenCheckLoopBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSmallStep
open C99ArrayReference (State bindValue restoreScope)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99MemoryReference
open KeygenSmallSource

def abortFlow : C99ProcedureReference.Flow := .returned (some (.int32 0))
def declared (s : State) : State :=
  {s with locals := C99ScalarReference.set s.locals "z".toList (.int32,none)}
def assigned (s : State) (w : BitVec 32) : State := bindValue (declared s) "z".toList .int32 (.int32 w)
def tailStore : Stmt := chain [.store16 "d".toList (var "u") (var "z")]
def tailGate : Stmt := .seq gate tailStore
def tailCall : Stmt := .seq (.plain "z".toList "s".toList (var "u")) tailGate

theorem skip_result (s : State) (out : Result) (source : Exec skip s out) : out=⟨s,.normal⟩ := by
  cases source with
  | modular _ _ _ body => exact C99ModularReference.skip_result s out body

theorem ret_result (n : Nat) (s : State) (out : Result) (source : Exec (ret n) s out) :
    out=⟨s,.returned (some (C99IntegerReference.convert .int32 n))⟩ := by
  cases source with
  | modular _ _ _ body => exact KeygenCheckGate.return_literal n s out body

theorem reject_result (s : State) (out : Result) (source : Exec (.scope [] (chain [ret 0])) s out) :
    out=⟨s,abortFlow⟩ := by
  cases source with
  | scope _ _ _ inner body =>
    have he : inner=⟨s,abortFlow⟩ := by
      cases body with
      | seqNormal _ _ _ mid _ first _ =>
        have hf := congrArg Result.flow (ret_result 0 s ⟨mid,.normal⟩ first)
        cases hf
      | seqExit _ _ _ _ first _ => exact ret_result 0 s inner first
    rw [he]
    rfl

theorem compare_signed (op : C99IntegerReference.Comparison) (a b : BitVec 32) (v : Value)
    (source : C99IntegerReference.CompareExec op (.int32 a) (.int32 b) v) :
    v=C99ScalarReference.boolean (C99IntegerReference.compare op a.toInt b.toInt) := by
  have he := C99CountedWords.comparison_result op (.int32 a) (.int32 b) v source
  change v=C99ScalarReference.boolean (C99IntegerReference.compare op
    (C99IntegerReference.convert (Value.int32 a).type (Value.int32 a).integer).integer
    (C99IntegerReference.convert (Value.int32 b).type (Value.int32 b).integer).integer) at he
  rw [C99CountedWords.convert_self,C99CountedWords.convert_self] at he
  exact he

theorem lower_compare (s : State) (w : BitVec 32) (v : Value)
    (slot : s.locals "z".toList=some (.int32,some (.int32 w)))
    (source : C99ArrayReference.scalar s (.cmp .lt (var "z") (.neg (number 2047))) v) :
    v=C99ScalarReference.boolean (decide (w.toInt < -2047)) := by
  change C99ScalarReference.Eval _ _
    (.compare .lt (.variable "z".toList) (.neg (.literal .int32 2047))) v at source
  cases source with
  | compare _ _ _ x y v hx hy operation =>
    have he := C99CountedWords.variable_exact s "z".toList .int32 (.int32 w) x slot hx
    subst x
    have hy0 : y=.int32 (BitVec.ofInt 32 (-2047)) := by
      cases hy with
      | neg _ x y ev op =>
        cases ev
        exact (C99IntegerReference.neg_iff _ _ |>.mp op).2
    subst y
    exact compare_signed .lt w (BitVec.ofInt 32 (-2047)) v operation

theorem upper_compare (s : State) (w : BitVec 32) (v : Value)
    (slot : s.locals "z".toList=some (.int32,some (.int32 w)))
    (source : C99ArrayReference.scalar s (.cmp .gt (var "z") (number 2047)) v) :
    v=C99ScalarReference.boolean (decide (2047 < w.toInt)) := by
  change C99ScalarReference.Eval _ _
    (.compare .gt (.variable "z".toList) (.literal .int32 2047)) v at source
  cases source with
  | compare _ _ _ x y v hx hy operation =>
    have he := C99CountedWords.variable_exact s "z".toList .int32 (.int32 w) x slot hx
    subst x
    cases hy
    exact compare_signed .gt w 2047 v operation

theorem guard_bounds (s : State) (w : BitVec 32) (v : Value)
    (slot : s.locals "z".toList=some (.int32,some (.int32 w)))
    (source : C99ArrayReference.scalar s guard v) (zero : v.integer=0) :
    KeygenSmallOutput.accepted w.toInt := by
  change C99ScalarReference.Eval _ _ (.logicalOr _ _) v at source
  cases source with
  | orTrue => cases zero
  | orFalse a b x y hx hz hy =>
    have hlo := lower_compare s w x slot hx
    have hhi := upper_compare s w y slot hy
    have lo : ¬w.toInt < -2047 := by
      intro h
      rw [hlo] at hz
      simp [h,C99ScalarReference.boolean,Value.integer] at hz
    have hi : ¬2047 < w.toInt := by
      intro h
      rw [hhi] at zero
      simp [h,C99ScalarReference.boolean,Value.integer] at zero
    exact fun h => h.elim lo hi

theorem gate_cases (s : State) (w : BitVec 32) (out : Result)
    (slot : s.locals "z".toList=some (.int32,some (.int32 w)))
    (source : Exec gate s out) :
    (out=⟨s,.normal⟩ ∧ KeygenSmallOutput.accepted w.toInt) ∨ out=⟨s,abortFlow⟩ := by
  cases source with
  | branchTrue _ _ _ _ _ v condition nonzero body => exact Or.inr (reject_result s out body)
  | branchFalse _ _ _ _ _ v condition zero body =>
    exact Or.inl ⟨skip_result s out body,guard_bounds s w v slot condition zero⟩

theorem assigned_slot (s : State) (w : BitVec 32) :
    (assigned s w).locals "z".toList=some (.int32,some (.int32 w)) := by
  change some (C99IntegerReference.Ty.int32,some (C99IntegerReference.convert (Value.int32 w).type (Value.int32 w).integer))=_
  rw [C99CountedWords.convert_self]

theorem assigned_counter (s : State) (w : BitVec 32) (i : Nat) (h : C99CountedWords.Counter s i) :
    C99CountedWords.Counter (assigned s w) i := by
  simpa [C99CountedWords.Counter,assigned,declared,bindValue,C99ScalarReference.set] using h

theorem restored (s : State) (w : BitVec 32) (heap : Memory) :
    restoreScope s {assigned s w with heap := heap} ["z".toList] []={s with heap := heap} := by
  have hl : C99ScalarReference.restore s.locals (assigned s w).locals ["z".toList]=s.locals := by
    funext name
    by_cases h : name=['z'] <;>
      simp [C99ScalarReference.restore,assigned,declared,bindValue,C99ScalarReference.set,h]
  change { s with locals := C99ScalarReference.restore s.locals (assigned s w).locals ["z".toList]
                  heap := heap }=_
  rw [hl]

theorem call_result (s : State) (out : Result)
    (source : Exec (.plain "z".toList "s".toList (var "u")) (declared s) out) :
    ∃ w : BitVec 32, out=⟨assigned s w,.normal⟩ := by
  cases source with
  | plain _ _ _ _ p ty old v address binding call =>
    have ht : ty=.int32 := congrArg Prod.fst (Option.some.inj binding.symm)
    subst ty
    obtain ⟨w,he⟩ := plain_signed _ p v call
    subst v
    exact ⟨w,rfl⟩

theorem store_result (s : State) (w : BitVec 32) (dst : ArrayPointer) (i : Nat) (out : Result)
    (hi : i≤1536) (counter : C99CountedWords.Counter s i)
    (binding : s.arrays "d".toList=some dst)
    (source : Exec tailStore (assigned s w) out) :
    out.flow=.normal ∧ out.state={assigned s w with heap := out.state.heap} ∧
      KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element dst i) (BitVec.ofInt 16 w.toInt) out.state.heap := by
  cases source with
  | seqNormal _ _ _ middle _ head tail =>
    cases head with
    | store16 _ _ _ _ heap p v address evaluated store =>
      have he := C99CountedWords.pointer_exact (assigned s w) "d".toList dst p i hi
        (assigned_counter s w i counter) binding address
      have hv := C99CountedWords.variable_exact (assigned s w) "z".toList .int32 (.int32 w) v
        (assigned_slot s w) evaluated
      subst p v
      rw [skip_result _ out tail]
      exact ⟨rfl,rfl,store⟩
  | seqExit _ _ _ _ head exit => cases head; exact (exit rfl).elim

theorem gate_tail (s : State) (w : BitVec 32) (dst : ArrayPointer) (i : Nat) (out : Result)
    (hi : i≤1536) (counter : C99CountedWords.Counter s i) (binding : s.arrays "d".toList=some dst)
    (source : Exec tailGate (assigned s w) out) :
    (out.flow=.normal ∧ out.state={assigned s w with heap := out.state.heap} ∧
      KeygenSmallOutput.accepted w.toInt ∧
      KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element dst i) (BitVec.ofInt 16 w.toInt) out.state.heap)
    ∨ out=⟨assigned s w,abortFlow⟩ := by
  cases source with
  | seqNormal _ _ _ middle _ head tail =>
    rcases gate_cases _ w ⟨middle,.normal⟩ (assigned_slot s w) head with ⟨hm,bound⟩ | aborted
    · have hm0 := congrArg Result.state hm
      change middle=assigned s w at hm0
      subst middle
      obtain ⟨normal,equal,write⟩ := store_result s w dst i out hi counter binding tail
      exact Or.inl ⟨normal,equal,bound,write⟩
    · cases congrArg Result.flow aborted
  | seqExit _ _ _ _ head exit =>
    rcases gate_cases _ w out (assigned_slot s w) head with ⟨hm,_⟩ | aborted
    · exact (exit (congrArg Result.flow hm)).elim
    · exact Or.inr aborted

theorem iteration_cases (s : State) (dst : ArrayPointer) (i : Nat) (out : Result)
    (hi : i≤1536) (counter : C99CountedWords.Counter s i) (binding : s.arrays "d".toList=some dst)
    (source : Exec iteration s out) :
    (out.flow=.normal ∧ out.state={s with heap := out.state.heap} ∧
      ∃ z : Int, KeygenSmallOutput.accepted z ∧
        KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element dst i) (BitVec.ofInt 16 z) out.state.heap)
    ∨ out=⟨s,abortFlow⟩ := by
  cases source with
  | scope _ _ _ inner body =>
    have tail : Exec tailCall (declared s) inner := by
      cases body with
      | seqNormal _ _ _ middle _ head tail =>
        cases head with
        | modular _ _ _ hd =>
          obtain ⟨mid,hd,he⟩ := KeygenNttForwardExec.base_inv _ s ⟨middle,.normal⟩ hd
          have hm := C99DeclarationStatements.source_result .i32 ["z".toList] s mid hd
          have hmid := congrArg Result.state he
          change middle=mid at hmid
          subst middle mid
          exact tail
      | seqExit _ _ _ _ head exit =>
        cases head with
        | modular _ _ _ hd =>
          obtain ⟨mid,hd,he⟩ := KeygenNttForwardExec.base_inv _ s inner hd
          exact (exit (congrArg Result.flow he)).elim
    have hc : ∃ w : BitVec 32, Exec tailGate (assigned s w) inner := by
      cases tail with
      | seqNormal _ _ _ middle _ head rest =>
        obtain ⟨w,he⟩ := call_result s ⟨middle,.normal⟩ head
        have hm := congrArg Result.state he
        change middle=assigned s w at hm
        subst middle
        exact ⟨w,rest⟩
      | seqExit _ _ _ _ head exit =>
        obtain ⟨w,he⟩ := call_result s inner head
        exact (exit (congrArg Result.flow he)).elim
    obtain ⟨w,tail⟩ := hc
    rcases gate_tail s w dst i inner hi counter binding tail with ⟨normal,equal,bound,write⟩ | aborted
    · left
      refine ⟨normal,?_,w.toInt,bound,write⟩
      change restoreScope s inner.state ["z".toList] []={s with heap := inner.state.heap}
      conv_lhs => rw [equal]
      exact restored s w inner.state.heap
    · right
      rw [aborted]
      exact congrArg (fun t => (⟨t,abortFlow⟩ : Result)) (restored s w s.heap)

end FT1536.Source3.KeygenSmallStep
