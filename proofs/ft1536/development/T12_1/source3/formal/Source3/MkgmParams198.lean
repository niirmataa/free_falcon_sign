import Source3.Gen0RowIndex189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Shared exact parameters for every remaining full=0 generator size. -/
namespace FT1536.Source3.MkgmParams198
abbrev Level := Fin 9

def logn (l : Level) : Nat := l.val+1
def half (l : Level) : Nat := 2^l.val
def count (l : Level) : Nat := 2*half l
def shift (l : Level) : Nat := 10-l.val
def factor (l : Level) : Nat := 2^(shift l-1)
def scale (l : Level) : Nat := 2^shift l
def lognWord (l : Level) : BitVec 32 := BitVec.ofNat 32 (logn l)
def shiftWord (l : Level) : BitVec 32 := BitVec.ofNat 32 (shift l)
def reverse (l : Level) (u : Nat) : Nat := KeygenMkgm3Indices.reverse9 (factor l*u)
def lastIndex (l : Level) (u : Nat) : Nat := half l+reverse l u

theorem logn_range (l : Level) : 1≤logn l ∧ logn l≤9 := by
  have h:=l.isLt
  simp only [logn]
  omega

theorem half_range (l : Level) : 0<half l ∧ half l≤256 := by fin_cases l <;> decide
theorem shift_range (l : Level) : 2≤shift l ∧ shift l≤10 := by fin_cases l <;> decide
theorem factor_half (l : Level) : factor l*half l=512 := by fin_cases l <;> decide
theorem scale_half (l : Level) : scale l*half l=1024 := by fin_cases l <;> decide
theorem scale_factor (l : Level) : scale l=2*factor l := by fin_cases l <;> decide
theorem factor_positive (l : Level) : 0<factor l := by fin_cases l <;> decide
theorem scale_positive (l : Level) : 0<scale l := by fin_cases l <;> decide

theorem table_range (l : Level) (u : Nat) (bound : u<half l) : factor l*u<512 := by
  have h := Nat.mul_lt_mul_of_pos_left bound (factor_positive l)
  rw [factor_half] at h
  exact h

theorem shift_index_range (l : Level) (u : Nat) (bound : u<half l) : scale l*u<1024 := by
  have h := Nat.mul_lt_mul_of_pos_left bound (scale_positive l)
  rw [scale_half] at h
  exact h

theorem reverse_range (l : Level) (u : Nat) (bound : u<half l) : reverse l u<half l := by
  have all : ∀ l : Level, ∀ u : Fin (half l), reverse l u.val<half l := by decide +kernel
  exact all l ⟨u,bound⟩

theorem reverse_involutive (l : Level) (u : Nat) (bound : u<half l) : reverse l (reverse l u)=u := by
  have all : ∀ l : Level, ∀ u : Fin (half l), reverse l (reverse l u.val)=u.val := by decide +kernel
  exact all l ⟨u,bound⟩

theorem reverse_surjective (l : Level) (j : Fin (half l)) :
    ∃ u : Fin (half l), reverse l u.val=j.val :=
  ⟨⟨reverse l j.val,reverse_range l j.val j.isLt⟩,reverse_involutive l j.val j.isLt⟩

theorem last_range (l : Level) (u : Nat) (bound : u<half l) :
    half l≤lastIndex l u ∧ lastIndex l u<count l := by
  have h:=reverse_range l u bound
  simp only [lastIndex,count]
  omega

theorem logn_integer (l : Level) :
    (C99IntegerReference.Value.uint32 (lognWord l)).integer=(logn l : Int) := by fin_cases l <;> decide

theorem shift_integer (l : Level) :
    (C99IntegerReference.Value.uint32 (shiftWord l)).integer=(shift l : Int) := by fin_cases l <;> decide

end FT1536.Source3.MkgmParams198
