import Source3.KeygenAttemptCap
import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCapWords
open C99IntegerReference
open C99ArrayReference (State)

def Count (s : State) (i : Nat) : Prop :=
  s.locals "local_attempts".toList=some (.uint64,some (.uint64 (BitVec.ofNat 64 i)))
def advanced (s : State) (i : Nat) : State :=
  {s with locals := C99ScalarReference.set s.locals "local_attempts".toList (.uint64,some (.uint64 (BitVec.ofNat 64 (i+1))))}

theorem increment_value (i : Nat) (hi : i≤KeygenAttemptCap.limit) (v : Value)
    (source : ArithmeticExec .plus (.uint64 (BitVec.ofNat 64 i)) (.int32 1) v) :
    v=.uint64 (BitVec.ofNat 64 (i+1)) := by
  have he := ((arithmetic_iff _ _ _ _).mp source).2
  change v=convert .uint64
    ((convert (Value.uint64 (BitVec.ofNat 64 i)).type (Value.uint64 (BitVec.ofNat 64 i)).integer).integer+1) at he
  rw [C99CountedWords.convert_self] at he
  have hnat : (BitVec.ofNat 64 i).toNat=i := Nat.mod_eq_of_lt (by dsimp [KeygenAttemptCap.limit] at hi; omega)
  change v=Value.uint64 (BitVec.ofInt 64 ((BitVec.ofNat 64 i).toNat+1)) at he
  rw [hnat] at he
  have hc : (i : Int)+1=((i+1 : Nat) : Int) := by omega
  rw [hc,BitVec.ofInt_natCast] at he
  exact he

theorem source_increment (program : C99ProcedureReference.Program) (before : State) (i : Nat)
    (result : C99ProcedureReference.Result) (hi : i≤KeygenAttemptCap.limit) (counter : Count before i)
    (source : C99ProcedureReference.Exec program KeygenAttemptCap.increment before result) :
    result=⟨advanced before i,.normal⟩ := by
  cases source with
  | base _ _ _ execution =>
      cases execution with
      | scalar state env statement body =>
          obtain ⟨ty,old,value,declared,evaluated,he⟩ := C99ControlInversion.assign_inv _ _ _ _ _ body
          have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
          subst ty
          change C99ScalarReference.Eval _ _ (.arithmetic .plus (.variable "local_attempts".toList) (.literal .int32 1)) value at evaluated
          have hv : value=.uint64 (BitVec.ofNat 64 (i+1)) := by
            cases evaluated with
            | arithmetic _ _ _ x y z hx hy operation =>
                have hu := C99CountedWords.variable_exact before "local_attempts".toList .uint64
                  (.uint64 (BitVec.ofNat 64 i)) x counter hx
                subst x
                cases hy
                exact increment_value i hi value operation
          have henv := C99ScalarReference.Result.normal.inj he
          rw [hv] at henv
          change env=C99ScalarReference.set before.locals "local_attempts".toList
            (.uint64,some (convert (Value.uint64 (BitVec.ofNat 64 (i+1))).type
              (Value.uint64 (BitVec.ofNat 64 (i+1))).integer)) at henv
          rw [C99CountedWords.convert_self] at henv
          rw [henv]
          rfl

theorem advanced_count (before : State) (i : Nat) : Count (advanced before i) (i+1) := by
  simp [Count,advanced,C99ScalarReference.set]

theorem guard_value (before : State) (i : Nat) (value : Value)
    (hi : i≤KeygenAttemptCap.limit+1) (counter : Count before i)
    (source : C99ArrayReference.scalar before KeygenAttemptCap.condition value) :
    value=C99ScalarReference.boolean (decide (KeygenAttemptCap.limit < i)) := by
  change C99ScalarReference.Eval _ _ (.compare .gt (.variable "local_attempts".toList) (.literal .int32 3000000)) value at source
  cases source with
  | compare op a b x y z hx hy operation =>
      have hv := C99CountedWords.variable_exact before "local_attempts".toList .uint64
        (.uint64 (BitVec.ofNat 64 i)) x counter hx
      subst x
      cases hy
      have he := C99CountedWords.comparison_result .gt (.uint64 (BitVec.ofNat 64 i)) (.int32 3000000) value operation
      change value=C99ScalarReference.boolean
        (compare .gt (convert (Value.uint64 (BitVec.ofNat 64 i)).type
          (Value.uint64 (BitVec.ofNat 64 i)).integer).integer 3000000) at he
      rw [C99CountedWords.convert_self] at he
      have hnat : (BitVec.ofNat 64 i).toNat=i := Nat.mod_eq_of_lt (by dsimp [KeygenAttemptCap.limit] at hi; omega)
      change value=C99ScalarReference.boolean (decide ((3000000 : Int)<((BitVec.ofNat 64 i).toNat : Int))) at he
      rw [hnat] at he
      have hlt : ((3000000 : Int)<(i : Int))↔KeygenAttemptCap.limit < i := by dsimp [KeygenAttemptCap.limit]; omega
      simpa only [hlt] using he

end FT1536.Source3.KeygenCapWords
