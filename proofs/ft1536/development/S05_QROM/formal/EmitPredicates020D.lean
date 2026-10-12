import EmitLoops020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.EmitPredicates020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D BufferField020D OutputValues020D
open EmitLoops020D
attribute [local irreducible] exec loopState

def Post (z : StandaloneRuntime019.CachedBox) (v : Coeffs) (s t : State) : Prop :=
  OutputChunks020D.Prefix (fun j => (keyValue z v j).val) 0 16 (by decide) 1536 t.out ∧
    OutputChunks020D.Prefix (replyValue z) 24577 17 (by decide) 1536 t.out ∧
    t.out EmitTag020D.position=true ∧ t.ram=s.ram ∧ t.fault=s.fault

theorem combine (s q t : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs)
    (key : OutputLoop020D.Good (fun j => (keyValue z v j).val) 0 16 (by decide) s 1536 q ∧
      OutputLoop020D.Frame 0 16 s q)
    (rep : OutputLoop020D.Good (replyValue z) 24577 17 (by decide) (EmitTag020D.result q) 1536 t ∧
      OutputLoop020D.Frame 24577 17 (EmitTag020D.result q) t) : Post z v s t := by
  refine ⟨?_,rep.1.2.2.1,?_,rep.2.1.trans ((EmitTag020D.frame q).1.trans key.2.1),
    rep.2.2.1.trans ((EmitTag020D.frame q).2.trans key.2.2.1)⟩
  · intro p hp j
    let a := OutputChunks020D.address 0 16 p j (by decide)
    have hb : a.val<24576 := by
      change 0+16*p.val+j.val<24576
      have := p.isLt;have := j.isLt;omega
    have hn : a≠EmitTag020D.position := by
      intro hh;have hv := congrArg Fin.val hh;change a.val=24576 at hv;omega
    exact (rep.2.2.2 a (Or.inl (by omega))).trans
      ((EmitTag020D.other q a hn).trans (key.1.2.2.1 p hp j))
  · exact (rep.2.2.2 EmitTag020D.position (Or.inl (by decide))).trans (EmitTag020D.tag_true q)

theorem after_key (i : Input) (s q : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z)
    (key : OutputLoop020D.Good (fun j => (keyValue z v j).val) 0 16 (by decide) s 1536 q ∧
      OutputLoop020D.Frame 0 16 s q) :
    Post z v s (exec i (replyCode 1536) (exec i EmitTag020D.code q)) := by
  have q28 : q.reg 28=word 24576 := key.1.2.1
  have qz := (ActualEmitEntry020D.readVec_ram key.2.1).trans hz
  have uz := (ActualEmitEntry020D.readVec_ram (EmitTag020D.frame q).1).trans qz
  have rep := reply_correct i (EmitTag020D.result q) z 1536 (by decide) uz (EmitTag020D.cursor q)
  rw [EmitTag020D.run_correct i q q28]
  exact combine s q _ z v key rep

/-- The whole original emitPair with both regions and the presence bit.
    All local step and cross-phase preservation premises are filled. -/
theorem emit_correct (i : Input) (s : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z) (hv : Holds s v) :
    Post z v s (exec i emitPair s) := by
  rw [emit_shape]
  exact after_key i s _ z v hz (key_correct i s z v 1536 (by decide) hz hv)

end FT1536.S05.EmitPredicates020D
