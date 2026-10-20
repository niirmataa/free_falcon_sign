import Run2.BitSubtract

namespace FT1536.Run2.BitArithmetic

def remainder (xs q : List Bool) : Result :=
  match xs with
  | [] => ⟨[],1⟩
  | b::bs =>
    let r := remainder bs q
    let v := b::r.bits
    let c := compareWords v q
    match c.1 with
    | .lt => ⟨v,r.steps+c.2+1⟩
    | _ => let s:=subtract v q false; ⟨s.bits,r.steps+c.2+s.steps+1⟩

theorem bit_le_one (b : Bool) : bit b≤1 := by cases b <;> decide

theorem remainder_correct (xs q : List Bool) (hq : 0<value q) :
    value (remainder xs q).bits=value xs%value q := by
  induction xs with
  | nil => simp [remainder,value]
  | cons b bs ih =>
    let v := b::(remainder bs q).bits
    have hv : value v<2*value q := by
      have hr := Nat.mod_lt (value bs) hq
      have hb := bit_le_one b
      dsimp [v,value]
      rw [ih]
      omega
    have hmod : value v%value q=value (b::bs)%value q := by
      simp only [v,value,ih,Nat.add_mod,Nat.mul_mod,Nat.mod_mod]
    have hc := compare_correct v q
    cases ho : (compareWords v q).1 with
    | lt =>
      rw [ho] at hc
      change value v<value q at hc
      dsimp only [v] at ho
      simp only [remainder,ho]
      exact (Nat.mod_eq_of_lt hc).symm.trans hmod
    | eq =>
      rw [ho] at hc
      change value v=value q at hc
      have hs := subtract_correct v q hc.ge
      dsimp only [v] at ho
      simp only [remainder,ho]
      rw [hs.1]
      rw [←hmod,hc]
      simp
    | gt =>
      rw [ho] at hc
      change value q<value v at hc
      have hs := subtract_correct v q hc.le
      have hd : value v-value q<value q := by omega
      have he : (value v-value q+value q)%value q=value v%value q :=
        congrArg (fun n => n%value q) (Nat.sub_add_cancel hc.le)
      simp only [Nat.add_mod_right,Nat.mod_eq_of_lt hd] at he
      dsimp only [v] at ho
      simp only [remainder,ho]
      exact hs.1.trans (he.trans hmod)

theorem remainder_length (xs q : List Bool) :
    (remainder xs q).bits.length≤xs.length+q.length := by
  induction xs with
  | nil => simp [remainder]
  | cons b bs ih =>
    simp only [remainder,List.length_cons]
    split
    · simp only [List.length_cons]; omega
    · rw [subtract_length]
      simp only [List.length_cons]
      omega

theorem remainder_steps (xs q : List Bool) :
    (remainder xs q).steps≤128*(xs.length+q.length+1)*(xs.length+1) := by
  induction xs with
  | nil => simp [remainder]; omega
  | cons b bs ih =>
    have hl := remainder_length bs q
    have hm : max ((remainder bs q).bits.length+1) q.length≤bs.length+q.length+1 := by omega
    simp only [remainder,List.length_cons]
    split <;> simp only [compare_steps,subtract_steps,List.length_cons] <;> nlinarith

theorem split_value (xs : List Bool) (n : ℕ) :
    value (xs.take n)+2^n*value (xs.drop n)=value xs := by
  induction n generalizing xs with
  | zero => simp [value]
  | succ n ih =>
    cases xs with
    | nil => simp [value]
    | cons b bs =>
      have hh := ih bs
      simp only [List.take_succ_cons,List.drop_succ_cons,value,pow_succ]
      nlinarith

theorem take_preserves_value (xs : List Bool) (n : ℕ) (h : value xs<2^n) :
    value (xs.take n)=value xs := by
  have hh := split_value xs n
  have hz : value (xs.drop n)=0 := by
    by_contra hn
    have hp := Nat.mul_le_mul_left (2^n) (show 1≤value (xs.drop n) by omega)
    simp only [Nat.mul_one] at hp
    omega
  simpa only [hz,Nat.mul_zero,Nat.add_zero] using hh

def canonicalRemainder (xs q : List Bool) : Result :=
  let r:=remainder xs q
  ⟨r.bits.take q.length,r.steps+2*q.length+1⟩

theorem canonicalRemainder_correct (xs q : List Bool) (hq : 0<value q) :
    value (canonicalRemainder xs q).bits=value xs%value q ∧
      (canonicalRemainder xs q).bits.length≤q.length := by
  have hc := remainder_correct xs q hq
  have hv : value (remainder xs q).bits<2^q.length := by
    rw [hc]
    exact (Nat.mod_lt _ hq).trans (value_lt q)
  exact ⟨(take_preserves_value _ _ hv).trans hc,List.length_take_le _ _⟩

end FT1536.Run2.BitArithmetic
