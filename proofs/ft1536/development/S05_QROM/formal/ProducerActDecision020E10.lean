import ProducerActSetter020E10
import ProducerActROM020E10
import ProducerActRAM020E10
import ProducerActTape020E10
import ProducerActStore020E10
import ProducerActEmit020E10
import ProducerActSeq020E10
import ProducerActBranch020E10
import ProducerActLoop020E10
import ProducerActReject020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActDecision020E10
open ProducerActSource020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1

/-- Every typed state, all modeled node tags and Word512 payloads; no legality,
    reachability or successful-action assumption. -/
theorem correct (d : BoundaryPayload020E5.Data) : Matches d (result d) := by
  cases hn : actNode d with
  | none => exact ProducerActFacts020E10.no_node d hn
  | some n =>
    cases ht : top d with
    | none => simp only [actNode,ht,Option.bind_none] at hn;cases hn
    | some fr =>
      cases fr with
      | run p =>
        by_cases h3 : n.cell.1.val=3
        · exact ProducerActSetter020E10.correct d p n ht hn h3
        by_cases h4 : n.cell.1.val=4
        · exact ProducerActROM020E10.correct d p n ht hn h4
        by_cases h5 : n.cell.1.val=5
        · exact ProducerActRAM020E10.correct d p n ht hn h5
        by_cases h6 : n.cell.1.val=6
        · exact ProducerActTape020E10.correct d p n ht hn h6
        by_cases h7 : n.cell.1.val=7
        · exact ProducerActStore020E10.correct d p n ht hn h7
        by_cases h8 : n.cell.1.val=8
        · exact ProducerActEmit020E10.correct d p n ht hn h8
        by_cases h9 : n.cell.1.val=9
        · exact ProducerActSeq020E10.correct d p n ht hn h9
        by_cases h10 : n.cell.1.val=10
        · exact ProducerActBranch020E10.correct d p n ht hn h10
        by_cases h11 : n.cell.1.val=11
        · exact ProducerActLoop020E10.run d p n ht hn h11
        exact ProducerActReject020E10.run d p n ht hn (by omega)
      | again p c =>
        by_cases h11 : n.cell.1.val=11
        · exact ProducerActLoop020E10.again d p c n ht hn h11
        · exact ProducerActReject020E10.again d p c n ht hn h11

theorem pending (d : BoundaryPayload020E5.Data) (p : FixedAction020E5.Pending 877) (e : MemoryEdit020E5.Edit)
    (h : result d=some (p,e)) (k : Nat) (hk : k<11) :
    ProducerExpr020E6.eval (ProducerReference020E7.env d) (ProducerCoreCircuit020E6.actionPending k)=ProducerMetaWords020E8.pending p k :=
  ((correct d).2 p e h).2 ⟨k,hk⟩

end FT1536.S05.ProducerActDecision020E10
