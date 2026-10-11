import WordRAM020
set_option maxRecDepth 32768
set_option exponentiation.threshold 1024
namespace FT1536.S05.MemoryProbe020
open WordRAM020
#check atomRun.eq_1
#print atomRun
example (i : Input) (s : State) (a v : Expr) (k : Fin ramSize)
    (ha : address ramSize (eval s a) = some k) :
    atomRun i (.store a v) s = {s with ram := Function.update s.ram k (eval s v)} := by
  change (match address ramSize (eval s a) with
    | none => fail s
    | some j => {s with ram := Function.update s.ram j (eval s v)}) = _
  rw [ha]
end FT1536.S05.MemoryProbe020
