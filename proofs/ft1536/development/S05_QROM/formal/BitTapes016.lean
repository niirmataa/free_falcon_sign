import FiniteLaw016
import Mathlib.Logic.Equiv.Fin.Basic

namespace FT1536.S05.BitTapes016
open FT1536.Run2
abbrev Bits (n : ℕ) := Fin n → Bool

def split (a b : ℕ) : Bits (a+b) ≃ Bits a × Bits b :=
  (Equiv.arrowCongr finSumFinEquiv.symm (Equiv.refl Bool)).trans
    (Equiv.sumArrowEquivProdArrow (Fin a) (Fin b) Bool)

def chunks (n k : ℕ) : Bits (n*k) ≃ (Fin n → Bits k) :=
  (Equiv.arrowCongr finProdFinEquiv.symm (Equiv.refl Bool)).trans
    (Equiv.curry (Fin n) (Fin k) Bool)

theorem split_uniform (a b : ℕ) : (Law.uniform : Law (Bits (a+b))).map (split a b)=Law.uniform :=
  uniform_equiv (split a b)
theorem chunks_uniform (n k : ℕ) : (Law.uniform : Law (Bits (n*k))).map (chunks n k)=Law.uniform :=
  uniform_equiv (chunks n k)

def value : (n : ℕ) → Bits n → ℕ
  | 0,_ => 0
  | n+1,tape => (if tape 0 then 1 else 0)+2*value n (fun i => tape i.succ)

theorem value_lt (n : ℕ) (tape : Bits n) : value n tape<2^n := by
  induction n with
  | zero => simp [value]
  | succ n ih =>
    have hh := ih (fun i => tape i.succ)
    simp only [value,pow_succ]
    split <;> omega

def word (n : ℕ) (tape : Bits n) : Fin (2^n) := ⟨value n tape,value_lt n tape⟩

theorem value_injective (n : ℕ) : Function.Injective (value n) := by
  induction n with
  | zero => intro a b _; funext i; exact Fin.elim0 i
  | succ n ih =>
    intro a b he
    have h0 : a 0=b 0 := by
      simp only [value] at he
      cases ha : a 0 <;> cases hb : b 0 <;> simp_all <;> omega
    have ht : (fun i : Fin n => a i.succ)=(fun i : Fin n => b i.succ) := by
      apply ih
      simp only [value,h0] at he
      omega
    funext i
    exact Fin.cases h0 (fun j => congrFun ht j) i

theorem word_injective (n : ℕ) : Function.Injective (word n) := by
  intro a b he
  exact value_injective n (congrArg Fin.val he)

theorem word_bijective (n : ℕ) : Function.Bijective (word n) := by
  apply (Fintype.bijective_iff_injective_and_card (word n)).mpr
  exact ⟨word_injective n,by simp [Bits]⟩

noncomputable def wordEquiv (n : ℕ) : Bits n ≃ Fin (2^n) :=
  Equiv.ofBijective (word n) (word_bijective n)

theorem word_uniform (n : ℕ) : (Law.uniform : Law (Bits n)).map (word n)=Law.uniform :=
  uniform_equiv (wordEquiv n)

#print axioms split_uniform
#print axioms chunks_uniform
#print axioms value_lt
#print axioms value_injective
#print axioms word_injective
#print axioms word_bijective
#print axioms word_uniform
end FT1536.S05.BitTapes016
