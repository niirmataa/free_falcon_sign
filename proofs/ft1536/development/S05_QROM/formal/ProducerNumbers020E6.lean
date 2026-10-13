import ProducerMemory020E6
import ProducerWindow020E6
import ProducerCoreSlots020E6
import ProducerProgram020E6

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
namespace FT1536.S05.ProducerNumbers020E6

theorem window_size : ProducerBatch020E6.size ProducerWindow020E6.cells=3469 := by decide +kernel
theorem slot_size : ProducerBatch020E6.size ProducerCoreSlots020E6.cells=11264 := by decide +kernel

theorem window_fits : ProducerBatch020E6.size ProducerWindow020E6.cells<2^511 := by rw [window_size];decide +kernel
theorem slot_fits : ProducerBatch020E6.size ProducerCoreSlots020E6.cells<2^511 := by rw [slot_size];decide +kernel

/-- Actual stored working payload, including IR and fetch/execute phase. -/
theorem payload_bytes : 64*(186 : Nat)=11904 := by decide +kernel

theorem window_increment : 22*ProducerBatch020E6.size ProducerWindow020E6.cells+190=76508 := by rw [window_size]
theorem slot_increment : 22*ProducerBatch020E6.size ProducerCoreSlots020E6.cells+190=247998 := by rw [slot_size]

end FT1536.S05.ProducerNumbers020E6
