import RootModel
set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 4096
namespace Node3
def inverse3 : ZeroScalar.Word := RootLDL.divC (ZeroScalar.ofC 1) (ZeroScalar.ofC 3)
theorem inverse3_bits : inverse3.val=4599676419421066581 := by decide
theorem inverse3_units : 3*ZeroScalar.valueNum inverse3=ZeroScalar.D-H3Range.p2 1020 := by decide
theorem expanded_div_exponent (ex ey w : Int)
    (hx : 1≤ex ∧ ex≤1123) (hy : 1019≤ey ∧ ey≤1058) (hw : 0≤w ∧ w≤1) :
    ex-ey+1021+w+2≤1128 ∧ -37≤ex-ey+1021+w := by omega
theorem normalization_indices (j k : Nat) (hj : j<256) (hk : k<3) :
    3*j+k<768 ∧ 3*j+k+768<1536 ∧ j+256<512 ∧ 512+j<768 := by omega
end Node3
