import Source3.C99ProcedureParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftProcedurePrograms
open C99ArrayReference (Name)
open C99ProcedureReference (Function Program)

inductive Id where
  | leaf (op : FftLeafPrograms.Operation)
  | fft | mulAdj | splitTop | splitDeep | ldl2 | ldl3 | inner | depth1 | ldlTop
  deriving DecidableEq, Repr

def all : List Id := [
  .leaf .add,.leaf .sub,.leaf .neg,.leaf .adj,.leaf .selfAdj,.leaf .mulAuto,.leaf .divAuto,
  .fft,.mulAdj,.splitTop,.splitDeep,.ldl2,.ldl3,.inner,.depth1,.ldlTop]
def name : Id → Name
  | .leaf op => FftLeafPrograms.name op
  | .fft => "falcon_FFT3".toList
  | .mulAdj => "falcon_poly_muladj_fft3".toList
  | .splitTop => "falcon_poly_split_top_fft3".toList
  | .splitDeep => "falcon_poly_split_deep_fft3".toList
  | .ldl2 => "LDL_dim2_fft3_keygen".toList
  | .ldl3 => "LDL_dim3_fft3_keygen".toList
  | .inner => "ffLDL_inner_fft3_keygen".toList
  | .depth1 => "ffLDL_depth1_fft3_keygen".toList
  | .ldlTop => "ffLDL_fft3_keygen".toList

def sourceRegion : Id → Bool×Nat×Nat
  | .leaf op => (false,(FftLeafPrograms.region op).1,(FftLeafPrograms.region op).2)
  | .fft => (false,758,93)
  | .mulAdj => (false,1077,18)
  | .splitTop => (false,1274,49)
  | .splitDeep => (false,1325,46)
  | .ldl2 => (true,7549,14)
  | .ldl3 => (true,7564,28)
  | .inner => (true,7593,28)
  | .depth1 => (true,7622,33)
  | .ldlTop => (true,7656,27)

def text (id : Id) : List Char :=
  let (keygen,start,count) := sourceRegion id
  let lines := if keygen then Pinned.keygenLines else FT1536.FftBind.FftPin.fftLines
  ((lines.drop (start-1)).take count).flatMap String.toList

/- Object-like aliases in the pinned M0 internal.h. The source-fragment
   equality and full-file pin are checked by the companion source checker. -/
def aliases : List (Name×Name) := [
  ("falcon_poly_add_fft3".toList,"falcon_poly_add3".toList),
  ("falcon_poly_sub_fft3".toList,"falcon_poly_sub3".toList),
  ("falcon_poly_neg_fft3".toList,"falcon_poly_neg3".toList)]
def canonical (n : Name) : Name :=
  ((aliases.find? (fun p => p.1==n)).map Prod.snd).getD n
def find (n : Name) : Option Id := all.find? (fun id => name id==canonical n)
def headerText (id : Id) : List Char := (text id).takeWhile (· != '{')++['{']
def pointer (n : String) (readOnly restricted : Bool) : C99ArrayParser.Parameter :=
  ⟨.pointer n.toList,some .u64,readOnly,restricted⟩
def unsigned (n : String) : C99ArrayParser.Parameter := ⟨.scalar .uint32 n.toList,none,false,false⟩
def dimensions : List C99ArrayParser.Parameter := [unsigned "logn",unsigned "full"]
def header (id : Id) : C99ProcedureParser.Header :=
  let params := match id with
    | .leaf .add | .leaf .sub | .leaf .mulAuto | .leaf .divAuto | .mulAdj =>
        [pointer "a" false true,pointer "b" true true]++dimensions
    | .leaf .neg => [pointer "a" false true]++dimensions
    | .leaf .adj | .leaf .selfAdj | .fft => [pointer "a" false false]++dimensions
    | .splitTop => [pointer "f0" false true,pointer "f1" false true,pointer "f2" false true,
        pointer "f" true true,unsigned "logn"]
    | .splitDeep => [pointer "f0" false true,pointer "f1" false true,pointer "f" true true,unsigned "logn"]
    | .ldl2 => [pointer "d11" false true,pointer "l10" false true,
        pointer "g00" true true,pointer "g10" true true,pointer "g11" true true]++dimensions
    | .ldl3 => [pointer "d11" false true,pointer "d22" false true,pointer "l10" false true,
        pointer "l20" false true,pointer "l21" false true,pointer "g00" true true,
        pointer "g10" true true,pointer "g11" true true,pointer "g20" true true,
        pointer "g21" true true,pointer "g22" true true]++dimensions++[pointer "tmp" false true]
    | .inner | .ldlTop => [pointer "tree" false true,pointer "g00" true true,
        pointer "g10" true true,pointer "g11" true true,unsigned "logn",pointer "tmp" false true]
    | .depth1 => [pointer "tree" false true,pointer "g00" true true,pointer "g10" true true,
        pointer "g11" true true,pointer "g20" true true,pointer "g21" true true,
        pointer "g22" true true,unsigned "logn",pointer "tmp" false true]
  let result := match id with | .inner | .depth1 | .ldlTop => some .uint64 | _ => none
  ⟨name id,params,result⟩

theorem header_add : C99ProcedureParser.signature (headerText (.leaf .add))=some (header (.leaf .add)) := by decide
theorem header_sub : C99ProcedureParser.signature (headerText (.leaf .sub))=some (header (.leaf .sub)) := by decide
theorem header_neg : C99ProcedureParser.signature (headerText (.leaf .neg))=some (header (.leaf .neg)) := by decide
theorem header_adj : C99ProcedureParser.signature (headerText (.leaf .adj))=some (header (.leaf .adj)) := by decide
theorem header_selfAdj : C99ProcedureParser.signature (headerText (.leaf .selfAdj))=some (header (.leaf .selfAdj)) := by decide
theorem header_mulAuto : C99ProcedureParser.signature (headerText (.leaf .mulAuto))=some (header (.leaf .mulAuto)) := by decide
theorem header_divAuto : C99ProcedureParser.signature (headerText (.leaf .divAuto))=some (header (.leaf .divAuto)) := by decide
theorem header_fft : C99ProcedureParser.signature (headerText .fft)=some (header .fft) := by decide
theorem header_mulAdj : C99ProcedureParser.signature (headerText .mulAdj)=some (header .mulAdj) := by decide
theorem header_splitTop : C99ProcedureParser.signature (headerText .splitTop)=some (header .splitTop) := by decide
theorem header_splitDeep : C99ProcedureParser.signature (headerText .splitDeep)=some (header .splitDeep) := by decide
theorem header_ldl2 : C99ProcedureParser.signature (headerText .ldl2)=some (header .ldl2) := by decide
theorem header_ldl3 : C99ProcedureParser.signature (headerText .ldl3)=some (header .ldl3) := by decide
theorem header_inner : C99ProcedureParser.signature (headerText .inner)=some (header .inner) := by decide
theorem header_depth1 : C99ProcedureParser.signature (headerText .depth1)=some (header .depth1) := by decide
theorem header_ldlTop : C99ProcedureParser.signature (headerText .ldlTop)=some (header .ldlTop) := by decide

theorem header_bound (id : Id) : C99ProcedureParser.signature (headerText id)=some (header id) := by
  cases id with
  | leaf op =>
      cases op
      · exact header_add
      · exact header_sub
      · exact header_neg
      · exact header_adj
      · exact header_selfAdj
      · exact header_mulAuto
      · exact header_divAuto
  | fft => exact header_fft
  | mulAdj => exact header_mulAdj
  | splitTop => exact header_splitTop
  | splitDeep => exact header_splitDeep
  | ldl2 => exact header_ldl2
  | ldl3 => exact header_ldl3
  | inner => exact header_inner
  | depth1 => exact header_depth1
  | ldlTop => exact header_ldlTop

def sourceSignatures (n : Name) : Option (List C99ArrayReference.Param×Option C99IntegerReference.Ty) := do
  let id ← find n
  let h ← C99ProcedureParser.signature (headerText id)
  pure (h.parameters.map C99ArrayParser.Parameter.value,h.result)
def signatures (n : Name) : Option (List C99ArrayReference.Param×Option C99IntegerReference.Ty) := do
  let id ← find n
  pure ((header id).parameters.map C99ArrayParser.Parameter.value,(header id).result)
theorem signatures_source (n : Name) : signatures n=sourceSignatures n := by
  unfold signatures sourceSignatures
  cases find n with
  | none => rfl
  | some id => simp only [header_bound]; rfl
def source (id : Id) : Option C99ProcedureParser.Parsed := C99ProcedureParser.parse signatures (text id)
def program (n : Name) : Option Function := do
  pure (← source (← find n)).function

theorem signatures_bound (id : Id) :
    (C99ProcedureParser.signature (headerText id)).map C99ProcedureParser.Header.name=some (name id) := by
  rw [header_bound]
  cases id with
  | leaf op => cases op <;> rfl
  | _ => rfl

theorem fft_source : (source .fft).map (fun p => p.header.name)=some (name .fft) := by decide
theorem mulAdj_source : (source .mulAdj).map (fun p => p.header.name)=some (name .mulAdj) := by decide
theorem splitTop_source : (source .splitTop).map (fun p => p.header.name)=some (name .splitTop) := by decide
theorem splitDeep_source : (source .splitDeep).map (fun p => p.header.name)=some (name .splitDeep) := by decide
theorem ldl2_source : (source .ldl2).map (fun p => p.header.name)=some (name .ldl2) := by decide
theorem ldl3_source : (source .ldl3).map (fun p => p.header.name)=some (name .ldl3) := by decide
theorem inner_source : (source .inner).map (fun p => p.header.name)=some (name .inner) := by decide
theorem depth1_source : (source .depth1).map (fun p => p.header.name)=some (name .depth1) := by decide
theorem ldlTop_source : (source .ldlTop).map (fun p => p.header.name)=some (name .ldlTop) := by decide

end FT1536.Source3.FftProcedurePrograms
