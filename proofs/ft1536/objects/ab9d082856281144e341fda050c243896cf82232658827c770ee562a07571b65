import Source3.KeygenModpAddSub
import Source3.KeygenNinv31
import Source3.KeygenModpSet
import Source3.KeygenModpR
import Source3.C99ProcedureReference

/- Read-only uint32 expressions and ordinary block/loop control. Primitive
   calls execute their pinned scalar bodies. This reference judgment does
   not use the modular equations that will be proved about its executions.
   B1.03 extensions (only the syntax genuinely used by modp_mkgm3 and its
   callees): five-argument calls (modp_div), stores with the mixed index
   `base + REV10[index]` from a read-only uint16 table, and the composite
   modular callees modp_R2/modp_div whose pinned bodies contain nested
   modular calls. The evaluation/execution judgments are parameterized by
   the call relation (the C99ScalarReference pattern), so they remain
   ordinary inductive families with working induction. The strata are:
   LeafCall (six pinned scalar leaf bodies), then ModCall = LeafCall plus
   the two composite callees, whose body executions run under LeafCall.
   The hand-built body statements r2Code/divCode below are checked against
   the pinned source parse in KeygenMkgm3Callees. -/
namespace FT1536.Source3.C99ModularReference
open C99ArrayReference (Name State scalar bindValue restoreScope Pointer)
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)

inductive Expr where
  | scalar (e : CLogic.Expr)
  | load32 (array : Name) (index : CLogic.Expr)
  | load16 (array : Name) (index : CLogic.Expr)
  | call1 (name : Name) (a : Expr)
  | call2 (name : Name) (a b : Expr)
  | call3 (name : Name) (a b c : Expr)
  | call4 (name : Name) (a b c d : Expr)
  | call5 (name : Name) (a b c d e : Expr)
  deriving DecidableEq, Repr

inductive Stmt where
  | base (code : C99ArrayReference.Stmt)
  | assign (name : Name) (value : Expr)
  | store32 (array : Name) (index : CLogic.Expr) (value : Expr)
  | storeRev (array table : Name) (base index : CLogic.Expr) (value : Expr)
  | seq (first second : Stmt)
  | scope (locals : List Name) (body : Stmt)
  | branch (condition : CLogic.Expr) (yes no : Stmt)
  | loop (condition : CLogic.Expr) (body increment : Stmt)
  | ret (value : Expr)
  | retVoid
  deriving DecidableEq, Repr

def chainOf : List Stmt → Stmt
  | [] => .base .skip
  | first::rest => .seq first (chainOf rest)

/- Statement-level parameter binding for the composite modular callees.
   Binding follows the argument order left to right, converting each value
   to the declared parameter type like BindArgs does at the scalar level. -/
def bindParams (base : State) : List (C99IntegerReference.Ty×Name) → List Value → State
  | [],[] => base
  | (ty,name)::rest,v::vs => bindParams (bindValue base name ty v) rest vs
  | _,_ => base

/- Pinned modular bodies of modp_R2 and modp_div (composite modular callees
   of modp_mkgm3). The statements mirror the source byte-for-byte structure;
   the parse equalities against the pinned lines are proved in
   KeygenMkgm3Callees and are the source binding for these definitions. -/
def r2Params : List (C99IntegerReference.Ty×Name) :=
  [(.uint32,"p".toList),(.uint32,"p0i".toList)]

def montZZ : Expr := .call4 "modp_montymul".toList
  (.scalar (.var "z".toList)) (.scalar (.var "z".toList))
  (.scalar (.var "p".toList)) (.scalar (.var "p0i".toList))

def r2Halving : CLogic.Expr :=
  .bin .shr (.bin .add (.var "z".toList)
    (.bin .band (.var "p".toList) (.neg (.bin .band (.var "z".toList) (.literal .i32 1)))))
    (.literal .i32 1)

def r2Code : Stmt := chainOf [
  .base (.scalar (.declare .u32 ["z".toList])),
  .assign "z".toList (.call1 "modp_R".toList (.scalar (.var "p".toList))),
  .assign "z".toList (.call3 "modp_add".toList (.scalar (.var "z".toList))
    (.scalar (.var "z".toList)) (.scalar (.var "p".toList))),
  .assign "z".toList montZZ,.assign "z".toList montZZ,.assign "z".toList montZZ,
  .assign "z".toList montZZ,.assign "z".toList montZZ,
  .assign "z".toList (.scalar r2Halving),
  .ret (.scalar (.var "z".toList))]

def divParams : List (C99IntegerReference.Ty×Name) :=
  [(.uint32,"a".toList),(.uint32,"b".toList),(.uint32,"p".toList),(.uint32,"p0i".toList),
   (.uint32,"R".toList)]

def montZB : Expr := .call4 "modp_montymul".toList
  (.scalar (.var "z".toList)) (.scalar (.var "b".toList))
  (.scalar (.var "p".toList)) (.scalar (.var "p0i".toList))

/- Right-hand side of the compound update `z ^= ...`: exactly
   `(z ^ z2) & -(uint32_t)((e >> i) & 1)`; the update form contributes the
   outer xor with z (the previous tree wrongly carried a second outer
   `xor z`, which is the single parser<->divCode mismatch found by probe
   keygen_mkgm3_div_probe_001; retained dumps in its job logs). -/
def divSelect : CLogic.Expr :=
  .bin .band
    (.bin .xor (.var "z".toList) (.var "z2".toList))
    (.neg (.cast .u32 (.bin .band (.bin .shr (.var "e".toList) (.var "i".toList))
      (.literal .i32 1))))

def divLoopBody : Stmt := .scope ["z2".toList] (chainOf [
  .base (.scalar (.declare .u32 ["z2".toList])),
  .assign "z".toList montZZ,
  .assign "z2".toList montZB,
  .base (.scalar (.update "z".toList .xor divSelect))])

def divLoop : Stmt := .seq (.assign "i".toList (.scalar (.literal .i32 30)))
  (.loop (.cmp .ge (.var "i".toList) (.literal .i32 0)) divLoopBody
    (.base (.scalar (.update "i".toList .sub (.literal .i32 1)))))

def divCode : Stmt := chainOf [
  .base (.scalar (.declare .u32 ["z".toList,"e".toList])),
  .base (.scalar (.declare .i32 ["i".toList])),
  .assign "e".toList (.scalar (.bin .sub (.var "p".toList) (.literal .i32 2))),
  .assign "z".toList (.scalar (.var "R".toList)),
  divLoop,
  .assign "z".toList (.call4 "modp_montymul".toList (.scalar (.var "z".toList))
    (.scalar (.literal .i32 1)) (.scalar (.var "p".toList)) (.scalar (.var "p0i".toList))),
  .ret (.call4 "modp_montymul".toList (.scalar (.var "a".toList))
    (.scalar (.var "z".toList)) (.scalar (.var "p".toList)) (.scalar (.var "p0i".toList)))]

abbrev CallRelation := Name → List Value → Value → Prop

/- First stratum: the six pinned scalar leaf bodies. -/
inductive LeafCall : CallRelation where
  | montgomery (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpWord.montgomeryCode) args out) :
      LeafCall "modp_montymul".toList args out
  | add (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction (KeygenModpAddSub.code .add)) args out) :
      LeafCall "modp_add".toList args out
  | sub (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction (KeygenModpAddSub.code .sub)) args out) :
      LeafCall "modp_sub".toList args out
  | inverse (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenNinv31.code) args out) :
      LeafCall "modp_ninv31".toList args out
  | set (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpSet.code) args out) :
      LeafCall "modp_set".toList args out
  | r (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpR.code) args out) :
      LeafCall "modp_R".toList args out

inductive GenEval (calls : CallRelation) (s : State) : Expr → Value → Prop where
  | scalar (e : CLogic.Expr) (v : Value) (source : scalar s e v) : GenEval calls s (.scalar e) v
  | load32 (name : Name) (index : CLogic.Expr) (p : C99MemoryReference.ArrayPointer) (w : BitVec 32)
      (address : Pointer s name index p) (read : C99MemoryReference.Load32 s.heap p w) :
      GenEval calls s (.load32 name index) (.uint32 w)
  | load16 (name : Name) (index : CLogic.Expr) (p : C99MemoryReference.ArrayPointer) (w : BitVec 16)
      (address : Pointer s name index p) (read : C99NarrowReads.Load16 s.heap p w) :
      GenEval calls s (.load16 name index) (C99NarrowReads.signedPromotion w)
  | call1 (name : Name) (a : Expr) (x out : Value)
      (arg : GenEval calls s a x) (call : calls name [x] out) : GenEval calls s (.call1 name a) out
  | call2 (name : Name) (a b : Expr) (x y out : Value)
      (first : GenEval calls s a x) (second : GenEval calls s b y) (call : calls name [x,y] out) :
      GenEval calls s (.call2 name a b) out
  | call3 (name : Name) (a b c : Expr) (x y z out : Value)
      (first : GenEval calls s a x) (second : GenEval calls s b y) (third : GenEval calls s c z)
      (call : calls name [x,y,z] out) : GenEval calls s (.call3 name a b c) out
  | call4 (name : Name) (a b c d : Expr) (x y z t out : Value)
      (first : GenEval calls s a x) (second : GenEval calls s b y) (third : GenEval calls s c z)
      (fourth : GenEval calls s d t) (call : calls name [x,y,z,t] out) :
      GenEval calls s (.call4 name a b c d) out
  | call5 (name : Name) (a b c d e : Expr) (x y z t u out : Value)
      (first : GenEval calls s a x) (second : GenEval calls s b y) (third : GenEval calls s c z)
      (fourth : GenEval calls s d t) (fifth : GenEval calls s e u)
      (call : calls name [x,y,z,t,u] out) :
      GenEval calls s (.call5 name a b c d e) out

inductive GenExec (calls : CallRelation) : Stmt → State → Result → Prop where
  | base (code : C99ArrayReference.Stmt) (before after : State)
      (source : C99ArrayReference.Exec FftLeafPrograms.program code before after) :
      GenExec calls (.base code) before ⟨after,.normal⟩
  | assign (name : Name) (e : Expr) (before : State) (ty : C99IntegerReference.Ty)
      (old : Option Value) (v : Value) (declared : before.locals name=some (ty,old))
      (value : GenEval calls before e v) :
      GenExec calls (.assign name e) before ⟨bindValue before name ty v,.normal⟩
  | store32 (name : Name) (index : CLogic.Expr) (e : Expr) (before : State)
      (after : C99MemoryReference.Memory) (p : C99MemoryReference.ArrayPointer) (v : Value)
      (address : Pointer before name index p) (value : GenEval calls before e v)
      (write : C99MemoryReference.Store32 before.heap p (BitVec.ofInt 32 v.integer) after) :
      GenExec calls (.store32 name index e) before ⟨{before with heap := after},.normal⟩
  | storeRev (name table : Name) (base index : CLogic.Expr) (e : Expr) (before : State)
      (after : C99MemoryReference.Memory) (p q : C99MemoryReference.ArrayPointer)
      (bv : Value) (w : BitVec 16) (v : Value)
      (baseValue : scalar before base bv)
      (tableAddress : Pointer before table index q)
      (tableRead : C99NarrowReads.Load16 before.heap q w)
      (address : Pointer before name (.literal .u64
        ((bv.integer.toNat+(C99NarrowReads.unsignedPromotion w).integer.toNat)%2^64)) p)
      (value : GenEval calls before e v)
      (write : C99MemoryReference.Store32 before.heap p (BitVec.ofInt 32 v.integer) after) :
      GenExec calls (.storeRev name table base index e) before ⟨{before with heap := after},.normal⟩
  | seqNormal (first second : Stmt) (before middle : State) (result : Result)
      (head : GenExec calls first before ⟨middle,.normal⟩) (tail : GenExec calls second middle result) :
      GenExec calls (.seq first second) before result
  | seqExit (first second : Stmt) (before : State) (result : Result)
      (head : GenExec calls first before result) (exit : result.flow≠.normal) :
      GenExec calls (.seq first second) before result
  | scope (locals : List Name) (body : Stmt) (before : State) (result : Result)
      (inner : GenExec calls body before result) :
      GenExec calls (.scope locals body) before ⟨restoreScope before result.state locals [],result.flow⟩
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before : State) (result : Result)
      (v : Value) (guard : scalar before condition v) (nonzero : v.integer≠0)
      (body : GenExec calls yes before result) : GenExec calls (.branch condition yes no) before result
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before : State) (result : Result)
      (v : Value) (guard : scalar before condition v) (zero : v.integer=0)
      (body : GenExec calls no before result) : GenExec calls (.branch condition yes no) before result
  | loopFalse (condition : CLogic.Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : scalar before condition v) (zero : v.integer=0) :
      GenExec calls (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : CLogic.Expr) (body increment : Stmt) (before middle next : State)
      (result : Result) (v : Value) (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : GenExec calls body before ⟨middle,.normal⟩)
      (update : GenExec calls increment middle ⟨next,.normal⟩)
      (rest : GenExec calls (.loop condition body increment) next result) :
      GenExec calls (.loop condition body increment) before result
  | loopReturn (condition : CLogic.Expr) (body increment : Stmt) (before after : State)
      (v value : Value) (guard : scalar before condition v) (nonzero : v.integer≠0)
      (iteration : GenExec calls body before ⟨after,.returned (some value)⟩) :
      GenExec calls (.loop condition body increment) before ⟨after,.returned (some value)⟩
  | ret (e : Expr) (before : State) (v : Value) (value : GenEval calls before e v) :
      GenExec calls (.ret e) before ⟨before,.returned (some v)⟩
  | retVoid (before : State) : GenExec calls .retVoid before ⟨before,.returned none⟩

/- Body executions of the composite modular callees, under the leaf
   stratum: their nested calls are exactly the pinned scalar leaves. -/
def r2Body : List Value → Value → Prop := fun args out =>
  ∃ base after, GenExec LeafCall r2Code (bindParams base r2Params args)
    ⟨after,.returned (some out)⟩

def divBody : List Value → Value → Prop := fun args out =>
  ∃ base after, GenExec LeafCall divCode (bindParams base divParams args)
    ⟨after,.returned (some out)⟩

/- Second stratum: the leaf bodies plus the composite modular callees. -/
inductive ModCall : CallRelation where
  | montgomery (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpWord.montgomeryCode) args out) :
      ModCall "modp_montymul".toList args out
  | add (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction (KeygenModpAddSub.code .add)) args out) :
      ModCall "modp_add".toList args out
  | sub (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction (KeygenModpAddSub.code .sub)) args out) :
      ModCall "modp_sub".toList args out
  | inverse (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenNinv31.code) args out) :
      ModCall "modp_ninv31".toList args out
  | set (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpSet.code) args out) :
      ModCall "modp_set".toList args out
  | r (args : List Value) (out : Value)
      (body : C99ScalarReference.FunctionExec C99Frontend.noCalls
        (C99Frontend.headerFunction KeygenModpR.code) args out) :
      ModCall "modp_R".toList args out
  | r2 (args : List Value) (out : Value) (body : r2Body args out) :
      ModCall "modp_R2".toList args out
  | div (args : List Value) (out : Value) (body : divBody args out) :
      ModCall "modp_div".toList args out

abbrev Eval (s : State) : Expr → Value → Prop := GenEval ModCall s
abbrev Exec : Stmt → State → Result → Prop := GenExec ModCall

theorem base_before_tail (code : C99ArrayReference.Stmt) (tail : Stmt) (before : State)
    (result : Result) (source : Exec (.seq (.base code) tail) before result) :
    ∃ middle, C99ArrayReference.Exec FftLeafPrograms.program code before middle ∧
      Exec tail middle result := by
  cases source with
  | seqNormal _ _ _ middle _ head rest => cases head; exact ⟨middle,‹_›,rest⟩
  | seqExit _ _ _ _ head exit => cases head; exact False.elim (exit rfl)

theorem skip_result (before : State) (result : Result)
    (source : Exec (.base .skip) before result) : result=⟨before,.normal⟩ := by
  cases source; cases ‹C99ArrayReference.Exec _ _ _ _›; rfl

theorem continuation (head tail : Stmt) (before middle : State) (result : Result)
    (unique : ∀ out, Exec head before out → out=⟨middle,.normal⟩)
    (source : Exec (.seq head tail) before result) : Exec tail middle result := by
  cases source with
  | seqNormal _ _ _ actual _ first rest =>
      have he := congrArg Result.state (unique ⟨actual,.normal⟩ first)
      change actual=middle at he
      subst actual
      exact rest
  | seqExit _ _ _ _ first exit =>
      exact False.elim (exit (congrArg Result.flow (unique result first)))

end FT1536.Source3.C99ModularReference
