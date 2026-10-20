import Source3.KeygenAttemptPin
import Source3.KeygenRootObjects
import Source3.KeygenNormFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The missing GS scaling helper, with its actual header alias, full body,
   value argument evaluation and derived byte frame. -/
namespace FT1536.Source3.KeygenAttemptFft
open C99ArrayReference (State Name Arg)
open C99MemoryReference
open C99ProcedureReference (Result)

def text : List Char := ((FT1536.FftBind.FftPin.fftLines.drop 1118).take 10).flatMap String.toList
def header : C99ProcedureParser.Header :=
  ⟨"falcon_poly_mulconst3".toList,[FftProcedurePrograms.pointer "a" false false,
    ⟨.scalar .uint64 "x".toList,none,false,false⟩]++FftProcedurePrograms.dimensions,none⟩
def parsed : Option C99ProcedureParser.Parsed := C99ProcedureParser.parse (fun _ => none) text
def code : C99ProcedureReference.Stmt := (parsed.map C99ProcedureParser.Parsed.body).getD (.base .skip)
def params : List C99ArrayReference.Param := header.parameters.map C99ArrayParser.Parameter.value
def writable : List Name := ["a".toList]
def audit : Option Bool := parsed.map (fun p => p.header==header &&
  C99ProcedureFootprint.only (fun _ => none) (fun _ => []) writable p.body)
theorem alias_source : KeygenAttemptPin.internalLines[645]?=
    some "#define falcon_poly_mulconst_fft3   falcon_poly_mulconst3\n" := by decide
theorem source_audit : audit=some true := by decide
theorem source_parsed : ∃ p, parsed=some p ∧ p.header=header ∧ p.body=code ∧
    C99ProcedureFootprint.only (fun _ => none) (fun _ => []) writable code=true := by
  have h := source_audit
  cases hp : parsed with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some p =>
    simp only [audit,hp,Option.map_some] at h
    have facts := Bool.and_eq_true_iff.mp (Option.some.inj h)
    have hc : p.body=code := by simp only [code,hp,Option.map_some,Option.getD_some]
    exact ⟨p,rfl,beq_iff_eq.mp facts.1,hc,by rw [← hc]; exact facts.2⟩
def arguments (name : String) : List Arg := [.pointer name.toList C99ProcedureParser.zero,
  .scalar (.call1 "fpr_of".toList (.literal .i32 18433)),.scalar (.var "logn".toList),.scalar (.literal .i32 1)]
inductive Call (before : State) (args : List Arg) : State → Prop where
  | run (entry : State) (out : Result) (binding : C99ArrayReference.Bind before params args entry)
      (body : C99ProcedureReference.Exec (fun _ => none) code entry out)
      (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Call before args {before with heap := out.state.heap}
theorem frame (before after : State) (args : List Arg) (source : Call before args after)
    (names : List Name) (checked : C99PointerFootprint.arguments names writable params args=true)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out binding body returned =>
    obtain ⟨oe,te⟩ := C99PointerFootprint.bind_outside before params args entry binding
      names writable checked block offset outside tables
    have keep := C99ProcedureFootprint.body_frame (fun _ => none) (fun _ => none) (fun _ => [])
      (by intro _ _ h; cases h) (by intro _ _ h; cases h) code entry out body writable
      source_parsed.choose_spec.2.2.2 block offset oe (by simpa only [C99PointerFootprint.TablesOutside,te] using tables)
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at keep
    exact keep.2.2
theorem stable (before after : State) (args : List Arg) (source : Call before args after) :
    KeygenMemoryStability.Stable before.heap after.heap := by
  cases source with
  | run entry out binding body returned =>
    have h := KeygenMemoryStability.procedure _ _ _ _ body
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at h
    exact h
theorem slots (before after : State) (args : List Arg) (source : Call before args after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases source; exact ⟨rfl,rfl,rfl⟩

end FT1536.Source3.KeygenAttemptFft
