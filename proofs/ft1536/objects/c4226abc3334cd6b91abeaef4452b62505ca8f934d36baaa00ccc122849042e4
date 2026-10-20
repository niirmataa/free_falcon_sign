import Source3.FftProcedurePrograms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftGlobalScalars
open B20.C (Name Token)

def parseConstant (line : String) : Option (Name×BitVec 64) := do
  let tokens ← CLogicParser.tokenize (line.length+1) line.toList
  match tokens with
  | [st,cn,ty,name,['='],number,[';']] =>
      if st="static".toList ∧ cn="const".toList ∧ ty="fpr".toList then do
        match ← CLogicParser.number number with
        | .literal .u64 n => pure (name,BitVec.ofNat 64 n)
        | _ => none
      else none
  | _ => none

def expected : List (Name×BitVec 64) := [
  ("fpr_W1R".toList,0x3fe0000000000000),("fpr_W1I".toList,0x3febb67ae8584caa),
  ("fpr_W2R".toList,0xbfe0000000000000),("fpr_W2I".toList,0x3febb67ae8584caa),
  ("fpr_W4R".toList,0xbfe0000000000000),("fpr_W4I".toList,0xbfebb67ae8584caa),
  ("fpr_W5R".toList,0x3fe0000000000000),("fpr_W5I".toList,0xbfebb67ae8584caa),
  ("fpr_IW1I".toList,0x3ff279a74590331c),("fpr_zero".toList,0),
  ("fpr_one".toList,0x3ff0000000000000),("fpr_two".toList,0x4000000000000000),
  ("fpr_onehalf".toList,0x3fe0000000000000)]

theorem source_bound : ((Pinned.fprLines.drop 66).take 13).mapM parseConstant=some expected := by decide

def environment : C99ScalarReference.Env := fun name =>
  ((expected.find? (fun pair => pair.1==name)).map (fun pair =>
    (C99IntegerReference.Ty.uint64,some (C99IntegerReference.Value.uint64 pair.2))))

theorem scalar_types (name : Name) (ty : C99IntegerReference.Ty) (value : C99IntegerReference.Value)
    (bound : environment name=some (ty,some value)) : ty=.uint64 ∧ value.type=.uint64 := by
  unfold environment at bound
  cases h : expected.find? (fun pair => pair.1==name) with
  | none => simp [h] at bound
  | some pair =>
      have he : (.uint64,some (C99IntegerReference.Value.uint64 pair.2))=(ty,some value) :=
        Option.some.inj (by simpa [h] using bound)
      cases he
      exact ⟨rfl,rfl⟩

theorem table_macro_source : FT1536.FftBind.FftPin.fftLines[36]?=some "#define FPC(re, im)   re, im\n" := by decide
theorem table_include_source : FT1536.FftBind.FftPin.fftLines[37]?=some "#include FPR_IMPL\n" := by decide

end FT1536.Source3.FftGlobalScalars
