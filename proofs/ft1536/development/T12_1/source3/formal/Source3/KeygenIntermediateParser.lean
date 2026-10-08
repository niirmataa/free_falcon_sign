import Source3.KeygenIntermediateExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Rejecting grammar for the complete intermediate caller. Integer and
   pointer expressions have distinct types; calls are resolved through the
   fixed table. The profile's DEPTH_INT_FG macro is bound below. -/
namespace FT1536.Source3.KeygenIntermediateParser
open C99ArrayReference (Name Param)
open KeygenIntermediateCalls (Expr Arg Kind)
open KeygenIntermediateExec (Stmt chain)
open B20.C (Token)

def widths : KeygenWordExpr.Types :=
  ["Fd","Gd","Ft","Gt","ft","gt","t1","x","y","k","xs","ys","xd","yd","gm","igm","fx","gx","Fp","Gp"].map
    (fun n => (n.toList,4)) ++
  ["rt1","rt2","rt3","rt4","rt5","MAX_BL_SMALL2","MAX_BL_SMALL3","MAX_BL_LARGE2","MAX_BL_LARGE3"].map
    (fun n => (n.toList,8)) ++
  [("fk".toList,448),("f".toList,2),("g".toList,2),("primes".toList,12),("PRIMES2".toList,12),("PRIMES3".toList,12)]
def ptrs : List Name := widths.map Prod.fst
def word (e : KeygenWordExpr.Expr) : Expr := .word e
def literal (n : Nat) : Expr := word (.scalar (.literal .i32 n))
def pointer := KeygenIntermediateMemory.pointer 32
def expr (ts : List Token) : Option (Expr×List Token) :=
  match ts with
  | ['f','k']::['-']::['>']::['l','o','g','n']::rest => some (.logn,rest)
  | ['f','k']::['-']::['>']::['t','e','r','n','a','r','y']::['&','&']::rest => do
    let (e,rest) ← KeygenWordExpr.expression widths rest
    pure (.land .ternary (word e),rest)
  | ['f','k']::['-']::['>']::['t','e','r','n','a','r','y']::rest => some (.ternary,rest)
  | ['f','p','r','_','r','i','n','t']::['(']::name::['[']::rest => do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with | [']']::[')']::rest => pure (.rint name index,rest) | _ => none
  | ['*']::name::rest => some (word (.load32 name C99ProcedureParser.zero),rest)
  | _ =>
    match KeygenLevelParser.prime ts with
    | some (name,index,field,rest) => some (.prime name index field,rest)
    | none =>
      match ts with
      | name::['[']::rest =>
        if KeygenSearchParser.width widths name=some 8 then do
          let (index,rest) ← C99ArrayParser.pureExpr rest
          match rest with | [']']::rest => pure (.load64 name index,rest) | _ => none
        else (KeygenWordExpr.expression widths ts).map (fun (e,rest) => (word e,rest))
      | name::['<']::rest =>
        if ptrs.contains name then do
          let (p,rest) ← pointer rest
          pure (.pointerLt (.named name) p,rest)
        else (KeygenWordExpr.expression widths ts).map (fun (e,rest) => (word e,rest))
      | _ => (KeygenWordExpr.expression widths ts).map (fun (e,rest) => (word e,rest))

def callee (name : Name) : Option (Kind×Bool) :=
  if name="make_fg".toList then some (.make,false) else
  if name="poly_max_bitlength".toList then some (.poly .maxBitlength,false) else
  if name="poly_big_to_fp".toList then some (.poly .bigToFp,false) else
  if name="poly_sub_scaled_ntt".toList then some (.subNtt,false) else
  if name="poly_sub_scaled".toList then some (.subQuadratic,false) else
  match KeygenZintCall.calleeOf name with
  | some kind => some (.zint kind,false)
  | none => match KeygenMakeFgSource.binaryOf name with
    | some (kind,wrapper) => some (.binaryNtt kind,wrapper)
    | none => match KeygenLevelParser.callee name with
      | some (kind,wrapper) => some (.ternaryNtt kind,wrapper)
      | none => match KeygenBinaryFft.find name with
        | some kind => some (.binaryFft kind,false)
        | none => (KeygenSearchFft.find name).map (fun kind => (.ternaryFft kind,false))
def callParams (kind : Kind) (wrapper : Bool) : List Param :=
  let ps := KeygenIntermediateCalls.params kind
  if wrapper then ps.take 1++ps.drop 2 else ps
def argument : Param → List Token → Option (Arg×List Token)
  | .pointer _,rest => (pointer rest).map (fun (p,rest) => (.pointer p,rest))
  | .scalar _ _,['f','k']::['-']::['>']::['t','e','r','n','a','r','y']::rest => some (.scalar .ternary,rest)
  | .scalar _ _,rest =>
    match KeygenLevelParser.prime rest with
    | some (name,index,field,tail) => some (.scalar (.prime name index field),tail)
    | none => (C99ArrayParser.pureExpr rest).map (fun (e,rest) => (.scalar (.word (.scalar e)),rest))
def arguments : List Param → List Token → Option (List Arg×List Token)
  | [],[')']::rest => some ([],rest)
  | [p],rest => do
    let (arg,rest) ← argument p rest
    match rest with | [')']::rest => pure ([arg],rest) | _ => none
  | p::q::ps,rest => do
    let (arg,rest) ← argument p rest
    match rest with
    | [',']::rest => do
      let (args,rest) ← arguments (q::ps) rest
      pure (arg::args,rest)
    | _ => none
  | _,_ => none
def call (dst : KeygenZintCall.CDest) : List Token → Option (Stmt×List Token)
  | name::['(']::rest => do
    let (kind,wrapper) ← callee name
    let (args,rest) ← arguments (callParams kind wrapper) rest
    let args := if wrapper then args.take 1++[.scalar (literal 1)]++args.drop 1 else args
    match rest with | [';']::rest => pure (.call kind args dst,rest) | _ => none
  | _ => none
def lowerWord : KeygenWordExec.Stmt → Option Stmt
  | .assign dst e => some (.assign dst (word e))
  | .store dst index e => some (.store dst index (word e))
  | .modular (.base (.scalar code)) => some (.scalar code)
  | .ret e => some (.ret (word e))
  | _ => none
def declaration : List Token → Option (Stmt×List Token)
  | ['c','o','n','s','t']::['s','m','a','l','l','_','p','r','i','m','e']::['*']::rest => do
    let (names,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
    pure (chain (names.map Stmt.declarePtr),rest)
  | ty::['*']::rest => do
    let _ ← KeygenIntermediateMemory.width ty
    let (names,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
    pure (chain (names.map Stmt.declarePtr),rest)
  | _ => none
def clause (ts : List Token) : Option (Stmt×List Token) :=
  match ts with
  | dst::['=']::rest =>
    if ptrs.contains dst then (pointer rest).map (fun (p,rest) => (.pointer dst p,rest))
    else (KeygenWordParser.clause widths ts).bind (fun (code,rest) => (lowerWord code).map (fun code => (code,rest)))
  | dst::['+','=']::rest =>
    if ptrs.contains dst then (C99ArrayParser.pureExpr rest).map
      (fun (i,rest) => (.pointer dst (.add (.named dst) i),rest))
    else (KeygenWordParser.clause widths ts).bind (fun (code,rest) => (lowerWord code).map (fun code => (code,rest)))
  | _ => (KeygenWordParser.clause widths ts).bind (fun (code,rest) => (lowerWord code).map (fun code => (code,rest)))
def clauses (ending : Token) : Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | fuel+1,rest =>
    if rest.head?=some ending then some (.skip,rest.drop 1) else do
      let (first,rest) ← clause rest
      match rest with
      | [',']::rest => do
        let (tail,rest) ← clauses ending fuel rest
        pure (.seq first tail,rest)
      | last::rest => if last=ending then some (first,rest) else none
      | _ => none
def rhs (dst : Name) (rest : List Token) : Option (Stmt×List Token) :=
  match call (.into dst) rest with
  | some out => some out
  | none => do
    let (e,rest) ← expr rest
    match rest with
    | ['?']::rest => do
      let (yes,rest) ← expr rest
      match rest with
      | [':']::rest => do
        let (no,rest) ← expr rest
        match rest with
        | [';']::rest => pure (.branch e (.assign dst yes) (.assign dst no),rest)
        | _ => none
      | _ => none
    | [';']::rest => pure (.assign dst e,rest)
    | _ => none
def store (dst : Name) (index : CLogic.Expr) (rest : List Token) : Option (Stmt×List Token) :=
  match call (.store dst index) rest with
  | some out => some out
  | none => do
    let (e,rest) ← expr rest
    match rest with | [';']::rest => pure (.store dst index e,rest) | _ => none
def special : List Token → Option (Stmt×List Token)
  | ['b','r','e','a','k']::[';']::rest => some (.breakLoop,rest)
  | ['c','o','n','t','i','n','u','e']::[';']::rest => some (.continueLoop,rest)
  | ['r','e','t','u','r','n']::rest => do
    let (e,rest) ← expr rest
    match rest with | [';']::rest => pure (.ret e,rest) | _ => none
  | ['m','e','m','m','o','v','e']::['(']::rest => do
    let (dst,rest) ← pointer rest
    match rest with
    | [',']::rest => do
      let (src,rest) ← pointer rest
      match rest with
      | [',']::rest => do
        let (count,rest) ← C99ArrayParser.pureExpr rest
        match rest with | [')']::[';']::rest => pure (.move dst src count,rest) | _ => none
      | _ => none
    | _ => none
  | ['*']::dst::['=']::rest => store dst C99ProcedureParser.zero rest
  | dst::['[']::rest => do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with | [']']::['=']::rest => store dst index rest | _ => none
  | dst::['=']::rest =>
    if ptrs.contains dst then do
      let (p,rest) ← pointer rest
      match rest with | [';']::rest => pure (.pointer dst p,rest) | _ => none
    else rhs dst rest
  | ts => match call .discard ts with
    | some out => some out
    | none => declaration ts
def simple (ts : List Token) : Option (Stmt×List Token) :=
  match special ts with
  | some out => some out
  | none => do
    let (code,rest) ← KeygenWordParser.simple widths ts
    pure (← lowerWord code,rest)
def declarations : Stmt → List Name×List Name
  | .scalar (.declare _ names) => (names,[])
  | .declarePtr name => ([],[name])
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])
mutual
  def statement : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,rest) ← body fuel rest
      let names := declarations code
      pure (.scope names.1 names.2 code,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← clauses [';'] 16 rest
      let (condition,rest) ← if rest.head?=some [';'] then some (literal 1,rest.drop 1) else do
        let (e,rest) ← expr rest
        match rest with | [';']::rest => pure (e,rest) | _ => none
      let (update,rest) ← clauses [')'] 16 rest
      let (inner,rest) ← statement fuel rest
      pure (.seq initial (.loop condition inner update),rest)
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
      let (condition,rest) ← expr rest
      match rest with
      | [')']::rest => do
        let (inner,rest) ← statement fuel rest
        pure (.loop condition inner .skip,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← expr rest
      match rest with
      | [')']::rest => do
        let (yes,rest) ← statement fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,rest) ← statement fuel rest
          pure (.branch condition yes no,rest)
        | _ => pure (.branch condition yes .skip,rest)
      | _ => none
    | _+1,rest => simple rest
  def body : Nat → List Token → Option (Stmt×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (.skip,rest)
    | fuel+1,rest => do
      let (first,rest) ← statement fuel rest
      let (tail,rest) ← body fuel rest
      pure (.seq first tail,rest)
end
def expandDepth (ts : List Token) : List Token := ts.map (fun t => if t="DEPTH_INT_FG".toList then ['4'] else t)
theorem depth_macro_source : Pinned.keygenLines[4959]?=some "#define DEPTH_INT_FG   4\n" := by decide
def tokensAt (start count : Nat) : Option (List Token) :=
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  KeygenZintTop.tokens text
def ofTokens (tokens : List Token) : Option Stmt := do
  let tokens ← KeygenSearchParser.sizes widths (expandDepth tokens)
  let (code,rest) ← body 512 tokens
  if rest.isEmpty then pure code else none
def region (start count : Nat) : Option Stmt := (tokensAt start count).bind ofTokens

end FT1536.Source3.KeygenIntermediateParser
