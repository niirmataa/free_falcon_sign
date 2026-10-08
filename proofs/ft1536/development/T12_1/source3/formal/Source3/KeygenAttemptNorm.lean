import Source3.KeygenAttemptFft

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete active raw-bound initialization and GS computation/gate. The
   comparisons execute the existing object-copy fpr_lt source. No real FFT
   norm, gate acceptance, or material frame is assumed. -/
namespace FT1536.Source3.KeygenAttemptNorm
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSearchExec (Stmt)
open KeygenMemoryStability (Stable)

def types : KeygenSearchParser.Types := [("f".toList,2),("g".toList,2),
  ("rt1".toList,8),("rt2".toList,8),("rt3".toList,8)]
def writable : List Name := ["rt1".toList,"rt2".toList,"rt3".toList]
/- The inherited literal parser lacks the signed L suffix. This exact LP64
   literal is lowered to a signed-long cast, never to an unsigned token. -/
def expand (tokens : List B20.C.Token) : List B20.C.Token := tokens.flatMap (fun token =>
  if token="73732L".toList then ["(","long",")","73732"].map String.toList else
  [match KeygenM0Preprocess.lookup token with | some value => (toString value).toList | none => token])
theorem signed_long_literal : C99IntegerReference.convert .int64 (C99IntegerReference.Value.int32 73732).integer=
    .int64 73732 := by decide
def parse (lines : List String) : Option Stmt := do
  let tokens ← C99ProcedureParser.tokens (lines.flatMap String.toList++['}'])
  let (code,_,rest) ← KeygenSearchParser.body types 256 (expand tokens)
  if rest.isEmpty then pure code else none
def boundLines : List String := (Pinned.keygenLines.drop 7957).take 2++(Pinned.keygenLines.drop 7960).take 3
def gsHeadLines : List String := (Pinned.keygenLines.drop 7994).take 3
def gsTailLines : List String := (Pinned.keygenLines.drop 7999).take 8
def boundParsed : Option Stmt := parse boundLines
def headParsed : Option Stmt := parse gsHeadLines
def tailParsed : Option Stmt := parse gsTailLines
def boundCode : Stmt := boundParsed.getD KeygenSearchExec.skip
def headCode : Stmt := headParsed.getD KeygenSearchExec.skip
def tailCode : Stmt := tailParsed.getD KeygenSearchExec.skip
theorem bound_selection : KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 7957).take 10)=some boundLines := by decide
theorem bound_audit : boundParsed.map (KeygenSearchFrame.only writable)=some true := by decide
theorem head_audit : headParsed.map (KeygenSearchFrame.only writable)=some true := by decide
theorem tail_audit : tailParsed.map (KeygenSearchFrame.only writable)=some true := by decide
theorem parsed_checked (parsed : Option Stmt) (audit : parsed.map (KeygenSearchFrame.only writable)=some true) :
    parsed=some (parsed.getD KeygenSearchExec.skip) ∧
    KeygenSearchFrame.only writable (parsed.getD KeygenSearchExec.skip)=true := by
  cases parsed with
  | none => cases audit
  | some code => exact ⟨rfl,Option.some.inj audit⟩
theorem bound_checked : KeygenSearchFrame.only writable boundCode=true := (parsed_checked _ bound_audit).2
theorem head_checked : KeygenSearchFrame.only writable headCode=true := (parsed_checked _ head_audit).2
theorem tail_checked : KeygenSearchFrame.only writable tailCode=true := (parsed_checked _ tail_audit).2
def scaleSignatures (name : Name) : Option (List C99ArrayReference.Param×Option C99IntegerReference.Ty) :=
  if name="falcon_poly_mulconst_fft3".toList then some (KeygenAttemptFft.params,none) else none
def scaleParsed : Option C99ProcedureReference.Stmt := do
  let tokens ← C99ProcedureParser.tokens (((Pinned.keygenLines.drop 7997).take 2).flatMap String.toList++['}'])
  let (code,_,rest) ← C99ProcedureParser.body scaleSignatures ["rt1".toList,"rt2".toList] 32 tokens
  if rest.isEmpty then pure code else none
def scaleCode : C99ProcedureReference.Stmt := C99ProcedureParser.chain [
  .call "falcon_poly_mulconst_fft3".toList (KeygenAttemptFft.arguments "rt1") .discard,
  .call "falcon_poly_mulconst_fft3".toList (KeygenAttemptFft.arguments "rt2") .discard]
theorem scale_source : scaleParsed=some scaleCode := by decide
theorem scale_first_checked : C99PointerFootprint.arguments writable KeygenAttemptFft.writable
    KeygenAttemptFft.params (KeygenAttemptFft.arguments "rt1")=true := by decide
theorem scale_second_checked : C99PointerFootprint.arguments writable KeygenAttemptFft.writable
    KeygenAttemptFft.params (KeygenAttemptFft.arguments "rt2")=true := by decide
def gateLines : List String := ["\n","\t\t\tif (!fpr_lt(norm, bound)) {\n","\t\t\t\tcontinue;\n","\t\t\t}\n"]
theorem gs_selection : KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 7994).take 25)=
    some (gsHeadLines++(Pinned.keygenLines.drop 7997).take 2++gsTailLines++gateLines) := by decide
theorem same_gate : gateLines=KeygenNormFrame.visible.drop 10 := KeygenNormFrame.gate_source.symm

inductive GS (ctx : Context) (before : State) : Result → Prop where
  | run (head scaledFirst scaledSecond ready : State) (out : Result)
      (initial : KeygenSearchExec.Exec ctx headCode before ⟨head,.normal⟩)
      (first : KeygenAttemptFft.Call head (KeygenAttemptFft.arguments "rt1") scaledFirst)
      (second : KeygenAttemptFft.Call scaledFirst (KeygenAttemptFft.arguments "rt2") scaledSecond)
      (tail : KeygenSearchExec.Exec ctx tailCode scaledSecond ⟨ready,.normal⟩)
      (gate : KeygenNormFrame.Gate ready out) : GS ctx before out
inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | rawRejected (bounded : State) (out : Result)
      (initial : KeygenSearchExec.Exec ctx boundCode before ⟨bounded,.normal⟩)
      (raw : KeygenNormFrame.Exec ctx bounded out) (rejected : out.flow=.continueLoop) : Exec ctx before out
  | gs (bounded raw : State) (out : Result)
      (initial : KeygenSearchExec.Exec ctx boundCode before ⟨bounded,.normal⟩)
      (norm : KeygenNormFrame.Exec ctx bounded ⟨raw,.normal⟩) (gs : GS ctx raw out) : Exec ctx before out

def Protected (ctx : Context) (s : State) (block : Nat) : Prop := ctx.scratch.block≠block ∧
  (∀ name∈writable, ∀ p, s.arrays name=some p → p.block≠block) ∧
  ∀ name p, s.tables name=some p → p.block≠block
def Frame (before : State) (out : Result) (block offset : Nat) : Prop :=
  C99ArrayFrame.Outside out.state writable block offset ∧ out.state.tables=before.tables ∧
    out.state.heap.bytes block offset=before.heap.bytes block offset
theorem search_frame (ctx : Context) (code : Stmt) (before : State) (out : Result)
    (source : KeygenSearchExec.Exec ctx code before out) (checked : KeygenSearchFrame.only writable code=true)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before writable block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset)
    (scratch : C99PointerFootprint.PointOutside ctx.scratch block offset) : Frame before out block offset :=
  KeygenSearchFrame.body_frame ctx code before out source writable checked block offset outside tables scratch
theorem scale_frame (before after : State) (name : String) (source : KeygenAttemptFft.Call before (KeygenAttemptFft.arguments name) after)
    (checked : C99PointerFootprint.arguments writable KeygenAttemptFft.writable KeygenAttemptFft.params
      (KeygenAttemptFft.arguments name)=true)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before writable block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) : Frame before ⟨after,.normal⟩ block offset := by
  have slots := KeygenAttemptFft.slots _ _ _ source
  exact ⟨by simpa only [C99ArrayFrame.Outside,slots.2.1] using outside,slots.2.2,
    KeygenAttemptFft.frame _ _ _ source writable checked block offset outside tables⟩
theorem compose (a b : State) (out : Result) (block offset : Nat)
    (first : Frame a ⟨b,.normal⟩ block offset) (second : Frame b out block offset) : Frame a out block offset :=
  ⟨second.1,second.2.1.trans first.2.1,second.2.2.trans first.2.2⟩
theorem tables_after (a : State) (out : Result) (block offset : Nat) (frame : Frame a out block offset)
    (tables : C99PointerFootprint.TablesOutside a block offset) : C99PointerFootprint.TablesOutside out.state block offset := by
  simpa only [C99PointerFootprint.TablesOutside,frame.2.1] using tables
theorem gs_frame (ctx : Context) (before : State) (out : Result) (source : GS ctx before out)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before writable block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset)
    (scratch : C99PointerFootprint.PointOutside ctx.scratch block offset) : Frame before out block offset := by
  cases source with
  | run head first second ready out initial scale1 scale2 tail gate =>
    have a := search_frame ctx _ _ _ initial head_checked block offset outside tables scratch
    have b := scale_frame _ _ "rt1" scale1 scale_first_checked block offset a.1 (tables_after _ _ _ _ a tables)
    have c := scale_frame _ _ "rt2" scale2 scale_second_checked block offset b.1
      (tables_after _ _ _ _ b (tables_after _ _ _ _ a tables))
    have d := search_frame ctx _ _ _ tail tail_checked block offset c.1
      (tables_after _ _ _ _ c (tables_after _ _ _ _ b (tables_after _ _ _ _ a tables))) scratch
    have result := compose _ _ _ block offset a (compose _ _ _ block offset b (compose _ _ _ block offset c d))
    cases gate <;> exact result
theorem raw_checked : KeygenSearchFrame.only writable KeygenNormFrame.code=true := by decide
theorem raw_frame (ctx : Context) (before : State) (out : Result) (source : KeygenNormFrame.Exec ctx before out)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before writable block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset)
    (scratch : C99PointerFootprint.PointOutside ctx.scratch block offset) : Frame before out block offset := by
  cases source with
  | run ready out computation gate =>
    have result := search_frame ctx _ _ _ computation raw_checked block offset outside tables scratch
    cases gate <;> exact result
theorem frame (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before writable block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset)
    (scratch : C99PointerFootprint.PointOutside ctx.scratch block offset) : Frame before out block offset := by
  cases source with
  | rawRejected bounded out initial raw rejected =>
    have a := search_frame ctx _ _ _ initial bound_checked block offset outside tables scratch
    exact compose _ _ _ block offset a (raw_frame ctx _ _ raw block offset a.1 (tables_after _ _ _ _ a tables) scratch)
  | gs bounded raw out initial norm gs =>
    have a := search_frame ctx _ _ _ initial bound_checked block offset outside tables scratch
    have b := raw_frame ctx _ _ norm block offset a.1 (tables_after _ _ _ _ a tables) scratch
    exact compose _ _ _ block offset a (compose _ _ _ block offset b
      (gs_frame ctx _ _ gs block offset b.1 (tables_after _ _ _ _ b (tables_after _ _ _ _ a tables)) scratch))
theorem bytes (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (block : Nat) (separated : Protected ctx before block) :
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  intro offset
  exact (frame ctx before out source block offset
    (fun name member p hp => Or.inl (Ne.symm (separated.2.1 name member p hp)))
    (fun name p hp => Or.inl (Ne.symm (separated.2.2 name p hp))) (Or.inl (Ne.symm separated.1))).2.2
theorem material (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (p : ArrayPointer) (separated : Protected ctx before p.block) (vector : Geometry.Vec)
    (represented : KeygenMaterial.Represents before.heap p vector) : KeygenMaterial.Represents out.state.heap p vector := by
  have keep := bytes ctx before out source p.block separated
  intro i
  exact ⟨fun b => (keep _).trans ((represented i).1 b),fun b => (keep _).trans ((represented i).2 b)⟩
theorem gs_stable (ctx : Context) (before : State) (out : Result) (source : GS ctx before out) : Stable before.heap out.state.heap := by
  cases source with
  | run head first second ready out initial scale1 scale2 tail gate =>
    have a := KeygenSearchStability.search _ _ _ _ initial
    have b := KeygenAttemptFft.stable _ _ _ scale1
    have c := KeygenAttemptFft.stable _ _ _ scale2
    have d := KeygenSearchStability.search _ _ _ _ tail
    have result := KeygenMemoryStability.trans _ _ _ a (KeygenMemoryStability.trans _ _ _ b (KeygenMemoryStability.trans _ _ _ c d))
    cases gate <;> exact result
theorem raw_stable (ctx : Context) (before : State) (out : Result) (source : KeygenNormFrame.Exec ctx before out) : Stable before.heap out.state.heap := by
  cases source with
  | run ready out computation gate =>
    have result := KeygenSearchStability.search _ _ _ _ computation
    cases gate <;> exact result
theorem stable (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out) : Stable before.heap out.state.heap := by
  cases source with
  | rawRejected bounded out initial raw rejected =>
    exact KeygenMemoryStability.trans _ _ _
      (KeygenSearchStability.search _ _ _ _ initial) (raw_stable _ _ _ raw)
  | gs bounded raw out initial norm gs =>
    exact KeygenMemoryStability.trans _ _ _
      (KeygenSearchStability.search _ _ _ _ initial) (KeygenMemoryStability.trans _ _ _ (raw_stable _ _ _ norm) (gs_stable _ _ _ gs))

end FT1536.Source3.KeygenAttemptNorm
