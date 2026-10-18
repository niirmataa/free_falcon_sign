import Source3.SelectedGeneratorRowPrelude179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorRowFixed179
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p p0i)
open SelectedGeneratorSquare178 (g1)
open SelectedGeneratorInverseCall178 (ig)
open SelectedGeneratorRowPrelude179 (before after input)
open GeneratorRowPrelude179 (square fourth)

def g2 := square g1 p p0i
def g4 := fourth g1 p p0i
def ig2 := square ig p p0i
def ig4 := fourth ig p p0i

theorem g_binding : after.arrays "gm".toList=some gm := by
  rw [SelectedGeneratorRowPrelude179.arrays]
  rfl

theorem i_binding : after.arrays "igm".toList=some igm := by
  rw [SelectedGeneratorRowPrelude179.arrays]
  rfl

theorem table : KeygenMkgm3RevMemory.Rev after rev := by
  apply KeygenMkgm3RevMemory.from_source after rev
  · rw [SelectedGeneratorRowPrelude179.arrays]
    exact SelectedGeneratorEntry178.rev_binding
  · rw [SelectedGeneratorRowPrelude179.heap]
    exact SelectedGeneratorEntry178.rev_source

theorem g_allocated (j : Nat) (bound : j<1024) : Allocated after.heap (element gm j) := by
  rw [SelectedGeneratorRowPrelude179.heap]
  exact SelectedGeneratorEntry178.allocated (4766+j) (by omega)

theorem i_allocated (j : Nat) (bound : j<1024) : Allocated after.heap (element igm j) := by
  rw [SelectedGeneratorRowPrelude179.heap]
  exact SelectedGeneratorEntry178.allocated (5790+j) (by omega)

theorem writable : after.heap.writable 31=true := by
  rw [SelectedGeneratorRowPrelude179.heap]
  exact SelectedGeneratorEntry178.writable

theorem fixed : GeneratorRowFixed179.Fixed after gm igm rev p p0i g2 g4 ig2 ig4 :=
  ⟨GeneratorRowPreludeFacts179.p_cell before g1 ig p p0i input,
    GeneratorRowPreludeFacts179.i_cell before g1 ig p p0i input,
    GeneratorRowPreludeFacts179.g2_cell before g1 ig p p0i,
    GeneratorRowPreludeFacts179.g4_cell before g1 ig p p0i,
    GeneratorRowPreludeFacts179.ig2_cell before g1 ig p p0i,
    GeneratorRowPreludeFacts179.ig4_cell before g1 ig p p0i,
    GeneratorRowPreludeFacts179.k_cell before g1 ig p p0i,
    GeneratorRowPreludeFacts179.b_cell before g1 ig p p0i,
    g_binding,i_binding,table,by decide,by decide,g_allocated,i_allocated,writable,writable⟩

end FT1536.Source3.SelectedGeneratorRowFixed179
