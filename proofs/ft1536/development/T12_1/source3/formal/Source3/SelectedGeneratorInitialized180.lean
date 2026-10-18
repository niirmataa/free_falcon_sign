import Source3.GeneratorRowInitLoop180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorInitialized180
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedTopLayout177 (gm igm)
open KeygenFullData127 (rev)
open SelectedTopInit178 (p p0i)
open SelectedGeneratorSquare178 (g1)
open SelectedGeneratorInverseCall178 (ig)
open SelectedGeneratorRowFixed179 (g2 g4 ig2 ig4)
open SelectedGeneratorRow179 (after)

theorem initialized_prefix : GeneratorRowInitialized180.Prefix after.heap gm igm 512 := by
  obtain ⟨out,x',ix',run,_,_,_,_,initialized⟩ := GeneratorRowInitLoop180.full SelectedGeneratorRowLoop179.before
    gm igm rev p p0i g2 g4 ig2 ig4 g1 ig SelectedGeneratorRowFixed179.fixed
    (GeneratorRowPreludeFacts179.x_cell SelectedGeneratorRowPrelude179.before g1 ig p p0i)
    (GeneratorRowPreludeFacts179.ix_cell SelectedGeneratorRowPrelude179.before g1 ig p p0i)
    none SelectedGeneratorRowPrelude179.u_declared
  have unique := C99ModularArity096.execution_unique KeygenMkgm3Program.lastRowLoop SelectedGeneratorRowLoop179.before
    ⟨out,.normal⟩ ⟨SelectedGeneratorRowLoop179.after,.normal⟩ (by decide) run SelectedGeneratorRowLoop179.source
  have same := congrArg C99ProcedureReference.Result.state unique
  change out=SelectedGeneratorRowLoop179.after at same
  rw [same] at initialized
  exact initialized

theorem g_initialized (i : Nat) (lo : 512 ≤ i) (hi : i < 1024) :
    Word32Initialized180.At after.heap (element gm i) := by
  obtain ⟨u,bound,equal⟩ := KeygenMkgm3Table.last_covers i lo hi
  rw [←equal]
  exact (initialized_prefix u bound).1

theorem i_initialized (i : Nat) (lo : 512 ≤ i) (hi : i < 1024) :
    Word32Initialized180.At after.heap (element igm i) := by
  obtain ⟨u,bound,equal⟩ := KeygenMkgm3Table.last_covers i lo hi
  rw [←equal]
  exact (initialized_prefix u bound).2

theorem g_read (i : Nat) (lo : 512 ≤ i) (hi : i < 1024) : ∃ word, Load32 after.heap (element gm i) word :=
  Word32Initialized180.load after.heap (element gm i) (SelectedGeneratorRowLoop179.fixed.gAllocated i hi)
    rfl (g_initialized i lo hi)

theorem i_read (i : Nat) (lo : 512 ≤ i) (hi : i < 1024) : ∃ word, Load32 after.heap (element igm i) word :=
  Word32Initialized180.load after.heap (element igm i) (SelectedGeneratorRowLoop179.fixed.iAllocated i hi)
    rfl (i_initialized i lo hi)

end FT1536.Source3.SelectedGeneratorInitialized180
