import Source3.SecondExtraPair212
import Source3.SecondExtraGenerator212
import Source3.SecondExtraStatics212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraInner212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open SecondStepOuter204 (Outer)
open SecondStepBasic203 (Basic)
open SecondStepLayout197 (fd gd fs gs gm igm)
open KeygenFullData127 (primes rev)
open SecondExtraPrime212 (p2 i2 r22 rx2)
open ZintNormWalkFlat208 (Data)
open StepCopyBody190 (elem addr)
open SecondExtraSide212 (words)

def Earlier (q : ArrayPointer) : Prop := SecondExtraGeometry212.Safe q ∧
  MkgmCallKeep203.Outside gm q ∧ MkgmCallKeep203.Outside igm q

theorem source (s : State) (F G : Nat → BitVec 32) (h : Outer s 2)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revBinding : s.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 512 F) (gdata : Data s gs 512 G) :
    ∃ (out : State) (gvs : Fin 256 → BitVec 32),
      Exec MakeFgAddPrimeShape194.aInner s ⟨out,.normal⟩ ∧ Basic out 2 p2 i2 r22 ∧
      StepProductFixed203.Image out fd 2 3 128 p2 i2 r22 (words F gvs p2 i2 r22 rx2) 128 ∧
      StepProductFixed203.Image out gd 2 3 128 p2 i2 r22 (words G gvs p2 i2 r22 rx2) 128 ∧
      (∀ name : Name, name∉MakeFgAddPrimeShape194.localNames → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, Earlier q → Load32 s.heap q old → Load32 out.heap q old) := by
  let before:=SecondExtraPrime212.after s
  have basic:=SecondExtraPrime212.basic s h
  obtain ⟨generated,gvs,ivs,genRun,gb,gls,gas,gloads,_,gkeep⟩:=SecondExtraGenerator212.source before basic object revBinding revSource
  have fsAfter : Data generated fs 512 F := by
    intro j bound
    have outside:=SecondStepGeneratorKeep203.source_outside j bound
    exact gkeep _ outside.1 outside.2.1 _ (fdata j bound)
  have gsAfter : Data generated gs 512 G := by
    intro j bound
    have outside:=SecondStepGeneratorKeep203.source_outside j bound
    exact gkeep _ outside.2.2.1 outside.2.2.2 _ (gdata j bound)
  have rxCell : KeygenModpR2Exec.Slot generated "Rx" rx2 := (congrFun gls _).trans (SecondExtraPrime212.rx_cell s)
  have vNone : generated.locals "v".toList=some (.uint64,none) := (congrFun gls _).trans rfl
  obtain ⟨out,pairRun,ob,fdImage,gdImage,pls,pas,pkeep⟩:=SecondExtraPair212.source generated p2 i2 r22 rx2 F G gvs gb rxCell fsAfter gsAfter gloads none vNone
  have remaining : Exec MakeFgAddPrimeShape194.remaining before ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.r0_split]
    exact .seqNormal _ _ _ _ _ genRun pairRun
  have run : Exec MakeFgAddPrimeShape194.aInner s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.prefix_shape]
    exact SecondExtraPrime212.source s h object _ _ remaining
  refine ⟨out,gvs,run,ob,fdImage,gdImage,?_,?_,?_⟩
  · intro name absent
    have nv : name≠"v".toList := by intro eq; apply absent; rw [eq]; decide
    exact (pls name nv).trans ((congrFun gls name).trans (SecondExtraPrime212.locals s name absent))
  · intro name nx
    exact (pas name nx).trans ((congrFun gas name).trans (SecondExtraPrime212.arrays s name nx))
  · intro q old earlier loaded
    exact pkeep q old earlier.1 (gkeep q earlier.2.1 earlier.2.2 old loaded)

theorem product_earlier (side : SecondStepCopy203.Side) (u j : Nat) (ub : u<2) (jb : j<128) :
    Earlier (addr (SecondExtraProduct212.root side) u j 3) := by
  have a:=SecondExtraGeometry212.product_old .f side u j ub jb
  have b:=SecondExtraGeometry212.product_old .g side u j ub jb
  refine ⟨⟨a,b⟩,?_,?_⟩
  all_goals intro byte; right; left
  · cases side
    · change 0+4*(670+u+j*3)+byte.val<0+4*2462; have bb:=byte.isLt; omega
    · change 0+4*(1054+u+j*3)+byte.val<0+4*2462; have bb:=byte.isLt; omega
  · cases side
    · change 0+4*(670+u+j*3)+byte.val<0+4*2718; have bb:=byte.isLt; omega
    · change 0+4*(1054+u+j*3)+byte.val<0+4*2718; have bb:=byte.isLt; omega

end FT1536.Source3.SecondExtraInner212
