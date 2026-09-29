import RintBits
import BridgeWords
namespace Postprocess
def narrow16 (w : Int) := (w+32768)%65536-32768
def Safe16 (a b : Fin 1536 → Int) := ∀i,(-32768≤a i ∧ a i≤32767) ∧ (-32768≤b i ∧ b i≤32767)
def BadPrecast (a b : Fin 1536 → Int) := ¬Safe16 a b
theorem narrow_range (w : Int) : -32768≤narrow16 w ∧ narrow16 w≤32767 := by unfold narrow16;omega
theorem narrow_preserves_iff (w : Int) : narrow16 w=w ↔ -32768≤w ∧ w≤32767 := by unfold narrow16;omega
theorem joint_preserves_iff (a b : Fin 1536 → Int) :
    (∀i,narrow16 (a i)=a i ∧ narrow16 (b i)=b i) ↔ Safe16 a b := by
  simp only [narrow_preserves_iff,Safe16]
theorem narrow_matches_LV (w : Int) : narrow16 w=FT1536Bridge.s16 w := by rfl
theorem narrowing_countermodel : narrow16 65536=0 ∧ (65536:Int)>32767 := by decide
theorem negative_endpoint_roundtrip : narrow16 (-narrow16 32768)= -32768 := by decide
theorem rint_word_bound_consumer (x w scale : Int) (hs : 0<scale)
    (hx : -585228161*scale≤128*x ∧ 128*x≤585228161*scale)
    (hround : -scale≤2*(scale*w-x) ∧ 2*(scale*w-x)≤scale) : -4572095≤w ∧ w≤4572095 := by
  constructor
  · by_cases h : -4572095≤w
    · exact h
    · have hb : w≤ -4572096 := by omega
      have hm:=Int.mul_le_mul_of_nonneg_left hb (Int.le_of_lt hs)
      have he : scale*(-4572096)= -4572096*scale := Int.mul_comm _ _
      rw [he] at hm;omega
  · by_cases h : w≤4572095
    · exact h
    · have hb : 4572096≤w := by omega
      have hm:=Int.mul_le_mul_of_nonneg_left hb (Int.le_of_lt hs)
      have he : scale*4572096=4572096*scale := Int.mul_comm _ _
      rw [he] at hm;omega
theorem int64_margin : (9223372036854775808-4572095:Nat)=9223372036850203713 := by decide
-- Finite union of joint events; no probability or independence is asserted.
def WholeCallBad (completed : Fin 16 → Prop) (a b : Fin 16 → Fin 1536 → Int) :=
  ∃j,completed j ∧ BadPrecast (a j) (b j)
theorem bad_in_one_attempt (completed : Fin 16 → Prop) (a b : Fin 16 → Fin 1536 → Int)
    (j : Fin 16) (hc : completed j) (hb : BadPrecast (a j) (b j)) : WholeCallBad completed a b := by exact ⟨j,hc,hb⟩
end Postprocess
