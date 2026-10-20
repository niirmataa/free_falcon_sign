import Source3.NttInverseMiddleU1Loop192
import Source3.C99OuterScalar144
import Source3.KeygenNttControl
import Source3.KeygenMkgm3RowInit

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

theorem mOf_two (i : Nat) (bound : i+1 ≤ 8) : mOf i = 2*mOf (i+1) := by
  show 2^(8-i) = 2*2^(8-(i+1))
  have tail : 8-(i+1) = 8-i-1 := by omega
  have e : 8-i = (8-i-1)+1 := by omega
  rw [e,tail,Nat.pow_succ]
  exact (Nat.mul_comm _ _).symm

theorem group_shift (i g : Nat) : g*tOf (i+1) = (g*2)*tOf i := by
  show g*2^(i+1+1) = (g*2)*2^(i+1)
  simp only [Nat.pow_succ,Nat.mul_comm,Nat.mul_left_comm,Nat.mul_assoc]

theorem group_two (i g : Nat) (bound : i+1 ≤ 8) (slot : g < mOf (i+1)) : g*2 < mOf i := by
  have split := mOf_two i bound
  omega

theorem round_lowpos (i g' j : Nat) : g'*tOf (i+1)+j = (g'*2)*tOf i + j := by
  rw [group_shift i g']

theorem round_highpos (i g' j : Nat) :
    g'*tOf (i+1)+htOf (i+1)+j = (g'*2+1)*tOf i + j := by
  have shift : g'*tOf (i+1) = (g'*2)*tOf i := group_shift i g'
  have half : htOf (i+1) = tOf i := rfl
  rw [shift,half]
  simp only [Nat.add_mul,Nat.one_mul,Nat.mul_assoc]

theorem round_image (s : State) (a : ArrayPointer) (stride : Nat) (i : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv0 : Nat → BitVec 32)
    (bound : i+1 ≤ 8)
    (image : NttInverseMiddleU1Loop192.Image s a stride (tOf i) (htOf i) (mOf i)
      (roundTws tws i) p p0i (fvAt fv0 tws p p0i i) (mOf i)) :
    NttInverseMiddleU1Loop192.Image s a stride (tOf (i+1)) (htOf (i+1)) (mOf (i+1))
      (roundTws tws (i+1)) p p0i (fvAt fv0 tws p p0i (i+1)) 0 := by
  intro g' j slot' jBound
  have group : g'*2 < mOf i := group_two i g' bound slot'
  have groupSucc : g'*2+1 < mOf i := by
    have split := mOf_two i bound
    omega
  have span : 2*htOf i = tOf i := tOf_htOf i
  have jSmall : j < tOf i := jBound
  constructor
  · intro impossible
    exact absurd impossible (Nat.not_lt_zero g')
  · intro _
    by_cases low : j < htOf i
    · have evaluated := next_low (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i)
        p p0i (g'*2) j (Nat.le_of_eq span) (pow_nonzero _) low
      have transformed := (image (g'*2) j group low).1 group
      have evaluated' := next_low (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i)
        p p0i (g'*2+1) j (Nat.le_of_eq span) (pow_nonzero _) low
      have transformed' := (image (g'*2+1) j groupSucc low).1 groupSucc
      constructor
      · rw [round_lowpos i g' j]
        show Load32 s.heap (walk a ((g'*2)*tOf i + j) stride)
          (fvAt fv0 tws p p0i (i+1) ((g'*2)*tOf i + j))
        rw [show fvAt fv0 tws p p0i (i+1) ((g'*2)*tOf i + j)=
          nextWord (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i) p p0i
            ((g'*2)*tOf i + j) from rfl,evaluated]
        exact transformed.1
      · rw [round_highpos i g' j]
        show Load32 s.heap (walk a ((g'*2+1)*tOf i + j) stride)
          (fvAt fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + j))
        rw [show fvAt fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + j)=
          nextWord (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i) p p0i
            ((g'*2+1)*tOf i + j) from rfl,evaluated']
        exact transformed'.1
    · have offset : j - htOf i < htOf i := by
        have := span
        omega
      have join : htOf i + (j - htOf i) = j := by omega
      have evaluated := next_high (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i)
        p p0i (g'*2) (j - htOf i) (Nat.le_of_eq span) (pow_nonzero _) offset
      have transformed := (image (g'*2) (j - htOf i) group offset).1 group
      have evaluated' := next_high (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i)
        p p0i (g'*2+1) (j - htOf i) (Nat.le_of_eq span) (pow_nonzero _) offset
      have transformed' := (image (g'*2+1) (j - htOf i) groupSucc offset).1 groupSucc
      have position : g'*tOf (i+1)+j = (g'*2)*tOf i + htOf i + (j - htOf i) := by
        rw [round_lowpos i g' j]
        omega
      have position' : g'*tOf (i+1)+htOf (i+1)+j =
          (g'*2+1)*tOf i + htOf i + (j - htOf i) := by
        rw [round_highpos i g' j]
        omega
      constructor
      · rw [position]
        show Load32 s.heap (walk a ((g'*2)*tOf i + htOf i + (j - htOf i)) stride)
          (fvAt fv0 tws p p0i (i+1) ((g'*2)*tOf i + htOf i + (j - htOf i)))
        rw [show fvAt fv0 tws p p0i (i+1) ((g'*2)*tOf i + htOf i + (j - htOf i))=
          nextWord (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i) p p0i
            ((g'*2)*tOf i + htOf i + (j - htOf i)) from rfl,evaluated]
        exact transformed.2
      · rw [position']
        show Load32 s.heap (walk a ((g'*2+1)*tOf i + htOf i + (j - htOf i)) stride)
          (fvAt fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + htOf i + (j - htOf i)))
        rw [show fvAt fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + htOf i + (j - htOf i))=
          nextWord (fvAt fv0 tws p p0i i) (tOf i) (htOf i) (roundTws tws i) p p0i
            ((g'*2+1)*tOf i + htOf i + (j - htOf i)) from rfl,evaluated']
        exact transformed'.2

/- Round body execution (part 2 tail): the mInner block of one m round at
   the executed words — the ht/u1/v1 declarations, ht = t >> 1 as the u64
   shr word (the div-two conversion with the cell identity
   tOf i / 2 = htOf i), the closed u1-group loop instance at
   (tOf i, htOf i, mOf i), the t <<= 1 body shift and the trailing skip
   under the block scope. Values stay executed words only. -/
open KeygenNttLoopSupport (u64)

def declared (s : State) : State := C99DeclarationStatements.effect .u64 names s
def prepared (s : State) (h : Nat) : State := bindValue (declared s) "ht".toList .uint64 (u64 h)

def innerBody : C99ModularReference.Stmt :=
  .seq (NttInversePrograms192.declareU64 ["ht","u1","v1"])
    (.seq NttInversePrograms192.htAssign
      (.seq NttInversePrograms192.u1Loop
        (.seq (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1))
          (.base .skip))))

theorem mInner_split : NttInversePrograms192.mInner=.scope names innerBody := by decide

theorem restore_locals (before after : State) (list : List Name) (name : Name)
    (absent : name∉list) :
    (restoreScope before after list []).locals name=after.locals name := by
  have restore : (restoreScope before after list []).locals name=
      (if list.contains name then before.locals name else after.locals name) := rfl
  rw [restore]
  split_ifs with h
  · exact absurd (List.contains_iff_mem.mp h) absent
  · rfl

theorem put_locals (before : State) (name : Name) (w : BitVec 64) (other : Name)
    (different : other≠name) :
    (FftLocalCells140.put before name w).locals other=before.locals other :=
  FftLocalCells140.outside before name other w different

theorem effect_keep (s : State) (name : String) (n : Nat) (absent : name.toList∉names)
    (cell : USlot s name n) : USlot (declared s) name n :=
  (NttInverseMiddleU1Loop192.effect_outside .u64 names s name.toList absent).trans cell

theorem prepared_keep (s : State) (h : Nat) (name : String) (n : Nat)
    (different : name.toList≠"ht".toList) (cell : USlot (declared s) name n) :
    USlot (prepared s h) name n := by
  have keep : (prepared s h).locals name.toList=(declared s).locals name.toList := by
    simp only [prepared,bindValue,C99ScalarReference.set,different,ite_false]
  exact keep.trans cell

theorem effect_keep32 (s : State) (name : String) (w : BitVec 32) (absent : name.toList∉names)
    (cell : Slot s name w) : Slot (declared s) name w :=
  (NttInverseMiddleU1Loop192.effect_outside .u64 names s name.toList absent).trans cell

theorem prepared_keep32 (s : State) (h : Nat) (name : String) (w : BitVec 32)
    (different : name.toList≠"ht".toList) (cell : Slot (declared s) name w) :
    Slot (prepared s h) name w := by
  have keep : (prepared s h).locals name.toList=(declared s).locals name.toList := by
    simp only [prepared,bindValue,C99ScalarReference.set,different,ite_false]
  exact keep.trans cell

theorem declared_u1 (s : State) : (declared s).locals "u1".toList=some (.uint64,none) := rfl
theorem declared_v1 (s : State) : (declared s).locals "v1".toList=some (.uint64,none) := rfl

theorem prepared_u1 (s : State) (h : Nat) : (prepared s h).locals "u1".toList=some (.uint64,none) := by
  have keep : (prepared s h).locals "u1".toList=(declared s).locals "u1".toList := by
    simp only [prepared,bindValue,C99ScalarReference.set,
      show ("u1".toList : Name)≠"ht".toList from by decide,ite_false]
  rw [keep]
  exact declared_u1 s

theorem prepared_v1 (s : State) (h : Nat) : (prepared s h).locals "v1".toList=some (.uint64,none) := by
  have keep : (prepared s h).locals "v1".toList=(declared s).locals "v1".toList := by
    simp only [prepared,bindValue,C99ScalarReference.set,
      show ("v1".toList : Name)≠"ht".toList from by decide,ite_false]
  rw [keep]
  exact declared_v1 s

theorem prepared_ht (s : State) (h : Nat) (bound : h<2^64) : USlot (prepared s h) "ht" h :=
  KeygenMkgm3RowInit.set64_slot (declared s) "ht" h bound

/- Round-constant reconstruction at a successor state: the bounds, span
   and separation facts are state-free; the cells, bindings, writability
   and twiddle reads are supplied for the new state. -/
theorem fixed_state {s s' : State} {a igm : ArrayPointer} {stride : Nat} {p p0i : BitVec 32}
    {tws : Nat → BitVec 32} (base : Fixed s a igm stride p p0i tws)
    (nCell : USlot s' "n" 512) (strideCell : USlot s' "stride" stride)
    (pCell : Slot s' "p" p) (iCell : Slot s' "p0i" p0i)
    (aBinding : s'.arrays "a".toList=some a) (igmBinding : s'.arrays "igm".toList=some igm)
    (aWritable : s'.heap.writable a.block=true)
    (twLoads : ∀ k : Nat, k < 512 → Load32 s'.heap ({igm with index := igm.index+k}) (tws k)) :
    Fixed s' a igm stride p p0i tws where
  strideBound := base.strideBound
  wide := base.wide
  aWidth := base.aWidth
  aCapacity := base.aCapacity
  aWritable := aWritable
  igmCapacity := base.igmCapacity
  nCell := nCell
  strideCell := strideCell
  pCell := pCell
  iCell := iCell
  aBinding := aBinding
  igmBinding := igmBinding
  separate := base.separate
  twSeparate := base.twSeparate
  twLoads := twLoads

/- The u64 shr word through the div-two conversion. -/
theorem shr_word (x : Nat) (bound : x<2^64) :
    C99IntegerReference.ShiftExec .right (u64 x) (C99IntegerReference.convert .int32 1)
      (u64 (x/2)) := by
  have raw := C99IntegerReference.ShiftExec.right (u64 x)
    (C99IntegerReference.convert .int32 1) 1 rfl (by change (1 : Nat)<64; decide)
  have half : (u64 x).integer/2^1=(u64 x).integer/2 := by simp [pow_one]
  have hty : (u64 x).type=C99IntegerReference.Ty.uint64 := rfl
  rw [half] at raw
  rw [hty] at raw
  rw [KeygenNttLoopSupport.convert_div_two x bound] at raw
  exact raw

theorem below (i x : Nat) (bound : i+1 ≤ 8) (slot : x < mOf i * tOf i) : x < 512 := by
  have := round_product i (by omega)
  omega

/- One executed m round: the mInner block at round i. -/
theorem round_run (i : Nat) (bound : i+1 ≤ 8) (s : State) (a igm : ArrayPointer) (stride : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv0 : Nat → BitVec 32)
    (fixed : Fixed s a igm stride p p0i tws)
    (tCell : USlot s "t" (tOf i)) (mCell : USlot s "m" (mOf i))
    (image : NttInverseMiddleU1Loop192.Image s a stride (tOf i) (htOf i) (mOf i)
      (roundTws tws i) p p0i (fvAt fv0 tws p p0i i) 0) :
    ∃ out, Exec NttInversePrograms192.mInner s ⟨out,.normal⟩ ∧
      Fixed out a igm stride p p0i tws ∧
      USlot out "t" (tOf (i+1)) ∧ USlot out "m" (mOf i) ∧
      NttInverseMiddleU1Loop192.Image out a stride (tOf (i+1)) (htOf (i+1)) (mOf (i+1))
        (roundTws tws (i+1)) p p0i (fvAt fv0 tws p p0i (i+1)) 0 ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < 512 → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) ∧
      out.heap.writable=s.heap.writable := by
  have tBound : tOf i < 2^64 := two_pow_bound i bound
  have htBound : htOf i < 2^64 := ht_pow_bound i bound
  have mBound : mOf i < 2^64 := m_pow_bound i bound
  have product : mOf i * tOf i = 512 := round_product i (by omega)
  have dc : Exec (NttInversePrograms192.declareU64 ["ht","u1","v1"]) s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 names s)
  have tKept : USlot (declared s) "t" (tOf i) := effect_keep s "t" (tOf i) (by decide) tCell
  have mKept : USlot (declared s) "m" (mOf i) := effect_keep s "m" (mOf i) (by decide) mCell
  have nKept : USlot (declared s) "n" 512 := effect_keep s "n" 512 (by decide) fixed.nCell
  have shrWord : C99IntegerReference.ShiftExec .right (u64 (tOf i))
      (C99IntegerReference.convert .int32 1) (u64 (htOf i)) := by
    have raw : C99IntegerReference.ShiftExec .right (u64 (tOf i))
        (C99IntegerReference.convert .int32 1) (u64 (tOf i / 2)) := shr_word (tOf i) tBound
    rw [htOf_eq] at raw
    exact raw
  have htRun : Exec NttInversePrograms192.htAssign (declared s) ⟨prepared s (htOf i),.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 (htOf i)) (by rfl)
      (.scalar _ _ (.shift .right _ _ _ _ _
        (C99LoopScalar141.read (declared s) "t".toList (tOf i) tKept) (.literal .int32 1) shrWord))
  have nPrepared : USlot (prepared s (htOf i)) "n" 512 :=
    prepared_keep s (htOf i) "n" 512 (by decide) nKept
  have tPrepared : USlot (prepared s (htOf i)) "t" (tOf i) :=
    prepared_keep s (htOf i) "t" (tOf i) (by decide) tKept
  have mPrepared : USlot (prepared s (htOf i)) "m" (mOf i) :=
    prepared_keep s (htOf i) "m" (mOf i) (by decide) mKept
  have preparedFixed : Fixed (prepared s (htOf i)) a igm stride p p0i tws :=
    fixed_state fixed nPrepared
      (prepared_keep s (htOf i) "stride" stride (by decide)
        (effect_keep s "stride" stride (by decide) fixed.strideCell))
      (prepared_keep32 s (htOf i) "p" p (by decide)
        (effect_keep32 s "p" p (by decide) fixed.pCell))
      (prepared_keep32 s (htOf i) "p0i" p0i (by decide)
        (effect_keep32 s "p0i" p0i (by decide) fixed.iCell))
      fixed.aBinding fixed.igmBinding fixed.aWritable fixed.twLoads
  have u1Fixed : NttInverseMiddleU1Loop192.Fixed (prepared s (htOf i)) a igm stride
      (tOf i) (htOf i) (mOf i) p p0i (roundTws tws i) (fvAt fv0 tws p p0i i) :=
    u1_fixed (prepared s (htOf i)) a igm stride i p p0i tws (fvAt fv0 tws p p0i i)
      preparedFixed bound tPrepared mPrepared (prepared_ht s (htOf i) htBound)
  obtain ⟨after,u1Run,afterFixed,afterU1,afterV1,afterImage,afterKeep,afterWritable⟩ :=
    NttInverseMiddleU1Loop192.full (prepared s (htOf i)) a igm stride (tOf i) (htOf i) (mOf i)
      p p0i (roundTws tws i) (fvAt fv0 tws p p0i i) u1Fixed none none (prepared_u1 s (htOf i))
      (prepared_v1 s (htOf i)) image
  have tAfter : Cell after "t".toList (tOf i) := afterFixed.tCell
  have tBase : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "t".toList .shl (NttInversePrograms192.num 1))) after
      (FftLocalCells140.put after "t".toList (word (tOf i * 2))) := by
    cases C99ControlShift142.double (fun _ => none) after "t".toList (tOf i) tBound tAfter with
    | base _ _ _ source => exact source
  have tRun : Exec (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1))
      after ⟨FftLocalCells140.put after "t".toList (word (tOf i * 2)),.normal⟩ :=
    .base _ _ _ tBase
  set shifted : State := FftLocalCells140.put after "t".toList (word (tOf i * 2)) with shiftedEq
  have skipRun : Exec (.base .skip) shifted ⟨shifted,.normal⟩ := .base _ _ _ (.skip shifted)
  have tailRun : Exec (.seq (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1))
      (.base .skip)) after ⟨shifted,.normal⟩ :=
    .seqNormal _ _ after shifted ⟨shifted,.normal⟩ tRun skipRun
  have u1Seq : Exec (.seq NttInversePrograms192.u1Loop
      (.seq (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1)) (.base .skip)))
      (prepared s (htOf i)) ⟨shifted,.normal⟩ :=
    .seqNormal _ _ (prepared s (htOf i)) after ⟨shifted,.normal⟩ u1Run tailRun
  have htSeq : Exec (.seq NttInversePrograms192.htAssign
      (.seq NttInversePrograms192.u1Loop
        (.seq (NttInversePrograms192.update "t" .shl (NttInversePrograms192.num 1)) (.base .skip))))
      (declared s) ⟨shifted,.normal⟩ :=
    .seqNormal _ _ (declared s) (prepared s (htOf i)) ⟨shifted,.normal⟩ htRun u1Seq
  have bodyRun : Exec innerBody s ⟨shifted,.normal⟩ :=
    .seqNormal _ _ s (declared s) ⟨shifted,.normal⟩ dc htSeq
  have innerRun : Exec NttInversePrograms192.mInner s ⟨restoreScope s shifted names [],.normal⟩ := by
    rw [mInner_split]
    exact .scope names innerBody s ⟨shifted,.normal⟩ bodyRun
  have control := KeygenNttControl.frame NttInversePrograms192.mInner s
    ⟨restoreScope s shifted names [],.normal⟩ (by decide) innerRun
  refine ⟨restoreScope s shifted names [],innerRun,?_,?_,?_,?_,?_,?_⟩
  · refine fixed_state fixed
      (control.2.1 "n".toList (by decide) |>.trans fixed.nCell)
      (control.2.1 "stride".toList (by decide) |>.trans fixed.strideCell)
      (control.2.1 "p".toList (by decide) |>.trans fixed.pCell)
      (control.2.1 "p0i".toList (by decide) |>.trans fixed.iCell)
      (control.2.2 "a".toList (by decide) |>.trans fixed.aBinding)
      (control.2.2 "igm".toList (by decide) |>.trans fixed.igmBinding) ?_ ?_
    · show after.heap.writable a.block=true
      rw [afterWritable]
      exact fixed.aWritable
    · intro k kBound
      show Load32 after.heap {igm with index := igm.index+k} (tws k)
      exact afterKeep {igm with index := igm.index+k}
        (fun x xSlot => fixed.twSeparate k kBound x (below i x bound xSlot)) (tws k)
        (fixed.twLoads k kBound)
  · have tShift : USlot shifted "t" (tOf i * 2) :=
      FftLocalCells140.cell_at after "t".toList (word (tOf i * 2))
    have tOut : USlot (restoreScope s shifted names []) "t" (tOf i * 2) :=
      (restore_locals s shifted names "t".toList (by decide)).trans tShift
    show USlot (restoreScope s shifted names []) "t" (tOf (i+1))
    rw [tOf_succ]
    exact tOut
  · exact (control.2.1 "m".toList (by decide) |>.trans mCell)
  · show NttInverseMiddleU1Loop192.Image (restoreScope s shifted names []) a stride
      (tOf (i+1)) (htOf (i+1)) (mOf (i+1)) (roundTws tws (i+1)) p p0i
      (fvAt fv0 tws p p0i (i+1)) 0
    exact round_image _ a stride i p p0i tws fv0 bound afterImage
  · intro q sep w loaded
    show Load32 after.heap q w
    exact afterKeep q (fun x xSlot => sep x (below i x bound xSlot)) w loaded
  · show after.heap.writable=s.heap.writable
    exact afterWritable.trans rfl

end FT1536.Source3.NttInverseMiddleRounds192
