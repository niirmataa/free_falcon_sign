import Source3.BezoutABZeroFrame217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Selected good branch through the two original upper a/b zeroes. -/
namespace FT1536.Source3.SelectedBezoutABZero217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99MemoryReference (ArrayPointer Load32)
open C99NatWord141 (word)
open KeygenFullData127 (env)
open StepCopyBody190 (elem)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b v1)
open DeepestSelectedCrt217 (tmp)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)

def code : KeygenZintCall.Stmt := .seq SelectedBezoutUpper217.code (.seq BezoutABZero217.first BezoutABZero217.second)
noncomputable def after (rebuilt : State) (F G : Nat → BitVec 32) :=
  BezoutABZero217.after (SelectedBezoutUpper217.after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → BezoutABZero217.Input (SelectedBezoutUpper217.after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335) ∧
      KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Load32 (after rebuilt F G).heap Gp 1 ∧
      Data (after rebuilt F G) BezoutInitZero217.firstPtr (highest (Y F G) 335-1) (fun _ => 0) ∧
      Data (after rebuilt F G) Fp (highest (X F G) 335) (fun _ => 0) ∧
      Data (after rebuilt F G) fd 335 (X F G) ∧ Data (after rebuilt F G) gd 335 (Y F G) ∧
      Data (after rebuilt F G) a (highest (X F G) 335) (X F G) ∧ Data (after rebuilt F G) b (highest (Y F G) 335) (Y F G) ∧
      Data (after rebuilt F G) tmp (highest (Y F G) 335) (Y F G) ∧
      Data (after rebuilt F G) v1 (highest (X F G) 335) (BezoutInitLowBit217.image (X F G))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutUpper217.selected
  let fin := SelectedBezoutInitCopies217.finish rebuilt F G
  let mid := SelectedBezoutInitMore217.after rebuilt F G
  let upper := SelectedBezoutUpper217.after rebuilt F G
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  have nxBound : nx≤335 := ExactLengthProgram217.highest_le _ _
  have nyBound : ny≤335 := ExactLengthProgram217.highest_le _ _
  have nx64 : nx<2^64 := lt_of_le_of_lt nxBound (by decide)
  have ny64 : ny<2^64 := lt_of_le_of_lt nyBound (by decide)
  have acMid : Cell mid "alen".toList nx := SelectedBezoutInitMoreCells217.alen fin nx ny (X F G) nx64
  have bcMid : Cell mid "blen".toList ny := SelectedBezoutInitMoreCells217.blen fin nx ny (X F G) ny64
  have ac : Cell upper "alen".toList nx :=
    (SelectedStepAddPrime195.locals_keep (BezoutUpperZero217.after mid nx ny) "mlen".toList .uint64 (.uint64 (word (max nx ny))) "alen".toList (by decide)).trans acMid
  have bc : Cell upper "blen".toList ny :=
    (SelectedStepAddPrime195.locals_keep (BezoutUpperZero217.after mid nx ny) "mlen".toList .uint64 (.uint64 (word (max nx ny))) "blen".toList (by decide)).trans bcMid
  have ab : upper.arrays "a".toList=some a := by rfl
  have bb : upper.arrays "b".toList=some b := by rfl
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨upperInput,priorRun,mlen,one,lowU,lowV,xf,yf,af,bf,uf,vf⟩:=prior good
  have input : BezoutABZero217.Input upper nx ny :=
    ⟨nxBound,nyBound,ac,bc,mlen,ab,bb,upperInput.extent,upperInput.size,upperInput.writable,one⟩
  obtain ⟨first,second,oneAfter⟩:=BezoutABZero217.source upper nx ny input
  have keepBelow (root : ArrayPointer) (start n : Nat) (W : Nat → BitVec 32)
      (shape : root=⟨31,0,71680,4,start⟩) (upperBound : start+n≤2010) (data : Data upper root n W) :
      Data (BezoutABZero217.after upper nx ny) root n W := by
    subst root
    apply BezoutABZeroFrame217.keep_data upper nx ny n _ W data
    · intro i ib; right; left; change 0+4*(start+i)+4≤0+4*(2010+nx); omega
    · intro i ib; right; left; change 0+4*(start+i)+4≤0+4*(2345+ny); omega
  have keepA : Data (BezoutABZero217.after upper nx ny) a nx (X F G) := by
    apply BezoutABZeroFrame217.keep_data upper nx ny nx a _ af
    · intro i ib; right; left; change 0+4*(2010+i)+4≤0+4*(2010+nx); omega
    · intro i ib; right; left; change 0+4*(2010+i)+4≤0+4*(2345+ny); omega
  have keepB : Data (BezoutABZero217.after upper nx ny) b ny (Y F G) := by
    apply BezoutABZeroFrame217.keep_data upper nx ny ny b _ bf
    · intro i ib; right; right; change 0+4*(2010+nx)+4*(max nx ny-nx)≤0+4*(2345+i)
      have maxBound : max nx ny≤335 := (Nat.max_le).2 ⟨nxBound,nyBound⟩
      have le:=Nat.le_max_left nx ny; omega
    · intro i ib; right; left; change 0+4*(2345+i)+4≤0+4*(2345+ny); omega
  exact ⟨input,.seqNormal _ _ _ _ _ priorRun (.seqNormal _ _ _ _ _ first second),oneAfter,
    keepBelow BezoutInitZero217.firstPtr 336 (ny-1) _ BezoutInitZeroImages217.firstPtr_shape (by omega) lowU,
    keepBelow Fp 0 nx _ BezoutInitZeroImages217.Fp_shape (by omega) lowV,
    keepBelow fd 670 335 _ NinthStepLayout217.fd_shape (by decide) xf,
    keepBelow gd 1005 335 _ NinthStepLayout217.gd_shape (by decide) yf,keepA,keepB,
    keepBelow tmp 1340 ny _ BezoutInitMoreCopies217.tmp_shape (by omega) uf,
    keepBelow v1 1675 nx _ BezoutInitMoreCopies217.v1_shape (by omega) vf⟩

end FT1536.Source3.SelectedBezoutABZero217
