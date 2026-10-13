import CoreEncoding020E5
import PairPatch020E5

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CoreFieldPatch020E5
open WordRAM020 ArrayBank020E4 NodeFrames020E2 CoreState020E5 CoreEncoding020E5 WordCodec020E5 VerifiedPatch020E5

abbrev valueCodec : Codec (Option Word) 2 := ⟨BankStorage020E3.valueWords,BankStorage020E3.value_injective⟩
abbrev cv (cap : Nat) := bank valueCodec cap
abbrev cf (cap capacity : Nat) (hc : cap<2^511) := bank (frameCodec cap hc) capacity
abbrev co := bank boolCodec outputSize
abbrev cr := bank wordCodec ramSize
abbrev cg := bank wordCodec 32
abbrev c0 (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) := pair (cv cap) (metaCodec cap capacity limit hc hf hl)
abbrev c1 (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) := pair (cf cap capacity hc) (c0 cap capacity limit hc hf hl)
abbrev c2 (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) := pair co (c1 cap capacity limit hc hf hl)
abbrev c3 (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) := pair cr (c2 cap capacity limit hc hf hl)

abbrev image {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) := CoreEncoding020E5.encode hc hf hl q

def setValues {cap capacity limit : Nat} (q : Core cap capacity limit) (v : ArrayValues020E4.Values cap) := {q with values := v}
def setFrames {cap capacity limit : Nat} (q : Core cap capacity limit) (v : Bank (Frame cap) capacity) := {q with frames := {q.frames with bank := v}}
def setReg {cap capacity limit : Nat} (q : Core cap capacity limit) (r : Reg) (v : Word) := {q with state := ArrayState020E4.put q.state r v}
def setRam {cap capacity limit : Nat} (q : Core cap capacity limit) (r : Fin ramSize) (v : Word) := {q with state := ArrayState020E4.store q.state r v}
def setOut {cap capacity limit : Nat} (q : Core cap capacity limit) (r : Fin outputSize) (v : Bool) := {q with state := ArrayState020E4.emit q.state r v}

def setMetadata {cap capacity limit : Nat} (q : Core cap capacity limit) (m : Meta cap capacity limit) : Core cap capacity limit :=
  ofFields (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,m)))))

section
variable {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)

/-- This program contains exactly two stores; it never materializes a copy
    of the value bank or the unchanged product components. -/
def values (q : Core cap capacity limit) (j : Fin cap) (v : Option Word) :
    Program (image hc hf hl q) (image hc hf hl (setValues q (write q.values j v))) := by
  exact PairPatch020E5.second cg (c3 cap capacity limit hc hf hl) q.state.reg
    (PairPatch020E5.second cr (c2 cap capacity limit hc hf hl) q.state.ram
      (PairPatch020E5.second co (c1 cap capacity limit hc hf hl) q.state.out
        (PairPatch020E5.second (cf cap capacity hc) (c0 cap capacity limit hc hf hl) q.frames.bank
          (PairPatch020E5.first (cv cap) (metaCodec cap capacity limit hc hf hl) (metadata q) (cell valueCodec q.values j v)))))

def frames (q : Core cap capacity limit) (j : Fin capacity) (v : Frame cap) :
    Program (image hc hf hl q) (image hc hf hl (setFrames q (write q.frames.bank j v))) := by
  exact PairPatch020E5.second cg (c3 cap capacity limit hc hf hl) q.state.reg
    (PairPatch020E5.second cr (c2 cap capacity limit hc hf hl) q.state.ram
      (PairPatch020E5.second co (c1 cap capacity limit hc hf hl) q.state.out
        (PairPatch020E5.first (cf cap capacity hc) (c0 cap capacity limit hc hf hl) (q.values,metadata q)
          (cell (frameCodec cap hc) q.frames.bank j v))))

def reg (q : Core cap capacity limit) (r : Reg) (v : Word) :
    Program (image hc hf hl q) (image hc hf hl (setReg q r v)) := by
  exact PairPatch020E5.first cg (c3 cap capacity limit hc hf hl)
    (q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))) (cell wordCodec q.state.reg r v)

def ram (q : Core cap capacity limit) (r : Fin ramSize) (v : Word) :
    Program (image hc hf hl q) (image hc hf hl (setRam q r v)) := by
  exact PairPatch020E5.second cg (c3 cap capacity limit hc hf hl) q.state.reg
    (PairPatch020E5.first cr (c2 cap capacity limit hc hf hl)
      (q.state.out,(q.frames.bank,(q.values,metadata q))) (cell wordCodec q.state.ram r v))

def out (q : Core cap capacity limit) (r : Fin outputSize) (v : Bool) :
    Program (image hc hf hl q) (image hc hf hl (setOut q r v)) := by
  exact PairPatch020E5.second cg (c3 cap capacity limit hc hf hl) q.state.reg
    (PairPatch020E5.second cr (c2 cap capacity limit hc hf hl) q.state.ram
      (PairPatch020E5.first co (c1 cap capacity limit hc hf hl)
        (q.frames.bank,(q.values,metadata q)) (cell boolCodec q.state.out r v)))

def control (q : Core cap capacity limit) (m : Meta cap capacity limit) :
    Program (image hc hf hl q) (image hc hf hl (setMetadata q m)) := by
  exact PairPatch020E5.second cg (c3 cap capacity limit hc hf hl) q.state.reg
    (PairPatch020E5.second cr (c2 cap capacity limit hc hf hl) q.state.ram
      (PairPatch020E5.second co (c1 cap capacity limit hc hf hl) q.state.out
        (PairPatch020E5.second (cf cap capacity hc) (c0 cap capacity limit hc hf hl) q.frames.bank
          (PairPatch020E5.second (cv cap) (metaCodec cap capacity limit hc hf hl) q.values
            (overwrite (pack (metaCodec cap capacity limit hc hf hl) (metadata q)) (pack (metaCodec cap capacity limit hc hf hl) m))))))

theorem values_length (q : Core cap capacity limit) (j : Fin cap) (v : Option Word) : (values hc hf hl q j v).code.length=2 := by
  unfold payloadWords
  simp only [values,PairPatch020E5.first,PairPatch020E5.second,WordJoin020E5.liftLeft,WordJoin020E5.liftRight,cell]
  simp only [List.length_map,List.length_ofFn]

theorem frames_length (q : Core cap capacity limit) (j : Fin capacity) (v : Frame cap) : (frames hc hf hl q j v).code.length=3 := by
  unfold payloadWords
  simp only [frames,PairPatch020E5.first,PairPatch020E5.second,WordJoin020E5.liftLeft,WordJoin020E5.liftRight,cell]
  simp only [List.length_map,List.length_ofFn]

theorem reg_length (q : Core cap capacity limit) (r : Reg) (v : Word) : (reg hc hf hl q r v).code.length=1 := by
  unfold payloadWords
  simp only [reg,PairPatch020E5.first,WordJoin020E5.liftLeft,cell]
  simp only [List.length_map,List.length_ofFn]

theorem ram_length (q : Core cap capacity limit) (r : Fin ramSize) (v : Word) : (ram hc hf hl q r v).code.length=1 := by
  unfold payloadWords
  simp only [ram,PairPatch020E5.first,PairPatch020E5.second,WordJoin020E5.liftLeft,WordJoin020E5.liftRight,cell]
  simp only [List.length_map,List.length_ofFn]

theorem out_length (q : Core cap capacity limit) (r : Fin outputSize) (v : Bool) : (out hc hf hl q r v).code.length=1 := by
  unfold payloadWords
  simp only [out,PairPatch020E5.first,PairPatch020E5.second,WordJoin020E5.liftLeft,WordJoin020E5.liftRight,cell]
  simp only [List.length_map,List.length_ofFn]

theorem control_length (q : Core cap capacity limit) (m : Meta cap capacity limit) : (control hc hf hl q m).code.length=16 := by
  unfold payloadWords
  simp only [control,PairPatch020E5.second,WordJoin020E5.liftRight,overwrite]
  simp only [List.length_map,List.length_ofFn]

end
end FT1536.S05.CoreFieldPatch020E5
