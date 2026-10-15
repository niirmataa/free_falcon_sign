import Source3.FftFirstValues152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirstClosed152

theorem real (n hn u : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (input : Fin n → BitVec 64) (range : u<hn) :
    FftFirstInduction149.values n hn length wr wi hn 0 input ⟨u,by omega⟩=
      FftFirstBody149.real (input ⟨u,by omega⟩) (input ⟨u+hn,by omega⟩) wr := by
  rw [FftFirstValues152.pointwise,FftFirstValues152.real_owner n hn u length range]
  have inside : 0≤u ∧ u<0+hn := by omega
  rw [ite_eq_left inside,FftFirstValues152.effect n hn u length wr wi input range]
  have different : (⟨u,by omega⟩ : Fin n)≠⟨u+hn,by omega⟩ := by
    intro same
    have equal : u=u+hn := congrArg Fin.val same
    omega
  rw [ite_eq_right different,ite_eq_left rfl]

theorem imag (n hn u : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (input : Fin n → BitVec 64) (range : u<hn) :
    FftFirstInduction149.values n hn length wr wi hn 0 input ⟨u+hn,by omega⟩=
      FftFirstBody149.imag (input ⟨u+hn,by omega⟩) wi := by
  rw [FftFirstValues152.pointwise,FftFirstValues152.imag_owner n hn u length range]
  have inside : 0≤u ∧ u<0+hn := by omega
  rw [ite_eq_left inside,FftFirstValues152.effect n hn u length wr wi input range,ite_eq_left rfl]

def image (n hn : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (input : Fin n → BitVec 64) (i : Fin n) : BitVec 64 :=
  if first : i.val<hn then FftFirstBody149.real (input i) (input ⟨i.val+hn,by omega⟩) wr
  else if i.val<2*hn then FftFirstBody149.imag (input i) wi else input i

/-- Direct indexed image of the entire first pass, with no update recurrence. -/
theorem source (n hn : Nat) (length : 2*hn≤n) (wr wi : BitVec 64) (input : Fin n → BitVec 64) :
    FftFirstInduction149.values n hn length wr wi hn 0 input=image n hn length wr wi input := by
  funext i
  by_cases first : i.val<hn
  · rw [image,dite_eq_left first]
    exact real n hn i.val length wr wi input first
  · by_cases second : i.val<2*hn
    · have uBound : i.val-hn<hn := by omega
      have index : i.val-hn+hn=i.val := by omega
      have result := imag n hn (i.val-hn) length wr wi input uBound
      rw [image,dite_eq_right first,ite_eq_left second]
      simpa only [index] using result
    · rw [image,dite_eq_right first,ite_eq_right second,FftFirstValues152.pointwise]
      have outside : ¬(0≤FftFirstValues152.owner hn i ∧ FftFirstValues152.owner hn i<0+hn) := by
        simp only [FftFirstValues152.owner,ite_eq_right first]
        omega
      rw [ite_eq_right outside]

end FT1536.Source3.FftFirstClosed152
