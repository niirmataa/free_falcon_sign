import Source3.KeygenCPP

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Conditional directives of the pinned M0 KeyGen body. Runtime statements
   remain unchanged. Unknown/unsupported active directives are rejected. -/
namespace FT1536.Source3.KeygenM0Preprocess
open B20.C (Name Token)

def macros : List (Name×Nat) := [
  ("TRUE_TERNARY_SECRET".toList,1),("TRUE_TERNARY_SECRET_MODE".toList,1),
  ("TERNARY_KEYGEN_BOUND_SCALE_NUM".toList,1250),("TERNARY_KEYGEN_BOUND_SCALE_DEN".toList,100),
  ("TERNARY_KEYGEN_MAX_ATTEMPTS".toList,3000000)]
def lookup (name : Name) : Option Nat := ((macros.find? (fun pair => pair.1==name)).map Prod.snd)
def env : B20.C.Env := fun name => some (.i64 (BitVec.ofNat 64 ((lookup name).getD 0)))

def condition (tokens : List Token) : Option Bool := do
  let (expression,rest) ← CLogicParser.expression 32 tokens
  if !rest.isEmpty then none else do
    let value ← CLogic.eval (fun _ _ => none) env 64 expression
    pure (CLogic.truth value)

def knownConditions : List (List Token×Bool) := [
  (["TRUE_TERNARY_SECRET".toList],true),
  (["TRUE_TERNARY_SECRET_MODE".toList,['=','='],['1']],true),
  (["TRUE_TERNARY_SECRET_MODE".toList,['=','='],['2']],false),
  (["TERNARY_KEYGEN_MAX_ATTEMPTS".toList,['!','='],['0']],true),
  (["TERNARY_KEYGEN_BOUND_SCALE_NUM".toList,['!','='],"TERNARY_KEYGEN_BOUND_SCALE_DEN".toList],true)]

theorem known_conditions_checked : knownConditions.all (fun entry => condition entry.1==some entry.2)=true := by decide
theorem known_conditions_bound : ∀ entry∈knownConditions, condition entry.1=some entry.2 := by
  intro entry member
  exact beq_iff_eq.mp ((List.all_eq_true.mp known_conditions_checked) entry member)

def cachedCondition (tokens : List Token) : Option Bool :=
  match knownConditions.find? (fun entry => entry.1==tokens) with
  | some entry => some entry.2
  | none => condition tokens

theorem cached_condition_bound (tokens : List Token) : cachedCondition tokens=condition tokens := by
  unfold cachedCondition
  cases found : knownConditions.find? (fun entry => entry.1==tokens) with
  | none => rfl
  | some entry =>
      have member := List.mem_of_find?_eq_some found
      have tested := List.find?_some found
      have he : entry.1=tokens := beq_iff_eq.mp tested
      rw [← he]
      exact (known_conditions_bound entry member).symm

inductive Line where
  | text (line : String)
  | ifdef (name : Name)
  | ifndef (name : Name)
  | ifExpr (tokens : List Token)
  | elifExpr (tokens : List Token)
  | elseBranch | endBranch | errorDirective

def readLine (line : String) : Option Line :=
  match line.toList.dropWhile (fun c => c==' ' || c=='\t') with
  | '#'::characters => do
      let tokens ← CLogicParser.tokenize (characters.length+1) characters
      match tokens with
      | [name,argument] =>
          if name="ifdef".toList then some (.ifdef argument)
          else if name="ifndef".toList then some (.ifndef argument)
          else if name="if".toList then some (.ifExpr [argument])
          else if name="elif".toList then some (.elifExpr [argument])
          else if name="error".toList then some .errorDirective else none
      | name::rest =>
          if name="if".toList then some (.ifExpr rest)
          else if name="elif".toList then some (.elifExpr rest)
          else if name="else".toList && rest.isEmpty then some .elseBranch
          else if name="endif".toList && rest.isEmpty then some .endBranch
          else if name="error".toList then some .errorDirective else none
      | _ => none
  | _ => some (.text line)

structure Frame where
  outer : Bool
  taken : Bool
  elseSeen : Bool
  deriving DecidableEq, Repr

structure Control where
  active : Bool
  stack : List Frame
  deriving DecidableEq, Repr
def initial : Control := ⟨true,[]⟩

def step (line : String) (control : Control) : Option (Control×List String) := do
  match ← readLine line with
  | .text text => pure (control,if control.active then [text] else [])
  | .ifdef name =>
      let test := (lookup name).isSome
      pure (⟨control.active && test,⟨control.active,test,false⟩::control.stack⟩,[])
  | .ifndef name =>
      let test := !(lookup name).isSome
      pure (⟨control.active && test,⟨control.active,test,false⟩::control.stack⟩,[])
  | .ifExpr tokens =>
      let test ← cachedCondition tokens
      pure (⟨control.active && test,⟨control.active,test,false⟩::control.stack⟩,[])
  | .elifExpr tokens =>
      match control.stack with
      | [] => none
      | frame::tail =>
          if frame.elseSeen then none else do
            let test ← cachedCondition tokens
            pure (⟨frame.outer && !frame.taken && test,⟨frame.outer,frame.taken || test,false⟩::tail⟩,[])
  | .elseBranch =>
      match control.stack with
      | [] => none
      | frame::tail => if frame.elseSeen then none else
          pure (⟨frame.outer && !frame.taken,⟨frame.outer,true,true⟩::tail⟩,[])
  | .endBranch =>
      match control.stack with
      | [] => none
      | frame::tail => pure (⟨frame.outer,tail⟩,[])
  | .errorDirective => if control.active then none else pure (control,[])

def runControl : List String → Control → Option (Control×List String)
  | [],control => some (control,[])
  | line::rest,control => do
      let (next,head) ← step line control
      let (last,tail) ← runControl rest next
      pure (last,head++tail)

theorem run_append (first second : List String) (control : Control) :
    runControl (first++second) control=(runControl first control).bind (fun left =>
      (runControl second left.1).map (fun right => (right.1,left.2++right.2))) := by
  induction first generalizing control with
  | nil => simp [runControl]
  | cons line rest ih =>
      simp only [List.cons_append,runControl,ih]
      cases head : step line control with
      | none => simp
      | some first =>
          cases middle : runControl rest first.1 with
          | none => simp [middle]
          | some next =>
              cases last : runControl second next.1 <;> simp [middle,last,List.append_assoc]

def preprocess (lines : List String) : Option (List String) := do
  let (last,visible) ← runControl lines initial
  if last.stack.isEmpty then pure visible else none
def makeSource : Option (List String) := preprocess ((Pinned.keygenLines.drop 7780).take 407)

theorem unmatched_end_rejected : preprocess ["#endif\n"]=none := by decide
theorem unclosed_if_rejected : preprocess ["#if TRUE_TERNARY_SECRET\n"]=none := by decide
theorem duplicate_else_rejected : preprocess ["#if TRUE_TERNARY_SECRET\n","#else\n","#else\n","#endif\n"]=none := by decide
theorem active_error_rejected : preprocess ["#error Unsupported\n"]=none := by decide
theorem selected_ternary_mode :
    preprocess ["#if TRUE_TERNARY_SECRET_MODE == 1\n","one\n","#elif TRUE_TERNARY_SECRET_MODE == 2\n","two\n","#else\n","#error Unsupported\n","#endif\n"]=some ["one\n"] := by decide

end FT1536.Source3.KeygenM0Preprocess
