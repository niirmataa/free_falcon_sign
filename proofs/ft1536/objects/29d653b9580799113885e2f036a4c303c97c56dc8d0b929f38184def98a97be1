import Source3.KeygenLevelParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Read-only word expressions for bigint limbs and the earlier norm gate.
   Casts/operators use the existing C99 integer judgments. Array reads may
   occur inside arithmetic, without inventing temporary scalar bindings. -/
namespace FT1536.Source3.KeygenWordExpr
open C99ArrayReference (State Name Pointer)
open C99MemoryReference
open C99IntegerReference (Value Ty)

inductive Expr where
  | scalar (e : CLogic.Expr)
  | load32 (name : Name) (index : CLogic.Expr)
  | load16 (name : Name) (index : CLogic.Expr)
  | cast (ty : Ty) (e : Expr)
  | neg (e : Expr)
  | bitNot (e : Expr)
  | lnot (e : Expr)
  | bin (op : B20.C.BinOp) (a b : Expr)
  | cmp (op : CLogic.Cmp) (a b : Expr)
  | land (a b : Expr)
  | lor (a b : Expr)
  | call1 (name : Name) (a : Expr)
  | call2 (name : Name) (a b : Expr)
  | call3 (name : Name) (a b c : Expr)
  | call4 (name : Name) (a b c d : Expr)
  | call5 (name : Name) (a b c d e : Expr)
  deriving DecidableEq, Repr
inductive Eval (s : State) : Expr → Value → Prop where
  | scalar (e : CLogic.Expr) (v : Value) (source : C99ArrayReference.scalar s e v) : Eval s (.scalar e) v
  | load32 (name : Name) (index : CLogic.Expr) (p : ArrayPointer) (w : BitVec 32)
      (address : Pointer s name index p) (read : Load32 s.heap p w) : Eval s (.load32 name index) (.uint32 w)
  | load16 (name : Name) (index : CLogic.Expr) (p : ArrayPointer) (w : BitVec 16)
      (address : Pointer s name index p) (read : C99NarrowReads.Load16 s.heap p w) :
      Eval s (.load16 name index) (C99NarrowReads.signedPromotion w)
  | cast (ty : Ty) (e : Expr) (v : Value) (source : Eval s e v) : Eval s (.cast ty e) (C99IntegerReference.convert ty v.integer)
  | neg (e : Expr) (v z : Value) (source : Eval s e v) (op : C99IntegerReference.NegExec v z) : Eval s (.neg e) z
  | bitNot (e : Expr) (v z : Value) (source : Eval s e v) (op : C99IntegerReference.ComplementExec v z) : Eval s (.bitNot e) z
  | lnot (e : Expr) (v : Value) (source : Eval s e v) : Eval s (.lnot e) (C99ScalarReference.boolean (decide (v.integer=0)))
  | bin (op : B20.C.BinOp) (a b : Expr) (x y z : Value) (left : Eval s a x) (right : Eval s b y)
      (operation : C99OperatorBridge.Binary op x y z) : Eval s (.bin op a b) z
  | cmp (op : CLogic.Cmp) (a b : Expr) (x y z : Value) (left : Eval s a x) (right : Eval s b y)
      (operation : C99IntegerReference.CompareExec (C99Frontend.comparison op) x y z) : Eval s (.cmp op a b) z
  | andFalse (a b : Expr) (x : Value) (left : Eval s a x) (zero : x.integer=0) :
      Eval s (.land a b) (C99ScalarReference.boolean false)
  | andTrue (a b : Expr) (x y : Value) (left : Eval s a x) (nonzero : x.integer≠0) (right : Eval s b y) :
      Eval s (.land a b) (C99ScalarReference.boolean (decide (y.integer≠0)))
  | orTrue (a b : Expr) (x : Value) (left : Eval s a x) (nonzero : x.integer≠0) :
      Eval s (.lor a b) (C99ScalarReference.boolean true)
  | orFalse (a b : Expr) (x y : Value) (left : Eval s a x) (zero : x.integer=0) (right : Eval s b y) :
      Eval s (.lor a b) (C99ScalarReference.boolean (decide (y.integer≠0)))
  | call1 (name : Name) (a : Expr) (x out : Value) (first : Eval s a x)
      (source : C99ModularReference.ModCall name [x] out) : Eval s (.call1 name a) out
  | call2 (name : Name) (a b : Expr) (x y out : Value) (first : Eval s a x) (second : Eval s b y)
      (source : C99ModularReference.ModCall name [x,y] out) : Eval s (.call2 name a b) out
  | call3 (name : Name) (a b c : Expr) (x y z out : Value)
      (first : Eval s a x) (second : Eval s b y) (third : Eval s c z)
      (source : C99ModularReference.ModCall name [x,y,z] out) : Eval s (.call3 name a b c) out
  | call4 (name : Name) (a b c d : Expr) (x y z t out : Value)
      (first : Eval s a x) (second : Eval s b y) (third : Eval s c z) (fourth : Eval s d t)
      (source : C99ModularReference.ModCall name [x,y,z,t] out) : Eval s (.call4 name a b c d) out
  | call5 (name : Name) (a b c d e : Expr) (x y z t u out : Value)
      (first : Eval s a x) (second : Eval s b y) (third : Eval s c z) (fourth : Eval s d t) (fifth : Eval s e u)
      (source : C99ModularReference.ModCall name [x,y,z,t,u] out) : Eval s (.call5 name a b c d e) out

abbrev Types := List (Name×Nat)
abbrev Parser := List B20.C.Token → Option (Expr×List B20.C.Token)
def typeToken (token : B20.C.Token) : Option B20.C.Ty :=
  if token="int32_t".toList then some .i32 else
  if token="int64_t".toList then some .i64 else B20.C.Scalar.typeToken token
def mkn (a b : Expr) : Expr := .bin .shl
  (.cast .uint64 (.bin .add (.scalar (.literal .i32 1)) (.bin .shl b (.scalar (.literal .i32 1))))) (.bin .sub a b)
def applyOp : CLogicParser.Op → Expr → Expr → Expr
  | .arithmetic op,a,b => .bin op a b
  | .comparison op,a,b => .cmp op a b
  | .land,a,b => .land a b
  | .lor,a,b => .lor a b
def parseArgs (sub : Parser) : Nat → List B20.C.Token → Option (List Expr×List B20.C.Token)
  | 0,_ => none
  | fuel+1,ts => do
    let (e,rest) ← sub ts
    match rest with
    | [')']::rest => pure ([e],rest)
    | [',']::rest => do
      let (args,rest) ← parseArgs sub fuel rest
      pure (e::args,rest)
    | _ => none
def unary (types : Types) (sub : Parser) : Nat → Parser
  | 0,_ => none
  | fuel+1,['-']::ts => do
    let (e,rest) ← unary types sub fuel ts
    pure (.neg e,rest)
  | fuel+1,['~']::ts => do
    let (e,rest) ← unary types sub fuel ts
    pure (.bitNot e,rest)
  | fuel+1,['!']::ts => do
    let (e,rest) ← unary types sub fuel ts
    pure (.lnot e,rest)
  | fuel+1,['(']::ty::[')']::ts =>
    match typeToken ty with
    | some t => do
      let (e,rest) ← unary types sub fuel ts
      pure (.cast (C99ValueBridge.type t) e,rest)
    | none => do
      let (e,rest) ← sub (ty::[')']::ts)
      match rest with
      | [')']::rest => pure (e,rest)
      | _ => none
  | _+1,['(']::ts => do
    let (e,rest) ← sub ts
    match rest with
    | [')']::rest => pure (e,rest)
    | _ => none
  | _+1,name::['[']::ts => do
    let (index,rest) ← C99ArrayParser.pureExpr ts
    let width ← KeygenSearchParser.width types name
    let e ← if width=4 then some (.load32 name index) else
      if width=2 then some (.load16 name index) else none
    match rest with
    | [']']::rest => pure (e,rest)
    | _ => none
  | fuel+1,name::['(']::ts => do
    let (args,rest) ← parseArgs sub fuel ts
    if name="MKN".toList then
      match args with
      | [a,b] => pure (mkn a b,rest)
      | _ => none
    else match args with
      | [a] => pure (.call1 name a,rest)
      | [a,b] => pure (.call2 name a b,rest)
      | [a,b,c] => pure (.call3 name a b c,rest)
      | [a,b,c,d] => pure (.call4 name a b c d,rest)
      | [a,b,c,d,e] => pure (.call5 name a b c d e,rest)
      | _ => none
  | _+1,t::ts =>
    if t.isEmpty then none
    else if B20.C.digit t.head! then (CLogicParser.number t).map (fun e => (.scalar e,ts))
    else if t.all B20.C.wordChar then some (.scalar (.var t),ts) else none
  | _+1,[] => none
def more (subPrec : Nat → Parser) (minPrec : Nat) : Nat → Expr → Parser
  | _,left,[] => some (left,[])
  | 0,left,ts => some (left,ts)
  | fuel+1,left,t::ts =>
    match CLogicParser.opInfo t with
    | none => some (left,t::ts)
    | some (op,prec) =>
      if prec<minPrec then some (left,t::ts) else do
        let (right,rest) ← subPrec (prec+1) ts
        more subPrec minPrec fuel (applyOp op left right) rest
def parse (types : Types) : Nat → Nat → Parser
  | 0,_,_ => none
  | fuel+1,minPrec,ts => do
    let subPrec := fun prec => parse types fuel prec
    let (left,rest) ← unary types (subPrec 1) fuel ts
    more subPrec minPrec fuel left rest
def expression (types : Types) : Parser := parse types 32 1

end FT1536.Source3.KeygenWordExpr
