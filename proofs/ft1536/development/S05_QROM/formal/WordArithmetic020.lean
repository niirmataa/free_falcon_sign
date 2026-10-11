import WordRAM020

set_option exponentiation.threshold 512
namespace FT1536.S05.WordArithmetic020
open WordRAM020

def Fits (x : Int) : Prop := -(2^511) ≤ x ∧ x < 2^511

theorem decode_word (x : Int) (h : Fits x) : (word x).toInt=x := word_exact x h.1 h.2

theorem add_word (x y : Int) (hx : Fits x) (hy : Fits y) :
    op .add (word x) (word y)=word (x+y) := by
  change word ((word x).toInt + (word y).toInt)=_
  rw [decode_word x hx,decode_word y hy]

theorem sub_word (x y : Int) (hx : Fits x) (hy : Fits y) :
    op .sub (word x) (word y)=word (x-y) := by
  change word ((word x).toInt - (word y).toInt)=_
  rw [decode_word x hx,decode_word y hy]

theorem mul_word (x y : Int) (hx : Fits x) (hy : Fits y) :
    op .mul (word x) (word y)=word (x*y) := by
  change word ((word x).toInt * (word y).toInt)=_
  rw [decode_word x hx,decode_word y hy]

theorem div_word (x y : Int) (hx : Fits x) (hy : Fits y) :
    op .div (word x) (word y)=word (x/y) := by
  change word ((word x).toInt / (word y).toInt)=_
  rw [decode_word x hx,decode_word y hy]

theorem mod_word (x y : Int) (hx : Fits x) (hy : Fits y) :
    op .mod (word x) (word y)=word (x%y) := by
  change word ((word x).toInt % (word y).toInt)=_
  rw [decode_word x hx,decode_word y hy]

theorem lt_word (x y : Int) (hx : Fits x) (hy : Fits y) :
    op .lt (word x) (word y)=word (if x<y then 1 else 0) := by
  change word (if (word x).toInt < (word y).toInt then 1 else 0)=_
  rw [decode_word x hx,decode_word y hy]

/-- Numeric interval covering all planned scalar intermediate bounds. This
    lemma alone does NOT establish the reachability invariant of the program. -/
theorem small_fits (x : Int) (lo : -(2^400) ≤ x) (hi : x < 2^400) : Fits x := by
  constructor <;> linarith [show (2: Int)^400 < 2^511 by norm_num]

theorem read_accumulator_bound (a : Nat) (n : Nat) (h : a < 2^n) (b : Bool) :
    2*a+(if b then 1 else 0)<2^(n+1) := by
  cases b <;> simp only [Bool.false_eq_true,ite_false,ite_true,pow_succ] <;> omega

/-- The signed Euclidean remainder required by the negative scatter update.
    A truncating C remainder would be a different instruction. -/
theorem canonical_remainder (x : Int) : 0 ≤ x%18433 ∧ x%18433 < 18433 := by
  exact ⟨Int.emod_nonneg x (by decide),Int.emod_lt_of_pos x (by decide)⟩

theorem scatter_scalar_bound (x p : Int) (hx : 0≤x ∧ x<18433) (hp : 0≤p ∧ p<18433) :
    -18433 < x-p ∧ x+p < 36866 ∧ x*p < 2^29 := by
  have hm := mul_nonneg (show 0≤18432-x by omega) hp.1
  constructor
  · omega
  constructor
  · omega
  nlinarith

end FT1536.S05.WordArithmetic020
