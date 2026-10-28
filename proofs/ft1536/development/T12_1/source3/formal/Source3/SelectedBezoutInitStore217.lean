import Source3.BezoutInitStoreCells217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Conditional selected path through copies, length assignments and u0[0]. -/
namespace FT1536.Source3.SelectedBezoutInitStore217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99MemoryReference (Allocated Load32)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b)
open DeepestBezoutEntry217 (Gp)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutInitCopies217 (finish)

def code : KeygenZintCall.Stmt := .seq SelectedBezoutInitCopies217.code BezoutInitStore217.code
noncomputable def after (rebuilt : State) (F G : Nat → BitVec 32) :=
  BezoutInitStore217.after (finish rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Cell (after rebuilt F G) "alen".toList (highest (X F G) 335) ∧
      Cell (after rebuilt F G) "blen".toList (highest (Y F G) 335) ∧
      Load32 (after rebuilt F G).heap Gp 1 ∧
      Data (after rebuilt F G) fd 335 (X F G) ∧ Data (after rebuilt F G) gd 335 (Y F G) ∧
      Data (after rebuilt F G) a (highest (X F G) 335) (X F G) ∧
      Data (after rebuilt F G) b (highest (Y F G) 335) (Y F G)) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,copies⟩:=SelectedBezoutInitCopies217.selected
  let s := state rebuilt F G
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  let fin := finish rebuilt F G
  have nxBound : nx≤335 := ExactLengthProgram217.highest_le _ _
  have nyBound : ny≤335 := ExactLengthProgram217.highest_le _ _
  have initExtent : 4*71680≤SelectedDeepestConfig175.after.heap.size 31 := by
    change 4*71680≤SelectedMakeFgSetup176.after.heap.size 31
    exact SelectedMakeFgDomains176.extent
  have initSize : SelectedDeepestConfig175.after.heap.size 31<2^64 := by
    change SelectedMakeFgSetup176.after.heap.size 31<2^64
    exact SelectedMakeFgDomains176.size_bound
  have initWritable : SelectedDeepestConfig175.after.heap.writable 31=true := by
    change SelectedMakeFgSetup176.after.heap.writable 31=true
    exact SelectedMakeFgDomains176.writable
  have stable := KeygenMemoryStability.trans _ _ _ (KeygenSearchStability.deepest env.ctx _ _ _ part2) (KeygenSearchStability.deepest env.ctx _ _ _ crt)
  have sameHeap : s.heap=rebuilt.heap := (BezoutLengthCells217.heap _ _ _).trans (BezoutPointerSetup217.heap rebuilt)
  have extent : 4*71680≤fin.heap.size 31 := by change 4*71680≤s.heap.size 31; rw [sameHeap,stable.size]; exact initExtent
  have size : fin.heap.size 31<2^64 := by change s.heap.size 31<2^64; rw [sameHeap,stable.size]; exact initSize
  have writable : fin.heap.writable Gp.block=true := by change s.heap.writable 31=true; rw [sameHeap,stable.writable]; exact initWritable
  have allocated : Allocated fin.heap Gp := by
    have h := BezoutInitCopies217.allocated_at fin.heap 335 0 extent size (by decide)
    exact h
  have xcell : Cell fin "xlen".toList nx := BezoutLengthCells217.xcell (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)
  have ycell : Cell fin "ylen".toList ny := BezoutLengthCells217.ycell (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)
  have adecl : fin.locals "alen".toList=some (.uint64,none) := by
    change (ExactLengthCalls217.after (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)).locals "alen".toList=some (.uint64,none)
    exact (SelectedStepAddPrime195.locals_keep _ "ylen".toList .uint64 _ "alen".toList (by decide)).trans
      ((SelectedStepAddPrime195.locals_keep _ "xlen".toList .uint64 _ "alen".toList (by decide)).trans (BezoutInitStoreCells217.a_decl rebuilt))
  have bdecl : fin.locals "blen".toList=some (.uint64,none) := by
    change (ExactLengthCalls217.after (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)).locals "blen".toList=some (.uint64,none)
    exact (SelectedStepAddPrime195.locals_keep _ "ylen".toList .uint64 _ "blen".toList (by decide)).trans
      ((SelectedStepAddPrime195.locals_keep _ "xlen".toList .uint64 _ "blen".toList (by decide)).trans (BezoutInitStoreCells217.b_decl rebuilt))
  have ub : fin.arrays "u0".toList=some Gp := BezoutInitStoreCells217.u0_binding rebuilt
  have input : BezoutInitStore217.Input fin nx ny := ⟨nxBound,nyBound,xcell,ycell,adecl,bdecl,ub,allocated,writable⟩
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨copyRun,xf,yf,af,bf⟩:=copies good
  obtain ⟨storeRun,ac,bc,read⟩:=BezoutInitStore217.source fin nx ny input
  have sepF : ∀ i<335, Word32Memory176.Separate Gp (StepCopyBody190.elem fd i) := by
    intro i _; right; left; change 0+4*335+4≤0+4*(670+i); omega
  have sepG : ∀ i<335, Word32Memory176.Separate Gp (StepCopyBody190.elem gd i) := by
    intro i _; right; left; change 0+4*335+4≤0+4*(1005+i); omega
  have sepA : ∀ i<nx, Word32Memory176.Separate Gp (StepCopyBody190.elem a i) := by
    intro i _; right; left; change 0+4*335+4≤0+4*(2010+i); omega
  have sepB : ∀ i<ny, Word32Memory176.Separate Gp (StepCopyBody190.elem b i) := by
    intro i _; right; left; change 0+4*335+4≤0+4*(2345+i); omega
  exact ⟨.seqNormal _ _ _ _ _ copyRun storeRun,ac,bc,read,
    BezoutInitStore217.keep_data fin nx ny _ fd _ xf sepF,BezoutInitStore217.keep_data fin nx ny _ gd _ yf sepG,
    BezoutInitStore217.keep_data fin nx ny _ a _ af sepA,BezoutInitStore217.keep_data fin nx ny _ b _ bf sepB⟩

end FT1536.Source3.SelectedBezoutInitStore217
