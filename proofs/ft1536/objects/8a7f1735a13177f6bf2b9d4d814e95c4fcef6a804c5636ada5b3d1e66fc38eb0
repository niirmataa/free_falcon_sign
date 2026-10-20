import Source3.C99ArrayParser
import FftBind.FftPin

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Seven complete void callee bodies used by the certificate prefix and raw
   LDL calls. Their source is parsed, including declarations and loop control.
   This is not a table of assumed numerical or memory postconditions. -/
namespace FT1536.Source3.FftLeafPrograms
open C99ArrayReference

inductive Operation where
  | add | sub | neg | adj | selfAdj | mulAuto | divAuto
  deriving DecidableEq, Repr

def region : Operation → Nat×Nat
  | .add => (968,11)
  | .sub => (1002,11)
  | .neg => (1015,10)
  | .adj => (1027,11)
  | .selfAdj => (1097,20)
  | .mulAuto => (1244,13)
  | .divAuto => (1259,13)

def name : Operation → Name
  | .add => "falcon_poly_add3".toList
  | .sub => "falcon_poly_sub3".toList
  | .neg => "falcon_poly_neg3".toList
  | .adj => "falcon_poly_adj_fft3".toList
  | .selfAdj => "falcon_poly_mulselfadj_fft3".toList
  | .mulAuto => "falcon_poly_mul_autoadj_fft3".toList
  | .divAuto => "falcon_poly_div_autoadj_fft3".toList

def source (op : Operation) : Option C99ArrayParser.Parsed :=
  C99ArrayParser.parse (((FT1536.FftBind.FftPin.fftLines.drop ((region op).1-1)).take (region op).2).flatMap String.toList)

theorem mkn_source : FT1536.FftBind.FftPin.fftLines[754]?=
    some "#define MKN(logn, full)   ((size_t)(1 + ((full) << 1)) << ((logn) - (full)))\n" := by decide

theorem add_source : (source .add).map C99ArrayParser.Parsed.name=some (name .add) := by decide
theorem sub_source : (source .sub).map C99ArrayParser.Parsed.name=some (name .sub) := by decide
theorem neg_source : (source .neg).map C99ArrayParser.Parsed.name=some (name .neg) := by decide
theorem adj_source : (source .adj).map C99ArrayParser.Parsed.name=some (name .adj) := by decide
theorem selfAdj_source : (source .selfAdj).map C99ArrayParser.Parsed.name=some (name .selfAdj) := by decide
theorem mulAuto_source : (source .mulAuto).map C99ArrayParser.Parsed.name=some (name .mulAuto) := by decide
theorem divAuto_source : (source .divAuto).map C99ArrayParser.Parsed.name=some (name .divAuto) := by decide

theorem source_name (op : Operation) : (source op).map C99ArrayParser.Parsed.name=some (name op) := by
  cases op
  · exact add_source
  · exact sub_source
  · exact neg_source
  · exact adj_source
  · exact selfAdj_source
  · exact mulAuto_source
  · exact divAuto_source

def program (n : Name) : Option Function := do
  let op ← ([Operation.add,.sub,.neg,.adj,.selfAdj,.mulAuto,.divAuto].find? (fun op => name op==n))
  pure (← source op).function

def Call (op : Operation) (args : List Arg) (before after : State) : Prop :=
  C99ArrayReference.Exec program (.call (name op) args) before after

theorem call_memory_steps (op : Operation) (args : List Arg) (before after : State)
    (h : Call op args before after) : C99InitializationTrace.Steps before.heap after.heap :=
  C99ArrayReference.memory_steps program _ before after h

theorem call_preserves_initialization (op : Operation) (args : List Arg) (before after : State)
    (h : Call op args before after) : C99InitializationTrace.Preserves before.heap after.heap :=
  C99InitializationTrace.steps_preserve before.heap after.heap (call_memory_steps op args before after h)

end FT1536.Source3.FftLeafPrograms
