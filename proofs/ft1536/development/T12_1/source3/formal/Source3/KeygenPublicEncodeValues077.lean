import Source3.KeygenCodecValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Public uint16 loads promote UNSIGNED values to int32. Shared scalar,
   pointer and memory rules are unchanged; no result/length/frame oracle. -/
namespace FT1536.Source3.KeygenPublicEncodeValues077
open KeygenCodecSyntax C99MemoryReference

abbrev Name := KeygenCodecValues.Name
abbrev Args := KeygenCodecValues.Args
abbrev Value := KeygenCodecValues.Value
abbrev Locals := KeygenCodecValues.Locals
abbrev State := KeygenCodecValues.State
abbrev initialLocals := KeygenCodecValues.initialLocals
abbrev initial := KeygenCodecValues.initial
abbrev withLocals := KeygenCodecValues.withLocals
abbrev localSet := KeygenCodecValues.localSet
abbrev scalarTy := KeygenCodecValues.scalarTy
abbrev castInteger := KeygenCodecValues.castInteger
abbrev truth := KeygenCodecValues.truth
abbrev boolean := KeygenCodecValues.boolean
abbrev Load16 := KeygenCodecValues.Load16
abbrev UnaryOp := KeygenCodecValues.UnaryOp
abbrev BinaryOp := KeygenCodecValues.BinaryOp
abbrev Update := KeygenCodecValues.Update
abbrev assignOp := KeygenCodecValues.assignOp
abbrev Assigned := KeygenCodecValues.Assigned
abbrev declareLocals := KeygenCodecValues.declareLocals
abbrev hasBuf := KeygenCodecValues.hasBuf
abbrev declared := KeygenCodecValues.declared

inductive Eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer)) :
    Expr → Locals → Value → Locals → Prop where
  | number (ty : Ty) (n : Nat) (v : C99IntegerReference.Value) (l : Locals)
      (cast : castInteger ty (.int64 (BitVec.ofNat 64 n))=some v) :
      Eval args heap buf (.number ty n) l (.integer v) l
  | scalar (name : Name) (l : Locals) (ty : C99IntegerReference.Ty) (v : C99IntegerReference.Value)
      (bound : l.scalars name=some (ty,some v)) : Eval args heap buf (.variable name) l (.integer v) l
  | out (l : Locals) : Eval args heap buf (.variable "out".toList) l (.pointer args.out) l
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
      Eval args heap buf (.unary .dereference e) l (.integer (.int32 (BitVec.ofNat 32 w.toNat))) t
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


end FT1536.Source3.KeygenPublicEncodeValues077
