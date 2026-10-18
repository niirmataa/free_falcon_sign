import Source3.ModpDivStep178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModpDivControl178
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value ArithmeticExec CompareExec convert)
open C99ModularReference (GenExec LeafCall)
open ModpDivSelect178 (index index_value)

def counter (n : Nat) : BitVec 32 := BitVec.ofInt 32 ((n : Int)-1)
def lower (s : State) (n : Nat) := bindValue s "i".toList .int32 (.int32 (counter n))
def condition : CLogic.Expr := .cmp .ge (.var "i".toList) (.literal .i32 0)
def update : C99ModularReference.Stmt := .base (.scalar (.update "i".toList .sub (.literal .i32 1)))
def loop : C99ModularReference.Stmt := .loop condition C99ModularReference.divLoopBody update

theorem counter_succ (n : Nat) : counter (n+1)=index n := by
  unfold counter index
  congr 1
  omega

theorem lower_slot (s : State) (n : Nat) :
    (lower s n).locals "i".toList=some (.int32,some (.int32 (counter n))) := by
  simp [lower,bindValue,C99ScalarReference.set,convert,Value.integer]

theorem positive_compare (n : Nat) (bound : n<31) :
    CompareExec .ge (.int32 (index n)) (.int32 0) (.int32 1) := by
  have raw := CompareExec.step .ge (.int32 (index n)) (.int32 0) .int32 rfl
    (.int32 (index n)) (.int32 0) (by simp [convert,Value.integer]) rfl
  simpa [Value.integer,index_value n bound,C99IntegerReference.compare] using raw

theorem negative_compare : CompareExec .ge (.int32 (counter 0)) (.int32 0) (.int32 0) :=
  .step .ge (.int32 (counter 0)) (.int32 0) .int32 rfl (.int32 (counter 0)) (.int32 0) rfl rfl

theorem subtraction (n : Nat) (bound : n<31) :
    ArithmeticExec .minus (.int32 (index n)) (.int32 1) (.int32 (counter n)) := by
  have safe : C99IntegerReference.signed C99IntegerReference.Ty.int32=true →
      C99IntegerReference.fits .int32 (C99IntegerReference.exact .minus (Value.int32 (index n)).integer (Value.int32 1).integer) := by
    intro _
    change -(2^31 : Int)≤(index n).toInt-1 ∧ (index n).toInt-1<2^31
    rw [index_value n bound]
    omega
  have raw := ArithmeticExec.step .minus (.int32 (index n)) (.int32 1) .int32 rfl
    (.int32 (index n)) (.int32 1) (by simp [convert,Value.integer]) rfl safe
  simpa [C99IntegerReference.exact,Value.integer,index_value n bound,convert,counter] using raw

theorem decrement (s : State) (n : Nat) (bound : n<31)
    (hi : s.locals "i".toList=some (.int32,some (.int32 (index n)))) :
    GenExec LeafCall update s ⟨lower s n,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .int32 (some (.int32 (index n))) (.int32 (counter n)) hi
    (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ hi) (.literal .int32 1) (subtraction n bound))))

theorem fixed (s : State) (a b p p0i e : BitVec 32) (n : Nat) (h : ModpDivStep178.Fixed s a b p p0i e) :
    ModpDivStep178.Fixed (lower s n) a b p p0i e := ⟨h.1,h.2.1,h.2.2.1,h.2.2.2.1,h.2.2.2.2⟩

end FT1536.Source3.ModpDivControl178
