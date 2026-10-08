import Source3.KeygenSearchFft

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Binary FFT branch retained by the complete intermediate source grammar.
   Each call executes its own pinned body. The ternary caller will select
   the ternary branch from actual context bytes, not from omitted syntax. -/
namespace FT1536.Source3.KeygenBinaryFft
open C99ArrayReference (Name State)
open C99ProcedureReference (Function Exec Result)

inductive Id where
  | forward | inverse | add | adj | mul | invnorm | mulAuto
  deriving DecidableEq, Repr
def all : List Id := [.forward,.inverse,.add,.adj,.mul,.invnorm,.mulAuto]
def name : Id → Name
  | .forward => "falcon_FFT".toList
  | .inverse => "falcon_iFFT".toList
  | .add => "falcon_poly_add".toList
  | .adj => "falcon_poly_adj_fft".toList
  | .mul => "falcon_poly_mul_fft".toList
  | .invnorm => "falcon_poly_invnorm2_fft".toList
  | .mulAuto => "falcon_poly_mul_autoadj_fft".toList
def canonical (n : Name) : Name := if n="falcon_poly_add_fft".toList then name .add else n
def find (n : Name) : Option Id := all.find? (fun id => name id==canonical n)
def region : Id → Nat×Nat
  | .forward => (175,78)
  | .inverse => (255,94)
  | .add => (351,10)
  | .adj => (425,10)
  | .mul => (437,17)
  | .invnorm => (581,21)
  | .mulAuto => (635,13)
def text (id : Id) : List Char :=
  ((FT1536.FftBind.FftPin.fftLines.drop ((region id).1-1)).take (region id).2).flatMap String.toList
def dimension : List C99ArrayParser.Parameter := [FftProcedurePrograms.unsigned "logn"]
def header (id : Id) : C99ProcedureParser.Header :=
  let pointers := match id with
    | .forward | .inverse => [FftProcedurePrograms.pointer "f" false false]
    | .adj => [FftProcedurePrograms.pointer "a" false false]
    | .add | .mul | .mulAuto => [FftProcedurePrograms.pointer "a" false true,FftProcedurePrograms.pointer "b" true true]
    | .invnorm => [FftProcedurePrograms.pointer "d" false true,
      FftProcedurePrograms.pointer "a" true true,FftProcedurePrograms.pointer "b" true true]
  ⟨name id,pointers++dimension,none⟩
def signatures (n : Name) : Option (List C99ArrayReference.Param×Option C99IntegerReference.Ty) := do
  let id ← find n
  pure ((header id).parameters.map C99ArrayParser.Parameter.value,none)
/- Post-decrement in a discarded for-update position is the compound
   subtraction by one. Expression-position post-decrement is not lowered. -/
def increments : List B20.C.Token → List B20.C.Token
  | name::['-']::['-']::[')']::rest => name::['-','=']::['1']::[')']::increments rest
  | t::rest => t::increments rest
  | [] => []
/- Parenthesize the complete unary argument so the inherited array grammar
   does not misclassify the leading minus followed by '(' as a call name. -/
def scalarArguments : List B20.C.Token → List B20.C.Token
  | ['f','p','r','_','s','c','a','l','e','d']::['(']::['2']::[',']::['-']::['(']::['i','n','t']::[')']::['l','o','g','n']::[')']::rest =>
    ["fpr_scaled","(","2",",","(","-","(","int",")","logn",")",")"].map String.toList ++ scalarArguments rest
  | t::rest => t::scalarArguments rest
  | [] => []
def source (id : Id) : Option C99ProcedureParser.Parsed := do
  let ts ← C99ProcedureParser.tokens (text id)
  let (h,rest) ← C99ProcedureParser.header (increments (scalarArguments ts))
  let (code,_,tail) ← C99ProcedureParser.body signatures h.context 256 rest
  if tail.isEmpty then pure ⟨h,code⟩ else none
theorem inverse_update_source : FT1536.FftBind.FftPin.fftLines[305]?=
    some "\tfor (u = logn; u > 1; u --) {\n" := by decide
theorem decrement_lowering : increments (["u","-","-",")"].map String.toList)=
    (["u","-=","1",")"].map String.toList) := by decide
theorem scale_source : FT1536.FftBind.FftPin.fftLines[342]?=
    some "\t\tni = fpr_scaled(2, -(int)logn);\n" := by decide
def scaleExpr : C99ArrayReference.Expr := .call2 "fpr_scaled".toList
  (.scalar (.literal .i32 2)) (.scalar (.neg (.cast .i32 (.var "logn".toList))))
theorem signed_scale_argument : C99ArrayParser.expr 24
    (scalarArguments (["fpr_scaled","(","2",",","-","(","int",")","logn",")"].map String.toList))=
    some (scaleExpr,[]) := by decide
def program (n : Name) : Option Function := do pure (← source (← find n)).function
def writable : Id → List Name
  | .forward | .inverse => ["f".toList]
  | .invnorm => ["d".toList]
  | _ => ["a".toList]
def permissions (n : Name) : List Name := ((find n).map writable).getD []
def interfaces (n : Name) : Option (List C99ArrayReference.Param) := (signatures n).map Prod.fst
def audit (id : Id) : Option Bool := (source id).map (fun p =>
  (p.header==header id) && C99ProcedureFootprint.only interfaces permissions (writable id) p.body)
theorem audit_forward : audit .forward=some true := by decide
theorem audit_inverse : audit .inverse=some true := by decide
theorem audit_add : audit .add=some true := by decide
theorem audit_adj : audit .adj=some true := by decide
theorem audit_mul : audit .mul=some true := by decide
theorem audit_invnorm : audit .invnorm=some true := by decide
theorem audit_mulAuto : audit .mulAuto=some true := by decide
theorem audit_all (id : Id) : audit id=some true := by
  cases id
  · exact audit_forward
  · exact audit_inverse
  · exact audit_add
  · exact audit_adj
  · exact audit_mul
  · exact audit_invnorm
  · exact audit_mulAuto
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

end FT1536.Source3.KeygenBinaryFft
