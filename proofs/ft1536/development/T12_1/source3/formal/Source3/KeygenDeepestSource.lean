import Source3.KeygenMakeFgSource
import Source3.KeygenSearchContext
import Source3.KeygenMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete deepest search call. Context members are read from their actual
   LP64 object bytes; the make_fg ternary argument is value-bound from that
   read. Both rejection gates execute the fixed bigint bodies and retain
   short-circuit order. No GCD/NTRU/termination conclusion is assumed. -/
namespace FT1536.Source3.KeygenDeepestSource
open C99ArrayReference (State Name Param Arg bindValue bindPointer)
open C99MemoryReference
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open B20.C (Token)

def writable : List Name := ["Fp","Gp","fp","gp","t1","primes","PRIMES2","PRIMES3"].map String.toList
def ptrs : List Name := writable++["fk","f","g"].map String.toList
/- All ordinary arguments retain their C positions. The omitted fifth
   parameter is bound separately to the evaluated fk->ternary word. -/
def makeParams : List Param := (KeygenMakeFgSource.params .make).take 4++(KeygenMakeFgSource.params .make).drop 5
def makeArgs : List Arg := [.pointer "fp".toList C99ProcedureParser.zero,
  .pointer "f".toList C99ProcedureParser.zero,.pointer "g".toList C99ProcedureParser.zero,
  .scalar (.var "logn".toList),.scalar (.var "logn".toList),.scalar (.literal .i32 0)]
def makeTokens : List Token := ["make_fg","(","fp",",","f",",","g",",","logn",",",
  "fk","-",">","ternary",",","logn",",","0",")",";"].map String.toList
inductive Stmt where
  | base (code : KeygenMakeFgSource.Stmt)
  | logn (dst : Name)
  | tmp (dst : Name)
  | ternary (yes no : Stmt)
  | make
  | seq (first second : Stmt)
  deriving DecidableEq, Repr
def skip : Stmt := .base KeygenMakeFgSource.skip
def chain : List Stmt → Stmt
  | [] => skip
  | a::rest => .seq a (chain rest)
def assignQ (n : Nat) : Stmt := .base (.word (.assign "q".toList (.scalar (.literal .i32 n))))
def zintGuard (kind : KeygenZintCall.Callee) (args : List Arg) (test : CLogic.Cmp)
    (yes : KeygenZintCall.Stmt) : Stmt :=
  .base (.zint (.callBranch kind args test (.literal .i32 0) yes KeygenZintCall.skip))
def special : List Token → Option (Stmt×List Token)
  | dst::['=']::['f','k']::['-']::['>']::['l','o','g','n']::[';']::rest => some (.logn dst,rest)
  | dst::['=']::['f','k']::['-']::['>']::['t','m','p']::[';']::rest => some (.tmp dst,rest)
  | ['q']::['=']::['f','k']::['-']::['>']::['t','e','r','n','a','r','y']::['?']::
      ['1','8','4','3','3']::[':']::['1','2','2','8','9']::[';']::rest =>
    some (.ternary (assignQ 18433) (assignQ 12289),rest)
  | ['i','f']::['(']::['f','k']::['-']::['>']::['t','e','r','n','a','r','y']::[')']::rest => do
    let (yes,_,rest) ← KeygenMakeFgSource.statement ptrs 256 rest
    match rest with
    | ['e','l','s','e']::rest => do
      let (no,_,rest) ← KeygenMakeFgSource.statement ptrs 256 rest
      pure (.ternary (.base yes) (.base no),rest)
    | _ => none
  | ['i','f']::['(']::['!']::callee::['(']::rest => do
    let kind ← KeygenZintCall.calleeOf callee
    let (args,rest) ← C99ProcedureParser.arguments (KeygenZintCall.params kind) rest
    match rest with
    | [')']::rest => do
      let (yes,_,rest) ← KeygenZintCall.parseStatement KeygenMakeFgSource.widths ptrs 256 rest
      pure (zintGuard kind args .eq yes,rest)
    | _ => none
  | ['i','f']::['(']::callee::['(']::rest => do
    let kind ← KeygenZintCall.calleeOf callee
    let (args,rest) ← C99ProcedureParser.arguments (KeygenZintCall.params kind) rest
    match rest with
    | ['!','=']::['0']::['|','|']::callee2::['(']::rest => do
      let kind2 ← KeygenZintCall.calleeOf callee2
      let (args2,rest) ← C99ProcedureParser.arguments (KeygenZintCall.params kind2) rest
      match rest with
      | ['!','=']::['0']::[')']::rest => do
        let (yes,_,rest) ← KeygenZintCall.parseStatement KeygenMakeFgSource.widths ptrs 256 rest
        pure (.seq (zintGuard kind args .ne yes) (zintGuard kind2 args2 .ne yes),rest)
      | _ => none
    | _ => none
  | _ => none
def statement (ts : List Token) : Option (Stmt×List Token) :=
  if ts.take makeTokens.length=makeTokens then some (.make,ts.drop makeTokens.length) else
  match special ts with
  | some code => some code
  | none => do
    let (code,_,rest) ← KeygenMakeFgSource.statement ptrs 256 ts
    pure (.base code,rest)
def body : Nat → List Token → Option (Stmt×List Token)
  | 0,_ => none
  | _+1,['}']::rest => some (skip,rest)
  | fuel+1,rest => do
    let (head,rest) ← statement rest
    let (tail,rest) ← body fuel rest
    pure (.seq head tail,rest)
def region (start count : Nat) : Option Stmt := do
  let text := ((Pinned.keygenLines.drop (start-1)).take count).flatMap String.toList++['}']
  let lexed ← KeygenZintCall.tokens text
  let (code,rest) ← body 256 lexed
  if rest.isEmpty then pure code else none
def parsed : Nat → Option Stmt
  | 0 => region 5744 5
  | 1 => region 5749 9
  | 2 => region 5758 7
  | 3 => region 5765 15
  | 4 => region 5780 12
  | _ => none
def part (index : Nat) : Stmt := (parsed index).getD skip
def code : Stmt := chain [part 0,part 1,part 2,part 3,part 4]
def only (names : List Name) : Stmt → Bool
  | .base body => KeygenMakeFgSource.only names body
  | .logn _ | .tmp _ => true
  | .ternary a b | .seq a b => only names a && only names b
  | .make => C99PointerFootprint.arguments names KeygenMakeFgSource.writable makeParams makeArgs
def counts : Stmt → Nat×Nat×Nat×Nat
  | .base (.zint body) => KeygenZintCall.callShape body
  | .logn _ | .tmp _ => (0,0,1,0)
  | .ternary a b =>
    let x := counts a
    let y := counts b
    (x.1+y.1,x.2.1+y.2.1,1+x.2.2.1+y.2.2.1,x.2.2.2+y.2.2.2)
  | .seq a b =>
    let x := counts a
    let y := counts b
    (x.1+y.1,x.2.1+y.2.1,x.2.2.1+y.2.2.1,x.2.2.2+y.2.2.2)
  | .make => (0,0,1,1)
  | _ => (0,0,0,0)
def lines := KeygenLevelNtt.region
theorem header : lines 5741 3=["static int\n",
    "solve_NTRU_deepest(falcon_keygen *fk, const int16_t *f, const int16_t *g)\n","{\n"] := by decide
theorem close : Pinned.keygenLines[5791]?=some "}\n" := by decide
theorem partition : lines 5744 48=lines 5744 5 ++ lines 5749 9 ++ lines 5758 7 ++ lines 5765 15 ++ lines 5780 12 := by decide
theorem make_parameter_field : KeygenMakeFgSource.params .make=makeParams.take 4++
    [.scalar .uint32 "ter".toList]++makeParams.drop 4 := by decide
def audit (index : Nat) : Option Bool := (parsed index).map (only writable)
theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem audit3 : audit 3=some true := by decide
theorem audit4 : audit 4=some true := by decide
theorem members1 : (parsed 1).map counts=some (0,0,2,0) := by decide
theorem members_make2 : (parsed 2).map counts=some (0,0,2,1) := by decide
theorem crt_bezout3 : (parsed 3).map counts=some (1,1,0,0) := by decide
theorem q_multiply4 : (parsed 4).map counts=some (0,2,1,0) := by decide
theorem parsed_part (index : Nat) (h : audit index=some true) : parsed index=some (part index) := by
  cases hp : parsed index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (index : Nat) (h : audit index=some true) : only writable (part index)=true := by
  have parsed := parsed_part index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem only_skip (names : List Name) : only names skip=true := rfl
theorem code_checked : only writable code=true := by
  show only writable (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) (.seq (part 4) skip)))))=true
  rw [only_seq,only_seq,only_seq,only_seq,only_seq,only_skip,
    part_checked 0 audit0,part_checked 1 audit1,part_checked 2 audit2,part_checked 3 audit3,part_checked 4 audit4]
  decide

inductive Exec (ctx : Context) : Stmt → State → Result → Prop where
  | base (code : KeygenMakeFgSource.Stmt) (before : State) (out : Result)
      (source : KeygenMakeFgSource.Exec code before out) : Exec ctx (.base code) before out
  | logn (dst : Name) (before : State) (ty : Ty) (old : Option Value) (word : BitVec 32)
      (declared : before.locals dst=some (ty,old)) (read : KeygenSearchContext.ReadLogn ctx before word) :
      Exec ctx (.logn dst) before ⟨bindValue before dst ty (.uint32 word),.normal⟩
  | tmp (dst : Name) (before : State) (p : ArrayPointer) (read : KeygenSearchContext.ReadTmp ctx before p) :
      Exec ctx (.tmp dst) before ⟨bindPointer before dst p,.normal⟩
  | ternaryTrue (yes no : Stmt) (before : State) (out : Result) (word : BitVec 32)
      (read : KeygenSearchContext.ReadTernary ctx before word) (nonzero : word.toNat≠0)
      (source : Exec ctx yes before out) : Exec ctx (.ternary yes no) before out
  | ternaryFalse (yes no : Stmt) (before : State) (out : Result) (word : BitVec 32)
      (read : KeygenSearchContext.ReadTernary ctx before word) (zero : word.toNat=0)
      (source : Exec ctx no before out) : Exec ctx (.ternary yes no) before out
  | make (before entry : State) (out : Result) (word : BitVec 32)
      (binding : C99ArrayReference.Bind before makeParams makeArgs entry)
      (read : KeygenSearchContext.ReadTernary ctx before word)
      (source : KeygenMakeFgSource.Exec (KeygenMakeFgSource.code .make)
        (bindValue entry "ter".toList .uint32 (.uint32 word)) out)
      (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Exec ctx .make before ⟨{before with heap := out.state.heap},.normal⟩
  | seqNormal (a b : Stmt) (before middle : State) (out : Result)
      (first : Exec ctx a before ⟨middle,.normal⟩) (second : Exec ctx b middle out) : Exec ctx (.seq a b) before out
  | seqExit (a b : Stmt) (before : State) (out : Result)
      (first : Exec ctx a before out) (exit : out.flow≠.normal) : Exec ctx (.seq a b) before out
theorem frame (ctx : Context) (code : Stmt) (before : State) (out : Result) (source : Exec ctx code before out)
    (names : List Name) (checked : only names code=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset)
    (scratch : C99PointerFootprint.PointOutside ctx.scratch block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | base code before out source => exact KeygenMakeFgSource.frame code before out source names checked block offset outside tables
  | logn => exact ⟨outside,rfl,rfl⟩
  | tmp dst before p read =>
    have hp := KeygenSearchContext.tmp_value ctx before p read
    subst p
    refine ⟨?_,rfl,rfl⟩
    intro n hn q hq
    by_cases he : n=dst
    · have hpq : ctx.scratch=q := Option.some.inj (by simpa [bindPointer,he] using hq)
      subst q
      exact scratch
    · exact outside n hn q (by simpa [bindPointer,he] using hq)
  | ternaryTrue yes no before out word read nonzero source ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | ternaryFalse yes no before out word read zero source ih => exact ih (Bool.and_eq_true_iff.mp checked).2 outside tables
  | make before entry out word binding read source returned =>
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before makeParams makeArgs entry binding names KeygenMakeFgSource.writable checked block offset outside tables
    have keep := (KeygenMakeFgSource.frame (KeygenMakeFgSource.code .make)
      (bindValue entry "ter".toList .uint32 (.uint32 word)) out source KeygenMakeFgSource.writable
      (KeygenMakeFgSource.code_checked .make) block offset ho
      (by simpa only [C99PointerFootprint.TablesOutside,bindValue,ht] using tables)).2.2
    change out.state.heap.bytes block offset=entry.heap.bytes block offset at keep
    rw [C99ArrayReference.bind_heap before makeParams makeArgs entry binding] at keep
    exact ⟨outside,rfl,keep⟩
  | seqNormal a b before middle out first second ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [C99PointerFootprint.TablesOutside,ta] using tables)
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out first exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables

def params : List Param := [.pointer "fk".toList,.pointer "f".toList,.pointer "g".toList]
def arguments : List Arg := ["fk","f","g"].map (fun name => .pointer name.toList C99ProcedureParser.zero)
inductive Call (ctx : Context) (before : State) : State → Value → Prop where
  | run (entry : State) (out : Result) (v : Value)
      (binding : C99ArrayReference.Bind before params arguments entry) (source : Exec ctx code entry out)
      (returned : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) :
      Call ctx before {before with heap := out.state.heap} v
def Protected (ctx : Context) (s : State) (block : Nat) : Prop :=
  ctx.scratch.block≠block ∧ ∀ name p, s.tables name=some p → p.block≠block
theorem arguments_readonly : C99PointerFootprint.arguments [] writable params arguments=true := by decide
theorem call_frame (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v)
    (block : Nat) (separated : Protected ctx before block) :
    ∀ offset, after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out v binding execution returned =>
    intro offset
    have tables : C99PointerFootprint.TablesOutside before block offset :=
      fun name p hp => Or.inl (Ne.symm (separated.2 name p hp))
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before params arguments entry binding [] writable arguments_readonly
      block offset (by intro n hn; cases hn) tables
    have keep := (frame ctx code entry out execution writable code_checked block offset ho
      (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables) (Or.inl (Ne.symm separated.1))).2.2
    rw [C99ArrayReference.bind_heap before params arguments entry binding] at keep
    exact keep
theorem slots (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases source
  exact ⟨rfl,rfl,rfl⟩
theorem material (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v)
    (input : ArrayPointer) (separated : Protected ctx before input.block) (vector : Geometry.Vec)
    (represented : KeygenMaterial.Represents before.heap input vector) :
    KeygenMaterial.Represents after.heap input vector := by
  have keep := call_frame ctx before after v source input.block separated
  intro i
  constructor
  · intro byte; exact (keep _).trans ((represented i).1 byte)
  · intro byte; exact (keep _).trans ((represented i).2 byte)

end FT1536.Source3.KeygenDeepestSource
