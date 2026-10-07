import Source3.KeygenRngSource
import Source3.KeygenTernaryStore
import Source3.KeygenM0Preprocess

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Specialized natural semantics of the complete, fixed MODE1 function.
   The two loops retain their actual guard/increment, rejection and break.
   Refill executes KeygenRngSource.Call, never an arbitrary word relation.
   The source declaration/body fragments below cover every selected line. -/
namespace FT1536.Source3.KeygenSamplerSource
open C99ArrayReference (State Name bindValue)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open ShakeExtractSource (Layout)

def selected : Option (List String) :=
  KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 4755).take 58)
def visible : List String := (Pinned.keygenLines.drop 4755).take 2++
  (Pinned.keygenLines.drop 4758).take 23++["}\n"]
theorem selected_source : selected=some visible := by decide
theorem signature_source : (Pinned.keygenLines.drop 4752).take 3 =
    ["static void\n","sample_true_ternary_secret(falcon_keygen *fk, int16_t *v, size_t n)\n","{\n"] := by decide

def prologue : C99ModularReference.Stmt := C99ModularParser.chain [
  .base (.scalar (.declare .u64 ["u".toList])),
  .base (.scalar (.declare .u64 ["rb".toList])),
  .base (.scalar (.declare .u32 ["rbits".toList])),
  .assign "rb".toList (.scalar (.literal .i32 0)),
  .assign "rbits".toList (.scalar (.literal .i32 0))]
def parsedPrologue : Option C99ModularReference.Stmt := do
  let lines := (Pinned.keygenLines.drop 4755).take 2++(Pinned.keygenLines.drop 4758).take 6
  let tokens ← C99ProcedureParser.tokens (lines.flatMap String.toList++['}'])
  let (code,_,rest) ← C99ModularParser.body [] 32 tokens
  if rest.isEmpty then pure code else none
theorem prologue_source : parsedPrologue=some prologue := by decide

def initial : C99ModularReference.Stmt := .assign "u".toList (.scalar (.literal .i32 0))
def increment : C99ModularReference.Stmt := .base (.scalar (.update "u".toList .add (.literal .i32 1)))
def declareX : C99ModularReference.Stmt := .base (.scalar (.declare .u32 ["x".toList]))
def refillCondition : CLogic.Expr := .cmp .lt (.var "rbits".toList) (.literal .i32 2)
def assignBits : C99ModularReference.Stmt := .assign "rbits".toList (.scalar (.literal .i32 64))

theorem control_source : Pinned.keygenLines[4764]?=some "\tfor (u = 0; u < n; u ++) {\n" ∧
    Pinned.keygenLines[4765]?=some "\t\tuint32_t x;\n" ∧
    Pinned.keygenLines[4767]?=some "\t\tfor (;;) {\n" ∧
    (Pinned.keygenLines.drop 4768).take 4=["\t\t\tif (rbits < 2) {\n",
      "\t\t\t\trb = get_rng_u64(&fk->rng);\n","\t\t\t\trbits = 64;\n","\t\t\t}\n"] ∧
    (Pinned.keygenLines.drop 4779).take 2=["\t\t}\n","\t}\n"] := by decide
theorem clauses_source :
    ((C99ProcedureParser.tokens "u = 0;".toList).bind (C99ModularParser.clauses [] [';'] 16))=some (initial,[]) ∧
    ((C99ProcedureParser.tokens "u < n".toList).bind C99ArrayParser.pureExpr)=some (C99CountedWords.condition,[]) ∧
    ((C99ProcedureParser.tokens "u ++ )".toList).bind (C99ModularParser.clauses [] [')'] 16))=some (increment,[]) ∧
    ((C99ProcedureParser.tokens "rbits < 2".toList).bind C99ArrayParser.pureExpr)=some (refillCondition,[]) ∧
    C99ModularParser.region 4771 1=some (C99ModularParser.chain [assignBits]) := by decide

inductive Refill (ctx : Layout) : State → State → Prop where
  | skip (s : State) (v : Value) (guard : C99ArrayReference.scalar s refillCondition v) (zero : v.integer=0) :
      Refill ctx s s
  | fill (before drawn after : State) (v : Value) (w : BitVec 64) (ty : Ty) (old : Option Value)
      (guard : C99ArrayReference.scalar before refillCondition v) (nonzero : v.integer≠0)
      (declared : before.locals "rb".toList=some (ty,old))
      (draw : KeygenRngSource.Call ctx before drawn w)
      (bits : C99ModularReference.Exec assignBits (bindValue drawn "rb".toList ty (.uint64 w)) ⟨after,.normal⟩) :
      Refill ctx before after

/- A finite execution of for (;;) must eventually take the source break.
   The recursive constructor is exactly the rejected-draw edge. -/
inductive Inner (ctx : Layout) : State → State → Prop where
  | accepted (before refilled after : State) (refill : Refill ctx before refilled)
      (tail : KeygenTernaryStore.Exec refilled ⟨after,.breakLoop⟩) : Inner ctx before after
  | rejected (before refilled next after : State) (refill : Refill ctx before refilled)
      (tail : KeygenTernaryStore.Exec refilled ⟨next,.normal⟩) (rest : Inner ctx next after) : Inner ctx before after

def closedScope (before after : State) : State := C99ArrayReference.restoreScope before after ["x".toList] []

inductive Outer (ctx : Layout) : State → State → Prop where
  | done (s : State) (v : Value) (guard : C99ArrayReference.scalar s C99CountedWords.condition v)
      (zero : v.integer=0) : Outer ctx s s
  | next (before declared inner updated after : State) (v : Value)
      (guard : C99ArrayReference.scalar before C99CountedWords.condition v) (nonzero : v.integer≠0)
      (declaration : C99ModularReference.Exec declareX before ⟨declared,.normal⟩)
      (iteration : Inner ctx declared inner)
      (update : C99ModularReference.Exec increment (closedScope before inner) ⟨updated,.normal⟩)
      (rest : Outer ctx updated after) : Outer ctx before after

inductive Exec (ctx : Layout) (before : State) : State → Prop where
  | run (declared ready after : State)
      (setup : C99ModularReference.Exec prologue before ⟨declared,.normal⟩)
      (initialization : C99ModularReference.Exec initial declared ⟨ready,.normal⟩)
      (loop : Outer ctx ready after) : Exec ctx before after

end FT1536.Source3.KeygenSamplerSource
