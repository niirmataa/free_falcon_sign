import Source3.KeygenAttemptMaterial
import Source3.KeygenRootCaller

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The dimension and ternary-local initialization fragments of the caller.
   Automatic coefficient allocation, RNG readiness and the enclosing capped
   loop are B1.07 obligations, not silently included in this fragment relation. -/
namespace FT1536.Source3.KeygenCallerInit
open C99ArrayReference (State Name bindValue bindPointer)
open C99MemoryReference
open C99IntegerReference (Value)
open KeygenSearchContext (Context)

def scalarDeclared (s : State) : State :=
  C99DeclarationStatements.effect .u64 ["n".toList,"u".toList]
    (C99DeclarationStatements.effect .u32 ["logn".toList,"ter".toList] s)
def logged (s : State) (word : BitVec 32) : State :=
  bindValue (scalarDeclared s) "logn".toList .uint32 (.uint32 word)
def ternary (s : State) (logn ter : BitVec 32) : State :=
  bindValue (logged s logn) "ter".toList .uint32 (.uint32 ter)
def sized (s : State) : State := bindValue (ternary s 10 1) "n".toList .uint64 (.uint64 1536)
def sizeExpr : CLogic.Expr := C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList)
def lex (text : String) : Option (List B20.C.Token) := KeygenZintCall.tokens text.toList
theorem scalar_declarations_source : KeygenRootSearch.tokens 7805 2=lex "unsigned logn, ter; size_t n, u;" := by decide
theorem dimensions_source : KeygenRootSearch.tokens 7824 3=lex "logn = fk->logn; ter = fk->ternary; n = MKN(logn, ter);" := by decide
inductive Dimensions (ctx : Context) (before : State) : State → Prop where
  | run (logn ter : BitVec 32) (n : Value)
      (first : KeygenSearchContext.ReadLogn ctx (scalarDeclared before) logn)
      (second : KeygenSearchContext.ReadTernary ctx (logged before logn) ter)
      (size : C99ArrayReference.scalar (ternary before logn ter) sizeExpr n) :
      Dimensions ctx before (bindValue (ternary before logn ter) "n".toList .uint64 n)
theorem dimensions_exact (ctx : Context) (before after : State)
    (profile : KeygenSearchContext.M0 before.heap ctx) (source : Dimensions ctx before after) : after=sized before := by
  cases source with
  | run logn ter n first second size =>
    have hl := KeygenSearchContext.logn_m0 ctx (scalarDeclared before) logn profile first
    subst logn
    have ht := KeygenSearchContext.ternary_m0 ctx (logged before 10) ter profile second
    subst ter
    have hn := KeygenSmallBounds.mkn_value (ternary before 10 1) n ⟨rfl,rfl⟩ size
    simp only [bindValue,hn,sized]
    rfl

def rtNames : List Name := ["rt1".toList,"rt2".toList,"rt3".toList]
def rtDeclared (s : State) : State :=
  C99DeclarationStatements.effect .u64 ["norm".toList,"bound".toList]
    {s with arrays := fun name => if rtNames.contains name then none else s.arrays name}
def rt (ctx : Context) (i : Nat) : ArrayPointer :=
  let p := KeygenSearchMemory.view ctx.scratch 8
  {p with index := p.index+1536*i}
def ready (ctx : Context) (s : State) : State :=
  bindPointer (bindPointer (bindPointer (rtDeclared (sized s)) "rt1".toList (rt ctx 0))
    "rt2".toList (rt ctx 1)) "rt3".toList (rt ctx 2)
def setupCode : KeygenSearchExec.Stmt := KeygenSearchExec.chain [
  KeygenSearchExec.chain (rtNames.map (fun name => .procedure (.base (.declarePtr name)))),
  .procedure (.base (.scalar (.declare .u64 ["norm".toList,"bound".toList]))),
  .pointer "rt1".toList (.cast 8 .tmp),
  .pointer "rt2".toList (.named "rt1".toList (.var "n".toList)),
  .pointer "rt3".toList (.named "rt2".toList (.var "n".toList))]
def setupParsed : Option KeygenSearchExec.Stmt := do
  let tokens ← C99ProcedureParser.tokens (((Pinned.keygenLines.drop 7875).take 6).flatMap String.toList++['}'])
  let (code,_,rest) ← KeygenSearchParser.body [] 64 tokens
  if rest.isEmpty then pure code else none
theorem setup_source : setupParsed=some setupCode := by decide
theorem setup_declarations : KeygenSearchParser.declarations setupCode=
    (["norm".toList,"bound".toList],rtNames) := by decide
inductive Setup (ctx : Context) (before : State) : State → Prop where
  | run (p q r : ArrayPointer)
      (first : KeygenSearchExec.EvalPointer ctx (rtDeclared before) (.cast 8 .tmp) p)
      (second : C99ArrayReference.Pointer (bindPointer (rtDeclared before) "rt1".toList p)
        "rt1".toList (.var "n".toList) q)
      (third : C99ArrayReference.Pointer (bindPointer (bindPointer (rtDeclared before) "rt1".toList p) "rt2".toList q)
        "rt2".toList (.var "n".toList) r) :
      Setup ctx before (bindPointer (bindPointer (bindPointer (rtDeclared before) "rt1".toList p) "rt2".toList q) "rt3".toList r)
theorem pointer_n (s : State) (name : Name) (root p : ArrayPointer)
    (binding : s.arrays name=some root) (size : C99CountedWords.Limit s)
    (source : C99ArrayReference.Pointer s name (.var "n".toList) p) : p={root with index := root.index+1536} := by
  obtain ⟨v,value,equal⟩ := KeygenNttLoopSupport.pointer_root s name _ root p binding source
  have hv := C99CountedWords.variable_exact s "n".toList .uint64 (.uint64 1536) v size value
  subst v
  exact equal
theorem setup_exact (ctx : Context) (before after : State) (source : Setup ctx (sized before) after) : after=ready ctx before := by
  cases source with
  | run p q r first second third =>
    have hp : p=KeygenSearchMemory.view ctx.scratch 8 := by
      cases first with
      | cast width e raw p value cast =>
        cases value with
        | tmp raw read =>
          rw [KeygenSearchContext.tmp_value ctx _ raw read] at cast
          exact cast.2.2.2.2
    subst p
    have hq := pointer_n (bindPointer (rtDeclared (sized before)) "rt1".toList _) "rt1".toList _ q rfl (by rfl) second
    subst q
    have hr := pointer_n (bindPointer (bindPointer (rtDeclared (sized before)) "rt1".toList _) "rt2".toList _) "rt2".toList _ r rfl (by rfl) third
    subst r
    simp only [ready,rt,Nat.mul_zero,Nat.add_zero,Nat.mul_succ,Nat.add_assoc]

inductive Exec (ctx : Context) (before : State) : State → Prop where
  | run (dimensioned after : State) (dimensions : Dimensions ctx before dimensioned)
      (setup : Setup ctx dimensioned after) : Exec ctx before after
theorem exact_state (ctx : Context) (before after : State) (profile : KeygenSearchContext.M0 before.heap ctx)
    (source : Exec ctx before after) : after=ready ctx before := by
  cases source with
  | run dimensioned after dimensions setup =>
    have h := dimensions_exact ctx before dimensioned profile dimensions
    subst dimensioned
    exact setup_exact ctx before after setup
theorem ready_heap (ctx : Context) (s : State) : (ready ctx s).heap=s.heap := rfl
theorem ready_tables (ctx : Context) (s : State) : (ready ctx s).tables=s.tables := rfl
theorem ready_size (ctx : Context) (s : State) : C99CountedWords.Limit (ready ctx s) := rfl
theorem ready_slot (ctx : Context) (s : State) (name : Name) (outside : name∉rtNames) :
    (ready ctx s).arrays name=s.arrays name := by
  have absent : rtNames.contains name=false := by
    cases h : rtNames.contains name with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp h)).elim
  have h1 : name≠"rt1".toList := fun h => outside (h ▸ (by decide))
  have h2 : name≠"rt2".toList := fun h => outside (h ▸ (by decide))
  have h3 : name≠"rt3".toList := fun h => outside (h ▸ (by decide))
  simp only [ready,bindPointer,rtDeclared,C99DeclarationStatements.effect,sized,ternary,logged,scalarDeclared,
    bindValue,h1,h2,h3,absent,ite_false,Bool.false_eq_true]
theorem ready_rt (ctx : Context) (s : State) (name : Name) (member : name∈rtNames) (p : ArrayPointer)
    (binding : (ready ctx s).arrays name=some p) : p.block=ctx.scratch.block := by
  rcases List.mem_cons.mp member with he | member
  · subst name; have hp : rt ctx 0=p := Option.some.inj binding; rw [← hp]; rfl
  rcases List.mem_cons.mp member with he | member
  · subst name; have hp : rt ctx 1=p := Option.some.inj binding; rw [← hp]; rfl
  rcases List.mem_cons.mp member with he | member
  · subst name; have hp : rt ctx 2=p := Option.some.inj binding; rw [← hp]; rfl
  · cases member

end FT1536.Source3.KeygenCallerInit
