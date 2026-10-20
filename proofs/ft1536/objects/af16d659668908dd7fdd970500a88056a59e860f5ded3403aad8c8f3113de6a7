import Source3.SmallintsProgram
import Source3.C99CountedWords

namespace FT1536.Source3.SmallintsCounter
open C99ArrayReference (State)
open C99ProcedureReference (Exec Result)
open C99CountedWords

def advanced (s : State) (i : Nat) : State :=
  {s with locals := C99ScalarReference.set s.locals "u".toList (.uint64,some (.uint64 (BitVec.ofNat 64 (i+1))))}

theorem source_increment (before : State) (i : Nat) (result : Result)
    (hi : i≤1536) (counter : Counter before i)
    (source : Exec FftProcedurePrograms.program SmallintsProgram.increment before result) :
    result=⟨advanced before i,.normal⟩ := by
  cases source with
  | base _ _ _ execution =>
      cases execution with
      | scalar before env statement body =>
          obtain ⟨ty,old,value,declared,evaluated,he⟩ := C99ControlInversion.assign_inv _ _ _ _ _ body
          have htype : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
          subst ty
          change C99ScalarReference.Eval _ _ (.arithmetic .plus (.variable "u".toList) (.literal .int32 1)) value at evaluated
          have hv : value=.uint64 (BitVec.ofNat 64 (i+1)) := by
            cases evaluated with
            | arithmetic _ _ _ x y z hx hy operation =>
                have hu := variable_exact before "u".toList .uint64 (.uint64 (BitVec.ofNat 64 i)) x counter hx
                subst x
                cases hy
                exact add_one i hi value operation
          have henv := C99ScalarReference.Result.normal.inj he
          rw [hv] at henv
          change env=C99ScalarReference.set before.locals "u".toList
            (.uint64,some (C99IntegerReference.convert (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 (i+1))).type
              (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 (i+1))).integer)) at henv
          rw [convert_self] at henv
          rw [henv]
          rfl

theorem advanced_counter (before : State) (i : Nat) : Counter (advanced before i) (i+1) := by
  simp [Counter,advanced,C99ScalarReference.set]
theorem advanced_limit (before : State) (i : Nat) (limit : Limit before) : Limit (advanced before i) := by
  simpa [Limit,advanced,C99ScalarReference.set] using limit

end FT1536.Source3.SmallintsCounter
