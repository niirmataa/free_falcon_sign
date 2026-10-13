import ProducerPhaseCases020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerControlPush020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7
open ProducerMetaWords020E8 ProducerEval020E7 ProducerFlags020E8 ProducerWordLaws020E6 CoreEncoding020E5
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem none (d : BoundaryPayload020E5.Data) (hp : d.core.phase=CoreState020E5.Phase.push) 
    (hpend : d.core.pending=.none) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  have hpres : eval (env d) pendingPresent=0 := by
    exact (pending_present d).trans (by rw [hpend];rfl)
  fin_cases j <;> simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,hpres,hpend,
    read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),CoreControl020E5.next,words,metadata]
  all_goals rfl

theorem one (d : BoundaryPayload020E5.Data) (hp : d.core.phase=CoreState020E5.Phase.push) (f : NodeFrames020E2.Frame 877)
    (hpend : d.core.pending=(.one f)) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  have hpres : eval (env d) pendingPresent=1 := by
    exact (pending_present d).trans (by rw [hpend];rfl)
  by_cases hr : d.core.frames.sp.val<28941
  all_goals fin_cases j
  all_goals simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,hpres,room d,sp_add d,
    read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),
    ProducerPhaseCases020E8.push_pending d 0 (by decide),ProducerPhaseCases020E8.push_pending d 1 (by decide),ProducerPhaseCases020E8.push_pending d 2 (by decide),ProducerPhaseCases020E8.push_pending d 3 (by decide),ProducerPhaseCases020E8.push_pending d 4 (by decide),ProducerPhaseCases020E8.push_pending d 5 (by decide),ProducerPhaseCases020E8.push_pending d 6 (by decide),ProducerPhaseCases020E8.push_pending d 7 (by decide),ProducerPhaseCases020E8.push_pending d 8 (by decide),ProducerPhaseCases020E8.push_pending d 9 (by decide),ProducerPhaseCases020E8.push_pending d 10 (by decide),
    CoreControl020E5.next,CoreControl020E5.pushMeta,words,metadata,hr,hpend,afterPush]
  all_goals simp

theorem two (d : BoundaryPayload020E5.Data) (hp : d.core.phase=CoreState020E5.Phase.push) (f g : NodeFrames020E2.Frame 877)
    (hpend : d.core.pending=(.two f g)) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  have hpres : eval (env d) pendingPresent=1 := by
    exact (pending_present d).trans (by rw [hpend];rfl)
  by_cases hr : d.core.frames.sp.val<28941
  all_goals fin_cases j
  all_goals simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,hpres,room d,sp_add d,
    read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),
    ProducerPhaseCases020E8.push_pending d 0 (by decide),ProducerPhaseCases020E8.push_pending d 1 (by decide),ProducerPhaseCases020E8.push_pending d 2 (by decide),ProducerPhaseCases020E8.push_pending d 3 (by decide),ProducerPhaseCases020E8.push_pending d 4 (by decide),ProducerPhaseCases020E8.push_pending d 5 (by decide),ProducerPhaseCases020E8.push_pending d 6 (by decide),ProducerPhaseCases020E8.push_pending d 7 (by decide),ProducerPhaseCases020E8.push_pending d 8 (by decide),ProducerPhaseCases020E8.push_pending d 9 (by decide),ProducerPhaseCases020E8.push_pending d 10 (by decide),
    CoreControl020E5.next,CoreControl020E5.pushMeta,words,metadata,hr,hpend,afterPush]
  all_goals simp

theorem control (d : BoundaryPayload020E5.Data) (hp : d.core.phase=CoreState020E5.Phase.push) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  cases hpend : d.core.pending with
  | none => exact none d hp hpend j
  | one f => exact one d hp f hpend j
  | two f g => exact two d hp f g hpend j

end FT1536.S05.ProducerControlPush020E8
