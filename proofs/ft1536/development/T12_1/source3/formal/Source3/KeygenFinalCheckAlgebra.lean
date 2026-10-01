import Source3.KeygenModpAddSub
import Source3.KeygenNinv31

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenFinalCheckAlgebra

/- The final scalar comparison, after the four source transforms. Its
   inputs are transform words, not yet polynomial evaluations. The NTT
   refinement and material preservation must discharge that separate link. -/
theorem accepted_coordinate (a b bigF bigG p p0i left right target out : BitVec 32)
    (hp : 18433<p.toNat) (hpr : p.toNat<2^31)
    (ha : a.toNat<p.toNat) (hb : b.toNat<p.toNat)
    (hF : bigF.toNat<p.toNat) (hG : bigG.toNat<p.toNat)
    (inverse : 2^31∣p.toNat*p0i.toNat+1)
    (leftSource : KeygenModpWord.SourceExec a bigG p p0i (.uint32 left))
    (rightSource : KeygenModpWord.SourceExec b bigF p p0i (.uint32 right))
    (targetSource : KeygenModpWord.SourceExec 18433 1 p p0i (.uint32 target))
    (subSource : KeygenModpAddSub.SourceExec .sub left right p (.uint32 out))
    (comparison : out=target) :
    (a.toNat*bigG.toNat)%p.toNat=(18433+b.toNat*bigF.toNat)%p.toNat := by
  obtain ⟨wl,hel,hl,hml⟩ := KeygenMontgomery.source_reduction_contract a bigG p p0i (.uint32 left)
    (by omega) hpr ha hG inverse leftSource
  obtain ⟨wr,her,hr,hmr⟩ := KeygenMontgomery.source_reduction_contract b bigF p p0i (.uint32 right)
    (by omega) hpr hb hF inverse rightSource
  obtain ⟨wt,het,_,hmt⟩ := KeygenMontgomery.source_reduction_contract 18433 1 p p0i (.uint32 target)
    (by omega) hpr hp (by change 1<p.toNat; omega) inverse targetSource
  have hleft : left=wl := C99IntegerReference.Value.uint32.inj hel
  have hright : right=wr := C99IntegerReference.Value.uint32.inj her
  have htarget : target=wt := C99IntegerReference.Value.uint32.inj het
  subst wl
  subst wr
  subst wt
  have hout : out=KeygenModpAddSub.result .sub left right p :=
    C99IntegerReference.Value.uint32.inj (KeygenModpAddSub.source_exact .sub left right p (.uint32 out) subSource)
  have hs := KeygenModpAddSub.sub_congruence left right p hpr hl hr
  rw [← hout,comparison] at hs
  have multiply : ((target.toNat+right.toNat)*2^31)%p.toNat=(left.toNat*2^31)%p.toNat := by
    change Nat.ModEq p.toNat (target.toNat+right.toNat) left.toNat at hs
    exact hs.mul_right (2^31)
  change (target.toNat*2^31)%p.toNat=18433%p.toNat at hmt
  rw [Nat.add_mul,Nat.add_mod,hmt,hmr,hml] at multiply
  exact multiply.symm.trans (Nat.add_mod 18433 (b.toNat*bigF.toNat) p.toNat).symm

theorem initialized_coordinate (a b bigF bigG p0i left right target out : BitVec 32)
    (ha : a.toNat<KeygenNinv31.prime.toNat) (hb : b.toNat<KeygenNinv31.prime.toNat)
    (hF : bigF.toNat<KeygenNinv31.prime.toNat) (hG : bigG.toNat<KeygenNinv31.prime.toNat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (leftSource : KeygenModpWord.SourceExec a bigG KeygenNinv31.prime p0i (.uint32 left))
    (rightSource : KeygenModpWord.SourceExec b bigF KeygenNinv31.prime p0i (.uint32 right))
    (targetSource : KeygenModpWord.SourceExec 18433 1 KeygenNinv31.prime p0i (.uint32 target))
    (subSource : KeygenModpAddSub.SourceExec .sub left right KeygenNinv31.prime (.uint32 out))
    (comparison : out=target) :
    (a.toNat*bigG.toNat)%KeygenNinv31.prime.toNat=(18433+b.toNat*bigF.toNat)%KeygenNinv31.prime.toNat := by
  have he : p0i=KeygenNinv31.word KeygenNinv31.prime :=
    C99IntegerReference.Value.uint32.inj (KeygenNinv31.source_exact _ _ initialization)
  subst p0i
  exact accepted_coordinate a b bigF bigG KeygenNinv31.prime _ left right target out
    (by decide) (by decide) ha hb hF hG KeygenNinv31.inverse_identity leftSource rightSource targetSource subSource comparison

end FT1536.Source3.KeygenFinalCheckAlgebra
