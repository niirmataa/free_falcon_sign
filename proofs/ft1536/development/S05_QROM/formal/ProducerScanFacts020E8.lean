import ProducerScanRows020E8
import ProducerOpcode020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerScanFacts020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerWordLaws020E6 ProducerScanRows020E8
attribute [local irreducible] ProducerCoreCircuit020E6.w

def Matches (d : BoundaryPayload020E5.Data) (v : Option Word) : Prop :=
  eval (env d) scanPresent=ProducerSnapshot020E6.present v ∧
  eval (env d) scanValue=ProducerSnapshot020E6.value v

theorem zero_matches (d : BoundaryPayload020E5.Data) (h : eval (env d) scanPresent=0) : Matches d none := by
  refine ⟨h,?_⟩
  simp only [scanValue,choose_eval,h,ite_true,literal]
  rfl

theorem observed (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) :
    eval (env d) (w 21)=word n.cell.1.val ∧ eval (env d) (w 22)=n.cell.2 ∧ eval (env d) (w 46)=1 := by
  exact ⟨(row21 d).trans (by rw [hn];rfl),(row22 d).trans (by rw [hn];rfl),(row46 d).trans (by rw [hn];rfl)⟩

theorem tag_test (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) (k : Nat) (hk : k<3) :
    eval (env d) (ProducerScalar020E6.eq (w 21) (ProducerScalar020E6.lit k))=
      if n.cell.1.val=k then (1 : Word) else 0 := by
  simp only [eq_eval,literal,(observed d n hn).1]
  exact eq_nat (lt_trans n.cell.1.isLt (by norm_num)) (lt_trans hk (by norm_num))

theorem payload_lt (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) (k : Nat) (hk : k<2^511) :
    eval (env d) (ProducerScalar020E6.lt (ProducerScalar020E6.natClamp (w 22)) (ProducerScalar020E6.lit k))=
      if n.cell.2.toInt.toNat<k then (1 : Word) else 0 := by
  simp only [lt_eval,literal,clamp_eval,(observed d n hn).2.1]
  exact lt_nat (ProducerRegisterRead020E7.clamp_bound _) hk

theorem no_node (d : BoundaryPayload020E5.Data) (hn : ProducerSnapshot020E6.scanNode d=none) :
    Matches d (ProducerScanSpec020E8.result d) := by
  have h46 : eval (env d) (w 46)=0 := (row46 d).trans (by rw [hn];rfl)
  have hp : eval (env d) scanPresent=0 := by simp only [scanPresent,and_eval,h46,ite_true]
  have hr : ProducerScanSpec020E8.result d=none := by rw [ProducerScanSpec020E8.result,hn];rfl
  rw [hr]
  exact zero_matches d hp

theorem compute_other (tag : Fin 16) (x : Word) (a b : Option Word) (r : Word) (ht : 3≤tag.val) :
    ProducerScanSpec020E8.compute (tag,x) a b r=none := by
  fin_cases tag <;> norm_num at ht
  all_goals simp only [ProducerScanSpec020E8.compute,SyntaxCells020E.decode]
  all_goals first | rfl | (cases SyntaxCells020E.regOf x <;> rfl)

end FT1536.S05.ProducerScanFacts020E8
