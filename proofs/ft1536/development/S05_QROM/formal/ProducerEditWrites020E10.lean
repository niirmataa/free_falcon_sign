import ProducerActOutcome020E10
import ProducerDataList020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerEditWrites020E10
open WordRAM020 ArrayBank020E4 CoreState020E5 CoreFieldPatch020E5 CoreEncoding020E5 ProducerBankRead020E6

def writes {cap capacity : Nat} : MemoryEdit020E5.Edit → List (WordPatch020E5.Write (payloadWords cap capacity))
  | .keep | .fault => []
  | .reg r v => [(regPtr r,v)]
  | .ram a v => [(ramPtr a,v)]
  | .out a v => [(outPtr a,WordCodec020E5.boolWord v)]

theorem reg_code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (r : Reg) (v : Word) :
    (CoreFieldPatch020E5.reg hc hf hl q r v).code=writes (.reg r v) := by
  unfold payloadWords
  simp only [CoreFieldPatch020E5.reg,PairPatch020E5.first,WordJoin020E5.liftLeft,VerifiedPatch020E5.cell,List.map_ofFn,Function.comp_def]
  rfl

theorem ram_code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (r : Fin ramSize) (v : Word) :
    (CoreFieldPatch020E5.ram hc hf hl q r v).code=writes (.ram r v) := by
  unfold payloadWords
  simp only [CoreFieldPatch020E5.ram,PairPatch020E5.first,PairPatch020E5.second,WordJoin020E5.liftLeft,WordJoin020E5.liftRight,VerifiedPatch020E5.cell,List.map_ofFn,Function.comp_def]
  rfl

theorem out_code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (r : Fin outputSize) (v : Bool) :
    (CoreFieldPatch020E5.out hc hf hl q r v).code=writes (.out r v) := by
  unfold payloadWords
  simp only [CoreFieldPatch020E5.out,PairPatch020E5.first,PairPatch020E5.second,WordJoin020E5.liftLeft,WordJoin020E5.liftRight,VerifiedPatch020E5.cell,List.map_ofFn,Function.comp_def]
  rfl

theorem effect {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) (e : MemoryEdit020E5.Edit) :
    WordPatch020E5.apply (writes e) (image hc hf hl q)=image hc hf hl (CoreData020E5.edit q e) := by
  cases e with
  | keep => rfl
  | fault => rfl
  | reg r v => rw [←reg_code hc hf hl q r v];exact (CoreFieldPatch020E5.reg hc hf hl q r v).correct
  | ram a v => rw [←ram_code hc hf hl q a v];exact (CoreFieldPatch020E5.ram hc hf hl q a v).correct
  | out a v => rw [←out_code hc hf hl q a v];exact (CoreFieldPatch020E5.out hc hf hl q a v).correct

theorem length_bound {cap capacity : Nat} (e : MemoryEdit020E5.Edit) : (writes (cap:=cap) (capacity:=capacity) e).length≤1 := by
  cases e <;> simp [writes]

end FT1536.S05.ProducerEditWrites020E10
