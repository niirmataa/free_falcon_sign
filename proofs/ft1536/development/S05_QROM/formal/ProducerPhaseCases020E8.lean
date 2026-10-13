import ProducerFlags020E8

namespace FT1536.S05.ProducerPhaseCases020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7

/-- Nat-indexed rewrite rule matches the circuit syntax directly; the Fin
    projection in the earlier theorem is kept inside this checked wrapper. -/
theorem phase (d : BoundaryPayload020E5.Data) (p : Nat) (hp : p<7) :
    eval (env d) (isPhase p)=if (CoreEncoding020E5.phaseTag d.core.phase).val=p then (1 : Word) else 0 :=
  ProducerFlags020E8.phase d ⟨p,hp⟩

theorem push_pending (d : BoundaryPayload020E5.Data) (k : Nat) (hk : k<11) :
    eval (env d) (pushPending k)=ProducerMetaWords020E8.pending (ProducerFlags020E8.afterPush d.core.pending) k :=
  ProducerFlags020E8.push_pending d ⟨k,hk⟩

end FT1536.S05.ProducerPhaseCases020E8
