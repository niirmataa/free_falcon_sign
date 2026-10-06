import Source3.C99ModularAnnotation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source bindings for the composite modular callees of modp_mkgm3 (B1.03).
   The hand-built statement C99ModularReference.r2Code is checked here
   against the pinned source parse; that equality is its source binding.
   C99ModularReference.divCode is a CANDIDATE body tree only: its former
   binding `div_source_bound : C99ModularParser.region 2642 26 = some
   divCode` was DISPROVEN by kernel `decide` (retained failure log:
   .build/jobs/keygen_mkgm3_frontend_011/logs/Source3_KeygenMkgm3Callees.
   stdout) and has been removed from the tree. The candidate is recorded
   as an open obligation in the batch receipt (BATCH_014), not claimed as
   a theorem; the corrected parser<->divCode binding is pending (exactly
   one statement of the tree differs; candidates listed in BATCH_013.json).
   No value law for modp_div is claimed here either: its exact quotient
   law needs the modulus primality and is not required for the gm words,
   whose only division use feeds the temporary igm table that the checked
   coefficient-conversion loop overwrites. -/
namespace FT1536.Source3.KeygenMkgm3Callees

theorem r2_header :
    Pinned.keygenLines[2572]?=some "modp_R2(uint32_t p, uint32_t p0i)\n" := by decide

theorem r2_source_bound :
    C99ModularParser.region 2575 24=some C99ModularReference.r2Code := by decide

theorem div_header :
    Pinned.keygenLines[2639]?=
      some "modp_div(uint32_t a, uint32_t b, uint32_t p, uint32_t p0i, uint32_t R)\n" := by
  decide

end FT1536.Source3.KeygenMkgm3Callees
