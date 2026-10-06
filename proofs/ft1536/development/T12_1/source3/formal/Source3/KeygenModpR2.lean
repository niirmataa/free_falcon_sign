import Source3.KeygenModpR2Exec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- B1.03 stage (b): source modp_R2 returns the canonical R^2 residue.
   The general contract uses only the actual arithmetic domain; the M0
   specialization obtains p0i from the executed modp_ninv31 initializer.
   These scalar contracts are the inputs for the next window's row laws. -/
namespace FT1536.Source3.KeygenModpR2
open C99IntegerReference (Value)
open C99ModularReference (GenExec LeafCall ModCall)

def Contract (p out : BitVec 32) : Prop :=
  out.toNat<p.toNat ∧ out.toNat=2^62%p.toNat ∧
    KeygenModpR2Word.value p out=KeygenModpR2Word.radix p*KeygenModpR2Word.radix p

theorem source_contract (p p0i : BitVec 32) (v : Value)
    (lower : 2^30<p.toNat) (upper : p.toNat<2^31) (odd : p.toNat%2=1)
    (inverse : 2^31∣p.toNat*p0i.toNat+1) (source : KeygenModpR2Exec.SourceExec p p0i v) :
    ∃ out : BitVec 32, v=.uint32 out ∧ Contract p out := by
  obtain ⟨range,scaled⟩ := KeygenModpR2Word.word_contract p p0i lower upper odd inverse
  exact ⟨KeygenModpR2Word.word p p0i,KeygenModpR2Exec.source_exact p p0i v source,
    range,KeygenModpR2Word.value_law p p0i lower upper odd inverse,scaled⟩

theorem parsed_contract (code : C99ModularReference.Stmt) (base after : C99ArrayReference.State)
    (p p0i : BitVec 32) (v : Value)
    (binding : C99ModularParser.region 2575 24=some code)
    (lower : 2^30<p.toNat) (upper : p.toNat<2^31) (odd : p.toNat%2=1)
    (inverse : 2^31∣p.toNat*p0i.toNat+1)
    (source : GenExec LeafCall code (KeygenModpR2Exec.entry base p p0i)
      ⟨after,.returned (some v)⟩) : ∃ out : BitVec 32, v=.uint32 out ∧ Contract p out := by
  have he : code=C99ModularReference.r2Code :=
    Option.some.inj (binding.symm.trans KeygenMkgm3Callees.r2_source_bound)
  subst code
  exact source_contract p p0i v lower upper odd inverse ⟨base,after,source⟩

theorem call_contract (p p0i : BitVec 32) (v : Value)
    (lower : 2^30<p.toNat) (upper : p.toNat<2^31) (odd : p.toNat%2=1)
    (inverse : 2^31∣p.toNat*p0i.toNat+1)
    (source : ModCall "modp_R2".toList [.uint32 p,.uint32 p0i] v) :
    ∃ out : BitVec 32, v=.uint32 out ∧ Contract p out := by
  cases source with
  | r2 _ _ body => exact source_contract p p0i v lower upper odd inverse body

theorem initialized_value_law (p0i out : BitVec 32)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : ModCall "modp_R2".toList [.uint32 KeygenNinv31.prime,.uint32 p0i] (.uint32 out)) :
    out.toNat<KeygenNinv31.prime.toNat ∧ out.toNat=2^62%KeygenNinv31.prime.toNat ∧
      KeygenNttWordAlgebra.value out=KeygenNttWordAlgebra.radix*KeygenNttWordAlgebra.radix := by
  have hi : p0i=KeygenNinv31.word KeygenNinv31.prime :=
    Value.uint32.inj (KeygenNinv31.source_exact _ _ initialization)
  subst p0i
  obtain ⟨w,hw,range,exactValue,scaled⟩ := call_contract KeygenNinv31.prime _ (.uint32 out)
    (by decide) (by decide) (by decide) KeygenNinv31.inverse_identity source
  have he : out=w := Value.uint32.inj hw
  subst w
  exact ⟨range,exactValue,scaled⟩

theorem initialized_to_montgomery (a r2 p0i out : BitVec 32)
    (ha : a.toNat<KeygenNinv31.prime.toNat)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (r2Call : ModCall "modp_R2".toList [.uint32 KeygenNinv31.prime,.uint32 p0i] (.uint32 r2))
    (multiplication : KeygenModpWord.SourceExec a r2 KeygenNinv31.prime p0i (.uint32 out)) :
    out.toNat<KeygenNinv31.prime.toNat ∧
      KeygenNttWordAlgebra.value out=KeygenNttWordAlgebra.radix*KeygenNttWordAlgebra.value a := by
  obtain ⟨range,_,scaled⟩ := initialized_value_law p0i r2 initialization r2Call
  obtain ⟨outRange,he⟩ := KeygenNttWordAlgebra.source_twiddle a r2 p0i out
    KeygenNttWordAlgebra.radix ha range initialization scaled multiplication
  exact ⟨outRange,he.trans (mul_comm _ _)⟩

theorem call_exists (base : C99ArrayReference.State) (p p0i : BitVec 32) :
    ModCall "modp_R2".toList [.uint32 p,.uint32 p0i] (.uint32 (KeygenModpR2Word.word p p0i)) :=
  .r2 _ _ (KeygenModpR2Exec.source_exists base p p0i)

end FT1536.Source3.KeygenModpR2
