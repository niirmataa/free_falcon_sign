import Source3.KeygenInt16CodecMath076
import Source3.KeygenMakeMaterialWitness

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Consume the EXISTING source-derived same-material witness, retaining all
   four roles f/g/F/G and the same public/inverse equations. This does not
   assert the still-open whole-root accepted-attempt/encoding assembly. -/
namespace FT1536.Source3.KeygenInt16FourMaterial076
open C99MemoryReference
open KeygenInt16Vector076 KeygenInt16Representation076

abbrev Vectors := Fin 4 → Geometry.Vec
def Legal (heap : Memory) (input : Fin 4 → ArrayPointer) : Prop :=
  ∀ slot, KeygenPublicInputMaterial.Legal heap (input slot)
def Represented (heap : Memory) (input : Fin 4 → ArrayPointer) (v : Vectors) : Prop :=
  ∀ slot, KeygenMaterial.Represents heap (input slot) (v slot)
def Physical (heap : Memory) (input : Fin 4 → ArrayPointer) (v : Vectors) : Prop :=
  ∀ slot, KeygenCodecStaticMaterial.Words heap (input slot) (wordList (v slot))

theorem bounds_signed (v : Vectors) (bounds : KeygenSolverEquation.Bounds v) : ∀ slot, Signed16 (v slot) := by
  intro slot
  fin_cases slot
  · exact bound_signed _ 1 (by decide +kernel) (by decide +kernel) bounds.1
  · exact bound_signed _ 1 (by decide +kernel) (by decide +kernel) bounds.2.1
  · exact bound_signed _ 2047 (by decide +kernel) (by decide +kernel) bounds.2.2.1
  · exact bound_signed _ 2047 (by decide +kernel) (by decide +kernel) bounds.2.2.2

theorem bounds_carrier (v : Vectors) (bounds : KeygenSolverEquation.Bounds v) :
    ∀ slot, KeygenDecodeNonePairs.CarrierList (wordList (v slot)) := by
  intro slot
  fin_cases slot
  · exact KeygenInt16Bounds076.none_carrier _ 1 (by decide +kernel) (by decide +kernel) bounds.1
  · exact KeygenInt16Bounds076.none_carrier _ 1 (by decide +kernel) (by decide +kernel) bounds.2.1
  · exact KeygenInt16Bounds076.none_carrier _ 2047 (by decide +kernel) (by decide +kernel) bounds.2.2.1
  · exact KeygenInt16Bounds076.none_carrier _ 2047 (by decide +kernel) (by decide +kernel) bounds.2.2.2

theorem represented_physical (heap : Memory) (input : Fin 4 → ArrayPointer) (v : Vectors)
    (legal : Legal heap input) (material : Represented heap input v) : Physical heap input v :=
  fun slot => represents_words heap (input slot) (v slot) (legal slot) (material slot)

theorem physical_represented (heap : Memory) (input : Fin 4 → ArrayPointer) (v : Vectors)
    (material : Physical heap input v) : Represented heap input v :=
  fun slot => words_represents heap (input slot) (v slot) (material slot)

theorem source_conversion (dst src : ArrayPointer) (before after : Memory)
    (legal : KeygenPublicInputMaterial.Legal before dst)
    (source : KeygenSmallOutput.Loop dst src 0 before after true) :
    ∃ v : Geometry.Vec, KeygenIntegerLift.Bound v 2047 ∧ Signed16 v ∧
      KeygenCodecStaticMaterial.Words after dst (wordList v) ∧
      KeygenInt16CodecMath076.IntegerReads after dst v := by
  obtain ⟨v,represented,bound⟩ := KeygenMaterial.converted_material dst src before after source legal.1
  have sizes := (KeygenSmallOutput.loop_metadata dst src 0 before after true source).1
  have legalAfter : KeygenPublicInputMaterial.Legal after dst :=
    ⟨legal.1,fun i small => by simpa only [Allocated,sizes] using legal.2 i small⟩
  have signed := bound_signed v 2047 (by decide +kernel) (by decide +kernel) bound
  have indexed := represents_indexed after dst v legalAfter represented
  exact ⟨v,bound,signed,indexed_words after dst v indexed,
    fun i => ⟨words v i,indexed i,word_integer v signed i⟩⟩

theorem from_witness (heap : Memory) (input : Fin 4 → ArrayPointer) (pub : ArrayPointer)
    (legal : Legal heap input) (sourceMaterial : KeygenMakeMaterialWitness.Witness heap input pub) :
    ∃ (v : Vectors) (h fInv : Relation.Rq),
      Represented heap input v ∧ Physical heap input v ∧
      (∀ slot, Signed16 (v slot)) ∧ (∀ slot, KeygenDecodeNonePairs.CarrierList (wordList (v slot))) ∧
      KeygenSolverEquation.Bounds v ∧ KeygenSolverEquation.Equation v ∧
      KeygenPublicNormalizePolynomial.Represents heap pub h ∧
      Relation.mulRq h (Relation.reduceVec (v 0))=Relation.reduceVec (v 1) ∧
      Relation.mulRq fInv (Relation.reduceVec (v 0))=
        FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R) := by
  obtain ⟨f,g,F,G,h,fInv,hf,hg,hF,hG,hh,bounds,equation,publicEq,inverseEq⟩ := sourceMaterial
  let v : Vectors := KeygenOutputGateValidation.material f g F G
  have represented : Represented heap input v := by
    intro slot
    fin_cases slot
    · exact hf
    · exact hg
    · exact hF
    · exact hG
  exact ⟨v,h,fInv,represented,represented_physical heap input v legal represented,
    bounds_signed v bounds,bounds_carrier v bounds,bounds,equation,hh,publicEq,inverseEq⟩

end FT1536.Source3.KeygenInt16FourMaterial076
