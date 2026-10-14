import ProducerActDecision020E10
import ProducerActOutcome020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerControlAct020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActSource020E10 ProducerMetaWords020E8 ProducerWordLaws020E6 CoreEncoding020E5
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem fault_word (old : Bool) (e : MemoryEdit020E5.Edit) :
    (if op .eq (MemoryEdit020E5.words e 0) (word 1)=0 then WordCodec020E5.boolWord old else (1 : Word))=
      WordCodec020E5.boolWord (CoreControl020E5.faultAfter old e) := by
  cases e <;> rfl

theorem rejected (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (hr : result d=none) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  have hok : eval (env d) actionOK=0 := (ProducerActDecision020E10.correct d).1.trans (by rw [hr];rfl)
  rw [ProducerActOutcome020E10.control_eq d hp,hr]
  fin_cases j
  all_goals simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,not_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,hok,
    read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),ProducerActOutcome020E10.control,words,metadata]
  all_goals rfl

theorem accepted (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act)
    (p : FixedAction020E5.Pending 877) (e : MemoryEdit020E5.Edit) (hr : result d=some (p,e)) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  have hok : eval (env d) actionOK=1 := (ProducerActDecision020E10.correct d).1.trans (by rw [hr];rfl)
  have he := ((ProducerActDecision020E10.correct d).2 p e hr).1.1
  have hl := pred_nat (env d) (w 2) d.core.left.val (lt_trans d.core.left.isLt (by norm_num)) (read_control d 2 (by decide))
  have hs := pred_nat (env d) (w 3) d.core.frames.sp.val (lt_trans d.core.frames.sp.isLt (by norm_num)) (read_control d 3 (by decide))
  rw [ProducerActOutcome020E10.control_eq d hp,hr]
  fin_cases j
  all_goals simp only [nextMeta,nextPhase,nextCursor,choose_eval,and_eval,not_eval,eq_eval,literal,
    ProducerPhaseCases020E8.phase d 0 (by decide),ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),ProducerPhaseCases020E8.phase d 3 (by decide),ProducerPhaseCases020E8.phase d 4 (by decide),hp,phaseTag,hok,he,hl,hs,
    ProducerActDecision020E10.pending d p e hr 0 (by decide),ProducerActDecision020E10.pending d p e hr 1 (by decide),ProducerActDecision020E10.pending d p e hr 2 (by decide),ProducerActDecision020E10.pending d p e hr 3 (by decide),ProducerActDecision020E10.pending d p e hr 4 (by decide),ProducerActDecision020E10.pending d p e hr 5 (by decide),ProducerActDecision020E10.pending d p e hr 6 (by decide),ProducerActDecision020E10.pending d p e hr 7 (by decide),ProducerActDecision020E10.pending d p e hr 8 (by decide),ProducerActDecision020E10.pending d p e hr 9 (by decide),ProducerActDecision020E10.pending d p e hr 10 (by decide),
    read_control d 1 (by decide),read_control d 2 (by decide),read_control d 3 (by decide),read_control d 4 (by decide),read_control d 5 (by decide),read_control d 6 (by decide),read_control d 7 (by decide),read_control d 8 (by decide),read_control d 9 (by decide),read_control d 10 (by decide),read_control d 11 (by decide),read_control d 12 (by decide),read_control d 13 (by decide),read_control d 14 (by decide),read_control d 15 (by decide),ProducerActOutcome020E10.control,words,metadata]
  all_goals first | rfl | exact fault_word d.core.state.fault e

theorem correct (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (j : Fin 16) :
    eval (env d) (nextMeta j.val)=words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  cases hr : result d with
  | none => exact rejected d hp hr j
  | some r => exact accepted d hp r.1 r.2 hr j

end FT1536.S05.ProducerControlAct020E10
