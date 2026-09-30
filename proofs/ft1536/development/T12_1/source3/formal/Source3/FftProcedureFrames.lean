import Source3.FftProcedurePrograms
import Source3.C99ProcedureFootprint

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftProcedureFrames
open C99ArrayReference (Name State)
open C99ProcedureReference (Exec Result)
open FftProcedurePrograms

def writable (id : Id) : List Name :=
  let names : List String := match id with
    | .leaf _ | .fft | .mulAdj => ["a"]
    | .splitTop => ["f0","f1","f2"]
    | .splitDeep => ["f0","f1"]
    | .ldl2 => ["d11","l10"]
    | .ldl3 => ["d11","d22","l10","l20","l21","tmp"]
    | .inner => ["tree","tmp","t0","t1","t2"]
    | .depth1 => ["tree","tmp","l10","l20","l21","d11","d22","t0","t1","t2"]
    | .ldlTop => ["tree","tmp","l10","d11","t0","t1","t2","t3"]
  names.map String.toList

def permissions (n : Name) : List Name := ((find n).map writable).getD []
def interfaces (n : Name) : Option (List C99ArrayReference.Param) :=
  (signatures n).map Prod.fst
def audit (id : Id) : Option Bool := (source id).map (fun p =>
  (p.header==header id) && C99ProcedureFootprint.only interfaces permissions (writable id) p.body)

theorem audit_add : audit (.leaf .add)=some true := by decide
theorem audit_sub : audit (.leaf .sub)=some true := by decide
theorem audit_neg : audit (.leaf .neg)=some true := by decide
theorem audit_adj : audit (.leaf .adj)=some true := by decide
theorem audit_selfAdj : audit (.leaf .selfAdj)=some true := by decide
theorem audit_mulAuto : audit (.leaf .mulAuto)=some true := by decide
theorem audit_divAuto : audit (.leaf .divAuto)=some true := by decide
theorem audit_fft : audit .fft=some true := by decide
theorem audit_mulAdj : audit .mulAdj=some true := by decide
theorem audit_splitTop : audit .splitTop=some true := by decide
theorem audit_splitDeep : audit .splitDeep=some true := by decide
theorem audit_ldl2 : audit .ldl2=some true := by decide
theorem audit_ldl3 : audit .ldl3=some true := by decide
theorem audit_inner : audit .inner=some true := by decide
theorem audit_depth1 : audit .depth1=some true := by decide
theorem audit_ldlTop : audit .ldlTop=some true := by decide

theorem audit_all (id : Id) : audit id=some true := by
  cases id with
  | leaf op =>
      cases op
      · exact audit_add
      · exact audit_sub
      · exact audit_neg
      · exact audit_adj
      · exact audit_selfAdj
      · exact audit_mulAuto
      · exact audit_divAuto
  | fft => exact audit_fft
  | mulAdj => exact audit_mulAdj
  | splitTop => exact audit_splitTop
  | splitDeep => exact audit_splitDeep
  | ldl2 => exact audit_ldl2
  | ldl3 => exact audit_ldl3
  | inner => exact audit_inner
  | depth1 => exact audit_depth1
  | ldlTop => exact audit_ldlTop

theorem audited_body (id : Id) (p : C99ProcedureParser.Parsed) (hp : source id=some p) :
    p.header=header id ∧ C99ProcedureFootprint.only interfaces permissions (writable id) p.body=true := by
  have h := audit_all id
  rw [audit,hp] at h
  have hb := Bool.and_eq_true_iff.mp (Option.some.inj h)
  exact ⟨beq_iff_eq.mp hb.1,hb.2⟩

theorem aligned : C99ProcedureFootprint.Aligned program interfaces := by
  intro n f hf
  unfold program at hf
  cases hi : find n with
  | none => simp [hi] at hf
  | some id =>
      cases hp : source id with
      | none => simp [hi,hp] at hf
      | some p =>
          have he : p.function=f := Option.some.inj (by simpa [hi,hp] using hf)
          subst f
          have hh := (audited_body id p hp).1
          simp only [interfaces,signatures,hi]
          change some ((header id).parameters.map C99ArrayParser.Parameter.value)=
            some (p.header.parameters.map C99ArrayParser.Parameter.value)
          rw [hh]

theorem closed : C99ProcedureFootprint.Closed program interfaces permissions := by
  intro n f hf
  unfold program at hf
  cases hi : find n with
  | none => simp [hi] at hf
  | some id =>
      cases hp : source id with
      | none => simp [hi,hp] at hf
      | some p =>
          have he : p.function=f := Option.some.inj (by simpa [hi,hp] using hf)
          subst f
          change C99ProcedureFootprint.only interfaces permissions (permissions n) p.body=true
          simp only [permissions,hi,Option.map_some,Option.getD_some]
          exact (audited_body id p hp).2

theorem parsed_body_frame (id : Id) (p : C99ProcedureParser.Parsed) (hp : source id=some p)
    (before : State) (result : Result) (execution : Exec program p.body before result)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before (writable id) block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside result.state (writable id) block offset ∧
      result.state.tables=before.tables ∧
      result.state.heap.bytes block offset=before.heap.bytes block offset :=
  C99ProcedureFootprint.body_frame program interfaces permissions aligned closed p.body before result
    execution (writable id) (audited_body id p hp).2 block offset outside tables

end FT1536.Source3.FftProcedureFrames
