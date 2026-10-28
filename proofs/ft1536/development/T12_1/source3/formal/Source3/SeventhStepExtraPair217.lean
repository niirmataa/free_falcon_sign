import Source3.SeventhStepExtraSide217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d7 additional-prime pair layer, with actual source execution and same-output keeps. -/
namespace FT1536.Source3.SeventhStepExtraPair217
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec Stmt)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SeventhStepProduct217 (root)
open SeventhStepLayout217 (fd gd fs gs gm igm t1)
open SecondStepGeometry203 (scratch ordered)
open SeventhStepGenerator217 (Basic)
open ZintNormWalkFlat208 (Data)
open StepProductFixed203 (Image)
open SeventhStepExtraSide217 (croot)

def Outside (side : Side) (u : Nat) (q : ArrayPointer) : Prop :=
  (∀ i, i < 8 → Separate (elem t1 i) q) ∧
  (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 8 q.block (q.offset+byte.val)) ∧
  (∀ i : Fin 4, Separate (addr (root side) u i.val 82) q)

def Safe (u : Nat) (q : ArrayPointer) : Prop := Outside .f u q ∧ Outside .g u q

theorem before_t1 (index : Nat) (bound : index<2014) :
    (∀ i, i < 8 → Separate (elem t1 i) (scratch index)) ∧
    (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 8 (scratch index).block ((scratch index).offset+byte.val)) := by
  constructor
  · intro i _
    exact StepCopyFixed190.separate_symm (ordered _ _ (by change index<2014+i; omega))
  · intro byte
    right; left
    change 0+4*index+byte.val<0+4*2014
    have b:=byte.isLt
    omega

theorem middle (side : Side) (u : Nat) (hu : u<82) (index : Nat) (lower : 1326 ≤ index) (upper : index<2014) :
    Outside side u (scratch index) := by
  refine ⟨(before_t1 index upper).1,(before_t1 index upper).2,?_⟩
  intro i
  cases side
  · change Separate (scratch (670+u+i.val*82)) (scratch index)
    exact ordered _ _ (by have b:=i.isLt; omega)
  · change Separate (scratch (998+u+i.val*82)) (scratch index)
    exact ordered _ _ (by have b:=i.isLt; omega)

theorem data (side source : Side) (u : Nat) (hu : u<82) (i : Nat) (bound : i<336) :
    Outside side u (elem (croot source) i) := by
  cases source
  · exact middle side u hu (1326+i) (by omega) (by omega)
  · exact middle side u hu (1662+i) (by omega) (by omega)

theorem twiddle (side : Side) (u : Nat) (hu : u<82) (i : Fin 8) : Outside side u (elem gm i.val) :=
  middle side u hu (1998+i.val) (by omega) (by have b:=i.isLt; omega)

theorem f_after_g (u : Nat) (hu : u<82) (j : Nat) (jb : j<4) : Outside .g u (addr fd u j 82) := by
  change Outside .g u (scratch (670+u+j*82))
  refine ⟨(before_t1 _ (by omega)).1,(before_t1 _ (by omega)).2,?_⟩
  intro i
  change Separate (scratch (998+u+i.val*82)) (scratch (670+u+j*82))
  exact StepCopyFixed190.separate_symm (ordered _ _ (by have b:=i.isLt; omega))

/- The per-side chain (walk + NTT3 forward + product march). -/
def sCode (side : Side) : Stmt :=
  .seq (SeventhStepExtraSide217.walkCode side) (.seq MakeFgAddPrimeShape194.nttBranch (SecondStepProduct203.code side))

def reduced (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32) (i : Fin 8) :=
  SignedWalkFixed212.words W 42 i.val p pi r2 rx

noncomputable def sWords (W : Nat → BitVec 32) (gvs : Fin 8 → BitVec 32) (p pi r2 rx : BitVec 32) :=
  NttForwardWhole211.words 2 (reduced W p pi r2 rx) gvs p pi

theorem side_source (side : Side) (s : State) (u : Nat) (p pi r2 rx : BitVec 32) (W : Nat → BitVec 32)
    (gvs : Fin 8 → BitVec 32) (h : Basic s u p pi r2) (hu : u<82) (rxCell : Slot s "Rx" rx)
    (data : Data s (croot side) 336 W) (gloads : ∀ i, Load32 s.heap (elem gm i.val) (gvs i))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (sCode side) s ⟨out,.normal⟩ ∧ Basic out u p pi r2 ∧ Slot out "Rx" rx ∧
      Cell out "v".toList 4 ∧
      Image out (root side) u 82 4 p pi r2 (sWords W gvs p pi r2 rx) 4 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, Outside side u q → Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨walk,wrun,wb,wrx,wv,wimage,wls,was,wkeep⟩ := SeventhStepExtraSide217.walk_source side s u p pi r2 rx W
    h rxCell data old declared
  have wg (i : Fin 8) : Load32 walk.heap (elem gm i.val) (gvs i) :=
    wkeep _ _ (twiddle side u hu i).1 (gloads i)
  obtain ⟨transformed,trun,tb,timage,tls,tas,tkeep⟩ := SeventhStepExtraSide217.forward_source walk u p pi r2
    (reduced W p pi r2 rx) gvs wb (fun i => wimage i.val i.isLt) wg
  have tv : Cell transformed "v".toList 8 := (congrFun tls "v".toList).trans wv
  obtain ⟨out,prun,pb,pv,pimage,pls,pas,pkeep⟩ := SeventhStepExtraSide217.product_source side transformed u p pi r2
    tb hu (sWords W gvs p pi r2 rx) (fun i => timage i.val i.isLt) (some (.uint64 (C99NatWord141.word 8))) tv
  have ls (name : Name) (different : name≠"v".toList) : out.locals name=s.locals name :=
    (pls name different).trans ((congrFun tls name).trans (wls name different))
  have ars (name : Name) (different : name≠"x".toList) : out.arrays name=s.arrays name :=
    (pas name different).trans ((congrFun tas name).trans (was name different))
  refine ⟨out,.seqNormal _ _ _ _ _ wrun (.seqNormal _ _ _ _ _ trun prun),pb,(ls _ (by decide)).trans rxCell,
    pv,pimage,ls,ars,?_⟩
  intro q old outside loaded
  exact pkeep q outside.2.2 old (tkeep q old outside.2.1 (wkeep q old outside.1 loaded))

/- The false !out_ntt skip of the iteration (out_ntt = 1 at this step). -/
theorem out_skip (s : State) (u : Nat) (p pi r2 : BitVec 32) (h : Basic s u p pi r2) :
    Exec MakeFgAddPrimeShape194.outBranch s ⟨s,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.outBranch_guard]
  exact .branchFalse _ _ _ s _ (.int32 0) (.logicalNot _ (.int32 1) (.variable _ _ _ h.outCell)) rfl
    (SelectedStepAddPrime195.skip_run s)

theorem normal_seq (a b : Stmt) (s out : State) (run : Exec (.seq a b) s ⟨out,.normal⟩) :
    ∃ mid, Exec a s ⟨mid,.normal⟩ ∧ Exec b mid ⟨out,.normal⟩ := by
  cases run with
  | seqNormal _ _ _ mid _ first second => exact ⟨mid,first,second⟩
  | seqExit _ _ _ _ _ exit => exact False.elim (exit rfl)

theorem continue_side (side : Side) (s out : State) (run : Exec (sCode side) s ⟨out,.normal⟩)
    (tail : Stmt) (result : C99ProcedureReference.Result) (rest : Exec tail out result) :
    Exec (.seq (SeventhStepExtraSide217.walkCode side)
      (.seq MakeFgAddPrimeShape194.nttBranch (.seq (SecondStepProduct203.code side) tail))) s result := by
  obtain ⟨a,walk,afterWalk⟩:=normal_seq _ _ s out run
  obtain ⟨b,forward,product⟩:=normal_seq _ _ a out afterWalk
  exact .seqNormal _ _ _ _ _ walk (.seqNormal _ _ _ _ _ forward (.seqNormal _ _ _ _ _ product rest))

/- The two sides of one additional-prime iteration body tail. -/
theorem source (s : State) (u : Nat) (p pi r2 rx : BitVec 32) (F G : Nat → BitVec 32)
    (gvs : Fin 8 → BitVec 32) (h : Basic s u p pi r2) (hu : u<82) (rxCell : Slot s "Rx" rx)
    (fdata : Data s fs 336 F) (gdata : Data s gs 336 G)
    (gloads : ∀ i, Load32 s.heap (elem gm i.val) (gvs i))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec MakeFgAddPrimeShape194.r1 s ⟨out,.normal⟩ ∧ Basic out u p pi r2 ∧
      Image out fd u 82 4 p pi r2 (sWords F gvs p pi r2 rx) 4 ∧
      Image out gd u 82 4 p pi r2 (sWords G gvs p pi r2 rx) 4 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, Safe u q → Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨fout,frun,fb,frx,fv,fimage,fls,fas,fkeep⟩ := side_source .f s u p pi r2 rx F gvs h hu rxCell fdata gloads old declared
  have gdataAfter : Data fout gs 336 G :=
    fun i bound => fkeep _ _ (data .f .g u hu i bound) (gdata i bound)
  have gloadsAfter (i : Fin 8) : Load32 fout.heap (elem gm i.val) (gvs i) :=
    fkeep _ _ (twiddle .f u hu i) (gloads i)
  obtain ⟨out,grun,gb,_,_,gimage,gls,gas,gkeep⟩ := side_source .g fout u p pi r2 rx G gvs fb hu frx gdataAfter gloadsAfter
    (some (C99IntegerReference.Value.uint64 (C99NatWord141.word 4))) fv
  have finish : Exec MakeFgAddPrimeShape194.r7 out ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.r7_split,MakeFgAddPrimeShape194.r8_skip]
    exact .seqNormal _ _ _ _ _ (out_skip out u p pi r2 gb) (SelectedStepAddPrime195.skip_run out)
  have run : Exec MakeFgAddPrimeShape194.r1 s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.r1_split,MakeFgAddPrimeShape194.r2_split,MakeFgAddPrimeShape194.r3_split,
      MakeFgAddPrimeShape194.r4_split,MakeFgAddPrimeShape194.r5_split,MakeFgAddPrimeShape194.r6_split,
      MakeFgAddPrimeShape194.walkFs_shape,MakeFgAddPrimeShape194.nttFs_shape,MakeFgAddPrimeShape194.productFd_shape,
      MakeFgAddPrimeShape194.walkGs_shape,MakeFgAddPrimeShape194.nttGs_shape,MakeFgAddPrimeShape194.productGd_shape]
    exact continue_side .f s fout frun _ _ (continue_side .g fout out grun _ _ finish)
  refine ⟨out,run,gb,?_,gimage,?_,?_,?_⟩
  · intro i bound
    exact gkeep _ _ (f_after_g u hu i.val i.isLt) (fimage i bound)
  · intro name different
    exact (gls name different).trans (fls name different)
  · intro name different
    exact (gas name different).trans (fas name different)
  · intro q old safe loaded
    exact gkeep q old safe.2 (fkeep q old safe.1 loaded)

end FT1536.Source3.SeventhStepExtraPair217
