import Source3.KeygenSmallStep
import Source3.KeygenTernaryBound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The complete MODE1 tail AFTER the refill branch: extract two bits,
   shift the buffer, decrement rbits, reject or store and break. The refill,
   surrounding loops and SHAKE calls are separate source obligations. This
   module has no random-word oracle or probability premise. -/
namespace FT1536.Source3.KeygenTernaryStore
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99MemoryReference

def var (s : String) : CLogic.Expr := .var s.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def extract : C99ModularReference.Stmt := .assign "x".toList
  (.scalar (.bin .band (.cast .u32 (var "rb")) (.literal .u32 3)))
def shift : C99ModularReference.Stmt := .base (.scalar (.update "rb".toList .shr (num 2)))
def decrement : C99ModularReference.Stmt := .base (.scalar (.update "rbits".toList .sub (num 2)))
def draw : C99ModularReference.Stmt := C99ModularParser.chain [extract,shift,decrement]
def condition : CLogic.Expr := .cmp .lt (var "x") (.literal .u32 3)
def coefficient : CLogic.Expr := .bin .sub (.cast .i32 (var "x")) (num 1)
def store : KeygenSmallSource.Stmt := .store16 "v".toList (var "u") coefficient

theorem draw_source : C99ModularParser.region 4773 3=some draw := by decide
theorem branch_source : (Pinned.keygenLines.drop 4775).take 5 =
  ["\t\t\tif (x < 3U) {\n","\t\t\t\tv[u] = (int16_t)((int)x - 1);\n",
   "\t\t\t\tbreak;\n","\t\t\t}\n","\t\t}\n"] := by decide
theorem store_source : KeygenSmallSource.region 4777 1=some (KeygenSmallSource.chain [store]) := by decide
theorem condition_source : (C99ProcedureParser.tokens "x < 3U".toList).bind C99ArrayParser.pureExpr=
    some (condition,[]) := by decide

inductive Branch (before : State) : Result → Prop where
  | rejected (v : Value) (guard : C99ArrayReference.scalar before condition v) (zero : v.integer=0) :
      Branch before ⟨before,.normal⟩
  | accepted (middle : State) (v : Value) (guard : C99ArrayReference.scalar before condition v)
      (nonzero : v.integer≠0) (write : KeygenSmallSource.Exec store before ⟨middle,.normal⟩) :
      Branch before ⟨middle,.breakLoop⟩

inductive Exec (before : State) : Result → Prop where
  | tail (middle : State) (out : Result)
      (prefixExecution : C99ModularReference.Exec draw before ⟨middle,.normal⟩)
      (branch : Branch middle out) : Exec before out

theorem assigned_else (s : State) (name other : C99ArrayReference.Name) (e : C99ModularReference.Expr)
    (out : Result) (different : other≠name) (source : C99ModularReference.Exec (.assign name e) s out) :
    out.state.locals other=s.locals other := by
  cases source
  simp [C99ArrayReference.bindValue,C99ScalarReference.set,different]

theorem updated_else (s : State) (name other : C99ArrayReference.Name) (op : B20.C.BinOp) (e : CLogic.Expr)
    (out : Result) (different : other≠name)
    (source : C99ModularReference.Exec (.base (.scalar (.update name op e))) s out) :
    out.state.locals other=s.locals other := by
  cases source with
  | base _ _ after execution =>
    cases execution with
    | scalar _ env _ body =>
      obtain ⟨ty,old,v,slot,ev,he⟩ := C99ControlInversion.assign_inv _ _ _ _ _ body
      have he0 := C99ScalarReference.Result.normal.inj he
      rw [he0]
      simp [C99ScalarReference.set,different]

theorem updates_preserve (s : State) (out : Result) (name : C99ArrayReference.Name)
    (notRb : name≠"rb".toList) (notBits : name≠"rbits".toList)
    (source : C99ModularReference.Exec (C99ModularParser.chain [shift,decrement]) s out) :
    out.state.locals name=s.locals name := by
  obtain ⟨middle,first,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right (by
    rintro ⟨r,head,exit,_⟩
    obtain ⟨mid,ev,he⟩ := KeygenNttForwardExec.base_inv _ s r head
    exact exit (congrArg Result.flow he))
  obtain ⟨next,second,last⟩ := (KeygenNttForwardExec.seq_inv _ _ middle out tail).resolve_right (by
    rintro ⟨r,head,exit,_⟩
    obtain ⟨mid,ev,he⟩ := KeygenNttForwardExec.base_inv _ middle r head
    exact exit (congrArg Result.flow he))
  rw [C99ModularReference.skip_result next out last]
  exact (updated_else middle "rbits".toList name .sub (num 2) ⟨next,.normal⟩ notBits second).trans
    (updated_else s "rb".toList name .shr (num 2) ⟨middle,.normal⟩ notRb first)

theorem draw_slots (s middle : State) (old : Option Value)
    (slot : s.locals "x".toList=some (.uint32,old))
    (source : C99ModularReference.Exec draw s ⟨middle,.normal⟩) :
    (∃ w : BitVec 32, middle.locals "x".toList=some (.uint32,some (.uint32 w))) ∧
      middle.locals "u".toList=s.locals "u".toList := by
  obtain ⟨next,first,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s ⟨middle,.normal⟩ source).resolve_right (by
    rintro ⟨r,head,exit,_⟩
    obtain ⟨ty,old,v,slot,ev,he⟩ := KeygenNttForwardExec.assign_inv s "x".toList _ r head
    exact exit (congrArg Result.flow he))
  obtain ⟨ty,previous,v,declared,ev,he⟩ := KeygenNttForwardExec.assign_inv s "x".toList _ ⟨next,.normal⟩ first
  have ht : ty=.uint32 := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  subst ty
  have hn := congrArg Result.state he
  change next=C99ArrayReference.bindValue s "x".toList .uint32 v at hn
  subst next
  have hx := updates_preserve _ ⟨middle,.normal⟩ "x".toList (by decide) (by decide) tail
  have hu := updates_preserve _ ⟨middle,.normal⟩ "u".toList (by decide) (by decide) tail
  refine ⟨⟨BitVec.ofInt 32 v.integer,?_⟩,?_⟩
  · exact hx
  · simpa [C99ArrayReference.bindValue,C99ScalarReference.set] using hu

theorem scalar_store_bound (s : State) (x : BitVec 32) (v gate : Value)
    (slot : s.locals "x".toList=some (.uint32,some (.uint32 x)))
    (test : C99ArrayReference.scalar s condition gate) (nonzero : gate.integer≠0)
    (value : C99ArrayReference.scalar s coefficient v) :
    (BitVec.ofInt 16 v.integer).toInt=v.integer ∧ -1≤v.integer ∧ v.integer≤1 := by
  change C99ScalarReference.Eval _ _ (.compare .lt (.variable "x".toList) (.literal .uint32 3)) gate at test
  cases test with
  | compare _ _ _ a b gate ha hb comparison =>
    have ha0 := C99CountedWords.variable_exact s "x".toList .uint32 (.uint32 x) a slot ha
    subst a
    cases hb
    change C99ScalarReference.Eval _ _ (.arithmetic .minus (.cast .int32 (.variable "x".toList)) (.literal .int32 1)) v at value
    cases value with
    | arithmetic _ _ _ a b v ha hb arithmetic =>
      cases ha with
      | cast _ _ a ha =>
        have ha0 := C99CountedWords.variable_exact s "x".toList .uint32 (.uint32 x) a slot ha
        subst a
        cases hb
        exact KeygenTernaryBound.stored_integer x v gate comparison nonzero arithmetic

theorem accepted_store (s : State) (out : Result) (dst : ArrayPointer) (i : Nat) (old : Option Value)
    (hi : i≤1536) (counter : C99CountedWords.Counter s i)
    (binding : s.arrays "v".toList=some dst) (slot : s.locals "x".toList=some (.uint32,old))
    (source : Exec s out) (accepted : out.flow=.breakLoop) :
    ∃ z : Int, -1≤z ∧ z≤1 ∧
      KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element dst i) (BitVec.ofInt 16 z) out.state.heap := by
  cases source with
  | tail middle out prefixExecution branch =>
    obtain ⟨⟨x,hx⟩,hu⟩ := draw_slots s middle old slot prefixExecution
    have frame := C99ModularFrame.source_frame draw s ⟨middle,.normal⟩ prefixExecution (by decide)
    cases branch with
    | rejected => cases accepted
    | accepted after v guard nonzero write =>
      cases write with
      | store16 _ _ _ _ heap p value address ev store =>
        have hc : C99CountedWords.Counter middle i := hu.trans counter
        have hp := C99CountedWords.pointer_exact middle "v".toList dst p i hi hc
          ((congrFun frame.2 _).trans binding) address
        subst p
        obtain ⟨_,lower,upper⟩ := scalar_store_bound middle x value v hx guard nonzero ev
        refine ⟨value.integer,lower,upper,?_⟩
        rw [frame.1] at store
        exact store

theorem rejected_heap (s : State) (out : Result) (source : Exec s out) (rejected : out.flow=.normal) :
    out.state.heap=s.heap := by
  cases source with
  | tail middle out prefixExecution branch =>
    cases branch with
    | rejected => exact (C99ModularFrame.source_frame draw s ⟨middle,.normal⟩ prefixExecution (by decide)).1
    | accepted => cases rejected

end FT1536.Source3.KeygenTernaryStore
