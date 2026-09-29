import B20.C.Parser
import B20.Word.Shift
import B20.Pinned.Header
import B20.Pinned.Slices
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

set_option maxRecDepth 16384
set_option maxHeartbeats 8000000

namespace B20.Word
open B20.C

def slice (lines : List String) (start count : Nat) : List Char :=
  ((lines.drop start).take count).flatMap String.toList

def shiftFunction (ty : Ty) (op : BinOp) (name : Name) : Function := {
  result := ty
  name := name
  params := [(ty, ['x']), (.i32, ['n'])]
  body := [
    .xorAssign ['x']
      (.bin .band (.bin .xor (.var ['x']) (.bin op (.var ['x']) (.literal 32)))
        (.neg (.cast ty (.bin .shr (.var ['n']) (.literal 5))))),
    .ret (.bin op (.var ['x']) (.bin .band (.var ['n']) (.literal 31)))
  ]
}

def urshFunction := shiftFunction .u64 .shr "fpr_ursh".toList
def irshFunction := shiftFunction .i64 .shr "fpr_irsh".toList
def ulshFunction := shiftFunction .u64 .shl "fpr_ulsh".toList

theorem pinned_ursh_slice : slice B20.Pinned.headerLines 17 6 = B20.Pinned.urshChars := by decide
theorem pinned_irsh_slice : slice B20.Pinned.headerLines 24 6 = B20.Pinned.irshChars := by decide
theorem pinned_ulsh_slice : slice B20.Pinned.headerLines 31 6 = B20.Pinned.ulshChars := by decide

theorem pinned_ursh_lex : tokenize (B20.Pinned.urshChars.length + 1) B20.Pinned.urshChars = some B20.Pinned.urshTokens := by decide
theorem pinned_irsh_lex : tokenize (B20.Pinned.irshChars.length + 1) B20.Pinned.irshChars = some B20.Pinned.irshTokens := by decide
theorem pinned_ulsh_lex : tokenize (B20.Pinned.ulshChars.length + 1) B20.Pinned.ulshChars = some B20.Pinned.ulshTokens := by decide

theorem pinned_ursh_syntax : parseFunctionTokens B20.Pinned.urshTokens = some urshFunction := by decide
theorem pinned_irsh_syntax : parseFunctionTokens B20.Pinned.irshTokens = some irshFunction := by decide
theorem pinned_ulsh_syntax : parseFunctionTokens B20.Pinned.ulshTokens = some ulshFunction := by decide

theorem pinned_ursh_parses :
    parseFunction (slice B20.Pinned.headerLines 17 6) = some urshFunction := by
  rw [parseFunction, pinned_ursh_slice, pinned_ursh_lex]
  exact pinned_ursh_syntax
theorem pinned_irsh_parses :
    parseFunction (slice B20.Pinned.headerLines 24 6) = some irshFunction := by
  rw [parseFunction, pinned_irsh_slice, pinned_irsh_lex]
  exact pinned_irsh_syntax
theorem pinned_ulsh_parses :
    parseFunction (slice B20.Pinned.headerLines 31 6) = some ulshFunction := by
  rw [parseFunction, pinned_ulsh_slice, pinned_ulsh_lex]
  exact pinned_ulsh_syntax

theorem ursh_execution (x : BitVec 64) (n : Fin 64) :
    execute urshFunction [.u64 x, .i32 (BitVec.ofNat 32 n.val)] =
      some (.u64 (ursh x n.val)) := by
  fin_cases n <;> rfl

theorem irsh_execution (x : BitVec 64) (n : Fin 64) :
    execute irshFunction [.i64 x, .i32 (BitVec.ofNat 32 n.val)] =
      some (.i64 (irsh x n.val)) := by
  fin_cases n <;> rfl

theorem ulsh_execution (x : BitVec 64) (n : Fin 64) :
    execute ulshFunction [.u64 x, .i32 (BitVec.ofNat 32 n.val)] =
      some (.u64 (ulsh x n.val)) := by
  fin_cases n <;> rfl

/-- From the kernel-parsed slice of the entire pinned header to a generic
checked C evaluator and then to the BitVec specification, for every word. -/
theorem pinned_ursh_refines (x : BitVec 64) (n : Fin 64) :
    ∃ f, parseFunction (slice B20.Pinned.headerLines 17 6) = some f ∧
      CExec f [.u64 x, .i32 (BitVec.ofNat 32 n.val)] (.u64 (x >>> n.val)) := by
  refine ⟨urshFunction, pinned_ursh_parses, ?_⟩
  unfold CExec
  rw [ursh_execution, ursh_refines x n.val n.isLt]

theorem pinned_irsh_refines (x : BitVec 64) (n : Fin 64) :
    ∃ f, parseFunction (slice B20.Pinned.headerLines 24 6) = some f ∧
      CExec f [.i64 x, .i32 (BitVec.ofNat 32 n.val)] (.i64 (x.sshiftRight n.val)) := by
  refine ⟨irshFunction, pinned_irsh_parses, ?_⟩
  unfold CExec
  rw [irsh_execution, irsh_refines x n.val n.isLt]

theorem pinned_ulsh_refines (x : BitVec 64) (n : Fin 64) :
    ∃ f, parseFunction (slice B20.Pinned.headerLines 31 6) = some f ∧
      CExec f [.u64 x, .i32 (BitVec.ofNat 32 n.val)] (.u64 (x <<< n.val)) := by
  refine ⟨ulshFunction, pinned_ulsh_parses, ?_⟩
  unfold CExec
  rw [ulsh_execution, ulsh_refines x n.val n.isLt]

#print axioms pinned_ursh_parses
#print axioms pinned_irsh_parses
#print axioms pinned_ulsh_parses
#print axioms pinned_ursh_refines
#print axioms pinned_irsh_refines
#print axioms pinned_ulsh_refines

end B20.Word
