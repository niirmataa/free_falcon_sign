import Run2.BitArithmetic

namespace FT1536.Run2.BitArithmetic

def fullSubtract (a b c : Bool) : Bool×Bool :=
  (Bool.xor (Bool.xor a b) c, ((!a)&&(b||c))||(b&&c))

theorem fullSubtract_correct (a b c : Bool) :
    bit (fullSubtract a b c).1+bit b+bit c=bit a+2*bit (fullSubtract a b c).2 := by
  cases a <;> cases b <;> cases c <;> rfl

structure SubResult where
  bits : List Bool
  borrow : Bool
  steps : ℕ

def subtract : List Bool → List Bool → Bool → SubResult
  | [],[],c => ⟨[],c,1⟩
  | a::as,[],c =>
      let d:=fullSubtract a false c
      let r:=subtract as [] d.2
      ⟨d.1::r.bits,r.borrow,16+r.steps⟩
  | [],b::bs,c =>
      let d:=fullSubtract false b c
      let r:=subtract [] bs d.2
      ⟨d.1::r.bits,r.borrow,16+r.steps⟩
  | a::as,b::bs,c =>
      let d:=fullSubtract a b c
      let r:=subtract as bs d.2
      ⟨d.1::r.bits,r.borrow,16+r.steps⟩

theorem subtract_identity (xs ys : List Bool) (c : Bool) :
    value (subtract xs ys c).bits+value ys+bit c =
      value xs+2^(max xs.length ys.length)*bit (subtract xs ys c).borrow := by
  induction xs generalizing ys c with
  | nil =>
    induction ys generalizing c with
    | nil => simp [subtract,value]
    | cons b bs ih =>
      have hh := ih (fullSubtract false b c).2
      have hf := fullSubtract_correct false b c
      simp only [subtract,value,List.length_nil,List.length_cons,Nat.zero_max,pow_succ,bit_false] at *
      nlinarith
  | cons a as ih =>
    cases ys with
    | nil =>
      have hh := ih [] (fullSubtract a false c).2
      have hf := fullSubtract_correct a false c
      simp only [subtract,value,List.length_nil,List.length_cons,Nat.max_zero,pow_succ,bit_false] at *
      nlinarith
    | cons b bs =>
      have hh := ih bs (fullSubtract a b c).2
      have hf := fullSubtract_correct a b c
      simp only [subtract,value,List.length_cons,max_add_add_right,pow_succ] at *
      nlinarith

theorem subtract_length (xs ys : List Bool) (c : Bool) :
    (subtract xs ys c).bits.length=max xs.length ys.length := by
  induction xs generalizing ys c with
  | nil =>
    induction ys generalizing c with
    | nil => simp [subtract]
    | cons b bs ih => simp only [subtract,List.length_nil,List.length_cons,Nat.zero_max,ih]
  | cons a as ih =>
    cases ys with
    | nil => simp only [subtract,List.length_nil,List.length_cons,Nat.max_zero,ih]
    | cons b bs => simp only [subtract,List.length_cons,max_add_add_right,ih]

theorem subtract_steps (xs ys : List Bool) (c : Bool) :
    (subtract xs ys c).steps=16*max xs.length ys.length+1 := by
  induction xs generalizing ys c with
  | nil =>
    induction ys generalizing c with
    | nil => simp [subtract]
    | cons b bs ih => simp only [subtract,List.length_nil,List.length_cons,Nat.zero_max,ih]; omega
  | cons a as ih =>
    cases ys with
    | nil => simp only [subtract,List.length_nil,List.length_cons,Nat.max_zero,ih]; omega
    | cons b bs => simp only [subtract,List.length_cons,max_add_add_right,ih]; omega

theorem value_lt (xs : List Bool) : value xs<2^xs.length := by
  induction xs with
  | nil => simp [value]
  | cons b bs ih => cases b <;> simp only [value,List.length_cons,pow_succ,bit_false,bit_true] <;> omega

theorem subtract_correct (xs ys : List Bool) (h : value ys≤value xs) :
    value (subtract xs ys false).bits=value xs-value ys ∧ (subtract xs ys false).borrow=false := by
  have hh := subtract_identity xs ys false
  have hv := value_lt (subtract xs ys false).bits
  rw [subtract_length] at hv
  cases hc : (subtract xs ys false).borrow with
  | false => simp only [hc,bit_false,mul_zero,add_zero] at hh; constructor; omega; rfl
  | true => simp only [hc,bit_false,bit_true,mul_one,add_zero] at hh; omega

end FT1536.Run2.BitArithmetic
