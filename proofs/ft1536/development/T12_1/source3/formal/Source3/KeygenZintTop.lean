import Source3.KeygenZintCore

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The next grammar stratum keeps the checked CRT/Bezout closure intact.
   Division/remainder by the literal 31 and a same-width pun in return
   position are source statements, not assumed extraction postconditions. -/
namespace FT1536.Source3.KeygenZintTop
open C99ArrayReference (State Name Param Arg bindValue)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open B20.C (Token)

/- The same rejecting word/member lexer, extended with `/` and `%`.
   Comment recognition precedes the division token. No macro directive or
   other unknown character is removed by this stratum. -/
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
        if ['(',')','{','}','[',']',';',',','^','&','|','-','+','*','~','=','!',
            '<','>','.','?',':','/','%'].contains c then
          (tokenize fuel cs).map ([c]::·)
        else none
def tokens (text : List Char) : Option (List Token) :=
  (tokenize (text.length+1) text).map C99ArrayParser.normalizeTypes

inductive Stmt where
  | core (code : KeygenZintCall.Stmt)
  | divide31 (dst src : Name) (remainder : Bool)
  | retBitcast (src : Name) (ty : Ty)
  | seq (first second : Stmt)
  deriving DecidableEq, Repr
def skip : Stmt := .core KeygenZintCall.skip
def chain : List Stmt → Stmt
  | [] => skip
  | a::rest => .seq a (chain rest)

/- With a uint32 lhs and int literal 31, usual arithmetic conversion is
   uint32. Both unsigned operations are defined for every input word. -/
def divided31 (word : BitVec 32) (remainder : Bool) : Value :=
  .uint32 (BitVec.ofNat 32 (if remainder then word.toNat%31 else word.toNat/31))
theorem division_type : C99IntegerReference.usual .uint32 .int32=.uint32 := by decide
theorem divisor_nonzero : (31 : Nat)≠0 := by decide

inductive Exec : Stmt → State → Result → Prop where
  | core (code : KeygenZintCall.Stmt) (before : State) (out : Result)
      (source : KeygenZintCall.Exec code before out) : Exec (.core code) before out
  | divide31 (dst src : Name) (remainder : Bool) (before : State)
      (old : Option Value) (word : BitVec 32)
      (declared : before.locals dst=some (.uint32,old))
      (read : before.locals src=some (.uint32,some (.uint32 word))) :
      Exec (.divide31 dst src remainder) before
        ⟨bindValue before dst .uint32 (divided31 word remainder),.normal⟩
  | retBitcast (src : Name) (ty : Ty) (before : State) (held : Ty) (v w : Value)
      (read : before.locals src=some (held,some v))
      (view : KeygenZintCall.reinterpret ty v=some w) :
      Exec (.retBitcast src ty) before ⟨before,.returned (some w)⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (first : Exec a before ⟨middle,.normal⟩) (second : Exec b middle out) :
      Exec (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result)
      (first : Exec a before out) (exit : out.flow≠.normal) : Exec (.seq a b) before out

def statement (types : KeygenWordExpr.Types) (ptrs : List Name) :
    List Token → Option (Stmt×List Name×List Token)
  | dst::['=']::src::op::['3','1']::[';']::rest =>
    if op=['/'] then some (.divide31 dst src false,ptrs,rest) else
    if op=['%'] then some (.divide31 dst src true,ptrs,rest) else do
      let (code,ptrs,rest) ← KeygenZintCall.parseStatement types ptrs 256
        (dst::['=']::src::op::['3','1']::[';']::rest)
      pure (.core code,ptrs,rest)
  | ['r','e','t','u','r','n']::['*']::['(']::ty::['*']::[')']::['&']::src::[';']::rest => do
    let base ← KeygenWordExpr.typeToken ty
    pure (.retBitcast src (C99ValueBridge.type base),ptrs,rest)
  | rest => do
    let (code,ptrs,rest) ← KeygenZintCall.parseStatement types ptrs 256 rest
    pure (.core code,ptrs,rest)
def body (types : KeygenWordExpr.Types) (ptrs : List Name) :
    Nat → List Token → Option (Stmt×List Name×List Token)
  | 0,_ => none
  | _+1,['}']::rest => some (skip,ptrs,rest)
  | fuel+1,rest => do
    let (first,next,rest) ← statement types ptrs rest
    let (tail,final,rest) ← body types next fuel rest
    pure (.seq first tail,final,rest)
def region (types : KeygenWordExpr.Types) (ptrs : List Name) (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← tokens text
  let (code,_,rest) ← body types ptrs 512 lexed
  if rest.isEmpty then pure code else none

def only (names : List Name) : Stmt → Bool
  | .core code => KeygenZintCall.only names code
  | .divide31 _ _ _ | .retBitcast _ _ => true
  | .seq a b => only names a && only names b
theorem frame (code : Stmt) (before : State) (out : Result) (source : Exec code before out)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | core code before out source =>
    exact KeygenZintCall.body_frame KeygenZintCore.code_checked code before out source
      names checked block offset outside tables
  | divide31 | retBitcast => exact ⟨outside,rfl,rfl⟩
  | seqNormal a b before middle out first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    have tm : C99PointerFootprint.TablesOutside middle block offset := by
      simpa only [C99PointerFootprint.TablesOutside,ta] using tables
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa tm
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out first exit ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables

def params : List Param := [.pointer "x".toList,.scalar .uint64 "xlen".toList,
  .scalar .uint32 "sc".toList]
def widths : KeygenWordExpr.Types := [("x".toList,4)]
def parsed : Nat → Option Stmt
  | 0 => region widths [] 4272 13
  | 1 => region widths [] 4285 1
  | 2 => region widths [] 4286 26
  | 3 => region widths [] 4312 8
  | _ => none
def part (index : Nat) : Stmt := (parsed index).getD skip
def code : Stmt := chain [part 0,part 1,part 2,part 3]
def lines := KeygenLevelNtt.region
theorem header : lines 4269 3 = ["static int64_t\n",
    "zint_get_top(const uint32_t *x, size_t xlen, uint32_t sc)\n","{\n"] := by decide
theorem close : Pinned.keygenLines[4319]?=some "}\n" := by decide
theorem partition : lines 4272 48=lines 4272 13 ++ lines 4285 1 ++
    lines 4286 26 ++ lines 4312 8 := by decide
def audit (index : Nat) : Option Bool := (parsed index).map (only [])
theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem audit3 : audit 3=some true := by decide
theorem division_source : parsed 1=some (.seq (.divide31 "k".toList "sc".toList false) skip) := by decide
theorem return_source : parsed 3=some (.seq (.retBitcast "z".toList .int64) skip) := by decide
theorem parsed_part (index : Nat) (h : audit index=some true) : parsed index=some (part index) := by
  cases hp : parsed index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some code => simp only [part,hp,Option.getD_some]
theorem part_checked (index : Nat) (h : audit index=some true) : only [] (part index)=true := by
  have parsed := parsed_part index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem only_skip (names : List Name) : only names skip=true := rfl
theorem code_checked : only [] code=true := by
  show only [] (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) skip))))=true
  rw [only_seq,only_seq,only_seq,only_seq,only_skip,
    part_checked 0 audit0,part_checked 1 audit1,part_checked 2 audit2,part_checked 3 audit3]
  decide

def Call (before : State) (args : List Arg) (after : State) (v : Value) : Prop :=
  ∃ entry out, C99ArrayReference.Bind before params args entry ∧ Exec code entry out ∧
    C99ProcedureReference.ReturnValue (some .int64) out.flow (some v) ∧
    after={before with heap := out.state.heap}
theorem bind_tables (before entry : State) (ps : List Param) (args : List Arg)
    (binding : C99ArrayReference.Bind before ps args entry) : entry.tables=before.tables := by
  induction binding with
  | nil => rfl
  | scalar _ _ _ _ _ _ _ _ _ ih => exact ih
  | pointer _ _ _ _ _ _ _ _ _ ih => exact ih
theorem call_frame (before after : State) (args : List Arg) (v : Value)
    (source : Call before args after v) (block offset : Nat)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,out,binding,execution,returned,equal⟩ := source
  subst after
  have ht := bind_tables before entry params args binding
  have ho : C99ArrayFrame.Outside entry [] block offset := by intro n hn; cases hn
  have tm : C99PointerFootprint.TablesOutside entry block offset := by
    simpa only [C99PointerFootprint.TablesOutside,ht] using tables
  have keep := (frame code entry out execution [] code_checked block offset ho tm).2.2
  rw [C99ArrayReference.bind_heap before params args entry binding] at keep
  exact keep

end FT1536.Source3.KeygenZintTop
