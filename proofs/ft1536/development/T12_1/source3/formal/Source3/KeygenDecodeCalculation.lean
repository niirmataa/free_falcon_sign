import Source3.KeygenDecodePure

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Pure calculations of the decoder's actual expressions, including real
   byte reads. Each calculation supplies both existence and inversion of
   its operational derivation; it assumes no decoded value or source frame. -/
namespace FT1536.Source3.KeygenDecodeCalculation
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
abbrev IV := C99IntegerReference.Value

def Ordinary (name : Name) : Prop :=
  name≠"data".toList ∧ name≠"NULL".toList ∧ name≠"x".toList ∧ name≠"buf".toList

inductive Computes (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer)) (l : Locals) : Expr → IV → Prop where
  | number (ty : Ty) (n : Nat) (v : IV)
      (value : castInteger ty (.int64 (BitVec.ofNat 64 n))=some v) : Computes args heap buf l (.number ty n) v
  | scalar (name : Name) (ty : C99IntegerReference.Ty) (v : IV)
      (ordinary : Ordinary name) (cell : l.scalars name=some (ty,some v)) : Computes args heap buf l (.variable name) v
  | cast (ty : Ty) (e : Expr) (v z : IV) (inner : Computes args heap buf l e v)
      (converted : castInteger ty v=some z) : Computes args heap buf l (.cast ty e) z
  | unary (op : Unary) (e : Expr) (v z : IV) (inner : Computes args heap buf l e v)
      (operation : UnaryOp op (.integer v) (.integer z)) : Computes args heap buf l (.unary op e) z
  | binary (op : Op) (a b : Expr) (x y z : IV)
      (left : Computes args heap buf l a x) (right : Computes args heap buf l b y)
      (operation : BinaryOp op (.integer x) (.integer y) (.integer z)) : Computes args heap buf l (.binary op a b) z
  | byteIndex (index : Expr) (ptr atByte : ArrayPointer) (offset : IV) (word : BitVec 8)
      (held : buf=some (some ptr)) (indexValue : Computes args heap buf l index offset)
      (nonnegative : 0≤offset.integer) (advance : PointerAdd ptr offset.integer.toNat atByte)
      (load : LoadByte heap atByte word) :
      Computes args heap buf l (.index (.variable "buf".toList) index) (.int32 (BitVec.ofNat 32 word.toNat))

theorem byte_unique (heap : Memory) (ptr : ArrayPointer) (a b : BitVec 8)
    (first : LoadByte heap ptr a) (second : LoadByte heap ptr b) : a=b := by
  cases first; cases second
  exact Option.some.inj (‹heap.bytes ptr.block ptr.offset=some a›.symm.trans ‹heap.bytes ptr.block ptr.offset=some b›)

theorem pointer_unique (ptr a b : ArrayPointer) (n : Nat)
    (first : PointerAdd ptr n a) (second : PointerAdd ptr n b) : a=b := by
  cases first; cases second; rfl

/-- A calculation supplies a genuine finite operational expression derivation. -/
theorem computes_exists (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l : Locals) (e : Expr) (v : IV) (calculation : Computes args heap buf l e v) :
    Eval args heap buf e l (.integer v) l := by
  induction calculation with
  | number ty n v value => exact .number ty n v l value
  | scalar name ty v ordinary cell => exact .scalar name l ty v cell
  | cast ty e v z inner converted ih => exact .cast ty e l l v z ih converted
  | unary op e v z inner operation ih => exact .unary op e l l (.integer v) (.integer z) ih operation
  | binary op a b x y z left right operation ih1 ih2 => exact .binary op a b l l l (.integer x) (.integer y) (.integer z) ih1 ih2 operation
  | byteIndex index ptr atByte offset word held indexValue nonnegative advance load ih =>
    exact .byteIndex index l l ptr atByte offset word held ih nonnegative advance load

/-- Every actual derivation of that source expression has the calculated
    value and unchanged activation locals. -/
theorem computes_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l : Locals) (e : Expr) (v : IV) (calculation : Computes args heap buf l e v)
    (t : Locals) (result : Value) (source : Eval args heap buf e l result t) :
    result=.integer v ∧ t=l := by
  induction calculation generalizing t result with
  | number ty n v value => exact KeygenDecodePure.literal args heap buf l ty n v value t result source
  | scalar name ty v ordinary cell => cases source <;> simp_all [Ordinary]
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
      exact ⟨KeygenDecodePure.unary_unique _ _ _ _ actual operation,last⟩
    | dereference => cases operation
  | binary op a b x y z left right operation ih1 ih2 =>
    cases source with
    | binary op a b l middle t x y z first second actual =>
      obtain ⟨same,last⟩ := ih1 middle _ first
      subst x; subst middle
      obtain ⟨same,last⟩ := ih2 t _ second
      subst y
      exact ⟨KeygenDecodePure.binary_unique _ _ _ _ _ actual operation,last⟩
    | andFalse => cases operation
    | andTrue => cases operation
    | orTrue => cases operation
    | orFalse => cases operation
  | byteIndex index ptr atByte offset word held indexValue nonnegative advance load ih =>
    cases source with
    | byteIndex index l t actual atActual actualOffset actualWord actualHeld evaluated nonnegative' actualAdvance actualLoad =>
      have samePtr := Option.some.inj (Option.some.inj (actualHeld.symm.trans held))
      subst actual
      obtain ⟨same,last⟩ := ih t _ evaluated
      have equal := Value.integer.inj same
      subst actualOffset
      have equalPtr := pointer_unique _ _ _ _ actualAdvance advance
      subst atActual
      have equalWord := byte_unique heap atByte actualWord word actualLoad load
      subst actualWord
      exact ⟨rfl,last⟩

/-- Source assignment inversion, deriving the entire actual next state. -/
theorem assign_set (args : Args) (s t : State) (flow : Flow) (name : Name)
    (ty : C99IntegerReference.Ty) (old : Option IV) (rhs : Expr) (v : IV)
    (cell : s.locals.scalars name=some (ty,old)) (calculation : Computes args s.heap s.buf s.locals rhs v)
    (source : Exec args (.write (.variable name) .set rhs) s t flow) :
    t=withLocals s (localSet s.locals name ty (some (C99IntegerReference.convert ty v.integer))) ∧ flow=.normal := by
  cases source with
  | bind => cases calculation; simp_all [Ordinary]
  | scalar s name op rhs ty old value result locals notBuf notData declared evaluated assigned =>
    have equal := Option.some.inj (declared.symm.trans cell)
    cases equal
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals rhs v calculation locals (.integer value) evaluated
    cases same
    subst locals
    cases assigned with
    | set => exact ⟨rfl,rfl⟩
    | compound op binary old rhs z operator operation => cases operator

/-- The same calculation constructs the real source assignment, with no
    desired result or execution-existence premise. -/
theorem assign_exists (args : Args) (s : State) (name : Name)
    (ty : C99IntegerReference.Ty) (old : Option IV) (rhs : Expr) (v : IV)
    (notBuf : name≠"buf".toList) (notData : name≠"data".toList)
    (cell : s.locals.scalars name=some (ty,old)) (calculation : Computes args s.heap s.buf s.locals rhs v) :
    Exec args (.write (.variable name) .set rhs) s
      (withLocals s (localSet s.locals name ty (some (C99IntegerReference.convert ty v.integer)))) .normal :=
  .scalar args s name .set rhs ty old v v s.locals notBuf notData cell
    (computes_exists args s.heap s.buf s.locals rhs v calculation) (.set old v)

end FT1536.Source3.KeygenDecodeCalculation
