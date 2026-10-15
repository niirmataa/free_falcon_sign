import ProducerCount020E13

namespace FT1536.S05.ProducerPairCount020E13
open WordRAM020 ArrayBank020E4 ProducerMachine020E6

/-- The second producer consumes the first producer's actual output. -/
def run {regions firstSize secondSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (firstCode : Bank (Instruction regions firstSize) firstSize)
    (secondCode : Bank (Instruction 1 secondSize) secondSize) : Bank Word 96 × Nat :=
  let a := ProducerCount020E13.invoke sources firstCode
  let b := ProducerCount020E13.invoke (ProducerComposition020E6.oneSource a.1.vm.output) secondCode
  (b.1.vm.output,a.2+b.2)

theorem value {regions firstSize secondSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (firstCode : Bank (Instruction regions firstSize) firstSize)
    (secondCode : Bank (Instruction 1 secondSize) secondSize) :
    (run sources firstCode secondCode).1=ProducerStored020E6.pairRun sources firstCode secondCode := by
  simp only [run,ProducerStored020E6.pairRun,ProducerCount020E13.invoke_value]

theorem bound {regions firstSize secondSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (firstCode : Bank (Instruction regions firstSize) firstSize)
    (secondCode : Bank (Instruction 1 secondSize) secondSize) :
    (run sources firstCode secondCode).2≤firstSize+secondSize :=
  Nat.add_le_add (ProducerCount020E13.invoke_bound sources firstCode)
    (ProducerCount020E13.invoke_bound _ secondCode)

theorem core_bound (sources : Sources ProducerCoreView020E6.extent) :
    (run sources ProducerStored020E6.windowCode ProducerStored020E6.slotCode).2≤14733 := by
  have h := bound sources ProducerStored020E6.windowCode ProducerStored020E6.slotCode
  exact h.trans_eq (by rw [ProducerNumbers020E6.window_size,ProducerNumbers020E6.slot_size])

end FT1536.S05.ProducerPairCount020E13
