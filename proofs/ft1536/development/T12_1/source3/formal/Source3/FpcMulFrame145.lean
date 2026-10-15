import Source3.FpcMulShape145
import Source3.C99DeclareOutside140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcMulFrame145
open C99ArrayReference (State Name)
open FftMulShape140 (temporaries aNames bNames dNames)
open FftMulStates140 (Words s1 s2 s3 s4 s5 s6 s7 s8 s9)

theorem different (name temp : Name) (safe : name∉temporaries) (member : temp∈temporaries) : name≠temp := by
  intro same
  subst name
  exact safe member

theorem outside3 (s : State) (name : Name) (safe : name∉temporaries) : (s3 s).locals name=s.locals name :=
  (C99DeclareOutside140.source .uint64 dNames (s2 s).locals name
    (fun member => safe (FftMulClosed140.d_subset name member))).trans
    ((C99DeclareOutside140.source .uint64 bNames (s1 s).locals name
      (fun member => safe (FftMulClosed140.b_subset name member))).trans
      (C99DeclareOutside140.source .uint64 aNames s.locals name
        (fun member => safe (FftMulClosed140.a_subset name member))))

theorem outside4 (s : State) (x : Words) (name : Name) (safe : name∉temporaries) : (s4 s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside3 s name safe)
theorem outside5 (s : State) (x : Words) (name : Name) (safe : name∉temporaries) : (s5 s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside4 s x name safe)
theorem outside6 (s : State) (x : Words) (name : Name) (safe : name∉temporaries) : (s6 s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside5 s x name safe)
theorem outside7 (s : State) (x : Words) (name : Name) (safe : name∉temporaries) : (s7 s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside6 s x name safe)
theorem outside8 (s : State) (x : Words) (name : Name) (safe : name∉temporaries) : (s8 s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside7 s x name safe)
theorem outside9 (s : State) (x : Words) (name : Name) (safe : name∉temporaries) : (s9 s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (outside8 s x name safe)

theorem restore9 (s : State) (x : Words) : C99ArrayReference.restoreScope s (s9 s x) temporaries []=s := by
  rw [s9,FftRestoreState140.inside s (s8 s x) temporaries "fpct_d_im".toList (FftMulStates140.imag x) (by decide)]
  rw [s8,FftRestoreState140.inside s (s7 s x) temporaries "fpct_d_re".toList (FftMulStates140.real x) (by decide)]
  rw [s7,FftRestoreState140.inside s (s6 s x) temporaries "fpct_b_im".toList x.bi (by decide)]
  rw [s6,FftRestoreState140.inside s (s5 s x) temporaries "fpct_b_re".toList x.br (by decide)]
  rw [s5,FftRestoreState140.inside s (s4 s x) temporaries "fpct_a_im".toList x.ai (by decide)]
  rw [s4,FftRestoreState140.inside s (s3 s) temporaries "fpct_a_re".toList x.ar (by decide)]
  rw [s3,FftRestoreState140.declarations s (s2 s) temporaries dNames .u64 FftMulClosed140.d_subset]
  rw [s2,FftRestoreState140.declarations s (s1 s) temporaries bNames .u64 FftMulClosed140.b_subset]
  rw [s1,FftRestoreState140.declarations s s temporaries aNames .u64 FftMulClosed140.a_subset,FftRestoreState140.self]

end FT1536.Source3.FpcMulFrame145
