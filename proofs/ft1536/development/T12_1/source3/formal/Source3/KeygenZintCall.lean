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
   (tokenized by the member-access rule of `tokens`, trap 110), the
   same-width `*(T*)&local` bitcast statements and the `#define`/`#undef`
   macro scope of zint_co_reduce_mod, pointer declaration/assignment/advance for the local walk pointer,
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
  | coReduce | coReduceMod | reduce | reduceMod | bezout
  | bitlength | signedBitLength
  deriving DecidableEq, Repr

def calleeName : Callee → Name
  | .leaf kind => KeygenZintLeaves.name kind
  | .modSigned => "zint_mod_small_signed".toList
  | .normZero => "zint_norm_zero".toList
  | .exactLen => "zint_exact_length".toList
  | .rshiftMod => "zint_rshift1_mod".toList
  | .subMod => "zint_sub_mod".toList
  | .rebuildCrt => "zint_rebuild_CRT".toList
  | .coReduce => "zint_co_reduce".toList
  | .coReduceMod => "zint_co_reduce_mod".toList
  | .reduce => "zint_reduce".toList
  | .reduceMod => "zint_reduce_mod".toList
  | .bezout => "zint_bezout".toList
  | .bitlength => "bitlength".toList
  | .signedBitLength => "zint_signed_bit_length".toList

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
  | .coReduce => [.pointer "a".toList,.pointer "b".toList,
    .scalar .uint64 "len".toList,.scalar .int32 "xa".toList,
    .scalar .int32 "xb".toList,.scalar .int32 "ya".toList,
    .scalar .int32 "yb".toList]
  | .coReduceMod => [.pointer "a".toList,.pointer "b".toList,
    .pointer "m".toList,.scalar .uint64 "len".toList,
    .scalar .uint32 "m0i".toList,.scalar .int32 "xa".toList,
    .scalar .int32 "xb".toList,.scalar .int32 "ya".toList,
    .scalar .int32 "yb".toList]
  | .reduce => [.pointer "a".toList,.pointer "b".toList,
    .scalar .uint64 "len".toList,.scalar .int32 "k".toList]
  | .reduceMod => [.pointer "a".toList,.pointer "b".toList,
    .pointer "m".toList,.scalar .uint64 "len".toList,
    .scalar .uint32 "m0i".toList,.scalar .int32 "k".toList]
  | .bezout => [.pointer "u".toList,.pointer "v".toList,
    .pointer "x".toList,.pointer "y".toList,
    .scalar .uint64 "len".toList,.pointer "tmp".toList]
  | .bitlength => [.scalar .uint32 "x".toList]
  | .signedBitLength => [.pointer "x".toList,.scalar .uint64 "xlen".toList]

def result : Callee → Option Ty
  | .leaf kind => KeygenZintLeaves.result kind
  | .modSigned => some .uint32
  | .normZero => none
  | .exactLen => some .uint64
  | .rshiftMod => none
  | .subMod => none
  | .rebuildCrt => none
  | .coReduce => some .int32
  | .coReduceMod => none
  | .reduce => some .int32
  | .reduceMod => none
  | .bezout => some .int32
  | .bitlength | .signedBitLength => some .uint32

def writable : Callee → List Name
  | .leaf kind => KeygenZintLeaves.writable kind
  | .modSigned => []
  | .normZero => ["x".toList]
  | .exactLen => []
  | .rshiftMod => ["x".toList]
  | .subMod => ["x".toList]
  | .rebuildCrt => ["xx".toList,"tmp".toList,"x".toList]
  | .coReduce => ["a".toList,"b".toList]
  | .coReduceMod => ["a".toList,"b".toList]
  | .reduce => ["a".toList]
  | .reduceMod => ["a".toList]
  -- zint_bezout writes its u/v outputs (u0=u, v0=v) and the four tmp
  -- lanes reached through the local walk pointers u1, v1, a and b. Both
  -- the parameters and the local pointer names must be listed: pointer
  -- binds check their source name and stores check their walk name.
  | .bezout => ["u".toList,"v".toList,"tmp".toList,
    "u0".toList,"u1".toList,"v0".toList,"v1".toList,"a".toList,"b".toList]
  | .bitlength | .signedBitLength => []

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
  | .coReduce => (3666,3)
  | .coReduceMod => (3731,3)
  | .reduce => (3808,2)
  | .reduceMod => (3851,3)
  | .bezout => (3904,4)
  | .bitlength => (4206,2)
  | .signedBitLength => (4244,2)

/-- Body region as (first body line, closing brace line). -/
def bodyRegion : Callee → Nat×Nat
  | .leaf _ => (0,0)
  | .modSigned => (3426,3434)
  | .normZero => (3542,3560)
  | .exactLen => (3643,3650)
  | .rshiftMod => (3489,3498)
  | .subMod => (3507,3510)
  | .rebuildCrt => (3581,3634)
  | .coReduce => (3670,3725)
  | .coReduceMod => (3735,3802)
  | .reduce => (3811,3845)
  | .reduceMod => (3855,3889)
  | .bezout => (3909,4200)
  | .bitlength => (4209,4237)
  | .signedBitLength => (4247,4263)

inductive CDest where
  | discard
  | into (destination : Name)
  | store (array : Name) (index : CLogic.Expr)
  deriving DecidableEq, Repr

/- memset's zero-byte write of an explicit byte count at a resolved object
   position. It is the C library operation used by zint_bezout
   (`memset(dst, 0, n * sizeof *element)` with 4-byte limbs); nonzero byte
   values are rejected by the parser rather than approximated. The frame is
   the same outside-footprint law as Memcpy. -/
def Memzero (before : Memory) (p : ArrayPointer) (bytes : Nat) (after : Memory) : Prop :=
  p.offset+bytes≤before.size p.block ∧
  before.size p.block<2^64 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  (∀ i<bytes, after.bytes p.block (p.offset+i)=some 0) ∧
  (∀ block offset, block≠p.block ∨ offset<p.offset ∨ p.offset+bytes≤offset →
    after.bytes block offset=before.bytes block offset)

/- A block-scope static array is an existing read-only object, not an
   automatic allocation or a lookup oracle. The declaration resolves its
   qualified identity and checks every initializer against actual Load32
   bytes. The local array name is restored by the usual scope/call rules. -/
def vvName : Name := "vv".toList
def vvObject : Name := "bitlength.vv".toList
def Static32 (heap : Memory) (p : ArrayPointer) (values : List (BitVec 32)) : Prop :=
  heap.writable p.block=false ∧ p.base=0 ∧ p.index=0 ∧
  p.elementBytes=4 ∧ p.count=values.length ∧ heap.size p.block=4*values.length ∧
  ∀ i : Fin values.length, Load32 heap {p with index := i.val} values[i.val]

def valueEntry (caller : State) (value : Value) : State :=
  bindValue ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
    "x".toList .uint32 value

inductive Stmt where
  | word (code : KeygenWordExec.Stmt)
  | call (kind : Callee) (args : List Arg) (dst : CDest)
  | callBranch (kind : Callee) (args : List Arg) (test : CLogic.Cmp)
      (bound : CLogic.Expr) (yes no : Stmt)
  | prime (dst src : Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field)
  | storePrime (array : Name) (index : CLogic.Expr) (src : Name)
      (srcIndex : CLogic.Expr) (field : KeygenLevelCalls.Field)
  | bitcastInto (dst src : Name) (ty : Ty)
  | static32 (values : List (BitVec 32))
  | retSum (left argument : Expr)
  | memzero (array : Name) (index count : CLogic.Expr)
  | breakLoop
  | continueLoop
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

/- Same-width reinterpretation of an automatic scalar's object bytes for
   the source type-pun `*(T*)&local` (the cast target is `T*`, GCC LP64).
   The checked bodies only pun same-width locals (uint32->int32,
   uint64->int64); cross-width reads stay outside this rule rather than
   being approximated. -/
def reinterpret (target : Ty) : Value → Option Value
  | .uint64 x => match target with
    | .uint64 => some (.uint64 x)
    | .int64 => some (.int64 x)
    | _ => none
  | .int64 x => match target with
    | .uint64 => some (.uint64 x)
    | .int64 => some (.int64 x)
    | _ => none
  | .uint32 x => match target with
    | .uint32 => some (.uint32 x)
    | .int32 => some (.int32 x)
    | _ => none
  | .int32 x => match target with
    | .uint32 => some (.uint32 x)
    | .int32 => some (.int32 x)
    | _ => none

def calleeOf (token : Token) : Option Callee :=
  if token="zint_mod_small_signed".toList then some .modSigned else
  if token="zint_norm_zero".toList then some .normZero else
  if token="zint_exact_length".toList then some .exactLen else
  if token="zint_rshift1_mod".toList then some .rshiftMod else
  if token="zint_sub_mod".toList then some .subMod else
  if token="zint_rebuild_CRT".toList then some .rebuildCrt else
  if token="zint_co_reduce_mod".toList then some .coReduceMod else
  if token="zint_co_reduce".toList then some .coReduce else
  if token="zint_reduce_mod".toList then some .reduceMod else
  if token="zint_reduce".toList then some .reduce else
  if token="zint_bezout".toList then some .bezout else
  if token="bitlength".toList then some .bitlength else
  if token="zint_signed_bit_length".toList then some .signedBitLength else
  if token="zint_mod_small_unsigned".toList then some (.leaf .reduce) else
  if token="zint_add_mul_small".toList then some (.leaf .addMul) else
  if token="zint_mul_small".toList then some (.leaf .mul) else
  if token="zint_add".toList then some (.leaf .add) else
  if token="zint_sub".toList then some (.leaf .sub) else
  if token="zint_rshift1".toList then some (.leaf .shift) else
  if token="zint_ucmp".toList then some (.leaf .compare) else none

/- Local pointer declarations extend the width environment for word array
   accesses (`u0[0]`, `a[len-1]`, `sizeof *v1`): every zint-family walk
   pointer is a `uint32_t *` limb pointer of element width 4. Scalars need
   no width. `size_t` is the LP64 typedef the shared scalar type table does
   not carry (trap 84 family); it maps to the 64-bit unsigned word. -/
def env (types : KeygenWordExpr.Types) (ptrs : List Name) : KeygenWordExpr.Types :=
  types++ptrs.map (fun n => (n,4))

def zintTypeToken (token : Token) : Option B20.C.Ty :=
  if token="size_t".toList then some .u64 else KeygenWordExpr.typeToken token

/- `sizeof *element` in memcpy/memset byte counts is lowered by the checked
   KeygenSearchParser normalizer at the CURRENT width environment, so 4-byte
   limbs become `* 4ULL` inside the ordinary count expression. -/
def copyCount (types : KeygenWordExpr.Types) : List Token → Option (CLogic.Expr×List Token) :=
  fun tokens => do
    let normalized ← KeygenSearchParser.sizes types tokens
    let (count,rest) ← C99ArrayParser.pureExpr normalized
    match rest with
    | [')']::[';']::tail => some (count,tail)
    | _ => none

/- Scalar declarations with the extended zint type table (`size_t` under the
   pinned LP64 profile); the statement shape is the sealed word grammar's
   declaration, so scope collection is unchanged. -/
def scalarDeclare : List Token → Option (Stmt×List Token)
  | ty::rest => do
    let declared ← zintTypeToken ty
    let (names,rest) ← B20.C.Scalar.names 32 rest
    some (.word (.modular (.base (.scalar (.declare declared names)))),rest)
  | _ => none

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

/- Statement-position pointer binds (`u0 = u;`, `f += fstride;`) consume
   their terminating `;`, unlike the for-clause `pointerClause` above whose
   ending token belongs to `clauses` (rebuild_CRT's `x = xx`/`x += xstride`
   loop clauses). zint_bezout's six walk-pointer binds are statements. -/
def pointerStmt (ptrs : List Name) : List Token → Option (Stmt×List Token)
  | slot::['=']::rest => if ptrs.contains slot then do
      let (p,rest) ← C99ProcedureParser.pointerExpr rest
      match p,rest with
      | .pointer src index,[';']::tail =>
        some (.word (.modular (.base (.bindPtr slot src index))),tail)
      | _,_ => none
    else none
  | slot::['+','=']::rest => if ptrs.contains slot then do
      let (index,rest) ← C99ArrayParser.pureExpr rest
      match rest with
      | [';']::tail => some (.word (.modular (.base (.bindPtr slot slot index))),tail)
      | _ => none
    else none
  | _ => none

/- Ternary conditional assignment `slot = cond ? a : b;` (the conditional
   operator is new grammar here). The three subexpressions keep their source
   order and both arms stay explicit statements: the lowering is a branch of
   two whole assignments evaluated from the same pre-assignment state. Only
   scalar destinations qualify; pointer selection (make_fg's
   `primes = ter ? PRIMES3 : PRIMES2`) has its own rule. -/
def ternaryAssign (types : KeygenWordExpr.Types) (ptrs : List Name) :
    List Token → Option (Stmt×List Name×List Token)
  | slot::['=']::rest => if ptrs.contains slot then none else do
      let (condition,r1) ← KeygenWordExpr.expression (env types ptrs) rest
      match r1 with
      | ['?']::r2 => do
        let (yes,r3) ← KeygenWordExpr.expression (env types ptrs) r2
        match r3 with
        | [':']::r4 => do
          let (no,r5) ← KeygenWordExpr.expression (env types ptrs) r4
          match r5 with
          | [';']::done =>
            let left : Stmt := .word (.assign slot yes)
            let right : Stmt := .word (.assign slot no)
            pure (.branch condition left right,ptrs,done)
          | _ => none
        | _ => none
      | _ => none
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

/- Initializer grammar for the unsized `static const unsigned vv[]`.
   The source supplies its inferred length; decimal/hex literals use the
   pinned C literal typing rule, with no truncation of out-of-range words. -/
def staticWords : Nat → List Token → Option (List (BitVec 32)×List Token)
  | 0,_ => none
  | fuel+1,token::rest => do
    let expression ← CLogicParser.number token
    let n ← match expression with | .literal _ n => some n | _ => none
    if n≥2^32 then none else do
      match rest with
      | ['}']::[';']::tail => pure ([BitVec.ofNat 32 n],tail)
      | [',']::tail => do
        let (values,tail) ← staticWords fuel tail
        pure (BitVec.ofNat 32 n::values,tail)
      | _ => none
  | _,_ => none

/- A value-level call in the returned sum. The word-expression parser
   supplies the exact operator tree, but this call must execute bitlength's
   body rather than fall through to the closed modular-call relation. No
   invented local or pointer-to-scalar argument is introduced. -/
def returnValueCall (types : KeygenWordExpr.Types) (ptrs : List Name) :
    List Token → Option (Stmt×List Name×List Token)
  | ['r','e','t','u','r','n']::rest => do
    let (e,rest) ← KeygenWordExpr.expression (env types ptrs) rest
    match e,rest with
    | .bin .add left (.call1 name argument),[';']::tail =>
      if name="bitlength".toList then some (.retSum left argument,ptrs,tail) else none
    | _,_ => none
  | _ => none

def fresh (types : KeygenWordExpr.Types) (ptrs : List Name) :
    List Token → Option (Stmt×List Name×List Token)
  | ['r','e','t','u','r','n']::[';']::rest => pure (.retVoid,ptrs,rest)
  | ['r','e','t','u','r','n']::rest => returnValueCall types ptrs ("return".toList::rest)
  | ['s','t','a','t','i','c']::['c','o','n','s','t']::['u','n','s','i','g','n','e','d']::
      ['v','v']::['[']::[']']::['=']::['{']::rest => do
    let (values,rest) ← staticWords 64 rest
    pure (.static32 values,vvName::ptrs,rest)
  | slot::['=']::['*']::['(']::ty::['*']::[')']::['&']::src::[';']::rest => do
    let base ← KeygenWordExpr.typeToken ty
    pure (.bitcastInto slot src (C99ValueBridge.type base),ptrs,rest)
  | ['m','e','m','c','p','y']::['(']::rest => do
    let (dst,rest) ← C99ProcedureParser.pointerExpr rest
    match dst,rest with
    | .pointer d di,[',']::rest => do
      let (src,rest) ← C99ProcedureParser.pointerExpr rest
      match src,rest with
      | .pointer s si,[',']::rest => do
        let (count,rest) ← copyCount (env types ptrs) rest
        pure (.word (.modular (.base (.copy d s di si count))),ptrs,rest)
      | _,_ => none
    | _,_ => none
  | ['m','e','m','s','e','t']::['(']::rest => do
    let (dst,rest) ← C99ProcedureParser.pointerExpr rest
    match dst,rest with
    | .pointer d di,[',']::['0']::[',']::rest => do
      let (count,rest) ← copyCount (env types ptrs) rest
      pure (.memzero d di count,ptrs,rest)
    | _,_ => none
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
  | ['b','r','e','a','k']::[';']::rest => pure (.breakLoop,ptrs,rest)
  | ['c','o','n','t','i','n','u','e']::[';']::rest => pure (.continueLoop,ptrs,rest)
  | slot::['=']::src::['[']::rest =>
    primeRead src rest (fun srcIndex field tail =>
      match tail with
      | [';']::done => some (.prime slot src srcIndex field,ptrs,done)
      | _ => none)
  | tokens => match returnValueCall types ptrs tokens with
    | some returned => some returned
    | none => match ternaryAssign types ptrs tokens with
      | some conditional => some conditional
      | none => match pointerDeclare ptrs tokens with
        | some declared => some declared
        | none => match scalarDeclare tokens with
          | some (code,rest) => some (code,ptrs,rest)
          | none => match pointerStmt ptrs tokens with
            | some (code,rest) => some (code,ptrs,rest)
            | none => none

def clause (types : KeygenWordExpr.Types) (ptrs : List Name) :
    List Token → Option (Stmt×List Token)
  | tokens => match pointerClause ptrs tokens with
    | some (code,rest) => some (code,rest)
    | none => do
      let (code,rest) ← KeygenWordParser.clause (env types ptrs) tokens
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
  | .static32 _ => ([],[vvName])
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
      let (bound,rest) ← KeygenWordExpr.expression (env types ptrs) rest
      match rest with
      | [')']::rest => do
        let (inner,ptrs,rest) ← parseStatement types ptrs fuel rest
        pure (postLoop slot (.cmp comparison (.scalar (CLogic.Expr.var slot)) bound) inner,
          ptrs,rest)
      | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
      let (condition,rest) ← KeygenWordExpr.expression (env types ptrs) rest
      match rest with
      | [')']::rest => do
        let (inner,ptrs,rest) ← parseStatement types ptrs fuel rest
        pure (.loop condition inner skip,ptrs,rest)
      | _ => none
    | fuel+1,['f','o','r']::['(']::[';']::[';']::[')']::rest => do
      let (inner,ptrs,rest) ← parseStatement types ptrs fuel rest
      pure (.loop (.scalar (.literal .i32 1)) inner skip,ptrs,rest)
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,rest) ← clauses types ptrs [';'] 16 rest
      let (condition,rest) ← KeygenWordExpr.expression (env types ptrs) rest
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
      let (condition,rest) ← KeygenWordExpr.expression (env types ptrs) rest
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
      match fresh types ptrs rest with
      | some (code,next,rest) => some (code,next,rest)
      | none => do
        let (code,rest) ← KeygenWordParser.statement (env types ptrs) 64 rest
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

/- Member-access and macro-scope tokenization rules (trap 110). The shared
   LeafScan lexer surface refuses `.`, so prime-struct bodies (`primes[u].p`)
   never reached their checked primeRead productions. This is the same lexer
   extended with the dot token; comments and `//` lines are skipped exactly
   as in LeafScan, and nothing else changes. Preprocessor directives get the
   C textual semantics used by zint_co_reduce_mod: `#define NAME tokens`
   splices the tokenized rest-of-line at later word occurrences, `#undef
   NAME` removes the binding, unknown directives are rejected. The rules live
   here so no shared pinned parse or cache closure moves; KeygenZintCore
   pins the parse equalities they enable. -/
def expand (macros : List (Token×List Token)) (word : Token) : List Token :=
  match macros.find? (fun entry => entry.1=word) with
  | some (_,body) => body
  | none => [word]

def tokenize (macros : List (Token×List Token)) : Nat → List Char → Option (List Token)
  | 0,_ => none
  | _+1,[] => some []
  | fuel+1,'/'::'*'::rest => do
      let tail ← B20.C.Scalar.skipBlock (rest.length+1) rest
      tokenize macros fuel tail
  | fuel+1,'/'::'/'::rest => tokenize macros fuel (rest.dropWhile (· != '\n'))
  | fuel+1,'#'::cs =>
      let line := cs.takeWhile (· != '\n')
      let beyond := cs.drop line.length
      let directive := line.takeWhile B20.C.wordChar
      let after := line.drop directive.length
      if directive="undef".toList then
        let name := (after.dropWhile (·==' ')).takeWhile B20.C.wordChar
        tokenize (macros.filter (fun entry => entry.1≠name)) fuel beyond
      else if directive="define".toList then
        let spacing := after.dropWhile (·==' ')
        let name := spacing.takeWhile B20.C.wordChar
        let body := (spacing.drop name.length).dropWhile (·==' ')
        do
          let expansion ← tokenize macros fuel body
          tokenize ((name,expansion)::macros) fuel beyond
      else none
  | fuel+1,c::cs =>
      if c==' ' || c=='\t' || c=='\n' || c=='\r' then tokenize macros fuel cs
      else if B20.C.wordChar c then
        let tail:=cs.takeWhile B20.C.wordChar
        let emitted := expand macros (c::tail)
        (tokenize macros fuel (cs.drop tail.length)).map (emitted++·)
      else match c,cs with
        | '+','+'::rest => (tokenize macros fuel rest).map (['+','+']::·)
        | '>','>'::'='::rest => (tokenize macros fuel rest).map (['>','>','=']::·)
        | '<','<'::'='::rest => (tokenize macros fuel rest).map (['<','<','=']::·)
        | '>','>'::rest => (tokenize macros fuel rest).map (['>','>']::·)
        | '<','<'::rest => (tokenize macros fuel rest).map (['<','<']::·)
        | '&','&'::rest => (tokenize macros fuel rest).map (['&','&']::·)
        | '|','|'::rest => (tokenize macros fuel rest).map (['|','|']::·)
        | _,'='::rest =>
            if ['+','-','*','^','&','|','=','!','<','>'].contains c then
              (tokenize macros fuel rest).map ([c,'=']::·)
            else none
        | _,_ =>
            if ['(',')','{','}','[',']',';',',','^','&','|','-','+','*','~','=','!','<','>','.','?',':'].contains c
            then (tokenize macros fuel cs).map ([c]::·)
            else none

def tokens (text : List Char) : Option (List Token) :=
  (tokenize [] (text.length+1) text).map C99ArrayParser.normalizeTypes

def region (types : KeygenWordExpr.Types) (ptrs : List Name) (start count : Nat) : Option Stmt := do
  let chars := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← tokens chars
  let (code,_,rest) ← parseBody types ptrs 512 lexed
  if rest.isEmpty then pure code else none

/- zint_bezout is source-bound in eight statement-boundary pieces with a
   chained scaffold (kernel memory discipline, traps 88/95/98; the accepted
   KeygenDepth0Source and ShakeBlockProgram precedents). Piece 0 declares
   the six walk pointers and pieces 1-7 parse with that pointer environment,
   exactly as the threaded monolithic parse would see it. `bezoutCode` is
   the executed body; KeygenZintCore pins the body line partition and every
   piece parse/audit. -/
def bezoutPtrs : List Name := ["u0","u1","v0","v1","a","b"].map String.toList
def bezoutParsed : Nat → Option Stmt
  | 0 => region (widths .bezout) [] 3909 4
  | 1 => region (widths .bezout) bezoutPtrs 3913 33
  | 2 => region (widths .bezout) bezoutPtrs 3946 7
  | 3 => region (widths .bezout) bezoutPtrs 3953 9
  | 4 => region (widths .bezout) bezoutPtrs 3962 17
  | 5 => region (widths .bezout) bezoutPtrs 3979 15
  | 6 => region (widths .bezout) bezoutPtrs 3994 21
  | 7 => region (widths .bezout) bezoutPtrs 4015 185
  | _ => none
def bezoutPart (index : Nat) : Stmt := (bezoutParsed index).getD skip
def bezoutCode : Stmt := chain [bezoutPart 0,bezoutPart 1,bezoutPart 2,bezoutPart 3,
  bezoutPart 4,bezoutPart 5,bezoutPart 6,bezoutPart 7]

/- Statement-boundary pieces keep the initializer and each return-call
   grammar obligation independently kernel-checkable. Source line partitions
   and non-vacuous per-piece audits live in KeygenZintExtract. -/
def extractParsed : Callee → Nat → Option Stmt
  | .bitlength,0 => region (widths .bitlength) [] 4209 21
  | .bitlength,1 => region (widths .bitlength) [vvName] 4230 6
  | .bitlength,2 => region (widths .bitlength) [vvName] 4236 1
  | .signedBitLength,0 => region (widths .signedBitLength) [] 4247 2
  | .signedBitLength,1 => region (widths .signedBitLength) [] 4249 3
  | .signedBitLength,2 => region (widths .signedBitLength) [] 4252 7
  | .signedBitLength,3 => region (widths .signedBitLength) [] 4259 3
  | .signedBitLength,4 => region (widths .signedBitLength) [] 4262 1
  | _,_ => none
def extractPart (kind : Callee) (index : Nat) : Stmt := (extractParsed kind index).getD skip
def bitlengthCode : Stmt := chain [extractPart .bitlength 0,extractPart .bitlength 1,
  extractPart .bitlength 2]
def signedBitLengthCode : Stmt := chain [extractPart .signedBitLength 0,
  extractPart .signedBitLength 1,extractPart .signedBitLength 2,
  extractPart .signedBitLength 3,extractPart .signedBitLength 4]

def calleeParsed (kind : Callee) : Option Stmt :=
  match kind with
  | .leaf leaf => some (.word (KeygenZintLeaves.code leaf))
  | .bezout => some bezoutCode
  | .bitlength => some bitlengthCode
  | .signedBitLength => some signedBitLengthCode
  | _ => region (widths kind) (extraPointers kind) (bodyRegion kind).1
    ((bodyRegion kind).2-(bodyRegion kind).1)
def calleeBody (kind : Callee) : Stmt := (calleeParsed kind).getD skip

def shapeAdd (left right : Nat×Nat×Nat×Nat) : Nat×Nat×Nat×Nat :=
  (left.1+right.1,left.2.1+right.2.1,left.2.2.1+right.2.2.1,left.2.2.2+right.2.2.2)

/- (call, callBranch, primeRead, retVoid) counts. A zint call statement that
   silently fell through to the sealed word grammar would not be counted, so
   the per-body shape audits close that fallback gap. -/
def callShape : Stmt → Nat×Nat×Nat×Nat
  | .word _ | .bitcastInto _ _ _ | .static32 _ | .memzero _ _ _ | .breakLoop | .continueLoop => (0,0,0,0)
  | .retSum _ _ => (1,0,0,0)
  | .call _ _ _ => (1,0,0,0)
  | .callBranch _ _ _ _ a b => shapeAdd (0,1,0,0) (shapeAdd (callShape a) (callShape b))
  | .prime _ _ _ _ => (0,0,1,0)
  | .storePrime _ _ _ _ _ => (0,0,1,0)
  | .retVoid => (0,0,0,1)
  | .seq a b | .loop _ a b => shapeAdd (callShape a) (callShape b)
  | .scope _ _ body => callShape body
  | .branch _ a b => shapeAdd (callShape a) (callShape b)

/- Separate count of `*(T*)&local` statements: their parse has no fallback
   production, so an exact per-body count pins the pun sites. -/
def bitcastCount : Stmt → Nat
  | .bitcastInto _ _ _ => 1
  | .callBranch _ _ _ _ a b | .branch _ a b | .seq a b | .loop _ a b =>
    bitcastCount a + bitcastCount b
  | .scope _ _ body => bitcastCount body
  | _ => 0

def only : List Name → Stmt → Bool
  | _,.static32 _ | _,.retSum _ _ => true
  | names,.word code => KeygenWordExec.only names code
  | names,.call kind args dst =>
    C99PointerFootprint.arguments names (writable kind) (params kind) args && destOnly names dst
  | names,.callBranch kind args _ _ yes no =>
    C99PointerFootprint.arguments names (writable kind) (params kind) args
      && only names yes && only names no
  | _,.prime _ _ _ _ | _,.bitcastInto _ _ _ | _,.breakLoop | _,.continueLoop => true
  | names,.storePrime array _ _ _ _ => names.contains array
  | names,.memzero array _ _ => names.contains array
  | _,.retVoid => true
  | names,.seq a b | names,.loop _ a b => only names a && only names b
  | names,.scope _ _ body => only names body
  | names,.branch _ yes no => only names yes && only names no

inductive Exec : Stmt → State → Result → Prop where
  | static32 (values : List (BitVec 32)) (before : State) (p : ArrayPointer)
      (binding : before.tables vvObject=some p)
      (initialized : Static32 before.heap p values) :
      Exec (.static32 values) before ⟨C99ArrayReference.bindPointer before vvName p,.normal⟩
  | retSum (left argument : Expr) (before : State) (a x v z : Value) (out : Result)
      (leftValue : KeygenWordExpr.Eval before left a)
      (argumentValue : KeygenWordExpr.Eval before argument x)
      (source : Exec (calleeBody .bitlength) (valueEntry before x) out)
      (returned : C99ProcedureReference.ReturnValue (result .bitlength) out.flow (some v))
      (addition : C99OperatorBridge.Binary .add a v z) :
      Exec (.retSum left argument) before ⟨{before with heap := out.state.heap},.returned (some z)⟩
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
  | bitcastInto (dst src : Name) (ty : Ty) (before : State) (held : Ty)
      (old : Option Value) (v w : Value)
      (declared : before.locals dst=some (ty,old))
      (read : before.locals src=some (held,some v))
      (view : reinterpret ty v=some w) :
      Exec (.bitcastInto dst src ty) before ⟨bindValue before dst ty w,.normal⟩
  | memzero (before : State) (after : Memory) (array : Name) (index count : CLogic.Expr)
      (p : ArrayPointer) (n : BitVec 64)
      (address : Pointer before array index p)
      (length : C99ArrayReference.scalar before count (.uint64 n))
      (object : p.offset+n.toNat≤p.base+p.elementBytes*p.count)
      (zeroed : Memzero before.heap p n.toNat after) :
      Exec (.memzero array index count) before ⟨{before with heap := after},.normal⟩
  | breakLoop (before : State) : Exec .breakLoop before ⟨before,.breakLoop⟩
  | continueLoop (before : State) : Exec .continueLoop before ⟨before,.continueLoop⟩
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
  | loopBreak (condition : Expr) (body increment : Stmt) (before after : State)
      (v : Value) (guard : KeygenWordExpr.Eval before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨after,.breakLoop⟩) :
      Exec (.loop condition body increment) before ⟨after,.normal⟩
  | loopContinue (condition : Expr) (body increment : Stmt) (before middle next : State)
      (out : Result) (v : Value) (guard : KeygenWordExpr.Eval before condition v)
      (nonzero : v.integer≠0) (iteration : Exec body before ⟨middle,.continueLoop⟩)
      (update : Exec increment middle ⟨next,.normal⟩)
      (rest : Exec (.loop condition body increment) next out) :
      Exec (.loop condition body increment) before out

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
  | static32 values before p binding initialized =>
    refine ⟨?_,rfl,rfl⟩
    intro n hn q hq
    by_cases he : n=vvName
    · have hpq : p=q := Option.some.inj (by simpa [C99ArrayReference.bindPointer,he] using hq)
      subst q
      exact tables vvObject p binding
    · exact outside n hn q (by simpa [C99ArrayReference.bindPointer,he] using hq)
  | retSum left argument before a x v z out leftValue argumentValue source returned addition ih =>
    have ho : C99ArrayFrame.Outside (valueEntry before x) (writable .bitlength) block offset := by
      intro n hn
      cases hn
    have ht : C99PointerFootprint.TablesOutside (valueEntry before x) block offset := tables
    obtain ⟨_,_,keep⟩ := ih (writable .bitlength) (calleeChecked .bitlength) ho ht
    exact ⟨outside,rfl,keep⟩
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
  | prime | retVoid | loopFalse | bitcastInto | breakLoop | continueLoop =>
    exact ⟨outside,rfl,rfl⟩
  | storePrime array index src srcIndex field before after p w read address write =>
    have member : array∈names := List.contains_iff_mem.mp checked
    have keep := write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names array index p 4 address member
        write.1 write.2.1 block offset outside)
    exact ⟨outside,rfl,keep⟩
  | memzero before after array index count p n address length object zeroed =>
    have member : array∈names := List.contains_iff_mem.mp checked
    have keep := zeroed.2.2.2.2.2.2 block offset
      (C99PointerFootprint.copy_frame before names array index p n.toNat address member
        object block offset outside)
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
  | loopBreak condition body increment before after v guard nonzero iteration ih =>
    exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | loopContinue condition body increment before middle next out v guard nonzero iteration
      update rest ih1 ih2 ih3 =>
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
