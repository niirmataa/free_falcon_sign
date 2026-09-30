import Source3.CLogicParser

namespace FT1536.Source3.CRefWord
open B20.C

/- Typed live uint32_t objects. An address denotes an entire aligned word
object; none is absent/uninitialized and therefore cannot be read by RMW.
Local by-value variables are distinct from these caller-owned objects. -/
abbrev Heap := Nat → Option (BitVec 32)
def store (m : Heap) (p : Nat) (v : BitVec 32) : Heap := fun q => if q=p then some v else m q

structure State where
  scalar : B20.C.Scalar.State
  refs : B20.C.Name → Option Nat
  heap : Heap

abbrev Globals := B20.C.Env
def values (globals : Globals) (s : State) : Env := fun name => (s.scalar.values name).or (globals name)

inductive Stmt where
  | localStmt (stmt : CLogic.Stmt)
  | updateRef (name : B20.C.Name) (op : BinOp) (value : CLogic.Expr)
  deriving DecidableEq, Repr

def step (calls : B20.C.Scalar.Calls) (globals : Globals) (s : State) : Stmt → Option State
  | .localStmt (.declare ty names) => do
      if names.any (fun n => (s.refs n).isSome) then none else do
        pure {s with scalar := ← B20.C.Scalar.declareMany s.scalar ty names}
  | .localStmt (.assign name expr) => do
      pure {s with scalar := ← B20.C.Scalar.assign s.scalar name (← CLogic.eval calls (values globals s) 32 expr)}
  | .localStmt (.update name op expr) => do
      let v ← B20.C.bin op (← s.scalar.values name) (← CLogic.eval calls (values globals s) 32 expr)
      pure {s with scalar := ← B20.C.Scalar.assign s.scalar name v}
  | .localStmt (.ret _) => none
  | .updateRef name op expr => do
      let p ← s.refs name
      let old ← s.heap p
      let v ← B20.C.bin op (.u32 old) (← CLogic.eval calls (values globals s) 32 expr)
      match B20.C.cast .u32 v with
      | .u32 word => pure {s with heap := store s.heap p word}
      | _ => none

def evalBody (calls : B20.C.Scalar.Calls) (globals : Globals) (result : Ty) : List Stmt → State → Option (Val × Heap)
  | [],_ => none
  | .localStmt (.ret e)::_,s => do
      pure (B20.C.cast result (← CLogic.eval calls (values globals s) 32 e),s.heap)
  | stmt::rest,s => do evalBody calls globals result rest (← step calls globals s stmt)

inductive Param where
  | word (ty : Ty) (name : B20.C.Name)
  | ref32 (name : B20.C.Name)
  deriving DecidableEq, Repr
inductive Arg where
  | word (v : Val)
  | ref32 (address : Nat)

def bindArgs (m : Heap) : List Param → List Arg → Option State
  | [],[] => some ⟨B20.C.Scalar.emptyState,fun _ => none,m⟩
  | .word ty name::ps,.word v::args => do
      let s ← bindArgs m ps args
      if (s.refs name).isSome then none else do
        let scalar ← B20.C.Scalar.declareOne s.scalar ty name
        pure {s with scalar := ← B20.C.Scalar.assign scalar name v}
  | .ref32 name::ps,.ref32 p::args => do
      let s ← bindArgs m ps args
      if (s.refs name).isSome || (s.scalar.types name).isSome then none else
        pure {s with refs := fun n => if n=name then some p else s.refs n}
  | _,_ => none

structure Function where
  name : B20.C.Name
  result : Ty
  params : List Param
  body : List Stmt
  deriving DecidableEq, Repr

def execute (calls : B20.C.Scalar.Calls) (globals : Globals) (f : Function) (m : Heap) (args : List Arg) :
    Option (Val × Heap) := do
  evalBody calls globals f.result f.body (← bindArgs m f.params args)

def parseParams : Nat → List Token → Option (List Param × List Token)
  | 0,_ => none
  | _+1,[')']::ts => some ([],ts)
  | fuel+1,ty::['*']::name::sep::ts => do
      if B20.C.Scalar.typeToken ty != some .u32 then none else do
        if sep=[')'] then pure ([.ref32 name],ts)
        else if sep=[','] then do
          let (params,rest) ← parseParams fuel ts
          pure (.ref32 name::params,rest)
        else none
  | fuel+1,ty::name::sep::ts => do
      let t ← B20.C.Scalar.typeToken ty
      if sep=[')'] then pure ([.word t name],ts)
      else if sep=[','] then do
        let (params,rest) ← parseParams fuel ts
        pure (.word t name::params,rest)
      else none
  | _+1,_ => none

def parseStmt : List Token → Option (Stmt × List Token)
  | ['*']::name::op::ts => do
      let operation ← B20.C.Scalar.updateOp op
      let (e,rest) ← CLogicParser.expression 16 ts
      match rest with | [';']::tail => pure (.updateRef name operation e,tail) | _ => none
  | ts => (CLogicParser.statement ts).map (fun (s,rest) => (.localStmt s,rest))

def parseBody : Nat → List Token → Option (List Stmt × List Token)
  | 0,_ => none
  | _+1,['}']::ts => some ([],ts)
  | fuel+1,ts => do
      let (stmt,rest) ← parseStmt ts
      let (stmts,tail) ← parseBody fuel rest
      pure (stmt::stmts,tail)

def parseCore : List Token → Option Function
  | ty::name::['(']::ts => do
      let result ← B20.C.Scalar.typeToken ty
      let (params,rest) ← parseParams 16 ts
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

theorem store_frame (m : Heap) (p q : Nat) (v : BitVec 32) (h : q≠p) : store m p v q=m q := by
  simp only [store,h,ite_false]

theorem store_read (m : Heap) (p : Nat) (v : BitVec 32) : store m p v p=some v := by
  simp only [store,ite_true]

end FT1536.Source3.CRefWord
