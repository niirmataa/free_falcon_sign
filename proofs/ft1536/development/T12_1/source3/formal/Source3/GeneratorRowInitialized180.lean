import Source3.Word32Initialized180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowInitialized180
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99InitializationTrace (Preserves preserves_trans)
open KeygenSmallOutput (element)
open KeygenMkgm3Indices (lastIndex)
open Word32Initialized180 (At write_preserves write_initializes transported)

def Prefix (heap : Memory) (gm igm : ArrayPointer) (count : Nat) : Prop :=
  ∀ u<count, At heap (element gm (lastIndex u)) ∧ At heap (element igm (lastIndex u))

theorem preserves (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :
    Preserves s.heap (GeneratorRowBody179.after s gm igm p p0i g2 g4 ig2 ig4 x ix u).heap := by
  let st := GeneratorRowBody179.states s gm igm p p0i g2 g4 ig2 ig4 x ix u
  have a : Preserves s.heap st.a.heap := write_preserves s.heap (element gm (lastIndex u)) x
  have b : Preserves st.a.heap st.b.heap := write_preserves st.a.heap (element igm (lastIndex u)) ix
  have e : Preserves st.b.heap st.e.heap := write_preserves st.d.heap (element gm (lastIndex (u+1))) (GeneratorRowBody179.mul x g4 p p0i)
  have f : Preserves st.e.heap st.f.heap := write_preserves st.e.heap (element igm (lastIndex (u+1))) (GeneratorRowBody179.mul ix ig4 p p0i)
  exact preserves_trans _ _ _ a (preserves_trans _ _ _ b (preserves_trans _ _ _ e f))

theorem pair (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :
    let out := GeneratorRowBody179.after s gm igm p p0i g2 g4 ig2 ig4 x ix u
    (At out.heap (element gm (lastIndex u)) ∧ At out.heap (element igm (lastIndex u))) ∧
    (At out.heap (element gm (lastIndex (u+1))) ∧ At out.heap (element igm (lastIndex (u+1)))) := by
  let st := GeneratorRowBody179.states s gm igm p p0i g2 g4 ig2 ig4 x ix u
  have b : Preserves st.a.heap st.b.heap := write_preserves st.a.heap (element igm (lastIndex u)) ix
  have e : Preserves st.b.heap st.e.heap := write_preserves st.d.heap (element gm (lastIndex (u+1))) (GeneratorRowBody179.mul x g4 p p0i)
  have f : Preserves st.e.heap st.f.heap := write_preserves st.e.heap (element igm (lastIndex (u+1))) (GeneratorRowBody179.mul ix ig4 p p0i)
  have tail := preserves_trans _ _ _ e f
  refine ⟨⟨?_,?_⟩,⟨?_,?_⟩⟩
  · exact transported _ _ _ (preserves_trans _ _ _ b tail) (write_initializes s.heap _ x)
  · exact transported _ _ _ tail (write_initializes st.a.heap _ ix)
  · exact transported _ _ _ f (write_initializes st.d.heap _ (GeneratorRowBody179.mul x g4 p p0i))
  · exact write_initializes st.e.heap _ (GeneratorRowBody179.mul ix ig4 p p0i)

theorem grows (s : State) (gm igm : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat)
    (old : Prefix s.heap gm igm u) :
    Prefix (GeneratorRowBody179.after s gm igm p p0i g2 g4 ig2 ig4 x ix u).heap gm igm (u+2) := by
  intro i bound
  by_cases early : i<u
  · exact ⟨transported _ _ _ (preserves s gm igm p p0i g2 g4 ig2 ig4 x ix u) (old i early).1,
      transported _ _ _ (preserves s gm igm p p0i g2 g4 ig2 ig4 x ix u) (old i early).2⟩
  · have cases : i=u ∨ i=u+1 := by omega
    rcases cases with equal | equal
    · rw [equal]
      exact (pair s gm igm p p0i g2 g4 ig2 ig4 x ix u).1
    · rw [equal]
      exact (pair s gm igm p p0i g2 g4 ig2 ig4 x ix u).2

end FT1536.Source3.GeneratorRowInitialized180
