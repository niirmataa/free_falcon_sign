import Source3.NttInverseMiddleRounds192
import Source3.NttInversePrologue201

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseSchedule201
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open NttInverseCorrectionLoop192 (walk)
open MkgmParams198 (Level half count)
open NttInverseMiddleRounds192 (tOf htOf nextWord pow_two_div_two tOf_htOf)

def size (l : Level) := count l
def mOf (l : Level) (i : Nat) := 2^(l.val-i)

theorem size_eq (l : Level) : size l=2^(l.val+1) := by
  unfold size count half
  rw [Nat.pow_succ]
  exact Nat.mul_comm _ _

theorem size_bound (l : Level) : size l ≤ 512 ∧ size l<2^64 := by
  have h:=MkgmParams198.half_range l
  unfold size count
  omega

theorem mOf_succ (l : Level) (i : Nat) (bound : i+1 ≤ l.val) : mOf l i/2=mOf l (i+1) := by
  show 2^(l.val-i)/2=2^(l.val-(i+1))
  have e : l.val-i=(l.val-(i+1))+1 := by omega
  rw [e,pow_two_div_two]

theorem round_product (l : Level) (i : Nat) (bound : i ≤ l.val) : mOf l i*tOf i=size l := by
  unfold mOf tOf
  rw [← Nat.pow_add]
  have e : l.val-i+(i+1)=l.val+1 := by omega
  rw [e,size_eq]

theorem two_pow_bound (l : Level) (i : Nat) (bound : i+1 ≤ l.val) : tOf i<2^64 := by
  have limit:=l.isLt
  exact Nat.pow_lt_pow_of_lt (by decide : 1<2) (by omega : i+1<64)

theorem ht_pow_bound (l : Level) (i : Nat) (bound : i+1 ≤ l.val) : htOf i<2^64 := by
  have limit:=l.isLt
  exact Nat.pow_lt_pow_of_lt (by decide : 1<2) (by omega : i<64)

theorem m_pow_bound (l : Level) (i : Nat) (bound : i+1 ≤ l.val) : mOf l i<2^64 := by
  have limit:=l.isLt
  exact Nat.pow_lt_pow_of_lt (by decide : 1<2) (by omega : l.val-i<64)

theorem htOf_bound (l : Level) (i : Nat) (bound : i+1 ≤ l.val) : htOf i ≤ half l := by
  exact Nat.pow_le_pow_right (by decide : 0<2) (by omega : i ≤ l.val)

theorem mOf_bound (l : Level) (i : Nat) : mOf l i ≤ half l :=
  Nat.pow_le_pow_right (by decide : 0<2) (Nat.sub_le _ _)

theorem tOf_two (i : Nat) : 2 ≤ tOf i :=
  Nat.pow_le_pow_right (by decide : 0<2) (by omega : 1 ≤ i+1)

def roundTws (l : Level) (tws : Nat → BitVec 32) (i : Nat) : Nat → BitVec 32 := fun g => tws (mOf l i+g)

def fvAt (l : Level) (fv : Nat → BitVec 32) (tws : Nat → BitVec 32) (p p0i : BitVec 32) :
    Nat → Nat → BitVec 32
  | 0,n => fv n
  | i+1,n => nextWord (fvAt l fv tws p p0i i) (tOf i) (htOf i) (roundTws l tws i) p p0i n

structure Fixed (l : Level) (s : State) (a igm : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (tws : Nat → BitVec 32) : Prop where
  strideBound : stride<2^64
  wide : size l*stride<2^64
  aWidth : a.elementBytes=4
  aCapacity : a.index+size l*stride ≤ a.count
  aWritable : s.heap.writable a.block=true
  igmCapacity : igm.index+size l ≤  igm.count
  nCell : USlot s "n" (size l)
  strideCell : USlot s "stride" stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  aBinding : s.arrays "a".toList=some a
  igmBinding : s.arrays "igm".toList=some igm
  separate : ∀ j k : Nat, j<size l → k<size l → j≠k → Separate (walk a j stride) (walk a k stride)
  twSeparate : ∀ k : Nat, k<size l → ∀ j : Nat, j<size l →
    Separate (walk a j stride) ({igm with index:=igm.index+k})
  twLoads : ∀ k : Nat, k<size l → Load32 s.heap ({igm with index:=igm.index+k}) (tws k)

theorem u1_fixed (l : Level) (s : State) (a igm : ArrayPointer) (stride : Nat) (i : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed l s a igm stride p p0i tws) (bound : i+1  ≤  l.val)
    (tCell : USlot s "t" (tOf i)) (mCell : USlot s "m" (mOf l i))
    (htCell : USlot s "ht" (htOf i)) :
    NttInverseMiddleU1Loop192.Fixed s a igm stride (tOf i) (htOf i) (mOf l i) p p0i
      (roundTws l tws i) fv where
  tBound := two_pow_bound l i bound
  htBound := ht_pow_bound l i bound
  mBound := m_pow_bound l i bound
  strideBound := fixed.strideBound
  htPositive := NttInverseMiddleRounds192.pow_nonzero _
  span := Nat.le_of_eq (tOf_htOf i)
  wideT := by
    rw [round_product l i (by omega)]
    exact (size_bound l).2
  wideV := by
    rw [round_product l i (by omega)]
    exact fixed.wide
  wideHt := by
    have sizeHalf : size l=2*half l := rfl
    have step : htOf i*stride  ≤  (size l)*stride :=
      Nat.mul_le_mul_right stride (by
        have := htOf_bound l i bound
        show htOf i  ≤  (size l)
        omega)
    exact Nat.lt_of_le_of_lt step fixed.wide
  wideM := by
    have step := mOf_bound l i
    have range:=MkgmParams198.half_range l
    show mOf l i+mOf l i < 2^64
    omega
  aWidth := fixed.aWidth
  aCapacity := by
    rw [round_product l i (by omega)]
    exact fixed.aCapacity
  aWritable := fixed.aWritable
  igmCapacity := by
    have sizeHalf : size l=2*half l := rfl
    have step := mOf_bound l i
    have grow : igm.index + (mOf l i + mOf l i)  ≤  igm.index + (size l) := by omega
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
    (by rw [round_product l i (by omega)] at first; exact first)
    (by rw [round_product l i (by omega)] at second; exact second) different
  twSeparate := fun g slot j jBound => fixed.twSeparate (mOf l i+g)
    (by
      have two := tOf_two i
      have step : 2*mOf l i  ≤  mOf l i*tOf i := by
        have := Nat.mul_le_mul_left (mOf l i) two
        omega
      have grow : mOf l i+g < 2*mOf l i := by omega
      rw [← round_product l i (by omega)]
      omega)
    j (by rw [round_product l i (by omega)] at jBound; exact jBound)
  twLoads := fun g slot => fixed.twLoads (mOf l i+g)
    (by
      have two := tOf_two i
      have step : 2*mOf l i  ≤  mOf l i*tOf i := by
        have := Nat.mul_le_mul_left (mOf l i) two
        omega
      have grow : mOf l i+g < 2*mOf l i := by omega
      rw [← round_product l i (by omega)]
      omega)


end FT1536.Source3.NttInverseSchedule201
