import Source3.KeygenMakeWorkspaceRelocation
import Source3.KeygenMakeCertMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The M0 table-block inversion: the pinned static tables occupy exactly
   heap blocks 1 and 2, so every other block (in particular the relocated
   workspace block0 and the foreign material blocks) is outside all table
   pointers. This closes the inversion that a general same-block call frame
   needs before it can consume `CallerFrame`. The inversion is over the
   pinned `FftGlobalMemory.tables` dispatch only; no table contents or
   certificate outcome is used. -/
namespace FT1536.Source3.KeygenMakeWorkspaceTables
open C99ArrayReference (State Name)
open C99MemoryReference
open CertificateFunctionReference (Arguments)

theorem tables_block (name : Name) (p : ArrayPointer)
    (source : FftGlobalMemory.tables name=some p) : p.block=1 ∨ p.block=2 := by
  simp only [FftGlobalMemory.tables] at source
  split at source
  · next square =>
    have equal : p=FftGlobalMemory.pointer .square := (Option.some.inj source).symm
    exact Or.inl (by rw [equal]; rfl)
  · next cubic =>
    split at source
    · next taken =>
      have equal : p=FftGlobalMemory.pointer .cubic := (Option.some.inj source).symm
      exact Or.inr (by rw [equal]; rfl)
    · cases source

theorem initial_tables (args : Arguments) (caller : Memory) :
    (CertificateFunctionReference.initial args FftGlobalMemory.environment caller).tables=
      FftGlobalMemory.tables := rfl

theorem tablesOutside_nonTable (args : Arguments) (caller : Memory) (block offset : Nat)
    (not1 : block≠1) (not2 : block≠2) :
    C99PointerFootprint.TablesOutside
      (CertificateFunctionReference.initial args FftGlobalMemory.environment caller) block offset := by
  intro name p binding
  have dispatch : FftGlobalMemory.tables name=some p := by
    rw [← initial_tables args caller]
    exact binding
  rcases tables_block name p dispatch with one | two
  · exact Or.inl (by rw [one]; exact not1)
  · exact Or.inl (by rw [two]; exact not2)

theorem tablesOutside_zero (args : Arguments) (caller : Memory) (offset : Nat) :
    C99PointerFootprint.TablesOutside
      (CertificateFunctionReference.initial args FftGlobalMemory.environment caller) 0 offset :=
  tablesOutside_nonTable args caller 0 offset (by decide) (by decide)

/-- General same-block frame consumption: any live byte of a foreign block
    outside the certificate workspace and outside the two table blocks keeps
    its content through the accepted call. -/
theorem foreign_block_retained (args : Arguments) (caller after : Memory)
    (frame : CertificateFunctionOutcome.CallerFrame args FftGlobalMemory.environment caller after)
    (block offset : Nat) (live : offset<caller.size block)
    (outside : CertificateRegionFrame.Outside args.base block offset)
    (not1 : block≠1) (not2 : block≠2) :
    after.bytes block offset=caller.bytes block offset :=
  frame block offset live outside (tablesOutside_nonTable args caller block offset not1 not2)

/-- The relocated workspace block keeps its foreign bytes through the
    accepted call: block0 is outside the table blocks. -/
theorem workspace_block_retained (args : Arguments) (caller after : Memory)
    (frame : CertificateFunctionOutcome.CallerFrame args FftGlobalMemory.environment caller after)
    (offset : Nat) (live : offset<caller.size 0)
    (outside : CertificateRegionFrame.Outside args.base 0 offset) :
    after.bytes 0 offset=caller.bytes 0 offset :=
  foreign_block_retained args caller after frame 0 offset live outside (by decide) (by decide)

end FT1536.Source3.KeygenMakeWorkspaceTables
