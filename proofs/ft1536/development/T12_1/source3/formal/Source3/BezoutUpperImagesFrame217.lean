import Source3.BezoutUpperCombine217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Abstract upper/lower zero image composition at the post-mlen state. -/
namespace FT1536.Source3.BezoutUpperImagesFrame217
open C99ArrayReference (State)
open DeepestBezoutEntry217 (Fp)
open ZintNormWalkFlat208 (Data)

theorem source (s : State) (nx ny : Nat) (h : BezoutUpperZero217.Input s nx ny)
    (lowU : Data (BezoutUpperSequence217.after s nx ny) BezoutInitZero217.firstPtr (ny-1) (fun _ => 0))
    (lowV : Data (BezoutUpperSequence217.after s nx ny) Fp nx (fun _ => 0)) :
    Data (BezoutUpperSequence217.after s nx ny) BezoutInitZero217.firstPtr 334 (fun _ => 0) ∧
    Data (BezoutUpperSequence217.after s nx ny) Fp 335 (fun _ => 0) := by
  have upperU := BezoutUpperZeroImages217.u_high s nx ny h
  have upperV := BezoutUpperZeroImages217.v_high s nx ny h
  exact ⟨BezoutUpperCombine217.u_tail _ ny h.nyPositive h.nyBound lowU upperU,
    BezoutUpperCombine217.v_all _ nx h.nxBound lowV upperV⟩

end FT1536.Source3.BezoutUpperImagesFrame217
