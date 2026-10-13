import ProducerPhaseCases020E8

namespace FT1536.S05.ProducerScanSpec020E8
open WordRAM020 ArrayBank020E4

/-- Proof-only scalar summary of exactly the three expression tokens. -/
def compute (c : SyntaxCells020E.Cell) (first second : Option Word) (registerValue : Word) : Option Word :=
  (SyntaxCells020E.decode c).bind (fun t => match t with
    | .literal w => some w
    | .register _ => some registerValue
    | .binary o => second.bind (fun x => first.map (fun y => op o x y))
    | _ => none)

def result (d : BoundaryPayload020E5.Data) : Option Word :=
  (ProducerSnapshot020E6.scanNode d).bind (fun n => compute n.cell
    (ProducerSnapshot020E6.scanValue d 0) (ProducerSnapshot020E6.scanValue d 1) (ProducerSnapshot020E6.regValue d))

def entry (d : BoundaryPayload020E5.Data) : Option Word :=
  if h : d.core.cursor.val<877 then ArrayValues020E4.entry d.parser.arena d.core.state d.core.values ⟨d.core.cursor.val,h⟩ else none

theorem source (d : BoundaryPayload020E5.Data) : entry d=result d := by
  by_cases hc : d.core.cursor.val<877
  · by_cases hu : d.core.cursor.val<d.parser.arena.used.val
    · let n := read d.parser.arena.bank ⟨d.core.cursor.val,hc⟩
      have hn : ProducerSnapshot020E6.scanNode d=some n := by
        simp only [ProducerSnapshot020E6.scanNode,dite_eq_left hc,hu,ite_true]
        rfl
      simp only [entry,dite_eq_left hc,ArrayValues020E4.entry,hu,ite_true,result,hn,Option.bind_some,compute]
      cases ht : SyntaxCells020E.decode n.cell with
      | none => simp only [Option.bind_none]
      | some t =>
        change (some t).bind (fun u => ValueSlot020E3.compute
          (fun p => if p.val<d.core.cursor.val then ArrayValues020E4.lookup d.parser.arena d.core.values p else none)
          (ArrayState020E4.model d.core.state) n u)=_
        cases t <;> simp only [Option.bind_some,ValueSlot020E3.compute]
        all_goals first
          | rfl
          | (simp only [ProducerSnapshot020E6.regValue,hn,Option.bind_some,ht,ProducerSnapshot020E6.value,Option.getD_some];rfl)
          | (simp only [ProducerSnapshot020E6.scanValue,hn,Option.bind_some,ProducerSnapshot020E6.child];rfl)
    · simp [entry,hc,ArrayValues020E4.entry,hu,result,ProducerSnapshot020E6.scanNode]
  · simp [entry,hc,result,ProducerSnapshot020E6.scanNode]

end FT1536.S05.ProducerScanSpec020E8
