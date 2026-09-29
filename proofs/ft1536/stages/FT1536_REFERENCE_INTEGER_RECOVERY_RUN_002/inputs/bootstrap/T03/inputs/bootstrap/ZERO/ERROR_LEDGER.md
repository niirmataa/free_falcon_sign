# H3_ZERO_SCALAR — ledger lokalnych błędów i konsumpcji



A/OF mają dowody kernelowe na source-normalized modelach. B ma uniwersalny dowód analityczny po instrukcjach C, wsparty kernelowymi lematami bitowymi; nie udaje pełnego kernelowego fpr_add.

E_r=E_res=1/1048576. NumericCenter zawiera oba zera i subnormals.



## FLOOR_ZERO — PROVED_KERNEL_WITH_C_TRANSLATION

NumericCenter implies exponent<=1053 and source floor=floor(val)-eps0, including -0.

**Domena:** All local finite64-bit words in NumericCenter; no NotNegZero premise.

**Dalsza konsumpcja:** Brak dodatkowej otwartej przesłanki tej lokalnej tezy.

**Dowody:** formal/ValueDomain.lean, formal/SourceFloor.lean, scripts/fp_literal.py



## C_INT_BRIDGE — PROVED_KERNEL_WITH_C_TRANSLATION

long->int exact and s_C+z within int32 for all z in[-365,366].

**Domena:** NumericCenter; successful nonfault proposal return, not sticky0.

**Dalsza konsumpcja:** Brak dodatkowej otwartej przesłanki tej lokalnej tezy.

**Dowody:** formal/SourceFloor.lean, inputs/bootstrap/H3/formal/Proposal.lean



## OF_EXACT — PROVED_KERNEL_WITH_C_TRANSLATION

Source-normalized fpr_of on signed32 returns exact integer value; zero is +0.

**Domena:** All i in[-2^31,2^31-1].

**Dalsza konsumpcja:** Brak dodatkowej otwartej przesłanki tej lokalnej tezy.

**Dowody:** formal/BitErrors.lean, formal/PackOf.lean, ANALYTIC_PROOF.md



## SUB_CENTER — PROVED_UNIVERSAL_ANALYTIC_WITH_KERNEL_INTEGER_LEMMAS

r_C finite; |val(r_C)-(val(x)-s_C)|<=1/1048576.

**Domena:** Every NumericCenter word, including zeros/subnormals/underflow.

**Dalsza konsumpcja:** Full source-add theorem is not kernelized: kernel consumers explicitly take this analytically proved source contract. No error bound is left unknown in the analytical theorem.

**Dowody:** ANALYTIC_PROOF.md, formal/BitErrors.lean, formal/LiteralAdd.lean, artifacts/error_certificate.json



## SUB_RESIDUAL — PROVED_UNIVERSAL_ANALYTIC_WITH_KERNEL_INTEGER_LEMMAS

res_C finite; absolute error versus val(x)-(s_C+z)<=1/1048576.

**Domena:** Every NumericCenter and all z in[-365,366].

**Dalsza konsumpcja:** Same proof-layer distinction as SUB_CENTER; this is not an all-backend IEEE theorem.

**Dowody:** ANALYTIC_PROOF.md, formal/ErrorArithmetic.lean, formal/LiteralAdd.lean, artifacts/error_certificate.json



## R_DELTA_DOMAIN — PROVED_SOURCE_CASE_ANALYSIS_WITH_KERNEL_ENDPOINTS

r_C and sub_C(1,r_C) are +0 or positive normal, values in[0,1]; endpoint1 not exclusive to -0.

**Domena:** All NumericCenter; no extra normality/zero assumption.

**Dalsza konsumpcja:** Brak dodatkowej otwartej przesłanki tej lokalnej tezy.

**Dowody:** ANALYTIC_PROOF.md, formal/EndpointFacts.lean, formal/LiteralAdd.lean, artifacts/controls_normal.json



## ORDERED_CONSUMPTION — PROVED_MIXED_KERNEL_ANALYTIC

rho in closed[0,1], exact residual<=366, machine residual<=366+2^-20; ordered zero-aware terminal bridge.

**Domena:** First NumericCenter, then returned residual, then next center. E_half/E_add explicit.

**Dalsza konsumpcja:** Resolve E_half/E_add and the next-center premise on appropriate global paths; do not apply closeness to sticky/fault0.

**Dowody:** formal/ZeroRho.lean, formal/ErrorArithmetic.lean, ANALYTIC_PROOF.md



## GLOBAL_REACHABILITY_OPEN — OPEN_NOT_THIS_LOCAL_THEOREM

Emitted-KeyGen/M0 Reach_call_C -> NumericCenter remains unproved; old CenterClass/floor-equality theorem unchanged.

**Domena:** All emitted keys and actual histories, including pre-dss/norm-rejected attempts.

**Dalsza konsumpcja:** Uniform emitted/loader/internal LDL/ordered bounds and actual backend error/domain transfer.

**Dowody:** M0_COMPATIBILITY.md, inputs/bootstrap/M0/H3_INTERFACE.md, inputs/bootstrap/H3/REACHABILITY.md



## SAMPLER_LAW_CONSUMPTION_OPEN — OPEN_NOT_A_RANGE_COROLLARY

Zero-aware scalar-law comparison must account for endpoints, errors and changed shifted finite support.

**Domena:** For -0 y in[-366,365], for +0 y in[-365,366].

**Dalsza konsumpcja:** No automatic H3 arithmetic/H1R/FFO/R5T/M7 closure, no new small global loss or abort assigned.

**Dowody:** M0_COMPATIBILITY.md, formal/EndpointFacts.lean
