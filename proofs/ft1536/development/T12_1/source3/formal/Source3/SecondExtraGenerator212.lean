import Source3.SecondExtraPrime212
import Source3.SecondStepGeneratorOne204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraGenerator212
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open KeygenModpR2Exec (Slot)
open SecondExtraPrime212 (p2 g2 i2 r22 rx2 prime2)
open SecondStepLayout197 (gm igm)
open KeygenSmallOutput (element)
open SecondStepBasic203 (Basic)

theorem g_read (s : State) (h : Basic s 2 p2 i2 r22) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) :
    KeygenLevelCalls.PrimeRead s "primes".toList (FirstStepEntry187.var "u") .g (.uint32 g2) :=
  .read prime2 g2
    (.add _ _ primes prime2 (.uint64 2) h.primesBinding (.variable _ _ _ h.uCell) (by decide)
      (.within primes 2 (by decide))) rfl (by decide) (SecondExtraPrime212.g_object s object)

theorem input (s : State) (h : Basic s 2 p2 i2 r22) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revBinding : s.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev) :
    MkgmCall200.Input 7 s gm igm rev g2 p2 i2 := by
  refine ⟨h.pCell,h.iCell,h.lognCell,g_read s h object,h.gmBinding,h.igmBinding,revBinding,revSource,rfl,rfl,?_,?_,h.writable,h.writable⟩
  · intro j bound
    exact h.allocated (2462+j) (by change j<256 at bound; omega)
  · intro j bound
    exact h.allocated (2718+j) (by change j<256 at bound; omega)

theorem branch_shape : MakeFgAddPrimeShape194.gBranch=StepPrimeShape188.generateBranch := by
  rw [MakeFgAddPrimeShape194.generateBranch_guard,MakeFgAddPrimeShape194.genYes_shape,MakeFgAddPrimeShape194.genNo_shape]
  rfl

theorem source (s : State) (h : Basic s 2 p2 i2 r22) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revBinding : s.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev) :
    ∃ (out : State) (gvs ivs : Fin 256 → BitVec 32),
      Exec MakeFgAddPrimeShape194.gBranch s ⟨out,.normal⟩ ∧ Basic out 2 p2 i2 r22 ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ i, Load32 out.heap (element gm i.val) (gvs i)) ∧
      (∀ i, Load32 out.heap (element igm i.val) (ivs i)) ∧
      (∀ q : ArrayPointer, MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨out,run,locals,arrays,reads,keeps⟩ := MkgmCallKeep203.branch_source 7 s gm igm rev g2 p2 i2
    (input s h object revBinding revSource) h.terCell
  have basic:=SecondStepBasic203.transport h run (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name)
  have gRead (i : Fin 256) : ∃ w, Load32 out.heap (element gm i.val) w := (reads i.val i.isLt).1
  have iRead (i : Fin 256) : ∃ w, Load32 out.heap (element igm i.val) w := (reads i.val i.isLt).2
  exact ⟨out,(fun i => Classical.choose (gRead i)),(fun i => Classical.choose (iRead i)),by rw [branch_shape]; exact run,
    basic,locals,arrays,(fun i => Classical.choose_spec (gRead i)),(fun i => Classical.choose_spec (iRead i)),keeps⟩

end FT1536.Source3.SecondExtraGenerator212
