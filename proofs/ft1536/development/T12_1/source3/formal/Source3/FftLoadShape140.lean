import Source3.FftPairShape140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoadShape140
open C99ArrayReference (Name Expr)
open C99ProcedureReference (Stmt)

def names : List Name := ["a0r".toList,"a0i".toList,"a1r".toList,"a1i".toList]
def name : Fin 4 → Name := fun i => names[i.val]'(by change i.val<4; exact i.isLt)
def parts := FftMiddleShape139.spine (FftMiddleShape139.unscoped FftMiddleShape139.butterflyBody)
def assignmentIndex : Stmt → CLogic.Expr
  | .base (.assign _ (.load _ index)) => index
  | _ => .literal .i32 0

def index (i : Fin 4) : CLogic.Expr := assignmentIndex ((parts[i.val+1]?).getD (.base .skip))
def declaration : Stmt := .base (.scalar (.declare .u64 names))
def load (i : Fin 4) : Stmt := .base (.assign (name i) (.load "a".toList (index i)))

theorem body_source : FftMiddleShape139.butterflyBody=.scope names []
    (C99ProcedureParser.chain [declaration,load 0,load 1,load 2,load 3,
      FftMulShape140.sourcePart,FftPairShape140.sourcePart .add,FftPairShape140.sourcePart .sub]) := by rfl

theorem add_real : FftPairShape140.realIndex .add=index 0 := by rfl
theorem add_imag : FftPairShape140.imagIndex .add=index 1 := by rfl
theorem sub_real : FftPairShape140.realIndex .sub=index 2 := by rfl
theorem sub_imag : FftPairShape140.imagIndex .sub=index 3 := by rfl

def readNames : Fin 4 → List Name
  | ⟨0,_⟩ => ["v".toList]
  | ⟨1,_⟩ => ["v".toList,"hn".toList]
  | ⟨2,_⟩ => ["v".toList,"ht".toList]
  | ⟨3,_⟩ => ["v".toList,"ht".toList,"hn".toList]

theorem read_names (i : Fin 4) : C99ExpressionEnvironment.readNames (C99Frontend.expression (index i))=readNames i := by
  fin_cases i <;> rfl

theorem index_outside (i : Fin 4) (n : Name) (member : n∈readNames i) : n∉names := by
  fin_cases i
  all_goals simp only [readNames,List.mem_cons,List.not_mem_nil,or_false] at member
  · subst n
    decide
  · rcases member with rfl|rfl <;> decide
  · rcases member with rfl|rfl <;> decide
  · rcases member with rfl|rfl|rfl <;> decide

end FT1536.Source3.FftLoadShape140
