import DecodeStatic
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge

def noneRaw (hi lo : Byte) : Nat := (hi.val*256)|||lo.val
def noneExtended (w : Nat) : Nat := w ||| (u32 (-Int.ofNat (w &&& 32768))).toNat
def nonePost (w : Nat) : Int := u32 ((noneExtended w : Int)+18433)
def noneFlag (w : Int) : Nat :=
  ((u32 (9216-w)).toNat &&& (u32 (w-27650)).toNat)/2147483648
def noneWord (hi lo : Byte) : Option Int :=
  let w:=nonePost (noneRaw hi lo)
  if noneFlag w=0 then none else some (s16 (w-18433))

theorem none_raw_range (hi lo : Byte) : noneRaw hi lo<65536 := by
  unfold noneRaw
  exact Nat.or_lt_two_pow (show hi.val*256<2^16 by have h:=hi.isLt;omega)
    (show lo.val<2^16 by have h:=lo.isLt;omega)
theorem none_extended_range (w : Nat) (hw : w<65536) : noneExtended w<4294967296 := by
  unfold noneExtended
  have hu:=u32_range (-Int.ofNat (w &&& 32768))
  exact Nat.or_lt_two_pow (show w<2^32 by omega) (show (u32 (-Int.ofNat (w &&& 32768))).toNat<2^32 by omega)

theorem msb_and (a b : Nat) (ha : a<4294967296) (hb : b<4294967296) :
    (a &&& b)/2147483648≠0 ↔ a/2147483648=1 ∧ b/2147483648=1 := by
  have he : (a &&& b)/2147483648=(a/2147483648)&&&(b/2147483648) := by
    simpa only [Nat.shiftRight_eq_div_pow] using Nat.shiftRight_and_distrib (i:=31) (a:=a) (b:=b)
  have h0 : a/2147483648=0 ∨ a/2147483648=1 := by omega
  have h1 : b/2147483648=0 ∨ b/2147483648=1 := by omega
  rcases h0 with h0|h0 <;> rcases h1 with h1|h1 <;> simp [he,h0,h1]

theorem none_flag_range (w : Int) (hw : 0≤w ∧ w<4294967296) (hf : noneFlag w≠0) :
    9216<w ∧ w<27650 := by
  have ha:=u32_range (9216-w)
  have hb:=u32_range (w-27650)
  have h:= (msb_and (u32 (9216-w)).toNat (u32 (w-27650)).toNat (by omega) (by omega)).mp hf
  unfold u32 at *
  omega
theorem none_word_spec (hi lo : Byte) (v : Int) (h : noneWord hi lo=some v) :
    v=nonePost (noneRaw hi lo)-18433 ∧ -9216≤v ∧ v≤9216 := by
  dsimp only [noneWord] at h
  generalize hw : nonePost (noneRaw hi lo)=w at h ⊢
  have hword : 0≤w ∧ w<4294967296 := by
    rw [←hw]
    exact u32_range ((noneExtended (noneRaw hi lo) : Int)+18433)
  clear hw
  split at h
  · cases h
  · rename_i hn
    have hb:=none_flag_range w hword hn
    cases h
    have he : s16 (w-18433)=w-18433 :=
      s16_exact _ (by unfold FT1536.InInt16;omega)
    rw [he]
    exact ⟨rfl,by omega,by omega⟩

def byteAt (d : Bytes) (i : Nat) : Byte := d[i]?.getD ⟨0,by decide⟩
theorem byteAt_in_range (d : Bytes) (i : Nat) (hi : i<d.length) : byteAt d i=d[i]'hi := by
  unfold byteAt
  rw [List.getElem?_eq_getElem hi]
  rfl
theorem none_read_bounds (d : Bytes) (hlen : 3072≤d.length) (i : Nat) (hi : i<1536) :
    2*i<d.length ∧ 2*i+1<d.length ∧ i+1≤1536 := by omega

def noneLoop : Nat → Nat → Bytes → Option (List Int)
  | 0,_,_ => some []
  | n+1,u,d =>
    match noneWord (byteAt d (2*u)) (byteAt d (2*u+1)) with
    | none => none
    | some v => match noneLoop n (u+1) d with | none => none | some vs => some (v::vs)
def decodeNone (d : Bytes) : Option (List Int × Nat) :=
  if d.length<3072 then none else
    match noneLoop 1536 0 d with | none => none | some vs => some (vs,3072)

theorem none_loop_spec (n u : Nat) (d : Bytes) (vs : List Int) (h : noneLoop n u d=some vs) :
    vs.length=n ∧ (∀ v, v∈vs → -9216≤v ∧ v≤9216) := by
  induction n generalizing u vs with
  | zero => cases h; exact ⟨rfl,by simp⟩
  | succ n ih =>
    rw [noneLoop] at h
    cases hs : noneWord (byteAt d (2*u)) (byteAt d (2*u+1)) with
    | none => simp only [hs] at h; cases h
    | some v =>
      have hv:=none_word_spec _ _ v hs
      simp only [hs] at h
      cases ht : noneLoop n (u+1) d with
      | none => simp only [ht] at h; cases h
      | some tail =>
        simp only [ht] at h
        cases h
        have hs:=ih (u+1) tail ht
        refine ⟨by simp [hs.1],?_⟩
        intro x hx
        rcases List.mem_cons.mp hx with rfl|hx
        · exact hv.2
        · exact hs.2 x hx

theorem DECODE_NONE (d : Bytes) (vs : List Int) (used : Nat) (h : decodeNone d=some (vs,used)) :
    vs.length=1536 ∧ (∀ x, x∈vs → FT1536.InInt16 x) ∧ used=3072 ∧ used≤d.length := by
  unfold decodeNone at h
  split at h
  · cases h
  · rename_i hlen
    cases hs : noneLoop 1536 0 d with
    | none => simp only [hs] at h; cases h
    | some xs =>
      simp only [hs] at h
      cases h
      have spec:=none_loop_spec 1536 0 d vs hs
      refine ⟨spec.1,?_,rfl,by omega⟩
      intro x hx
      have hr:=spec.2 x hx
      unfold FT1536.InInt16
      omega

#check @none_word_spec
#check @DECODE_NONE
#print axioms none_raw_range
#print axioms none_extended_range
#print axioms msb_and
#print axioms none_flag_range
#print axioms none_word_spec
#print axioms byteAt_in_range
#print axioms none_read_bounds
#print axioms none_loop_spec
#print axioms DECODE_NONE
end FT1536Bridge
