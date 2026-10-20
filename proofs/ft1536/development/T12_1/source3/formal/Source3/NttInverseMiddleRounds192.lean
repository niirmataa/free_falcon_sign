import Source3.NttInverseMiddleU1Loop192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The eight-round outer loop of the original intermediate doubling pass
   of the accepted modp_iNTT3_ext corpus at logn 9 / full 0: the
   tInit/mInit initialization (t = 2, m = 256), the eight m iterations
   with ht = t >> 1, the u1-group loop of each round (the closed
   NttInverseMiddleU1Loop192.full instance), the t <<= 1 body shift and
   the m >>= 1 increment, composing to the execution of the whole
   intermediatePass statement. The exported image records the final
   words as the executed word terms: the round output words are the
   butterfly words of the round input words over the loaded twiddle
   words, composed across the eight rounds. Values stay executed words
   only; no transform property is assumed. -/
namespace FT1536.Source3.NttInverseMiddleRounds192
open C99ArrayReference (State Name Pointer bindPointer bindValue restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk walk_index walk_count walk_width)
open NttInverseMiddleBody192 (bb high)

def mWalk : C99ModularReference.Stmt :=
  .loop NttInversePrograms192.mGuard NttInversePrograms192.mInner NttInversePrograms192.mStep

def names : List Name := ["ht".toList,"u1".toList,"v1".toList]

/- Round parameters: t doubles from 2, ht halves the t of the round, m
   halves from 256; all eight rounds keep t*m = 512. -/
def tOf (i : Nat) : Nat := 2^(i+1)
def htOf (i : Nat) : Nat := 2^i
def mOf (i : Nat) : Nat := 2^(8-i)

theorem tOf_succ (i : Nat) : tOf (i+1) = tOf i * 2 := by
  show 2^(i+1+1) = 2^(i+1)*2
  rw [Nat.pow_succ]

theorem pow_two_div_two (k : Nat) : 2^(k+1) / 2 = 2^k := by
  have lo : 2^k * 2 ≤ 2^(k+1) := by rw [Nat.pow_succ]
  have hi : 2^(k+1) < (2^k+1) * 2 := by
    have e : (2^k+1) * 2 = 2^k * 2 + 2 := by
      rw [Nat.add_mul,Nat.one_mul]
    rw [e,Nat.pow_succ]
    omega
  exact Nat.div_eq_of_lt_le lo hi

theorem htOf_eq (i : Nat) : tOf i / 2 = htOf i := by
  show 2^(i+1)/2 = 2^i
  exact pow_two_div_two i

theorem mOf_succ (i : Nat) (bound : i+1 ≤ 8) : mOf i / 2 = mOf (i+1) := by
  show 2^(8-i)/2 = 2^(8-(i+1))
  have tail : 8-(i+1) = 8-i-1 := by omega
  have e : 8-i = (8-i-1)+1 := by omega
  rw [e,pow_two_div_two,tail]

theorem tOf_htOf (i : Nat) : 2*htOf i = tOf i := by
  show 2*2^i = 2^(i+1)
  rw [Nat.pow_succ]
  exact Nat.mul_comm _ _

theorem round_product (i : Nat) (bound : i ≤ 8) : mOf i * tOf i = 512 := by
  show 2^(8-i)*2^(i+1) = 512
  have e : (8-i)+(i+1) = 9 := by omega
  rw [← Nat.pow_add,e]

theorem two_pow_bound (i : Nat) (bound : i+1 ≤ 8) : tOf i < 2^64 := by
  show 2^(i+1) < 2^64
  exact Nat.pow_lt_pow_of_lt (by decide : 1 < 2) (by omega : i+1 < 64)

theorem ht_pow_bound (i : Nat) (bound : i+1 ≤ 8) : htOf i < 2^64 := by
  show 2^i < 2^64
  exact Nat.pow_lt_pow_of_lt (by decide : 1 < 2) (by omega : i < 64)

theorem m_pow_bound (i : Nat) (bound : i+1 ≤ 8) : mOf i < 2^64 := by
  show 2^(8-i) < 2^64
  exact Nat.pow_lt_pow_of_lt (by decide : 1 < 2) (by omega : 8-i < 64)

theorem pow_nonzero (k : Nat) : 0 < 2^k := Nat.two_pow_pos k

theorem htOf_bound (i : Nat) (bound : i+1 ≤ 8) : htOf i ≤ 256 := by
  show 2^i ≤ 256
  have step : 2^i ≤ 2^8 := Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : i ≤ 8)
  simpa using step

theorem mOf_bound (i : Nat) (bound : i+1 ≤ 8) : mOf i ≤ 256 := by
  show 2^(8-i) ≤ 256
  have step : 2^(8-i) ≤ 2^8 := Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : 8-i ≤ 8)
  simpa using step

theorem tOf_two (i : Nat) (bound : i+1 ≤ 8) : 2 ≤ tOf i := by
  show 2 ≤ 2^(i+1)
  have step : 2^1 ≤ 2^(i+1) := Nat.pow_le_pow_right (by decide : 0 < 2) (by omega : 1 ≤ i+1)
  simpa using step

/- Round word composition: the output words of one round are the
   executed butterfly words of the input words over the group twiddle
   words; low positions take the bb word and high positions the mont
   word. -/
def nextWord (fv : Nat → BitVec 32) (t ht : Nat) (tws : Nat → BitVec 32) (p p0i : BitVec 32)
    (n : Nat) : BitVec 32 :=
  if n % t < ht then bb (fv n) (fv (n+ht)) p
  else high (fv (n-ht)) (fv n) (tws (n/t)) p p0i

def roundTws (tws : Nat → BitVec 32) (i : Nat) : Nat → BitVec 32 := fun g => tws (mOf i+g)

def fvAt (fv : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) :
    Nat → Nat → BitVec 32
  | 0,n => fv n
  | i+1,n => nextWord (fvAt fv tws p p0i i) (tOf i) (htOf i) (roundTws tws i) p p0i n

theorem next_low (fv : Nat → BitVec 32) (t ht : Nat) (tws : Nat → BitVec 32) (p p0i : BitVec 32)
    (g j : Nat) (span : 2*ht ≤ t) (htPositive : 0 < ht) (slot : j < ht) :
    nextWord fv t ht tws p p0i (g*t+j) = bb (fv (g*t+j)) (fv (g*t+ht+j)) p := by
  have small : j < t := by have := span; omega
  have mod : (g*t+j) % t = j := by
    have comm : g*t+j = j + g*t := by omega
    rw [comm,Nat.add_mul_mod_self_right]
    exact Nat.mod_eq_of_lt small
  have branch : (g*t+j) % t < ht := by rw [mod]; exact slot
  have sum : g*t+j+ht = g*t+ht+j := by omega
  unfold nextWord
  rw [ite_eq_left branch,sum]

theorem next_high (fv : Nat → BitVec 32) (t ht : Nat) (tws : Nat → BitVec 32) (p p0i : BitVec 32)
    (g j : Nat) (span : 2*ht ≤ t) (htPositive : 0 < ht) (slot : j < ht) :
    nextWord fv t ht tws p p0i (g*t+ht+j) =
      high (fv (g*t+j)) (fv (g*t+ht+j)) (tws g) p p0i := by
  have small : ht+j < t := by have := span; omega
  have mod : (g*t+ht+j) % t = ht+j := by
    have comm : g*t+ht+j = (ht+j) + g*t := by omega
    rw [comm,Nat.add_mul_mod_self_right]
    exact Nat.mod_eq_of_lt small
  have branch : ¬ (g*t+ht+j) % t < ht := by rw [mod]; omega
  have diff : g*t+ht+j-ht = g*t+j := by omega
  have ratio : (g*t+ht+j)/t = g := by
    have comm : g*t+ht+j = (ht+j) + g*t := by omega
    rw [comm,Nat.add_mul_div_right (ht+j) g (by have := htPositive; omega)]
    have zero : (ht+j)/t = 0 := Nat.div_eq_of_lt small
    rw [zero]
    omega
  unfold nextWord
  rw [ite_eq_right branch,diff,ratio]

/- Round invariant: the round-constant facts of the whole eight-round
   run, with the twiddle table reads held for all used indices. -/
structure Fixed (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (tws : Nat → BitVec 32) : Prop where
  strideBound : stride < 2^64
  wide : 512*stride < 2^64
  aWidth : a.elementBytes=4
  aCapacity : a.index+512*stride ≤ a.count
  aWritable : s.heap.writable a.block=true
  igmCapacity : igm.index+512 ≤ igm.count
  nCell : USlot s "n" 512
  strideCell : USlot s "stride" stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  aBinding : s.arrays "a".toList=some a
  igmBinding : s.arrays "igm".toList=some igm
  separate : ∀ j k : Nat, j < 512 → k < 512 → j ≠ k → Separate (walk a j stride) (walk a k stride)
  twSeparate : ∀ k : Nat, k < 512 → ∀ j : Nat, j < 512 →
    Separate (walk a j stride) ({igm with index := igm.index+k})
  twLoads : ∀ k : Nat, k < 512 → Load32 s.heap ({igm with index := igm.index+k}) (tws k)

theorem u1_fixed (s : State) (a igm : ArrayPointer) (stride : Nat) (i : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a igm stride p p0i tws) (bound : i+1 ≤ 8)
    (tCell : USlot s "t" (tOf i)) (mCell : USlot s "m" (mOf i))
    (htCell : USlot s "ht" (htOf i)) :
    NttInverseMiddleU1Loop192.Fixed s a igm stride (tOf i) (htOf i) (mOf i) p p0i
      (roundTws tws i) fv where
  tBound := two_pow_bound i bound
  htBound := ht_pow_bound i bound
  mBound := m_pow_bound i bound
  strideBound := fixed.strideBound
  htPositive := pow_nonzero _
  span := Nat.le_of_eq (tOf_htOf i)
  wideT := by
    rw [round_product i (by omega)]
    decide
  wideV := by
    rw [round_product i (by omega)]
    exact fixed.wide
  wideHt := by
    have step : htOf i*stride ≤ 512*stride :=
      Nat.mul_le_mul_right stride (by
        have := htOf_bound i bound
        show htOf i ≤ 512
        omega)
    exact Nat.lt_of_le_of_lt step fixed.wide
  wideM := by
    have step := mOf_bound i bound
    show mOf i+mOf i < 2^64
    omega
  aWidth := fixed.aWidth
  aCapacity := by
    rw [round_product i (by omega)]
    exact fixed.aCapacity
  aWritable := fixed.aWritable
  igmCapacity := by
    have step := mOf_bound i bound
    have grow : igm.index + (mOf i + mOf i) ≤ igm.index + 512 := by omega
    exact Nat.le_trans grow fixed.igmCapacity
  tCell := tCell
  htCell := htCell
  mCell := mCell
  strideCell := fixed.strideCell
  pCell := fixed.pCell
  iCell := fixed.iCell
  aBinding := fixed.aBinding
  igmBinding := fixed.igmBinding
  separate := fun j k first second different => fixed.separate j k
    (by rw [round_product i (by omega)] at first; exact first)
    (by rw [round_product i (by omega)] at second; exact second) different
  twSeparate := fun g slot j jBound => fixed.twSeparate (mOf i+g)
    (by
      have two := tOf_two i bound
      have step : 2*mOf i ≤ mOf i*tOf i := by
        have := Nat.mul_le_mul_left (mOf i) two
        omega
      have grow : mOf i+g < 2*mOf i := by omega
      rw [← round_product i (by omega)]
      omega)
    j (by rw [round_product i (by omega)] at jBound; exact jBound)
  twLoads := fun g slot => fixed.twLoads (mOf i+g)
    (by
      have two := tOf_two i bound
      have step : 2*mOf i ≤ mOf i*tOf i := by
        have := Nat.mul_le_mul_left (mOf i) two
        omega
      have grow : mOf i+g < 2*mOf i := by omega
      rw [← round_product i (by omega)]
      omega)

end FT1536.Source3.NttInverseMiddleRounds192
