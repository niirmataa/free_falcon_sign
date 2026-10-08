import Source3.KeygenPrimeTablesBinary
import Source3.KeygenPrimeTablesTernaryLow
import Source3.KeygenPrimeTablesTernaryHigh

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenPrimeTableBinding
open KeygenStaticTables

theorem all_chunks (table : PrimeTable) (index : Nat) (bound : index<chunks table) : Checked table index := by
  cases table with
  | binary => exact KeygenPrimeTablesBinary.all_chunks ⟨index,bound⟩
  | ternary =>
    by_cases low : index<35
    · exact KeygenPrimeTablesTernaryLow.all_chunks ⟨index,low⟩
    · have hi : index-35<34 := by change index<69 at bound; omega
      have he : index-35+35=index := by omega
      have h := KeygenPrimeTablesTernaryHigh.all_chunks ⟨index-35,hi⟩
      simpa only [he] using h
theorem source_values (table : PrimeTable) : parsed table=some (values table) := values_bound all_chunks table
theorem source_length (table : PrimeTable) : (values table).length=rowCount table := values_length all_chunks table
theorem every_source_row (table : PrimeTable) (line : String) (member : line∈rows table) :
    ∃ value, row line=some value := row_defined all_chunks table line member

end FT1536.Source3.KeygenPrimeTableBinding
