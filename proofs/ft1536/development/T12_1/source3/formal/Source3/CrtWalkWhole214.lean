import Source3.CrtWalkFlat214

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkWhole214
open C99ArrayReference (State Name bindPointer Pointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open StepCopyBody190 (elem)
open CrtWalkIncrement214 (row point)
open CrtWalkFixed214 (Fixed)
open KeygenZintCall (Exec)
open ZintNormWalkFlat208 (Data)

def zero (s : State) := set64 s "v" 0
 def entry (s : State) (root : ArrayPointer) := bindPointer (zero s) "x".toList root

theorem locals (s : State) (root : ArrayPointer) (name : Name) (nv : name≠"v".toList) :
    (entry s root).locals name=s.locals name := SelectedStepAddPrime195.locals_keep s "v".toList .uint64 (.uint64 0) name nv

theorem arrays (s : State) (root : ArrayPointer) (name : Name) (nx : name≠"x".toList) :
    (entry s root).arrays name=s.arrays name := by
  simp only [entry,bindPointer,nx,ite_false]; rfl

theorem fixed (s : State) (root tmp : ArrayPointer) (n len stride : Nat) (T : Nat → BitVec 32) (p pi r2 c : BitVec 32)
    (h : Fixed s root tmp n len stride T p pi r2 c) : Fixed (entry s root) root tmp n len stride T p pi r2 c := by
  have l:=locals s root
  exact ⟨h.nBound,h.lenBound,h.strideBound,h.room,h.width,h.capacity,h.writable,
    (arrays s root _ (by decide)).trans h.tmpBinding,(l _ (by decide)).trans h.numCell,(l _ (by decide)).trans h.uCell,
    (l _ (by decide)).trans h.strideCell,(l _ (by decide)).trans h.pCell,(l _ (by decide)).trans h.iCell,
    (l _ (by decide)).trans h.rCell,(l _ (by decide)).trans h.sCell,h.tmpCapacity,h.tmpRead,h.apart⟩

theorem init_source (s : State) (root : ArrayPointer) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) (binding : s.arrays "xx".toList=some root) (cap : root.index ≤ root.count) :
    Exec CrtRoundShape205.walkInit s ⟨entry s root,.normal⟩ := by
  have assign : KeygenWordExec.Exec (.assign "v".toList (.scalar (.literal .i32 0))) s ⟨zero s,.normal⟩ :=
    .assign _ _ _ .uint64 old (.int32 0) declared (WordAtoms205.literal _ 0)
  have ptr : Pointer (zero s) "xx".toList C99ProcedureParser.zero root :=
    .add _ _ root root (.uint64 0) binding (.literal .uint64 0) (by decide) (.within root 0 (by omega))
  exact .seqNormal _ _ _ _ _ (.word _ _ _ assign)
    (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ _ ptr))))

theorem source (s : State) (root tmp : ArrayPointer) (n len stride : Nat) (W T : Nat → BitVec 32) (p pi r2 c : BitVec 32)
    (h : Fixed s root tmp n len stride T p pi r2 c) (data : Data s root (n*stride) W)
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old))
    (binding : s.arrays "xx".toList=some root) :
    ∃ out, Exec (.seq CrtRoundShape205.walkInit CrtRoundShape205.walk) s ⟨out,.normal⟩ ∧ Fixed out root tmp n len stride T p pi r2 c ∧
      Cell out "v".toList n ∧ out.arrays "x".toList=some (row root stride n) ∧ Data out root (n*stride) (CrtWalkFlat214.words len stride W T p pi r2 c) ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i j, i < n → j ≤ len → Word32Memory176.Separate (point root stride i j) q) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have vc : Cell (entry s root) "v".toList 0 := by change Cell (zero s) "v".toList 0; exact CrtState205.cell64 _ _ _
  have xb : (entry s root).arrays "x".toList=some root := rfl
  obtain ⟨out,run,finalFixed,finalV,finalX,image,ls,ars,keep⟩:=CrtWalkFlat214.source (entry s root) root tmp n len stride W T p pi r2 c
    (fixed s root tmp n len stride T p pi r2 c h) vc xb data
  refine ⟨out,.seqNormal _ _ _ _ _ (init_source s root old declared binding (by have cap:=h.capacity; omega)) run,
    finalFixed,finalV,finalX,image,?_,?_,keep⟩
  · intro name nv; exact (ls name nv).trans (locals s root name nv)
  · intro name nx; exact (ars name nx).trans (arrays s root name nx)

end FT1536.Source3.CrtWalkWhole214
