import Source3.KeygenPublicExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicParser
open B20.C (Token Name)
open KeygenPublicExec (Stmt chain)
open KeygenWordExpr (Expr)
abbrev Types := KeygenWordExpr.Types
abbrev Signatures := Name → Option (List C99ArrayReference.Param)

def assignment (types : Types) (make : Bool → Expr → Stmt) (ts : List Token) : Option (Stmt×List Token) := do
  let (cast,ts) := match ts with | ['(']::['u','i','n','t','1','6','_','t']::[')']::rest => (true,rest) | _ => (false,ts)
  let (value,rest) ← KeygenWordExpr.expression types ts
  match rest with
  | ['?']::rest => do
    if cast then none else do
    let (yes,rest) ← KeygenWordExpr.expression types rest
    match rest with
    | [':']::rest => do
      let (no,rest) ← KeygenWordExpr.expression types rest
      pure (.branch value (make false yes) (make false no),rest)
    | _ => none
  | _ => pure (make cast value,rest)
def clause (types : Types) : List Token → Option (Stmt×List Token)
  | name::['+','+']::rest => pure (.scalar (.update name .add (.literal .i32 1)),rest)
  | name::['-']::['-']::rest => pure (.scalar (.update name .sub (.literal .i32 1)),rest)
  | name::['=']::rest =>
    if (KeygenSearchParser.width types name).isSome then do
      let (value,rest) ← C99ProcedureParser.pointerExpr rest
      match value with
      | .pointer src index => pure (.pointer name src index,rest)
      | _ => none
    else if rest.take 3=[['('],"uint16_t".toList,[')']] then none
    else assignment types (fun _ value => .assign name value) rest
  | name::op::rest => do
    let bin ← B20.C.Scalar.updateOp op
    let (e,rest) ← KeygenWordExpr.expression types rest
    pure (.assign name (.bin bin (.scalar (.var name)) e),rest)
  | _ => none
def clauses (types : Types) (ending : Token) : Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | fuel+1,ts =>
    if ts.head?=some ending then pure (.skip,ts.drop 1) else do
    let (first,rest) ← clause types ts
    match rest with
    | [',']::rest => do
      let (tail,rest) ← clauses types ending fuel rest
      pure (.seq first tail,rest)
    | last::rest => if last=ending then pure (first,rest) else none
    | _ => none
def simple (signatures : Signatures) (types : Types) : List Token → Option (Stmt×Types×List Token)
  | [';']::rest => pure (.skip,types,rest)
  | ['r','e','t','u','r','n']::[';']::rest => pure (.ret none,types,rest)
  | ['r','e','t','u','r','n']::rest => do
    let (value,rest) ← KeygenWordExpr.expression types rest
    match rest with | [';']::rest => pure (.ret (some value),types,rest) | _ => none
  | ['c','o','n','s','t']::['u','i','n','t','1','6','_','t']::['*']::rest
  | ['u','i','n','t','1','6','_','t']::['*']::rest => do
    let (names,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
    pure (chain (names.map .declarePointer),names.map (fun n => (n,2))++types,rest)
  | name::['[']::rest => do
    if KeygenSearchParser.width types name≠some 2 then none else do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::['=']::rest => do
      let (code,rest) ← assignment types (fun cast value => .store name index cast value) rest
      match rest with | [';']::rest => pure (code,types,rest) | _ => none
    | _ => none
  | name::['(']::rest => do
    let params ← signatures name
    let (args,rest) ← C99ProcedureParser.arguments params rest
    match rest with | [';']::rest => pure (.call name args,types,rest) | _ => none
  | name::['=']::rest => do
    let (code,rest) ← clause types (name::['=']::rest)
    match rest with | [';']::rest => pure (code,types,rest) | _ => none
  | rest => do
    let (code,rest) ← CLogicParser.statement rest
    match code with
    | .declare _ _ | .assign _ _ | .update _ _ _ => pure (.scalar code,types,rest)
    | _ => none
def declarations : Stmt → List Name×List Name
  | .scalar (.declare _ names) => (names,[])
  | .declarePointer name => ([],[name])
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])
def count : Token → Option Nat
  | ['T','E','R','N','A','R','Y','_','G','M','_','S','I','Z','E'] => some 2048
  | ['T','E','R','N','A','R','Y','_','N','_','M','A','X'] => some 3072
  | _ => none
theorem constant_counts : (1 : Nat)*2^11=2048 ∧ (1+2)*2^(11-1)=3072 := by decide
def arrays : Nat → List Token → Option (List (Name×Nat)×List Token)
  | 0,_ => none
  | fuel+1,name::['[']::size::[']']::rest => do
    let n ← count size
    match rest with
    | [';']::rest => pure ([(name,n)],rest)
    | [',']::rest => do
      let (tail,rest) ← arrays fuel rest
      pure ((name,n)::tail,rest)
    | _ => none
  | _+1,_ => none
mutual
  def statement (signatures : Signatures) (types : Types) : Nat → List Token → Option (Stmt×Types×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,_,rest) ← body signatures types fuel rest
      let names := declarations code
      pure (.scope names.1 names.2 code,types,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← clauses types [';'] 16 rest
      let (condition,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [';']::rest => do
        let (increment,rest) ← clauses types [')'] 16 rest
        let (inner,_,rest) ← statement signatures types fuel rest
        pure (.seq initial (.loop condition inner increment),types,rest)
      | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::name::['+','+']::op::rest => do
      let cmp ← C99ModularParser.cmpToken op
      let (bound,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [')']::rest => do
        let (inner,_,rest) ← statement signatures types fuel rest
        let inc := Stmt.scalar (.update name .add (.literal .i32 1))
        pure (.seq (.loop (.cmp cmp (.scalar (.var name)) bound) (.seq inc inner) .skip) inc,types,rest)
      | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
      let (condition,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [')']::rest => do
        let (inner,_,rest) ← statement signatures types fuel rest
        pure (.loop condition inner .skip,types,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [')']::rest => do
        let (yes,_,rest) ← statement signatures types fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,_,rest) ← statement signatures types fuel rest
          pure (.branch condition yes no,types,rest)
        | _ => pure (.branch condition yes .skip,types,rest)
      | _ => none
    | _+1,rest => simple signatures types rest
  def body (signatures : Signatures) (types : Types) : Nat → List Token → Option (Stmt×Types×List Token)
    | 0,_ => none
    | _+1,['}']::rest => pure (.skip,types,rest)
    | fuel+1,['u','i','n','t','1','6','_','t']::name::['[']::rest => do
      let (objects,rest) ← arrays 16 (name::['[']::rest)
      let (tail,final,rest) ← body signatures (objects.map (fun (n,_) => (n,2))++types) fuel rest
      pure (objects.foldr (fun (n,count) code => .arrayScope n count code) tail,final,rest)
    | fuel+1,rest => do
      let (first,next,rest) ← statement signatures types fuel rest
      let (tail,final,rest) ← body signatures next fuel rest
      pure (.seq first tail,final,rest)
end

end FT1536.Source3.KeygenPublicParser
