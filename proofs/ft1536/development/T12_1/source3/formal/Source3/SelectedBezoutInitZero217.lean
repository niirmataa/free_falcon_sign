import Source3.BezoutInitStoreFrame217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Selected good branch through initial u0/v0 zeroing. -/
namespace FT1536.Source3.SelectedBezoutInitZero217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99MemoryReference (Load32)
open KeygenFullData127 (env)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)
open SelectedBezoutInitCopies217 (finish)

def code : KeygenZintCall.Stmt := .seq SelectedBezoutInitStore217.code (.seq BezoutInitZero217.first BezoutInitZero217.second)
noncomputable def after (rebuilt : State) (F G : Nat → BitVec 32) :=
  BezoutInitZero217.after (SelectedBezoutInitStore217.after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → BezoutInitZero217.Input (SelectedBezoutInitStore217.after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335) ∧
      KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Cell (after rebuilt F G) "alen".toList (highest (X F G) 335) ∧ Cell (after rebuilt F G) "blen".toList (highest (Y F G) 335) ∧
      Load32 (after rebuilt F G).heap Gp 1 ∧ Data (after rebuilt F G) fd 335 (X F G) ∧ Data (after rebuilt F G) gd 335 (Y F G) ∧
      Data (after rebuilt F G) a (highest (X F G) 335) (X F G) ∧ Data (after rebuilt F G) b (highest (Y F G) 335) (Y F G)) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutInitStore217.selected
  let s := state rebuilt F G
  let fin := finish rebuilt F G
  let mid := SelectedBezoutInitStore217.after rebuilt F G
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  have nxBound : nx≤335 := ExactLengthProgram217.highest_le _ _
  have nyBound : ny≤335 := ExactLengthProgram217.highest_le _ _
  have initExtent : 4*71680≤SelectedDeepestConfig175.after.heap.size 31 := by
    change 4*71680≤SelectedMakeFgSetup176.after.heap.size 31; exact SelectedMakeFgDomains176.extent
  have initSize : SelectedDeepestConfig175.after.heap.size 31<2^64 := by
    change SelectedMakeFgSetup176.after.heap.size 31<2^64; exact SelectedMakeFgDomains176.size_bound
  have initWritable : SelectedDeepestConfig175.after.heap.writable 31=true := by
    change SelectedMakeFgSetup176.after.heap.writable 31=true; exact SelectedMakeFgDomains176.writable
  have stable := KeygenMemoryStability.trans _ _ _ (KeygenSearchStability.deepest env.ctx _ _ _ part2) (KeygenSearchStability.deepest env.ctx _ _ _ crt)
  have sameHeap : s.heap=rebuilt.heap := (BezoutLengthCells217.heap _ _ _).trans (BezoutPointerSetup217.heap rebuilt)
  have sizeBefore : fin.heap.size=s.heap.size := rfl
  have writableBefore : fin.heap.writable=s.heap.writable := rfl
  have midSize : mid.heap.size=fin.heap.size := BezoutInitStoreFrame217.size fin nx ny
  have midWritable : mid.heap.writable=fin.heap.writable := BezoutInitStoreFrame217.writable fin nx ny
  have extent : 4*71680≤mid.heap.size 31 := by rw [midSize,sizeBefore,sameHeap,stable.size]; exact initExtent
  have size : mid.heap.size 31<2^64 := by rw [midSize,sizeBefore,sameHeap,stable.size]; exact initSize
  have writable : mid.heap.writable 31=true := by rw [midWritable,writableBefore,sameHeap,stable.writable]; exact initWritable
  have xBefore : Cell fin "xlen".toList nx := BezoutLengthCells217.xcell (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)
  have yBefore : Cell fin "ylen".toList ny := BezoutLengthCells217.ycell (BezoutPointerSetup217.after rebuilt) (X F G) (Y F G)
  have ub : fin.arrays "u0".toList=some Gp := BezoutInitStoreCells217.u0_binding rebuilt
  have vb : fin.arrays "v0".toList=some Fp := by rfl
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨priorRun,ac,bc,one,xf,yf,af,bf⟩:=prior good
  have nz : ny≠0 := (SelectedBezoutOutcome217.good_constraints F G good).2.1
  have positive : 0<ny := Nat.pos_of_ne_zero nz
  have input : BezoutInitZero217.Input mid nx ny :=
    ⟨nxBound,nyBound,positive,BezoutInitStoreFrame217.xlen fin nx ny xBefore,BezoutInitStoreFrame217.ylen fin nx ny yBefore,
      BezoutInitStoreFrame217.u0 fin nx ny ub,BezoutInitStoreFrame217.v0 fin nx ny vb,extent,size,writable,one⟩
  obtain ⟨first,second,oneAfter⟩:=BezoutInitZero217.source mid nx ny input
  have keepF : Data (after rebuilt F G) fd 335 (X F G) := by
    apply BezoutInitZeroFrame217.keep_data mid nx ny 335 fd _ xf
    · intro i bound; right; right; change 0+4*336+4*(ny-1)≤0+4*(670+i); omega
    · intro i bound; right; right; change 0+4*0+4*nx≤0+4*(670+i); omega
  have keepG : Data (after rebuilt F G) gd 335 (Y F G) := by
    apply BezoutInitZeroFrame217.keep_data mid nx ny 335 gd _ yf
    · intro i bound; right; right; change 0+4*336+4*(ny-1)≤0+4*(1005+i); omega
    · intro i bound; right; right; change 0+4*0+4*nx≤0+4*(1005+i); omega
  have keepA : Data (after rebuilt F G) a nx (X F G) := by
    apply BezoutInitZeroFrame217.keep_data mid nx ny nx a _ af
    · intro i bound; right; right; change 0+4*336+4*(ny-1)≤0+4*(2010+i); omega
    · intro i bound; right; right; change 0+4*0+4*nx≤0+4*(2010+i); omega
  have keepB : Data (after rebuilt F G) b ny (Y F G) := by
    apply BezoutInitZeroFrame217.keep_data mid nx ny ny b _ bf
    · intro i bound; right; right; change 0+4*336+4*(ny-1)≤0+4*(2345+i); omega
    · intro i bound; right; right; change 0+4*0+4*nx≤0+4*(2345+i); omega
  exact ⟨input,.seqNormal _ _ _ _ _ priorRun (.seqNormal _ _ _ _ _ first second),ac,bc,oneAfter,keepF,keepG,keepA,keepB⟩

end FT1536.Source3.SelectedBezoutInitZero217
