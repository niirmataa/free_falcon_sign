import ProducerScanRead020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActRead020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7 ProducerReads020E7 ProducerTopRead020E7

theorem read_some {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : ArenaTypes020E1.Ptr cap)
    (h : p.val<a.used.val) : NodeRead020E2.read (ArrayArena020E4.model a) p=
      Option.some (read a.bank ⟨p.val,by have := a.used.isLt;omega⟩) :=
  NodeRead020E2.valid_read (ArrayArena020E4.model a) p h

theorem read_none {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : ArenaTypes020E1.Ptr cap)
    (h : ¬p.val<a.used.val) : NodeRead020E2.read (ArrayArena020E4.model a) p=Option.none := by
  unfold NodeRead020E2.read
  exact dite_eq_right h

theorem frame_some (d : BoundaryPayload020E5.Data) (fresh : Bool) (fr : NodeFrames020E2.Frame 877)
    (h : ProducerSnapshot020E6.top d=Option.some fr) (f : Fin 3) :
    eval (sources d fresh) (frameAt ProducerWindow020E6.top f.val)=BankStorage020E3.frameWords fr f := by
  have hh := top_field d fresh f
  simpa only [choose_eval,top_present,h,ProducerSnapshot020E6.present,Option.isSome_some,
    WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,Option.map_some,Option.getD_some] using hh

theorem pc_some (d : BoundaryPayload020E5.Data) (fresh : Bool) (fr : NodeFrames020E2.Frame 877)
    (h : ProducerSnapshot020E6.top d=Option.some fr) :
    eval (sources d fresh) ProducerWindow020E6.topPC=word (ProducerSnapshot020E6.pc fr).val := by
  have hh := frame_some d fresh fr h 1
  cases fr <;> exact hh

theorem act_present (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) ProducerWindow020E6.actPresent=
      ProducerSnapshot020E6.present (ProducerSnapshot020E6.actNode d) := by
  simp only [ProducerWindow020E6.actPresent,and_eval,top_present]
  cases h : ProducerSnapshot020E6.top d with
  | none => simp [h,ProducerSnapshot020E6.actNode,ProducerSnapshot020E6.present,WordCodec020E5.boolWord]
  | some fr =>
    have hp : (ProducerSnapshot020E6.pc fr).val<2^511 := lt_trans (ProducerSnapshot020E6.pc fr).isLt (by norm_num)
    have hu : d.parser.arena.used.val<2^511 := lt_trans d.parser.arena.used.isLt (by norm_num)
    simp only [h,lt_eval,pc_some d fresh fr h,used_eval,lt_nat hp hu,
      ProducerSnapshot020E6.actNode,Option.bind_some]
    by_cases hk : (ProducerSnapshot020E6.pc fr).val<d.parser.arena.used.val
    · simp [hk,read_some d.parser.arena _ hk,ProducerSnapshot020E6.present,WordCodec020E5.boolWord]
    · simp [hk,read_none d.parser.arena _ hk,ProducerSnapshot020E6.present,WordCodec020E5.boolWord]

theorem act_field (d : BoundaryPayload020E5.Data) (fresh : Bool) (f : Fin 5) :
    eval (sources d fresh) (choose ProducerWindow020E6.actPresent (nodeAt ProducerWindow020E6.topPC f.val) (lit 0))=
      ProducerSnapshot020E6.field (ProducerSnapshot020E6.actNode d) f := by
  rw [choose_eval,act_present]
  cases h : ProducerSnapshot020E6.top d with
  | none =>
    simp [ProducerSnapshot020E6.actNode,h,ProducerSnapshot020E6.present,ProducerSnapshot020E6.field,
      WordCodec020E5.boolWord,word_zero]
  | some fr =>
    by_cases hk : (ProducerSnapshot020E6.pc fr).val<d.parser.arena.used.val
    · have hpc : (ProducerSnapshot020E6.pc fr).val<877 := by have := d.parser.arena.used.isLt;omega
      have hh := node_eval d fresh ProducerWindow020E6.topPC ⟨(ProducerSnapshot020E6.pc fr).val,hpc⟩ (pc_some d fresh fr h) f
      simpa only [ProducerSnapshot020E6.actNode,h,Option.bind_some,read_some d.parser.arena _ hk,ProducerSnapshot020E6.present,ProducerSnapshot020E6.field,Option.isSome_some,
        WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,Option.map_some,Option.getD_some] using hh
    · simp [ProducerSnapshot020E6.actNode,h,read_none d.parser.arena _ hk,
        ProducerSnapshot020E6.present,ProducerSnapshot020E6.field,WordCodec020E5.boolWord,word_zero]

theorem node_some (d : BoundaryPayload020E5.Data) (fresh : Bool) (n : ArenaTypes020E1.Node 877)
    (h : ProducerSnapshot020E6.actNode d=Option.some n) (f : Fin 5) :
    eval (sources d fresh) (nodeAt ProducerWindow020E6.topPC f.val)=ArenaWords020E1.nodeWords n f := by
  have hh := act_field d fresh f
  simpa only [choose_eval,act_present,h,ProducerSnapshot020E6.present,ProducerSnapshot020E6.field,
    Option.isSome_some,WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,
    Option.map_some,Option.getD_some] using hh

end FT1536.S05.ProducerActRead020E7
