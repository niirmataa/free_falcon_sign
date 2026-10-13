import ProducerPhaseCases020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerControlCheck020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7
open ProducerMetaWords020E8 ProducerEval020E7 ProducerFlags020E8 ProducerWordLaws020E6 CoreEncoding020E5
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem control (d : BoundaryPayload020E5.Data) (hp : d.core.phase=CoreState020E5.Phase.check) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  by_cases hs : d.core.frames.sp.val=0
  all_goals by_cases hl : d.core.left.val=0
  all_goals fin_cases j
  all_goals simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,not_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,sp_zero d,left_zero d,
    read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),
    CoreControl020E5.next,words,metadata,hs,hl]
  all_goals simp [op,word_zero,word_one,hs,hl]

end FT1536.S05.ProducerControlCheck020E8
