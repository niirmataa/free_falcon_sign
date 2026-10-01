import Source3.KeygenFinalCheckAlgebra
import Source3.C99MemoryReference
import Source3.KeygenSmallOutput

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenFinalCheck
open C99MemoryReference
open KeygenSmallOutput (element)

structure Arrays where
  f : ArrayPointer
  g : ArrayPointer
  bigF : ArrayPointer
  bigG : ArrayPointer

theorem source_loop : (Pinned.keygenLines.drop 7385).take 11 =
    ["\tfor (u = 0; u < n; u ++) {\n","\t\tuint32_t z;\n","\n",
     "\t\tz = modp_sub(modp_montymul(ft[u], Gt[u], p, p0i),\n",
     "\t\t\tmodp_montymul(gt[u], Ft[u], p, p0i), p);\n",
     "\t\tif (z != r) {\n","\t\t\treturn 0;\n","\t\t}\n","\t}\n","\n","\treturn 1;\n"] := by decide

inductive Step (arrays : Arrays) (heap : Memory) (p0i : BitVec 32) (i : Nat) : BitVec 32 → Prop where
  | evaluated (a b bigF bigG left right out : BitVec 32)
      (readF : Load32 heap (element arrays.f i) a)
      (readG : Load32 heap (element arrays.g i) b)
      (readBigF : Load32 heap (element arrays.bigF i) bigF)
      (readBigG : Load32 heap (element arrays.bigG i) bigG)
      (leftCall : KeygenModpWord.SourceExec a bigG KeygenNinv31.prime p0i (.uint32 left))
      (rightCall : KeygenModpWord.SourceExec b bigF KeygenNinv31.prime p0i (.uint32 right))
      (subCall : KeygenModpAddSub.SourceExec .sub left right KeygenNinv31.prime (.uint32 out)) :
      Step arrays heap p0i i out

inductive Loop (arrays : Arrays) (heap : Memory) (p0i target : BitVec 32) : Nat → Bool → Prop where
  | done (i : Nat) (guard : ¬i<1536) : Loop arrays heap p0i target i true
  | rejected (i : Nat) (out : BitVec 32) (guard : i<1536)
      (step : Step arrays heap p0i i out) (different : out≠target) : Loop arrays heap p0i target i false
  | next (i : Nat) (out : BitVec 32) (ret : Bool) (guard : i<1536)
      (step : Step arrays heap p0i i out) (equal : out=target)
      (rest : Loop arrays heap p0i target (i+1) ret) : Loop arrays heap p0i target i ret

def Canonical (arrays : Arrays) (heap : Memory) : Prop :=
  ∀ i<1536, ∀ p∈[arrays.f,arrays.g,arrays.bigF,arrays.bigG], ∀ word,
    Load32 heap (element p i) word → word.toNat<KeygenNinv31.prime.toNat

theorem accepted_step (arrays : Arrays) (heap : Memory) (p0i target out : BitVec 32) (i : Nat)
    (hi : i<1536) (canonical : Canonical arrays heap)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (targetCall : KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 target))
    (source : Step arrays heap p0i i out) (comparison : out=target) :
    ∃ a b bigF bigG,
      Load32 heap (element arrays.f i) a ∧ Load32 heap (element arrays.g i) b ∧
      Load32 heap (element arrays.bigF i) bigF ∧ Load32 heap (element arrays.bigG i) bigG ∧
      (a.toNat*bigG.toNat)%KeygenNinv31.prime.toNat=(18433+b.toNat*bigF.toNat)%KeygenNinv31.prime.toNat := by
  cases source with
  | evaluated a b bigF bigG left right out readF readG readBigF readBigG leftCall rightCall subCall =>
      refine ⟨a,b,bigF,bigG,readF,readG,readBigF,readBigG,?_⟩
      exact KeygenFinalCheckAlgebra.initialized_coordinate a b bigF bigG p0i left right target out
        (canonical i hi arrays.f (by simp) a readF)
        (canonical i hi arrays.g (by simp) b readG)
        (canonical i hi arrays.bigF (by simp) bigF readBigF)
        (canonical i hi arrays.bigG (by simp) bigG readBigG)
        initialization leftCall rightCall targetCall subCall comparison

theorem accepted_coordinates (arrays : Arrays) (heap : Memory) (p0i target : BitVec 32) (i : Nat)
    (canonical : Canonical arrays heap)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (targetCall : KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 target))
    (source : Loop arrays heap p0i target i true) :
    ∀ j, i≤j → j<1536 → ∃ a b bigF bigG,
      Load32 heap (element arrays.f j) a ∧ Load32 heap (element arrays.g j) b ∧
      Load32 heap (element arrays.bigF j) bigF ∧ Load32 heap (element arrays.bigG j) bigG ∧
      (a.toNat*bigG.toNat)%KeygenNinv31.prime.toNat=(18433+b.toNat*bigF.toNat)%KeygenNinv31.prime.toNat := by
  generalize hr : true=ret at source
  induction source with
  | done i guard => intro j hj hn; omega
  | rejected => cases hr
  | next i out ret guard step equal rest ih =>
      intro j hj hn
      by_cases he : j=i
      · subst j
        exact accepted_step arrays heap p0i target out i guard canonical initialization targetCall step equal
      · exact ih hr j (by omega) hn

end FT1536.Source3.KeygenFinalCheck
