import Source3.BezoutUpperCells217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual selected good-branch upper zeroes and mlen selection. -/
namespace FT1536.Source3.SelectedBezoutUpper217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99MemoryReference (Load32)
open KeygenFullData127 (env)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open NinthStepLayout217 (fd gd)
open BezoutPointerSetup217 (a b v1)
open DeepestSelectedCrt217 (tmp)
open DeepestBezoutEntry217 (Fp Gp)
open ZintNormWalkFlat208 (Data)
open ExactLengthProgram217 (highest)
open SelectedBezoutGuard217 (state bad X Y)

def code : KeygenZintCall.Stmt := .seq SelectedBezoutInitMore217.code BezoutUpperSequence217.code
noncomputable def after (rebuilt : State) (F G : Nat → BitVec 32) :=
  BezoutUpperSequence217.after (SelectedBezoutInitMore217.after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335)

theorem selected : ∃ (made rebuilt : State) (F G : Nat → BitVec 32),
    KeygenDeepestSource.Exec env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after ⟨made,.normal⟩ ∧
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.head made ⟨rebuilt,.normal⟩ ∧
    (bad F G=false → BezoutUpperZero217.Input (SelectedBezoutInitMore217.after rebuilt F G) (highest (X F G) 335) (highest (Y F G) 335) ∧
      KeygenZintCall.Exec code (state rebuilt F G) ⟨after rebuilt F G,.normal⟩ ∧
      Cell (after rebuilt F G) "mlen".toList (max (highest (X F G) 335) (highest (Y F G) 335)) ∧
      Load32 (after rebuilt F G).heap Gp 1 ∧
      Data (after rebuilt F G) BezoutInitZero217.firstPtr (highest (Y F G) 335-1) (fun _ => 0) ∧
      Data (after rebuilt F G) Fp (highest (X F G) 335) (fun _ => 0) ∧
      Data (after rebuilt F G) fd 335 (X F G) ∧ Data (after rebuilt F G) gd 335 (Y F G) ∧
      Data (after rebuilt F G) a (highest (X F G) 335) (X F G) ∧ Data (after rebuilt F G) b (highest (Y F G) 335) (Y F G) ∧
      Data (after rebuilt F G) tmp (highest (Y F G) 335) (Y F G) ∧
      Data (after rebuilt F G) v1 (highest (X F G) 335) (BezoutInitLowBit217.image (X F G))) := by
  obtain ⟨made,rebuilt,F,G,part2,crt,prior⟩:=SelectedBezoutInitMore217.selected
  let base := BezoutPointerSetup217.after rebuilt
  let fin := SelectedBezoutInitCopies217.finish rebuilt F G
  let mid := SelectedBezoutInitMore217.after rebuilt F G
  let nx := highest (X F G) 335
  let ny := highest (Y F G) 335
  have nxBound : nx≤335 := ExactLengthProgram217.highest_le _ _
  have nyBound : ny≤335 := ExactLengthProgram217.highest_le _ _
  have nx64 : nx<2^64 := lt_of_le_of_lt nxBound (by decide)
  have ny64 : ny<2^64 := lt_of_le_of_lt nyBound (by decide)
  have initExtent : 4*71680≤SelectedDeepestConfig175.after.heap.size 31 := by
    change 4*71680≤SelectedMakeFgSetup176.after.heap.size 31; exact SelectedMakeFgDomains176.extent
  have initSize : SelectedDeepestConfig175.after.heap.size 31<2^64 := by
    change SelectedMakeFgSetup176.after.heap.size 31<2^64; exact SelectedMakeFgDomains176.size_bound
  have initWritable : SelectedDeepestConfig175.after.heap.writable 31=true := by
    change SelectedMakeFgSetup176.after.heap.writable 31=true; exact SelectedMakeFgDomains176.writable
  have stable := KeygenMemoryStability.trans _ _ _ (KeygenSearchStability.deepest env.ctx _ _ _ part2) (KeygenSearchStability.deepest env.ctx _ _ _ crt)
  have baseHeap : base.heap=rebuilt.heap := BezoutPointerSetup217.heap rebuilt
  have lengthSize : (ExactLengthCalls217.after base (X F G) (Y F G)).heap.size=base.heap.size :=
    congrArg C99MemoryReference.Memory.size (BezoutLengthCells217.heap base (X F G) (Y F G))
  have lengthWritable : (ExactLengthCalls217.after base (X F G) (Y F G)).heap.writable=base.heap.writable :=
    congrArg C99MemoryReference.Memory.writable (BezoutLengthCells217.heap base (X F G) (Y F G))
  have finSize : fin.heap.size=base.heap.size := by
    change (ExactLengthCalls217.after base (X F G) (Y F G)).heap.size=base.heap.size
    exact lengthSize
  have finWritable : fin.heap.writable=base.heap.writable := by
    change (ExactLengthCalls217.after base (X F G) (Y F G)).heap.writable=base.heap.writable
    exact lengthWritable
  have midSize : mid.heap.size=fin.heap.size := BezoutUpperCells217.more_size fin nx ny (X F G)
  have midWritable : mid.heap.writable=fin.heap.writable := BezoutUpperCells217.more_writable fin nx ny (X F G)
  have extent : 4*71680≤mid.heap.size 31 := by rw [midSize,finSize,baseHeap,stable.size]; exact initExtent
  have size : mid.heap.size 31<2^64 := by rw [midSize,finSize,baseHeap,stable.size]; exact initSize
  have writable : mid.heap.writable 31=true := by rw [midWritable,finWritable,baseHeap,stable.writable]; exact initWritable
  have lenFin : Cell fin "len".toList 335 :=
    (BezoutUpperCells217.length_frame base (X F G) (Y F G) "len".toList (by decide) (by decide)).trans (BezoutUpperCells217.len_base rebuilt)
  have declFin : fin.locals "mlen".toList=some (.uint64,none) :=
    (BezoutUpperCells217.length_frame base (X F G) (Y F G) "mlen".toList (by decide) (by decide)).trans (BezoutUpperCells217.mlen_base rebuilt)
  have lenMid : Cell mid "len".toList 335 :=
    (BezoutUpperCells217.more_frame fin nx ny (X F G) "len".toList (by decide) (by decide)).trans lenFin
  have declMid : mid.locals "mlen".toList=some (.uint64,none) :=
    (BezoutUpperCells217.more_frame fin nx ny (X F G) "mlen".toList (by decide) (by decide)).trans declFin
  have xc : Cell mid "xlen".toList nx := SelectedBezoutInitMoreCells217.xlen fin nx ny (X F G) (BezoutLengthCells217.xcell base (X F G) (Y F G))
  have yc : Cell mid "ylen".toList ny := SelectedBezoutInitMoreCells217.ylen fin nx ny (X F G) (BezoutLengthCells217.ycell base (X F G) (Y F G))
  have ac : Cell mid "alen".toList nx := SelectedBezoutInitMoreCells217.alen fin nx ny (X F G) nx64
  have bc : Cell mid "blen".toList ny := SelectedBezoutInitMoreCells217.blen fin nx ny (X F G) ny64
  have ub : mid.arrays "u".toList=some Gp := BezoutUpperCells217.u_base rebuilt
  have vb : mid.arrays "v".toList=some Fp := BezoutUpperCells217.v_base rebuilt
  refine ⟨made,rebuilt,F,G,part2,crt,?_⟩
  intro good
  obtain ⟨priorRun,one,zeroU,zeroV,xf,yf,af,bf,uf,vf⟩:=prior good
  have positive : 0<ny := Nat.pos_of_ne_zero (SelectedBezoutOutcome217.good_constraints F G good).2.1
  have input : BezoutUpperZero217.Input mid nx ny := ⟨nxBound,nyBound,positive,lenMid,xc,yc,ub,vb,extent,size,writable,one⟩
  obtain ⟨run,mlen,oneAfter⟩:=BezoutUpperSequence217.source mid nx ny input ac bc declMid
  have keep (root : C99MemoryReference.ArrayPointer) (start n : Nat) (W : Nat → BitVec 32)
      (shape : root=⟨31,0,71680,4,start⟩) (lower : 670≤start) (data : Data mid root n W) :
      Data (BezoutUpperSequence217.after mid nx ny) root n W := by
    subst root
    apply BezoutUpperSequence217.keep_data mid nx ny n _ W data
    · intro i ib; right; right
      change 0+4*(335+ny)+4*(335-ny)≤0+4*(start+i)
      omega
    · intro i ib; right; right
      change 0+4*(0+nx)+4*(335-nx)≤0+4*(start+i)
      omega
  have lowU : Data (BezoutUpperSequence217.after mid nx ny) BezoutInitZero217.firstPtr (ny-1) (fun _ => 0) := by
    apply BezoutUpperSequence217.keep_data mid nx ny (ny-1) BezoutInitZero217.firstPtr _ zeroU
    · intro i ib; right; left; change 0+4*(336+i)+4≤0+4*(335+ny); omega
    · intro i ib; right; right; change 0+4*(0+nx)+4*(335-nx)≤0+4*(336+i); omega
  have lowV : Data (BezoutUpperSequence217.after mid nx ny) Fp nx (fun _ => 0) := by
    apply BezoutUpperSequence217.keep_data mid nx ny nx Fp _ zeroV
    · intro i ib; right; left; change 0+4*(0+i)+4≤0+4*(335+ny); omega
    · intro i ib; right; left; change 0+4*(0+i)+4≤0+4*(0+nx); omega
  exact ⟨input,.seqNormal _ _ _ _ _ priorRun run,mlen,oneAfter,lowU,lowV,
    keep fd 670 335 _ NinthStepLayout217.fd_shape (by decide) xf,
    keep gd 1005 335 _ NinthStepLayout217.gd_shape (by decide) yf,
    keep a 2010 nx _ BezoutInitCopies217.a_shape (by decide) af,
    keep b 2345 ny _ BezoutInitCopies217.b_shape (by decide) bf,
    keep tmp 1340 ny _ BezoutInitMoreCopies217.tmp_shape (by decide) uf,
    keep v1 1675 nx _ BezoutInitMoreCopies217.v1_shape (by decide) vf⟩

end FT1536.Source3.SelectedBezoutUpper217
