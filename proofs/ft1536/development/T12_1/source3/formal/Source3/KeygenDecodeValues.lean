import Source3.KeygenDecodeSyntax
import Source3.C99MemoryReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Independent decoder value semantics. Byte reads use allocated initialized
   physical memory; scalar arithmetic retains C99/GCC LP64 definedness.
   This module defines rules only and claims no whole-decoder correctness. -/
namespace FT1536.Source3.KeygenDecodeValues
open KeygenDecodeSyntax
open C99MemoryReference
abbrev Name := List Char

def calleeArgs : Expr := argumentTree
  [.variable "x".toList,.variable "logn".toList,
   .variable "q".toList,.variable "data".toList,.variable "len".toList]

structure Args where
  data : Option ArrayPointer
  len : BitVec 64
  comp : BitVec 32
  q : BitVec 32
  x : Option ArrayPointer
  logn : BitVec 32

inductive Value where
  | integer (value : C99IntegerReference.Value)
  | pointer (value : Option ArrayPointer)
  deriving DecidableEq, Repr

structure Locals where
  scalars : C99ScalarReference.Env
  x : Option ArrayPointer

structure State where
  heap : Memory
  locals : Locals
  buf : Option (Option ArrayPointer)

def initialLocals (args : Args) : Locals :=
  ⟨fun name =>
    if name="len".toList then some (.uint64,some (.uint64 args.len))
    else if name="comp".toList then some (.int32,some (.int32 args.comp))
    else if name="q".toList then some (.uint32,some (.uint32 args.q))
    else if name="logn".toList then some (.uint32,some (.uint32 args.logn))
    else none,args.x⟩

def initial (args : Args) (heap : Memory) : State := ⟨heap,initialLocals args,none⟩
def withLocals (s : State) (locals : Locals) : State := {s with locals := locals}
def localSet (l : Locals) (name : Name) (ty : C99IntegerReference.Ty) (value : Option C99IntegerReference.Value) : Locals :=
  {l with scalars := C99ScalarReference.set l.scalars name (ty,value)}

def scalarTy : Ty → Option C99IntegerReference.Ty
  | .i32 => some .int32 | .u32 => some .uint32
  | .size | .u64 => some .uint64 | .long => some .int64
  | _ => none

/-- Narrow integer casts produce their integer-promoted value. In these
    bodies byte casts only feed byte stores; int16 reads promote to int. -/
def castInteger (ty : Ty) (v : C99IntegerReference.Value) : Option C99IntegerReference.Value :=
  match ty with
  | .byte => some (.int32 (BitVec.ofNat 32 (BitVec.ofInt 8 v.integer).toNat))
  | .i16 => some (.int32 (BitVec.ofInt 32 (BitVec.ofInt 16 v.integer).toInt))
  | .u16 => some (.int32 (BitVec.ofNat 32 (BitVec.ofInt 16 v.integer).toNat))
  | _ => (scalarTy ty).map (fun t => C99IntegerReference.convert t v.integer)

def truth : Value → Bool
  | .integer v => decide (v.integer≠0)
  | .pointer p => p.isSome
def boolean (b : Bool) : Value := .integer (C99ScalarReference.boolean b)

/-- Exact little-endian int16 load from the source array, before x++.
    Allocation, alignment and initialization are required for a derivation. -/
inductive Load16 : Memory → ArrayPointer → BitVec 16 → Prop where
  | load (heap : Memory) (p : ArrayPointer) (lo hi : BitVec 8)
      (allocated : Allocated heap p) (width : p.elementBytes=2)
      (low : heap.bytes p.block p.offset=some lo)
      (high : heap.bytes p.block (p.offset+1)=some hi) :
      Load16 heap p (hi ++ lo)

inductive LoadByte : Memory → ArrayPointer → BitVec 8 → Prop where
  | load (heap : Memory) (ptr : ArrayPointer) (word : BitVec 8)
      (allocated : Allocated heap ptr) (width : ptr.elementBytes=1)
      (initialized : heap.bytes ptr.block ptr.offset=some word) : LoadByte heap ptr word

inductive UnaryOp : Unary → Value → Value → Prop where
  | neg (x z : C99IntegerReference.Value) (operation : C99IntegerReference.NegExec x z) : UnaryOp .neg (.integer x) (.integer z)
  | bitnot (x z : C99IntegerReference.Value) (operation : C99IntegerReference.ComplementExec x z) : UnaryOp .bitnot (.integer x) (.integer z)
  | logicalNot (v : Value) : UnaryOp .logicalNot v (boolean (!truth v))

inductive BinaryOp : Op → Value → Value → Value → Prop where
  | add (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.ArithmeticExec .plus x y z) : BinaryOp .add (.integer x) (.integer y) (.integer z)
  | sub (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.ArithmeticExec .minus x y z) : BinaryOp .sub (.integer x) (.integer y) (.integer z)
  | mul (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.ArithmeticExec .times x y z) : BinaryOp .mul (.integer x) (.integer y) (.integer z)
  | shl (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.ShiftExec .left x y z) : BinaryOp .shl (.integer x) (.integer y) (.integer z)
  | shr (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.ShiftExec .right x y z) : BinaryOp .shr (.integer x) (.integer y) (.integer z)
  | band (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.BitwiseExec .and x y z) : BinaryOp .band (.integer x) (.integer y) (.integer z)
  | bor (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.BitwiseExec .or x y z) : BinaryOp .bor (.integer x) (.integer y) (.integer z)
  | bxor (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.BitwiseExec .xor x y z) : BinaryOp .bxor (.integer x) (.integer y) (.integer z)
  | eq (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.CompareExec .eq x y z) : BinaryOp .eq (.integer x) (.integer y) (.integer z)
  | ne (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.CompareExec .ne x y z) : BinaryOp .ne (.integer x) (.integer y) (.integer z)
  | lt (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.CompareExec .lt x y z) : BinaryOp .lt (.integer x) (.integer y) (.integer z)
  | le (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.CompareExec .le x y z) : BinaryOp .le (.integer x) (.integer y) (.integer z)
  | gt (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.CompareExec .gt x y z) : BinaryOp .gt (.integer x) (.integer y) (.integer z)
  | ge (x y z : C99IntegerReference.Value) (operation : C99IntegerReference.CompareExec .ge x y z) : BinaryOp .ge (.integer x) (.integer y) (.integer z)
  | pointerEq (p q : Option ArrayPointer) : BinaryOp .eq (.pointer p) (.pointer q) (boolean (decide (p=q)))
  | pointerNe (p q : Option ArrayPointer) : BinaryOp .ne (.pointer p) (.pointer q) (boolean (decide (p≠q)))

/-- Scalar increment/decrement uses the declared cell type and the promoted C operation.
    Pointer x++ uses one-past-bounded array arithmetic. buf/data cannot be
    incremented by this codec fragment. There is no open callback. -/
inductive Update : Name → Int → Locals → Value → Value → Locals → Prop where
  | scalar (name : Name) (delta : Int) (l : Locals) (ty : C99IntegerReference.Ty) (v z : C99IntegerReference.Value)
      (bound : l.scalars name=some (ty,some v))
      (operation : C99IntegerReference.ArithmeticExec .plus v (.int32 (BitVec.ofInt 32 delta)) z) :
      Update name delta l (.integer v) (.integer (C99IntegerReference.convert ty z.integer))
        (localSet l name ty (some (C99IntegerReference.convert ty z.integer)))
  | pointer (l : Locals) (p next : ArrayPointer) (held : l.x=some p)
      (operation : PointerAdd p 1 next) :
      Update "x".toList 1 l (.pointer (some p)) (.pointer (some next)) {l with x := some next}

/-- Expressions evaluate on the same heap and buf binding. The changing
    locals carry postdecrement test effects and preincrement values. The
    fixed returning codec calls are statement rules, not expression oracles.
    Unsequenced operands are evaluated left first in this reference model;
    the pinned fragment has no conflicting operand updates. -/
inductive Eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer)) :
    Expr → Locals → Value → Locals → Prop where
  | number (ty : Ty) (n : Nat) (v : C99IntegerReference.Value) (l : Locals)
      (cast : castInteger ty (.int64 (BitVec.ofNat 64 n))=some v) :
      Eval args heap buf (.number ty n) l (.integer v) l
  | scalar (name : Name) (l : Locals) (ty : C99IntegerReference.Ty) (v : C99IntegerReference.Value)
      (bound : l.scalars name=some (ty,some v)) : Eval args heap buf (.variable name) l (.integer v) l
  | data (l : Locals) : Eval args heap buf (.variable "data".toList) l (.pointer args.data) l
  | null (l : Locals) : Eval args heap buf (.variable "NULL".toList) l (.pointer none) l
  | input (l : Locals) : Eval args heap buf (.variable "x".toList) l (.pointer l.x) l
  | buffer (l : Locals) (p : Option ArrayPointer) (held : buf=some p) :
      Eval args heap buf (.variable "buf".toList) l (.pointer p) l
  | preInc (name : Name) (l t : Locals) (old value : Value) (operation : Update name 1 l old value t) :
      Eval args heap buf (.preInc (.variable name)) l value t
  | postInc (name : Name) (l t : Locals) (value next : Value) (operation : Update name 1 l value next t) :
      Eval args heap buf (.postInc (.variable name)) l value t
  | preDec (name : Name) (l t : Locals) (old value : Value) (operation : Update name (-1) l old value t) :
      Eval args heap buf (.preDec (.variable name)) l value t
  | postDec (name : Name) (l t : Locals) (value next : Value) (operation : Update name (-1) l value next t) :
      Eval args heap buf (.postDec (.variable name)) l value t
  | cast (ty : Ty) (e : Expr) (l t : Locals) (v z : C99IntegerReference.Value)
      (evaluated : Eval args heap buf e l (.integer v) t) (cast : castInteger ty v=some z) :
      Eval args heap buf (.cast ty e) l (.integer z) t
  | unary (op : Unary) (e : Expr) (l t : Locals) (v z : Value)
      (evaluated : Eval args heap buf e l v t) (operation : UnaryOp op v z) :
      Eval args heap buf (.unary op e) l z t
  | dereference (e : Expr) (l t : Locals) (p : ArrayPointer) (w : BitVec 16)
      (evaluated : Eval args heap buf e l (.pointer (some p)) t) (load : Load16 heap p w) :
      Eval args heap buf (.unary .dereference e) l (.integer (.int32 (BitVec.ofInt 32 w.toInt))) t
  | byteIndex (index : Expr) (l t : Locals) (ptr atByte : ArrayPointer)
      (offset : C99IntegerReference.Value) (word : BitVec 8)
      (held : buf=some (some ptr))
      (evaluated : Eval args heap buf index l (.integer offset) t)
      (nonnegative : 0≤offset.integer)
      (advance : PointerAdd ptr offset.integer.toNat atByte)
      (load : LoadByte heap atByte word) :
      Eval args heap buf (.index (.variable "buf".toList) index) l
        (.integer (.int32 (BitVec.ofNat 32 word.toNat))) t
  | binary (op : Op) (a b : Expr) (l m t : Locals) (x y z : Value)
      (first : Eval args heap buf a l x m) (second : Eval args heap buf b m y t)
      (operation : BinaryOp op x y z) : Eval args heap buf (.binary op a b) l z t
  | andFalse (a b : Expr) (l t : Locals) (v : Value)
      (first : Eval args heap buf a l v t) (zero : truth v=false) :
      Eval args heap buf (.binary .land a b) l (boolean false) t
  | andTrue (a b : Expr) (l m t : Locals) (x y : Value)
      (first : Eval args heap buf a l x m) (nonzero : truth x=true)
      (second : Eval args heap buf b m y t) :
      Eval args heap buf (.binary .land a b) l (boolean (truth y)) t
  | orTrue (a b : Expr) (l t : Locals) (v : Value)
      (first : Eval args heap buf a l v t) (nonzero : truth v=true) :
      Eval args heap buf (.binary .lor a b) l (boolean true) t
  | orFalse (a b : Expr) (l m t : Locals) (x y : Value)
      (first : Eval args heap buf a l x m) (zero : truth x=false)
      (second : Eval args heap buf b m y t) :
      Eval args heap buf (.binary .lor a b) l (boolean (truth y)) t
  | conditionalTrue (test a b : Expr) (l m t : Locals) (v z : Value)
      (condition : Eval args heap buf test l v m) (nonzero : truth v=true)
      (selected : Eval args heap buf a m z t) : Eval args heap buf (.conditional test a b) l z t
  | conditionalFalse (test a b : Expr) (l m t : Locals) (v z : Value)
      (condition : Eval args heap buf test l v m) (zero : truth v=false)
      (selected : Eval args heap buf b m z t) : Eval args heap buf (.conditional test a b) l z t

def assignOp : Assign → Option Op
  | .set => none | .add => some .add | .sub => some .sub
  | .band => some .band | .bor => some .bor | .shl => some .shl

inductive Assigned : Assign → Option C99IntegerReference.Value → C99IntegerReference.Value → C99IntegerReference.Value → Prop where
  | set (old : Option C99IntegerReference.Value) (rhs : C99IntegerReference.Value) : Assigned .set old rhs rhs
  | compound (op : Assign) (binary : Op) (old rhs z : C99IntegerReference.Value)
      (operator : assignOp op=some binary)
      (operation : BinaryOp binary (.integer old) (.integer rhs) (.integer z)) :
      Assigned op (some old) rhs z

/-- Declarations overwrite private activation cells with uninitialized
    values. buf has its own nullable pointer slot. The source fragment has
    no escaping address of an automatic scalar. Scope exit is implemented
    by the statement semantics, not by heap frame assumptions. -/
def declareLocals : List Object → Locals → Option Locals
  | [],l => some l
  | o::rest,l =>
      if o.count.isSome then none
      else if o.name="buf".toList then
        if o.type=.pointer (.readonly .byte) then declareLocals rest l else none
      else do
        let ty ← scalarTy o.type
        declareLocals rest (localSet l o.name ty none)

def hasBuf (objects : List Object) : Bool := objects.any (fun o => o.name=="buf".toList)
def declared (s : State) (objects : List Object) (locals : Locals) : State :=
  ⟨s.heap,locals,if hasBuf objects then none else s.buf⟩

end FT1536.Source3.KeygenDecodeValues
