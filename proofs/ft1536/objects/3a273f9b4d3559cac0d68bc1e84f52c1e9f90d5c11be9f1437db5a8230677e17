import Source3.BitcastObjects

namespace FT1536.Source3.CObjectScalar
open B20.C

def word64Type : Ty → Bool
  | .u64 | .i64 => true
  | _ => false

def bytesOf : Val → Option BitcastObjects.Bytes8
  | .u64 w | .i64 w => some (B20.Word.LE.byteOf w)
  | _ => none

def fromBytes (ty : Ty) (bs : BitcastObjects.Bytes8) : Option Val :=
  match ty with
  | .u64 => some (.u64 (B20.Word.LE.join bs))
  | .i64 => some (.i64 (B20.Word.LE.join bs))
  | _ => none

/- Standard memcpy on two distinct local eight-byte objects. Destination
initialization is not required; its type/size and source initialization are.
The C profile fixes signed object interpretation to two's complement. -/
def copyLocal (s : B20.C.Scalar.State) (dst src sizeOf : B20.C.Name) : Option B20.C.Scalar.State := do
  let dt ← s.types dst
  let st ← s.types src
  let nt ← s.types sizeOf
  if !word64Type dt || !word64Type st || !word64Type nt || dst=src then none else do
    let bs ← bytesOf (← s.values src)
    let value ← fromBytes dt bs
    B20.C.Scalar.assign s dst value

inductive Stmt where
  | scalar (stmt : CLogic.Stmt)
  | memcpy8 (dst src sizeOf : B20.C.Name)
  deriving DecidableEq, Repr

def step (calls : B20.C.Scalar.Calls) (s : B20.C.Scalar.State) : Stmt → Option B20.C.Scalar.State
  | .scalar stmt => CLogic.step calls s stmt
  | .memcpy8 dst src sizeOf => copyLocal s dst src sizeOf

def evalBody (calls : B20.C.Scalar.Calls) (result : Ty) : List Stmt → B20.C.Scalar.State → Option Val
  | [],_ => none
  | .scalar (.ret e)::_,s => (CLogic.eval calls s.values 32 e).map (B20.C.cast result)
  | stmt::rest,s => do evalBody calls result rest (← step calls s stmt)

structure Function where
  name : B20.C.Name
  result : Ty
  params : List (Ty × B20.C.Name)
  body : List Stmt
  deriving DecidableEq, Repr

def execute (calls : B20.C.Scalar.Calls) (f : Function) (args : List Val) : Option Val := do
  evalBody calls f.result f.body (← B20.C.Scalar.bindArgs f.params args)

def parseStmt : List Token → Option (Stmt × List Token)
  | name::['(']::['&']::dst::[',']::['&']::src::[',']::size::sz::[')']::[';']::rest =>
      if name="memcpy".toList ∧ size="sizeof".toList then some (.memcpy8 dst src sz,rest) else none
  | ts => (CLogicParser.statement ts).map fun (s,rest) => (.scalar s,rest)

def parseBody : Nat → List Token → Option (List Stmt × List Token)
  | 0,_ => none
  | _+1,['}']::ts => some ([],ts)
  | fuel+1,ts => do
      let (s,rest) ← parseStmt ts
      let (ss,tail) ← parseBody fuel rest
      pure (s::ss,tail)

def parseCore : List Token → Option Function
  | ty::name::['(']::ts => do
      let result ← B20.C.Scalar.typeToken ty
      let (params,rest) ← B20.C.Scalar.params 16 ts
      match rest with
      | ['{']::tail => do
          let (stmts,rest) ← parseBody 64 tail
          if rest.isEmpty then pure ⟨name,result,params,stmts⟩ else none
      | _ => none
  | _ => none

def parseTokens : List Token → Option Function
  | ['s','t','a','t','i','c']::['i','n','l','i','n','e']::ts => parseCore ts
  | ['s','t','a','t','i','c']::ts => parseCore ts
  | ts => parseCore ts

def parse (chars : List Char) : Option Function :=
  (CLogicParser.tokenize (chars.length+1) chars).bind parseTokens

theorem same_bits_u64_i64 (w : BitVec 64) :
    (bytesOf (.u64 w)).bind (fromBytes .i64)=some (.i64 w) := by
  simp only [bytesOf,Option.bind_some,fromBytes,B20.Word.LE.join_byteOf]

end FT1536.Source3.CObjectScalar
