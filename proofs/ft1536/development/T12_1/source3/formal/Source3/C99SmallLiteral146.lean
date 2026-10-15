import Source3.C99LoopAssign142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99SmallLiteral146
open C99IntegerReference
open C99ArrayReference (State scalar)
open C99NatWord141 (word)

def small (k : Fin 4) : BitVec 32 := BitVec.ofNat 32 k.val

theorem convert_small (k : Fin 4) : convert .uint64 (Value.int32 (small k)).integer=.uint64 (word k.val) := by
  fin_cases k <;> rfl

theorem add_word (a : Nat) (k : Fin 4) (bound : a<2^64) :
    ArithmeticExec .plus (.uint64 (word a)) (.int32 (small k)) (.uint64 (word (a+k.val))) := by
  have raw := ArithmeticExec.step .plus (.uint64 (word a)) (.int32 (small k)) .uint64 rfl
    (.uint64 (word a)) (.uint64 (word k.val))
    (C99CountedWords.convert_self (.uint64 (word a))).symm (convert_small k).symm
    (by intro impossible; cases impossible)
  change ArithmeticExec .plus (.uint64 (word a)) (.int32 (small k))
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word a)).integer+(Value.uint64 (word k.val)).integer))) at raw
  rw [C99NatWord141.integer a bound,C99NatWord141.integer k.val (by have h:=k.isLt; omega)] at raw
  have sum : (a : Int)+(k.val : Int)=((a+k.val : Nat) : Int) := by omega
  rw [sum,BitVec.ofInt_natCast] at raw
  exact raw

theorem literal (s : State) (k : Fin 4) : scalar s (.literal .i32 k.val) (.int32 (small k)) := by
  fin_cases k <;> exact .literal .int32 _

theorem add (s : State) (left : CLogic.Expr) (a : Nat) (k : Fin 4) (bound : a<2^64)
    (first : scalar s left (.uint64 (word a))) :
    scalar s (.bin .add left (.literal .i32 k.val)) (.uint64 (word (a+k.val))) :=
  .arithmetic .plus _ _ _ _ _ first (literal s k) (add_word a k bound)

theorem update (program : C99ProcedureReference.Program) (s : State) (name : C99ArrayReference.Name)
    (a : Nat) (k : Fin 4) (bound : a<2^64) (cell : C99LoopScalar141.Cell s name a) :
    C99ProcedureReference.Exec program (.base (.scalar (.update name .add (.literal .i32 k.val)))) s
      ⟨FftLocalCells140.put s name (word (a+k.val)),.normal⟩ :=
  C99LoopAssign142.update program s name .add (.literal .i32 k.val) a (word (a+k.val)) cell
    (add s (.var name) a k bound (C99LoopScalar141.read s name a cell))

end FT1536.Source3.C99SmallLiteral146
