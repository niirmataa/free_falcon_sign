import RootModel
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
set_option exponentiation.threshold 4096
namespace InitialTarget
open ZeroScalar
def ni : Word := RootLDL.divC (ofC 1) (ofC 18433)
theorem one_word : (ofC 1).val=0x3ff0000000000000 := by decide
theorem q_word : (ofC 18433).val=0x40d2004000000000 := by decide
theorem ni_word : ni.val=0x3f0c7161fb1566d0 := by decide
theorem ni_fields : ex ni=1008 ∧ sg ni=false ∧ ni.val≠0 := by decide
theorem ni_value_scaled : valueNum ni=500372811634285*H3Range.p2 1011 := by decide
theorem reciprocal_error_numerator : (18433*500372811634285-9223372036854775808:Int).natAbs=403 := by decide
theorem reciprocal_interval : (500372811634285*32768:Nat)>9223372036854775808 ∧
    (500372811634285*16384:Nat)<9223372036854775808 := by decide
theorem canonical_int_ranges (c : Nat) (hc : c<18433) : c≤18432 ∧ c<65536 ∧ (c:Int)≤2147483647 := by omega
theorem canonical_of_exact (c : Nat) (hc : c<18433) : valueNum (ofC (c:Int))=(c:Int)*D := by
  exact OF_EXACT (c:Int) (by omega)
theorem hash_to_point_written_range (w : Nat) : w%18433<18433 := Nat.mod_lt _ (by decide)
theorem hash_to_point_uint16 (w : Nat) : w%18433<65536 := by have h:=hash_to_point_written_range w;omega
theorem rejection_limit : (65536-65536%18433:Nat)=55299 := by decide
end InitialTarget
