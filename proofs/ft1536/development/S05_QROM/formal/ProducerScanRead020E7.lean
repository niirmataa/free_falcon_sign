import ProducerValueRead020E7
import ProducerTopRead020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerScanRead020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7 ProducerReads020E7 ProducerTopRead020E7

/-- This follows from the typed arena bound, not a well-formed-program assumption. -/
theorem scan_present (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) ProducerWindow020E6.scanPresent=
      ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanNode d) := by
  have hc : d.core.cursor.val<2^511 := lt_trans d.core.cursor.isLt (by norm_num)
  have hu : d.parser.arena.used.val<2^511 := lt_trans d.parser.arena.used.isLt (by norm_num)
  simp only [ProducerWindow020E6.scanPresent,and_eval,lt_eval,literal,cursor_eval,used_eval,
    lt_nat (a:=d.core.cursor.val) (b:=877) hc (by norm_num),lt_nat hc hu]
  by_cases h : d.core.cursor.val<877
  · by_cases hu' : d.core.cursor.val<d.parser.arena.used.val
    · simp only [h,hu',ite_true,ProducerSnapshot020E6.scanNode ];rfl
    · simp only [h,hu',ite_true,ite_false,ProducerSnapshot020E6.scanNode ];rfl
  · simp only [h,ite_false,ite_true,ProducerSnapshot020E6.scanNode ];rfl

theorem scan_field (d : BoundaryPayload020E5.Data) (fresh : Bool) (f : Fin 5) :
    eval (sources d fresh) (choose ProducerWindow020E6.scanPresent (nodeAt cursor f.val) (lit 0))=
      ProducerSnapshot020E6.field (ProducerSnapshot020E6.scanNode d) f := by
  rw [choose_eval,scan_present]
  by_cases h : d.core.cursor.val<877
  · by_cases hu : d.core.cursor.val<d.parser.arena.used.val
    · have hh := node_eval d fresh cursor ⟨d.core.cursor.val,h⟩ (cursor_eval d fresh) f
      simp only [ProducerSnapshot020E6.scanNode,dite_eq_left h,hu,ite_true,ProducerSnapshot020E6.present,
        Option.isSome_some,WordCodec020E5.boolWord,ProducerSnapshot020E6.field,Option.map_some,Option.getD_some]
      simpa only [show (1 : Word)≠0 by decide,ite_false] using hh
    · simp only [ProducerSnapshot020E6.scanNode,dite_eq_left h,hu,ite_false,ProducerSnapshot020E6.present,
        Option.isSome_none,WordCodec020E5.boolWord,Bool.false_eq_true,ite_true,ProducerSnapshot020E6.field,Option.map_none,Option.getD_none,literal]
      rfl
  · simp only [ProducerSnapshot020E6.scanNode,dite_eq_right h,ProducerSnapshot020E6.present,
      Option.isSome_none,WordCodec020E5.boolWord,Bool.false_eq_true,ite_false,ite_true,
      ProducerSnapshot020E6.field,Option.map_none,Option.getD_none,literal]
    rfl

end FT1536.S05.ProducerScanRead020E7
