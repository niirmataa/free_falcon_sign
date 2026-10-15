import Source3.FftPairStates140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftPairExec140
open C99ArrayReference (State Program Exec)
open C99MemoryReference (ArrayPointer Allocated)
open FftPairShape140 (Kind operation temporaries realIndex imagIndex)
open FftMulShape140 (varExpr)
open FftMulStates140 (Words)
open FftPairStates140

theorem real_source (program : Program) (kind : Kind) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "fpct_re".toList (operation kind (varExpr "a0r") (varExpr "a1r")))
      (declared before) (realState kind before x) := by
  apply FftLocalCells140.assign program (declared before) "fpct_re".toList _ none (real kind x)
  · simp [declared,C99DeclarationStatements.effect,temporaries,C99DeclarationCells.declareCells,
      C99ScalarReference.set,C99ValueBridge.type]
  · apply FftPairShape140.operation_source kind _ _ _ x.ar x.br
    · apply FftLocalCells140.read_var
      simpa [declared,C99DeclarationStatements.effect,temporaries,C99DeclarationCells.declareCells,
        C99ScalarReference.set] using entry.ar
    · apply FftLocalCells140.read_var
      simpa [declared,C99DeclarationStatements.effect,temporaries,C99DeclarationCells.declareCells,
        C99ScalarReference.set] using entry.br

theorem imag_source (program : Program) (kind : Kind) (before : State) (x : Words) (entry : Entry before x) :
    Exec program (.assign "fpct_im".toList (operation kind (varExpr "a0i") (varExpr "a1i")))
      (realState kind before x) (imagState kind before x) := by
  apply FftLocalCells140.assign program (realState kind before x) "fpct_im".toList _ none (imag kind x)
  · simp [realState,FftLocalCells140.put,declared,C99DeclarationStatements.effect,temporaries,
      C99DeclarationCells.declareCells,C99ScalarReference.set,C99ValueBridge.type]
  · apply FftPairShape140.operation_source kind _ _ _ x.ai x.bi
    · apply FftLocalCells140.read_var
      simpa [realState,FftLocalCells140.put,declared,C99DeclarationStatements.effect,temporaries,
        C99DeclarationCells.declareCells,C99ScalarReference.set] using entry.ai
    · apply FftLocalCells140.read_var
      simpa [realState,FftLocalCells140.put,declared,C99DeclarationStatements.effect,temporaries,
        C99DeclarationCells.declareCells,C99ScalarReference.set] using entry.bi

theorem first_write (program : Program) (kind : Kind) (before : State) (x : Words) (p : ArrayPointer)
    (address : C99ArrayReference.Pointer before "a".toList (realIndex kind) p)
    (allocated : Allocated before.heap p) (width : p.elementBytes=8)
    (writable : before.heap.writable p.block=true) :
    Exec program (.store64 "a".toList (realIndex kind) (varExpr "fpct_re"))
      (imagState kind before x) (firstWrite kind before x p) := by
  apply FftWordStoreStep140.source program (imagState kind before x) "a".toList _ _ p (real kind x)
    (real_address kind before x p address) _ allocated width writable
  apply FftLocalCells140.read_var
  exact (FftLocalCells140.outside (realState kind before x) "fpct_im".toList "fpct_re".toList
    (imag kind x) (by decide)).trans (FftLocalCells140.cell_at (declared before) "fpct_re".toList (real kind x))

theorem second_write (program : Program) (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer)
    (address : C99ArrayReference.Pointer before "a".toList (imagIndex kind) q)
    (allocated : Allocated before.heap q) (width : q.elementBytes=8)
    (writable : before.heap.writable q.block=true) :
    Exec program (.store64 "a".toList (imagIndex kind) (varExpr "fpct_im"))
      (firstWrite kind before x p) (finalWrite kind before x p q) := by
  apply FftWordStoreStep140.source program (firstWrite kind before x p) "a".toList _ _ q (imag kind x)
    (imag_address kind before x p q address) _ allocated width writable
  apply FftLocalCells140.read_var
  exact FftLocalCells140.cell_at (realState kind before x) "fpct_im".toList (imag kind x)

theorem internal_source (program : Program) (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer)
    (entry : Entry before x)
    (realAddress : C99ArrayReference.Pointer before "a".toList (realIndex kind) p)
    (imagAddress : C99ArrayReference.Pointer before "a".toList (imagIndex kind) q)
    (realAllocated : Allocated before.heap p) (imagAllocated : Allocated before.heap q)
    (realWidth : p.elementBytes=8) (imagWidth : q.elementBytes=8)
    (realWritable : before.heap.writable p.block=true) (imagWritable : before.heap.writable q.block=true) :
    Exec program (FpcSourceExpansion.sequence (FftPairShape140.operations kind)) before (finalWrite kind before x p q) :=
  .seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 temporaries before)
    (.seq _ _ _ _ _ (real_source program kind before x entry)
      (.seq _ _ _ _ _ (imag_source program kind before x entry)
        (.seq _ _ _ _ _ (first_write program kind before x p realAddress realAllocated realWidth realWritable)
          (.seq _ _ _ _ _ (second_write program kind before x p q imagAddress imagAllocated imagWidth imagWritable) (.skip _)))))

end FT1536.Source3.FftPairExec140
