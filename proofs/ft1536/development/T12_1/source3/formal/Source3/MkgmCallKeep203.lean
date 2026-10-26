import Source3.MkgmCall200

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmCallKeep203
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open MkgmParams198 (Level count)
open KeygenSmallOutput (element)
open MkgmCall200 (Input entry)

def Outside (root cell : ArrayPointer) : Prop := ∀ byte : Fin 4,
  cell.block≠root.block ∨ cell.offset+byte.val<root.offset ∨
    root.base+root.elementBytes*root.count ≤ cell.offset+byte.val

theorem outside_entry (l : Level) (s : State) (gm igm : ArrayPointer) (g p p0i : BitVec 32)
    (q : ArrayPointer) (first : Outside gm q) (second : Outside igm q) (byte : Fin 4) :
    C99ArrayFrame.Outside (entry l s gm igm g p p0i) ["gm".toList,"igm".toList]
      q.block (q.offset+byte.val) := by
  intro name member pointer binding
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl
  · have current : (entry l s gm igm g p p0i).arrays "gm".toList=some gm := rfl
    have equal:=Option.some.inj (binding.symm.trans current)
    subst pointer
    exact first byte
  · have current : (entry l s gm igm g p p0i).arrays "igm".toList=some igm := rfl
    have equal:=Option.some.inj (binding.symm.trans current)
    subst pointer
    exact second byte

theorem body_keep (l : Level) (s out : State) (gm igm : ArrayPointer) (g p p0i : BitVec 32)
    (run : C99ModularReference.Exec KeygenMkgm3Program.code (entry l s gm igm g p p0i) ⟨out,.normal⟩)
    (q : ArrayPointer) (first : Outside gm q) (second : Outside igm q)
    (w : BitVec 32) (read : Load32 s.heap q w) : Load32 out.heap q w := by
  have stable:=KeygenMemoryStability.modular _ _ _ run
  apply Gate00Memory.load32_transport _ _ q w read stable.size
  intro byte
  exact (KeygenLevelModularFrame.body_frame _ _ _ run ["gm".toList,"igm".toList] (by decide)
    q.block (q.offset+byte.val) (outside_entry l s gm igm g p p0i q first second byte)).2.2

theorem source (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) :
    ∃ out, KeygenMakeFgSource.Exec StepPrimeShape188.generate s ⟨out,.normal⟩ ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j<count l, (∃ w, Load32 out.heap (element gm j) w) ∧ (∃ w, Load32 out.heap (element igm j) w)) ∧
      (∀ q, Outside gm q → Outside igm q → ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨generated,run,reads⟩ := MkgmComplete199.readable l (entry l s gm igm g p p0i) gm igm rev g p p0i
    (MkgmCall200.domain l s gm igm rev g p p0i h)
  let out := {s with heap:=generated.heap}
  have callRun : KeygenLevelCalls.Call .generate s StepPrimeShape188.args out :=
    .run _ ⟨generated,.normal⟩ (MkgmCall200.binding l s gm igm rev g p p0i h) run .voidEnd
  exact ⟨out,.level _ _ _ (.call _ _ _ _ callRun),rfl,rfl,reads,body_keep l s generated gm igm g p p0i run⟩

theorem branch_source (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) (ter : Slot s "ter" 1) :
    ∃ out, KeygenMakeFgSource.Exec StepPrimeShape188.generateBranch s ⟨out,.normal⟩ ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j<count l, (∃ w, Load32 out.heap (element gm j) w) ∧ (∃ w, Load32 out.heap (element igm j) w)) ∧
      (∀ q, Outside gm q → Outside igm q → ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨out,run,locals,arrays,reads,keeps⟩ := source l s gm igm rev g p p0i h
  have body : KeygenMakeFgSource.Exec (.scope [] [] (.seq StepPrimeShape188.generate KeygenMakeFgSource.skip))
      s ⟨out,.normal⟩ := MakeFgScope187.source _ s out
    (.seqNormal _ _ s out _ run (MakeFgDeclarations176.array_source .skip out out (.skip out)))
  exact ⟨out,.branchTrue _ _ _ s _ (.uint32 1) (.variable _ _ _ ter) (by decide) body,locals,arrays,reads,keeps⟩

end FT1536.Source3.MkgmCallKeep203
