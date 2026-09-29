import CDF
set_option maxRecDepth 8192
set_option maxHeartbeats 3000000
namespace H3Range

-- Integers below represent exact dyadics multiplied by a common positive D.
-- Error terms are signed, not silently replaced by an IEEE guarantee.
def Between (x r : Int) : Prop := -r≤x ∧ x≤r
theorem scalar_residual (D mu sf z err E : Int) (hD : 0<D)
    (hf : 0≤mu-D*sf ∧ mu-D*sf<D) (hz : -365≤z ∧ z≤366) (he : Between err E) :
    Between (mu-D*(sf+z)+err) (366*D+E) := by
  have hzlo:=Int.mul_le_mul_of_nonneg_left hz.1 (show 0≤D by omega)
  have hzhi:=Int.mul_le_mul_of_nonneg_left hz.2 (show 0≤D by omega)
  unfold Between at *
  simp only [Int.mul_add]
  omega

theorem terminal_right_then_left (D r1 rx r0 pre0 fl0 z0 err2 err3 E1 Eh E2 E3 : Int)
    (hD : 0<D) (h1 : Between r1 (366*D+E1))
    (hh : Between (2*rx-r1) (2*Eh))
    (hf0 : 0≤pre0-D*fl0 ∧ pre0-D*fl0<D) (hz0 : -365≤z0 ∧ z0≤366)
    (he2 : Between err2 E2) (he3 : Between err3 E3)
    (out : r0=pre0-D*(fl0+z0)+err2-rx+err3) :
    Between (2*r0) (1098*D+E1+2*Eh+2*E2+2*E3) := by
  have h0:=scalar_residual D pre0 fl0 z0 err2 E2 hD hf0 hz0 he2
  unfold Between at *
  omega

-- This lemma is ordered: a previously established right residual controls
-- the NEXT left center. It assumes nothing about that call's later return.
theorem next_terminal_center (t0 r1 rx c err T R Eh Ea : Int)
    (ht : Between t0 T) (hr : Between r1 R) (hh : Between (2*rx-r1) (2*Eh))
    (he : Between err Ea) (hc : c=t0+rx+err) : Between (2*c) (2*T+R+2*Eh+2*Ea) := by
  unfold Between at *
  omega

theorem safe_next_center (t0 r1 rx c err T R Eh Ea : Int)
    (ht : Between t0 T) (hr : Between r1 R) (hh : Between (2*rx-r1) (2*Eh))
    (he : Between err Ea) (hc : c=t0+rx+err)
    (budget : 2*T+R+2*Eh+2*Ea≤4294966562) :
    -2147483281≤c ∧ c≤2147483281 := by
  have h:=next_terminal_center t0 r1 rx c err T R Eh Ea ht hr hh he hc
  unfold Between at h
  omega

def innerVisits : Nat → Nat → List (Nat × Nat)
  | 0,base => [(base,1),(base,0)]
  | l+1,base =>
    let n:=2^(l+1)
    innerVisits l (base+n+(l+1)*2^l) ++ innerVisits l (base+n)
def depthVisits (l base : Nat) : List (Nat × Nat) :=
  let n:=2^l;let s:=l*2^(l-1);let child:=base+3*n
  innerVisits (l-1) (child+2*s) ++ innerVisits (l-1) (child+s) ++ innerVisits (l-1) child
def topVisits : List (Nat × Nat) := depthVisits 9 (1536+3*(11*256)) ++ depthVisits 9 1536
theorem inner_visits_count (l base : Nat) : (innerVisits l base).length=2^(l+1) := by
  induction l generalizing base with
  | zero => rfl
  | succ l ih => simp only [innerVisits,List.length_append,ih,Nat.pow_succ];omega
theorem actual_3072_calls : topVisits.length=3072 := by
  simp only [topVisits,depthVisits,List.length_append,inner_visits_count]
theorem first_terminal_right_first : topVisits.take 2=[(18431,1),(18431,0)] := by decide

-- Source poly_big_to_small's success forces the emitted coefficient cap.
def smallLoop : List Int → Option (List Int)
  | [] => some []
  | x::xs => if x< -2047 ∨ 2047<x then none else
      match smallLoop xs with | none => none | some ys => some (x::ys)
theorem checked_key_coefficients (xs ys : List Int) (h : smallLoop xs=some ys) :
    ys=xs ∧ ∀ x, x∈ys → -2047≤x ∧ x≤2047 := by
  induction xs generalizing ys with
  | nil => cases h;exact ⟨rfl,by simp⟩
  | cons x xs ih =>
    rw [smallLoop] at h
    split at h
    · cases h
    · rename_i hx
      cases hs : smallLoop xs with
      | none => simp only [hs] at h;cases h
      | some zs =>
        simp only [hs] at h
        cases h
        obtain ⟨he,hr⟩:=ih zs hs
        refine ⟨by rw [he],?_⟩
        intro y hy
        rcases List.mem_cons.mp hy with rfl|hy
        · omega
        · exact hr y hy

#check @scalar_residual
#check @terminal_right_then_left
#check @next_terminal_center
#check @safe_next_center
#check @checked_key_coefficients
#print axioms scalar_residual
#print axioms terminal_right_then_left
#print axioms next_terminal_center
#print axioms safe_next_center
#print axioms inner_visits_count
#print axioms actual_3072_calls
#print axioms first_terminal_right_first
#print axioms checked_key_coefficients
end H3Range
