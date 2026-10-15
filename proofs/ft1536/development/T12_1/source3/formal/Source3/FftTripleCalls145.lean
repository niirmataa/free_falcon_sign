import Source3.FpcSqrClosed145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleCalls145
open C99ArrayReference (State)
open FftTripleShape145 (mulParameters mulPosition part)

theorem names (i : Fin 6) :
    (mulParameters i).ar∉FftMulShape140.temporaries ∧ (mulParameters i).ai∉FftMulShape140.temporaries ∧
    (mulParameters i).br∉FftMulShape140.temporaries ∧ (mulParameters i).bi∉FftMulShape140.temporaries ∧
    (mulParameters i).dr∉FftMulShape140.temporaries ∧ (mulParameters i).di∉FftMulShape140.temporaries ∧
    (mulParameters i).dr≠(mulParameters i).di := by
  fin_cases i <;> decide +kernel

/-- The six original MUL sites require only their ordinary typed caller cells. -/
theorem mul (i : Fin 6) (s : State) (x : FftMulStates140.Words)
    (ar : s.locals (mulParameters i).ar=some (.uint64,some (.uint64 x.ar)))
    (ai : s.locals (mulParameters i).ai=some (.uint64,some (.uint64 x.ai)))
    (br : s.locals (mulParameters i).br=some (.uint64,some (.uint64 x.br)))
    (bi : s.locals (mulParameters i).bi=some (.uint64,some (.uint64 x.bi)))
    (dr : ∃ old, s.locals (mulParameters i).dr=some (.uint64,old))
    (di : ∃ old, s.locals (mulParameters i).di=some (.uint64,old)) :
    C99ProcedureReference.Exec KeygenSearchFft.program (part (mulPosition i)) s
      ⟨FpcMulShape145.output s (mulParameters i) x,.normal⟩ := by
  obtain ⟨arSafe,aiSafe,brSafe,biSafe,drSafe,diSafe,distinct⟩ := names i
  exact FftTripleShape145.mul_source i s x ⟨ar,ai,br,bi,dr,di,arSafe,aiSafe,brSafe,biSafe,drSafe,diSafe,distinct⟩

theorem square (s : State) (x y : BitVec 64)
    (real : s.locals "xr".toList=some (.uint64,some (.uint64 x)))
    (imag : s.locals "xi".toList=some (.uint64,some (.uint64 y))) :
    C99ProcedureReference.Exec KeygenSearchFft.program (part 15) s
      ⟨FpcSqrShape145.output s "xr".toList "xi".toList x y,.normal⟩ :=
  FpcSqrClosed145.in_tripling s x y ⟨real,imag,by decide,by decide,by decide⟩

end FT1536.Source3.FftTripleCalls145
