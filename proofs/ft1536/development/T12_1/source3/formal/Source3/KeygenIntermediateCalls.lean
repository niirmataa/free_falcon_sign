import Source3.KeygenIntermediateMemory
import Source3.KeygenBinaryFft
import Source3.KeygenPolySubNtt
import Source3.KeygenPolySubScaled
import Source3.KeygenZintPoly

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- A closed callee table for intermediate. Arguments include actual member
   reads and typed pointer expressions; parameter conversions are performed
   at their original positions. No callee postcondition supplies execution. -/
namespace FT1536.Source3.KeygenIntermediateCalls
open C99ArrayReference (State Name Param bindValue bindPointer)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenIntermediateMemory (Blocks)
abbrev TableBlocks := KeygenZintScaled.TableBlocks

inductive Expr where
  | word (value : KeygenWordExpr.Expr)
  | load64 (name : Name) (index : CLogic.Expr)
  | rint (name : Name) (index : CLogic.Expr)
  | logn | ternary
  | prime (name : Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field)
  | pointerLt (first second : KeygenIntermediateMemory.Expr)
  | land (first second : Expr)
  deriving DecidableEq, Repr
inductive Eval (ctx : Context) (s : State) : Expr → Value → Prop where
  | word (e : KeygenWordExpr.Expr) (v : Value) (source : KeygenWordExpr.Eval s e v) : Eval ctx s (.word e) v
  | load64 (name : Name) (index : CLogic.Expr) (v : Value)
      (source : C99ArrayReference.Eval s (.load name index) v) : Eval ctx s (.load64 name index) v
  | rint (name : Name) (index : CLogic.Expr) (x v : Value)
      (read : C99ArrayReference.Eval s (.load name index) x)
      (source : KeygenSearchLeaves.Rint [x] v) : Eval ctx s (.rint name index) v
  | logn (word : BitVec 32) (read : KeygenSearchContext.ReadLogn ctx s word) : Eval ctx s .logn (.uint32 word)
  | ternary (word : BitVec 32) (read : KeygenSearchContext.ReadTernary ctx s word) : Eval ctx s .ternary (.uint32 word)
  | prime (name : Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field) (v : Value)
      (read : KeygenLevelCalls.PrimeRead s name index field v) : Eval ctx s (.prime name index field) v
  | pointerLt (a b : KeygenIntermediateMemory.Expr) (p q : ArrayPointer) (v : Bool)
      (first : KeygenIntermediateMemory.Eval ctx s a p) (second : KeygenIntermediateMemory.Eval ctx s b q)
      (compare : KeygenIntermediateMemory.CompareLt p q v) :
      Eval ctx s (.pointerLt a b) (C99ScalarReference.boolean v)
  | andFalse (a b : Expr) (x : Value) (first : Eval ctx s a x) (zero : x.integer=0) :
      Eval ctx s (.land a b) (C99ScalarReference.boolean false)
  | andTrue (a b : Expr) (x y : Value) (first : Eval ctx s a x) (nonzero : x.integer≠0)
      (second : Eval ctx s b y) : Eval ctx s (.land a b) (C99ScalarReference.boolean (decide (y.integer≠0)))
inductive Arg where
  | scalar (value : Expr)
  | pointer (value : KeygenIntermediateMemory.Expr)
  deriving DecidableEq, Repr
inductive Bind (ctx : Context) (caller : State) : List Param → List Arg → State → Prop where
  | nil : Bind ctx caller [] [] ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
  | scalar (ty : Ty) (name : Name) (e : Expr) (ps : List Param) (args : List Arg) (out : State) (v : Value)
      (value : Eval ctx caller e v) (rest : Bind ctx caller ps args out) :
      Bind ctx caller (.scalar ty name::ps) (.scalar e::args) (bindValue out name ty v)
  | pointer (name : Name) (e : KeygenIntermediateMemory.Expr) (p : ArrayPointer)
      (ps : List Param) (args : List Arg) (out : State)
      (value : KeygenIntermediateMemory.Eval ctx caller e p) (rest : Bind ctx caller ps args out) :
      Bind ctx caller (.pointer name::ps) (.pointer e::args) (bindPointer out name p)
def arguments (caller callee : List Name) : List Param → List Arg → Bool
  | [],[] => true
  | .scalar _ _::ps,.scalar _::args => arguments caller callee ps args
  | .pointer name::ps,.pointer e::args =>
    (!(callee.contains name) || KeygenIntermediateMemory.only caller e) && arguments caller callee ps args
  | _,_ => false
theorem bind_heap (ctx : Context) (before : State) (ps : List Param) (args : List Arg) (entry : State)
    (source : Bind ctx before ps args entry) : entry.heap=before.heap := by
  induction source with
  | nil => rfl
  | scalar _ _ _ _ _ _ _ _ _ ih => exact ih
  | pointer _ _ _ _ _ _ _ _ ih => exact ih
theorem bind_blocks (ctx : Context) (before : State) (ps : List Param) (args : List Arg) (entry : State)
    (source : Bind ctx before ps args entry) (caller callee : List Name)
    (checked : arguments caller callee ps args=true) (block : Nat)
    (outside : Blocks before caller block) (tables : TableBlocks before block) (scratch : block≠ctx.scratch.block) :
    Blocks entry callee block ∧ entry.tables=before.tables := by
  induction source with
  | nil => exact ⟨fun n _ p hp => tables n p hp,rfl⟩
  | scalar ty name e ps args out v value rest ih => exact ih checked
  | pointer name e p ps args out value rest ih =>
    obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ho,ht⟩ := ih hr
    refine ⟨?_,ht⟩
    intro n hn q hq
    by_cases he : n=name
    · subst n
      have hm : callee.contains name=true := List.contains_iff_mem.mpr hn
      have ha : KeygenIntermediateMemory.only caller e=true := by rw [hm] at hc; exact hc
      have hpq : p=q := Option.some.inj (by simpa [bindPointer] using hq)
      subst q
      exact KeygenIntermediateMemory.eval_block ctx before e p value caller ha block outside scratch
    · exact ho n hn q (by simpa [bindPointer,he] using hq)

inductive Kind where
  | zint (kind : KeygenZintCall.Callee)
  | make
  | poly (kind : KeygenZintPoly.Kind)
  | subNtt | subQuadratic
  | binaryNtt (kind : KeygenBinaryNtt.Kind)
  | ternaryNtt (kind : KeygenLevelCalls.Kind)
  | binaryFft (kind : KeygenBinaryFft.Id)
  | ternaryFft (kind : KeygenSearchFft.Id)
  deriving DecidableEq, Repr
def params : Kind → List Param
  | .zint kind => KeygenZintCall.params kind
  | .make => KeygenMakeFgSource.params .make
  | .poly kind => KeygenZintPoly.params kind
  | .subNtt => KeygenPolySubNtt.params
  | .subQuadratic => KeygenPolySubScaled.parameters
  | .binaryNtt kind => KeygenBinaryNtt.params kind
  | .ternaryNtt kind => KeygenLevelCalls.params kind
  | .binaryFft kind => (KeygenBinaryFft.header kind).parameters.map C99ArrayParser.Parameter.value
  | .ternaryFft kind => (KeygenSearchFft.header kind).parameters.map C99ArrayParser.Parameter.value
def result : Kind → Option Ty
  | .zint kind => KeygenZintCall.result kind
  | .poly kind => KeygenZintPoly.result kind
  | .ternaryFft kind => (KeygenSearchFft.header kind).result
  | _ => none
def writable : Kind → List Name
  | .zint kind => KeygenZintCall.writable kind
  | .make => KeygenMakeFgSource.writable
  | .poly kind => KeygenZintPoly.writable kind
  | .subNtt => KeygenPolySubNtt.writable
  | .subQuadratic => KeygenPolySubScaled.writable
  | .binaryNtt kind => KeygenBinaryNtt.writable kind
  | .ternaryNtt kind => KeygenLevelCalls.writable kind
  | .binaryFft kind => KeygenBinaryFft.writable kind
  | .ternaryFft kind => KeygenSearchFft.writable kind
inductive Body : Kind → State → Result → Prop where
  | zint (kind : KeygenZintCall.Callee) (before : State) (out : Result)
      (source : KeygenZintCall.Exec (KeygenZintCall.calleeBody kind) before out) : Body (.zint kind) before out
  | make (before : State) (out : Result)
      (source : KeygenMakeFgSource.Exec (KeygenMakeFgSource.code .make) before out) : Body .make before out
  | poly (kind : KeygenZintPoly.Kind) (before : State) (out : Result)
      (source : KeygenZintPoly.Exec (KeygenZintPoly.code kind) before out) : Body (.poly kind) before out
  | subNtt (before : State) (out : Result)
      (source : KeygenPolySubNtt.Exec KeygenPolySubNtt.code before out) : Body .subNtt before out
  | subQuadratic (before after : State)
      (source : KeygenPolySubScaled.Exec KeygenPolySubScaled.code before after) : Body .subQuadratic before ⟨after,.normal⟩
  | binaryNtt (kind : KeygenBinaryNtt.Kind) (before : State) (out : Result)
      (source : KeygenBinaryNtt.Exec (KeygenBinaryNtt.code kind) before out) : Body (.binaryNtt kind) before out
  | ternaryNtt (kind : KeygenLevelCalls.Kind) (before : State) (out : Result)
      (source : C99ModularReference.Exec (KeygenLevelCalls.body kind) before out) : Body (.ternaryNtt kind) before out
  | binaryFft (kind : KeygenBinaryFft.Id) (before : State) (out : Result) (p : C99ProcedureParser.Parsed)
      (binding : KeygenBinaryFft.source kind=some p)
      (source : C99ProcedureReference.Exec KeygenBinaryFft.program p.body before out) : Body (.binaryFft kind) before out
  | ternaryFft (kind : KeygenSearchFft.Id) (before : State) (out : Result) (p : C99ProcedureParser.Parsed)
      (binding : KeygenSearchFft.source kind=some p)
      (source : C99ProcedureReference.Exec KeygenSearchFft.program p.body before out) : Body (.ternaryFft kind) before out
theorem body_frame (kind : Kind) (before : State) (out : Result) (source : Body kind before out)
    (block offset : Nat) (outside : Blocks before (writable kind) block) (tables : TableBlocks before block) :
    out.state.heap.bytes block offset=before.heap.bytes block offset := by
  have ho : C99ArrayFrame.Outside before (writable kind) block offset := fun n hn p hp => Or.inl (outside n hn p hp)
  have ht : C99PointerFootprint.TablesOutside before block offset := fun n p hp => Or.inl (tables n p hp)
  cases source with
  | zint kind before out source =>
    exact (KeygenZintCall.body_frame KeygenZintCore.code_checked _ _ _ source _ (KeygenZintCore.code_checked kind) _ _ ho ht).2.2
  | make before out source =>
    exact (KeygenMakeFgSource.frame _ _ _ source _ (KeygenMakeFgSource.code_checked .make) _ _ ho ht).2.2
  | poly kind before out source =>
    exact (KeygenZintPoly.frame _ _ _ source _ (KeygenZintPoly.code_checked kind) _ _ ho ht).2.2
  | subNtt before out source => exact (KeygenPolySubNtt.frame _ _ _ source _ KeygenPolySubNtt.code_checked _ _ ho ht).2.2
  | subQuadratic before after source =>
    exact (KeygenPolySubScaled.frame _ _ _ source _ KeygenPolySubScaled.code_checked _ _ outside tables).2.2
  | binaryNtt kind before out source =>
    exact (KeygenBinaryNtt.frame _ _ _ source _ (KeygenBinaryNtt.code_checked kind) _ _ ho).2.2
  | ternaryNtt kind before out source =>
    exact (KeygenLevelModularFrame.body_frame _ _ _ source _ (KeygenLevelCalls.checked kind) _ _ ho).2.2
  | binaryFft kind before out p binding source =>
    exact (KeygenBinaryFft.body_frame _ _ _ source _ (KeygenBinaryFft.audited_body kind p binding).2 _ _ ho ht).2.2
  | ternaryFft kind before out p binding source =>
    exact (KeygenSearchFft.body_frame _ _ _ source _ (KeygenSearchFft.audited_body kind p binding).2 _ _ ho ht).2.2
inductive Call (ctx : Context) (kind : Kind) (before : State) (args : List Arg) : State → Option Value → Prop where
  | run (entry : State) (out : Result) (v : Option Value)
      (binding : Bind ctx before (params kind) args entry) (source : Body kind entry out)
      (returned : C99ProcedureReference.ReturnValue (result kind) out.flow v) :
      Call ctx kind before args {before with heap := out.state.heap} v
theorem call_frame (ctx : Context) (kind : Kind) (before after : State) (args : List Arg) (v : Option Value)
    (source : Call ctx kind before args after v) (names : List Name) (block offset : Nat)
    (allowed : arguments names (writable kind) (params kind) args=true)
    (outside : Blocks before names block) (tables : TableBlocks before block) (scratch : block≠ctx.scratch.block) :
    after.arrays=before.arrays ∧ after.tables=before.tables ∧ after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out v binding execution returned =>
    obtain ⟨ho,ht⟩ := bind_blocks ctx before (params kind) args entry binding names (writable kind) allowed block outside tables scratch
    have keep := body_frame kind entry out execution block offset ho (by simpa only [TableBlocks,KeygenZintScaled.TableBlocks,ht] using tables)
    rw [bind_heap ctx before (params kind) args entry binding] at keep
    exact ⟨rfl,rfl,keep⟩

end FT1536.Source3.KeygenIntermediateCalls
