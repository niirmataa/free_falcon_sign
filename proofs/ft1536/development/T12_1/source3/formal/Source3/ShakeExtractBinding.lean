import Source3.ShakeExtractSource
import Source3.ShakeRcBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.ShakeExtractBinding
open ShakeExtractSource

theorem source_bound : parsed=some code := by decide
theorem rc_partition : ((List.range 12).map (fun i => (rc.drop (2*i)).take 2)).flatten=rc := rfl
theorem rc_scaffold : ShakeSource.sourceLines[38]?=some "static const uint64_t RC[] = {\n" ∧
    ShakeSource.sourceLines[51]?=some "};\n" ∧
    (List.range 11).all (fun i => ((ShakeSource.sourceLines[39+i]?).map
      (fun line => line.toList.reverse.take 2))=some ['\n',','])=true := by decide

end FT1536.Source3.ShakeExtractBinding
