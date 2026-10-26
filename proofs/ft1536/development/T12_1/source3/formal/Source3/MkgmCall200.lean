import Source3.MkgmComplete199
import Source3.StepGeneratorBridge188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmCall200
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open MkgmParams198 (Level lognWord count)

structure Input (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  lognCell : Slot s "logn" (lognWord l)
  gRead : KeygenLevelCalls.PrimeRead s "primes".toList (FirstStepEntry187.var "u") .g (.uint32 g)
  gBinding : s.arrays "gm".toList=some gm
  iBinding : s.arrays "igm".toList=some igm
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  gWidth : gm.elementBytes=4
  iWidth : igm.elementBytes=4
  gAllocated : ∀ j<count l, Allocated s.heap (element gm j)
  iAllocated : ∀ j<count l, Allocated s.heap (element igm j)
  gWritable : s.heap.writable gm.block=true
  iWritable : s.heap.writable igm.block=true

def empty (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def withI (s : State) (p0i : BitVec 32) := bindValue (empty s) "p0i".toList .uint32 (.uint32 p0i)
def withP (s : State) (p p0i : BitVec 32) := bindValue (withI s p0i) "p".toList .uint32 (.uint32 p)
def withG (s : State) (g p p0i : BitVec 32) := bindValue (withP s p p0i) "g".toList .uint32 (.uint32 g)
def withFull (s : State) (g p p0i : BitVec 32) := bindValue (withG s g p p0i) "full".toList .uint32 (.int32 0)
def withLogn (l : Level) (s : State) (g p p0i : BitVec 32) :=
  bindValue (withFull s g p p0i) "logn".toList .uint32 (.uint32 (lognWord l))
def withIgm (l : Level) (s : State) (igm : ArrayPointer) (g p p0i : BitVec 32) :=
  bindPointer (withLogn l s g p p0i) "igm".toList igm
def entry (l : Level) (s : State) (gm igm : ArrayPointer) (g p p0i : BitVec 32) :=
  bindPointer (withIgm l s igm g p p0i) "gm".toList gm

theorem binding (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) :
    KeygenLevelCalls.Bind s (KeygenLevelCalls.params .generate) StepPrimeShape188.args (entry l s gm igm g p p0i) :=
  .pointer "gm".toList "gm".toList C99ProcedureParser.zero gm _ _ _
    (RootBinding175.zero s "gm" gm h.gBinding (by
      have a:=h.gAllocated 0 (by have b:=MkgmParams198.half_range l; unfold count; omega)
      exact Nat.le_of_lt a.2.2.1))
    (.pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _ _
      (RootBinding175.zero s "igm" igm h.iBinding (by
        have a:=h.iAllocated 0 (by have b:=MkgmParams198.half_range l; unfold count; omega)
        exact Nat.le_of_lt a.2.2.1))
      (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 (lognWord l))
        (.modular _ _ (.scalar _ _ (.variable _ _ _ h.lognCell)))
        (.scalar .uint32 "full".toList _ _ _ _ (.int32 0)
          (.modular _ _ (.scalar _ _ (.literal .int32 0)))
          (.scalar .uint32 "g".toList _ _ _ _ (.uint32 g) (.prime _ _ _ _ h.gRead)
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p)
              (.modular _ _ (.scalar _ _ (.variable _ _ _ h.pCell)))
              (.scalar .uint32 "p0i".toList _ [] [] (empty s) (.uint32 p0i)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ h.iCell))) .nil))))))

theorem entry_heap (l : Level) (s : State) (gm igm : ArrayPointer) (g p p0i : BitVec 32) :
    (entry l s gm igm g p p0i).heap=s.heap := rfl

theorem domain (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) :
    MkgmComplete199.Input l (entry l s gm igm g p p0i) gm igm rev g p p0i := by
  have cells : MkgmScalar199.Input l (entry l s gm igm g p p0i) g p p0i := by
    constructor <;> simp [Slot,entry,withIgm,withLogn,withFull,withG,withP,withI,empty,
      bindValue,bindPointer,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]
  exact ⟨cells,⟨cells.pCell,cells.iCell,rfl,rfl,h.gWidth,h.iWidth,
    h.gAllocated,h.iAllocated,h.gWritable,h.iWritable⟩,
    KeygenMkgm3RevMemory.from_source _ rev h.revBinding h.revSource⟩

theorem source (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) :
    ∃ out, KeygenMakeFgSource.Exec StepPrimeShape188.generate s ⟨out,.normal⟩ ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      ∀ j<count l, (∃ w, Load32 out.heap (element gm j) w) ∧ (∃ w, Load32 out.heap (element igm j) w) := by
  obtain ⟨generated,run,reads⟩ := MkgmComplete199.readable l (entry l s gm igm g p p0i) gm igm rev g p p0i
    (domain l s gm igm rev g p p0i h)
  let out := {s with heap:=generated.heap}
  have callRun : KeygenLevelCalls.Call .generate s StepPrimeShape188.args out :=
    .run (entry l s gm igm g p p0i) ⟨generated,.normal⟩ (binding l s gm igm rev g p p0i h) run .voidEnd
  exact ⟨out,.level _ _ _ (.call _ _ _ _ callRun),rfl,rfl,reads⟩

theorem branch_source (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) (ter : Slot s "ter" 1) :
    ∃ out, KeygenMakeFgSource.Exec StepPrimeShape188.generateBranch s ⟨out,.normal⟩ ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      ∀ j<count l, (∃ w, Load32 out.heap (element gm j) w) ∧ (∃ w, Load32 out.heap (element igm j) w) := by
  obtain ⟨out,run,locals,arrays,reads⟩ := source l s gm igm rev g p p0i h
  have inside : KeygenMakeFgSource.Exec (.scope [] [] (.seq StepPrimeShape188.generate KeygenMakeFgSource.skip))
      s ⟨out,.normal⟩ := MakeFgScope187.source _ s out
    (.seqNormal _ _ s out _ run (MakeFgDeclarations176.array_source .skip out out (.skip out)))
  exact ⟨out,.branchTrue _ _ _ s _ (.uint32 1) (.variable _ _ _ ter) (by decide) inside,
    locals,arrays,reads⟩

end FT1536.Source3.MkgmCall200
