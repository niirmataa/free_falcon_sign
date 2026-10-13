import CostBank020E4
import CostFlow020E4
import ArrayState020E4

namespace FT1536.S05.CostState020E4
open WordRAM020 CostRun020E4 CostFlow020E4

def put (s : ArrayState020E4.State) (r : Reg) (w : Word) : Run ArrayState020E4.State := overhead 4
  (CostRun020E4.map (fun b => {s with reg := b}) (CostBank020E4.write 1 s.reg r w))

def store (s : ArrayState020E4.State) (k : Fin ramSize) (w : Word) : Run ArrayState020E4.State := overhead 4
  (CostRun020E4.map (fun b => {s with ram := b}) (CostBank020E4.write 1 s.ram k w))

def emit (s : ArrayState020E4.State) (k : Fin outputSize) (b : Bool) : Run ArrayState020E4.State := overhead 4
  (CostRun020E4.map (fun a => {s with out := a}) (CostBank020E4.write 1 s.out k b))

def fail (s : ArrayState020E4.State) : Run ArrayState020E4.State := charge 4 4 (ArrayState020E4.fail s)

def writePrice (n : Nat) : Nat := 4+CostBank020E4.writePrice n 1

theorem put_value (s : ArrayState020E4.State) (r : Reg) (w : Word) :
    (put s r w).value=ArrayState020E4.put s r w := by
  simp only [put,overhead,CostRun020E4.map,CostBank020E4.write_value]
  rfl

theorem store_value (s : ArrayState020E4.State) (k : Fin ramSize) (w : Word) :
    (store s k w).value=ArrayState020E4.store s k w := by
  simp only [store,overhead,CostRun020E4.map,CostBank020E4.write_value]
  rfl

theorem emit_value (s : ArrayState020E4.State) (k : Fin outputSize) (b : Bool) :
    (emit s k b).value=ArrayState020E4.emit s k b := by
  simp only [emit,overhead,CostRun020E4.map,CostBank020E4.write_value]
  rfl

theorem put_budget (s : ArrayState020E4.State) (r : Reg) (w : Word) :
    (put s r w).ticks=writePrice 32 ∧ (put s r w).allocated=writePrice 32 := ⟨rfl,rfl⟩

theorem store_budget (s : ArrayState020E4.State) (k : Fin ramSize) (w : Word) :
    (store s k w).ticks=writePrice ramSize ∧ (store s k w).allocated=writePrice ramSize := ⟨rfl,rfl⟩

theorem emit_budget (s : ArrayState020E4.State) (k : Fin outputSize) (b : Bool) :
    (emit s k b).ticks=writePrice outputSize ∧ (emit s k b).allocated=writePrice outputSize := ⟨rfl,rfl⟩

end FT1536.S05.CostState020E4
