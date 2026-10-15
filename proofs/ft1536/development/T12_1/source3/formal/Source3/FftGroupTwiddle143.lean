import Source3.FftTableWord139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupTwiddle143

def pair (i : Nat) : BitVec 64 × BitVec 64 := (FftTableSources.pairs .square)[i]?.getD (0,0)

theorem lookup {α : Type} (xs : List α) (i : Nat) (fallback : α) (bound : i<xs.length) :
    xs[i]?=some (xs[i]?.getD fallback) := by
  rw [List.getElem?_eq_getElem bound]
  rfl

theorem found (i : Nat) (bound : i<1024) : (FftTableSources.pairs .square)[i]?=some (pair i) :=
  lookup (FftTableSources.pairs .square) i (0,0) (by rw [FftTableSources.pairs_length]; exact bound)

theorem real_found (i : Nat) (bound : i<1024) :
    (FftTableSources.words .square)[2*i]?=some (pair i).1 :=
  FftTableWord139.even .square i (pair i) (found i bound)

theorem imag_found (i : Nat) (bound : i<1024) :
    (FftTableSources.words .square)[2*i+1]?=some (pair i).2 :=
  FftTableWord139.odd .square i (pair i) (found i bound)

theorem real_load (heap : C99MemoryReference.Memory)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment heap)
    (i : Nat) (bound : i<1024) :
    C99MemoryReference.Load64 heap {FftGlobalMemory.pointer .square with index := 2*i} (pair i).1 :=
  FftTableWord139.loaded heap pinned .square (2*i) (pair i).1 (real_found i bound)

theorem imag_load (heap : C99MemoryReference.Memory)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment heap)
    (i : Nat) (bound : i<1024) :
    C99MemoryReference.Load64 heap {FftGlobalMemory.pointer .square with index := 2*i+1} (pair i).2 :=
  FftTableWord139.loaded heap pinned .square (2*i+1) (pair i).2 (imag_found i bound)

end FT1536.Source3.FftGroupTwiddle143
