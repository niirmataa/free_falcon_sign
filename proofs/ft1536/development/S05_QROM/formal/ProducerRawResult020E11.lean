import ProducerRawDriver020E11

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerRawResult020E11
open WordRAM020 ArrayBank020E4 ProducerRawCore020E11 ProducerBankRead020E6 ProducerCoreRead020E6

/-- Finite final-state readout, not used to reconstruct intermediate Core states.
    Any allocation/copy cost of this readout is still part of the open resources task. -/
def readout (m : Memory) : ArrayState020E4.State :=
  ⟨load (fun r => read m (regPtr (cap:=877) (capacity:=28941) r)),
    load (fun a => read m (ramPtr (cap:=877) (capacity:=28941) a)),
    load (fun a => decide (read m (outPtr (cap:=877) (capacity:=28941) a)=1)),
    decide (read m (metaPtr 15)=1)⟩

def result (m : Memory) : Option ArrayState020E4.State :=
  if ProducerRawDriver020E11.phase m=word 5 then some (readout m) else none

/-- Outer none is consumer/encoding failure. Inner none is the unchanged old
    failure/incomplete-run result; the two cases are never silently identified. -/
def run (c : Context) (fuel : Nat) (m : Memory) : Option (Option ArrayState020E4.State) :=
  (ProducerRawDriver020E11.run c fuel m).map result

theorem bool_read (b : Bool) : decide (WordCodec020E5.boolWord b=(1 : Word))=b := by
  cases b <;> rfl

theorem readout_image (q : ProducerRawCore020E11.Core) : readout (ProducerRawCore020E11.image q)=q.state := by
  have hr : load (fun r => read (ProducerRawCore020E11.image q) (regPtr (cap:=877) (capacity:=28941) r))=q.state.reg := by
    apply Eq.trans _ (load_read q.state.reg)
    apply congrArg load
    funext r
    exact reg_read hc hf hl q r
  have hm : load (fun a => read (ProducerRawCore020E11.image q) (ramPtr (cap:=877) (capacity:=28941) a))=q.state.ram := by
    apply Eq.trans _ (load_read q.state.ram)
    apply congrArg load
    funext a
    exact ram_read hc hf hl q a
  have ho : load (fun a => decide (read (ProducerRawCore020E11.image q) (outPtr (cap:=877) (capacity:=28941) a)=1))=q.state.out := by
    apply Eq.trans _ (load_read q.state.out)
    apply congrArg load
    funext a
    have h := out_read hc hf hl q a
    exact (congrArg (fun w : Word => decide (w=1)) h).trans (bool_read _)
  have hfw : read (ProducerRawCore020E11.image q) (metaPtr 15)=WordCodec020E5.boolWord q.state.fault :=
    (meta_read q 15).trans (by rfl)
  unfold readout
  rw [hr,hm,ho,hfw,bool_read]

theorem result_image (q : ProducerRawCore020E11.Core) : result (ProducerRawCore020E11.image q)=CoreState020E5.result q := by
  rw [result,ProducerRawDriver020E11.phase_image,readout_image]
  cases hp : q.phase <;> simp only [CoreState020E5.result,hp] <;> rfl

theorem refines (d : BoundaryPayload020E5.Data) (fresh : Bool) (fuel : Nat) (q : ProducerRawCore020E11.Core) :
    run (ofData d fresh) fuel (ProducerRawCore020E11.image q)=
      some (CoreState020E5.result (CoreRun020E5.run d.parser.arena (ProducerSlotLayout020E7.input d) fuel q)) := by
  rw [run,ProducerRawDriver020E11.refines]
  simp only [Option.map_some,result_image]

end FT1536.S05.ProducerRawResult020E11
