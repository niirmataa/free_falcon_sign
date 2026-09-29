import B20.Word.SourceShift

namespace B20.Word
open B20.C

def brokenShiftFunction (middle final : Nat) : Function := {
  result := .u64
  name := "fpr_ursh".toList
  params := [(.u64, ['x']), (.i32, ['n'])]
  body := [
    .xorAssign ['x']
      (.bin .band (.bin .xor (.var ['x']) (.bin .shr (.var ['x']) (.literal middle)))
        (.neg (.cast .u64 (.bin .shr (.var ['n']) (.literal 5))))),
    .ret (.bin .shr (.var ['x']) (.bin .band (.var ['n']) (.literal final)))
  ]
}

/-- The changed constant is rejected by the *same* parser certificate. -/
theorem shift32_mutation_binding_rejected :
    parseFunction (slice B20.Pinned.headerLines 17 6) ≠ some (brokenShiftFunction 31 31) := by
  rw [pinned_ursh_parses]
  decide

/-- A legal input exposes the semantic effect of a 32→31 shift mutation. -/
theorem shift32_mutation_witness :
    execute (brokenShiftFunction 31 31)
      [.u64 0x8000000000000000, .i32 32] = some (.u64 0x100000000) ∧
    execute urshFunction [.u64 0x8000000000000000, .i32 32] = some (.u64 0x80000000) := by
  constructor <;> decide

theorem count_mask_mutation_witness :
    execute (brokenShiftFunction 32 30) [.u64 1, .i32 1] = some (.u64 1) ∧
    execute urshFunction [.u64 1, .i32 1] = some (.u64 0) := by
  constructor <;> decide

theorem signed_shift_differs_from_logical :
    (0xffffffffffffffff : BitVec 64).sshiftRight 1 = 0xffffffffffffffff ∧
    (0xffffffffffffffff : BitVec 64) >>> 1 = 0x7fffffffffffffff := by
  constructor <;> decide

theorem c_invalid_count_rejected :
    shift .shr (.u64 1) 64 = none ∧ shift .shr (.u64 1) 0xffffffff = none := by
  constructor <;> decide

theorem c_signed_negation_overflow_rejected :
    B20.C.neg (.i64 0x8000000000000000) = none ∧
    B20.C.neg (.i32 0x80000000) = none := by
  constructor <;> decide

theorem parser_unsupported_operator_rejected : tokenize 10 ['x', '+', '1'] = none := by decide

#print axioms shift32_mutation_binding_rejected
#print axioms shift32_mutation_witness
#print axioms count_mask_mutation_witness
#print axioms signed_shift_differs_from_logical
#print axioms c_invalid_count_rejected
#print axioms c_signed_negation_overflow_rejected
#print axioms parser_unsupported_operator_rejected

end B20.Word
