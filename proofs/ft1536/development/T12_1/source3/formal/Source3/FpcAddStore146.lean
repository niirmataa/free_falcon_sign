import Source3.FpcAddCompute146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcAddStore146
open C99ArrayReference (State Name Stmt Program Exec Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open FftPairShape140 (temporaries)
open FftMulStates140 (Words)
open FftPairStates140 (imagState firstWrite finalWrite)
open FftMulShape140 (varExpr)

structure Parameters where
  inputs : FpcAddCompute146.Inputs
  arrayName : Name
  realIndex : CLogic.Expr
  imagIndex : CLogic.Expr

def operations (p : Parameters) := FpcAddCompute146.operations p.inputs++[
  .store64 p.arrayName p.realIndex (varExpr "fpct_re"),.store64 p.arrayName p.imagIndex (varExpr "fpct_im")]
def code (p : Parameters) : Stmt := .scope temporaries [] (FpcSourceExpansion.sequence (operations p))
def output (s : State) (x : Words) (r q : ArrayPointer) := FftPairStates140.output .add s x r q

structure Entry (s : State) (p : Parameters) (x : Words) (r q : ArrayPointer) : Prop where
  inputs : FpcAddCompute146.Entry s p.inputs x
  realAddress : Pointer s p.arrayName p.realIndex r
  imagAddress : Pointer s p.arrayName p.imagIndex q
  realAllocated : Allocated s.heap r
  imagAllocated : Allocated s.heap q
  realWidth : r.elementBytes=8
  imagWidth : q.elementBytes=8
  realWritable : s.heap.writable r.block=true
  imagWritable : s.heap.writable q.block=true
  realNames : ∀ name∈C99ExpressionEnvironment.readNames (C99Frontend.expression p.realIndex), name∉temporaries
  imagNames : ∀ name∈C99ExpressionEnvironment.readNames (C99Frontend.expression p.imagIndex), name∉temporaries

theorem real_address (kind : FftPairShape140.Kind) (s : State) (p : Parameters) (x : Words) (r q : ArrayPointer) (entry : Entry s p x r q) :
    Pointer (imagState kind s x) p.arrayName p.realIndex r := by
  apply FftPointerTransport140.source s (imagState kind s x) _ _ r entry.realAddress rfl
  intro name member
  exact (FftPairStates140.other_local kind s x name (entry.realNames name member)).symm

theorem imag_address (kind : FftPairShape140.Kind) (s : State) (p : Parameters) (x : Words) (r q : ArrayPointer) (entry : Entry s p x r q) :
    Pointer (firstWrite kind s x r) p.arrayName p.imagIndex q := by
  apply FftPointerTransport140.source s (firstWrite kind s x r) _ _ q entry.imagAddress rfl
  intro name member
  exact (FftPairStates140.other_local kind s x name (entry.imagNames name member)).symm

theorem first_source (program : Program) (kind : FftPairShape140.Kind) (s : State) (p : Parameters) (x : Words) (r q : ArrayPointer) (entry : Entry s p x r q) :
    Exec program (.store64 p.arrayName p.realIndex (varExpr "fpct_re")) (imagState kind s x) (firstWrite kind s x r) := by
  apply FftWordStoreStep140.source program (imagState kind s x) p.arrayName p.realIndex _ r (FftPairStates140.real kind x)
    (real_address kind s p x r q entry) _ entry.realAllocated entry.realWidth entry.realWritable
  exact FftLocalCells140.read_var _ _ _ ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))

theorem second_source (program : Program) (kind : FftPairShape140.Kind) (s : State) (p : Parameters) (x : Words) (r q : ArrayPointer) (entry : Entry s p x r q) :
    Exec program (.store64 p.arrayName p.imagIndex (varExpr "fpct_im")) (firstWrite kind s x r) (finalWrite kind s x r q) := by
  apply FftWordStoreStep140.source program (firstWrite kind s x r) p.arrayName p.imagIndex _ q (FftPairStates140.imag kind x)
    (imag_address kind s p x r q entry) _ entry.imagAllocated entry.imagWidth entry.imagWritable
  exact FftLocalCells140.read_var _ _ _ (FftLocalCells140.cell_at
    (FftPairStates140.realState kind s x) "fpct_im".toList (FftPairStates140.imag kind x))

theorem internal_source (program : Program) (s : State) (p : Parameters) (x : Words) (r q : ArrayPointer) (entry : Entry s p x r q) :
    Exec program (FpcSourceExpansion.sequence (operations p)) s (finalWrite .add s x r q) :=
  C99ArrayChain146.append program (FpcAddCompute146.operations p.inputs) _ s (imagState .add s x) _
    (FpcAddCompute146.source program s p.inputs x entry.inputs)
    (.seq _ _ _ _ _ (first_source program .add s p x r q entry)
      (.seq _ _ _ _ _ (second_source program .add s p x r q entry) (.skip _)))

/-- Source-ordered writes; no disjointness premise is imposed on the two addresses. -/
theorem source (program : Program) (s : State) (p : Parameters) (x : Words) (r q : ArrayPointer) (entry : Entry s p x r q) :
    Exec program (code p) s (output s x r q) := by
  change Exec program (code p) s (FftPairStates140.output .add s x r q)
  rw [← FftPairClosed140.restored .add s x r q]
  exact .scope _ _ _ _ _ (internal_source program s p x r q entry)

theorem locals_same (s : State) (x : Words) (r q : ArrayPointer) : (output s x r q).locals=s.locals := rfl
theorem arrays_same (s : State) (x : Words) (r q : ArrayPointer) : (output s x r q).arrays=s.arrays := rfl

theorem other_byte (s : State) (x : Words) (r q : ArrayPointer) (block offset : Nat)
    (outsideReal : block ≠ r.block ∨ offset < r.offset ∨ r.offset + 8 ≤ offset)
    (outsideImag : block ≠ q.block ∨ offset < q.offset ∨ q.offset + 8 ≤ offset) :
    (output s x r q).heap.bytes block offset=s.heap.bytes block offset :=
  FftPairClosed140.other_byte .add s x r q block offset outsideReal outsideImag

end FT1536.Source3.FpcAddStore146
