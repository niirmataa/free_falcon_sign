import Source3.FftTripleWords147
import Source3.FftTripleArithmeticCells147
import Source3.FftTripleInputs147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleArithmetic147
open C99ArrayReference (State)
open FftTripleWords147
open FftTripleDeclare147 (names)

structure Entry (s : State) (x : Inputs) : Prop where
  declared : C99Declared147.Declared s names
  aR : s.locals "fAr".toList=some (.uint64,some (.uint64 x.aR))
  aI : s.locals "fAi".toList=some (.uint64,some (.uint64 x.aI))
  bR : s.locals "fBr".toList=some (.uint64,some (.uint64 x.bR))
  bI : s.locals "fBi".toList=some (.uint64,some (.uint64 x.bI))
  cR : s.locals "fCr".toList=some (.uint64,some (.uint64 x.cR))
  cI : s.locals "fCi".toList=some (.uint64,some (.uint64 x.cI))
  qR : s.locals "xr".toList=some (.uint64,some (.uint64 x.qR))
  qI : s.locals "xi".toList=some (.uint64,some (.uint64 x.qI))
  w2R : s.locals "fpr_W2R".toList=some (.uint64,some (.uint64 x.w2R))
  w2I : s.locals "fpr_W2I".toList=some (.uint64,some (.uint64 x.w2I))
  w4R : s.locals "fpr_W4R".toList=some (.uint64,some (.uint64 x.w4R))
  w4I : s.locals "fpr_W4I".toList=some (.uint64,some (.uint64 x.w4I))

def state1 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two s "fB0r".toList "fB0i".toList (real0 x) (imag0 x)

theorem declared1 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state1 s x) names :=
  FftTripleArithmeticCells147.declared s names "fB0r".toList "fB0i".toList (real0 x) (imag0 x) entry.declared

theorem heap1 (s : State) (x : Inputs) : (state1 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap s "fB0r".toList "fB0i".toList (real0 x) (imag0 x))

theorem frame1 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state1 s x) :=
  C99ScopeFrame147.trans names s s (state1 s x) (C99ScopeFrame147.refl names s)
    (FftTripleArithmeticCells147.frame s names "fB0r".toList "fB0i".toList (real0 x) (imag0 x) (by decide +kernel) (by decide +kernel))

theorem source1 (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 12) s ⟨(state1 s x),.normal⟩ :=
  FftTripleCalls145.mul 0 s (operands0 x)
    (entry.bR)
    (entry.bI)
    (entry.qR)
    (entry.qI)
    (entry.declared "fB0r".toList (by decide +kernel)) (entry.declared "fB0i".toList (by decide +kernel))

def state2 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x)

theorem declared2 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state2 s x) names :=
  FftTripleArithmeticCells147.declared (state1 s x) names "fB1r".toList "fB1i".toList (real1 x) (imag1 x) (declared1 s x entry)

theorem heap2 (s : State) (x : Inputs) : (state2 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x)).trans (heap1 s x)

theorem frame2 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state2 s x) :=
  C99ScopeFrame147.trans names s (state1 s x) (state2 s x) (frame1 s x)
    (FftTripleArithmeticCells147.frame (state1 s x) names "fB1r".toList "fB1i".toList (real1 x) (imag1 x) (by decide +kernel) (by decide +kernel))

theorem source2 (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 13) (state1 s x) ⟨(state2 s x),.normal⟩ :=
  FftTripleCalls145.mul 1 (state1 s x) (operands1 x)
    (FftTripleArithmeticCells147.real_cell s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) (by decide))
    (FftTripleArithmeticCells147.imag_cell s "fB0r".toList "fB0i".toList (real0 x) (imag0 x))
    ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W2R".toList (by decide) (by decide)).trans (entry.w2R))
    ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W2I".toList (by decide) (by decide)).trans (entry.w2I))
    (declared1 s x entry "fB1r".toList (by decide +kernel)) (declared1 s x entry "fB1i".toList (by decide +kernel))

def state3 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x)

theorem declared3 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state3 s x) names :=
  FftTripleArithmeticCells147.declared (state2 s x) names "fB2r".toList "fB2i".toList (real2 x) (imag2 x) (declared2 s x entry)

theorem heap3 (s : State) (x : Inputs) : (state3 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x)).trans (heap2 s x)

theorem frame3 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state3 s x) :=
  C99ScopeFrame147.trans names s (state2 s x) (state3 s x) (frame2 s x)
    (FftTripleArithmeticCells147.frame (state2 s x) names "fB2r".toList "fB2i".toList (real2 x) (imag2 x) (by decide +kernel) (by decide +kernel))

theorem source3 (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 14) (state2 s x) ⟨(state3 s x),.normal⟩ :=
  FftTripleCalls145.mul 2 (state2 s x) (operands2 x)
    ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fB0r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) (by decide)))
    ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fB0i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell s "fB0r".toList "fB0i".toList (real0 x) (imag0 x)))
    ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fpr_W4R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W4R".toList (by decide) (by decide)).trans (entry.w4R)))
    ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fpr_W4I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W4I".toList (by decide) (by decide)).trans (entry.w4I)))
    (declared2 s x entry "fB2r".toList (by decide +kernel)) (declared2 s x entry "fB2i".toList (by decide +kernel))

def state4 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x)

theorem declared4 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state4 s x) names :=
  FftTripleArithmeticCells147.declared (state3 s x) names "xr".toList "xi".toList (real3 x) (imag3 x) (declared3 s x entry)

theorem heap4 (s : State) (x : Inputs) : (state4 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x)).trans (heap3 s x)

theorem frame4 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state4 s x) :=
  C99ScopeFrame147.trans names s (state3 s x) (state4 s x) (frame3 s x)
    (FftTripleArithmeticCells147.frame (state3 s x) names "xr".toList "xi".toList (real3 x) (imag3 x) (by decide +kernel) (by decide +kernel))

theorem source4 (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 15) (state3 s x) ⟨(state4 s x),.normal⟩ :=
  FftTripleCalls145.square (state3 s x) x.qR x.qI
    ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "xr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "xr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "xr".toList (by decide) (by decide)).trans (entry.qR))))
    ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "xi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "xi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "xi".toList (by decide) (by decide)).trans (entry.qI))))

def state5 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x)

theorem declared5 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state5 s x) names :=
  FftTripleArithmeticCells147.declared (state4 s x) names "fC0r".toList "fC0i".toList (real4 x) (imag4 x) (declared4 s x entry)

theorem heap5 (s : State) (x : Inputs) : (state5 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x)).trans (heap4 s x)

theorem frame5 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state5 s x) :=
  C99ScopeFrame147.trans names s (state4 s x) (state5 s x) (frame4 s x)
    (FftTripleArithmeticCells147.frame (state4 s x) names "fC0r".toList "fC0i".toList (real4 x) (imag4 x) (by decide +kernel) (by decide +kernel))

theorem source5 (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 16) (state4 s x) ⟨(state5 s x),.normal⟩ :=
  FftTripleCalls145.mul 3 (state4 s x) (operands4 x)
    ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fCr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fCr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fCr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fCr".toList (by decide) (by decide)).trans (entry.cR)))))
    ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fCi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fCi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fCi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fCi".toList (by decide) (by decide)).trans (entry.cI)))))
    (FftTripleArithmeticCells147.real_cell (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) (by decide))
    (FftTripleArithmeticCells147.imag_cell (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x))
    (declared4 s x entry "fC0r".toList (by decide +kernel)) (declared4 s x entry "fC0i".toList (by decide +kernel))

def state6 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x)

theorem declared6 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state6 s x) names :=
  FftTripleArithmeticCells147.declared (state5 s x) names "fC1r".toList "fC1i".toList (real5 x) (imag5 x) (declared5 s x entry)

theorem heap6 (s : State) (x : Inputs) : (state6 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x)).trans (heap5 s x)

theorem frame6 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state6 s x) :=
  C99ScopeFrame147.trans names s (state5 s x) (state6 s x) (frame5 s x)
    (FftTripleArithmeticCells147.frame (state5 s x) names "fC1r".toList "fC1i".toList (real5 x) (imag5 x) (by decide +kernel) (by decide +kernel))

theorem source6 (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 17) (state5 s x) ⟨(state6 s x),.normal⟩ :=
  FftTripleCalls145.mul 4 (state5 s x) (operands5 x)
    (FftTripleArithmeticCells147.real_cell (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) (by decide))
    (FftTripleArithmeticCells147.imag_cell (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x))
    ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fpr_W2R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fpr_W2R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fpr_W2R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fpr_W2R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W2R".toList (by decide) (by decide)).trans (entry.w2R))))))
    ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fpr_W2I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fpr_W2I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fpr_W2I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fpr_W2I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W2I".toList (by decide) (by decide)).trans (entry.w2I))))))
    (declared5 s x entry "fC1r".toList (by decide +kernel)) (declared5 s x entry "fC1i".toList (by decide +kernel))

def state7 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x)

theorem declared7 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state7 s x) names :=
  FftTripleArithmeticCells147.declared (state6 s x) names "fC2r".toList "fC2i".toList (real6 x) (imag6 x) (declared6 s x entry)

theorem heap7 (s : State) (x : Inputs) : (state7 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x)).trans (heap6 s x)

theorem frame7 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state7 s x) :=
  C99ScopeFrame147.trans names s (state6 s x) (state7 s x) (frame6 s x)
    (FftTripleArithmeticCells147.frame (state6 s x) names "fC2r".toList "fC2i".toList (real6 x) (imag6 x) (by decide +kernel) (by decide +kernel))

theorem source7 (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 18) (state6 s x) ⟨(state7 s x),.normal⟩ :=
  FftTripleCalls145.mul 5 (state6 s x) (operands6 x)
    ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fC0r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) (by decide)))
    ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fC0i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x)))
    ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fpr_W4R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fpr_W4R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fpr_W4R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fpr_W4R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fpr_W4R".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W4R".toList (by decide) (by decide)).trans (entry.w4R)))))))
    ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fpr_W4I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fpr_W4I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fpr_W4I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fpr_W4I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fpr_W4I".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fpr_W4I".toList (by decide) (by decide)).trans (entry.w4I)))))))
    (declared6 s x entry "fC2r".toList (by decide +kernel)) (declared6 s x entry "fC2i".toList (by decide +kernel))

def state8 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x)

theorem declared8 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state8 s x) names :=
  FftTripleArithmeticCells147.declared (state7 s x) names "fB0r".toList "fB0i".toList (real7 x) (imag7 x) (declared7 s x entry)

theorem heap8 (s : State) (x : Inputs) : (state8 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x)).trans (heap7 s x)

theorem frame8 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state8 s x) :=
  C99ScopeFrame147.trans names s (state7 s x) (state8 s x) (frame7 s x)
    (FftTripleArithmeticCells147.frame (state7 s x) names "fB0r".toList "fB0i".toList (real7 x) (imag7 x) (by decide +kernel) (by decide +kernel))

theorem source8 (s : State) (x : Inputs) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 19) (state7 s x) ⟨(state8 s x),.normal⟩ :=
  FftTripleAddCalls146.local_source 0 (state7 s x) (operands7 x)
    ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fB0r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fB0r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fB0r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fB0r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fB0r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fB0r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) (by decide))))))))
    ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fB0i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fB0i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fB0i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fB0i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fB0i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fB0i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell s "fB0r".toList "fB0i".toList (real0 x) (imag0 x))))))))
    ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fC0r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fC0r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) (by decide))))
    ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fC0i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fC0i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x))))

def state9 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x)

theorem declared9 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state9 s x) names :=
  FftTripleArithmeticCells147.declared (state8 s x) names "fB1r".toList "fB1i".toList (real8 x) (imag8 x) (declared8 s x entry)

theorem heap9 (s : State) (x : Inputs) : (state9 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x)).trans (heap8 s x)

theorem frame9 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state9 s x) :=
  C99ScopeFrame147.trans names s (state8 s x) (state9 s x) (frame8 s x)
    (FftTripleArithmeticCells147.frame (state8 s x) names "fB1r".toList "fB1i".toList (real8 x) (imag8 x) (by decide +kernel) (by decide +kernel))

theorem source9 (s : State) (x : Inputs) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 20) (state8 s x) ⟨(state9 s x),.normal⟩ :=
  FftTripleAddCalls146.local_source 1 (state8 s x) (operands8 x)
    ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fB1r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fB1r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fB1r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fB1r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fB1r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fB1r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) (by decide))))))))
    ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fB1i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fB1i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fB1i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fB1i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fB1i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fB1i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x))))))))
    ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fC2r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) (by decide)))
    ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fC2i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x)))

def state10 (s : State) (x : Inputs) := FftTripleArithmeticCells147.two (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x)

theorem declared10 (s : State) (x : Inputs) (entry : Entry s x) : C99Declared147.Declared (state10 s x) names :=
  FftTripleArithmeticCells147.declared (state9 s x) names "fB2r".toList "fB2i".toList (real9 x) (imag9 x) (declared9 s x entry)

theorem heap10 (s : State) (x : Inputs) : (state10 s x).heap=s.heap :=
  (FftTripleArithmeticCells147.heap (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x)).trans (heap9 s x)

theorem frame10 (s : State) (x : Inputs) : C99ScopeFrame147.Frame names s (state10 s x) :=
  C99ScopeFrame147.trans names s (state9 s x) (state10 s x) (frame9 s x)
    (FftTripleArithmeticCells147.frame (state9 s x) names "fB2r".toList "fB2i".toList (real9 x) (imag9 x) (by decide +kernel) (by decide +kernel))

theorem source10 (s : State) (x : Inputs) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part 21) (state9 s x) ⟨(state10 s x),.normal⟩ :=
  FftTripleAddCalls146.local_source 2 (state9 s x) (operands9 x)
    ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fB2r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fB2r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fB2r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fB2r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fB2r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fB2r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) (by decide))))))))
    ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fB2i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fB2i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fB2i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fB2i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fB2i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fB2i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x))))))))
    ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fC1r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fC1r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fC1r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) (by decide)))))
    ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fC1i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fC1i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fC1i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x)))))

def code := C99ProcedureParser.chain ((FftTripleShape145.statements.drop 12).take 10)
theorem shape : code=C99ProcedureParser.chain [FftTripleShape145.part 12,FftTripleShape145.part 13,FftTripleShape145.part 14,FftTripleShape145.part 15,FftTripleShape145.part 16,FftTripleShape145.part 17,FftTripleShape145.part 18,FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21] := by rfl

theorem source (s : State) (x : Inputs) (entry : Entry s x) :
    C99ProcedureReference.Exec KeygenSearchFft.program code s ⟨state10 s x,.normal⟩ := by
  rw [shape]
  exact .seqNormal (FftTripleShape145.part 12) (C99ProcedureParser.chain [FftTripleShape145.part 13,FftTripleShape145.part 14,FftTripleShape145.part 15,FftTripleShape145.part 16,FftTripleShape145.part 17,FftTripleShape145.part 18,FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21]) s (state1 s x) ⟨(state10 s x),.normal⟩ (source1 s x entry) (.seqNormal (FftTripleShape145.part 13) (C99ProcedureParser.chain [FftTripleShape145.part 14,FftTripleShape145.part 15,FftTripleShape145.part 16,FftTripleShape145.part 17,FftTripleShape145.part 18,FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21]) (state1 s x) (state2 s x) ⟨(state10 s x),.normal⟩ (source2 s x entry) (.seqNormal (FftTripleShape145.part 14) (C99ProcedureParser.chain [FftTripleShape145.part 15,FftTripleShape145.part 16,FftTripleShape145.part 17,FftTripleShape145.part 18,FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21]) (state2 s x) (state3 s x) ⟨(state10 s x),.normal⟩ (source3 s x entry) (.seqNormal (FftTripleShape145.part 15) (C99ProcedureParser.chain [FftTripleShape145.part 16,FftTripleShape145.part 17,FftTripleShape145.part 18,FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21]) (state3 s x) (state4 s x) ⟨(state10 s x),.normal⟩ (source4 s x entry) (.seqNormal (FftTripleShape145.part 16) (C99ProcedureParser.chain [FftTripleShape145.part 17,FftTripleShape145.part 18,FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21]) (state4 s x) (state5 s x) ⟨(state10 s x),.normal⟩ (source5 s x entry) (.seqNormal (FftTripleShape145.part 17) (C99ProcedureParser.chain [FftTripleShape145.part 18,FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21]) (state5 s x) (state6 s x) ⟨(state10 s x),.normal⟩ (source6 s x entry) (.seqNormal (FftTripleShape145.part 18) (C99ProcedureParser.chain [FftTripleShape145.part 19,FftTripleShape145.part 20,FftTripleShape145.part 21]) (state6 s x) (state7 s x) ⟨(state10 s x),.normal⟩ (source7 s x entry) (.seqNormal (FftTripleShape145.part 19) (C99ProcedureParser.chain [FftTripleShape145.part 20,FftTripleShape145.part 21]) (state7 s x) (state8 s x) ⟨(state10 s x),.normal⟩ (source8 s x) (.seqNormal (FftTripleShape145.part 20) (C99ProcedureParser.chain [FftTripleShape145.part 21]) (state8 s x) (state9 s x) ⟨(state10 s x),.normal⟩ (source9 s x) (.seqNormal (FftTripleShape145.part 21) (C99ProcedureParser.chain []) (state9 s x) (state10 s x) ⟨(state10 s x),.normal⟩ (source10 s x) (C99ProcedureReference.Exec.base .skip (state10 s x) (state10 s x) (.skip (state10 s x))))))))))))

theorem metadata (s : State) (x : Inputs) : (state10 s x).heap=s.heap ∧ (state10 s x).arrays=s.arrays ∧
    (state10 s x).globals=s.globals ∧ (state10 s x).tables=s.tables := ⟨heap10 s x,(frame10 s x).arrays,(frame10 s x).globals,(frame10 s x).tables⟩

theorem final_aR (s : State) (x : Inputs) (entry : Entry s x) :
    (state10 s x).locals "fAr".toList=some (.uint64,some (.uint64 x.aR)) :=
  (FftTripleArithmeticCells147.outside (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fAr".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fAr".toList (by decide) (by decide)).trans (entry.aR))))))))))

theorem final_aI (s : State) (x : Inputs) (entry : Entry s x) :
    (state10 s x).locals "fAi".toList=some (.uint64,some (.uint64 x.aI)) :=
  (FftTripleArithmeticCells147.outside (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state6 s x) "fC2r".toList "fC2i".toList (real6 x) (imag6 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state5 s x) "fC1r".toList "fC1i".toList (real5 x) (imag5 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state4 s x) "fC0r".toList "fC0i".toList (real4 x) (imag4 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state3 s x) "xr".toList "xi".toList (real3 x) (imag3 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state2 s x) "fB2r".toList "fB2i".toList (real2 x) (imag2 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state1 s x) "fB1r".toList "fB1i".toList (real1 x) (imag1 x) "fAi".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside s "fB0r".toList "fB0i".toList (real0 x) (imag0 x) "fAi".toList (by decide) (by decide)).trans (entry.aI))))))))))

theorem final_b0R (s : State) (x : Inputs) :
    (state10 s x).locals "fB0r".toList=some (.uint64,some (.uint64 (real7 x))) :=
  (FftTripleArithmeticCells147.outside (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x) "fB0r".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fB0r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x) (by decide)))

theorem final_b0I (s : State) (x : Inputs) :
    (state10 s x).locals "fB0i".toList=some (.uint64,some (.uint64 (imag7 x))) :=
  (FftTripleArithmeticCells147.outside (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x) "fB0i".toList (by decide) (by decide)).trans ((FftTripleArithmeticCells147.outside (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) "fB0i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state7 s x) "fB0r".toList "fB0i".toList (real7 x) (imag7 x)))

theorem final_b1R (s : State) (x : Inputs) :
    (state10 s x).locals "fB1r".toList=some (.uint64,some (.uint64 (real8 x))) :=
  (FftTripleArithmeticCells147.outside (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x) "fB1r".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.real_cell (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x) (by decide))

theorem final_b1I (s : State) (x : Inputs) :
    (state10 s x).locals "fB1i".toList=some (.uint64,some (.uint64 (imag8 x))) :=
  (FftTripleArithmeticCells147.outside (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x) "fB1i".toList (by decide) (by decide)).trans (FftTripleArithmeticCells147.imag_cell (state8 s x) "fB1r".toList "fB1i".toList (real8 x) (imag8 x))

theorem final_b2R (s : State) (x : Inputs) :
    (state10 s x).locals "fB2r".toList=some (.uint64,some (.uint64 (real9 x))) :=
  FftTripleArithmeticCells147.real_cell (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x) (by decide)

theorem final_b2I (s : State) (x : Inputs) :
    (state10 s x).locals "fB2i".toList=some (.uint64,some (.uint64 (imag9 x))) :=
  FftTripleArithmeticCells147.imag_cell (state9 s x) "fB2r".toList "fB2i".toList (real9 x) (imag9 x)

end FT1536.Source3.FftTripleArithmetic147
