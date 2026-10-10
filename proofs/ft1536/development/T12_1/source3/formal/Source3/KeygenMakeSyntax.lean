import Source3.KeygenMakePreprocess
import Source3.KeygenZintTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Rejecting whole-caller grammar. Unlike the earlier fragment parsers this
   keeps both runtime arms, call expressions, physical lvalues, pointer casts,
   the conditional operator and all enclosing declarations. This is SYNTAX,
   not an interpreter, a callee contract or a proof of accepted material. -/
namespace FT1536.Source3.KeygenMakeSyntax
open B20.C (Token Name)

inductive Ty where
  | void | i32 | u32 | i16 | u16 | u64 | size | long | byte | fpr | context
  | pointer (element : Ty)
  deriving DecidableEq, Repr
def typeToken : List Token → Option (Ty × List Token)
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

/- An enumerated destination, never an arbitrary name/callback. The binary
   functions remain in the syntax even though M0 later selects ternary1. -/
inductive Callee where
  | mkn | ready | sample | resultant | smallToFp | fft3 | fft
  | invnorm3 | invnorm | adj3 | adj | mulconst3 | mulconst | mulauto3 | mulauto
  | mkgauss | sqnorm | ifft | computePublic | solve | certificate
  | encodeSmall | encodeT | encodeB
  | of | sqrt | div | mul | add | sqr | double | lt
  deriving DecidableEq, Repr
def calleeName : Callee → Name
  | .mkn => "MKN".toList | .ready => "rng_ready".toList
  | .sample => "sample_true_ternary_secret".toList | .resultant => "mod2_res_ternary".toList
  | .smallToFp => "poly_small_to_fp".toList | .fft3 => "falcon_FFT3".toList | .fft => "falcon_FFT".toList
  | .invnorm3 => "falcon_poly_invnorm2_fft3".toList | .invnorm => "falcon_poly_invnorm2_fft".toList
  | .adj3 => "falcon_poly_adj_fft3".toList | .adj => "falcon_poly_adj_fft".toList
  | .mulconst3 => "falcon_poly_mulconst_fft3".toList | .mulconst => "falcon_poly_mulconst_fft".toList
  | .mulauto3 => "falcon_poly_mul_autoadj_fft3".toList | .mulauto => "falcon_poly_mul_autoadj_fft".toList
  | .mkgauss => "poly_small_mkgauss".toList | .sqnorm => "poly_small_sqnorm".toList
  | .ifft => "falcon_iFFT".toList | .computePublic => "falcon_compute_public".toList
  | .solve => "solve_NTRU".toList | .certificate => "ft_keygen_leaf_certificate".toList
  | .encodeSmall => "falcon_encode_small".toList | .encodeT => "falcon_encode_18433".toList
  | .encodeB => "falcon_encode_12289".toList
  | .of => "fpr_of".toList | .sqrt => "fpr_sqrt".toList | .div => "fpr_div".toList
  | .mul => "fpr_mul".toList | .add => "fpr_add".toList | .sqr => "fpr_sqr".toList
  | .double => "fpr_double".toList | .lt => "fpr_lt".toList
def allCallees : List Callee := [.mkn,.ready,.sample,.resultant,.smallToFp,.fft3,.fft,
  .invnorm3,.invnorm,.adj3,.adj,.mulconst3,.mulconst,.mulauto3,.mulauto,.mkgauss,.sqnorm,
  .ifft,.computePublic,.solve,.certificate,.encodeSmall,.encodeT,.encodeB,.of,.sqrt,.div,.mul,.add,.sqr,.double,.lt]
def callee (name : Name) : Option Callee := allCallees.find? (fun k => calleeName k==name)
def arity : Callee → Nat
  | .ready | .of | .sqrt | .sqr | .double => 1
  | .mkn | .resultant | .fft | .adj | .ifft | .div | .mul | .add | .lt => 2
  | .sample | .fft3 | .adj3 | .mulconst | .mulauto | .mkgauss | .sqnorm => 3
  | .smallToFp | .invnorm | .mulconst3 | .mulauto3 | .encodeT | .encodeB => 4
  | .invnorm3 | .computePublic | .solve => 5
  | .encodeSmall => 6
  | .certificate => 7
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
  let (ty,digits) := if token.getLast?=some 'L' then (Ty.long,token.take (token.length-1)) else (.i32,token)
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
  | set | add
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
  | loop (initial : Stmt) (test : Option Expr) (increment body : Stmt)
  | ret (value : Expr)
  | breakLoop | continueLoop
  deriving DecidableEq, Repr
def lvalue : Expr → Bool
  | .variable _ | .index _ _ | .unary .dereference _ => true
  | _ => false
def clause (ts : List Token) : Option (Stmt × List Token) := do
  let (e,tail) ← expression 24 0 ts
  match tail with
  | op::tail =>
    if op=['='] || op=['+','='] then do
      if !lvalue e then none else do
      let (value,tail) ← expression 24 0 tail
      pure (.write e (if op=['+','='] then .add else .set) value,tail)
    else if op=['+','+'] then if lvalue e then some (.increment e,tail) else none
    else pure (.evaluate e,op::tail)
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
def header (ts : List Token) : Option (Header × List Token) := do
  let (ty,tail) ← typeToken ts
  match tail with
  | name::['(']::tail => do
    let (ps,tail) ← parameters 16 tail
    match tail with | ['{']::tail => pure (⟨name,ps,ty⟩,tail) | _ => none
  | _ => none
def parseTokens (ts : List Token) : Option (Header × Stmt) := do
  let (h,tail) ← header ts
  let (code,tail) ← body 512 tail
  if tail.isEmpty then pure (h,.scope code) else none
def expand (ts : List Token) : List Token := ts.map (fun token =>
  match KeygenM0Preprocess.lookup token with | some n => (toString n).toList | none => token)
def tokens (text : List Char) : Option (List Token) := (KeygenZintTop.tokenize (text.length+1) text).map expand
def parse (text : List Char) : Option (Header × Stmt) := (tokens text).bind parseTokens
def source : Option (Header × Stmt) := parse (KeygenMakePreprocess.output.flatMap String.toList)
def expectedHeader : Header := ⟨"falcon_keygen_make".toList,
  [⟨"fk".toList,.pointer .context,none⟩,⟨"comp".toList,.i32,none⟩,
   ⟨"privkey".toList,.pointer .void,none⟩,⟨"privkey_len".toList,.pointer .size,none⟩,
   ⟨"pubkey".toList,.pointer .void,none⟩,⟨"pubkey_len".toList,.pointer .size,none⟩],.i32⟩

end FT1536.Source3.KeygenMakeSyntax
