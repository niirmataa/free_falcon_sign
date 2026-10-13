import ProducerFetch020E6
import ProducerWordLaws020E6

set_option exponentiation.threshold 512
set_option maxRecDepth 8192
namespace FT1536.S05.ProducerFetchStore020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 ProducerFetch020E6

abbrev irCodec (regions codeSize : Nat) (hr : regions≤2^511) :=
  contramap (sum unit (ProducerCodec020E6.instruction regions codeSize hr))
    ScriptStore020E5.optionShape ScriptStore020E5.option_injective
abbrev tailCodec (regions codeSize : Nat) (hr : regions≤2^511) := pair (irCodec regions codeSize hr) boolCodec

def shape {regions codeSize : Nat} (q : ProducerFetch020E6.State regions codeSize) := (q.vm,(q.ir,q.executePhase))

theorem shape_injective {regions codeSize : Nat} : Function.Injective (@shape regions codeSize) := by
  intro a b h
  exact congrArg (fun p : ProducerMachine020E6.State codeSize × (Option (ProducerMachine020E6.Instruction regions codeSize) × Bool) =>
    (⟨p.1,p.2.1,p.2.2⟩ : ProducerFetch020E6.State regions codeSize)) h

def codec (regions codeSize : Nat) (hr : regions≤2^511) (hc : codeSize<2^511) :
    Codec (ProducerFetch020E6.State regions codeSize) 186 :=
  contramap (pair (ProducerCodec020E6.state codeSize hc) (tailCodec regions codeSize hr)) shape shape_injective

def image {regions codeSize : Nat} (hr : regions≤2^511) (hc : codeSize<2^511) (q : ProducerFetch020E6.State regions codeSize) :=
  pack (codec regions codeSize hr hc) q

def controls {regions codeSize : Nat} (hr : regions≤2^511) (hc : codeSize<2^511) (q : ProducerFetch020E6.State regions codeSize)
    (ir : Option (ProducerMachine020E6.Instruction regions codeSize)) (phase : Bool) :
    Program (image hr hc q) (image hr hc {q with ir:=ir,executePhase:=phase}) :=
  PairPatch020E5.second (ProducerCodec020E6.state codeSize hc) (tailCodec regions codeSize hr) q.vm
    (overwrite (pack (tailCodec regions codeSize hr) (q.ir,q.executePhase)) (pack (tailCodec regions codeSize hr) (ir,phase)))

def changeVM {regions codeSize : Nat} (hr : regions≤2^511) (hc : codeSize<2^511) (q : ProducerFetch020E6.State regions codeSize)
    {vm : ProducerMachine020E6.State codeSize} (p : Program (ProducerCodec020E6.image hc q.vm) (ProducerCodec020E6.image hc vm)) :
    Program (image hr hc q) (image hr hc {q with vm:=vm}) :=
  PairPatch020E5.first (ProducerCodec020E6.state codeSize hc) (tailCodec regions codeSize hr) (q.ir,q.executePhase) p

def program {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511) (hc : codeSize<2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize)
    (q : ProducerFetch020E6.State regions codeSize) :
    Program (image hr hc q) (image hr hc (ProducerFetch020E6.step sources code q)) := by
  unfold ProducerFetch020E6.step
  split
  · cases q.ir with
    | none =>
      exact thenDo (changeVM hr hc q (ProducerStore020E6.control hc q.vm ⟨codeSize,by omega⟩ true))
        (controls hr hc {q with vm:={q.vm with pc:=⟨codeSize,by omega⟩,fault:=true}} none false)
    | some ins =>
      exact thenDo (changeVM hr hc q (ProducerStore020E6.primitive hc sources ins q.vm))
        (controls hr hc {q with vm:=ProducerMachine020E6.execute sources ins q.vm} (some ins) false)
  · split
    · rename_i h
      exact controls hr hc q (some (read code ⟨q.vm.pc.val,h⟩)) true
    · exact identity _

/-- The fetched instruction payload comes from an actual resident code row;
    it is not an arbitrary instruction manufactured by a host callback. -/
theorem fetched_word {regions codeSize : Nat} (hr : regions≤2^511)
    (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize) (pc : Fin codeSize) (j : Fin 22) :
    read (pack (bank (ProducerCodec020E6.instruction regions codeSize hr) codeSize) code)
      (finProdFinEquiv (pc,j))=(ProducerCodec020E6.instruction regions codeSize hr).encode (read code pc) j :=
  ProducerWordLaws020E6.read_encoded_cell _ _ _ _

end FT1536.S05.ProducerFetchStore020E6
