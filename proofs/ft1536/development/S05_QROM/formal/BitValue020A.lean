import StandaloneRuntime019
import WordArithmetic020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.BitValue020A
open WordRAM020 WordArithmetic020

def bit (b : Bool) : Nat := if b then 1 else 0

def value (bits : Nat → Bool) : Nat → Nat → Nat
  | 0,_ => 0
  | n+1,base => bit (bits base)+2*value bits n (base+1)

theorem bit_le (b : Bool) : bit b ≤ 1 := by cases b <;> decide

theorem value_lt (bits : Nat → Bool) (n base : Nat) : value bits n base < 2^n := by
  induction n generalizing base with
  | zero => simp [value]
  | succ n ih =>
    have h := ih (base+1)
    have hb := bit_le (bits base)
    simp only [value,pow_succ]
    omega

/-- Last-bit recurrence matches the descending-address machine loop. -/
theorem value_snoc (bits : Nat → Bool) (n base : Nat) :
    value bits (n+1) base=value bits n base+2^n*bit (bits (base+n)) := by
  induction n generalizing base with
  | zero => simp [value]
  | succ n ih =>
    change bit (bits base)+2*value bits (n+1) (base+1) =
      (bit (bits base)+2*value bits n (base+1))+2^(n+1)*bit (bits (base+(n+1)))
    rw [ih,pow_succ]
    have he : base+1+n=base+(n+1) := by omega
    rw [he]
    ring

theorem reference_value (bits : Nat → Bool) (n base : Nat) :
    StandaloneRuntime019.value n (fun i => bits (base+i.val))=value bits n base := by
  induction n generalizing base with
  | zero => rfl
  | succ n ih =>
    simp only [StandaloneRuntime019.value,Fin.val_zero,Nat.add_zero,value,bit]
    have he : (fun i : Fin n => bits (base+i.succ.val))=(fun i => bits ((base+1)+i.val)) := by
      funext i
      congr 1
      simp only [Fin.val_succ]
      omega
    rw [he,ih]
    rfl

/-- Total extension for reasoning only. Actual loads require a valid address. -/
def tapeBits (i : Input) (k : Nat) : Bool := if h : k<tapeSize then i.tape ⟨k,h⟩ else false

theorem tapeBits_at (i : Input) (k : Fin tapeSize) : tapeBits i k.val=i.tape k := by
  simp [tapeBits,k.isLt]

theorem nat_fits {n : Nat} (hn : n<2^400) : Fits (n : Int) := by
  apply small_fits
  · exact le_trans (neg_nonpos.mpr (pow_nonneg (by decide) _)) (Nat.cast_nonneg _)
  · exact_mod_cast hn

theorem tiny_fits {n : Nat} (hn : n≤24662538624) : Fits (n : Int) := by
  apply nat_fits
  exact lt_of_le_of_lt hn (by norm_num)

end FT1536.S05.BitValue020A
