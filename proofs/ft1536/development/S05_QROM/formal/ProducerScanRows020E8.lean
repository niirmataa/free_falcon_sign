import ProducerScanSpec020E8

namespace FT1536.S05.ProducerScanRows020E8
open WordRAM020 ProducerExpr020E6 ProducerReference020E7 ProducerCoreCircuit020E6

theorem row21 (d : BoundaryPayload020E5.Data) : eval (env d) (w 21)=ProducerSnapshot020E6.field (ProducerSnapshot020E6.scanNode d) 0 := by
  exact (word_read d 21 (by decide)).trans (by rfl)

theorem row22 (d : BoundaryPayload020E5.Data) : eval (env d) (w 22)=ProducerSnapshot020E6.field (ProducerSnapshot020E6.scanNode d) 1 := by
  exact (word_read d 22 (by decide)).trans (by rfl)

theorem row26 (d : BoundaryPayload020E5.Data) : eval (env d) (w 26)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanValue d 0) := by
  exact (word_read d 26 (by decide)).trans (by rfl)

theorem row27 (d : BoundaryPayload020E5.Data) : eval (env d) (w 27)=ProducerSnapshot020E6.value (ProducerSnapshot020E6.scanValue d 0) := by
  exact (word_read d 27 (by decide)).trans (by rfl)

theorem row28 (d : BoundaryPayload020E5.Data) : eval (env d) (w 28)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanValue d 1) := by
  exact (word_read d 28 (by decide)).trans (by rfl)

theorem row29 (d : BoundaryPayload020E5.Data) : eval (env d) (w 29)=ProducerSnapshot020E6.value (ProducerSnapshot020E6.scanValue d 1) := by
  exact (word_read d 29 (by decide)).trans (by rfl)

theorem row30 (d : BoundaryPayload020E5.Data) : eval (env d) (w 30)=ProducerSnapshot020E6.regValue d := by
  exact (word_read d 30 (by decide)).trans (by rfl)

theorem row46 (d : BoundaryPayload020E5.Data) : eval (env d) (w 46)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanNode d) := by
  exact (word_read d 46 (by decide)).trans (by rfl)

end FT1536.S05.ProducerScanRows020E8
