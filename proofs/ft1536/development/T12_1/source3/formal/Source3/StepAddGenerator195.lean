import Source3.StepAddOps195
import Source3.SelectedStepGenerate195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepAddGenerator195
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open SelectedStepLayout187 (gm igm)
open StepCopyBody190 (elem)
open StepAddBasic195 (Basic)

theorem keep {s : State} (input : StepU1Entry195.Input s) (q : ArrayPointer)
    (block : q.block=31) (low : q.offset+4≤gm.offset) (w : BitVec 32)
    (read : Load32 s.heap q w) :
    Load32 (SelectedStepGenerate195.afterGenerate s input).heap q w := by
  have stable := KeygenHelperStability.make _ _ _ (SelectedStepGenerate195.branch_source s input)
  apply Gate00Memory.load32_transport _ _ q w read stable.size
  intro byte
  have outside : C99ArrayFrame.Outside (StepU1Entry195.entry s)
      ["gm".toList,"igm".toList] q.block (q.offset+byte.val) := by
    rw [block]
    intro name member pointer binding
    simp only [List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with rfl | rfl
    · have current : (StepU1Entry195.entry s).arrays "gm".toList=some gm := rfl
      have equal := Option.some.inj (binding.symm.trans current)
      subst pointer
      right; left
      have hb:=byte.isLt
      omega
    · have current : (StepU1Entry195.entry s).arrays "igm".toList=some igm := rfl
      have equal := Option.some.inj (binding.symm.trans current)
      subst pointer
      right; left
      have hb:=byte.isLt
      have offsetOrder : gm.offset ≤ igm.offset := by decide
      omega
  exact (KeygenLevelModularFrame.body_frame _ _ _ (StepU1Run195.body_source s input)
    ["gm".toList,"igm".toList] (by decide) q.block (q.offset+byte.val) outside).2.2

theorem source (s : State) (b : Basic s) (input : StepU1Entry195.Input s) :
    ∃ (out : State) (gvs : Fin 512 → BitVec 32),
      KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.gBranch s ⟨out,.normal⟩ ∧
      Basic out ∧ (∀ i : Fin 512, Load32 out.heap (elem gm i.val) (gvs i)) ∧
      (∀ q : ArrayPointer, q.block=31 → q.offset+4≤gm.offset →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) := by
  let out := SelectedStepGenerate195.afterGenerate s input
  have run : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.gBranch s ⟨out,.normal⟩ :=
    SelectedStepGenerate195.branch_source s input
  have outBasic : Basic out := StepAddBasic195.transport b run (by decide)
    (fun _ _ => rfl) (fun _ _ => rfl) b.vDeclared
  have preserves : C99InitializationTrace.Preserves s.heap out.heap :=
    StepMemoryInit195.modular _ _ _ (StepU1Run195.body_source s input)
  have initialized : GeneratorSquareDomains181.From out.heap gm igm 0 :=
    GeneratorSquareDomains181.from_transport _ _ gm igm 0 preserves input.rawInit
  have readable (i : Fin 512) : ∃ w, Load32 out.heap (elem gm i.val) w :=
    Word32Initialized180.load _ _ (outBasic.allocated (2718+i.val) (by omega)) rfl
      (initialized i.val (Nat.zero_le _) (by omega)).1
  let gvs : Fin 512 → BitVec 32 := fun i => Classical.choose (readable i)
  refine ⟨out,gvs,run,outBasic,?_,?_⟩
  · intro i
    exact Classical.choose_spec (readable i)
  · intro q block low w read
    exact keep input q block low w read

end FT1536.Source3.StepAddGenerator195
