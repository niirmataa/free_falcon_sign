import ProducerActSource020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActOutcome020E10
open WordRAM020 CoreEncoding020E5 FixedAction020E5 ProducerActSource020E10

def data (d : BoundaryPayload020E5.Data) (r : Option (Result 877)) :=
  match r with | none => d.core | some r => CoreData020E5.edit d.core r.2

def control (d : BoundaryPayload020E5.Data) (r : Option (Result 877)) : Meta 877 28941 1106642201817 :=
  match r with
  | none => (.bad,(d.core.cursor,(d.core.left,(d.core.frames.sp,(d.core.pending,d.core.state.fault)))))
  | some r => (.push,(d.core.cursor,(⟨d.core.left.val-1,by have := d.core.left.isLt;omega⟩,
      (⟨d.core.frames.sp.val-1,by have := d.core.frames.sp.isLt;omega⟩,(r.1,CoreControl020E5.faultAfter d.core.state.fault r.2)))))

theorem data_eq (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) :
    CoreData020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core=data d (result d) := by
  simp only [CoreData020E5.next,hp,result,ProducerSnapshot020E6.top]
  cases ht : ArrayFrames020E4.top d.core.frames with
  | none => rfl
  | some fr =>
    dsimp only
    simp only [Option.bind_some]
    cases action (ArrayValues020E4.lookup d.parser.arena d.core.values) d.parser.arena (ProducerSlotLayout020E7.input d) d.core.state fr <;> rfl

theorem control_eq (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) :
    CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core=control d (result d) := by
  simp only [CoreControl020E5.next,hp,result,ProducerSnapshot020E6.top]
  cases ht : ArrayFrames020E4.top d.core.frames with
  | none => rfl
  | some fr =>
    dsimp only
    simp only [Option.bind_some]
    cases action (ArrayValues020E4.lookup d.parser.arena d.core.values) d.parser.arena (ProducerSlotLayout020E7.input d) d.core.state fr <;> rfl

end FT1536.S05.ProducerActOutcome020E10
