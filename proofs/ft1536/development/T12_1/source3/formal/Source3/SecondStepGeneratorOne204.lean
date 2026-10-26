import Source3.SecondStepPrimeOne204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepGeneratorOne204
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open SelectedStepAddPrime195 (p1 p0i1 r21 primes1)
open StepU1Entry195 (g1)
open SecondStepLayout197 (gm igm)
open KeygenSmallOutput (element)
open SecondStepOuter204 (Outer)
open SecondStepBasic203 (Basic)

def before (s : State) := SecondStepPrimeOne204.after s

theorem before_heap (s : State) : (before s).heap=s.heap := SecondStepPrimeOne204.heap s

theorem g_read (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) :
    KeygenLevelCalls.PrimeRead (before s) "primes".toList (FirstStepEntry187.var "u") .g (.uint32 g1) := by
  have b:=SecondStepPrimeOne204.basic s h
  have objectAfter : KeygenStaticTables.PrimeObject (before s).heap primes .ternary := by
    rw [before_heap]; exact object
  exact .read primes1 g1
    (.add _ _ primes primes1 (.uint64 1) b.primesBinding (.variable _ _ _ b.uCell) (by decide)
      (.within primes 1 (by decide))) SelectedStepAddPrime195.primes1_width SelectedStepAddPrime195.primes1_extent
    (by rw [StepU1Entry195.fieldPointer_one_g]; exact StepU1Entry195.g_object_word (before s) objectAfter)

theorem input (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revBinding : s.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev) :
    MkgmCall200.Input 7 (before s) gm igm rev g1 p1 p0i1 := by
  have b:=SecondStepPrimeOne204.basic s h
  refine ⟨b.pCell,b.iCell,b.lognCell,g_read s h object,b.gmBinding,b.igmBinding,revBinding,?_,rfl,rfl,?_,?_,b.writable,b.writable⟩
  · rw [before_heap]; exact revSource
  · intro j bound
    exact b.allocated (2462+j) (by change j<256 at bound; omega)
  · intro j bound
    exact b.allocated (2718+j) (by change j<256 at bound; omega)

theorem source (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revBinding : s.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev) :
    ∃ (out : State) (gvs ivs : Fin 256 → BitVec 32),
      Exec StepPrimeShape188.generateBranch (before s) ⟨out,.normal⟩ ∧ Basic out 1 p1 p0i1 r21 ∧
      out.locals "v".toList=some (.uint64,none) ∧
      (∀ i, Load32 out.heap (element gm i.val) (gvs i)) ∧
      (∀ i, Load32 out.heap (element igm i.val) (ivs i)) ∧
      (∀ q : ArrayPointer, MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  have b:=SecondStepPrimeOne204.basic s h
  obtain ⟨out,run,locals,arrays,reads,keeps⟩ := MkgmCallKeep203.branch_source 7 (before s) gm igm rev g1 p1 p0i1
    (input s h object revBinding revSource) b.terCell
  have basic:=SecondStepBasic203.transport b run (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name)
  have gRead (i : Fin 256) : ∃ w, Load32 out.heap (element gm i.val) w := (reads i.val i.isLt).1
  have iRead (i : Fin 256) : ∃ w, Load32 out.heap (element igm i.val) w := (reads i.val i.isLt).2
  refine ⟨out,(fun i => Classical.choose (gRead i)),(fun i => Classical.choose (iRead i)),run,basic,
    (congrFun locals "v".toList).trans (SecondStepPrimeOne204.v_declared s),
    (fun i => Classical.choose_spec (gRead i)),(fun i => Classical.choose_spec (iRead i)),?_⟩
  intro q gOutside iOutside w loaded
  apply keeps q gOutside iOutside w
  rw [before_heap]
  exact loaded

end FT1536.Source3.SecondStepGeneratorOne204
