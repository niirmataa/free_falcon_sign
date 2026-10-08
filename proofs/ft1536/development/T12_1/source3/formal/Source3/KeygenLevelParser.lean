import Source3.KeygenLevelExec
import Source3.KeygenSearchParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Rejecting modular-search grammar. Dot access is tokenized explicitly;
   stride-one macros are expanded from the separately checked definitions.
   The sizeof normalizer uses the declared uint32 element widths. -/
namespace FT1536.Source3.KeygenLevelParser
open B20.C (Token Name)
open KeygenLevelExec

def tokenize : Nat → List Char → Option (List Token)
  | 0,_ => none
  | _+1,[] => some []
  | fuel+1,'/'::'*'::rest => do
    let tail ← B20.C.Scalar.skipBlock (rest.length+1) rest
    tokenize fuel tail
  | fuel+1,'/'::'/'::rest => tokenize fuel (rest.dropWhile (· != '\n'))
  | fuel+1,c::cs =>
    if c==' ' || c=='\t' || c=='\n' || c=='\r' then tokenize fuel cs
    else if B20.C.wordChar c then
      let tail := cs.takeWhile B20.C.wordChar
      (tokenize fuel (cs.drop tail.length)).map ((c::tail)::·)
    else match c,cs with
      | '+','+'::rest => (tokenize fuel rest).map (['+','+']::·)
      | '>','>'::'='::rest => (tokenize fuel rest).map (['>','>','=']::·)
      | '<','<'::'='::rest => (tokenize fuel rest).map (['<','<','=']::·)
      | '>','>'::rest => (tokenize fuel rest).map (['>','>']::·)
      | '<','<'::rest => (tokenize fuel rest).map (['<','<']::·)
      | '&','&'::rest => (tokenize fuel rest).map (['&','&']::·)
      | '|','|'::rest => (tokenize fuel rest).map (['|','|']::·)
      | _,'='::rest =>
        if ['+','-','*','^','&','|','=','!','<','>'].contains c then
          (tokenize fuel rest).map ([c,'=']::·)
        else none
      | _,_ =>
        if ['(',')','{','}','[',']',';',',','^','&','|','-','+','*','~','=','!','<','>','.'].contains c then
          (tokenize fuel cs).map ([c]::·)
        else none

def field : Token → Option KeygenLevelCalls.Field
  | ['p'] => some .p
  | ['g'] => some .g
  | ['s'] => some .s
  | _ => none
def prime : List Token → Option (Name×CLogic.Expr×KeygenLevelCalls.Field×List Token)
  | name::['[']::rest => do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::['.']::member::rest => pure (name,index,← field member,rest)
    | _ => none
  | _ => none
def expr (ts : List Token) : Option (KeygenLevelCalls.Expr×List Token) :=
  match prime ts with
  | some (name,index,member,rest) => some (.prime name index member,rest)
  | none => (C99ModularParser.expr 32 ts).map (fun (e,rest) => (.modular e,rest))
def argument : C99ArrayReference.Param → List Token → Option (KeygenLevelCalls.Arg×List Token)
  | .scalar _ _,ts => (expr ts).map (fun (e,rest) => (.scalar e,rest))
  | .pointer _,ts => do
    let (p,rest) ← C99ProcedureParser.pointerExpr ts
    match p with
    | .pointer name index => pure (.pointer name index,rest)
    | _ => none
def arguments : List C99ArrayReference.Param → List Token → Option (List KeygenLevelCalls.Arg×List Token)
  | [],[')']::rest => some ([],rest)
  | [p],ts => do
    let (a,rest) ← argument p ts
    match rest with
    | [')']::rest => pure ([a],rest)
    | _ => none
  | p::q::ps,ts => do
    let (a,rest) ← argument p ts
    match rest with
    | [',']::rest => do
      let (args,rest) ← arguments (q::ps) rest
      pure (a::args,rest)
    | _ => none
  | _,_ => none
def callee (name : Name) : Option (KeygenLevelCalls.Kind×Bool) :=
  if name="modp_NTT3".toList then some (.forward,true)
  else if name="modp_iNTT3".toList then some (.inverse,true)
  else if name="modp_NTT3_ext".toList then some (.forward,false)
  else if name="modp_iNTT3_ext".toList then some (.inverse,false)
  else if name="modp_mkgm3".toList then some (.generate,false)
  else none
def callParams (kind : KeygenLevelCalls.Kind) (wrapper : Bool) : List C99ArrayReference.Param :=
  let ps := KeygenLevelCalls.params kind
  if wrapper then ps.take 1++ps.drop 2 else ps
def expandArgs (args : List KeygenLevelCalls.Arg) (wrapper : Bool) : List KeygenLevelCalls.Arg :=
  if wrapper then args.take 1++[.scalar (.modular (.scalar (.literal .i32 1)))]++args.drop 1 else args

def simple (ctx : List Name) (ts : List Token) : Option (Stmt×List Name×List Token) := do
  match ts with
  | ['m','e','m','m','o','v','e']::['(']::rest =>
    let (args,rest) ← C99ProcedureParser.arguments
      [.pointer "dst".toList,.pointer "src".toList,.scalar .uint64 "count".toList] rest
    match args,rest with
    | [.pointer dst di,.pointer src si,.scalar count],[';']::rest => pure (.move dst src di si count,ctx,rest)
    | _,_ => none
  | name::['(']::rest =>
    let (kind,wrapper) ← callee name
    let (args,rest) ← arguments (callParams kind wrapper) rest
    match rest with
    | [';']::rest => pure (.call kind (expandArgs args wrapper),ctx,rest)
    | _ => none
  | dst::['=']::rest =>
    match prime rest with
    | some (src,index,member,[';']::rest) => pure (.prime dst src index member,ctx,rest)
    | _ => do
      let (code,ctx,rest) ← C99ModularParser.simple ctx ts
      pure (.modular code,ctx,rest)
  | _ =>
    let (code,ctx,rest) ← C99ModularParser.simple ctx ts
    pure (.modular code,ctx,rest)
def modularDeclarations : C99ModularReference.Stmt → List Name×List Name
  | .base (.scalar (.declare _ names)) => (names,[])
  | .base (.declarePtr name) => ([],[name])
  | .seq a b => ((modularDeclarations a).1++(modularDeclarations b).1,
    (modularDeclarations a).2++(modularDeclarations b).2)
  | _ => ([],[])
def declarations : Stmt → List Name×List Name
  | .modular code => modularDeclarations code
  | .seq a b => ((declarations a).1++(declarations b).1,(declarations a).2++(declarations b).2)
  | _ => ([],[])
mutual
  def statement (ctx : List Name) : Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,_,rest) ← body ctx fuel rest
      let names := declarations code
      pure (.scope names.1 names.2 code,ctx,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← C99ModularParser.clauses ctx [';'] 16 rest
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [';']::rest => do
        let (increment,rest) ← C99ModularParser.clauses ctx [')'] 16 rest
        let (inner,_,rest) ← statement ctx fuel rest
        pure (.seq (.modular initial) (.loop condition inner (.modular increment)),ctx,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [')']::rest => do
        let (yes,_,rest) ← statement ctx fuel rest
        match rest with
        | ['e','l','s','e']::rest => do
          let (no,_,rest) ← statement ctx fuel rest
          pure (.branch condition yes no,ctx,rest)
        | _ => pure (.branch condition yes skip,ctx,rest)
      | _ => none
    | _+1,rest => simple ctx rest
  def body (ctx : List Name) : Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | _+1,['}']::rest => pure (skip,ctx,rest)
    | fuel+1,rest => do
      let (head,next,rest) ← statement ctx fuel rest
      let (tail,final,rest) ← body next fuel rest
      pure (.seq head tail,final,rest)
end
def region (types : KeygenSearchParser.Types) (start count : Nat) : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let tokens ← tokenize (chars.length+1) chars
  let tokens ← KeygenSearchParser.sizes types (C99ArrayParser.normalizeTypes tokens)
  let (code,_,rest) ← body (types.map Prod.fst) 512 tokens
  if rest.isEmpty then pure code else none

end FT1536.Source3.KeygenLevelParser
