import Source3.FftTripleCubic147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleInputs147
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)

def cubicCode := C99ProcedureParser.chain ((FftTripleShape145.statements.drop 10).take 2)
def code := C99ProcedureParser.chain (FftTripleShape145.statements.take 12)

def after (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) :=
  FftTripleCubic147.after s (FftTripleLoadExec147.words n hn u inside length input) q

theorem cubic_shape : cubicCode=C99ProcedureParser.chain [FftTripleShape145.part 10,FftTripleShape145.part 11] := by rfl

theorem cubic_source (s : State) (words : Fin 6 → BitVec 64) (q : Nat) (bound : q<2048)
    (vCell : Cell s "v".toList (2*q))
    (binding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic))
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap) :
    C99ProcedureReference.Exec KeygenSearchFft.program cubicCode (FftTripleLoadState147.state s words 6)
      ⟨FftTripleCubic147.after s words q,.normal⟩ := by
  rw [cubic_shape]
  exact .seqNormal _ _ _ _ _ (FftTripleCubic147.real_source s words q bound vCell binding pinned)
    (.seqNormal _ _ _ _ _ (FftTripleCubic147.imag_source s words q bound vCell binding pinned) (.base _ _ _ (.skip _)))

theorem shape : code=C99ProcedureParser.chain
    (FftTripleShape145.statements.take 10++(FftTripleShape145.statements.drop 10).take 2) := by rfl

/-- All original declarations and eight loads, with no source-read premise. -/
theorem source (s : State) (base : ArrayPointer) (n hn u q : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64) (tableBound : q<2048)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn) (vCell : Cell s "v".toList (2*q))
    (tableBinding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic))
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap)
    (input : Fin n → BitVec 64) (represented : Represents s.heap base input) :
    C99ProcedureReference.Exec KeygenSearchFft.program code s ⟨after s n hn u q inside length input,.normal⟩ := by
  rw [shape]
  exact C99Chain139.append _ _ _ s _ _
    (FftTripleLoadExec147.prefix_source s base n hn u inside length wordBound capacity binding uCell hnCell input represented)
    (cubic_source s _ q tableBound vCell tableBinding pinned)

theorem input_cell (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (input : Fin n → BitVec 64) (i : Fin 6) :
    (after s n hn u q inside length input).locals (FftTripleLoadShape147.name i)=
      some (.uint64,some (.uint64 (input (FftTripleLoadShape147.slot n hn u inside length i)))) :=
  FftTripleCubic147.input_cell s _ q i

theorem real_cell (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) :
    (after s n hn u q inside length input).locals "xr".toList=some (.uint64,some (.uint64 (FftCubicWord147.pair q).1)) :=
  FftTripleCubic147.real_cell s _ q

theorem imag_cell (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) :
    (after s n hn u q inside length input).locals "xi".toList=some (.uint64,some (.uint64 (FftCubicWord147.pair q).2)) :=
  FftTripleCubic147.imag_cell s _ q

theorem declared (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) :
    C99Declared147.Declared (after s n hn u q inside length input) FftTripleDeclare147.names := FftTripleCubic147.declared s _ q

theorem metadata (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) :
    (after s n hn u q inside length input).heap=s.heap ∧ (after s n hn u q inside length input).arrays=s.arrays ∧
    (after s n hn u q inside length input).globals=s.globals ∧ (after s n hn u q inside length input).tables=s.tables :=
  FftTripleCubic147.metadata s _ q

theorem outside (s : State) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64)
    (key : C99ArrayReference.Name) (absent : key∉FftTripleDeclare147.names) :
    (after s n hn u q inside length input).locals key=s.locals key := FftTripleCubic147.outside s _ q key absent

end FT1536.Source3.FftTripleInputs147
