import WordRAM020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.MemoryFrames020
open WordRAM020

/-- Explicit transition equations avoid demand-generating the compiler's
    large-word equation simp theorem. These are definitionally true. -/
theorem store_step (i : Input) (s : State) (a v : Expr) :
    atomRun i (.store a v) s = (match address ramSize (eval s a) with
    | none => fail s
    | some k => {s with ram := Function.update s.ram k (eval s v)}) := rfl

theorem emit_step (i : Input) (s : State) (a v : Expr) :
    atomRun i (.emit a v) s = (match address outputSize (eval s a) with
    | none => fail s
    | some k => {s with out := Function.update s.out k (eval s v != 0)}) := rfl

theorem rom_step (i : Input) (s : State) (r : Reg) (a : Expr) :
    atomRun i (.loadROM r a) s = (match address romSize (eval s a) with
    | none => fail s | some k => put s r (i.rom k)) := rfl

theorem ram_step (i : Input) (s : State) (r : Reg) (a : Expr) :
    atomRun i (.loadRAM r a) s = (match address ramSize (eval s a) with
    | none => fail s | some k => put s r (s.ram k)) := rfl

theorem bit_step (i : Input) (s : State) (r : Reg) (a : Expr) :
    atomRun i (.loadBit r a) s = (match address tapeSize (eval s a) with
    | none => fail s | some k => put s r (if i.tape k then 1 else 0)) := rfl

/-- Typed banks give disjoint tape/table/data/output namespaces. -/
theorem store_frame (i : Input) (s : State) (a v : Expr) (k : Fin ramSize)
    (ha : address ramSize (eval s a) = some k) :
    (atomRun i (.store a v) s).reg = s.reg ∧
    (atomRun i (.store a v) s).out = s.out ∧
    (atomRun i (.store a v) s).fault = s.fault := by
  simp [store_step,ha]

theorem store_read_same (i : Input) (s : State) (a v : Expr) (k : Fin ramSize)
    (ha : address ramSize (eval s a) = some k) :
    (atomRun i (.store a v) s).ram k = eval s v := by
  simp [store_step,ha]

theorem store_read_other (i : Input) (s : State) (a v : Expr) (k j : Fin ramSize)
    (ha : address ramSize (eval s a) = some k) (hne : j ≠ k) :
    (atomRun i (.store a v) s).ram j = s.ram j := by
  simp [store_step,ha,Function.update,hne]

theorem emit_frame (i : Input) (s : State) (a v : Expr) (k : Fin outputSize)
    (ha : address outputSize (eval s a) = some k) :
    (atomRun i (.emit a v) s).reg = s.reg ∧
    (atomRun i (.emit a v) s).ram = s.ram ∧
    (atomRun i (.emit a v) s).fault = s.fault := by
  simp [emit_step,ha]

theorem load_rom (i : Input) (s : State) (a : Expr) (k : Fin romSize) (dst : Reg)
    (ha : address romSize (eval s a) = some k) :
    atomRun i (.loadROM dst a) s = put s dst (i.rom k) := by simp [rom_step,ha]

theorem load_ram (i : Input) (s : State) (a : Expr) (k : Fin ramSize) (dst : Reg)
    (ha : address ramSize (eval s a) = some k) :
    atomRun i (.loadRAM dst a) s = put s dst (s.ram k) := by simp [ram_step,ha]

theorem load_bit (i : Input) (s : State) (a : Expr) (k : Fin tapeSize) (dst : Reg)
    (ha : address tapeSize (eval s a) = some k) :
    atomRun i (.loadBit dst a) s = put s dst (if i.tape k then 1 else 0) := by
  simp [bit_step,ha]

theorem invalid_store_fault (i : Input) (s : State) (a v : Expr)
    (ha : address ramSize (eval s a) = none) :
    (atomRun i (.store a v) s).fault = true := by simp [store_step,ha,fail]

theorem invalid_load_fault (i : Input) (s : State) (a : Expr) (r : Reg)
    (ha : address tapeSize (eval s a) = none) :
    (atomRun i (.loadBit r a) s).fault = true := by simp [bit_step,ha,fail]

theorem atom_fault_sticky (i : Input) (a : Atom) (s : State) (h : s.fault = true) :
    (atomRun i a s).fault = true := by
  cases a with
  | set r e => exact h
  | loadROM r a => rw [rom_step]; split <;> simp [fail,put,h]
  | loadRAM r a => rw [ram_step]; split <;> simp [fail,put,h]
  | loadBit r a => rw [bit_step]; split <;> simp [fail,put,h]
  | store a v => rw [store_step]; split <;> simp [fail,h]
  | emit a v => rw [emit_step]; split <;> simp [fail,h]

theorem iterate_fault_sticky (f : State → State × Nat) (g : Expr)
    (hf : ∀ s, s.fault = true → (f s).1.fault = true) (n : Nat) (s : State)
    (hs : s.fault = true) : (iterate f g n s).1.fault = true := by
  induction n generalizing s with
  | zero => exact hs
  | succ n ih =>
    simp only [iterate]
    split
    · exact hs
    · exact ih (f s).1 (hf s hs)

theorem fault_sticky (i : Input) (p : Code) (s : State) (h : s.fault = true) :
    (run i p s).1.fault = true := by
  induction p generalizing s with
  | atom a => exact atom_fault_sticky i a s h
  | seq a b ha hb => exact hb _ (ha s h)
  | branch e a b ha hb =>
    simp only [run]
    split
    · exact hb s h
    · exact ha s h
  | loop cap g b ih => exact iterate_fault_sticky (run i b) g ih cap s h

end FT1536.S05.MemoryFrames020
