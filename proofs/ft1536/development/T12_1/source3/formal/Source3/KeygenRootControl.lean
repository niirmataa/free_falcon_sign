import Source3.KeygenRootSearch

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reachable root control: the M0 tests select the ternary arm, and the
   actual unsigned post-decrement calls depths 9,...,1, then leaves zero.
   These are execution consequences, not depth/profile premises at each call. -/
namespace FT1536.Source3.KeygenRootControl
open KeygenRootSearch
open C99ArrayReference (State bindValue)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem load32_same_bytes (before after : Memory) (p : ArrayPointer) (a b : BitVec 32)
    (first : Load32 before p a) (second : Load32 after p b)
    (same : ∀ offset, after.bytes p.block offset=before.bytes p.block offset) : b=a := by
  cases first with
  | load x allocated width bytes =>
    cases second with
    | load y allocated' width' bytes' =>
      have equal : y=x := by
        funext i
        exact Option.some.inj ((bytes' i).symm.trans ((same _).trans (bytes i)))
      rw [equal]
theorem ternary_after (ctx : Context) (before : State) (out : Result)
    (profile : KeygenSearchContext.M0 before.heap ctx) (source : Exec ctx before out)
    (separate : Protected ctx before ctx.object.block) (word : BitVec 32)
    (read : KeygenSearchContext.ReadTernary ctx out.state word) : word=1 := by
  have keep := (frame ctx before out source profile ctx.object.block separate).2.2.2
  cases read with
  | read binding legal bytes => exact load32_same_bytes before.heap out.state.heap _ _ word profile.2 bytes keep
theorem dispatch_enabled (ctx : Context) (before entry deep : State)
    (profile : KeygenSearchContext.M0 before.heap ctx) (start : Start ctx before entry)
    (deepest : Gate ctx .deepest entry ⟨deep,.normal⟩)
    (separate : Protected ctx before ctx.object.block)
    (test logn : Value) (ternary : BitVec 32)
    (small : C99ArrayReference.scalar deep smallTest test)
    (lognRead : C99ArrayReference.scalar deep (.var "logn".toList) logn)
    (member : KeygenSearchContext.ReadTernary ctx (depthEntry deep logn) ternary) :
    test=.int32 0 ∧ logn=.uint32 10 ∧ ternary=1 := by
  have he := start_m0 ctx before entry profile start
  subst entry
  obtain ⟨hl,_,_,keep⟩ := gate_frame ctx .deepest (ready before) _ deepest ctx.object.block separate
  have slot : deep.locals "logn".toList=some (.uint32,some (.uint32 10)) := (congrFun hl _).trans rfl
  have hn := C99CountedWords.variable_exact deep _ .uint32 (.uint32 10) logn slot lognRead
  have ht : test=.int32 0 := by
    change C99ScalarReference.Eval _ _ (.compare .le (.variable "logn".toList) (.literal .int32 2)) test at small
    cases small with
    | compare op a b x y z left right operation =>
      have hx := C99CountedWords.variable_exact deep _ .uint32 (.uint32 10) x slot left
      subst x
      cases right
      exact C99CountedWords.comparison_result _ _ _ _ operation
  refine ⟨ht,hn,?_⟩
  cases member with
  | read binding legal bytes => exact load32_same_bytes before.heap _ _ _ ternary profile.2 bytes keep

def Counter (s : State) (i : Nat) : Prop :=
  s.locals "depth".toList=some (.uint32,some (.uint32 (BitVec.ofNat 32 i)))
def decremented (s : State) (i : Nat) : State :=
  bindValue s "depth".toList .uint32 (.uint32 (BitVec.ofNat 32 (i-1)))
theorem post_exact (before after : State) (test : Value) (i : Nat) (lo : 1 ≤ i) (hi : i ≤ 10)
    (counter : Counter before i) (source : Post before after test) :
    after=decremented before i ∧ test=C99ScalarReference.boolean (decide (1 < i)) := by
  cases source with
  | run old next test read declared decrement compare =>
    have ho := C99CountedWords.variable_exact before _ .uint32 (.uint32 (BitVec.ofNat 32 i)) old counter read
    subst old
    have hn := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp decrement).2
    have ht := C99CountedWords.comparison_result _ _ _ _ compare
    interval_cases i <;> (rw [hn,ht]; exact ⟨rfl,rfl⟩)
theorem decremented_counter (before : State) (i : Nat) : Counter (decremented before i) (i-1) := by
  change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 (BitVec.ofNat 32 (i-1))).integer))=_
  rw [show C99IntegerReference.convert .uint32 (Value.uint32 (BitVec.ofNat 32 (i-1))).integer=
    .uint32 (BitVec.ofNat 32 (i-1)) from C99CountedWords.convert_self (.uint32 (BitVec.ofNat 32 (i-1)))]

/- The trace contains actual fixed intermediate calls and their caller
   depth slot, while the false test is retained separately at its end. -/
inductive Trace (ctx : Context) : List Nat → State → State → Prop where
  | done (before after : State) (v : Value) (test : Post before after v) (zero : v.integer=0) :
      Trace ctx [] before after
  | step (depth : Nat) (rest : List Nat) (before next middle after : State) (v : Value)
      (test : Post before next v) (nonzero : v.integer≠0) (counter : Counter next depth)
      (call : Gate ctx .intermediate next ⟨middle,.normal⟩) (tail : Trace ctx rest middle after) :
      Trace ctx (depth::rest) before after
def depths (i : Nat) : List Nat := ((List.range i).drop 1).reverse
theorem depths_step (i : Nat) (positive : 0 < i) : depths (i+1)=i::depths i := by
  rw [depths,List.range_succ,List.drop_append_of_le_length (by simp only [List.length_range]; omega),List.reverse_append]
  rfl
theorem loop_trace (ctx : Context) (before : State) (out : Result) (source : Loop ctx before out)
    (normal : out.flow=.normal) (i : Nat) (lo : 1 ≤ i) (hi : i ≤ 10) (counter : Counter before i)
    (block : Nat) (separate : Protected ctx before block) :
    Trace ctx (depths i) before out.state ∧ Counter out.state 0 := by
  induction source generalizing i with
  | done before next v test zero =>
    obtain ⟨state,value⟩ := post_exact before next v i lo hi counter test
    have last : i=1 := by
      by_contra h
      have strict : 1 < i := by omega
      rw [value] at zero
      simp only [strict,decide_true,C99ScalarReference.boolean,Value.integer] at zero
      norm_num at zero
    subst i next
    exact ⟨.done before _ v test zero,decremented_counter before 1⟩
  | step before next middle out v test nonzero call tail ih =>
    obtain ⟨state,value⟩ := post_exact before next v i lo hi counter test
    have strict : 1 < i := by
      by_contra h
      rw [value] at nonzero
      simp only [h,decide_false,C99ScalarReference.boolean,Value.integer] at nonzero
      exact nonzero rfl
    have nextCounter : Counter next (i-1) := by rw [state]; exact decremented_counter before i
    have post := post_frame before next v test
    have nextProtected : Protected ctx next block := ⟨separate.1,by simpa only [post.2.2.1] using separate.2⟩
    obtain ⟨hl,_,ht,_⟩ := gate_frame ctx .intermediate next _ call block nextProtected
    change middle.tables=next.tables at ht
    have middleCounter : Counter middle (i-1) := (congrFun hl _).trans nextCounter
    obtain ⟨trace,last⟩ := ih normal (i-1) (by omega) (by omega) middleCounter
      ⟨nextProtected.1,by simpa only [ht] using nextProtected.2⟩
    have decomposition : depths i=(i-1)::depths (i-1) := by
      have add : i=(i-1)+1 := by omega
      conv_lhs => rw [add]
      exact depths_step (i-1) (by omega)
    rw [decomposition]
    exact ⟨.step (i-1) _ before next middle out.state v test nonzero nextCounter call trace,last⟩
  | reject => cases normal
theorem m0_depths : depths 10=[9,8,7,6,5,4,3,2,1] := by decide

end FT1536.Source3.KeygenRootControl
