import Source3.CertificateAtoms

namespace FT1536.Source3.CertificateIndex
open B20.C C99ValueBridge

def locals (u : Nat) : B20.C.Scalar.State :=
  ⟨fun n => if n=['n'] ∨ n=['u'] ∨ n=['h','n'] then some .u64 else none,
   fun n => if n=['n'] then some (.u64 1536) else if n=['u'] then some (.u64 (BitVec.ofNat 64 u))
     else if n=['h','n'] then some (.u64 768) else none⟩
def expression := CertificateSuffixSyntax.expected.reverse.destination
def IndexEval (u dst : Nat) : Prop := ∃ word : BitVec 64,
  C99ScalarReference.Eval C99Frontend.noCalls (C99Typing.environment (locals u))
    (C99Frontend.expression expression) (.uint64 word) ∧ dst=word.toNat

theorem locals_good (u : Nat) : C99Typing.WellTyped (locals u) := by
  intro n v hv
  by_cases hn : n=['n'] <;> by_cases hu : n=['u'] <;> by_cases hh : n=['h','n'] <;>
    simp_all [locals,Val.ty]
  all_goals rw [← hv]

theorem model_index (u : Nat) (hu : u<768) :
    ExpressionFuel.unbounded (fun _ _ => none) (locals u).values expression=some (.u64 (BitVec.ofNat 64 (1535-u))) := by
  have he : (1535 : BitVec 64)-BitVec.ofNat 64 u=BitVec.ofNat 64 (1535-u) := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_sub,BitVec.toNat_ofNat]
    rw [show (1535 : BitVec 64).toNat=1535 from rfl]
    omega
  simpa [ExpressionFuel.unbounded,expression,CertificateSuffixSyntax.expected,locals,
    literalValue,B20.C.bin,commonTy,Val.ty,B20.C.cast,bitsOp] using congrArg (fun w => some (Val.u64 w)) he

theorem index_exists (u : Nat) (hu : u<768) : IndexEval u (1535-u) := by
  refine ⟨BitVec.ofNat 64 (1535-u),?_,?_⟩
  · exact C99ExpressionSound.expression_sound _ _ C99HeaderSound.no_calls_sound (locals u)
      (locals_good u) expression (.u64 (BitVec.ofNat 64 (1535-u))) (model_index u hu)
  · simp only [BitVec.toNat_ofNat]
    omega

theorem index_exact (u dst : Nat) (hu : u<768) (h : IndexEval u dst) : dst=1535-u := by
  obtain ⟨w,he,hd⟩:=h
  have ht : C99Typing.infer C99HeaderProof.noSignature (locals u).types expression=some .u64 := by rfl
  have hm:=(C99ExpressionBridge.expression_complete C99HeaderProof.noSignature _ _ C99HeaderProof.no_calls_ok
    (locals u) (locals_good u) expression .u64 (.uint64 w) ht he).1
  have hw : w=BitVec.ofNat 64 (1535-u) := Val.u64.inj (Option.some.inj (hm.symm.trans (model_index u hu)))
  rw [hd,hw]
  simp only [BitVec.toNat_ofNat]
  omega

theorem bounds (u : Nat) (hu : u<768) : 768≤1535-u ∧ 1535-u<1536 ∧ u+1<2^64 := by omega
theorem injective (u v : Nat) (hu : u<768) (hv : v<768) (h : 1535-u=1535-v) : u=v := by omega
theorem covers (i : Nat) (hi : 768 ≤ i ∧ i<1536) : ∃ u<768, 1535-u=i := ⟨1535-i,by omega,by omega⟩
theorem guard (u : Nat) (hu : u≤768) :
    C99IntegerReference.CompareExec .lt (C99HelperControl.sizeValue u) (C99HelperControl.sizeValue 768)
      (C99ScalarReference.boolean (decide (u<768))) := C99HelperControl.guard_exact _ _ (by omega) (by decide)

end FT1536.Source3.CertificateIndex

#print axioms FT1536.Source3.CertificateIndex.index_exact
#print axioms FT1536.Source3.CertificateIndex.covers
