import Source3.FftTableList139
import Source3.FftTableSources
import Source3.FftGlobalMemory
import Source3.CertificateM0Environment

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTableWord139
open FftTableList139

theorem pair_from_row (table : FftTableParser.Table) (i : Nat) (row : String)
    (values : BitVec 64 × BitVec 64) (found : (FftTableParser.rows table)[i]?=some row)
    (parsed : FftTableParser.pair row=some values) : (FftTableSources.pairs table)[i]?=some values := by
  have same := mapM_index FftTableParser.pair (FftTableParser.rows table)
    (FftTableSources.pairs table) (FftTableSources.pairs_bound table) i
  apply same.symm.trans
  rw [found]
  exact parsed

theorem even (table : FftTableParser.Table) (i : Nat) (values : BitVec 64 × BitVec 64)
    (found : (FftTableSources.pairs table)[i]?=some values) :
    (FftTableSources.words table)[2*i]?=some values.1 :=
  (flatten_even (FftTableSources.pairs table) i).trans (congrArg (Option.map Prod.fst) found)

theorem odd (table : FftTableParser.Table) (i : Nat) (values : BitVec 64 × BitVec 64)
    (found : (FftTableSources.pairs table)[i]?=some values) :
    (FftTableSources.words table)[2*i+1]?=some values.2 :=
  (flatten_odd (FftTableSources.pairs table) i).trans (congrArg (Option.map Prod.snd) found)

def rowTwo := "\tFPC(0x3febb67ae8584cabULL, 0x3fdfffffffffffffULL),\n"
theorem row_two : (FftTableParser.rows .square)[2]?=some rowTwo := by decide +kernel
theorem parsed_two : FftTableParser.pair rowTwo=some (0x3febb67ae8584cab,0x3fdfffffffffffff) := by decide +kernel

theorem square_pair_two : (FftTableSources.pairs .square)[2]?=
    some (0x3febb67ae8584cab,0x3fdfffffffffffff) :=
  pair_from_row .square 2 rowTwo (0x3febb67ae8584cab,0x3fdfffffffffffff) row_two parsed_two

theorem square_four : (FftTableSources.words .square)[4]?=some 0x3febb67ae8584cab :=
  even .square 2 (0x3febb67ae8584cab,0x3fdfffffffffffff) square_pair_two

theorem square_five : (FftTableSources.words .square)[5]?=some 0x3fdfffffffffffff :=
  odd .square 2 (0x3febb67ae8584cab,0x3fdfffffffffffff) square_pair_two

theorem loaded (heap : C99MemoryReference.Memory)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment heap)
    (table : FftTableParser.Table) (i : Nat) (word : BitVec 64)
    (found : (FftTableSources.words table)[i]?=some word) :
    C99MemoryReference.Load64 heap {FftGlobalMemory.pointer table with index := i} word := by
  obtain ⟨bound,same⟩ := List.getElem?_eq_some_iff.mp found
  rw [← same]
  exact (pinned.2 table i bound).1

end FT1536.Source3.FftTableWord139
