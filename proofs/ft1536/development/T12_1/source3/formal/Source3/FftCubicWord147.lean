import Source3.FftGroupTwiddle143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftCubicWord147

def pair (i : Nat) : BitVec 64 × BitVec 64 := (FftTableSources.pairs .cubic)[i]?.getD (0,0)

theorem found (i : Nat) (bound : i<2048) : (FftTableSources.pairs .cubic)[i]?=some (pair i) :=
  FftGroupTwiddle143.lookup (FftTableSources.pairs .cubic) i (0,0) (by rw [FftTableSources.pairs_length]; exact bound)

theorem real_load (heap : C99MemoryReference.Memory)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment heap) (i : Nat) (bound : i<2048) :
    C99MemoryReference.Load64 heap {FftGlobalMemory.pointer .cubic with index := 2*i} (pair i).1 :=
  FftTableWord139.loaded heap pinned .cubic (2*i) (pair i).1 (FftTableWord139.even .cubic i (pair i) (found i bound))

theorem imag_load (heap : C99MemoryReference.Memory)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment heap) (i : Nat) (bound : i<2048) :
    C99MemoryReference.Load64 heap {FftGlobalMemory.pointer .cubic with index := 2*i+1} (pair i).2 :=
  FftTableWord139.loaded heap pinned .cubic (2*i+1) (pair i).2 (FftTableWord139.odd .cubic i (pair i) (found i bound))

end FT1536.Source3.FftCubicWord147
