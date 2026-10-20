import FT1536.Basic

namespace FT1536.Run2.BitArithmetic

def bit (b : Bool) : ℕ := if b then 1 else 0
@[simp] theorem bit_false : bit false=0 := rfl
@[simp] theorem bit_true : bit true=1 := rfl
def value : List Bool → ℕ
  | [] => 0
  | b::bs => bit b+2*value bs

/- Two XOR, three AND and two OR gates. Carry and sum are explicit bits. -/
def fullAdder (a b c : Bool) : Bool×Bool :=
  (Bool.xor (Bool.xor a b) c, (a&&b)||(a&&c)||(b&&c))

theorem fullAdder_correct (a b c : Bool) :
    bit (fullAdder a b c).1+2*bit (fullAdder a b c).2=bit a+bit b+bit c := by
  cases a <;> cases b <;> cases c <;> rfl

structure Result where
  bits : List Bool
  steps : ℕ

/- The cost includes bit reads/writes, seven gates and loop bookkeeping.
The reference primitive budget is16 bit operations per visited bit position. -/
def add : List Bool → List Bool → Bool → Result
  | [],[],c => ⟨if c then [true] else [],1⟩
  | a::as,[],c =>
      let d := fullAdder a false c
      let r := add as [] d.2
      ⟨d.1::r.bits,16+r.steps⟩
  | [],b::bs,c =>
      let d := fullAdder false b c
      let r := add [] bs d.2
      ⟨d.1::r.bits,16+r.steps⟩
  | a::as,b::bs,c =>
      let d := fullAdder a b c
      let r := add as bs d.2
      ⟨d.1::r.bits,16+r.steps⟩

theorem add_correct (xs ys : List Bool) (carry : Bool) :
    value (add xs ys carry).bits=value xs+value ys+bit carry := by
  induction xs generalizing ys carry with
  | nil =>
    induction ys generalizing carry with
    | nil => cases carry <;> simp [add,value,bit]
    | cons b bs ih =>
      have hh := ih (fullAdder false b carry).2
      have hf := fullAdder_correct false b carry
      simp only [add,value] at *
      simp only [bit_false,zero_add] at hf
      omega
  | cons a as ih =>
    cases ys with
    | nil =>
      have hh := ih [] (fullAdder a false carry).2
      have hf := fullAdder_correct a false carry
      simp only [add,value] at *
      simp only [bit_false,add_zero] at hf
      omega
    | cons b bs =>
      have hh := ih bs (fullAdder a b carry).2
      have hf := fullAdder_correct a b carry
      simp only [add,value] at *
      omega

theorem add_steps (xs ys : List Bool) (carry : Bool) :
    (add xs ys carry).steps=16*(max xs.length ys.length)+1 := by
  induction xs generalizing ys carry with
  | nil =>
    induction ys generalizing carry with
    | nil => simp [add]
    | cons b bs ih => simp only [add,ih,List.length_cons,List.length_nil,Nat.zero_max]; omega
  | cons a as ih =>
    cases ys with
    | nil => simp only [add,ih,List.length_cons,List.length_nil,Nat.max_zero]; omega
    | cons b bs => simp only [add,ih,List.length_cons,max_add_add_right]; omega

theorem add_length (xs ys : List Bool) (carry : Bool) :
    (add xs ys carry).bits.length≤max xs.length ys.length+1 := by
  induction xs generalizing ys carry with
  | nil =>
    induction ys generalizing carry with
    | nil => cases carry <;> simp [add]
    | cons b bs ih =>
      have hh := ih (fullAdder false b carry).2
      simp only [add,List.length_cons,List.length_nil,Nat.zero_max] at *
      omega
  | cons a as ih =>
    cases ys with
    | nil =>
      have hh := ih [] (fullAdder a false carry).2
      simp only [add,List.length_cons,List.length_nil,Nat.max_zero] at *
      omega
    | cons b bs =>
      have hh := ih bs (fullAdder a b carry).2
      simp only [add,List.length_cons,max_add_add_right] at *
      omega

def multiply (xs : List Bool) : List Bool → Result
  | [] => ⟨[],1⟩
  | b::bs =>
      let r := multiply xs bs
      if b then
        let s := add xs (false::r.bits) false
        ⟨s.bits,1+r.steps+s.steps⟩
      else ⟨false::r.bits,2+r.steps⟩

theorem multiply_correct (xs ys : List Bool) :
    value (multiply xs ys).bits=value xs*value ys := by
  induction ys with
  | nil => simp [multiply,value]
  | cons b bs ih =>
    cases b with
    | false => simp [multiply,value,bit,ih]; ring
    | true => simp [multiply,add_correct,value,bit,ih]; ring

theorem zero_bit (xs : List Bool) : value (false::xs)=2*value xs := by simp [value,bit]

theorem multiply_length (xs ys : List Bool) :
    (multiply xs ys).bits.length≤xs.length+2*ys.length := by
  induction ys with
  | nil => simp [multiply]
  | cons b bs ih =>
    cases b with
    | false => simp only [multiply,Bool.false_eq_true,ite_false,List.length_cons]; omega
    | true =>
      have hh := add_length xs (false::(multiply xs bs).bits) false
      simp only [multiply,ite_true,List.length_cons] at *
      omega

theorem multiply_steps (xs ys : List Bool) :
    (multiply xs ys).steps≤64*(xs.length+ys.length+1)*(ys.length+1) := by
  induction ys with
  | nil => simp [multiply]; omega
  | cons b bs ih =>
    have hl := multiply_length xs bs
    have hm : max xs.length ((multiply xs bs).bits.length+1)≤xs.length+2*bs.length+1 := by omega
    cases b with
    | false =>
      simp only [multiply,Bool.false_eq_true,ite_false,List.length_cons]
      nlinarith
    | true =>
      simp only [multiply,ite_true,add_steps,List.length_cons]
      nlinarith

def compareDigit (a b : Bool) (higher : Ordering) : Ordering :=
  match higher with
  | .eq => if a=b then .eq else if a then .gt else .lt
  | o => o

def compareWords : List Bool → List Bool → Ordering×ℕ
  | [],[] => (.eq,1)
  | a::as,[] => let r:=compareWords as []; (compareDigit a false r.1,16+r.2)
  | [],b::bs => let r:=compareWords [] bs; (compareDigit false b r.1,16+r.2)
  | a::as,b::bs => let r:=compareWords as bs; (compareDigit a b r.1,16+r.2)

def OrderMeaning (o : Ordering) (x y : ℕ) : Prop :=
  match o with | .lt => x<y | .eq => x=y | .gt => y<x

theorem compare_digit_correct (a b : Bool) (o : Ordering) (x y : ℕ)
    (h : OrderMeaning o x y) : OrderMeaning (compareDigit a b o) (bit a+2*x) (bit b+2*y) := by
  cases o <;> cases a <;> cases b <;> simp [OrderMeaning,compareDigit,bit] at * <;> omega

theorem compare_correct (xs ys : List Bool) :
    OrderMeaning (compareWords xs ys).1 (value xs) (value ys) := by
  induction xs generalizing ys with
  | nil =>
    induction ys with
    | nil => simp [compareWords,OrderMeaning,value]
    | cons b bs ih =>
      have hh := compare_digit_correct false b (compareWords [] bs).1 0 (value bs) ih
      simpa only [compareWords,value,bit_false,Nat.zero_add,Nat.mul_zero] using hh
  | cons a as ih =>
    cases ys with
    | nil =>
      have hh := compare_digit_correct a false (compareWords as []).1 (value as) 0 (ih [])
      simpa only [compareWords,value,bit_false,Nat.zero_add,Nat.mul_zero] using hh
    | cons b bs => simpa only [compareWords,value] using compare_digit_correct a b _ _ _ (ih bs)

theorem compare_steps (xs ys : List Bool) :
    (compareWords xs ys).2=16*max xs.length ys.length+1 := by
  induction xs generalizing ys with
  | nil =>
    induction ys with
    | nil => simp [compareWords]
    | cons b bs ih => simp only [compareWords,ih,List.length_cons,List.length_nil,Nat.zero_max]; omega
  | cons a as ih =>
    cases ys with
    | nil => simp only [compareWords,ih,List.length_cons,List.length_nil,Nat.max_zero]; omega
    | cons b bs => simp only [compareWords,ih,List.length_cons,max_add_add_right]; omega

end FT1536.Run2.BitArithmetic
