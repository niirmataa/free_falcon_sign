import Source3.GeneratorCubeBody180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorCubeInitialized180
open C99ArrayReference (State)
open C99MemoryReference (Memory ArrayPointer)
open KeygenSmallOutput (element)
open C99InitializationTrace (Preserves preserves_trans)
open Word32Initialized180 (At write_preserves write_initializes transported)

def Lower (heap : Memory) (gm igm : ArrayPointer) (stop : Nat) : Prop :=
  ∀ i, 256 ≤ i → i < stop → At heap (element gm i) ∧ At heap (element igm i)

theorem preserves (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) :
    Preserves s.heap (GeneratorCubeBody180.after s gm igm p p0i y z u).heap := by
  let st := GeneratorCubeBody180.states s gm igm p p0i y z u
  have g : Preserves s.heap st.storedG.heap := write_preserves s.heap (element gm u) (GeneratorCubeBody180.cube y p p0i)
  have i : Preserves st.storedG.heap st.storedI.heap := write_preserves st.storedG.heap (element igm u) (GeneratorCubeBody180.cube z p p0i)
  exact preserves_trans _ _ _ g i

theorem pair (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) :
    let out := GeneratorCubeBody180.after s gm igm p p0i y z u
    At out.heap (element gm u) ∧ At out.heap (element igm u) := by
  let st := GeneratorCubeBody180.states s gm igm p p0i y z u
  have i : Preserves st.storedG.heap st.storedI.heap := write_preserves st.storedG.heap (element igm u) (GeneratorCubeBody180.cube z p p0i)
  exact ⟨transported _ _ _ i (write_initializes s.heap (element gm u) (GeneratorCubeBody180.cube y p p0i)),
    write_initializes st.storedG.heap (element igm u) (GeneratorCubeBody180.cube z p p0i)⟩

theorem grows (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat)
    (old : Lower s.heap gm igm u) : Lower (GeneratorCubeBody180.after s gm igm p p0i y z u).heap gm igm (u+1) := by
  intro i lo hi
  by_cases early : i<u
  · exact ⟨transported _ _ _ (preserves s gm igm p p0i y z u) (old i lo early).1,
      transported _ _ _ (preserves s gm igm p p0i y z u) (old i lo early).2⟩
  · have equal : i=u := by omega
    rw [equal]
    exact pair s gm igm p p0i y z u

end FT1536.Source3.GeneratorCubeInitialized180
