import Source3.KeygenPublicSuffixProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Successful source tests establish nonzero values before division. Actual
   unsigned16 promotions and uint32 parameter conversions remain visible. -/
namespace FT1536.Source3.KeygenPublicSuffixAtoms
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed index)
open KeygenPublicInputCells (Cell)
open KeygenPublicAlgebra (R Canonical value)
open KeygenPublicRangeExpr (Ranged word word_range word_argument)
open KeygenPublicValueExpr (meaning)
open KeygenPublicSuffixProgram (zeroTest fail test quotient divide)
open KeygenNttLoopSupport (USlot)

def Failure : C99ProcedureReference.Flow := .returned (some (.int32 0))

theorem load_word (s : State) (name : String) (p : ArrayPointer) (i : Nat) (z : R)
    (hi : i<1536) (unsigned : signed.contains name.toList=false)
    (binding : s.arrays name.toList=some p) (counter : USlot s "u" i)
    (cell : Cell s.heap p i z) (v : Value)
    (source : KeygenPublicWord.Eval signed s (.load16 name.toList index) v) :
    ∃ w : BitVec 16, v=C99NarrowReads.unsignedPromotion w ∧ w.toNat<18433 ∧ (w.toNat : R)=z := by
  cases source with
  | load16 _ _ actual w address read =>
      rw [KeygenPublicInputAtoms.index_address s name p actual i (by omega) binding counter address] at read
      obtain ⟨old,loaded,range,eq⟩ := cell
      have we := C99NarrowReads.load16_deterministic _ _ _ _ read loaded
      subst w
      exact ⟨old,by simp only [unsigned,Bool.false_eq_true,ite_false],range,eq⟩

theorem load_value (s : State) (name : String) (p : ArrayPointer) (i : Nat) (z : R)
    (hi : i<1536) (unsigned : signed.contains name.toList=false)
    (binding : s.arrays name.toList=some p) (counter : USlot s "u" i)
    (cell : Cell s.heap p i z) (v : Value)
    (source : KeygenPublicWord.Eval signed s (.load16 name.toList index) v) : Ranged v ∧ meaning v=z := by
  obtain ⟨w,eq,range,val⟩ := load_word s name p i z hi unsigned binding counter cell v source
  subst v
  refine ⟨?_,?_⟩
  · unfold Ranged
    rw [C99NarrowReads.unsigned_promotion_exact]
    exact ⟨Int.natCast_nonneg _,by exact_mod_cast range⟩
  · unfold meaning
    rw [C99NarrowReads.unsigned_promotion_exact,Int.cast_natCast]
    exact val

theorem test_guard (s : State) (t : ArrayPointer) (i : Nat) (z : R) (hi : i<1536)
    (binding : s.arrays "t".toList=some t) (counter : USlot s "u" i)
    (cell : Cell s.heap t i z) (v : Value)
    (source : KeygenPublicWord.Eval signed s zeroTest v) :
    v=C99ScalarReference.boolean (decide (z=0)) := by
  cases source with
  | cmp _ _ _ av bv _ left right op =>
      obtain ⟨w,ae,range,val⟩ := load_word s "t" t i z hi (by decide) binding counter cell av left
      have be := KeygenPublicTableAtoms.literal_value signed s 0 bv right
      subst av; subst bv
      have eq := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .eq
        (C99IntegerReference.convert .int32 (C99NarrowReads.unsignedPromotion w).integer).integer
        (C99IntegerReference.convert .int32 (Value.int32 0).integer).integer) at eq
      rw [show C99IntegerReference.convert .int32 (C99NarrowReads.unsignedPromotion w).integer=
        C99NarrowReads.unsignedPromotion w from C99CountedWords.convert_self (C99NarrowReads.unsignedPromotion w),
        show C99IntegerReference.convert .int32 (Value.int32 0).integer=.int32 0 from rfl,
        C99NarrowReads.unsigned_promotion_exact] at eq
      have castZero : (w.toNat : R)=0 ↔ w.toNat=0 := by
        constructor
        · intro zero
          have he := (ZMod.natCast_eq_natCast_iff' w.toNat 0 18433).mp zero
          rwa [Nat.mod_eq_of_lt range,Nat.zero_mod] at he
        · intro zero; rw [zero]; rfl
      have same : (w.toNat : Int)=0 ↔ z=0 := by rw [← val,castZero]; omega
      change v=C99ScalarReference.boolean (decide ((w.toNat : Int)=0)) at eq
      simpa only [same] using eq

theorem failed (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program signed fail s out) : out.flow=Failure := by
  cases source with
  | scope _ _ _ _ inner executed =>
      cases executed with
      | seqNormal _ _ _ _ _ first last => cases first
      | seqExit _ _ _ _ first exit =>
          cases first with
          | ret _ _ v evaluated =>
              rw [KeygenPublicTableAtoms.literal_value signed s 0 v evaluated]
              rfl

theorem test_flow (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program signed test s out) : out.flow=.normal ∨ out.flow=Failure := by
  cases source with
  | branchTrue _ _ _ _ _ _ _ _ inner => exact Or.inr (failed s out inner)
  | branchFalse _ _ _ _ _ _ _ _ inner => cases inner; exact Or.inl rfl

theorem test_normal (s after : State) (t : ArrayPointer) (i : Nat) (z : R) (hi : i<1536)
    (binding : s.arrays "t".toList=some t) (counter : USlot s "u" i) (cell : Cell s.heap t i z)
    (source : Exec KeygenPublicSource.program signed test s ⟨after,.normal⟩) : after=s ∧ z≠0 := by
  cases source with
  | branchTrue _ _ _ _ _ _ _ _ inner => have impossible := failed s ⟨after,.normal⟩ inner; cases impossible
  | branchFalse _ _ _ _ _ v guard zero inner =>
      cases inner
      refine ⟨rfl,?_⟩
      rw [test_guard s t i z hi binding counter cell v guard] at zero
      intro eq
      simp only [eq,decide_true,C99ScalarReference.boolean,Value.integer] at zero
      contradiction

theorem quotient_value (s : State) (h t : ArrayPointer) (i : Nat) (x y : R) (hi : i<1536)
    (hBinding : s.arrays "h".toList=some h) (tBinding : s.arrays "t".toList=some t)
    (counter : USlot s "u" i) (hc : Cell s.heap h i x) (tc : Cell s.heap t i y) (nonzero : y≠0)
    (v : Value) (source : KeygenPublicWord.Eval signed s (quotient .divT) v) :
    ∃ w, v=.uint32 w ∧ Canonical w ∧ value w=x*y⁻¹ := by
  cases source with
  | call2 _ _ _ av bv _ first second called =>
      obtain ⟨ar,ae⟩ := load_value s "h" h i x hi (by decide) hBinding counter hc av first
      obtain ⟨br,be⟩ := load_value s "t" t i y hi (by decide) tBinding counter tc bv second
      have normalized := KeygenPublicDivisionAlgebra.normalize_call (word av) (word bv) av bv v
        (word_argument av ar) (word_argument bv br) called
      have ve := KeygenPublicDivisionWords.source_exact _ _ v normalized
      rw [ve] at normalized ⊢
      have nz : (word bv).toNat≠0 := by
        intro zero
        apply nonzero
        rw [← be,← KeygenPublicValueExpr.word_meaning bv br,KeygenPublicAlgebra.value,zero]
        rfl
      obtain ⟨range,_,law⟩ := KeygenPublicDivisionAlgebra.source_division _ _ _ (word_range av ar) (word_range bv br) nz normalized
      rw [KeygenPublicValueExpr.word_meaning av ar,KeygenPublicValueExpr.word_meaning bv br,ae,be] at law
      exact ⟨_,rfl,range,law⟩

end FT1536.Source3.KeygenPublicSuffixAtoms
