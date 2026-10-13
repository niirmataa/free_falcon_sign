import ProducerScanSimple020E8
import ProducerScanRegister020E8
import ProducerScanBinary020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerScanDecision020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerScanFacts020E8

/-- Every input state, including absent nodes/cache, all sixteen modeled tags and
    every signed Word512 payload; this is not restricted to reachable scans. -/
theorem correct (d : BoundaryPayload020E5.Data) : Matches d (ProducerScanSpec020E8.entry d) := by
  rw [ProducerScanSpec020E8.source]
  cases hn : ProducerSnapshot020E6.scanNode d with
  | none => exact no_node d hn
  | some n =>
    by_cases h0 : n.cell.1.val=0
    · exact ProducerScanSimple020E8.literal d n hn h0
    · by_cases h1 : n.cell.1.val=1
      · exact ProducerScanRegister020E8.correct d n hn h1
      · by_cases h2 : n.cell.1.val=2
        · exact ProducerScanBinary020E8.correct d n hn h2
        · exact ProducerScanSimple020E8.other d n hn (by omega)

theorem present_word (v : Option Word) : ProducerSnapshot020E6.present v=BankStorage020E3.valueWords v 0 := by
  cases v <;> rfl

theorem payload_word (v : Option Word) : ProducerSnapshot020E6.value v=BankStorage020E3.valueWords v 1 := by
  cases v <;> rfl

/-- Pure proof transport, keeping concrete reader evaluation out of reduction. -/
theorem transport (F G : ProducerExpr020E6.Expr 1 → Word) (a b : ProducerExpr020E6.Expr 1) (v : Option Word)
    (hF : ∀ e,F e=G e) (ha : G a=ProducerSnapshot020E6.present v) (hb : G b=ProducerSnapshot020E6.value v) (j : Fin 2) :
    (if j.val=0 then F a else F b)=BankStorage020E3.valueWords v j := by
  fin_cases j
  · exact (hF a).trans (ha.trans (present_word v))
  · exact (hF b).trans (hb.trans (payload_word v))

/-- Both cache words produced from the real resident reader equal the old
    entry encoding, including the zero payload of an absent value. -/
theorem cache_words (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 2) :
    (if j.val=0 then eval (ProducerMetaSource020E6.env d fresh) scanPresent
      else eval (ProducerMetaSource020E6.env d fresh) scanValue)=
    BankStorage020E3.valueWords (ProducerScanSpec020E8.entry d) j :=
  transport (eval (ProducerMetaSource020E6.env d fresh)) (eval (ProducerReference020E7.env d))
    scanPresent scanValue (ProducerScanSpec020E8.entry d) (ProducerReference020E7.scalar d fresh)
    (correct d).1 (correct d).2 j

end FT1536.S05.ProducerScanDecision020E8
