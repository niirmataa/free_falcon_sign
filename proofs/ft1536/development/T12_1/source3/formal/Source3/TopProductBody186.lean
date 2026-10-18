import Source3.TopProductFixed186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductBody186
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open KeygenLevelExec (Exec)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (fd gd fs gs)
open TopProductFixed186 (Fixed)
open KeygenNttLoopSupport (USlot)
open TopProductProgram186 (var product)

theorem source (s : State) (p p0i r3 : BitVec 32) (j : Nat) (bound : j<512)
    (fixed : Fixed s p p0i r3) (uc : USlot s "u" (3*j)) (vc : USlot s "v" j) :
    ∃ out, Exec TopProductProgram186.body s ⟨out,.normal⟩ ∧ Fixed out p p0i r3 ∧
      TopProductMemory186.Frame s.heap out.heap ∧ out.locals=s.locals ∧ out.arrays=s.arrays := by
  obtain ⟨f0,rf0⟩ := fixed.fReads (3*j) (by omega)
  obtain ⟨f1,rf1⟩ := fixed.fReads (3*j+1) (by omega)
  obtain ⟨f2,rf2⟩ := fixed.fReads (3*j+2) (by omega)
  let fw : TopProductEval186.Words := ⟨f0,f1,f2⟩
  let first : State := {s with heap:=Word32Memory176.write s.heap (element fd j) (TopProductEval186.output fw p p0i r3)}
  have firstFrame : TopProductMemory186.Frame s.heap first.heap := TopProductMemory186.f_write s.heap j bound _
  have firstFixed : Fixed first p p0i r3 := TopProductFixed186.heap s first.heap p p0i r3 fixed firstFrame
  have firstRun : Exec (TopProductProgram186.write "fd" "fs") s ⟨first,.normal⟩ :=
    .modular _ _ _ (ModularStore184.source s "fd" (var "v") (product "fs") (element fd j)
      (TopProductEval186.output fw p p0i r3)
      (TopProductEval186.address s "fd" fd j _ (by omega) fixed.fdBinding (.variable _ _ _ vc) (fixed.fdAllocated j bound))
      (TopProductEval186.source s "fs" fs (3*j) fw p p0i r3 (by omega) fixed.fsBinding uc fixed.pCell fixed.iCell fixed.rCell rf0 rf1 rf2)
      (fixed.fdAllocated j bound) rfl fixed.writable)
  obtain ⟨g0,rg0⟩ := firstFixed.gReads (3*j) (by omega)
  obtain ⟨g1,rg1⟩ := firstFixed.gReads (3*j+1) (by omega)
  obtain ⟨g2,rg2⟩ := firstFixed.gReads (3*j+2) (by omega)
  let gw : TopProductEval186.Words := ⟨g0,g1,g2⟩
  let out : State := {first with heap:=Word32Memory176.write first.heap (element gd j) (TopProductEval186.output gw p p0i r3)}
  have secondFrame : TopProductMemory186.Frame first.heap out.heap := TopProductMemory186.g_write first.heap j bound _
  have outFixed : Fixed out p p0i r3 := TopProductFixed186.heap first out.heap p p0i r3 firstFixed secondFrame
  have secondRun : Exec (TopProductProgram186.write "gd" "gs") first ⟨out,.normal⟩ :=
    .modular _ _ _ (ModularStore184.source first "gd" (var "v") (product "gs") (element gd j)
      (TopProductEval186.output gw p p0i r3)
      (TopProductEval186.address first "gd" gd j _ (by omega) firstFixed.gdBinding (.variable _ _ _ vc) (firstFixed.gdAllocated j bound))
      (TopProductEval186.source first "gs" gs (3*j) gw p p0i r3 (by omega) firstFixed.gsBinding uc firstFixed.pCell firstFixed.iCell firstFixed.rCell rg0 rg1 rg2)
      (firstFixed.gdAllocated j bound) rfl firstFixed.writable)
  have inner : Exec TopProductProgram186.inner s ⟨out,.normal⟩ :=
    .seqNormal _ _ s first _ firstRun (.seqNormal _ _ first out _ secondRun (.modular _ _ _ (.base .skip out out (.skip out))))
  exact ⟨out,.scope [] [] _ s ⟨out,.normal⟩ inner,outFixed,
    NttWriteFrame182.trans fd 1024 _ _ _ firstFrame secondFrame,rfl,rfl⟩

end FT1536.Source3.TopProductBody186
