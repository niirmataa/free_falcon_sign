import Source3.KeygenCodecStaticStreamByte

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact finite big-endian bit strings. This is bit algebra only;
   source encoder/decoder refinement is a separate obligation. -/
namespace FT1536.Source3.KeygenCodecStaticBits

def value : List Bool → Nat
  | [] => 0
  | b::rest => b.toNat*2^rest.length+value rest

def digits : Nat → Nat → List Bool
  | 0,_ => []
  | n+1,word => (decide (word/2^n%2=1))::digits n word

theorem digits_length (n word : Nat) : (digits n word).length=n := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [digits,List.length_cons,ih]

theorem value_bound (bits : List Bool) : value bits<2^bits.length := by
  induction bits with
  | nil => decide +kernel
  | cons b rest ih =>
    simp only [value,List.length_cons,pow_succ]
    have positive := Nat.two_pow_pos rest.length
    cases b <;> simp only [Bool.toNat_false,Bool.toNat_true,Nat.zero_mul,Nat.zero_add,Nat.one_mul] <;> omega

theorem value_append (a b : List Bool) : value (a++b)=value a*2^b.length+value b := by
  induction a with
  | nil => simp only [List.nil_append,value,Nat.zero_mul,Nat.zero_add]
  | cons x rest ih =>
    simp only [List.cons_append,value,List.length_append,pow_add,ih]
    ring

theorem mod_two (n : Nat) : (decide (n%2=1)).toNat=n%2 := by
  have bound := Nat.mod_lt n (by decide +kernel : 0<2)
  by_cases same : n%2=1
  · simp only [same,decide_true,Bool.toNat_true]
  · have zero : n%2=0 := by omega
    simp only [zero,show ¬(0 : Nat)=1 by decide +kernel,decide_false,Bool.toNat_false]

theorem digits_value (n word : Nat) : value (digits n word)=word%2^n := by
  induction n with
  | zero => simp only [digits,value,pow_zero,Nat.mod_one]
  | succ n ih =>
    simp only [digits,value,digits_length,ih,mod_two,pow_succ]
    have division := Nat.mod_add_div (word%(2^n*2)) (2^n)
    have remainder : (word%(2^n*2))%2^n=word%2^n :=
      Nat.mod_mod_of_dvd _ (by exact dvd_mul_right (2^n) 2)
    have quotient := Nat.mod_mul_right_div_self word (2^n) 2
    rw [remainder,quotient] at division
    calc
      _ = word%2^n+2^n*(word/2^n%2) := by ac_rfl
      _ = word%(2^n*2) := division

theorem value_injective (a b : List Bool) (length : a.length=b.length) (equal : value a=value b) : a=b := by
  induction a generalizing b with
  | nil =>
    have same : b=[] := List.length_eq_zero_iff.mp length.symm
    exact same.symm
  | cons x rest ih =>
    cases b with
    | nil => simp only [List.length_cons,List.length_nil] at length; omega
    | cons y tail =>
      have sameLength : rest.length=tail.length := by simpa only [List.length_cons,Nat.add_right_cancel_iff] using length
      have lower := value_bound rest
      have upper := value_bound tail
      have positive := Nat.two_pow_pos rest.length
      simp only [value] at equal
      rw [←sameLength] at equal upper
      have sameHead : x=y := by
        cases x <;> cases y <;> simp only [Bool.toNat_false,Bool.toNat_true,Nat.zero_mul,Nat.zero_add,Nat.one_mul] at equal <;> first | rfl | omega
      subst y
      have sameTail : value rest=value tail := by omega
      rw [ih tail sameLength sameTail]

theorem digits_inverse (bits : List Bool) : digits bits.length (value bits)=bits := by
  apply value_injective
  · exact digits_length _ _
  · rw [digits_value,Nat.mod_eq_of_lt (value_bound bits)]

theorem digits_of_append (a b : List Bool) :
    digits (a.length+b.length) (value a*2^b.length+value b)=a++b := by
  rw [←value_append,←List.length_append]
  exact digits_inverse _

theorem suffix (a b : List Bool) : value (a++b)%2^b.length=value b := by
  simp only [value_append,Nat.add_mod,Nat.mul_mod_left,Nat.zero_add,Nat.mod_mod]
  exact Nat.mod_eq_of_lt (value_bound b)

theorem head_value (a b : List Bool) : value (a++b)/2^b.length=value a := by
  rw [value_append,Nat.add_comm,Nat.add_mul_div_right _ _ (Nat.two_pow_pos _),
    Nat.div_eq_of_lt (value_bound b),Nat.zero_add]

end FT1536.Source3.KeygenCodecStaticBits
