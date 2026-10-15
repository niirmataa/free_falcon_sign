import Source3.FftTripleArithmetic147
import Source3.FftTripleEntry147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleLocal147
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)

def data (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64)
    (w2r w2i w4r w4i : BitVec 64) : FftTripleWords147.Inputs :=
  ⟨input (FftTripleLoadShape147.slot n hn u inside length 0),input (FftTripleLoadShape147.slot n hn u inside length 1),
   input (FftTripleLoadShape147.slot n hn u inside length 2),input (FftTripleLoadShape147.slot n hn u inside length 3),
   input (FftTripleLoadShape147.slot n hn u inside length 4),input (FftTripleLoadShape147.slot n hn u inside length 5),
   (FftCubicWord147.pair q).1,(FftCubicWord147.pair q).2,w2r,w2i,w4r,w4i⟩

theorem entry (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64)
    (w2r w2i w4r w4i : BitVec 64)
    (w2rCell : s.locals "fpr_W2R".toList=some (.uint64,some (.uint64 w2r)))
    (w2iCell : s.locals "fpr_W2I".toList=some (.uint64,some (.uint64 w2i)))
    (w4rCell : s.locals "fpr_W4R".toList=some (.uint64,some (.uint64 w4r)))
    (w4iCell : s.locals "fpr_W4I".toList=some (.uint64,some (.uint64 w4i))) :
    FftTripleArithmetic147.Entry (FftTripleInputs147.after s n hn u q inside length input)
      (data n hn u q inside length input w2r w2i w4r w4i) :=
  FftTripleEntry147.make (FftTripleInputs147.after s n hn u q inside length input)
    (input (FftTripleLoadShape147.slot n hn u inside length 0)) (input (FftTripleLoadShape147.slot n hn u inside length 1)) (input (FftTripleLoadShape147.slot n hn u inside length 2)) (input (FftTripleLoadShape147.slot n hn u inside length 3)) (input (FftTripleLoadShape147.slot n hn u inside length 4)) (input (FftTripleLoadShape147.slot n hn u inside length 5)) (FftCubicWord147.pair q).1 (FftCubicWord147.pair q).2 w2r w2i w4r w4i
    (FftTripleInputs147.declared s n hn u q inside length input)
    (FftTripleInputs147.input_cell s n hn u q inside length input 0)
    (FftTripleInputs147.input_cell s n hn u q inside length input 1)
    (FftTripleInputs147.input_cell s n hn u q inside length input 2)
    (FftTripleInputs147.input_cell s n hn u q inside length input 3)
    (FftTripleInputs147.input_cell s n hn u q inside length input 4)
    (FftTripleInputs147.input_cell s n hn u q inside length input 5)
    (FftTripleInputs147.real_cell s n hn u q inside length input)
    (FftTripleInputs147.imag_cell s n hn u q inside length input)
    ((FftTripleInputs147.outside s n hn u q inside length input "fpr_W2R".toList (by decide +kernel)).trans w2rCell)
    ((FftTripleInputs147.outside s n hn u q inside length input "fpr_W2I".toList (by decide +kernel)).trans w2iCell)
    ((FftTripleInputs147.outside s n hn u q inside length input "fpr_W4R".toList (by decide +kernel)).trans w4rCell)
    ((FftTripleInputs147.outside s n hn u q inside length input "fpr_W4I".toList (by decide +kernel)).trans w4iCell)

def after (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64)
    (w2r w2i w4r w4i : BitVec 64) :=
  FftTripleArithmetic147.state10 (FftTripleInputs147.after s n hn u q inside length input)
    (data n hn u q inside length input w2r w2i w4r w4i)

def code := C99ProcedureParser.chain (FftTripleShape145.statements.take 22)

theorem shape : code=C99ProcedureParser.chain
    (FftTripleShape145.statements.take 12++(FftTripleShape145.statements.drop 12).take 10) := by rfl

theorem source (s : State) (base : ArrayPointer) (n hn u q : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64) (tableBound : q<2048)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn) (vCell : Cell s "v".toList (2*q))
    (tableBinding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic))
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap)
    (input : Fin n → BitVec 64) (represented : Represents s.heap base input)
    (w2r w2i w4r w4i : BitVec 64)
    (w2rCell : s.locals "fpr_W2R".toList=some (.uint64,some (.uint64 w2r)))
    (w2iCell : s.locals "fpr_W2I".toList=some (.uint64,some (.uint64 w2i)))
    (w4rCell : s.locals "fpr_W4R".toList=some (.uint64,some (.uint64 w4r)))
    (w4iCell : s.locals "fpr_W4I".toList=some (.uint64,some (.uint64 w4i))) :
    C99ProcedureReference.Exec KeygenSearchFft.program code s ⟨after s n hn u q inside length input w2r w2i w4r w4i,.normal⟩ := by
  rw [shape]
  exact C99Chain139.append _ _ _ s _ _
    (FftTripleInputs147.source s base n hn u q inside length wordBound tableBound capacity binding uCell hnCell vCell tableBinding pinned input represented)
    (FftTripleArithmetic147.source (FftTripleInputs147.after s n hn u q inside length input)
      (data n hn u q inside length input w2r w2i w4r w4i) (entry s n hn u q inside length input w2r w2i w4r w4i w2rCell w2iCell w4rCell w4iCell))

theorem frame (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64)
    (w2r w2i w4r w4i : BitVec 64) :
    C99ScopeFrame147.Frame FftTripleDeclare147.names s (after s n hn u q inside length input w2r w2i w4r w4i) := by
  have kept := FftTripleInputs147.metadata s n hn u q inside length input
  exact C99ScopeFrame147.trans _ s _ _
    ⟨FftTripleInputs147.outside s n hn u q inside length input,kept.2.1,kept.2.2.1,kept.2.2.2⟩
    (FftTripleArithmetic147.frame10 (FftTripleInputs147.after s n hn u q inside length input)
      (data n hn u q inside length input w2r w2i w4r w4i))

theorem heap (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64)
    (w2r w2i w4r w4i : BitVec 64) : (after s n hn u q inside length input w2r w2i w4r w4i).heap=s.heap :=
  (FftTripleArithmetic147.metadata (FftTripleInputs147.after s n hn u q inside length input)
    (data n hn u q inside length input w2r w2i w4r w4i)).1.trans (FftTripleInputs147.metadata s n hn u q inside length input).1

end FT1536.Source3.FftTripleLocal147
