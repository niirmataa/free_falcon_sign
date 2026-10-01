import Source3.FftTableSquareChecks
import Source3.FftTableCubicLowChecks
import Source3.FftTableCubicHighChecks
import Source3.ParsedChunks

namespace FT1536.Source3.FftTableSources
open FftTableParser

theorem all_chunks (table : Table) (index : Nat) (bound : index<chunkCount table) : CheckedChunk table index := by
  cases table with
  | square => exact FftTableSquareChecks.all_chunks ⟨index,bound⟩
  | cubic =>
      by_cases low : index<32
      · exact FftTableCubicLowChecks.all_chunks ⟨index,low⟩
      · have hi : index-32<32 := by change index<64 at bound; omega
        have he : index-32+32=index := by omega
        have h := FftTableCubicHighChecks.all_chunks ⟨index-32,hi⟩
        simpa only [he] using h

theorem rows_partition (table : Table) : rows table=(List.range (chunkCount table)).flatMap (chunk table) := by
  have hn : chunkCount table*32=rowCount table := by cases table <;> decide
  have h := ParsedChunks.take_chunks (rows table) 32 (chunkCount table)
  rw [hn,← rows_length table,List.take_length] at h
  have he : (fun i => ((rows table).drop (i*32)).take 32)=chunk table := by
    funext i
    unfold chunk
    rw [Nat.mul_comm]
  rw [he] at h
  exact h

theorem row_defined (table : Table) (line : String) (member : line∈rows table) : ∃ values, pair line=some values := by
  rw [rows_partition] at member
  obtain ⟨index,hi,member⟩ := List.mem_flatMap.mp member
  have bound : index<chunkCount table := List.mem_range.mp hi
  obtain ⟨values,parsed,_⟩ := checked_defined table index (all_chunks table index bound)
  exact (ParsedChunks.mapM_defined pair (chunk table index)).mp ⟨values,parsed⟩ line member

def parsedPairs (table : Table) : Option (List (BitVec 64×BitVec 64)) := (rows table).mapM pair
def pairs (table : Table) : List (BitVec 64×BitVec 64) := (parsedPairs table).getD []
def words (table : Table) : List (BitVec 64) := (pairs table).flatMap (fun pair => [pair.1,pair.2])

theorem pairs_bound (table : Table) : parsedPairs table=some (pairs table) := by
  obtain ⟨values,hv⟩ := (ParsedChunks.mapM_defined pair (rows table)).mpr (row_defined table)
  change parsedPairs table=some values at hv
  simp only [pairs,hv,Option.getD_some]

theorem pairs_length (table : Table) : (pairs table).length=rowCount table :=
  (ParsedChunks.mapM_length pair (rows table) (pairs table) (pairs_bound table)).trans (rows_length table)

theorem words_length (table : Table) : (words table).length=2*rowCount table := by
  have generic : ∀ xs : List (BitVec 64×BitVec 64), (xs.flatMap (fun pair => [pair.1,pair.2])).length=2*xs.length := by
    intro xs
    induction xs with
    | nil => rfl
    | cons head rest ih => simp only [List.flatMap_cons,List.length_append,List.length_cons,List.length_nil,ih]; omega
  rw [words,generic,pairs_length]

end FT1536.Source3.FftTableSources
