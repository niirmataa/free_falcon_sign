import CoreState020E5
import WordCodec020E5

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CoreEncoding020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5 WordCodec020E5

def frameCodec (cap : Nat) (h : cap<2^511) : Codec (Frame cap) 3 :=
  ⟨BankStorage020E3.frameWords,BankStorage020E3.frame_injective h⟩

def pendingShape {cap : Nat} : Pending cap → Unit ⊕ (Frame cap ⊕ (Frame cap × Frame cap))
  | .none => .inl () | .one f => .inr (.inl f) | .two f g => .inr (.inr (f,g))

def pendingOfShape {cap : Nat} : Unit ⊕ (Frame cap ⊕ (Frame cap × Frame cap)) → Pending cap
  | .inl _ => .none | .inr (.inl f) => .one f | .inr (.inr (f,g)) => .two f g

theorem pending_shape_injective {cap : Nat} : Function.Injective (@pendingShape cap) := by
  intro a b h
  have round : ∀ p : Pending cap,pendingOfShape (pendingShape p)=p := by intro p;cases p <;> rfl
  exact (round a).symm.trans ((congrArg pendingOfShape h).trans (round b))

def pendingCodec (cap : Nat) (h : cap<2^511) : Codec (Pending cap) 11 :=
  contramap (sum unit (sum (frameCodec cap h) (pair (frameCodec cap h) (frameCodec cap h)))) pendingShape pending_shape_injective

def phaseTag : Phase → Fin 7
  | .check => 0 | .clear => 1 | .scan => 2 | .act => 3 | .push => 4 | .done => 5 | .bad => 6

theorem phase_tag_injective : Function.Injective phaseTag := by
  intro a b h
  cases a <;> cases b <;> simp_all [phaseTag]

def phaseCodec : Codec Phase 1 := contramap (finCodec 7 (by norm_num)) phaseTag phase_tag_injective

abbrev Meta (cap capacity limit : Nat) :=
  Phase × (Fin (cap+1) × (Fin (limit+1) × (Fin (capacity+1) × (Pending cap × Bool))))

def metadata {cap capacity limit : Nat} (q : Core cap capacity limit) : Meta cap capacity limit :=
  (q.phase,(q.cursor,(q.left,(q.frames.sp,(q.pending,q.state.fault)))))

def metaCodec (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) :
    Codec (Meta cap capacity limit) 16 :=
  pair phaseCodec (pair (finCodec (cap+1) (by omega)) (pair (finCodec (limit+1) (by omega))
    (pair (finCodec (capacity+1) (by omega)) (pair (pendingCodec cap hc) boolCodec))))

abbrev Fields (cap capacity limit : Nat) :=
  ArrayBank020E4.Bank Word 32 × (ArrayBank020E4.Bank Word ramSize ×
    (ArrayBank020E4.Bank Bool outputSize × (ArrayBank020E4.Bank (Frame cap) capacity ×
      (ArrayValues020E4.Values cap × Meta cap capacity limit))))

def fields {cap capacity limit : Nat} (q : Core cap capacity limit) : Fields cap capacity limit :=
  (q.state.reg,(q.state.ram,(q.state.out,(q.frames.bank,(q.values,metadata q)))))

def ofFields {cap capacity limit : Nat} (f : Fields cap capacity limit) : Core cap capacity limit :=
  let m := f.2.2.2.2.2
  ⟨⟨f.1,f.2.1,f.2.2.1,m.2.2.2.2.2⟩,⟨f.2.2.2.1,m.2.2.2.1⟩,f.2.2.2.2.1,m.1,m.2.1,m.2.2.1,m.2.2.2.2.1⟩

theorem fields_roundtrip {cap capacity limit : Nat} (q : Core cap capacity limit) : ofFields (fields q)=q := rfl

theorem fields_injective {cap capacity limit : Nat} : Function.Injective (@fields cap capacity limit) := by
  intro a b h
  exact (fields_roundtrip a).symm.trans ((congrArg ofFields h).trans (fields_roundtrip b))

def payloadWords (cap capacity : Nat) : Nat := 32*1+(ramSize*1+(outputSize*1+(capacity*3+(cap*2+16))))

def codec (cap capacity limit : Nat) (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) :
    Codec (Core cap capacity limit) (payloadWords cap capacity) :=
  contramap (pair (bank wordCodec 32) (pair (bank wordCodec ramSize) (pair (bank boolCodec outputSize)
    (pair (bank (frameCodec cap hc) capacity) (pair
      (bank (⟨BankStorage020E3.valueWords,BankStorage020E3.value_injective⟩ : Codec (Option Word) 2) cap)
      (metaCodec cap capacity limit hc hf hl)))))) fields fields_injective

def encode {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) : ArrayBank020E4.Bank Word (payloadWords cap capacity) :=
  ArrayBank020E4.load ((codec cap capacity limit hc hf hl).encode q)

theorem encode_injective {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511) :
    Function.Injective (encode hc hf hl) := by
  intro a b h
  apply (codec cap capacity limit hc hf hl).injective
  have hh := congrArg ArrayBank020E4.read h
  simpa only [encode,ArrayBank020E4.read_load] using hh

theorem encode_size {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (q : Core cap capacity limit) : (encode hc hf hl q).cells.size=payloadWords cap capacity :=
  (encode hc hf hl q).size_eq

end FT1536.S05.CoreEncoding020E5
