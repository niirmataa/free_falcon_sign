import ProducerMachine020E6
import StartupImage020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerCodec020E6
open WordRAM020 WordCodec020E5 VerifiedPatch020E5 ProducerMachine020E6

abbrev Shape (regions _codeSize : Nat) :=
  (Register × Word) ⊕ ((Register × Register) ⊕ ((Register × (Op × (Register × Register))) ⊕
    ((Register × (Fin regions × Register)) ⊕ ((OutputCell × Register) ⊕
      (Register × (Register × (Register × Register)))))))

def shape {regions codeSize : Nat} : Instruction regions codeSize → Shape regions codeSize
  | .literal d w => .inl (d,w)
  | .copy d s => .inr (.inl (d,s))
  | .binary d o x y => .inr (.inr (.inl (d,(o,(x,y)))))
  | .load d r a => .inr (.inr (.inr (.inl (d,(r,a)))))
  | .output d s => .inr (.inr (.inr (.inr (.inl (d,s)))))
  | .select d r z n => .inr (.inr (.inr (.inr (.inr (d,(r,(z,n)))))))

def unshape {regions codeSize : Nat} : Shape regions codeSize → Instruction regions codeSize
  | .inl (d,w) => .literal d w
  | .inr (.inl (d,s)) => .copy d s
  | .inr (.inr (.inl (d,(o,(x,y))))) => .binary d o x y
  | .inr (.inr (.inr (.inl (d,(r,a))))) => .load d r a
  | .inr (.inr (.inr (.inr (.inl (d,s))))) => .output d s
  | .inr (.inr (.inr (.inr (.inr (d,(r,(z,n))))))) => .select d r z n

theorem shape_injective {regions codeSize : Nat} : Function.Injective (@shape regions codeSize) := by
  intro a b h
  have round : ∀ i : Instruction regions codeSize,unshape (shape i)=i := by intro i;cases i <;> rfl
  exact (round a).symm.trans ((congrArg unshape h).trans (round b))

def opTag : Op → Fin 7 | .add => 0 | .sub => 1 | .mul => 2 | .div => 3 | .mod => 4 | .lt => 5 | .eq => 6

theorem op_injective : Function.Injective opTag := by
  intro a b h
  cases a <;> cases b <;> simp_all [opTag]

def opCodec : Codec Op 1 := contramap (finCodec 7 (by norm_num)) opTag op_injective
abbrev rc := finCodec 64 (by norm_num)
abbrev oc := finCodec 96 (by norm_num)

def instruction (regions codeSize : Nat) (hr : regions≤2^511) :
    Codec (Instruction regions codeSize) 22 :=
  contramap (sum (pair rc wordCodec) (sum (pair rc rc) (sum (pair rc (pair opCodec (pair rc rc)))
    (sum (pair rc (pair (finCodec regions hr) rc)) (sum (pair oc rc)
      (pair rc (pair rc (pair rc rc))))))))
    shape shape_injective

def stateShape {codeSize : Nat} (q : State codeSize) := (q.regs,(q.output,(q.pc,q.fault)))

theorem state_shape_injective {codeSize : Nat} : Function.Injective (@stateShape codeSize) := by
  intro a b h
  exact congrArg (fun p : ArrayBank020E4.Bank Word 64 × (ArrayBank020E4.Bank Word 96 × (Fin (codeSize+1) × Bool)) =>
    (⟨p.1,p.2.1,p.2.2.1,p.2.2.2⟩ : State codeSize)) h

def state (codeSize : Nat) (hc : codeSize<2^511) : Codec (State codeSize) (64*1+(96*1+(1+1))) :=
  contramap (pair (bank wordCodec 64) (pair (bank wordCodec 96) (pair (finCodec (codeSize+1) (by omega)) boolCodec)))
    stateShape state_shape_injective

def image {codeSize : Nat} (hc : codeSize<2^511) (q : State codeSize) := pack (state codeSize hc) q

theorem initial_zero (codeSize : Nat) (hc : codeSize<2^511) :
    image hc (ProducerMachine020E6.initial codeSize)=ArrayBank020E4.zero 162 (0 : Word) := by
  change pack (pair (bank wordCodec 64) (pair (bank wordCodec 96) (pair (finCodec (codeSize+1) (by omega)) boolCodec)))
    (ArrayBank020E4.zero 64 (0 : Word),(ArrayBank020E4.zero 96 (0 : Word),((0 : Fin (codeSize+1)),false)))=_
  simp only [pack_pair]
  rw [ZeroCodec020E5.bank_zero wordCodec 64 0 (by intro j;rfl),ZeroCodec020E5.bank_zero wordCodec 96 0 (by intro j;rfl),
    StartupImage020E5.pack_zero (finCodec (codeSize+1) (by omega)) 0 (by intro j;rfl),
    StartupImage020E5.pack_zero boolCodec false (by intro j;rfl)]
  simp only [ZeroCodec020E5.join_zero]

end FT1536.S05.ProducerCodec020E6
