import ProducerActSource020E10

namespace FT1536.S05.ProducerActRows020E10
open WordRAM020 ProducerExpr020E6 ProducerReference020E7 ProducerCoreCircuit020E6

theorem row17 (d : BoundaryPayload020E5.Data) : eval (env d) (w 17)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.top d) := by
  exact (word_read d 17 (by decide)).trans (by rfl)

theorem row18 (d : BoundaryPayload020E5.Data) : eval (env d) (w 18)=((ProducerSnapshot020E6.top d).map (fun f => BankStorage020E3.frameWords f 0)).getD 0 := by
  exact (word_read d 18 (by decide)).trans (by rfl)

theorem row19 (d : BoundaryPayload020E5.Data) : eval (env d) (w 19)=((ProducerSnapshot020E6.top d).map (fun f => BankStorage020E3.frameWords f 1)).getD 0 := by
  exact (word_read d 19 (by decide)).trans (by rfl)

theorem row20 (d : BoundaryPayload020E5.Data) : eval (env d) (w 20)=((ProducerSnapshot020E6.top d).map (fun f => BankStorage020E3.frameWords f 2)).getD 0 := by
  exact (word_read d 20 (by decide)).trans (by rfl)

theorem row31 (d : BoundaryPayload020E5.Data) : eval (env d) (w 31)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.actNode d) := by
  exact (word_read d 31 (by decide)).trans (by rfl)

theorem row32 (d : BoundaryPayload020E5.Data) : eval (env d) (w 32)=ProducerSnapshot020E6.field (ProducerSnapshot020E6.actNode d) 0 := by
  exact (word_read d 32 (by decide)).trans (by rfl)

theorem row33 (d : BoundaryPayload020E5.Data) : eval (env d) (w 33)=ProducerSnapshot020E6.field (ProducerSnapshot020E6.actNode d) 1 := by
  exact (word_read d 33 (by decide)).trans (by rfl)

theorem row34 (d : BoundaryPayload020E5.Data) : eval (env d) (w 34)=ProducerSnapshot020E6.field (ProducerSnapshot020E6.actNode d) 2 := by
  exact (word_read d 34 (by decide)).trans (by rfl)

theorem row35 (d : BoundaryPayload020E5.Data) : eval (env d) (w 35)=ProducerSnapshot020E6.field (ProducerSnapshot020E6.actNode d) 3 := by
  exact (word_read d 35 (by decide)).trans (by rfl)

theorem row36 (d : BoundaryPayload020E5.Data) : eval (env d) (w 36)=ProducerSnapshot020E6.field (ProducerSnapshot020E6.actNode d) 4 := by
  exact (word_read d 36 (by decide)).trans (by rfl)

theorem row37 (d : BoundaryPayload020E5.Data) : eval (env d) (w 37)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.actValue d 0) := by
  exact (word_read d 37 (by decide)).trans (by rfl)

theorem row38 (d : BoundaryPayload020E5.Data) : eval (env d) (w 38)=ProducerSnapshot020E6.value (ProducerSnapshot020E6.actValue d 0) := by
  exact (word_read d 38 (by decide)).trans (by rfl)

theorem row39 (d : BoundaryPayload020E5.Data) : eval (env d) (w 39)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.actValue d 1) := by
  exact (word_read d 39 (by decide)).trans (by rfl)

theorem row40 (d : BoundaryPayload020E5.Data) : eval (env d) (w 40)=ProducerSnapshot020E6.value (ProducerSnapshot020E6.actValue d 1) := by
  exact (word_read d 40 (by decide)).trans (by rfl)

theorem row41 (d : BoundaryPayload020E5.Data) : eval (env d) (w 41)=ProducerSnapshot020E6.present (ProducerSnapshot020E6.actValue d 2) := by
  exact (word_read d 41 (by decide)).trans (by rfl)

theorem row42 (d : BoundaryPayload020E5.Data) : eval (env d) (w 42)=ProducerSnapshot020E6.value (ProducerSnapshot020E6.actValue d 2) := by
  exact (word_read d 42 (by decide)).trans (by rfl)

theorem row43 (d : BoundaryPayload020E5.Data) : eval (env d) (w 43)=ProducerSnapshot020E6.memoryValue d 0 := by
  exact (word_read d 43 (by decide)).trans (by rfl)

theorem row44 (d : BoundaryPayload020E5.Data) : eval (env d) (w 44)=ProducerSnapshot020E6.memoryValue d 1 := by
  exact (word_read d 44 (by decide)).trans (by rfl)

theorem row45 (d : BoundaryPayload020E5.Data) : eval (env d) (w 45)=ProducerSnapshot020E6.memoryValue d 2 := by
  exact (word_read d 45 (by decide)).trans (by rfl)

end FT1536.S05.ProducerActRows020E10
