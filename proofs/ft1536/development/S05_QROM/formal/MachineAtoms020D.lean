import StoreExpressions020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.MachineAtoms020D
open WordRAM020 PairProgram020 ReadSemantics020A PairStores020B

def ramPut (s : State) (k : Fin ramSize) (w : Word) : State :=
  {s with ram := Function.update s.ram k w}

theorem exec_ram (i : Input) (s : State) (dst : Reg) (e : Expr) :
    exec i (loadRAM dst e) s=(match address ramSize (eval s e) with
      | none => fail s | some k => put s dst (s.ram k)) := rfl
theorem exec_rom (i : Input) (s : State) (dst : Reg) (e : Expr) :
    exec i (loadROM dst e) s=(match address romSize (eval s e) with
      | none => fail s | some k => put s dst (i.rom k)) := rfl

theorem load_ram_at (i : Input) (s : State) (dst : Reg) (e : Expr) (k : Fin ramSize)
    (he : eval s e=word (k.val:Int)) : exec i (loadRAM dst e) s=put s dst (s.ram k) := by
  rw [exec_ram,he,address_exact ramSize k.val k.isLt (by have := k.isLt;unfold ramSize at this;norm_num;omega)]

theorem load_rom_at (i : Input) (s : State) (dst : Reg) (e : Expr) (k : Fin romSize)
    (he : eval s e=word (k.val:Int)) : exec i (loadROM dst e) s=put s dst (i.rom k) := by
  rw [exec_rom,he,address_exact romSize k.val k.isLt (by have := k.isLt;unfold romSize at this;norm_num;omega)]

theorem store_at (i : Input) (s : State) (a v : Expr) (k : Fin ramSize)
    (ha : eval s a=word (k.val:Int)) : exec i (store a v) s=ramPut s k (eval s v) := by
  rw [exec_store,ha,address_exact ramSize k.val k.isLt (by have := k.isLt;unfold ramSize at this;norm_num;omega)]
  rfl

theorem ramPut_same (s : State) (k : Fin ramSize) (w : Word) : (ramPut s k w).ram k=w := by
  simp [ramPut]
theorem ramPut_other (s : State) (k j : Fin ramSize) (w : Word) (hj : j≠k) :
    (ramPut s k w).ram j=s.ram j := by simp [ramPut,Function.update,hj]

end FT1536.S05.MachineAtoms020D
