import Source3.C99ModularAnnotation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source bindings for the composite modular callees of modp_mkgm3 (B1.03).
   The hand-built statements C99ModularReference.r2Code / divCode are checked
   here against the pinned source parse; these equalities are their source
   binding. No value law for modp_div is claimed here: its exact quotient
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

theorem div_source_bound :
    C99ModularParser.region 2642 26=some C99ModularReference.divCode := by decide

end FT1536.Source3.KeygenMkgm3Callees
