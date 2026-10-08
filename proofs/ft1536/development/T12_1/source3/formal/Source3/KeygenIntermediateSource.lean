import Source3.KeygenIntermediateReduce
import Source3.KeygenIntermediateTokensTop0
import Source3.KeygenIntermediateTokensTop1
import Source3.KeygenIntermediateTokensTop2
import Source3.KeygenIntermediateTokensTop3
import Source3.KeygenIntermediateTokensTop4
import Source3.KeygenIntermediateTokensTop5
import Source3.KeygenIntermediateTokensTop6
import Source3.KeygenIntermediateTokensTop7
import Source3.KeygenMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete intermediate source, statement-boundary pieces on one shared
   state. Source coverage and fixed callee execution are operational; the
   final NTRU validation, rather than Babai arithmetic, supplies the equation. -/
namespace FT1536.Source3.KeygenIntermediateSource
open KeygenIntermediateExec (Stmt Exec chain only)
open C99ArrayReference (State Name Param Arg)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open C99MemoryReference

def writable : List Name := KeygenIntermediateLift.writable
def parsed : Nat → Option Stmt
  | 0 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop0.tokens
  | 1 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop1.tokens
  | 2 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop2.tokens
  | 3 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop3.tokens
  | 4 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop4.tokens
  | 5 => some KeygenIntermediateLift.code
  | 6 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop5.tokens
  | 7 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop6.tokens
  | 8 => some KeygenIntermediateReduce.code
  | 9 => KeygenIntermediateParser.ofTokens KeygenIntermediateTokensTop7.tokens
  | _ => none
def part (index : Nat) : Stmt := (parsed index).getD .skip
def code : Stmt := chain [part 0,part 1,part 2,part 3,part 4,part 5,part 6,part 7,part 8,part 9]
def audit (index : Nat) : Option Bool := (parsed index).map (fun code =>
  only writable code && KeygenIntermediateCoverage.statement code)
def lines := KeygenLevelNtt.region
theorem header : lines 5801 4=["static int\n","solve_NTRU_intermediate(falcon_keygen *fk,\n",
    "\tconst int16_t *f, const int16_t *g, unsigned depth)\n","{\n"] := by decide
theorem close : Pinned.keygenLines[6389]?=some "}\n" := by decide
theorem partition : lines 5805 585=lines 5805 19 ++ lines 5824 14 ++ lines 5838 23 ++ lines 5861 37 ++
    lines 5898 18 ++ lines 5916 203 ++ lines 6119 80 ++ lines 6199 22 ++ lines 6221 133 ++ lines 6354 36 := by
  have generic (xs : List String) : xs.take (19+(14+(23+(37+(18+(203+(80+(22+(133+36)))))))))=
      xs.take 19 ++ (xs.drop 19).take 14 ++ (xs.drop 33).take 23 ++ (xs.drop 56).take 37 ++
      (xs.drop 93).take 18 ++ (xs.drop 111).take 203 ++ (xs.drop 314).take 80 ++
      (xs.drop 394).take 22 ++ (xs.drop 416).take 133 ++ (xs.drop 549).take 36 := by
    simp only [List.take_add,List.drop_drop,List.append_assoc]
  simpa only [lines,KeygenLevelNtt.region,List.drop_drop] using generic (Pinned.keygenLines.drop 5804)
theorem audit0 : audit 0=some true := by decide +kernel
theorem audit1 : audit 1=some true := by decide +kernel
theorem audit2 : audit 2=some true := by decide +kernel
theorem audit3 : audit 3=some true := by decide +kernel
theorem audit4 : audit 4=some true := by decide +kernel
theorem audit5 : audit 5=some true := by
  change some (only KeygenIntermediateLift.writable KeygenIntermediateLift.code &&
    KeygenIntermediateCoverage.statement KeygenIntermediateLift.code)=some true
  rw [KeygenIntermediateLift.code_checked,KeygenIntermediateLift.code_covered]
  rfl
theorem audit6 : audit 6=some true := by decide +kernel
theorem audit7 : audit 7=some true := by decide +kernel
theorem audit8 : audit 8=some true := by
  change some (only KeygenIntermediateReduce.writable KeygenIntermediateReduce.code &&
    KeygenIntermediateCoverage.statement KeygenIntermediateReduce.code)=some true
  rw [KeygenIntermediateReduce.code_checked,KeygenIntermediateReduce.code_covered]
  rfl
theorem audit9 : audit 9=some true := by decide +kernel
theorem parsed_part (index : Nat) (h : audit index=some true) : parsed index=some (part index) := by
  cases hp : parsed index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (index : Nat) (h : audit index=some true) : only writable (part index)=true := by
  have parsed := parsed_part index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact (Bool.and_eq_true_iff.mp h).1
theorem part_covered (index : Nat) (h : audit index=some true) :
    KeygenIntermediateCoverage.statement (part index)=true := by
  have parsed := parsed_part index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact (Bool.and_eq_true_iff.mp h).2
theorem only_seq (names : List Name) (a b : Stmt) : only names (.seq a b)=(only names a && only names b) := rfl
theorem code_checked : only writable code=true := by
  show only writable (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) (.seq (part 4)
    (.seq (part 5) (.seq (part 6) (.seq (part 7) (.seq (part 8) (.seq (part 9) .skip))))))))))=true
  rw [only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,
    part_checked 0 audit0,part_checked 1 audit1,part_checked 2 audit2,part_checked 3 audit3,
    part_checked 4 audit4,part_checked 5 audit5,part_checked 6 audit6,part_checked 7 audit7,
    part_checked 8 audit8,part_checked 9 audit9]
  rfl
theorem code_covered : KeygenIntermediateCoverage.statement code=true := by
  show KeygenIntermediateCoverage.statement (.seq (part 0) (.seq (part 1) (.seq (part 2) (.seq (part 3) (.seq (part 4)
    (.seq (part 5) (.seq (part 6) (.seq (part 7) (.seq (part 8) (.seq (part 9) .skip))))))))))=true
  rw [KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,
    KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,
    KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,KeygenIntermediateCoverage.sequence,
    KeygenIntermediateCoverage.sequence,part_covered 0 audit0,part_covered 1 audit1,part_covered 2 audit2,
    part_covered 3 audit3,part_covered 4 audit4,part_covered 5 audit5,part_covered 6 audit6,
    part_covered 7 audit7,part_covered 8 audit8,part_covered 9 audit9]
  rfl
def params : List Param := [.pointer "fk".toList,.pointer "f".toList,.pointer "g".toList,.scalar .uint32 "depth".toList]
def arguments : List Arg := [.pointer "fk".toList C99ProcedureParser.zero,.pointer "f".toList C99ProcedureParser.zero,
  .pointer "g".toList C99ProcedureParser.zero,.scalar (.var "depth".toList)]
inductive Call (ctx : Context) (before : State) : State → Value → Prop where
  | run (entry : State) (out : Result) (v : Value)
      (binding : C99ArrayReference.Bind before params arguments entry) (source : Exec ctx code entry out)
      (returned : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) :
      Call ctx before {before with heap := out.state.heap} v
def Protected (ctx : Context) (s : State) (block : Nat) : Prop :=
  ctx.scratch.block≠block ∧ ∀ name p, s.tables name=some p → p.block≠block
theorem arguments_readonly : C99PointerFootprint.arguments [] writable params arguments=true := by decide
theorem entry_blocks (before entry : State) (source : C99ArrayReference.Bind before params arguments entry)
    (block : Nat) (tables : KeygenZintScaled.TableBlocks before block) :
    KeygenIntermediateMemory.Blocks entry writable block ∧ entry.tables=before.tables := by
  have generic : ∀ ps args entry, C99ArrayReference.Bind before ps args entry →
      C99PointerFootprint.arguments [] writable ps args=true →
      KeygenIntermediateMemory.Blocks entry writable block ∧ entry.tables=before.tables := by
    intro ps args entry binding allowed
    induction binding with
    | nil => exact ⟨fun n _ p hp => tables n p hp,rfl⟩
    | scalar ty name e ps args out v value rest ih => exact ih allowed
    | pointer name src index p ps args out value rest ih =>
      obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp allowed
      obtain ⟨ho,ht⟩ := ih hr
      refine ⟨?_,ht⟩
      intro n hn q hq
      by_cases he : n=name
      · subst n
        have notmem : name∉writable := by simpa using hc
        exact (notmem hn).elim
      · exact ho n hn q (by simpa [C99ArrayReference.bindPointer,he] using hq)
  exact generic params arguments entry source arguments_readonly
theorem call_frame (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v)
    (block : Nat) (separated : Protected ctx before block) :
    ∀ offset, after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out v binding execution returned =>
    intro offset
    obtain ⟨ho,ht⟩ := entry_blocks before entry binding block (fun name p hp => Ne.symm (separated.2 name p hp))
    have keep := (KeygenIntermediateExec.frame ctx code entry out execution writable code_checked block offset ho
      (fun name p hp => Ne.symm (separated.2 name p (by simpa only [ht] using hp))) (Ne.symm separated.1)).2.2
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

end FT1536.Source3.KeygenIntermediateSource
