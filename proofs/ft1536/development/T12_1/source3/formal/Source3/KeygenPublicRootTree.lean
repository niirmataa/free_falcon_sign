import Source3.KeygenPublicRadixInvocation
import Source3.KeygenNttTwiddleCert

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reprove the source-index root tree in q18433. Only natural exponent
   certificates are reused; no transform theorem in another field is used. -/
namespace FT1536.Source3.KeygenPublicRootTree
open KeygenPublicAlgebra (R)
open KeygenPublicRoots (root firstRoot unity point)
open KeygenMkgm3Indices (tableExponent)
open KeygenPublicRadixStages (count size)

def twiddle (k j : Nat) : R := KeygenPublicRadixRow.root (count k) j
def nodeRoot (k j : Nat) : R := twiddle k j^(if k<8 then 2 else 3)

theorem half_order_negative : root^2304= -1 := by
  have equal : root^2304=firstRoot^3 := by
    change root^(768*3)=(root^768)^3
    rw [pow_mul]
  rw [equal]
  linear_combination (firstRoot+1)*KeygenPublicRoots.first_root_relation
theorem power_mod (a b : Nat) (equal : a%4608=b%4608) : root^a=root^b := by
  rw [← pow_mod_orderOf root a,← pow_mod_orderOf root b,KeygenPublicRoots.root_order,equal]
theorem even_square (r : Nat) (lo : 1≤r) (hi : r<256) : (root^tableExponent (2*r))^2=root^tableExponent r := by
  have exponent := (KeygenMkgm3IndexCert.all_indices r (by omega)).2.2.1 ⟨lo,hi⟩
  rw [← pow_mul,Nat.mul_comm (tableExponent (2*r)),← exponent]
theorem odd_square (r : Nat) (lo : 2≤r) (hi : r<256) : (root^tableExponent (2*r+1))^2= -(root^tableExponent r) := by
  rw [← pow_mul,Nat.mul_comm (tableExponent (2*r+1))]
  rw [power_mod _ _ ((KeygenNttTwiddleCert.all_indices r (by omega)).1 ⟨lo,hi⟩),pow_add,half_order_negative]
  ring
theorem even_cube (r : Nat) (lo : 256≤r) (hi : r<512) : (root^tableExponent (2*r))^3=root^tableExponent r := by
  have exponent := (KeygenMkgm3IndexCert.all_indices r (by omega)).2.1 ⟨lo,hi⟩
  rw [← pow_mul,Nat.mul_comm (tableExponent (2*r)),← exponent]
theorem odd_cube (r : Nat) (lo : 256≤r) (hi : r<512) : (root^tableExponent (2*r+1))^3= -(root^tableExponent r) := by
  rw [← pow_mul,Nat.mul_comm (tableExponent (2*r+1))]
  rw [power_mod _ _ ((KeygenNttTwiddleCert.all_indices r (by omega)).2 ⟨lo,hi⟩),pow_add,half_order_negative]
  ring
theorem top_low : nodeRoot 0 0=firstRoot := even_square 1 (by decide) (by decide)
theorem top_high : nodeRoot 0 1=1-firstRoot := by
  change (root^1920)^2=1-firstRoot
  rw [← pow_mul]
  have equal : root^(1920*2)=firstRoot^5 := by
    change root^(768*5)=(root^768)^5
    rw [pow_mul]
  rw [equal,KeygenPublicRoots.first_root_fifth]
theorem parent_square (k j : Nat) (hk : k<8) : nodeRoot k j=twiddle k j^2 := by
  simp only [nodeRoot,hk,ite_true]
theorem child_indices (k j : Nat) :
    count (k+1)+2*j=2*(count k+j) ∧ count (k+1)+(2*j+1)=2*(count k+j)+1 := by
  have step : count (k+1)=count k*2 := Nat.pow_succ 2 (k+1)
  rw [step]
  constructor <;> omega
theorem children (k j : Nat) (hk : k<8) (hj : j<count k) :
    nodeRoot (k+1) (2*j)=twiddle k j ∧ nodeRoot (k+1) (2*j+1)= -twiddle k j := by
  obtain ⟨even,odd⟩ := child_indices k j
  have cm := (KeygenPublicRadixStages.dimensions k hk).2.1
  have positive : 2≤count k := by
    have h : 2^1≤2^(k+1) := Nat.pow_le_pow_right (by decide) (by omega)
    exact h
  unfold nodeRoot twiddle KeygenPublicRadixRow.root
  rw [even,odd]
  by_cases small : k<7
  · have upper : count k≤128 := by
      have cert : ∀ i : Fin 7, count i.val≤128 := by decide
      exact cert ⟨k,small⟩
    simp only [show k+1<8 by omega,ite_true]
    exact ⟨even_square _ (by omega) (by omega),odd_square _ (by omega) (by omega)⟩
  · have eq : k=7 := by omega
    subst k
    change j<256 at hj
    simp only [show ¬7+1<8 by decide,ite_false]
    exact ⟨even_cube _ (by change 256≤256+j; omega) (by change 256+j<512; omega),
      odd_cube _ (by change 256≤256+j; omega) (by change 256+j<512; omega)⟩
theorem leaf_power (j k : Nat) (hj : j<512) (hk : k<3) :
    point ⟨3*j+k,by omega⟩^3=nodeRoot 8 j := by
  rw [KeygenPublicTripleOrder.triple_order j k hj hk,mul_pow]
  have cube : (unity^k)^3=1 := by
    rw [← pow_mul,Nat.mul_comm k 3,pow_mul,KeygenPublicTripleOrder.unity_cube,one_pow]
  rw [cube,mul_one]
  rfl

end FT1536.Source3.KeygenPublicRootTree
