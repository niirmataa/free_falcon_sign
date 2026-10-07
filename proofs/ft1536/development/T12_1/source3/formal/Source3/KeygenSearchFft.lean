import Source3.FftProcedureFrames

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Fixed operational FFT closure for the search routines. These functions
   need only word execution and a write footprint here, not a real-arithmetic
   FFT correctness hypothesis. All source is the pinned M0 translation unit. -/
namespace FT1536.Source3.KeygenSearchFft
open C99ArrayReference (Name State)
open C99ProcedureReference (Function Program Exec Result)

inductive Id where
  | inherited (id : FftProcedurePrograms.Id)
  | inverse | mul | invnorm
  deriving DecidableEq, Repr

def all : List Id := FftProcedurePrograms.all.map .inherited ++ [.inverse,.mul,.invnorm]
def name : Id → Name
  | .inherited id => FftProcedurePrograms.name id
  | .inverse => "falcon_iFFT3".toList
  | .mul => "falcon_poly_mul_fft3".toList
  | .invnorm => "falcon_poly_invnorm2_fft3".toList
def find (n : Name) : Option Id := all.find? (fun id => name id==FftProcedurePrograms.canonical n)
def region : Id → Nat×Nat
  | .inverse => (853,113)
  | .mul => (1040,18)
  | .invnorm => (1188,22)
  | .inherited _ => (0,0)
def text : Id → List Char
  | .inherited id => FftProcedurePrograms.text id
  | id => ((FT1536.FftBind.FftPin.fftLines.drop ((region id).1-1)).take (region id).2).flatMap String.toList
def header : Id → C99ProcedureParser.Header
  | .inherited id => FftProcedurePrograms.header id
  | .inverse => ⟨name .inverse,[FftProcedurePrograms.pointer "a" false false]++FftProcedurePrograms.dimensions,none⟩
  | .mul => ⟨name .mul,[FftProcedurePrograms.pointer "a" false true,
      FftProcedurePrograms.pointer "b" true true]++FftProcedurePrograms.dimensions,none⟩
  | .invnorm => ⟨name .invnorm,[FftProcedurePrograms.pointer "d" false true,
      FftProcedurePrograms.pointer "a" true true,FftProcedurePrograms.pointer "b" true true]++
      FftProcedurePrograms.dimensions,none⟩
def signatures (n : Name) : Option (List C99ArrayReference.Param×Option C99IntegerReference.Ty) := do
  let id ← find n
  pure ((header id).parameters.map C99ArrayParser.Parameter.value,(header id).result)
def source (id : Id) : Option C99ProcedureParser.Parsed := C99ProcedureParser.parse signatures (text id)
def program (n : Name) : Option Function := do
  pure (← source (← find n)).function
def writable : Id → List Name
  | .inherited id => FftProcedureFrames.writable id
  | .inverse | .mul => ["a".toList]
  | .invnorm => ["d".toList]
def permissions (n : Name) : List Name := ((find n).map writable).getD []
def interfaces (n : Name) : Option (List C99ArrayReference.Param) := (signatures n).map Prod.fst
def audit (id : Id) : Option Bool := (source id).map (fun p =>
  (p.header==header id) && C99ProcedureFootprint.only interfaces permissions (writable id) p.body)

theorem header_inverse : C99ProcedureParser.signature ((text .inverse).takeWhile (· != '{')++['{'])=
    some (header .inverse) := by decide
theorem header_mul : C99ProcedureParser.signature ((text .mul).takeWhile (· != '{')++['{'])=
    some (header .mul) := by decide
theorem header_invnorm : C99ProcedureParser.signature ((text .invnorm).takeWhile (· != '{')++['{'])=
    some (header .invnorm) := by decide

theorem audit_inverse : audit .inverse=some true := by decide
theorem audit_mul : audit .mul=some true := by decide
theorem audit_invnorm : audit .invnorm=some true := by decide
theorem audit_add : audit (.inherited (.leaf .add))=some true := by decide
theorem audit_sub : audit (.inherited (.leaf .sub))=some true := by decide
theorem audit_neg : audit (.inherited (.leaf .neg))=some true := by decide
theorem audit_adj : audit (.inherited (.leaf .adj))=some true := by decide
theorem audit_selfAdj : audit (.inherited (.leaf .selfAdj))=some true := by decide
theorem audit_mulAuto : audit (.inherited (.leaf .mulAuto))=some true := by decide
theorem audit_divAuto : audit (.inherited (.leaf .divAuto))=some true := by decide
theorem audit_fft : audit (.inherited .fft)=some true := by decide
theorem audit_mulAdj : audit (.inherited .mulAdj)=some true := by decide
theorem audit_splitTop : audit (.inherited .splitTop)=some true := by decide
theorem audit_splitDeep : audit (.inherited .splitDeep)=some true := by decide
theorem audit_ldl2 : audit (.inherited .ldl2)=some true := by decide
theorem audit_ldl3 : audit (.inherited .ldl3)=some true := by decide
theorem audit_inner : audit (.inherited .inner)=some true := by decide
theorem audit_depth1 : audit (.inherited .depth1)=some true := by decide
theorem audit_ldlTop : audit (.inherited .ldlTop)=some true := by decide
theorem audit_inherited (id : FftProcedurePrograms.Id) : audit (.inherited id)=some true := by
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

theorem audit_all (id : Id) : audit id=some true := by
  cases id with
  | inherited id => exact audit_inherited id
  | inverse => exact audit_inverse
  | mul => exact audit_mul
  | invnorm => exact audit_invnorm

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

theorem body_frame (code : C99ProcedureReference.Stmt) (before : State) (out : Result)
    (source : Exec program code before out) (names : List Name)
    (checked : C99ProcedureFootprint.only interfaces permissions names code=true)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset :=
  C99ProcedureFootprint.body_frame program interfaces permissions aligned closed code before out source
    names checked block offset outside tables

end FT1536.Source3.KeygenSearchFft
