import MetricTransport
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace LeftRoot
open ZeroScalar
theorem signal_history_bound (signal history current B E : Int)
    (hs : -B≤signal ∧ signal≤B) (hh : -E≤history ∧ history≤E)
    (hc : current=signal+history) : -(B+E)≤current ∧ current≤B+E := by omega
theorem split_defect_bound (oldError newError scale delta : Int)
    (hs : 0≤scale) (ho : -oldError≤newError ∧ newError≤oldError)
    (hdelta : 0≤delta) : -(scale*oldError+delta)≤scale*newError ∧ scale*newError≤scale*oldError+delta := by
  have a:=Int.mul_le_mul_of_nonneg_left ho.1 hs
  have b:=Int.mul_le_mul_of_nonneg_left ho.2 hs
  rw [Int.mul_neg] at a
  omega
theorem left_numeric_center (mu : Word) (finite : ex mu<2047)
    (range : -937866518*D≤valueNum mu ∧ valueNum mu≤937866518*D) : NumericCenter mu := by
  have hd:=D_pos
  unfold NumericCenter
  refine ⟨finite,?_,?_⟩ <;> omega
theorem global_range_union (v D : Int) (hd : 0<D)
    (h : (-156276714*D≤v ∧ v≤156276714*D) ∨ (-937866518*D≤v ∧ v≤937866518*D)) :
    -937866518*D≤v ∧ v≤937866518*D := by rcases h with h|h <;> omega
theorem global_margins : (2147483283-937866518:Nat)=1209616765 ∧
    (2147483282-937866518:Nat)=1209616764 := by decide
theorem normal_return_zero_is_not_fault : OrderedReach.Outcome.normal 0≠OrderedReach.Outcome.fault := by
  exact OrderedReach.normal_zero_distinct_tag
theorem conditional_right_completion_is_not_termination {S : Type} (right : S → Option S)
    (entry returned : S) (h : right entry=some returned) : right entry≠none := by rw [h];intro hn;cases hn
end LeftRoot
