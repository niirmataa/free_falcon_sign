import Source3.KeygenNttTwiddleCert
import Source3.KeygenNttTripleValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Child laws use the source tableExponent/REV10 definitions. The top
   complement is separate from the later signed binary splits. -/
namespace FT1536.Source3.KeygenNttTwiddleTree
open KeygenNttWordAlgebra (R)
open KeygenMkgm3Rows (root)
open KeygenMkgm3Indices (tableExponent)
open KeygenNttGeometry (m t ht twiddleIndex)
open KeygenNttFirstValues (firstRoot)

def nodeRoot (i j : Nat) : R := (KeygenNttMiddleValues.root i j)^(if i<8 then 2 else 3)

theorem half_order_negative : root^2304= -1 := by
  have equal : root^2304=firstRoot^3 := by
    change root^(768*3)=(root^768)^3
    rw [pow_mul]
  rw [equal]
  have h := KeygenNttPolynomial.first_root_relation
  linear_combination (firstRoot+1)*h

theorem power_mod (a b : Nat) (equal : a%4608=b%4608) : root^a=root^b := by
  rw [← pow_mod_orderOf root a,← pow_mod_orderOf root b,KeygenMkgm3Rows.root_order,equal]

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
  rw [equal,KeygenNttRoots.first_root_fifth]

theorem parent_square (i j : Nat) (hi : i≤7) : nodeRoot i j=(KeygenNttMiddleValues.root i j)^2 := by
  simp only [nodeRoot,show i<8 by omega,ite_true]

theorem child_indices (i j : Nat) :
    twiddleIndex (i+1) (2*j)=2*twiddleIndex i j ∧
      twiddleIndex (i+1) (2*j+1)=2*twiddleIndex i j+1 := by
  have hm := (KeygenNttGeometry.next_header i).2
  unfold twiddleIndex
  rw [hm]
  constructor <;> omega

theorem children (i j : Nat) (hi : i≤7) (hj : j<m i) :
    nodeRoot (i+1) (2*j)=KeygenNttMiddleValues.root i j ∧
      nodeRoot (i+1) (2*j+1)= -KeygenNttMiddleValues.root i j := by
  have bounds := KeygenNttGeometry.active_twiddle i j hi hj
  obtain ⟨even,odd⟩ := child_indices i j
  unfold nodeRoot KeygenNttMiddleValues.root
  rw [even,odd]
  by_cases small : i<7
  · have indexBound : twiddleIndex i j<256 := by
      have hm : m i≤128 := by interval_cases i <;> decide
      unfold twiddleIndex
      omega
    simp only [show i+1<8 by omega,ite_true]
    exact ⟨even_square _ (by omega) indexBound,odd_square _ bounds.1 indexBound⟩
  · have equal : i=7 := by omega
    subst i
    have lo : 256≤twiddleIndex 7 j := by change 256≤256+j; omega
    simp only [show ¬7+1<8 by decide,ite_false]
    exact ⟨even_cube _ lo bounds.2,odd_cube _ lo bounds.2⟩

theorem leaf_power (j k : Nat) (hj : j<512) (hk : k<3) :
    (KeygenNttRoots.point ⟨3*j+k,by omega⟩)^3=nodeRoot 8 j := by
  rw [KeygenNttRoots.triple_order j k hj hk,mul_pow]
  have cube : (KeygenNttRoots.unity^k)^3=1 := by
    rw [← pow_mul,Nat.mul_comm k 3,pow_mul,KeygenNttRoots.unity_cube,one_pow]
  rw [cube,mul_one]
  rfl

end FT1536.Source3.KeygenNttTwiddleTree
