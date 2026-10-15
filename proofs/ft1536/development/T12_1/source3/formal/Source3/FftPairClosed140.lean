import Source3.FftPairExec140
import Source3.FftRestoreState140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftPairClosed140
open C99ArrayReference (State Exec Program)
open C99MemoryReference (ArrayPointer Allocated)
open FftPairShape140 (Kind temporaries realIndex imagIndex)
open FftMulStates140 (Words)
open FftPairStates140

theorem locals_restored (kind : Kind) (before : State) (x : Words) :
    C99ArrayReference.restoreScope before (imagState kind before x) temporaries []=before := by
  rw [imagState,FftRestoreState140.inside before (realState kind before x) temporaries "fpct_im".toList (imag kind x) (by decide)]
  rw [realState,FftRestoreState140.inside before (declared before) temporaries "fpct_re".toList (real kind x) (by decide)]
  rw [declared,FftRestoreState140.declarations before before temporaries temporaries .u64 (fun _ h => h),FftRestoreState140.self]

theorem restored (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer) :
    C99ArrayReference.restoreScope before (finalWrite kind before x p q) temporaries []=output kind before x p q := by
  change {C99ArrayReference.restoreScope before (imagState kind before x) temporaries [] with
      heap := finalHeap kind before x p q}={before with heap := finalHeap kind before x p q}
  rw [locals_restored]

/-- Both source macros are proved once for arbitrary word operands and legal
    addresses. No disjointness is assumed: the two source writes stay ordered. -/
theorem source (program : Program) (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer)
    (entry : Entry before x)
    (realAddress : C99ArrayReference.Pointer before "a".toList (realIndex kind) p)
    (imagAddress : C99ArrayReference.Pointer before "a".toList (imagIndex kind) q)
    (realAllocated : Allocated before.heap p) (imagAllocated : Allocated before.heap q)
    (realWidth : p.elementBytes=8) (imagWidth : q.elementBytes=8)
    (realWritable : before.heap.writable p.block=true) (imagWritable : before.heap.writable q.block=true) :
    Exec program (FftPairShape140.code kind) before (output kind before x p q) := by
  rw [← restored kind before x p q]
  exact .scope _ _ _ _ _ (FftPairExec140.internal_source program kind before x p q entry realAddress imagAddress
    realAllocated imagAllocated realWidth imagWidth realWritable imagWritable)

theorem in_butterfly (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer)
    (entry : Entry before x)
    (realAddress : C99ArrayReference.Pointer before "a".toList (realIndex kind) p)
    (imagAddress : C99ArrayReference.Pointer before "a".toList (imagIndex kind) q)
    (realAllocated : Allocated before.heap p) (imagAllocated : Allocated before.heap q)
    (realWidth : p.elementBytes=8) (imagWidth : q.elementBytes=8)
    (realWritable : before.heap.writable p.block=true) (imagWritable : before.heap.writable q.block=true) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftPairShape140.sourcePart kind) before
      ⟨output kind before x p q,.normal⟩ := by
  rw [FftPairShape140.source_bound]
  exact .base _ _ _ (source FftLeafPrograms.program kind before x p q entry realAddress imagAddress
    realAllocated imagAllocated realWidth imagWidth realWritable imagWritable)

theorem locals_same (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer) :
    (output kind before x p q).locals=before.locals := rfl

theorem arrays_same (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer) :
    (output kind before x p q).arrays=before.arrays := rfl

theorem other_byte (kind : Kind) (before : State) (x : Words) (p q : ArrayPointer) (block offset : Nat)
    (outsideReal : block≠p.block ∨ offset<p.offset ∨ p.offset+8≤offset)
    (outsideImag : block≠q.block ∨ offset<q.offset ∨ q.offset+8≤offset) :
    (output kind before x p q).heap.bytes block offset=before.heap.bytes block offset := by
  have notReal : ¬(block=p.block ∧ p.offset≤offset ∧ offset<p.offset+8) := by omega
  have notImag : ¬(block=q.block ∧ q.offset≤offset ∧ offset<q.offset+8) := by omega
  simp only [output,finalHeap,firstHeap,C99WordStore140.write,dite_eq_right notReal,dite_eq_right notImag]

end FT1536.Source3.FftPairClosed140
