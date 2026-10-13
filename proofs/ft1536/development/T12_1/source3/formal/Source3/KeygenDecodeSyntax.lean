import Source3.KeygenMakePreprocess
import Source3.KeygenZintTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Decoder grammar copied from the pinned encoder parser without editing it.
   The only new numeric token is0x8000=32768; original tokens remain intact.
   Syntax only; no operational decoder claim. Codec fragment: both dispatch cases, while loops, unsigned
   numerals, compound assignments and pre/post increment/decrement remain
   explicit syntax. The pinned caller grammar is not changed. -/
namespace FT1536.Source3.KeygenDecodeSyntax
open B20.C (Token Name)

inductive Ty where
  | void | i32 | u32 | i16 | u16 | u64 | size | long | byte | fpr | context
  | readonly (element : Ty)
  | pointer (element : Ty)
  deriving DecidableEq, Repr
def typeToken : List Token → Option (Ty × List Token)
  | ['c','o','n','s','t']::rest => do
      let (ty,tail) ← typeToken rest
      pure (.readonly ty,tail)
  | ['u','n','s','i','g','n','e','d']::['c','h','a','r']::rest => some (.byte,rest)
  | token::rest =>
    let ty := if token="void".toList then some Ty.void
      else if token="int".toList then some .i32
      else if token="unsigned".toList then some .u32
      else if token="int16_t".toList then some .i16
      else if token="uint16_t".toList then some .u16
      else if token="uint64_t".toList then some .u64
      else if token="uint32_t".toList then some .u32
      else if token="size_t".toList then some .size
      else if token="long".toList then some .long
      else if token="fpr".toList then some .fpr
      else if token="falcon_keygen".toList then some .context else none
    ty.map (fun t => (t,rest))
  | _ => none
def pointerType (ty : Ty) : List Token → Ty × List Token
  | ['*']::rest => (.pointer ty,rest)
  | rest => (ty,rest)

/- Fixed codec call table; no arbitrary callback. -/
inductive Callee where
  | none | static
  deriving DecidableEq, Repr
def calleeName : Callee → Name
  | .none => "uncompress_none".toList | .static => "uncompress_static".toList
def allCallees : List Callee := [.none,.static]
def callee (name : Name) : Option Callee := allCallees.find? (fun k => calleeName k==name)
def arity (_ : Callee) : Nat := 5
inductive Op where
  | mul | div | rem | add | sub | shl | shr | lt | le | gt | ge | eq | ne
  | band | bxor | bor | land | lor
  deriving DecidableEq, Repr
def operator : Token → Option Op
  | ['*'] => some .mul | ['/'] => some .div | ['%'] => some .rem
  | ['+'] => some .add | ['-'] => some .sub | ['<','<'] => some .shl | ['>','>'] => some .shr
  | ['<'] => some .lt | ['<','='] => some .le | ['>'] => some .gt | ['>','='] => some .ge
  | ['=','='] => some .eq | ['!','='] => some .ne | ['&'] => some .band
  | ['^'] => some .bxor | ['|'] => some .bor | ['&','&'] => some .land | ['|','|'] => some .lor
  | _ => none
def precedence : Op → Nat
  | .lor => 1 | .land => 2 | .bor => 3 | .bxor => 4 | .band => 5
  | .eq | .ne => 6 | .lt | .le | .gt | .ge => 7 | .shl | .shr => 8
  | .add | .sub => 9 | .mul | .div | .rem => 10
inductive Unary where
  | neg | bitnot | logicalNot | dereference | address
  deriving DecidableEq, Repr
inductive Expr where
  | preInc (value : Expr) | postInc (value : Expr)
  | preDec (value : Expr) | postDec (value : Expr)
  | variable (name : Name)
  | number (ty : Ty) (value : Nat)
  | unary (op : Unary) (value : Expr)
  | cast (ty : Ty) (value : Expr)
  | binary (op : Op) (first second : Expr)
  | conditional (test yes no : Expr)
  | member (object : Expr) (name : Name)
  | index (object index : Expr)
  | call (destination : Callee) (arguments : Expr)
  | argsNil | argsCons (head tail : Expr)
  deriving DecidableEq, Repr
def argumentTree : List Expr → Expr
  | [] => .argsNil | head::tail => .argsCons head (argumentTree tail)
def word (token : Token) : Bool := !token.isEmpty && token.all B20.C.wordChar
def numeral (token : Token) : Option Expr := do
  if token="0x8000".toList then return .number .i32 32768
  let (ty,digits) := if token.getLast?=some 'U' then (Ty.u32,token.take (token.length-1)) else if token.getLast?=some 'L' then (Ty.long,token.take (token.length-1)) else (.i32,token)
  if digits.isEmpty || !(digits.all (fun c => '0'≤c && c≤'9')) then none else do
  match ← B20.C.Scalar.number digits with
  | .literal _ n => pure (.number ty n)
  | _ => none
def unaryToken : Token → Option Unary
  | ['-'] => some .neg | ['~'] => some .bitnot | ['!'] => some .logicalNot
  | ['*'] => some .dereference | ['&'] => some .address | _ => none
mutual
  def expression : Nat → Nat → List Token → Option (Expr × List Token)
    | 0,_,_ => none
    | fuel+1,minimum,ts => do
      let (head,rest) ← unary fuel ts
      more fuel minimum head rest
  def unary : Nat → List Token → Option (Expr × List Token)
    | 0,_ => none
    | fuel+1,['+','+']::rest => (unary fuel rest).map (fun (e,tail) => (.preInc e,tail))
    | fuel+1,['-']::['-']::rest => (unary fuel rest).map (fun (e,tail) => (.preDec e,tail))
    | fuel+1,['(']::rest =>
      match typeToken rest with
      | some (ty,tail) =>
        let (ty,tail) := pointerType ty tail
        match tail with
        | [')']::tail => do
          let (e,tail) ← unary fuel tail
          pure (.cast ty e,tail)
        | _ => none
      | none => do
        let (e,tail) ← expression fuel 0 rest
        match tail with | [')']::tail => suffix fuel e tail | _ => none
    | fuel+1,token::rest =>
      match unaryToken token with
      | some op => (unary fuel rest).map (fun (e,tail) => (.unary op e,tail))
      | none =>
        match numeral token with
        | some number => suffix fuel number rest
        | none => if word token then
          match rest with
          | ['(']::tail => do
            let destination ← callee token
            let (args,tail) ← arguments fuel tail
            if args.length=arity destination then suffix fuel (.call destination (argumentTree args)) tail else none
          | _ => suffix fuel (.variable token) rest
          else none
    | _+1,_ => none
  def suffix : Nat → Expr → List Token → Option (Expr × List Token)
    | 0,_,_ => none
    | fuel+1,e,['+','+']::rest => suffix fuel (.postInc e) rest
    | fuel+1,e,['-']::['-']::rest => suffix fuel (.postDec e) rest
    | fuel+1,e,['[']::rest => do
      let (index,tail) ← expression fuel 0 rest
      match tail with | [']']::tail => suffix fuel (.index e index) tail | _ => none
    | fuel+1,e,['-']::['>']::name::rest =>
      if word name then suffix fuel (.member e name) rest else none
    | _+1,e,rest => some (e,rest)
  def more : Nat → Nat → Expr → List Token → Option (Expr × List Token)
    | 0,_,_,_ => none
    | fuel+1,minimum,left,['?']::rest =>
      if minimum≠0 then some (left,['?']::rest) else do
      let (yes,tail) ← expression fuel 0 rest
      match tail with
      | [':']::tail => do
        let (no,tail) ← expression fuel 0 tail
        pure (.conditional left yes no,tail)
      | _ => none
    | fuel+1,minimum,left,token::rest =>
      match operator token with
      | some op => if precedence op<minimum then some (left,token::rest) else do
        let (right,tail) ← expression fuel (precedence op+1) rest
        more fuel minimum (.binary op left right) tail
      | none => some (left,token::rest)
    | _+1,_,left,[] => some (left,[])
  def arguments : Nat → List Token → Option (List Expr × List Token)
    | 0,_ => none
    | _+1,[')']::rest => some ([],rest)
    | fuel+1,ts => do
      let (e,tail) ← expression fuel 0 ts
      match tail with
      | [')']::tail => pure ([e],tail)
      | [',']::tail => do
        let (args,tail) ← arguments fuel tail
        pure (e::args,tail)
      | _ => none
end
structure Object where
  name : Name
  type : Ty
  count : Option Nat
  deriving DecidableEq, Repr
def declarators (ty : Ty) : Nat → List Token → Option (List Object × List Token)
  | 0,_ => none
  | fuel+1,ts => do
    let (element,ts) := pointerType ty ts
    match ts with
    | name::tail =>
      if !word name then none else do
      let (count,tail) ← match tail with
        | ['[']::size::[']']::tail => do
            let value ← numeral size
            match value with | .number .i32 n => pure (some n,tail) | _ => none
        | tail => some (none,tail)
      let object := Object.mk name element count
      match tail with
      | [',']::tail => do
        let (objects,tail) ← declarators ty fuel tail
        pure (object::objects,tail)
      | [';']::tail => pure ([object],tail)
      | _ => none
    | _ => none
inductive Assign where
  | set | add | sub | band | bor | shl
  deriving DecidableEq, Repr
inductive Stmt where
  | skip
  | declare (objects : List Object)
  | write (lvalue : Expr) (operation : Assign) (value : Expr)
  | increment (lvalue : Expr)
  | evaluate (value : Expr)
  | seq (first second : Stmt)
  | scope (body : Stmt)
  | branch (test : Expr) (yes no : Stmt)
  | whileLoop (test : Expr) (body : Stmt)
  | switch (test : Expr) (noneCase staticCase fallback : Stmt)
  | loop (initial : Stmt) (test : Option Expr) (increment body : Stmt)
  | ret (value : Expr)
  | breakLoop | continueLoop
  deriving DecidableEq, Repr
def lvalue : Expr → Bool
  | .variable _ | .index _ _ | .unary .dereference _ => true
  | _ => false
def assignOp : Token → Option Assign
  | ['='] => some .set | ['+','='] => some .add | ['-','='] => some .sub
  | ['&','='] => some .band | ['|','='] => some .bor | ['<','<','='] => some .shl
  | _ => none
def clause (ts : List Token) : Option (Stmt × List Token) := do
  let (e,tail) ← expression 24 0 ts
  match tail with
  | op::tail =>
    match assignOp op with
    | some operation => do
      if !lvalue e then none else do
      let (value,tail) ← expression 24 0 tail
      pure (.write e operation value,tail)
    | none => pure (.evaluate e,op::tail)
  | [] => pure (.evaluate e,[])
def endedClause (ending : Token) (ts : List Token) : Option (Stmt × List Token) :=
  if ts.head?=some ending then some (.skip,ts.drop 1) else do
  let (code,tail) ← clause ts
  match tail with | last::tail => if last=ending then some (code,tail) else none | _ => none
def simple (ts : List Token) : Option (Stmt × List Token) :=
  match typeToken ts with
  | some (ty,tail) => (declarators ty 16 tail).map (fun (objects,tail) => (.declare objects,tail))
  | none => match ts with
    | [';']::rest => pure (.skip,rest)
    | ['r','e','t','u','r','n']::rest => do
      let (e,tail) ← expression 24 0 rest
      match tail with | [';']::tail => pure (.ret e,tail) | _ => none
    | ['b','r','e','a','k']::[';']::rest => pure (.breakLoop,rest)
    | ['c','o','n','t','i','n','u','e']::[';']::rest => pure (.continueLoop,rest)
    | _ => endedClause [';'] ts
mutual
  def statement : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
      let (code,tail) ← body fuel rest
      pure (.scope code,tail)
    | fuel+1,['i','f']::['(']::rest => do
      let (condition,tail) ← expression 24 0 rest
      match tail with
      | [')']::tail => do
        let (yes,tail) ← statement fuel tail
        match tail with
        | ['e','l','s','e']::tail => do
          let (no,tail) ← statement fuel tail
          pure (.branch condition yes no,tail)
        | _ => pure (.branch condition yes .skip,tail)
      | _ => none
    | fuel+1,['w','h','i','l','e']::['(']::rest => do
      let (test,tail) ← expression 24 0 rest
      match tail with
      | [')']::tail => do
        let (inner,tail) ← statement fuel tail
        pure (.whileLoop test inner,tail)
      | _ => none
    | fuel+1,['f','o','r']::['(']::rest => do
      let (initial,tail) ← endedClause [';'] rest
      let (condition,tail) ← if tail.head?=some [';'] then some (none,tail.drop 1) else do
        let (e,tail) ← expression 24 0 tail
        match tail with | [';']::tail => pure (some e,tail) | _ => none
      let (increment,tail) ← endedClause [')'] tail
      let (inner,tail) ← statement fuel tail
      pure (.loop initial condition increment inner,tail)
    | _+1,ts => simple ts
  def body : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | _+1,['}']::rest => some (.skip,rest)
    | fuel+1,ts => do
      let (head,tail) ← statement fuel ts
      let (rest,tail) ← body fuel tail
      pure (.seq head rest,tail)
end
structure Header where
  name : Name
  parameters : List Object
  result : Ty
  deriving DecidableEq, Repr
def parameters : Nat → List Token → Option (List Object × List Token)
  | 0,_ => none
  | fuel+1,ts => do
    let (ty,tail) ← typeToken ts
    let (ty,tail) := pointerType ty tail
    match tail with
    | name::tail =>
      if !word name then none else do
      match tail with
      | [')']::tail => pure ([⟨name,ty,none⟩],tail)
      | [',']::tail => do
        let (ps,tail) ← parameters fuel tail
        pure (⟨name,ty,none⟩::ps,tail)
      | _ => none
    | _ => none
def headerCore (ts : List Token) : Option (Header × List Token) := do
  let (ty,tail) ← typeToken ts
  match tail with
  | name::['(']::tail => do
    let (ps,tail) ← parameters 16 tail
    match tail with | ['{']::tail => pure (⟨name,ps,ty⟩,tail) | _ => none
  | _ => none
def header (ts : List Token) : Option (Header × List Token) :=
  headerCore (if ts.head?=some "static".toList then ts.drop 1 else ts)
def parseTokens (ts : List Token) : Option (Header × Stmt) := do
  let (h,tail) ← header ts
  let (code,tail) ← body 512 tail
  if tail.isEmpty then pure (h,.scope code) else none
def expand (ts : List Token) : List Token := ts.map (fun token =>
  if token="FALCON_COMP_NONE".toList then ['0'] else
  if token="FALCON_COMP_STATIC".toList then ['1'] else token)
def tokens (text : List Char) : Option (List Token) :=
  (KeygenZintTop.tokenize (text.length+1) text).map expand

theorem hexadecimal_value : numeral "0x8000".toList=some (.number .i32 (8*16^3)) := by decide +kernel

end FT1536.Source3.KeygenDecodeSyntax
