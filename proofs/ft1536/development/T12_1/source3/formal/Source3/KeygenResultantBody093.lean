import Source3.KeygenWordRename093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantBody093
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenResultantSource

theorem setup_checked : C99SimpleModular091.checkedCode setup = true := by decide
theorem packing_checked : KeygenWordDeterminism093.checkedCode packing = true := by decide
theorem part0_checked : KeygenWordDeterminism093.checkedCode (part 0) = true := by decide
theorem part1_checked : KeygenWordDeterminism093.checkedCode (part 1) = true := by decide
theorem part2_checked : KeygenWordDeterminism093.checkedCode (part 2) = true := by decide
theorem part3_checked : KeygenWordDeterminism093.checkedCode (part 3) = true := by decide
theorem part4_checked : KeygenWordDeterminism093.checkedCode (part 4) = true := by decide
theorem part5_checked : KeygenWordDeterminism093.checkedCode (part 5) = true := by decide
theorem part6_checked : KeygenWordDeterminism093.checkedCode (part 6) = true := by decide
theorem part7_checked : KeygenWordDeterminism093.checkedCode (part 7) = true := by decide
theorem part8_checked : KeygenWordDeterminism093.checkedCode (part 8) = true := by decide
theorem part_checked (i : Fin 9) : KeygenWordDeterminism093.checkedCode (part i) = true := by
  fin_cases i
  · exact part0_checked
  · exact part1_checked
  · exact part2_checked
  · exact part3_checked
  · exact part4_checked
  · exact part5_checked
  · exact part6_checked
  · exact part7_checked
  · exact part8_checked
theorem tail_checked : KeygenWordDeterminism093.checkedCode tailCode = true := by decide

theorem chain_checked (codes : List KeygenWordExec.Stmt)
    (checked : ∀ code ∈ codes, KeygenWordDeterminism093.checkedCode code = true) :
    KeygenWordDeterminism093.checkedCode (KeygenWordExec.chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons code rest ih =>
      exact Bool.and_eq_true_iff.mpr ⟨checked code (by simp), ih (fun c member => checked c (by simp [member]))⟩

theorem switch_checked (word : BitVec 32) : KeygenWordDeterminism093.checkedCode (switchCode word) = true := by
  unfold switchCode
  split
  · apply chain_checked
    intro code member
    obtain ⟨i, rfl⟩ := List.mem_ofFn.mp (List.mem_of_mem_drop member)
    exact part_checked i
  · rfl

/-- Exactly the body premises of the existing source Call, for a fixed
    bound state and automatic-object identifier. -/
inductive Body (bound : State) (block : Nat) : Result → Value → Prop where
  | run (ready packed reduced : State) (out : Result) (word : BitVec 32) (v : Value)
      (initial : C99ModularReference.Exec setup (entry bound block) ⟨ready, .normal⟩)
      (legal : ZeroLegal ready.heap block)
      (pack : KeygenWordExec.Exec packing {ready with heap := zeroed ready.heap block} ⟨packed, .normal⟩)
      (read : C99ArrayReference.scalar packed (.var "logn".toList) (.uint32 word))
      (fallthrough : KeygenWordExec.Exec (switchCode word) packed ⟨reduced, .normal⟩)
      (tail : KeygenWordExec.Exec tailCode reduced out)
      (returned : C99ProcedureReference.ReturnValue (some .uint32) out.flow (some v)) : Body bound block out v

theorem return_unique (ty : C99IntegerReference.Ty) (flow : C99ProcedureReference.Flow) (a b : Value)
    (first : C99ProcedureReference.ReturnValue (some ty) flow (some a))
    (second : C99ProcedureReference.ReturnValue (some ty) flow (some b)) : a = b := by
  cases first
  cases second
  rfl

theorem body_unique (bound : State) (block : Nat) (a b : Result) (x y : Value)
    (first : Body bound block a x) (second : Body bound block b y) : a = b ∧ x = y := by
  cases first
  cases second
  have setupUnique := C99SimpleModular091.execution C99ModularReference.ModCall setup (entry bound block)
  have packUnique := KeygenWordDeterminism093.execution packing
  have tailUnique := KeygenWordDeterminism093.execution tailCode
  have switchUnique : ∀ word before a b, KeygenWordExec.Exec (switchCode word) before a →
      KeygenWordExec.Exec (switchCode word) before b → a = b :=
    fun word before a b => KeygenWordDeterminism093.execution _ before a b (switch_checked word)
  grind only [setup_checked, packing_checked, tail_checked, C99ScalarCallsDeterminism089.array_scalar, return_unique]

end FT1536.Source3.KeygenResultantBody093
