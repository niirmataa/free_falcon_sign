import Source3.KeygenCodecStaticTerminal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Compositional calculations for pure integer expressions. The canonical
   operations are checked reference rules, not an evaluator or a codec oracle. -/
namespace FT1536.Source3.KeygenCodecScalarCalculation
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
abbrev IV := C99IntegerReference.Value

theorem unary_unique (op : Unary) (x : Value) (a b : Value)
    (first : UnaryOp op x a) (second : UnaryOp op x b) : a=b := by
  cases first <;> cases second
  · exact congrArg Value.integer (C99IntegerReference.neg_deterministic _ _ _ ‹_› ‹_›)
  · congr 1
    cases ‹C99IntegerReference.ComplementExec _ _›
    cases ‹C99IntegerReference.ComplementExec _ _›
    rfl
  · rfl

theorem binary_unique (op : Op) (x y a b : Value)
    (first : BinaryOp op x y a) (second : BinaryOp op x y b) : a=b := by
  cases first <;> cases second
  all_goals first
    | exact congrArg Value.integer (C99IntegerReference.arithmetic_deterministic _ _ _ _ _ ‹_› ‹_›)
    | exact congrArg Value.integer (C99IntegerReference.shift_deterministic _ _ _ _ _ ‹_› ‹_›)
    | exact congrArg Value.integer (C99IntegerReference.bitwise_deterministic _ _ _ _ _ ‹_› ‹_›)
    | (cases ‹C99IntegerReference.CompareExec _ _ _ _›; cases ‹C99IntegerReference.CompareExec _ _ _ _›; simp_all)
    | rfl

def Ordinary (name : Name) : Prop :=
  name≠"out".toList ∧ name≠"NULL".toList ∧ name≠"x".toList ∧ name≠"buf".toList

inductive Computes (l : Locals) : Expr → IV → Prop where
  | number (ty : Ty) (n : Nat) (v : IV)
      (value : castInteger ty (.int64 (BitVec.ofNat 64 n))=some v) : Computes l (.number ty n) v
  | scalar (name : Name) (ty : C99IntegerReference.Ty) (v : IV)
      (ordinary : Ordinary name) (cell : l.scalars name=some (ty,some v)) : Computes l (.variable name) v
  | cast (ty : Ty) (e : Expr) (v z : IV) (inner : Computes l e v)
      (converted : castInteger ty v=some z) : Computes l (.cast ty e) z
  | unary (op : Unary) (e : Expr) (v z : IV) (inner : Computes l e v)
      (operation : UnaryOp op (.integer v) (.integer z)) : Computes l (.unary op e) z
  | binary (op : Op) (a b : Expr) (x y z : IV) (left : Computes l a x) (right : Computes l b y)
      (operation : BinaryOp op (.integer x) (.integer y) (.integer z)) : Computes l (.binary op a b) z

theorem computes_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l : Locals) (e : Expr) (v : IV) (calculation : Computes l e v)
    (t : Locals) (result : Value) (source : Eval args heap buf e l result t) :
    result=.integer v ∧ t=l := by
  induction calculation generalizing t result with
  | number ty n v value => exact KeygenCodecNoneLength.number_eval args heap buf ty n v l t result value source
  | scalar name ty v ordinary cell =>
    cases source <;> simp_all [Ordinary]
  | cast ty e v z inner converted ih =>
    cases source with
    | cast ty e l t v z evaluated cast =>
      obtain ⟨same,last⟩ := ih t _ evaluated
      cases same
      exact ⟨congrArg Value.integer (Option.some.inj (cast.symm.trans converted)),last⟩
  | unary op e v z inner operation ih =>
    cases source with
    | unary op e l t v z evaluated actual =>
      obtain ⟨same,last⟩ := ih t _ evaluated
      subst v
      exact ⟨unary_unique _ _ _ _ actual operation,last⟩
    | dereference e l t p w evaluated load =>
      cases operation
  | binary op a b x y z left right operation ih1 ih2 =>
    cases source with
    | binary op a b l middle t x y z first second actual =>
      obtain ⟨same,last⟩ := ih1 middle _ first
      subst x
      subst middle
      obtain ⟨same,last⟩ := ih2 t _ second
      subst y
      exact ⟨binary_unique _ _ _ _ _ actual operation,last⟩
    | andFalse => cases operation
    | andTrue => cases operation
    | orTrue => cases operation
    | orFalse => cases operation

theorem assign_set (args : Args) (s t : State) (flow : Flow) (name : Name)
    (ty : C99IntegerReference.Ty) (old : Option IV) (rhs : Expr) (v : IV)
    (cell : s.locals.scalars name=some (ty,old)) (calculation : Computes s.locals rhs v)
    (source : Exec args (.write (.variable name) .set rhs) s t flow) :
    t=withLocals s (localSet s.locals name ty (some (C99IntegerReference.convert ty v.integer))) ∧ flow=.normal := by
  cases source with
  | bind => cases calculation; simp_all [Ordinary]
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal := Option.some.inj (declared.symm.trans cell)
    cases equal
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals rhs v calculation locals (.integer value) evaluated
    cases same
    subst locals
    cases assigned with
    | set => exact ⟨rfl,rfl⟩
    | compound op binary old rhs z operator operation => cases operator

end FT1536.Source3.KeygenCodecScalarCalculation
