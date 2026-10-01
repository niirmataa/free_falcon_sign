import Source3.FftGlobalMemory
import Source3.CertificateFunctionOutcome

namespace FT1536.Source3.CertificateM0Environment
open C99MemoryReference
open CertificateFunctionReference

/- Static source objects occupy their own read-only blocks. The remaining
   caller memory is retained, including block0 used by the workspace/frame.
   This fixes the scalar/table environment used by the certificate machine. -/
def Pinned (environment : Environment) (memory : Memory) : Prop :=
  environment=FftGlobalMemory.environment ∧
  ∀ (table : FftTableParser.Table) (i : Nat) (hi : i<(FftTableSources.words table).length),
    Load64 memory {FftGlobalMemory.pointer table with index := i} (FftTableSources.words table)[i] ∧
      memory.writable (FftGlobalMemory.block table)=false

theorem installed_pinned (before : Memory) : Pinned FftGlobalMemory.environment (FftGlobalMemory.install before) := by
  refine ⟨rfl,?_⟩
  intro table i hi
  exact ⟨FftGlobalMemory.loaded_source_word before table i hi,FftGlobalMemory.read_only before table⟩

def Exec (args : Arguments) (caller after : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (ret : Bool) : Prop :=
  Pinned FftGlobalMemory.environment caller ∧
    CertificateFunctionReference.Exec args FftGlobalMemory.environment caller after gateTrace events ret

theorem stored_words (args : Arguments) (caller after : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (profile : Profile args)
    (legal : CertificateFrameEntry.Legal args.base caller)
    (source : Exec args caller after gateTrace events true) : CertificateFunctionOutcome.StoredBounds args caller after :=
  (CertificateFunctionOutcome.accepted args FftGlobalMemory.environment caller after gateTrace events profile legal source.2).2.1

end FT1536.Source3.CertificateM0Environment
