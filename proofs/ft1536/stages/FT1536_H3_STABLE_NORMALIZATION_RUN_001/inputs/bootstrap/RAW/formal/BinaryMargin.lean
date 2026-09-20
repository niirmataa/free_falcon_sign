import Half
namespace Node2
theorem pair_identity (a b t s : Int) :
    (a+b)*(a+b)-((a-b)*(a-b)+(t-s)*(t-s))=4*a*b-(t-s)*(t-s) := by grind
theorem coarse_box_countermodel : (9*9-(34-(-34))*(34-(-34))/4:Int)= -1075 := by decide
theorem first_branch_margin : (4096-1:Int)>2048 := by decide
theorem second_branch_margin : (512-1:Int)>256 := by decide
theorem pair_layout (f : Nat) (hf : f<128) :
    2*f+1<256 ∧ 2*f+1+256<512 ∧ f+128<256 ∧ 256+f<384 := by omega
end Node2
