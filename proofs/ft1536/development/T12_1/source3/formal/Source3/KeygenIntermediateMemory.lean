import Source3.KeygenSearchMemory
import Source3.KeygenSearchContext
import Source3.KeygenSearchParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete align_u32 and pointer expressions used by the intermediate
   caller. Casts bind before subsequent addition; pointer comparison is
   defined only for two positions of the same array object. -/
namespace FT1536.Source3.KeygenIntermediateMemory
open C99MemoryReference
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open KeygenSearchMemory (Cast)
open KeygenSearchContext (Context)
open B20.C (Token)

def update : C99ModularReference.Stmt := .base (.scalar (.update "k".toList .add
  (.bin .sub (.literal .u64 4) (.var "km".toList))))
def rounding : C99ModularReference.Stmt := .branch KeygenSearchMemory.condition
  (.scope [] (C99ModularParser.chain [update])) (.base .skip)
theorem helper_source : (Pinned.keygenLines.drop 5335).take 15=[
  "static uint32_t *\n","align_u32(void *base, void *data)\n","{\n",
  "\tunsigned char *cb, *cd;\n","\tsize_t k, km;\n","\n",
  "\tcb = base;\n","\tcd = data;\n","\tk = (size_t)(cd - cb);\n",
  "\tkm = k % sizeof(uint32_t);\n","\tif (km) {\n",
  "\t\tk += (sizeof(uint32_t)) - km;\n","\t}\n",
  "\treturn (uint32_t *)(cb + k);\n","}\n"] := by decide
inductive Align32 (before : State) (base data : ArrayPointer) : ArrayPointer → Prop where
  | run (cb cd : ArrayPointer) (k km : BitVec 64) (rounded : C99ProcedureReference.Result)
      (offset : BitVec 64) (bytePointer result : ArrayPointer)
      (baseCast : Cast base 1 cb) (dataCast : Cast data 1 cd)
      (sameBlock : cd.block=cb.block) (sameBase : cd.base=cb.base)
      (sameCount : cd.count=cb.count) (ordered : cb.index≤cd.index)
      (difference : (k.toNat : Int)=(cd.index : Int)-(cb.index : Int))
      (ptrdiffRange : k.toNat<2^63) (remainder : km=BitVec.ofNat 64 (k.toNat%4))
      (control : C99ModularReference.Exec rounding (KeygenSearchMemory.scalarEntry before k km) rounded)
      (normal : rounded.flow=.normal)
      (read : C99ArrayReference.scalar rounded.state (.var "k".toList) (.uint64 offset))
      (addition : PointerAdd cb offset.toNat bytePointer)
      (resultCast : Cast bytePointer 4 result) : Align32 before base data result
theorem align32_block (before : State) (base data result : ArrayPointer) (source : Align32 before base data result) :
    result.block=base.block := by
  cases source with
  | run cb cd k km rounded word bytePointer result bc dc sb sa sc ordered diff range rem control normal read add rc =>
    rw [rc.2.2.2.2]
    cases add
    rw [bc.2.2.2.2]
    rfl
theorem align64_block (before : State) (base data result : ArrayPointer)
    (source : KeygenSearchMemory.Align before base data result) : result.block=base.block := by
  cases source with
  | run cb cd k km rounded word bytePointer result bc dc sb sa sc ordered diff range rem control normal read add rc =>
    rw [rc.2.2.2.2]
    cases add
    rw [bc.2.2.2.2]
    rfl

inductive Expr where
  | named (name : Name)
  | tmp
  | cast (width : Nat) (value : Expr)
  | add (value : Expr) (index : CLogic.Expr)
  | align32 (base data : Expr)
  | align64 (base data : Expr)
  deriving DecidableEq, Repr
inductive Eval (ctx : Context) (s : State) : Expr → ArrayPointer → Prop where
  | named (name : Name) (p : ArrayPointer) (binding : s.arrays name=some p) : Eval ctx s (.named name) p
  | tmp (p : ArrayPointer) (source : KeygenSearchContext.ReadTmp ctx s p) : Eval ctx s .tmp p
  | cast (width : Nat) (e : Expr) (p q : ArrayPointer) (source : Eval ctx s e p)
      (view : Cast p width q) : Eval ctx s (.cast width e) q
  | add (e : Expr) (index : CLogic.Expr) (p q : ArrayPointer) (v : Value)
      (source : Eval ctx s e p) (value : C99ArrayReference.scalar s index v)
      (nonnegative : 0≤v.integer) (within : PointerAdd p v.integer.toNat q) : Eval ctx s (.add e index) q
  | align32 (base data : Expr) (p q out : ArrayPointer) (first : Eval ctx s base p) (second : Eval ctx s data q)
      (source : Align32 s p q out) : Eval ctx s (.align32 base data) out
  | align64 (base data : Expr) (p q out : ArrayPointer) (first : Eval ctx s base p) (second : Eval ctx s data q)
      (source : KeygenSearchMemory.Align s p q out) : Eval ctx s (.align64 base data) out
def only (names : List Name) : Expr → Bool
  | .named name => names.contains name
  | .tmp => true
  | .cast _ e | .add e _ => only names e
  | .align32 base _ | .align64 base _ => only names base
def Blocks (s : State) (names : List Name) (block : Nat) : Prop :=
  ∀ name∈names, ∀ p, s.arrays name=some p → block≠p.block
theorem eval_block (ctx : Context) (s : State) (e : Expr) (p : ArrayPointer) (source : Eval ctx s e p)
    (names : List Name) (checked : only names e=true) (block : Nat)
    (outside : Blocks s names block) (scratch : block≠ctx.scratch.block) : block≠p.block := by
  induction source with
  | named name p binding => exact outside name (List.contains_iff_mem.mp checked) p binding
  | tmp p source => rw [KeygenSearchContext.tmp_value ctx s p source]; exact scratch
  | cast width e p q source view ih => rw [view.2.2.2.2]; exact ih checked
  | add e index p q v source value nonnegative within ih => cases within; exact ih checked
  | align32 base data p q out first second source ih1 ih2 => rw [align32_block s p q out source]; exact ih1 checked
  | align64 base data p q out first second source ih1 ih2 => rw [align64_block s p q out source]; exact ih1 checked
def CompareLt (p q : ArrayPointer) (b : Bool) : Prop :=
  p.block=q.block ∧ p.base=q.base ∧ p.elementBytes=q.elementBytes ∧ p.count=q.count ∧
  p.index≤p.count ∧ q.index≤q.count ∧ b=decide (p.index<q.index)

def width (ty : Token) : Option Nat :=
  if ty="int32_t".toList then some 4 else KeygenSearchParser.typeWidth ty
mutual
  def atom : Nat → List Token → Option (Expr×List Token)
    | 0,_ => none
    | fuel+1,['(']::ty::['*']::[')']::rest => do
      let w ← width ty
      let (e,rest) ← atom fuel rest
      pure (.cast w e,rest)
    | fuel+1,['(']::rest => do
      let (e,rest) ← pointer fuel rest
      match rest with | [')']::rest => pure (e,rest) | _ => none
    | fuel+1,name::['(']::rest => do
      if name≠"align_u32".toList && name≠"align_fpr".toList then none else do
      let (base,rest) ← pointer fuel rest
      match rest with
      | [',']::rest => do
        let (data,rest) ← pointer fuel rest
        match rest with
        | [')']::rest => pure (if name="align_u32".toList then .align32 base data else .align64 base data,rest)
        | _ => none
      | _ => none
    | _+1,['f','k']::['-']::['>']::['t','m','p']::rest => some (.tmp,rest)
    | _+1,name::rest => if name.all B20.C.wordChar && !name.isEmpty then some (.named name,rest) else none
    | _,_ => none
  def pointer : Nat → List Token → Option (Expr×List Token)
    | 0,_ => none
    | fuel+1,rest => do
      let (e,rest) ← atom fuel rest
      match rest with
      | ['+']::rest => do
        let (index,rest) ← C99ArrayParser.pureExpr rest
        pure (.add e index,rest)
      | _ => pure (e,rest)
end
def castBeforeAdd : Expr := .add (.cast 4 (.named "k".toList)) (.var "n".toList)
theorem cast_before_add : pointer 32 (["(","uint32_t","*",")","k","+","n",";"].map String.toList)=
    some (castBeforeAdd,[[';']]) := by decide

end FT1536.Source3.KeygenIntermediateMemory
