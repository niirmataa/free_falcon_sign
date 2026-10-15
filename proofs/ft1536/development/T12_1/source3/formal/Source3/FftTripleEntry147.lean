import Source3.FftTripleArithmetic147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleEntry147

theorem make (s : C99ArrayReference.State) (aR aI bR bI cR cI qR qI w2R w2I w4R w4I : BitVec 64)
    (declared : C99Declared147.Declared s FftTripleDeclare147.names)
    (aRCell : s.locals "fAr".toList=some (.uint64,some (.uint64 aR)))
    (aICell : s.locals "fAi".toList=some (.uint64,some (.uint64 aI)))
    (bRCell : s.locals "fBr".toList=some (.uint64,some (.uint64 bR)))
    (bICell : s.locals "fBi".toList=some (.uint64,some (.uint64 bI)))
    (cRCell : s.locals "fCr".toList=some (.uint64,some (.uint64 cR)))
    (cICell : s.locals "fCi".toList=some (.uint64,some (.uint64 cI)))
    (qRCell : s.locals "xr".toList=some (.uint64,some (.uint64 qR)))
    (qICell : s.locals "xi".toList=some (.uint64,some (.uint64 qI)))
    (w2RCell : s.locals "fpr_W2R".toList=some (.uint64,some (.uint64 w2R)))
    (w2ICell : s.locals "fpr_W2I".toList=some (.uint64,some (.uint64 w2I)))
    (w4RCell : s.locals "fpr_W4R".toList=some (.uint64,some (.uint64 w4R)))
    (w4ICell : s.locals "fpr_W4I".toList=some (.uint64,some (.uint64 w4I))) :
    FftTripleArithmetic147.Entry s ⟨aR,aI,bR,bI,cR,cI,qR,qI,w2R,w2I,w4R,w4I⟩ :=
  ⟨declared,aRCell,aICell,bRCell,bICell,cRCell,cICell,qRCell,qICell,w2RCell,w2ICell,w4RCell,w4ICell⟩

end FT1536.Source3.FftTripleEntry147
