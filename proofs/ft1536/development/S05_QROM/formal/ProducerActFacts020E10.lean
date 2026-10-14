import ProducerActRows020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActFacts020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerWordLaws020E6 ProducerActRows020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w

theorem observed (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) :
    eval (env d) (w 32)=word n.cell.1.val ∧ eval (env d) (w 33)=n.cell.2 ∧ eval (env d) (w 31)=1 := by
  exact ⟨(row32 d).trans (by rw [hn];rfl),(row33 d).trans (by rw [hn];rfl),(row31 d).trans (by rw [hn];rfl)⟩

theorem tag (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) (k : Nat) (hk : k<16) :
    eval (env d) (isToken k)=if n.cell.1.val=k then (1 : Word) else 0 := by
  simp only [isToken,eq_eval,literal,(observed d n hn).1]
  exact eq_nat (lt_trans n.cell.1.isLt (by norm_num)) (lt_trans hk (by norm_num))

theorem tag_lt (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) (k : Nat) (hk : k<16) :
    eval (env d) (ProducerScalar020E6.lt (w 32) (ProducerScalar020E6.lit k))=if n.cell.1.val<k then (1 : Word) else 0 := by
  simp only [lt_eval,literal,(observed d n hn).1]
  exact lt_nat (lt_trans n.cell.1.isLt (by norm_num)) (lt_trans hk (by norm_num))

theorem payload (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) :
    eval (env d) payloadNat=word n.cell.2.toInt.toNat := by
  simp only [payloadNat,clamp_eval,(observed d n hn).2.1]

theorem payload_lt (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) (k : Nat) (hk : k<2^511) :
    eval (env d) (ProducerScalar020E6.lt payloadNat (ProducerScalar020E6.lit k))=if n.cell.2.toInt.toNat<k then (1 : Word) else 0 := by
  simp only [lt_eval,literal,payload d n hn]
  exact lt_nat (ProducerRegisterRead020E7.clamp_bound _) hk

theorem run (d : BoundaryPayload020E5.Data) (p : Ptr 877) (ht : top d=some (.run p)) : eval (env d) isAgain=0 := by
  have hr : eval (env d) (w 18)=0 := (row18 d).trans (by rw [ht];rfl)
  simp only [isAgain,eq_eval,hr,literal];rfl

theorem again (d : BoundaryPayload020E5.Data) (p : Ptr 877) (c : Count) (ht : top d=some (.again p c)) : eval (env d) isAgain=1 := by
  have hr : eval (env d) (w 18)=1 := (row18 d).trans (by rw [ht];rfl)
  simp only [isAgain,eq_eval,hr,literal];rfl

theorem child_value (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) (j : Nat) :
    actValue d j=ArrayValues020E4.lookup d.parser.arena d.core.values (child n j) := by
  rw [actValue,hn];rfl

theorem first (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) :
    eval (env d) (w 37)=present (ArrayValues020E4.lookup d.parser.arena d.core.values n.first) ∧
    eval (env d) (w 38)=value (ArrayValues020E4.lookup d.parser.arena d.core.values n.first) := by
  rw [row37,row38,child_value d n hn];exact ⟨rfl,rfl⟩

theorem second (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) :
    eval (env d) (w 39)=present (ArrayValues020E4.lookup d.parser.arena d.core.values n.second) ∧
    eval (env d) (w 40)=value (ArrayValues020E4.lookup d.parser.arena d.core.values n.second) := by
  rw [row39,row40,child_value d n hn];exact ⟨rfl,rfl⟩

theorem third (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) :
    eval (env d) (w 41)=present (ArrayValues020E4.lookup d.parser.arena d.core.values n.third) ∧
    eval (env d) (w 42)=value (ArrayValues020E4.lookup d.parser.arena d.core.values n.third) := by
  rw [row41,row42,child_value d n hn];exact ⟨rfl,rfl⟩

theorem no_node (d : BoundaryPayload020E5.Data) (hn : actNode d=none) : ProducerActSource020E10.Matches d (ProducerActSource020E10.result d) := by
  rw [ProducerActSource020E10.no_node d hn]
  apply ProducerActSource020E10.rejected
  have hp : eval (env d) (w 31)=0 := (row31 d).trans (by rw [hn];rfl)
  simp only [actionOK,and_eval,hp,ite_true]

end FT1536.S05.ProducerActFacts020E10
