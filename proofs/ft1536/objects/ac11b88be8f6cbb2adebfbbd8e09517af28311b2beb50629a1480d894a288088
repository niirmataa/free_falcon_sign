import Source3.KeygenSearchParser
import Source3.KeygenSearchFrame
import Source3.KeygenSamplerCalls
import Source3.C99CompareObjects

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Active ternary raw-norm computation and gate, lines7969--7990 after M0
   preprocessing. This is the FFT/FPEMU path; poly_small_sqnorm belongs to
   the binary branch and does not supply this frame. Bound initialization
   and the preceding resultant gates remain caller obligations. -/
namespace FT1536.Source3.KeygenNormFrame
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchExec (Stmt skip)
open KeygenSearchContext (Context)

def selected : Option (List String) := KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 7968).take 22)
def visible : List String := (Pinned.keygenLines.drop 7968).take 10 ++
  (Pinned.keygenLines.drop 7981).take 2 ++ (Pinned.keygenLines.drop 7988).take 2
theorem selected_source : selected=some visible := by decide
def types : KeygenSearchParser.Types := [("f".toList,2),("g".toList,2),("rt1".toList,8),("rt2".toList,8)]
def writable : List Name := ["rt1".toList,"rt2".toList]
def parsed : Option Stmt := do
  let tokens ← C99ProcedureParser.tokens ((visible.take 10).flatMap String.toList++['}'])
  let (code,_,rest) ← KeygenSearchParser.body types 256 tokens
  if rest.isEmpty then pure code else none
def code : Stmt := parsed.getD skip
theorem source_audit : parsed.map (KeygenSearchFrame.only writable)=some true := by decide
theorem source_parsed : parsed=some code := by
  have h := source_audit
  cases hp : parsed with
  | none => simp only [hp,Option.map_none] at h; cases h
  | some p => simp only [code,hp,Option.getD_some]
theorem code_checked : KeygenSearchFrame.only writable code=true := by
  have h := source_audit
  rw [source_parsed] at h
  exact Option.some.inj h
theorem gate_source : visible.drop 10 = ["\n","\t\t\tif (!fpr_lt(norm, bound)) {\n",
    "\t\t\t\tcontinue;\n","\t\t\t}\n"] := by decide
/- fpr_lt is an object-copy helper, outside FprPrefixCalls. Execute its
   complete bitcast/scalar source rather than leaving an uninhabited call. -/
inductive Compare (before : State) : C99IntegerReference.Value → Prop where
  | run (norm bound : BitVec 64) (v : C99IntegerReference.Value)
      (normValue : C99ArrayReference.scalar before (.var "norm".toList) (.uint64 norm))
      (boundValue : C99ArrayReference.scalar before (.var "bound".toList) (.uint64 bound))
      (source : C99CompareObjects.Exec norm bound v) : Compare before v
inductive Gate (before : State) : Result → Prop where
  | reject (v : C99IntegerReference.Value) (source : Compare before v) (zero : v.integer=0) :
      Gate before ⟨before,.continueLoop⟩
  | accept (v : C99IntegerReference.Value) (source : Compare before v) (nonzero : v.integer≠0) :
      Gate before ⟨before,.normal⟩
inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | run (ready : State) (out : Result)
      (computation : KeygenSearchExec.Exec ctx code before ⟨ready,.normal⟩)
      (gate : Gate ready out) : Exec ctx before out
def Protected (ctx : Context) (before : State) (block : Nat) : Prop :=
  ctx.scratch.block≠block ∧
  (∀ name∈writable, ∀ p, before.arrays name=some p → p.block≠block) ∧
  ∀ name p, before.tables name=some p → p.block≠block
theorem bytes (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (block : Nat) (separated : Protected ctx before block) :
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run ready out computation gate =>
    intro offset
    have keep := (KeygenSearchFrame.body_frame ctx code before ⟨ready,.normal⟩ computation
      writable code_checked block offset
      (fun name member p hp => Or.inl (Ne.symm (separated.2.1 name member p hp)))
      (fun name p hp => Or.inl (Ne.symm (separated.2.2 name p hp)))
      (Or.inl (Ne.symm separated.1))).2.2
    cases gate <;> exact keep
theorem material (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (p : ArrayPointer) (separated : Protected ctx before p.block)
    (vector : Geometry.Vec) (represented : KeygenMaterial.Represents before.heap p vector) :
    KeygenMaterial.Represents out.state.heap p vector := by
  have keep := bytes ctx before out source p.block separated
  intro i
  constructor
  · intro byte; exact (keep _).trans ((represented i).1 byte)
  · intro byte; exact (keep _).trans ((represented i).2 byte)

end FT1536.Source3.KeygenNormFrame
