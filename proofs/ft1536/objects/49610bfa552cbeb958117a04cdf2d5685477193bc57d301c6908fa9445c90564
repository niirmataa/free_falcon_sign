import Source3.KeygenPublicScalar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Public helper expressions use the fixed mq scalar closure and real
   unsigned16 loads; signed int16 inputs are selected by declared parameters.
   In particular they do not fall back to the solver's closed modp calls. -/
namespace FT1536.Source3.KeygenPublicWord
open C99ArrayReference (State Name)
open C99IntegerReference (Value Ty)
open C99MemoryReference
open KeygenWordExpr (Expr)

def scalar (s : State) (e : CLogic.Expr) (v : Value) : Prop :=
  C99ScalarReference.Eval KeygenPublicScalar.Call s.locals (C99Frontend.expression e) v
inductive Address (s : State) : Name → CLogic.Expr → ArrayPointer → Prop where
  | add (name : Name) (index : CLogic.Expr) (p q : ArrayPointer) (v : Value)
      (binding : s.arrays name=some p) (value : scalar s index v) (nonnegative : 0≤v.integer)
      (within : PointerAdd p v.integer.toNat q) : Address s name index q
inductive Eval (signed : List Name) (s : State) : Expr → Value → Prop where
  | scalar (e : CLogic.Expr) (v : Value) (source : scalar s e v) : Eval signed s (.scalar e) v
  | load16 (name : Name) (index : CLogic.Expr) (p : ArrayPointer) (w : BitVec 16)
      (address : Address s name index p) (read : C99NarrowReads.Load16 s.heap p w) :
      Eval signed s (.load16 name index)
        (if signed.contains name then C99NarrowReads.signedPromotion w else C99NarrowReads.unsignedPromotion w)
  | cast (ty : Ty) (e : Expr) (v : Value) (source : Eval signed s e v) :
      Eval signed s (.cast ty e) (C99IntegerReference.convert ty v.integer)
  | neg (e : Expr) (v z : Value) (source : Eval signed s e v) (op : C99IntegerReference.NegExec v z) : Eval signed s (.neg e) z
  | bitNot (e : Expr) (v z : Value) (source : Eval signed s e v) (op : C99IntegerReference.ComplementExec v z) : Eval signed s (.bitNot e) z
  | lnot (e : Expr) (v : Value) (source : Eval signed s e v) : Eval signed s (.lnot e) (C99ScalarReference.boolean (decide (v.integer=0)))
  | bin (op : B20.C.BinOp) (a b : Expr) (x y z : Value) (left : Eval signed s a x) (right : Eval signed s b y)
      (operation : C99OperatorBridge.Binary op x y z) : Eval signed s (.bin op a b) z
  | cmp (op : CLogic.Cmp) (a b : Expr) (x y z : Value) (left : Eval signed s a x) (right : Eval signed s b y)
      (operation : C99IntegerReference.CompareExec (C99Frontend.comparison op) x y z) : Eval signed s (.cmp op a b) z
  | andFalse (a b : Expr) (x : Value) (left : Eval signed s a x) (zero : x.integer=0) : Eval signed s (.land a b) (C99ScalarReference.boolean false)
  | andTrue (a b : Expr) (x y : Value) (left : Eval signed s a x) (nonzero : x.integer≠0) (right : Eval signed s b y) :
      Eval signed s (.land a b) (C99ScalarReference.boolean (decide (y.integer≠0)))
  | orTrue (a b : Expr) (x : Value) (left : Eval signed s a x) (nonzero : x.integer≠0) : Eval signed s (.lor a b) (C99ScalarReference.boolean true)
  | orFalse (a b : Expr) (x y : Value) (left : Eval signed s a x) (zero : x.integer=0) (right : Eval signed s b y) :
      Eval signed s (.lor a b) (C99ScalarReference.boolean (decide (y.integer≠0)))
  | call1 (name : Name) (a : Expr) (x out : Value) (first : Eval signed s a x)
      (source : KeygenPublicScalar.Call name [x] out) : Eval signed s (.call1 name a) out
  | call2 (name : Name) (a b : Expr) (x y out : Value) (first : Eval signed s a x) (second : Eval signed s b y)
      (source : KeygenPublicScalar.Call name [x,y] out) : Eval signed s (.call2 name a b) out
  | call3 (name : Name) (a b c : Expr) (x y z out : Value)
      (first : Eval signed s a x) (second : Eval signed s b y) (third : Eval signed s c z)
      (source : KeygenPublicScalar.Call name [x,y,z] out) : Eval signed s (.call3 name a b c) out
  | call4 (name : Name) (a b c d : Expr) (x y z t out : Value)
      (first : Eval signed s a x) (second : Eval signed s b y) (third : Eval signed s c z) (fourth : Eval signed s d t)
      (source : KeygenPublicScalar.Call name [x,y,z,t] out) : Eval signed s (.call4 name a b c d) out
def narrow (v : Value) : BitVec 16 := BitVec.ofInt 16 v.integer
theorem narrowed_store (v : Value) :
    BitVec.ofNat 16 (narrow v).toNat=narrow v := by simp
inductive Bind (caller : State) : List C99ArrayReference.Param → List C99ArrayReference.Arg → State → Prop where
  | nil : Bind caller [] [] ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
  | scalar (ty : Ty) (name : Name) (e : CLogic.Expr) (ps : List C99ArrayReference.Param)
      (args : List C99ArrayReference.Arg) (out : State) (v : Value)
      (value : scalar caller e v) (rest : Bind caller ps args out) :
      Bind caller (.scalar ty name::ps) (.scalar e::args) (C99ArrayReference.bindValue out name ty v)
  | pointer (name source : Name) (index : CLogic.Expr) (p : ArrayPointer)
      (ps : List C99ArrayReference.Param) (args : List C99ArrayReference.Arg) (out : State)
      (value : Address caller source index p) (rest : Bind caller ps args out) :
      Bind caller (.pointer name::ps) (.pointer source index::args) (C99ArrayReference.bindPointer out name p)
theorem bind_heap (caller : State) (ps : List C99ArrayReference.Param) (args : List C99ArrayReference.Arg) (out : State)
    (source : Bind caller ps args out) : out.heap=caller.heap := by
  induction source <;> first | rfl | assumption

end FT1536.Source3.KeygenPublicWord
