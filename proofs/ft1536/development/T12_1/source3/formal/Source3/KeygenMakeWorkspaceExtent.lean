import Source3.CertificateWorkspace
import Source3.KeygenSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The workspace-extent source witness: the pinned `temp_size` reservation
   allocates exactly the certificate workspace extent (286720 bytes =35840
   fpr words) for the M0 inputs (logn=10, ternary=1), and no other candidate
   of the pinned function body exceeds it. The candidate mirror below
   transcribes the pinned `cur = ...` assignments line by line; each
   assignment is pinned against `Pinned.keygenLines`, and the transcription
   is additionally checked by the native Sage control against the reference
   C source. The kernel-checked claims are integer facts about the mirror;
   executing `temp_size` through the C machine is a separate, still-open
   composition obligation. No certificate outcome is a premise here. -/
namespace FT1536.Source3.KeygenMakeWorkspaceExtent

/-! ## 1. Pinned source shapes of the reservation -/

theorem cert_reservation_source : (Pinned.keygenLines.drop 4977).take 9=
    ["\t/* Reserve the mandatory FT1536 leaf-certificate workspace in the\n","\t * keygen context so key generation has no optional allocation gate. */\n","\tif (ternary && logn == 10) {\n","\t\tsize_t n, cur;\n","\n","\t\tn = MKN(logn, 1);\n","\t\tcur = (22 * n + 4 * (n / 3)) * sizeof(fpr);\n","\t\tgmax = cur > gmax ? cur : gmax;\n","\t}\n"] := by decide

theorem gmax_init : Pinned.keygenLines[4975]?=some "\tgmax = 0;\n" := by decide

theorem fg_loop_source : Pinned.keygenLines[4990]?=some "\tfor (depth = 0; depth < logn; depth ++) {\n" := by decide

theorem fg_depth0_source : Pinned.keygenLines[4993]?=some "\t\tif (depth == 0 && ternary) {\n" := by decide

theorem fg_depth0_candidate : Pinned.keygenLines[4999]?=some "\t\t\tcur = (2 * tn + 2 * n + 2 * dn) * sizeof(uint32_t);\n" := by decide

theorem fg_else_candidate_a : Pinned.keygenLines[5011]?=some "\t\t\tcur = (n * tlen + 2 * n * slen + 3 * n)\n" := by decide

theorem fg_else_candidate_b : Pinned.keygenLines[5014]?=some "\t\t\tcur = (n * tlen + 2 * n * slen + slen)\n" := by decide

theorem depth_loop_source : Pinned.keygenLines[5023]?=some "\tfor (depth = 0; depth <= logn; depth ++) {\n" := by decide

theorem depth_top_source : Pinned.keygenLines[5027]?=some "\t\tif (depth == logn) {\n" := by decide

theorem depth_top_candidate : Pinned.keygenLines[5033]?=some "\t\t\tcur = 8 * slen * sizeof(uint32_t);\n" := by decide

theorem depth_zero_source : Pinned.keygenLines[5035]?=some "\t\t} else if (ternary && depth == 0 && logn > 2) {\n" := by decide

theorem depth_zero_candidates : (Pinned.keygenLines.drop 5041).take 8=
    ["\t\t\tcur = ALIGN_FP(2 * tn * sizeof(uint32_t))\n","\t\t\t\t+ (2 * n + hn) * sizeof(fpr);\n","\t\t\tmax = cur > max ? cur : max;\n","\t\t\tcur = (hn + 4 * n) * sizeof(fpr);\n","\t\t\tmax = cur > max ? cur : max;\n","\t\t\tcur = ALIGN_FP(2 * n * sizeof(uint32_t))\n","\t\t\t\t+ 2 * n * sizeof(fpr);\n","\t\t\tmax = cur > max ? cur : max;\n"] := by decide

theorem binary_branch_source : Pinned.keygenLines[5052]?=some "\t\t\tn = (size_t)1 << logn;\n" := by decide

theorem final_else_dimension : Pinned.keygenLines[5097]?=some "\t\t\t\tn = (size_t)1 << (logn - depth);\n" := by decide

theorem final_else_tables : (Pinned.keygenLines.drop 5101).take 2=
    ["\t\t\t\tslen = MAX_BL_SMALL3[depth];\n","\t\t\t\tllen = MAX_BL_LARGE3[depth];\n"] := by decide

theorem final_else_candidate1 : (Pinned.keygenLines.drop 5107).take 2=
    ["\t\t\tcur = (2 * n * llen + 2 * n * slen + 4 * n)\n","\t\t\t\t* sizeof(uint32_t);\n"] := by decide

theorem final_else_candidate2 : (Pinned.keygenLines.drop 5110).take 2=
    ["\t\t\tcur = (2 * n * llen + 2 * n * slen + llen)\n","\t\t\t\t* sizeof(uint32_t);\n"] := by decide

theorem final_else_candidate3 : (Pinned.keygenLines.drop 5113).take 10=
    ["\t\t\ttmp1 = ALIGN_UW(\n","\t\t\t\tALIGN_FP((2 * n * llen + 2 * n * slen)\n","\t\t\t\t\t* sizeof(uint32_t))\n","\t\t\t\t+ (2 * n + hn) * sizeof(fpr))\n","\t\t\t\t+ n * sizeof(uint32_t);\n","\t\t\ttmp2 = ALIGN_FP((2 * n * llen + 2 * n * slen)\n","\t\t\t\t* sizeof(uint32_t))\n","\t\t\t\t+ (3 * n + hn) * sizeof(fpr);\n","\t\t\tcur = tmp1 > tmp2 ? tmp1 : tmp2;\n","\t\t\tcur = ALIGN_FP(cur) + n * sizeof(fpr);\n"] := by decide

theorem final_else_candidate4 : (Pinned.keygenLines.drop 5124).take 6=
    ["\t\t\tcur = ALIGN_UW(\n","\t\t\t\tALIGN_FP((2 * n * llen + 2 * n * slen)\n","\t\t\t\t\t* sizeof(uint32_t))\n","\t\t\t\t+ (2 * n + hn) * sizeof(fpr))\n","\t\t\t\t+ (5 * n + n * slen) * sizeof(uint32_t);\n","\t\t\tmax = cur > max ? cur : max;\n"] := by decide

theorem gmax_fold : Pinned.keygenLines[5132]?=some "\t\tgmax = max > gmax ? max : gmax;\n" := by decide

theorem gmax_return : Pinned.keygenLines[5135]?=some "\treturn gmax;\n" := by decide

theorem tmp_len_source : Pinned.keygenLines[5173]?=some "\tfk->tmp_len = temp_size(logn, ternary);\n" := by decide

theorem tmp_malloc_source : Pinned.keygenLines[5177]?=some "\tfk->tmp = malloc(fk->tmp_len);\n" := by decide

/-! ## 2. Candidate mirror at the M0 inputs (logn=10, ternary=1) -/

def small3 : List Nat := [1,1,2,3,6,12,22,42,82,166,335,700]
def large3 : List Nat := [2,3,5,9,16,32,62,123,245,490,1000]

/-- `ALIGN_FP(tt) = (((tt) + sizeof(fpr) - 1) / sizeof(fpr)) * sizeof(fpr)`. -/
def alignFP (t : Nat) : Nat := ((t+7)/8)*8
/-- `ALIGN_UW(tt) = (((tt) + sizeof(uint32_t) - 1) / sizeof(uint32_t)) * sizeof(uint32_t)`. -/
def alignUW (t : Nat) : Nat := ((t+3)/4)*4

/-- Degree of the M0 profile; `MKN(logn,1)=3<<(logn-1)=1536` for logn=10. -/
def degree : Nat := 1536
def half : Nat := 768

/-- The certificate reservation candidate `cur = (22*n + 4*(n/3)) * sizeof(fpr)`. -/
def certCandidate (n : Nat) : Nat := (22*n+4*(n/3))*8

/-- make_fg depth-0 ternary candidate `(2*tn + 2*n + 2*dn) * sizeof(uint32_t)`. -/
def fgDepth0Candidate : Nat := (2*512+2*degree+2*1024)*4

/-- make_fg general-depth candidates `(n*tlen + 2*n*slen + 3*n)` and
    `(n*tlen + 2*n*slen + slen)`, in32-bit words. -/
def fgCandidateA (depth : Nat) : Nat :=
  (2^(10-depth)*(small3.getD (depth+1) 0)+2*(2^(10-depth))*(small3.getD depth 0)
    +3*(2^(10-depth)))*4
def fgCandidateB (depth : Nat) : Nat :=
  (2^(10-depth)*(small3.getD (depth+1) 0)+2*(2^(10-depth))*(small3.getD depth 0)
    +(small3.getD depth 0))*4

/-- Per-depth loop, `depth == logn` branch: `8 * slen * sizeof(uint32_t)`. -/
def depthTopCandidate : Nat := 8*(small3.getD 10 0)*4

/-- Per-depth loop, ternary depth-0 branch (three candidates). -/
def depth0Candidate1 : Nat := alignFP (2*512*4)+(2*degree+half)*8
def depth0Candidate2 : Nat := (half+4*degree)*8
def depth0Candidate3 : Nat := alignFP (2*degree*4)+2*degree*8

/-- Per-depth loop, final else branch (four candidates). -/
def depthCandidate1 (depth : Nat) : Nat :=
  (2*(2^(10-depth))*(large3.getD depth 0)+2*(2^(10-depth))*(small3.getD depth 0)
    +4*(2^(10-depth)))*4
def depthCandidate2 (depth : Nat) : Nat :=
  (2*(2^(10-depth))*(large3.getD depth 0)+2*(2^(10-depth))*(small3.getD depth 0)
    +(large3.getD depth 0))*4
def depthCandidate3 (depth : Nat) : Nat :=
  let n := 2^(10-depth)
  let hn := n/2
  let slen := small3.getD depth 0
  let llen := large3.getD depth 0
  let tmp1 := alignUW (alignFP ((2*n*llen+2*n*slen)*4)+(2*n+hn)*8)+n*4
  let tmp2 := alignFP ((2*n*llen+2*n*slen)*4)+(3*n+hn)*8
  alignFP (max tmp1 tmp2)+n*8
def depthCandidate4 (depth : Nat) : Nat :=
  let n := 2^(10-depth)
  let hn := n/2
  let slen := small3.getD depth 0
  let llen := large3.getD depth 0
  alignUW (alignFP ((2*n*llen+2*n*slen)*4)+(2*n+hn)*8)+(5*n+n*slen)*4

/-- Every candidate of the pinned body at (logn=10, ternary=1), in source
    order: the certificate reservation, the make_fg loop (depth0 ternary
    branch plus the two general-depth candidates at depths 1..9), and the
    per-depth loop (the `depth == logn` branch, the ternary depth-0 branch
    and the four final-else candidates at depths 1..9). The `!ternary`
    branches (`binary_branch_source`) are excluded by ternary=1. -/
def candidates : List Nat :=
  [certCandidate degree,fgDepth0Candidate] ++
  (List.range 9).flatMap (fun d => [fgCandidateA (d+1),fgCandidateB (d+1)]) ++
  [depthTopCandidate,depth0Candidate1,depth0Candidate2,depth0Candidate3] ++
  (List.range 9).flatMap (fun d =>
    [depthCandidate1 (d+1),depthCandidate2 (d+1),depthCandidate3 (d+1),depthCandidate4 (d+1)])

theorem candidates_length : candidates.length=60 := by decide +kernel

theorem certificate_candidate_member : certCandidate degree∈candidates := by decide +kernel

/-- No candidate of the pinned body exceeds the certificate reservation. -/
theorem candidates_bound : ∀ c∈candidates, c≤certCandidate degree := by decide +kernel

/-- The mirrored reservation maximum is exactly the certificate workspace
    candidate: `temp_size(10,1)` reserves exactly the workspace extent. -/
theorem candidates_fold_max : candidates.foldl max 0=certCandidate degree := by decide +kernel

/-! ## 3. Equality with the certificate workspace extent -/

theorem cert_candidate_value : certCandidate degree=286720 := by decide

theorem cert_candidate_workspace : certCandidate degree=CertificateWorkspace.bytes := by decide

theorem workspace_extent_value : CertificateWorkspace.bytes=286720 :=
  CertificateWorkspace.workspace_size

/-- The reservation covers the certificate workspace extent and no candidate
    exceeds it: the `fk->tmp` extent of the M0 allocation is exactly the
    workspace extent the fpr cast spans. -/
theorem reservation_matches_workspace :
    candidates.foldl max 0=CertificateWorkspace.bytes := by
  rw [← cert_candidate_workspace]
  exact candidates_fold_max

end FT1536.Source3.KeygenMakeWorkspaceExtent
