import ProducerPhaseCases020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerControlTerminal020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7
open ProducerMetaWords020E8 ProducerEval020E7 ProducerFlags020E8 ProducerWordLaws020E6 CoreEncoding020E5
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem done (d : BoundaryPayload020E5.Data) (hp : d.core.phase=CoreState020E5.Phase.done) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  fin_cases j <;> simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,
    read_control d 0 (by decide),read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),
    CoreControl020E5.next,words,metadata]
  all_goals simp

theorem bad (d : BoundaryPayload020E5.Data) (hp : d.core.phase=CoreState020E5.Phase.bad) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  fin_cases j <;> simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,
    read_control d 0 (by decide),read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),
    CoreControl020E5.next,words,metadata]
  all_goals simp

end FT1536.S05.ProducerControlTerminal020E8
