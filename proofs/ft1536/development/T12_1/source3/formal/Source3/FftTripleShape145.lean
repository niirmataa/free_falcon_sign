import Source3.FftMiddleShape139
import Source3.FpcMulClosed145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleShape145
open C99ProcedureReference (Stmt)
open FftMiddleShape139 (spine unscoped head tail condition body increment)

def branchCondition : Stmt → CLogic.Expr | .branch test _ _ => test | _ => .literal .i32 0
def branchYes : Stmt → Stmt | .branch _ yes _ => yes | _ => .base .skip
def code := FftMiddleShape139.tripling
def yes := branchYes code
def parts := spine (unscoped yes)
def loopPair := (parts[1]?).getD (.base .skip)
def initial := head loopPair
def loop := tail loopPair
def loopBody := body loop
def statements := spine (unscoped loopBody)
def part (index : Nat) := (statements[index]?).getD (.base .skip)

theorem branch_test : branchCondition code=.var "full".toList := by rfl
theorem loop_test : condition loop=.cmp .lt (.var "u".toList) (.var "hn".toList) := by rfl
theorem loop_increment : increment loop=.seq
    (.base (.scalar (.update "u".toList .add (.literal .i32 3))))
    (.base (.scalar (.update "v".toList .add (.literal .i32 2)))) := by rfl

def mulPosition (i : Fin 6) : Nat := if i.val<3 then 12+i.val else 13+i.val

def mulParameters : Fin 6 → FpcMulShape145.Parameters
  | ⟨0,_⟩ => ⟨"fB0r".toList,"fB0i".toList,"fBr".toList,"fBi".toList,"xr".toList,"xi".toList⟩
  | ⟨1,_⟩ => ⟨"fB1r".toList,"fB1i".toList,"fB0r".toList,"fB0i".toList,"fpr_W2R".toList,"fpr_W2I".toList⟩
  | ⟨2,_⟩ => ⟨"fB2r".toList,"fB2i".toList,"fB0r".toList,"fB0i".toList,"fpr_W4R".toList,"fpr_W4I".toList⟩
  | ⟨3,_⟩ => ⟨"fC0r".toList,"fC0i".toList,"fCr".toList,"fCi".toList,"xr".toList,"xi".toList⟩
  | ⟨4,_⟩ => ⟨"fC1r".toList,"fC1i".toList,"fC0r".toList,"fC0i".toList,"fpr_W2R".toList,"fpr_W2I".toList⟩
  | ⟨5,_⟩ => ⟨"fC2r".toList,"fC2i".toList,"fC0r".toList,"fC0i".toList,"fpr_W4R".toList,"fpr_W4I".toList⟩

theorem mul_shape (i : Fin 6) : part (mulPosition i)=.base (FpcMulShape145.code (mulParameters i)) := by
  fin_cases i <;> rfl

theorem mul_source (i : Fin 6) (s : C99ArrayReference.State) (x : FftMulStates140.Words)
    (entry : FpcMulShape145.Entry s (mulParameters i) x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (part (mulPosition i)) s
      ⟨FpcMulShape145.output s (mulParameters i) x,.normal⟩ := by
  rw [mul_shape]
  exact .base _ _ _ (FpcMulClosed145.source FftLeafPrograms.program s (mulParameters i) x entry)

end FT1536.Source3.FftTripleShape145
