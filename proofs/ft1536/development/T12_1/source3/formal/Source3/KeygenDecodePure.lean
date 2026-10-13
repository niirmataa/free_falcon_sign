import Source3.KeygenDecodeNoneFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Compositional inversion of actual decoder expression derivations.
   Denotes does not assert existence of an expression or whole execution. -/
namespace FT1536.Source3.KeygenDecodePure
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference

abbrev Denotes (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (locals : Locals) (e : Expr) (value : C99IntegerReference.Value) : Prop :=
  ∀ after result, Eval args heap buf e locals result after →
    result=.integer value ∧ after=locals

theorem compare_unique (op : C99IntegerReference.Comparison) (x y a b : C99IntegerReference.Value)
    (first : C99IntegerReference.CompareExec op x y a)
    (second : C99IntegerReference.CompareExec op x y b) : a=b := by
  cases first; cases second; simp_all

theorem binary_unique (op : Op) (x y a b : Value)
    (first : BinaryOp op x y a) (second : BinaryOp op x y b) : a=b := by
  cases first <;> cases second
  all_goals first
    | exact congrArg Value.integer (C99IntegerReference.arithmetic_deterministic _ _ _ _ _ ‹_› ‹_›)
    | exact congrArg Value.integer (C99IntegerReference.shift_deterministic _ _ _ _ _ ‹_› ‹_›)
    | exact congrArg Value.integer (C99IntegerReference.bitwise_deterministic _ _ _ _ _ ‹_› ‹_›)
    | exact congrArg Value.integer (compare_unique _ _ _ _ _ ‹_› ‹_›)
    | rfl

theorem unary_unique (op : Unary) (x a b : Value)
    (first : UnaryOp op x a) (second : UnaryOp op x b) : a=b := by
  cases first <;> cases second
  · exact congrArg Value.integer (C99IntegerReference.neg_deterministic _ _ _ ‹_› ‹_›)
  · cases ‹C99IntegerReference.ComplementExec _ _›
    cases ‹C99IntegerReference.ComplementExec _ _›
    rfl
  · rfl

theorem literal (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (locals : Locals) (ty : Ty) (n : Nat) (value : C99IntegerReference.Value)
    (computed : castInteger ty (.int64 (BitVec.ofNat 64 n))=some value) :
    Denotes args heap buf locals (.number ty n) value := by
  intro after result evaluated
  cases evaluated with
  | number ty n v l cast =>
    have same := Option.some.inj (cast.symm.trans computed)
    subst v
    exact ⟨rfl,rfl⟩

theorem scalar (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (locals : Locals) (name : Name) (ty : C99IntegerReference.Ty) (value : C99IntegerReference.Value)
    (held : locals.scalars name=some (ty,some value))
    (ordinary : name≠"x".toList ∧ name≠"buf".toList ∧ name≠"data".toList ∧ name≠"NULL".toList) :
    Denotes args heap buf locals (.variable name) value := by
  intro after result evaluated
  cases evaluated <;> simp_all

theorem cast (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (locals : Locals) (ty : Ty) (e : Expr) (value result : C99IntegerReference.Value)
    (inner : Denotes args heap buf locals e value) (computed : castInteger ty value=some result) :
    Denotes args heap buf locals (.cast ty e) result := by
  intro after actual evaluated
  cases evaluated with
  | cast ty e l t v z evaluated converted =>
    obtain ⟨same,last⟩ := inner _ _ evaluated
    have sameV := Value.integer.inj same
    subst v
    have sameZ := Option.some.inj (converted.symm.trans computed)
    subst z
    exact ⟨rfl,last⟩

theorem binary (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (locals : Locals) (op : Op) (a b : Expr) (x y result : C99IntegerReference.Value)
    (left : Denotes args heap buf locals a x) (right : Denotes args heap buf locals b y)
    (computed : BinaryOp op (.integer x) (.integer y) (.integer result))
    (ordinary : op≠.land ∧ op≠.lor) :
    Denotes args heap buf locals (.binary op a b) result := by
  intro after actual evaluated
  cases evaluated with
  | binary op a b l m t x' y' z first second operation =>
    obtain ⟨sameX,middle⟩ := left _ _ first
    subst x'; subst m
    obtain ⟨sameY,last⟩ := right _ _ second
    subst y'
    exact ⟨binary_unique _ _ _ _ _ operation computed,last⟩
  | andFalse => exact (ordinary.1 rfl).elim
  | andTrue => exact (ordinary.1 rfl).elim
  | orTrue => exact (ordinary.2 rfl).elim
  | orFalse => exact (ordinary.2 rfl).elim

theorem unary (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (locals : Locals) (op : Unary) (e : Expr) (value result : C99IntegerReference.Value)
    (inner : Denotes args heap buf locals e value)
    (computed : UnaryOp op (.integer value) (.integer result))
    (ordinary : op≠.dereference) :
    Denotes args heap buf locals (.unary op e) result := by
  intro after actual evaluated
  cases evaluated with
  | unary op e l t v z evaluated operation =>
    obtain ⟨same,last⟩ := inner _ _ evaluated
    subst v
    exact ⟨unary_unique _ _ _ _ operation computed,last⟩
  | dereference => exact (ordinary rfl).elim

end FT1536.Source3.KeygenDecodePure
