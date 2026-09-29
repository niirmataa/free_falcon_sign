import PackOf
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
set_option exponentiation.threshold 4096
namespace ZeroScalar
open H3Range (p2 Between)
-- Value units D=2^1074; error units below are exactly2^-20.
def Eunits : Int := p2 1054
theorem error_rational : 1048576*Eunits=D ∧ 0<Eunits ∧ 4*Eunits<D := by decide
theorem error_budget_numeric : 13*p2 1176+2*p2 178≤p2 1180 := by decide
theorem phase_scale_bound (e sh : Nat) (he : e≤1054) (hs : 7≤sh ∧ sh≤63) :
    p2 (e+122)≤p2 1176 ∧ p2 (e+131-sh)≤4*p2 (e+122) := by
  constructor
  · exact H3Range.p2_mono _ _ (by omega)
  · have h:=H3Range.p2_mono (e+131-sh) (2+(e+122)) (by omega)
    rw [p2_add] at h
    exact h

theorem error_budget_composition (e : Nat) (he : e≤1054) (decodeA decodeB align shrink pack : Int)
    (hdA : Between decodeA (p2 177)) (hdB : Between decodeB (p2 177))
    (ha : Between align (p2 (e+122))) (hn : Between shrink (4*p2 (e+122)))
    (hp : Between pack (8*p2 (e+122)+p2 178)) :
    Between (decodeA+decodeB+align+shrink+pack) (p2 1180) := by
  have h:=H3Range.p2_mono (e+122) 1176 (by omega)
  have hc : 2*p2 177=p2 178 := by decide
  have hb:=error_budget_numeric
  unfold Between at *
  omega

-- These are kernel consumers of the independently proved analytical
-- SOURCE_ADD_ERROR, not a claim that full fpr_add is kernelized here.
theorem MACHINE_RESIDUAL_366 (x : Word) (hx : NumericCenter x) (z v : Int) (hz : -365≤z ∧ z≤366)
    (source_subtraction_error : Between (v-(valueNum x-D*(floorC x+z))) Eunits) :
    Between v (366*D+Eunits) := by
  have h:=EXACT_RESIDUAL_366 x hx z hz
  unfold Between at *
  omega
theorem MACHINE_CENTER_INTERVAL (x : Word) (hx : NumericCenter x) (r : Int)
    (source_subtraction_error : Between (r-rhoNum x) Eunits) : -Eunits≤r ∧ r≤D+Eunits := by
  have h:=RHO_CLOSED x hx
  unfold Between at *
  omega

theorem ORDERED_ZERO_TERMINAL (r1 rx r0 pre0 sf0 z0 e2 e3 Ehalf Eadd : Int)
    (prior_right : Between r1 (366*D+Eunits))
    (half_error : Between (2*rx-r1) (2*Ehalf))
    (closed_rho : 0≤pre0-D*sf0 ∧ pre0-D*sf0≤D)
    (proposal : -365≤z0 ∧ z0≤366)
    (second_sub_error : Between e2 Eunits)
    (last_sub_error : Between e3 Eadd)
    (out : r0=pre0-D*(sf0+z0)+e2-rx+e3) :
    Between (2*r0) (1098*D+3*Eunits+2*Ehalf+2*Eadd) := by
  have hd:=D_pos
  have hlo:=Int.mul_le_mul_of_nonneg_left proposal.1 (show 0≤D by omega)
  have hhi:=Int.mul_le_mul_of_nonneg_left proposal.2 (show 0≤D by omega)
  unfold Between at *
  rw [Int.mul_add] at out
  omega

#check @error_budget_composition
#check @MACHINE_RESIDUAL_366
#check @ORDERED_ZERO_TERMINAL
#print axioms error_rational
#print axioms error_budget_numeric
#print axioms phase_scale_bound
#print axioms error_budget_composition
#print axioms MACHINE_RESIDUAL_366
#print axioms MACHINE_CENTER_INTERVAL
#print axioms ORDERED_ZERO_TERMINAL
end ZeroScalar
