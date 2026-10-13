import ProducerRegisterRead020E7
import ProducerMemoryWindow020E7
import ProducerStored020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerWindowSource020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerCoreView020E6

/-- Every field of the executed reader, for every typed resident source.
    No reachability, token validity or cache-success hypothesis. -/
theorem field (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 96) :
    eval (sources d fresh) (ProducerWindow020E6.cells j)=ProducerSnapshot020E6.fields d j := by
  fin_cases j
  · exact ProducerCoreSource020E6.control_eval d fresh 0
  · exact ProducerCoreSource020E6.control_eval d fresh 1
  · exact ProducerCoreSource020E6.control_eval d fresh 2
  · exact ProducerCoreSource020E6.control_eval d fresh 3
  · exact ProducerCoreSource020E6.control_eval d fresh 4
  · exact ProducerCoreSource020E6.control_eval d fresh 5
  · exact ProducerCoreSource020E6.control_eval d fresh 6
  · exact ProducerCoreSource020E6.control_eval d fresh 7
  · exact ProducerCoreSource020E6.control_eval d fresh 8
  · exact ProducerCoreSource020E6.control_eval d fresh 9
  · exact ProducerCoreSource020E6.control_eval d fresh 10
  · exact ProducerCoreSource020E6.control_eval d fresh 11
  · exact ProducerCoreSource020E6.control_eval d fresh 12
  · exact ProducerCoreSource020E6.control_eval d fresh 13
  · exact ProducerCoreSource020E6.control_eval d fresh 14
  · exact ProducerCoreSource020E6.control_eval d fresh 15
  · exact ProducerReads020E7.used_eval d fresh
  · exact ProducerTopRead020E7.top_present d fresh
  · exact ProducerTopRead020E7.top_field d fresh 0
  · exact ProducerTopRead020E7.top_field d fresh 1
  · exact ProducerTopRead020E7.top_field d fresh 2
  · exact ProducerScanRead020E7.scan_field d fresh 0
  · exact ProducerScanRead020E7.scan_field d fresh 1
  · exact ProducerScanRead020E7.scan_field d fresh 2
  · exact ProducerScanRead020E7.scan_field d fresh 3
  · exact ProducerScanRead020E7.scan_field d fresh 4
  · exact (ProducerScanValue020E7.first_correct d fresh).1
  · exact (ProducerScanValue020E7.first_correct d fresh).2
  · exact (ProducerScanValue020E7.second_correct d fresh).1
  · exact (ProducerScanValue020E7.second_correct d fresh).2
  · exact ProducerRegisterRead020E7.register_correct d fresh
  · exact ProducerActRead020E7.act_present d fresh
  · exact ProducerActRead020E7.act_field d fresh 0
  · exact ProducerActRead020E7.act_field d fresh 1
  · exact ProducerActRead020E7.act_field d fresh 2
  · exact ProducerActRead020E7.act_field d fresh 3
  · exact ProducerActRead020E7.act_field d fresh 4
  · exact (ProducerActValue020E7.first_correct d fresh).1
  · exact (ProducerActValue020E7.first_correct d fresh).2
  · exact (ProducerActValue020E7.second_correct d fresh).1
  · exact (ProducerActValue020E7.second_correct d fresh).2
  · exact (ProducerActValue020E7.third_correct d fresh).1
  · exact (ProducerActValue020E7.third_correct d fresh).2
  · exact ProducerMemoryWindow020E7.ram_correct d fresh
  · exact ProducerMemoryWindow020E7.rom_correct d fresh
  · exact ProducerMemoryWindow020E7.tape_correct d fresh
  · exact ProducerScanRead020E7.scan_present d fresh
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl
  · rfl

/-- Equality of full banks, not merely selected successful fields. -/
theorem window (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    ProducerPipeline020E6.window d fresh=load (ProducerSnapshot020E6.fields d) := by
  unfold ProducerPipeline020E6.window
  congr 1
  funext j
  exact field d fresh j

/-- The installed first-stage code produces the same reference bank. -/
theorem executed (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    (ProducerStored020E6.invoke (sources d fresh) ProducerStored020E6.windowCode).vm.output=load (ProducerSnapshot020E6.fields d) := by
  rw [ProducerStored020E6.windowCode,ProducerStored020E6.expression_output]
  exact window d fresh

end FT1536.S05.ProducerWindowSource020E7
