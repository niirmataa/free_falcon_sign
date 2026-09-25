import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.MeasureTheory.Group.Basic

open MeasureTheory

#check @MeasureTheory.integral_gaussian
#check @MeasureTheory.integral_prod
#check @MeasureTheory.lintegral_prod
#check @MeasureTheory.integrable_prod_iff
example (t : ℝ) : MeasurePreserving (fun x : ℝ => t + x) volume volume :=
  measurePreserving_add_right volume t
#check @MeasureTheory.MeasurePreserving.integral_comp
#check @MeasureTheory.MeasurePreserving.lintegral_comp
