import Source3.FpcSqrShape145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcSqrFrame145
open C99ArrayReference (State Name)
open FpcSqrShape145
open FftMulShape140 (aNames dNames)

theorem a_subset : ∀ name∈aNames, name∈temporaries := fun _ member => List.mem_append_left dNames member
theorem d_subset : ∀ name∈dNames, name∈temporaries := fun _ member => List.mem_append_right aNames member

theorem different (name temp : Name) (safe : name∉temporaries) (member : temp∈temporaries) : name≠temp := by
  intro same
  subst name
  exact safe member

theorem outside2 (s : State) (name : Name) (safe : name∉temporaries) : (s2 s).locals name=s.locals name :=
  (C99DeclareOutside140.source .uint64 dNames (s1 s).locals name (fun member => safe (d_subset name member))).trans
    (C99DeclareOutside140.source .uint64 aNames s.locals name (fun member => safe (a_subset name member)))

theorem outside3 (s : State) (x : BitVec 64) (name : Name) (safe : name∉temporaries) : (s3 s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside2 s name safe)
theorem outside4 (s : State) (x y : BitVec 64) (name : Name) (safe : name∉temporaries) : (s4 s x y).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside3 s x name safe)
theorem outside5 (s : State) (x y : BitVec 64) (name : Name) (safe : name∉temporaries) : (s5 s x y).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside4 s x y name safe)
theorem outside6 (s : State) (x y : BitVec 64) (name : Name) (safe : name∉temporaries) : (s6 s x y).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside5 s x y name safe)

theorem restore6 (s : State) (x y : BitVec 64) : C99ArrayReference.restoreScope s (s6 s x y) temporaries []=s := by
  rw [s6,FftRestoreState140.inside s (s5 s x y) temporaries "fpct_d_im".toList (imag x y) (by decide)]
  rw [s5,FftRestoreState140.inside s (s4 s x y) temporaries "fpct_d_re".toList (real x y) (by decide)]
  rw [s4,FftRestoreState140.inside s (s3 s x) temporaries "fpct_a_im".toList y (by decide)]
  rw [s3,FftRestoreState140.inside s (s2 s) temporaries "fpct_a_re".toList x (by decide)]
  rw [s2,FftRestoreState140.declarations s (s1 s) temporaries dNames .u64 d_subset]
  rw [s1,FftRestoreState140.declarations s s temporaries aNames .u64 a_subset,FftRestoreState140.self]

end FT1536.Source3.FpcSqrFrame145
