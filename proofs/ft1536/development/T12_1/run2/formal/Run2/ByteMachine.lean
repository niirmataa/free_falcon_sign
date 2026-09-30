import Run2.WordEncoding
import Run2.Games

namespace FT1536.Run2.ByteMachine
open BitArithmetic

/- The argument encoding is the physical eight-bit representation of the
input byte. Comparison itself is the proved bit-by-bit comparator. -/
def equal (a b : Byte) : Bool × ℕ :=
  let c:=compareWords (encodeNat a.val 8) (encodeNat b.val 8)
  (decide (c.1=Ordering.eq),c.2+1)

theorem equal_correct (a b : Byte) : (equal a b).1=decide (a=b) := by
  have ha : a.val<2^8:=a.isLt
  have hb : b.val<2^8:=b.isLt
  have hc:=compare_correct (encodeNat a.val 8) (encodeNat b.val 8)
  rw [encodeNat_value _ _ ha,encodeNat_value _ _ hb] at hc
  have he : (compareWords (encodeNat a.val 8) (encodeNat b.val 8)).1=Ordering.eq ↔ a=b := by
    cases ho : (compareWords (encodeNat a.val 8) (encodeNat b.val 8)).1 <;>
      simp_all [OrderMeaning,Fin.ext_iff] <;> omega
  simp only [equal,he]

theorem equal_steps (a b : Byte) : (equal a b).2=130 := by
  norm_num [equal,compare_steps,encodeNat_length]

def compare : Bytes → Bytes → Bool × ℕ
  | [],[] => (true,1)
  | [],_::_ => (false,1)
  | _::_,[] => (false,1)
  | a::as,b::bs =>
      let c:=equal a b
      if c.1 then let r:=compare as bs; (r.1,c.2+3+r.2)
      else (false,c.2+3)

theorem compare_correct (x y : Bytes) : (compare x y).1=decide (x=y) := by
  induction x generalizing y with
  | nil => cases y <;> simp [compare]
  | cons a as ih =>
    cases y with
    | nil => simp [compare]
    | cons b bs =>
      by_cases he:a=b <;> simp [compare,equal_correct,he,ih]

theorem compare_cost (x y : Bytes) :
    (compare x y).2≤133*min x.length y.length+1 := by
  induction x generalizing y with
  | nil => cases y <;> simp [compare]
  | cons a as ih =>
    cases y with
    | nil => simp [compare]
    | cons b bs =>
      have hh:=ih bs
      simp only [compare,equal_steps,List.length_cons]
      split <;> omega

end FT1536.Run2.ByteMachine
