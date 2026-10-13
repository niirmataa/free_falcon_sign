import ProducerCodec020E6
import PairPatch020E5
import RegionSlot020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerStore020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ProducerMachine020E6

abbrev controls (codeSize : Nat) (hc : codeSize<2^511) := pair (finCodec (codeSize+1) (by omega)) boolCodec
abbrev rest (codeSize : Nat) (hc : codeSize<2^511) := pair (bank wordCodec 96) (controls codeSize hc)

def reg {codeSize : Nat} (hc : codeSize<2^511) (q : State codeSize) (dst : Register) (v : Word) :
    Program (ProducerCodec020E6.image hc q) (ProducerCodec020E6.image hc {q with regs:=write q.regs dst v}) :=
  PairPatch020E5.first (bank wordCodec 64) (rest codeSize hc) (q.output,(q.pc,q.fault)) (cell wordCodec q.regs dst v)

def output {codeSize : Nat} (hc : codeSize<2^511) (q : State codeSize) (dst : OutputCell) (v : Word) :
    Program (ProducerCodec020E6.image hc q) (ProducerCodec020E6.image hc {q with output:=write q.output dst v}) :=
  PairPatch020E5.second (bank wordCodec 64) (rest codeSize hc) q.regs
    (PairPatch020E5.first (bank wordCodec 96) (controls codeSize hc) (q.pc,q.fault) (cell wordCodec q.output dst v))

def control {codeSize : Nat} (hc : codeSize<2^511) (q : State codeSize) (pc : Fin (codeSize+1)) (fault : Bool) :
    Program (ProducerCodec020E6.image hc q) (ProducerCodec020E6.image hc {q with pc:=pc,fault:=fault}) :=
  PairPatch020E5.second (bank wordCodec 64) (rest codeSize hc) q.regs
    (PairPatch020E5.second (bank wordCodec 96) (controls codeSize hc) q.output
      (overwrite (pack (controls codeSize hc) (q.pc,q.fault)) (pack (controls codeSize hc) (pc,fault))))

/-- A proof-side decomposition of one RAM instruction into existing-cell
    stores. Runtime executes the closed instruction directly; it does not
    invoke this list-valued witness as a second code generator. -/
def primitive {regions codeSize : Nat} {extent : Fin regions → Nat} (hc : codeSize<2^511)
    (sources : Sources extent) (ins : Instruction regions codeSize) (q : State codeSize) :
    Program (ProducerCodec020E6.image hc q) (ProducerCodec020E6.image hc (execute sources ins q)) := by
  cases ins with
  | literal d w => exact thenDo (control hc q (next q.pc) q.fault) (reg hc {q with pc:=next q.pc} d w)
  | copy d s => exact thenDo (control hc q (next q.pc) q.fault) (reg hc {q with pc:=next q.pc} d (read q.regs s))
  | binary d o a b =>
    exact thenDo (control hc q (next q.pc) q.fault)
      (reg hc {q with pc:=next q.pc} d (WordRAM020.op o (read q.regs a) (read q.regs b)))
  | load d r a =>
    unfold execute
    dsimp only
    cases WordRAM020.address (extent r) (read q.regs a) with
    | none => exact thenDo (control hc q (next q.pc) true) (reg hc {q with pc:=next q.pc,fault:=true} d 0)
    | some j => exact thenDo (control hc q (next q.pc) q.fault) (reg hc {q with pc:=next q.pc} d (read (sources r) j))
  | output d s => exact thenDo (control hc q (next q.pc) q.fault) (output hc {q with pc:=next q.pc} d (read q.regs s))
  | select d c z n =>
    exact thenDo (control hc q (next q.pc) q.fault)
      (reg hc {q with pc:=next q.pc} d (read q.regs (if read q.regs c=0 then z else n)))

theorem run_trace {regions codeSize : Nat} {extent : Fin regions → Nat} (hc : codeSize<2^511)
    (sources : Sources extent) (code : Bank (Instruction regions codeSize) codeSize)
    (fuel : Nat) (q : State codeSize) (context : RegionRam020E5.Heap) (r : Fin context.size) :
    ∃ hist,RegionRam020E5.Steps (RegionSlot020E5.frame context r (ProducerCodec020E6.image hc q)) hist
      (RegionSlot020E5.frame context r (ProducerCodec020E6.image hc (ProducerMachine020E6.run sources code fuel q))) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    unfold ProducerMachine020E6.run
    split
    · exact ⟨[],.nil _⟩
    · rename_i hneq
      have hpc : q.pc.val<codeSize := by have := q.pc.isLt;omega
      let p := primitive hc sources (read code ⟨q.pc.val,hpc⟩) q
      obtain ⟨front,hf,_⟩ := WordPatch020E5.has_trace p.code (ProducerCodec020E6.image hc q)
      have hp := RegionSlot020E5.trace context r hf
      rw [p.correct] at hp
      obtain ⟨tail,ht⟩ := ih (execute sources (read code ⟨q.pc.val,hpc⟩) q)
      rw [step,dite_eq_left hpc]
      exact ⟨front.map (RegionSlot020E5.frame context r)++tail,RegionTrace020E5.append hp ht⟩

end FT1536.S05.ProducerStore020E6
