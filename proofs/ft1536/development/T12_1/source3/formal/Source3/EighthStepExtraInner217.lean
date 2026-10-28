import Source3.EighthStepExtraPair217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d8 additional-prime inner layer, with actual source execution and same-output keeps. -/
namespace FT1536.Source3.EighthStepExtraInner217
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open EighthStepProduct217 (root)
open EighthStepLayout217 (fd gd fs gs gm igm t1)
open KeygenFullData127 (primes rev)
open EighthStepGenerator217 (Basic Outer rxVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open ZintNormWalkFlat208 (Data)
open StepProductFixed203 (Image)
open EighthStepExtraPair217 (sWords)

def Earlier (u : Nat) (q : ArrayPointer) : Prop :=
  EighthStepExtraPair217.Safe u q ∧ MkgmCallKeep203.Outside gm q ∧ MkgmCallKeep203.Outside igm q

/- Byte-level scratch keeps of the fs/gs rows against the generator. -/
theorem fs_gm_out (i : Nat) (bound : i<328) : MkgmCallKeep203.Outside gm (elem fs i) := by
  intro byte; right; left
  change 0+4*(1334+i)+byte.val<0+4*1990
  have b:=byte.isLt; omega

theorem fs_igm_out (i : Nat) (bound : i<328) : MkgmCallKeep203.Outside igm (elem fs i) := by
  intro byte; right; left
  change 0+4*(1334+i)+byte.val<0+4*1994
  have b:=byte.isLt; omega

theorem gs_gm_out (i : Nat) (bound : i<328) : MkgmCallKeep203.Outside gm (elem gs i) := by
  intro byte; right; left
  change 0+4*(1662+i)+byte.val<0+4*1990
  have b:=byte.isLt; omega

theorem gs_igm_out (i : Nat) (bound : i<328) : MkgmCallKeep203.Outside igm (elem gs i) := by
  intro byte; right; left
  change 0+4*(1662+i)+byte.val<0+4*1994
  have b:=byte.isLt; omega

/- The prime-object input at the post-prefix state. -/
theorem heapP (s : State) (v : Nat×Nat×Nat) : (EighthStepExtraPrime217.after s v).heap=s.heap := rfl

theorem inputP (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : CrtPrimePrefix214.Input s u v) :
    CrtPrimePrefix214.Input (EighthStepExtraPrime217.after s v) u v := by
  refine ⟨input.uBound,?_,input.rowValue,
    (EighthStepExtraPrime217.arrays s "primes".toList (by decide)).trans input.primesBinding,?_⟩
  · exact (EighthStepExtraPrime217.locals s v "u".toList (by decide)).trans input.uCell
  · rw [heapP]; exact input.primeObject

/- One complete additional-prime iteration at loop index u and row v. -/
theorem source (s : State) (u : Nat) (v : Nat×Nat×Nat) (F G : Nat → BitVec 32)
    (o : Outer s u) (input : CrtPrimePrefix214.Input s u v) (hu : u<166)
    (revB : s.tables "REV10".toList=some rev) (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 328 F) (gdata : Data s gs 328 G) :
    ∃ (out : State) (gvs : Fin 4 → BitVec 32),
      Exec MakeFgAddPrimeShape194.aInner s ⟨out,.normal⟩ ∧
      Basic out u (pVal v) (iVal v) (rVal v) ∧
      Image out fd u 166 2 (pVal v) (iVal v) (rVal v) (sWords F gvs (pVal v) (iVal v) (rVal v) (rxVal v)) 2 ∧
      Image out gd u 166 2 (pVal v) (iVal v) (rVal v) (sWords G gvs (pVal v) (iVal v) (rVal v) (rxVal v)) 2 ∧
      (∀ name : Name, name∉MakeFgAddPrimeShape194.localNames → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, Earlier u q → Load32 s.heap q old → Load32 out.heap q old) := by
  let before := EighthStepExtraPrime217.after s v
  have basic := EighthStepExtraPrime217.basic s u v o
  obtain ⟨generated,gvs,ivs,genRun,gb,gls,gas,gloads,_,gkeep⟩ :=
    EighthStepGenerator217.generatorT before u v (pVal v) (iVal v) (rVal v) basic (inputP s u v input)
      revB (by rw [heapP]; exact revS)
  have fsAfter : Data generated fs 328 F := by
    intro j bound
    exact gkeep _ (fs_gm_out j bound) (fs_igm_out j bound) _ (fdata j bound)
  have gsAfter : Data generated gs 328 G := by
    intro j bound
    exact gkeep _ (gs_gm_out j bound) (gs_igm_out j bound) _ (gdata j bound)
  have rxCell : Slot generated "Rx" (rxVal v) := (congrFun gls "Rx".toList).trans (EighthStepExtraPrime217.rx_cell s v)
  have vNone : generated.locals "v".toList=some (.uint64,none) := (congrFun gls "v".toList).trans rfl
  obtain ⟨out,pairRun,ob,fdImage,gdImage,pls,pas,pkeep⟩ := EighthStepExtraPair217.source generated u
    (pVal v) (iVal v) (rVal v) (rxVal v) F G gvs gb hu rxCell fsAfter gsAfter gloads none vNone
  have remaining : Exec MakeFgAddPrimeShape194.remaining before ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.r0_split]
    exact .seqNormal _ _ _ _ _ genRun pairRun
  have run : Exec MakeFgAddPrimeShape194.aInner s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.prefix_shape]
    exact EighthStepExtraPrime217.source s u v o input _ _ remaining
  refine ⟨out,gvs,run,ob,fdImage,gdImage,?_,?_,?_⟩
  · intro name absent
    have nv : name≠"v".toList := by intro eq; apply absent; rw [eq]; decide
    exact (pls name nv).trans ((congrFun gls name).trans (EighthStepExtraPrime217.locals s v name absent))
  · intro name nx
    exact (pas name nx).trans ((congrFun gas name).trans (EighthStepExtraPrime217.arrays s name nx))
  · intro q old earlier loaded
    exact pkeep q old earlier.1 (gkeep q earlier.2.1 earlier.2.2 old loaded)

end FT1536.Source3.EighthStepExtraInner217
