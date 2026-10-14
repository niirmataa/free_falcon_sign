import ProducerActTests020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActRegisterFacts020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem ok (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (hl : 3≤n.cell.1.val) (hu : n.cell.1.val<7) :
    eval (env d) actionOK=if n.cell.2.toInt.toNat<32 then present (ArrayValues020E4.lookup d.parser.arena d.core.values n.first) else 0 := by
  have h7 : n.cell.1.val≠7 := by omega
  have h8 : n.cell.1.val≠8 := by omega
  have h9 : n.cell.1.val≠9 := by omega
  have h10 : n.cell.1.val≠10 := by omega
  have h11 : n.cell.1.val≠11 := by omega
  have h3 : ¬n.cell.1.val<3 := by omega
  simp only [actionOK,ordinaryOK,and_eval,choose_eval,not_eval,literal,(observed d n hn).2.2,
    ProducerActFacts020E10.run d p ht,tag d n hn 7 (by decide),tag d n hn 8 (by decide),tag d n hn 9 (by decide),
    tag d n hn 10 (by decide),tag d n hn 11 (by decide),tag_lt d n hn 3 (by decide),tag_lt d n hn 7 (by decide),
    payload_lt d n hn 32 (by norm_num),h7,h8,h9,h10,h11,h3,hu,(first d n hn).1]
  by_cases hk : n.cell.2.toInt.toNat<32 <;> simp only [hk,ite_true,ite_false] <;> rfl

theorem address (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n)
    (he : eval (env d) editTag=2) : eval (env d) editAddress=word n.cell.2.toInt.toNat := by
  simp only [editAddress,choose_eval,eq_eval,he,literal]
  exact payload d n hn

theorem memory_ram (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n)
    (v : Word) (hv : ArrayValues020E4.lookup d.parser.arena d.core.values n.first=some v) :
    eval (env d) (w 43)=((WordRAM020.address ramSize v).map (ArrayBank020E4.read d.core.state.ram)).getD 0 := by
  rw [ProducerActRows020E10.row43,ProducerSnapshot020E6.memoryValue,child_value d n hn]
  change value ((ArrayValues020E4.lookup d.parser.arena d.core.values n.first).bind _) = _
  rw [hv];rfl

theorem memory_rom (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n)
    (v : Word) (hv : ArrayValues020E4.lookup d.parser.arena d.core.values n.first=some v) :
    eval (env d) (w 44)=((WordRAM020.address romSize v).map (ArrayBank020E4.read d.rom.bank)).getD 0 := by
  rw [ProducerActRows020E10.row44,ProducerSnapshot020E6.memoryValue,child_value d n hn]
  change value ((ArrayValues020E4.lookup d.parser.arena d.core.values n.first).bind _) = _
  rw [hv];rfl

theorem memory_tape (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n)
    (v : Word) (hv : ArrayValues020E4.lookup d.parser.arena d.core.values n.first=some v) :
    eval (env d) (w 45)=((WordRAM020.address tapeSize v).map (fun a => WordCodec020E5.boolWord (ArrayBank020E4.read d.tape.bank a))).getD 0 := by
  rw [ProducerActRows020E10.row45,ProducerSnapshot020E6.memoryValue,child_value d n hn]
  change value ((ArrayValues020E4.lookup d.parser.arena d.core.values n.first).bind _) = _
  rw [hv];rfl

end FT1536.S05.ProducerActRegisterFacts020E10
