-- FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001: exact-skeleton cancellation lemmas.
-- Frame: per-coordinate instantiation of the R-module residual identities; the
-- recomputed source products enter as opaque values p/q (equal-word frame,
-- JOINT/SOURCE_ORDER: identical operand bits give identical rounded product).
-- All lemmas are linear in the abstract quantities and closed by `omega`.
-- Boundary: the coefficient-frame merge maps (signed placements) and their
-- application to whole vectors are covered by checks/skeleton_cancellation.py
-- (exact rational instances); this module kernel-proves the per-slot algebra.

set_option maxRecDepth 16384

namespace Ft1536.IntRecovery

/-- Intercall target update and its recomputed-product subtraction cancel
exactly (binary node, z0 path). -/
theorem intercall_add_sub_cancel (t0 p : Int) : t0 + p - p = t0 := by
  omega

/-- Same cancellation with the subtraction applied first (z1/z2 products in the
cubic node z0 path: two subtractions of recomputed products). -/
theorem intercall_add_two_sub_cancel (t0 p q : Int) : (t0 + p + q) - p - q = t0 := by
  omega

/-- Terminal half-update rx cancels between mu0' update and the final sub. -/
theorem terminal_rx_cancel (t0 rx y0 : Int) : (t0 + rx - y0) - rx = t0 - y0 := by
  omega

/-- Binary node residual: with left merge output m0 and recomputed product
p = z1*l, the returned z0 equals t0 - m0 regardless of p. -/
theorem binary_node_residual (t0 m0 p z0m z0 : Int)
    (hmerge : z0m = t0 + p - m0) (hfin : z0 = z0m - p) : z0 = t0 - m0 := by
  omega

/-- Cubic node residual (child0 path): products p = z1*l10, q = z2*l20. -/
theorem cubic_node_residual (t0 m0 p q z0m z0 : Int)
    (hmerge : z0m = t0 + p + q - m0) (hfin : z0 = z0m - p - q) : z0 = t0 - m0 := by
  omega

/-- Cubic node residual (child1 path): product p = z2*l21. -/
theorem cubic_node_residual_c1 (t1 m1 p z1m z1 : Int)
    (hmerge : z1m = t1 + p - m1) (hfin : z1 = z1m - p) : z1 = t1 - m1 := by
  omega

/-- Root node residual (fft3 top): product p = z1*L. -/
theorem root_node_residual (t0 m0 p z0m z0 : Int)
    (hmerge : z0m = t0 + p - m0) (hfin : z0 = z0m - p) : z0 = t0 - m0 := by
  omega

/-- Composition along one path: a sequence of intercall updates and
recomputed-product cancellations leaves t - m unchanged. Induction step. -/
theorem compose_step (t m p : Int) : ((t + p - m) - p) = t - m := by
  omega

/-- Composition along one path (two cubic products). -/
theorem compose_step2 (t m p q : Int) : (((t + p + q) - m) - p - q) = t - m := by
  omega

end Ft1536.IntRecovery

#print axioms Ft1536.IntRecovery.binary_node_residual
#print axioms Ft1536.IntRecovery.cubic_node_residual
#print axioms Ft1536.IntRecovery.terminal_rx_cancel
#print axioms Ft1536.IntRecovery.compose_step2
