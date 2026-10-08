import Source3.KeygenZintLeaves
import Source3.KeygenLevelCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Call-capable word layer for the bigint CRT/Bezout family. It embeds the
   sealed KeygenWordExec statements unchanged and adds exactly the syntax
   used by zint_mod_small_signed/zint_norm_zero/zint_exact_length/
   zint_rshift1_mod/zint_sub_mod/zint_rebuild_CRT: calls to the sealed
   zint leaves and to new family members (each executed through its own
   parsed body, so no callee is arbitrary), prime-struct member reads
   (tokenized by the member-access rule of `tokens`, trap 110),
   pointer declaration/assignment/advance for the local walk pointer,
   void return, and calls in conditions. Leaf callees share their real
   KeygenWordExec bodies through `calleeBody (.leaf kind)`. -/
namespace FT1536.Source3.KeygenZintCall
open C99ArrayReference (State Name Param Arg Pointer bindValue restoreScope)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenWordExpr (Expr)
open B20.C (Token)

inductive Callee where
  | leaf (kind : KeygenZintLeaves.Kind)
  | modSigned | normZero | exactLen | rshiftMod | subMod | rebuildCrt
  deriving DecidableEq, Repr

def calleeName : Callee → Name
  | .leaf kind => KeygenZintLeaves.name kind
  | .modSigned => "zint_mod_small_signed".toList
  | .normZero => "zint_norm_zero".toList
  | .exactLen => "zint_exact_length".toList
  | .rshiftMod => "zint_rshift1_mod".toList
  | .subMod => "zint_sub_mod".toList
  | .rebuildCrt => "zint_rebuild_CRT".toList

def params : Callee → List Param
  | .leaf kind => KeygenZintLeaves.params kind
  | .modSigned => [.pointer "d".toList,.scalar .uint64 "dlen".toList,
    .scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList,
    .scalar .uint32 "R2".toList,.scalar .uint32 "Rx".toList]
  | .normZero => [.pointer "x".toList,.pointer "p".toList,.scalar .uint64 "len".toList]
  | .exactLen => [.pointer "x".toList,.scalar .uint64 "xlen".toList]
  | .rshiftMod => [.pointer "x".toList,.pointer "p".toList,.scalar .uint64 "len".toList]
  | .subMod => [.pointer "x".toList,.pointer "y".toList,.pointer "p".toList,
    .scalar .uint64 "len".toList]
  | .rebuildCrt => [.pointer "xx".toList,.scalar .uint64 "xlen".toList,
    .scalar .uint64 "xstride".toList,.scalar .uint64 "num".toList,
    .pointer "primes".toList,.scalar .int32 "normalize_signed".toList,
    .pointer "tmp".toList]

def result : Callee → Option Ty
  | .leaf kind => KeygenZintLeaves.result kind
  | .modSigned => some .uint32
  | .normZero => none
  | .exactLen => some .uint64
  | .rshiftMod => none
  | .subMod => none
  | .rebuildCrt => none

def writable : Callee → List Name
  | .leaf kind => KeygenZintLeaves.writable kind
  | .modSigned => []
  | .normZero => ["x".toList]
  | .exactLen => []
  | .rshiftMod => ["x".toList]
  | .subMod => ["x".toList]
  | .rebuildCrt => ["xx".toList,"tmp".toList,"x".toList]

def extraPointers : Callee → List Name
  | .rebuildCrt => ["x".toList]
  | _ => []

def widths (kind : Callee) : KeygenWordExpr.Types :=
  ((params kind).filterMap (fun p => match p with
    | .pointer n => some (n,4) | _ => none)) ++ (extraPointers kind).map (fun n => (n,4))

/-- Header region (first line, line count through the line before `{`). -/
def header : Callee → Nat×Nat
  | .leaf _ => (0,0)
  | .modSigned => (3422,3)
  | .normZero => (3539,2)
  | .exactLen => (3640,2)
  | .rshiftMod => (3486,2)
  | .subMod => (3503,3)
  | .rebuildCrt => (3576,4)

/-- Body region as (first body line, closing brace line). -/
def bodyRegion : Callee → Nat×Nat
  | .leaf _ => (0,0)
  | .modSigned => (3426,3434)
  | .normZero => (3542,3560)
  | .exactLen => (3643,3650)
  | .rshiftMod => (3489,3498)
  | .subMod => (3507,3510)
  | .rebuildCrt => (3581,3634)

inductive CDest where
  | discard
  | into (destination : Name)
  | store (array : Name) (index : CLogic.Expr)
  deriving DecidableEq, Repr

inductive Stmt where
  | word (code : KeygenWordExec.Stmt)
  | call (kind : Callee) (args : List Arg) (dst : CDest)
  | callBranch (kind : Callee) (args : List Arg) (test : CLogic.Cmp)
      (bound : CLogic.Expr) (yes no : Stmt)
  | prime (dst src : Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field)
  | storePrime (array : Name) (index : CLogic.Expr) (src : Name)
      (srcIndex : CLogic.Expr) (field : KeygenLevelCalls.Field)
  | retVoid
  | seq (first second : Stmt)
  | scope (locals pointers : List Name) (body : Stmt)
  | branch (condition : Expr) (yes no : Stmt)
  | loop (condition : Expr) (body increment : Stmt)
  deriving DecidableEq, Repr

def skip : Stmt := .word KeygenWordExec.skip
def chain : List Stmt → Stmt
  | [] => skip
  | s::ss => .seq s (chain ss)
def stepIncrement (slot : Name) (op : B20.C.BinOp) : Stmt :=
  .word (KeygenWordParser.increment slot op)

inductive ReceiveC : CDest → State → Option Value → State → Prop where
  | discard (s : State) (v : Option Value) : ReceiveC .discard s v s
  | into (destination : Name) (s : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : s.locals destination=some (ty,old)) :
      ReceiveC (.into destination) s (some v) (bindValue s destination ty v)
  | store (array : Name) (index : CLogic.Expr) (s : State) (after : Memory)
      (p : ArrayPointer) (v : Value) (address : Pointer s array index p)
      (write : Store32 s.heap p (BitVec.ofInt 32 v.integer) after) :
      ReceiveC (.store array index) s (some v) {s with heap := after}

def destOnly : List Name → CDest → Bool
  | _,.discard | _,.into _ => true
  | names,.store array _ => names.contains array

def calleeOf (token : Token) : Option Callee :=
  if token="zint_mod_small_signed".toList then some .modSigned else
  if token="zint_norm_zero".toList then some .normZero else
  if token="zint_exact_length".toList then some .exactLen else
  if token="zint_rshift1_mod".toList then some .rshiftMod else
  if token="zint_sub_mod".toList then some .subMod else
  if token="zint_rebuild_CRT".toList then some .rebuildCrt else
  if token="zint_mod_small_unsigned".toList then some (.leaf .reduce) else
  if token="zint_add_mul_small".toList then some (.leaf .addMul) else
  if token="zint_mul_small".toList then some (.leaf .mul) else
  if token="zint_add".toList then some (.leaf .add) else
  if token="zint_sub".toList then some (.leaf .sub) else
  if token="zint_rshift1".toList then some (.leaf .shift) else
  if token="zint_ucmp".toList then some (.leaf .compare) else none

/- Parser: new productions first (they are name-dispatched and cannot
   collide with the sealed word grammar), then pointer forms, then the
   sealed KeygenWordParser for all remaining simple statements. -/
def pointerDeclare (ptrs : List Name) : List Token → Option (Stmt×List Name×List Token)
  | ['c','o','n','s','t']::['s','m','a','l','l','_','p','r','i','m','e']::['*']::rest => do
    let (vars,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
    pure (chain (vars.map (fun n => .word (.modular (.base (.declarePtr n))))),vars++ptrs,rest)
  | ty::['*']::rest =>
    if KeygenWordExpr.typeToken ty=some .u32 then do
      let (vars,rest) ← C99ProcedureParser.pointerNames 32 (['*']::rest)
      pure (chain (vars.map (fun n => .word (.modular (.base (.declarePtr n))))),vars++ptrs,rest)
    else none
  | _ => none

def pointerClause (ptrs : List Name) : List Token → Option (Stmt×List Token)
  | slot::['=']::rest => if ptrs.contains slot then do
      let (p,rest) ← C99ProcedureParser.pointerExpr rest
      match p with
      | .pointer src index => pure (.word (.modular (.base (.bindPtr slot src index))),rest)
      | _ => none
    else none
  | slot::['+','=']::rest => if ptrs.contains slot then do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      pure (.word (.modular (.base (.bindPtr slot slot index))),rest)
    else none
  | _ => none

def primeRead (src : Token) (rest : List Token)
    (finish : CLogic.Expr → KeygenLevelCalls.Field → List Token →
      Option (Stmt×List Name×List Token)) : Option (Stmt×List Name×List Token) :=
  match src with
  | ['p','r','i','m','e','s'] => do
    let (srcIndex,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::['.']::member::tail => finish srcIndex (← KeygenLevelParser.field member) tail
    | _ => none
  | _ => none

def fresh (ptrs : List Name) : List Token → Option (Stmt×List Name×List Token)
  | slot::['=']::callee::['(']::rest => do
    let kind ← calleeOf callee
    let (args,rest) ← C99ProcedureParser.arguments (params kind) rest
    match rest with
    | [';']::tail => pure (.call kind args (.into slot),ptrs,tail)
    | _ => none
  | callee::['(']::rest => do
    let kind ← calleeOf callee
    let (args,rest) ← C99ProcedureParser.arguments (params kind) rest
    match rest with
    | [';']::tail => pure (.call kind args .discard,ptrs,tail)
    | _ => none
  | slot::['[']::rest => do
    let (index,rest) ← C99ArrayParser.pureExpr rest
    match rest with
    | [']']::['=']::src::tail =>
      match tail with
      | ['[']::last =>
        primeRead src last (fun srcIndex field tail =>
          match tail with
          | [';']::done => some (.storePrime slot index src srcIndex field,ptrs,done)
          | _ => none)
      | ['(']::last =>
        match calleeOf src with
        | some kind => do
          let (args,last) ← C99ProcedureParser.arguments (params kind) last
          match last with
          | [';']::done => pure (.call kind args (.store slot index),ptrs,done)
          | _ => none
        | none => none
      | _ => none
    | _ => none
  | ['r','e','t','u','r','n']::[';']::rest => pure (.retVoid,ptrs,rest)
  | slot::['=']::src::['[']::rest =>
    primeRead src rest (fun srcIndex field tail =>
      match tail with
      | [';']::done => some (.prime slot src srcIndex field,ptrs,done)
      | _ => none)
  | tokens => match pointerDeclare ptrs tokens with
    | some declared => some declared
    | none => do
      let (code,rest) ← pointerClause ptrs tokens
      pure (code,ptrs,rest)

def clause (types : KeygenWordExpr.Types) (ptrs : List Name) :
    List Token → Option (Stmt×List Token)
  | tokens => match fresh ptrs tokens with
    | some (code,_,rest) => some (code,rest)
    | none => do
      let (code,rest) ← KeygenWordParser.clause types tokens
      pure (.word code,rest)

def clauses (types : KeygenWordExpr.Types) (ptrs : List Name) (ending : Token) :
    Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | fuel+1,tokens =>
    if tokens.head?=some ending then some (skip,tokens.drop 1) else do
      let (head,rest) ← clause types ptrs tokens
      match rest with
      | [',']::tail => do
        let (next,rest) ← clauses types ptrs ending fuel tail
        pure (.seq head next,rest)
      | last::tail => if last=ending then some (head,tail) else none
      | _ => none

def declarations : Stmt → List Name×List Name
  | .word (.modular (.base (.scalar (.declare _ vars)))) => (vars,[])
  | .word (.modular (.base (.declarePtr slot))) => ([],[slot])
  | .seq a b => ((declarations a).1++(declarations b).1,
    (declarations a).2++(declarations b).2)
  | _ => ([],[])

def postLoop (slot : Name) (condition : Expr) (inner : Stmt) : Stmt :=
  .seq (.loop condition (.seq (stepIncrement slot .sub) inner) skip) (stepIncrement slot .sub)

mutual
  def parseStatement (types : KeygenWordExpr.Types) (ptrs : List Name) :
      Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (inner,_,rest) ← parseBody types ptrs fuel rest
      let vars := declarations inner
      pure (.scope vars.1 vars.2 inner,ptrs,rest)
    | fuel+1,['w','h','i','l','e']::['(']::slot::['-']::['-']::op::rest => do
      let comparison ← C99ModularParser.cmpToken op
      let (bound,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [')']::rest => do
        let (inner,ptrs,rest) ← parseStatement types ptrs fuel rest
        pure (postLoop slot (.cmp comparison (.scalar (CLogic.Expr.var slot)) bound) inner,
          ptrs,rest)
      | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
      let (condition,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [')']::rest => do
        let (inner,ptrs,rest) ← parseStatement types ptrs fuel rest
        pure (.loop condition inner skip,ptrs,rest)
      | _ => none
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← clauses types ptrs [';'] 16 rest
      let (condition,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [';']::rest => do
        let (update,rest) ← clauses types ptrs [')'] 16 rest
        let (inner,ptrs,rest) ← parseStatement types ptrs fuel rest
        pure (.seq initial (.loop condition inner update),ptrs,rest)
      | _ => none
    | fuel+1,['i','f']::['(']::callee::['(']::rest => do
      let kind ← calleeOf callee
      let (args,rest) ← C99ProcedureParser.arguments (params kind) rest
      match rest with
      | [')']::rest => do
        let (yes,ptrs,rest) ← parseStatement types ptrs fuel rest
        let (no,ptrs,rest) ← match rest with
          | ['e','l','s','e']::tail => parseStatement types ptrs fuel tail
          | _ => pure (skip,ptrs,rest)
        pure (.callBranch kind args .ne (.literal .i32 0) yes no,ptrs,rest)
      | op::tail => do
        let comparison ← C99ModularParser.cmpToken op
        let (bound,tail) ← C99ArrayParser.pureExpr tail
        match tail with
        | [')']::rest => do
          let (yes,ptrs,rest) ← parseStatement types ptrs fuel rest
          let (no,ptrs,rest) ← match rest with
            | ['e','l','s','e']::last => parseStatement types ptrs fuel last
            | _ => pure (skip,ptrs,rest)
          pure (.callBranch kind args comparison bound yes no,ptrs,rest)
        | _ => none
      | _ => none
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,rest) ← KeygenWordExpr.expression types rest
      match rest with
      | [')']::rest => do
        let (yes,ptrs,rest) ← parseStatement types ptrs fuel rest
        match rest with
        | ['e','l','s','e']::tail => do
          let (no,ptrs,rest) ← parseStatement types ptrs fuel tail
          pure (.branch condition yes no,ptrs,rest)
        | _ => pure (.branch condition yes skip,ptrs,rest)
      | _ => none
    | _+1,rest =>
      match fresh ptrs rest with
      | some (code,next,rest) => some (code,next,rest)
      | none => do
        let (code,rest) ← KeygenWordParser.statement types 64 rest
        pure (.word code,ptrs,rest)
  def parseBody (types : KeygenWordExpr.Types) (ptrs : List Name) :
      Nat → List Token → Option (Stmt×List Name×List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (skip,ptrs,rest)
    | fuel+1,rest => do
      let (first,next,rest) ← parseStatement types ptrs fuel rest
      let (tail,final,rest) ← parseBody types next fuel rest
      pure (.seq first tail,final,rest)
end

/- Member-access tokenization rule (trap 110). The shared LeafScan lexer
   surface refuses `.`, so prime-struct bodies (`primes[u].p`) never reached
   their checked primeRead productions. This is the same lexer extended with
   the dot token; comments and `//` lines are skipped exactly as in LeafScan,
   and nothing else changes. The rule lives here so no shared pinned parse or
   cache closure moves; KeygenZintCore pins the parse equalities it enables. -/
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
        let tail:=cs.takeWhile B20.C.wordChar
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
            if ['(',')','{','}','[',']',';',',','^','&','|','-','+','*','~','=','!','<','>','.'].contains c
            then (tokenize fuel cs).map ([c]::·)
            else none

def tokens (text : List Char) : Option (List Token) :=
  (tokenize (text.length+1) text).map C99ArrayParser.normalizeTypes

def region (types : KeygenWordExpr.Types) (ptrs : List Name) (start count : Nat) : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← tokens chars
  let (code,_,rest) ← parseBody types ptrs 512 lexed
  if rest.isEmpty then pure code else none

def calleeParsed (kind : Callee) : Option Stmt :=
  match kind with
  | .leaf leaf => some (.word (KeygenZintLeaves.code leaf))
  | _ => region (widths kind) (extraPointers kind) (bodyRegion kind).1
    ((bodyRegion kind).2-(bodyRegion kind).1)
def calleeBody (kind : Callee) : Stmt := (calleeParsed kind).getD skip

def shapeAdd (left right : Nat×Nat×Nat×Nat) : Nat×Nat×Nat×Nat :=
  (left.1+right.1,left.2.1+right.2.1,left.2.2.1+right.2.2.1,left.2.2.2+right.2.2.2)

/- (call, callBranch, primeRead, retVoid) counts. A zint call statement that
   silently fell through to the sealed word grammar would not be counted, so
   the per-body shape audits close that fallback gap. -/
def callShape : Stmt → Nat×Nat×Nat×Nat
  | .word _ => (0,0,0,0)
  | .call _ _ _ => (1,0,0,0)
  | .callBranch _ _ _ _ a b => shapeAdd (0,1,0,0) (shapeAdd (callShape a) (callShape b))
  | .prime _ _ _ _ => (0,0,1,0)
  | .storePrime _ _ _ _ _ => (0,0,1,0)
  | .retVoid => (0,0,0,1)
  | .seq a b | .loop _ a b => shapeAdd (callShape a) (callShape b)
  | .scope _ _ body => callShape body
  | .branch _ a b => shapeAdd (callShape a) (callShape b)

def only : List Name → Stmt → Bool
  | names,.word code => KeygenWordExec.only names code
  | names,.call kind args dst =>
    C99PointerFootprint.arguments names (writable kind) (params kind) args && destOnly names dst
  | names,.callBranch kind args _ _ yes no =>
    C99PointerFootprint.arguments names (writable kind) (params kind) args
      && only names yes && only names no
  | _,.prime _ _ _ _ => true
  | names,.storePrime array _ _ _ _ => names.contains array
  | _,.retVoid => true
  | names,.seq a b | names,.loop _ a b => only names a && only names b
  | names,.scope _ _ body => only names body
  | names,.branch _ yes no => only names yes && only names no

inductive Exec : Stmt → State → Result → Prop where
  | word (code : KeygenWordExec.Stmt) (before : State) (out : Result)
      (source : KeygenWordExec.Exec code before out) : Exec (.word code) before out
  | call (before : State) (kind : Callee) (args : List Arg) (dst : CDest) (entry : State)
      (out : Result) (v : Option Value) (after : State)
      (binding : C99ArrayReference.Bind before (params kind) args entry)
      (source : Exec (calleeBody kind) entry out)
      (returned : C99ProcedureReference.ReturnValue (result kind) out.flow v)
      (receive : ReceiveC dst {before with heap := out.state.heap} v after) :
      Exec (.call kind args dst) before ⟨after,.normal⟩
  | callTrue (before : State) (kind : Callee) (args : List Arg) (test : CLogic.Cmp)
      (bound : CLogic.Expr) (yes no : Stmt) (entry : State) (out : Result)
      (v w z : Value) (next : Result)
      (binding : C99ArrayReference.Bind before (params kind) args entry)
      (source : Exec (calleeBody kind) entry out)
      (returned : C99ProcedureReference.ReturnValue (result kind) out.flow (some v))
      (boundValue : C99ArrayReference.scalar {before with heap := out.state.heap} bound w)
      (compare : C99IntegerReference.CompareExec (C99Frontend.comparison test) v w z)
      (nonzero : z.integer≠0)
      (execution : Exec yes {before with heap := out.state.heap} next) :
      Exec (.callBranch kind args test bound yes no) before next
  | callFalse (before : State) (kind : Callee) (args : List Arg) (test : CLogic.Cmp)
      (bound : CLogic.Expr) (yes no : Stmt) (entry : State) (out : Result)
      (v w z : Value) (next : Result)
      (binding : C99ArrayReference.Bind before (params kind) args entry)
      (source : Exec (calleeBody kind) entry out)
      (returned : C99ProcedureReference.ReturnValue (result kind) out.flow (some v))
      (boundValue : C99ArrayReference.scalar {before with heap := out.state.heap} bound w)
      (compare : C99IntegerReference.CompareExec (C99Frontend.comparison test) v w z)
      (zero : z.integer=0)
      (execution : Exec no {before with heap := out.state.heap} next) :
      Exec (.callBranch kind args test bound yes no) before next
  | prime (dst src : Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field)
      (before : State) (ty : Ty) (old : Option Value) (v : Value)
      (declared : before.locals dst=some (ty,old))
      (source : KeygenLevelCalls.PrimeRead before src index field v) :
      Exec (.prime dst src index field) before ⟨bindValue before dst ty v,.normal⟩
  | storePrime (array : Name) (index : CLogic.Expr) (src : Name) (srcIndex : CLogic.Expr)
      (field : KeygenLevelCalls.Field) (before : State) (after : Memory)
      (p : ArrayPointer) (w : BitVec 32)
      (read : KeygenLevelCalls.PrimeRead before src srcIndex field (.uint32 w))
      (address : Pointer before array index p)
      (write : Store32 before.heap p w after) :
      Exec (.storePrime array index src srcIndex field) before ⟨{before with heap := after},.normal⟩
  | retVoid (before : State) : Exec .retVoid before ⟨before,.returned none⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (head : Exec a before ⟨middle,.normal⟩) (tail : Exec b middle out) : Exec (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result) (head : Exec a before out)
      (exit : out.flow≠.normal) : Exec (.seq a b) before out
  | scope (locals pointers : List Name) (body : Stmt) (before : State) (out : Result)
      (inner : Exec body before out) :
      Exec (.scope locals pointers body) before
        ⟨restoreScope before out.state locals pointers,out.flow⟩
  | branchTrue (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (nonzero : v.integer≠0)
      (execution : Exec yes before out) : Exec (.branch condition yes no) before out
  | branchFalse (condition : Expr) (yes no : Stmt) (before : State) (out : Result) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (zero : v.integer=0)
      (execution : Exec no before out) : Exec (.branch condition yes no) before out
  | loopFalse (condition : Expr) (body increment : Stmt) (before : State) (v : Value)
      (guard : KeygenWordExpr.Eval before condition v) (zero : v.integer=0) :
      Exec (.loop condition body increment) before ⟨before,.normal⟩
  | loopNormal (condition : Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : KeygenWordExpr.Eval before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨middle,.normal⟩)
      (update : Exec increment middle ⟨next,.normal⟩)
      (rest : Exec (.loop condition body increment) next out) :
      Exec (.loop condition body increment) before out
  | loopReturn (condition : Expr) (body increment : Stmt) (before after : State)
      (v : Value) (ret : Option Value) (guard : KeygenWordExpr.Eval before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨after,.returned ret⟩) :
      Exec (.loop condition body increment) before ⟨after,.returned ret⟩

def Call (kind : Callee) (before : State) (args : List Arg) : State → Option Value → Prop :=
  fun after v => ∃ entry out, C99ArrayReference.Bind before (params kind) args entry
    ∧ Exec (calleeBody kind) entry out
    ∧ C99ProcedureReference.ReturnValue (result kind) out.flow v
    ∧ after={before with heap := out.state.heap}

theorem leaf_call (kind : KeygenZintLeaves.Kind) (before : State) (args : List Arg)
    (after : State) (v : Option Value) :
    Call (.leaf kind) before args after v ↔ KeygenZintLeaves.Call kind before args after v := by
  constructor
  · intro source
    obtain ⟨entry,out,binding,execution,returned,equal⟩ := source
    subst after
    change Exec (.word (KeygenZintLeaves.code kind)) entry out at execution
    cases execution with
    | word code before out inner =>
      exact KeygenZintLeaves.Call.run entry out v binding inner returned
  · intro source
    cases source with
    | run entry out v binding execution returned =>
      exact ⟨entry,out,binding,Exec.word (KeygenZintLeaves.code kind) entry out execution,
        returned,rfl⟩

theorem receive_bytes (dst : CDest) (s after : State) (v : Option Value)
    (source : ReceiveC dst s v after) (names : List Name) (checked : destOnly names dst=true)
    (block offset : Nat) (outside : C99ArrayFrame.Outside s names block offset) :
    C99ArrayFrame.Outside after names block offset
      ∧ after.heap.bytes block offset=s.heap.bytes block offset := by
  cases source with
  | discard => exact ⟨outside,rfl⟩
  | into destination s ty old v declared => exact ⟨outside,rfl⟩
  | store array index s after p v address write =>
    have member : array∈names := List.contains_iff_mem.mp checked
    have keep := write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame s names array index p 4 address member
        write.1 write.2.1 block offset outside)
    exact ⟨outside,keep⟩

theorem receive_tables (dst : CDest) (s after : State) (v : Option Value)
    (source : ReceiveC dst s v after) : after.tables=s.tables := by
  cases source <;> rfl

theorem body_frame (calleeChecked : ∀ kind : Callee, only (writable kind) (calleeBody kind)=true)
    (code : Stmt) (before : State) (out : Result) (source : Exec code before out)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source generalizing names with
  | word code before out source =>
    exact KeygenWordExec.body_frame code before out source names checked block offset outside
  | call before kind args dst entry out v after binding source returned receive ih =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (params kind) args entry binding
      names (writable kind) ha block offset outside tables
    obtain ⟨_,_,fa⟩ := ih (writable kind) (calleeChecked kind) ho
      (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)
    rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at fa
    obtain ⟨ra,rf⟩ := receive_bytes dst {before with heap := out.state.heap} after v receive
      names hb block offset outside
    exact ⟨ra,receive_tables dst {before with heap := out.state.heap} after v receive,rf.trans fa⟩
  | callTrue before kind args test bound yes no entry out v w z next binding source returned
      boundValue compare nonzero execution ih1 ih2 =>
    obtain ⟨first,hno⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ha,hyes⟩ := Bool.and_eq_true_iff.mp first
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (params kind) args entry binding
      names (writable kind) ha block offset outside tables
    obtain ⟨_,_,fa⟩ := ih1 (writable kind) (calleeChecked kind) ho
      (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)
    rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at fa
    have base : C99ArrayFrame.Outside {before with heap := out.state.heap} names block offset :=
      outside
    have tm : C99PointerFootprint.TablesOutside {before with heap := out.state.heap} block offset := by
      simpa only [C99PointerFootprint.TablesOutside] using tables
    obtain ⟨oa,ta,fb⟩ := ih2 names hyes base tm
    exact ⟨oa,ta,fb.trans fa⟩
  | callFalse before kind args test bound yes no entry out v w z next binding source returned
      boundValue compare zero execution ih1 ih2 =>
    obtain ⟨first,hno⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ha,hyes⟩ := Bool.and_eq_true_iff.mp first
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (params kind) args entry binding
      names (writable kind) ha block offset outside tables
    obtain ⟨_,_,fa⟩ := ih1 (writable kind) (calleeChecked kind) ho
      (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)
    rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at fa
    have base : C99ArrayFrame.Outside {before with heap := out.state.heap} names block offset :=
      outside
    have tm : C99PointerFootprint.TablesOutside {before with heap := out.state.heap} block offset := by
      simpa only [C99PointerFootprint.TablesOutside] using tables
    obtain ⟨oa,ta,fb⟩ := ih2 names hno base tm
    exact ⟨oa,ta,fb.trans fa⟩
  | prime | retVoid | loopFalse => exact ⟨outside,rfl,rfl⟩
  | storePrime array index src srcIndex field before after p w read address write =>
    have member : array∈names := List.contains_iff_mem.mp checked
    have keep := write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names array index p 4 address member
        write.1 write.2.1 block offset outside)
    exact ⟨outside,rfl,keep⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 names ha outside tables
    change middle.tables=before.tables at ta
    have tm : C99PointerFootprint.TablesOutside middle block offset := by
      simpa only [C99PointerFootprint.TablesOutside,ta] using tables
    obtain ⟨ob,tb,fb⟩ := ih2 names hb oa tm
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out head exit ih =>
    exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before out inner ih =>
    obtain ⟨ho,ht,hf⟩ := ih names checked outside tables
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset
      outside ho,ht,hf⟩
  | branchTrue condition yes no before out v guard nonzero execution ih =>
    exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before out v guard zero execution ih =>
    exact ih names (Bool.and_eq_true_iff.mp checked).2 outside tables
  | loopNormal condition body increment before middle next out v guard nonzero iteration update
      rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 names ha outside tables
    change middle.tables=before.tables at ta
    have tm : C99PointerFootprint.TablesOutside middle block offset := by
      simpa only [C99PointerFootprint.TablesOutside,ta] using tables
    obtain ⟨ob,tb,fb⟩ := ih2 names hb oa tm
    change next.tables=middle.tables at tb
    have tn : C99PointerFootprint.TablesOutside next block offset := by
      simpa only [C99PointerFootprint.TablesOutside,tb,ta] using tables
    obtain ⟨oc,tc,fc⟩ := ih3 names checked ob tn
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables

theorem call_frame (kind : Callee) (before after : State) (args : List Arg) (v : Option Value)
    (source : Call kind before args after v) (names : List Name) (block offset : Nat)
    (allowed : C99PointerFootprint.arguments names (writable kind) (params kind) args=true)
    (calleeChecked : ∀ kind : Callee, only (writable kind) (calleeBody kind)=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,out,binding,execution,returned,equal⟩ := source
  subst after
  obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before (params kind) args entry binding
    names (writable kind) allowed block offset outside tables
  obtain ⟨_,_,keep⟩ := body_frame calleeChecked (calleeBody kind) entry out execution
    (writable kind) (calleeChecked kind) block offset ho
    (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)
  rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at keep
  exact keep

end FT1536.Source3.KeygenZintCall
