import SourceFloor
set_option maxRecDepth 16384
set_option maxHeartbeats 4000000
namespace FloorCT
open ZeroScalar
open H3Range (p2)
def M : Nat := 18446744073709551616
def P : Int := 9223372036854775808
def sign (x : Word) : Nat := x.val/9223372036854775808
def xi (x : Word) : Int := if sign x=0 then (rawMant x:Int) else -(rawMant x:Int)
def cc (x : Word) : Int := 1085-(ex x:Int)
def count (x : Word) : Nat := ((cc x)%64).toNat
def flag (x : Word) : Int := (63-cc x)%4294967296/2147483648
def irsh (v : Int) (n : Nat) : Int :=
  (if n/32=0 then v else v/p2 32)/p2 (n%32)
def enc (v : Int) : Nat := (v%(M:Int)).toNat
def dec (v : Nat) : Int := if v<9223372036854775808 then (v:Int) else (v:Int)-(M:Int)
def candidateBits (x : Word) : Nat :=
  let shifted:=enc (irsh (xi x) (count x))
  let mask:=enc (-flag x)
  (shifted &&& (18446744073709551615-mask)) ||| (enc (-(sign x:Int)) &&& mask)
def candidateLong (x : Word) : Int := dec (candidateBits x)
theorem fields (x : Word) :
    (sign x=0 ∨ sign x=1) ∧ ex x≤2047 ∧ -962≤cc x ∧ cc x≤1085 ∧
    count x<64 ∧ (flag x=0 ∨ flag x=1) := by
  have hw:=x.isLt
  unfold sign ex cc count flag
  omega
theorem mantissa_range (x : Word) : 4611686018427387904≤rawMant x ∧ rawMant x≤9223372036854774784 := by
  rw [raw_mantissa]
  have hf:=frac_bound x
  omega
theorem xi_range (x : Word) : -P<xi x ∧ xi x<P := by
  have h:=mantissa_range x
  unfold xi P
  split <;> omega
theorem irsh_eq (v : Int) (n : Nat) (hn : n<64) : irsh v n=v/p2 n := by
  unfold irsh
  by_cases h : n<32
  · have hq : n/32=0 := by omega
    have hr : n%32=n := Nat.mod_eq_of_lt h
    rw [hq,hr,ite_eq_left rfl]
  · have hq : n/32≠0 := by omega
    rw [ite_eq_right hq,Int.ediv_ediv_of_nonneg (by decide : 0≤p2 32),←ZeroScalar.p2_add]
    congr 2
    omega
theorem enc_bound (v : Int) : enc v<M := by unfold enc M;omega
theorem decode_encode (v : Int) (hv : -P≤v ∧ v<P) : dec (enc v)=v := by
  unfold dec enc M P at *
  split <;> omega
theorem div_range (v : Int) (n : Nat) (hv : -P≤v ∧ v<P) : -P≤v/p2 n ∧ v/p2 n<P := by
  have hd : 0<p2 n := ZeroScalar.p2_pos n
  have hnon : 0≤P*(p2 n-1) := Int.mul_nonneg (by decide : 0≤P) (by omega)
  have hmul : P≤P*p2 n := by rw [Int.mul_sub,Int.mul_one] at hnon;omega
  have hlo : (-P)*(p2 n)≤v := by rw [Int.neg_mul];omega
  have hhi : v<P*p2 n := by omega
  exact ⟨(Int.le_ediv_iff_mul_le hd).mpr hlo,(Int.ediv_lt_iff_lt_mul hd).mpr hhi⟩
theorem old_range (x : Word) : -P≤floorC x ∧ floorC x<P := by
  have h:=fields x
  have hx:=xi_range x
  have hr:=div_range (xi x) (count x) (by omega)
  change -P≤(if flag x=0 then xi x/p2 (count x) else -(sign x:Int)) ∧
    (if flag x=0 then xi x/p2 (count x) else -(sign x:Int))<P
  split
  · exact hr
  · unfold P at *;omega
theorem uand_full (v : Nat) : v &&& 18446744073709551615=v%M := by
  exact Nat.and_two_pow_sub_one_eq_mod v 64
theorem candidate_bit_equivalence (x : Word) : candidateBits x=enc (floorC x) := by
  have hs:=(fields x).2.2.2.2.1
  have hb:=(fields x).2.2.2.2.2
  have ha:=enc_bound (irsh (xi x) (count x))
  have ht:=enc_bound (-(sign x:Int))
  change candidateBits x=enc (if flag x=0 then xi x/p2 (count x) else -(sign x:Int))
  rcases hb with h|h
  · unfold candidateBits
    rw [h]
    simp only [Int.neg_zero,show enc 0=0 by decide,Nat.sub_zero,Nat.and_zero,Nat.or_zero,uand_full,Nat.mod_eq_of_lt ha]
    rw [irsh_eq _ _ hs]
    rfl
  · unfold candidateBits
    rw [h]
    simp only [show enc (-1)=18446744073709551615 by decide,Nat.sub_self,Nat.and_zero,Nat.zero_or,uand_full,Nat.mod_eq_of_lt ht]
    rfl
theorem all_word64_equivalence (x : Word) : candidateLong x=floorC x := by
  unfold candidateLong
  rw [candidate_bit_equivalence]
  exact decode_encode _ (old_range x)
def DefinedLP64 (x : Word) : Prop :=
  -P<xi x ∧ xi x<P ∧ -962≤cc x ∧ cc x≤1085 ∧ count x<64 ∧
  count x/32≤1 ∧ count x%32<32 ∧
  (flag x=0 ∨ flag x=1) ∧ -P≤floorC x ∧ floorC x<P ∧
  -P≤candidateLong x ∧ candidateLong x<P
theorem all_word64_defined (x : Word) : DefinedLP64 x := by
  have h:=fields x
  have hx:=xi_range x
  have ho:=old_range x
  rw [DefinedLP64,all_word64_equivalence]
  exact ⟨hx.1,hx.2,h.2.2.1,h.2.2.2.1,h.2.2.2.2.1,by omega,by omega,h.2.2.2.2.2,ho.1,ho.2,ho.1,ho.2⟩
end FloorCT
