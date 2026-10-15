import Source3.FpcAddLocal146
import Source3.FpcAddStore146
import Source3.FftTripleShape145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleAddShape146

def localParameters : Fin 3 → FpcAddLocal146.Parameters
  | ⟨0,_⟩ => ⟨⟨"fB0r".toList,"fB0i".toList,"fC0r".toList,"fC0i".toList⟩,"fB0r".toList,"fB0i".toList⟩
  | ⟨1,_⟩ => ⟨⟨"fB1r".toList,"fB1i".toList,"fC2r".toList,"fC2i".toList⟩,"fB1r".toList,"fB1i".toList⟩
  | ⟨2,_⟩ => ⟨⟨"fB2r".toList,"fB2i".toList,"fC1r".toList,"fC1i".toList⟩,"fB2r".toList,"fB2i".toList⟩

def storeInputs : Fin 3 → FpcAddCompute146.Inputs
  | ⟨0,_⟩ => ⟨"fAr".toList,"fAi".toList,"fB0r".toList,"fB0i".toList⟩
  | ⟨1,_⟩ => ⟨"fAr".toList,"fAi".toList,"fB1r".toList,"fB1i".toList⟩
  | ⟨2,_⟩ => ⟨"fAr".toList,"fAi".toList,"fB2r".toList,"fB2i".toList⟩

def realIndex (i : Fin 3) : CLogic.Expr := .bin .add (.var "u".toList) (.literal .i32 i.val)
def imagIndex (i : Fin 3) : CLogic.Expr := .bin .add (realIndex i) (.var "hn".toList)
def storeParameters (i : Fin 3) : FpcAddStore146.Parameters := ⟨storeInputs i,"a".toList,realIndex i,imagIndex i⟩

theorem local_shape (i : Fin 3) : FftTripleShape145.part (19+i.val)=.base (FpcAddLocal146.code (localParameters i)) := by
  fin_cases i <;> rfl

theorem store_shape (i : Fin 3) : FftTripleShape145.part (22+i.val)=.base (FpcAddStore146.code (storeParameters i)) := by
  fin_cases i <;> rfl

theorem local_real (i : Fin 3) : (localParameters i).dr=(localParameters i).inputs.ar := by fin_cases i <;> rfl
theorem local_imag (i : Fin 3) : (localParameters i).di=(localParameters i).inputs.ai := by fin_cases i <;> rfl

theorem real_reads (i : Fin 3) : C99ExpressionEnvironment.readNames (C99Frontend.expression (realIndex i))=["u".toList] := by rfl
theorem imag_reads (i : Fin 3) : C99ExpressionEnvironment.readNames (C99Frontend.expression (imagIndex i))=["u".toList,"hn".toList] := by rfl

theorem real_safe (i : Fin 3) (name : C99ArrayReference.Name)
    (member : name∈C99ExpressionEnvironment.readNames (C99Frontend.expression (realIndex i))) : name∉FftPairShape140.temporaries := by
  rw [real_reads] at member
  have same := List.mem_singleton.mp member
  subst name
  decide

theorem imag_safe (i : Fin 3) (name : C99ArrayReference.Name)
    (member : name∈C99ExpressionEnvironment.readNames (C99Frontend.expression (imagIndex i))) : name∉FftPairShape140.temporaries := by
  rw [imag_reads] at member
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl|rfl <;> decide

end FT1536.Source3.FftTripleAddShape146
