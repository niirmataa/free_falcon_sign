import Run2.NormalizerComparison
import Run2.T5ScalarMass
import Run2.ActualNTRUFiber
import Run2.KeygenLeafGate
import Run2.StableLeafSchedule

namespace FT1536.Run2.T5Diagnostic

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

#print axioms FT1536.Run2.NormalizerComparison.finiteFlat_from_box_normalizers
#print axioms FT1536.Run2.NormalizerComparison.actual_rejection_from_box_normalizers
#print axioms FT1536.Run2.RejectionNumericMargin.actual_rejection_from_tilted_normalizers
#print axioms FT1536.Run2.GaussianFiberTilt.rejection_chernoff
#print axioms FT1536.Run2.GuaranteedDigits.three_significant_digits
#print axioms FT1536.Run2.ActualNTRUFiber.gaussian_fiber_in_basis
#print axioms FT1536.Run2.T5ThetaNumeric.centered_product_theta
#print axioms FT1536.Run2.TriangularGaussian.triangular_mass_bounds
#print axioms FT1536.Run2.KeygenLeafGate.successful_scan_all_leaf_values

end FT1536.Run2.T5Diagnostic
