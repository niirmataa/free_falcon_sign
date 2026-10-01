import Source3.KeygenResidueMaterial
import Source3.KeygenMaterial

namespace FT1536.Source3.KeygenResidueVectors
open C99MemoryReference
open KeygenSmallOutput (element Stored byte16)
open FT1536.Geometry (Vec)

theorem join_bytes (word : BitVec 16) : C99NarrowReads.le16 (byte16 word)=word := by
  change (word >>> 8).setWidth 8 ++ (word >>> 0).setWidth 8=word
  rw [BitVec.setWidth_ushiftRight_eq_extractLsb,BitVec.setWidth_ushiftRight_eq_extractLsb]
  exact BitVec.extractLsb'_append_extractLsb'

theorem stored_read_integer (heap : Memory) (ptr : ArrayPointer) (z : Int) (word : BitVec 16)
    (stored : Stored heap ptr (BitVec.ofInt 16 z)) (read : C99NarrowReads.Load16 heap ptr word)
    (bounds : -2047≤z ∧ z≤2047) : word.toInt=z := by
  cases read with
  | load bytes allocated width initialized =>
      have same : bytes=byte16 (BitVec.ofInt 16 z) := by
        funext i
        exact Option.some.inj ((initialized i).symm.trans (stored i))
      rw [same,join_bytes]
      exact KeygenSmallOutput.narrowed_exact z (by dsimp [KeygenSmallOutput.accepted]; omega)

def Represents (heap : Memory) (ptr : ArrayPointer) (v : Vec) : Prop := ∀ i : Fin 768,
  (∃ word, Load32 heap (element ptr i.val) word ∧ word.toNat<KeygenNinv31.prime.toNat ∧
    (word.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=(v i).1%(KeygenNinv31.prime.toNat : Int)) ∧
  (∃ word, Load32 heap (element ptr (i.val+768)) word ∧ word.toNat<KeygenNinv31.prime.toNat ∧
    (word.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=(v i).2%(KeygenNinv31.prime.toNat : Int))

theorem source_vectors (arrays : KeygenResidueTrace.Arrays) (root : ArrayPointer)
    (layout : KeygenResidueRanges.Layout arrays root) (separate : KeygenResidueFrame.InputSeparate arrays)
    (before : C99ArrayReference.State) (old : Option C99IntegerReference.Value) (result : C99ProcedureReference.Result)
    (counter : before.locals "u".toList=some (.uint64,old)) (inputs : KeygenResidueTrace.Inputs arrays before)
    (vectors : Fin 4 → Vec)
    (represented : ∀ slot, KeygenMaterial.Represents before.heap (arrays.input slot) (vectors slot))
    (bounded : ∀ slot, KeygenIntegerLift.Bound (vectors slot) 2047)
    (source : C99ModularReference.Exec KeygenResidueProgram.code before result) :
    ∀ slot, Represents result.state.heap (arrays.output slot) (vectors slot) := by
  have material := KeygenResidueMaterial.source_material arrays root layout separate before old result counter inputs source
  intro slot i
  constructor
  · obtain ⟨input,out,readIn,readOut,range,residue⟩ := material slot i.val (by have := i.isLt; omega)
    have value := stored_read_integer before.heap (element (arrays.input slot) i.val) (vectors slot i).1 input
      (represented slot i).1 readIn (abs_le.mp (bounded slot i).1)
    rw [value] at residue
    exact ⟨out,readOut,range,residue⟩
  · obtain ⟨input,out,readIn,readOut,range,residue⟩ := material slot (i.val+768) (by have := i.isLt; omega)
    have value := stored_read_integer before.heap (element (arrays.input slot) (i.val+768)) (vectors slot i).2 input
      (represented slot i).2 readIn (abs_le.mp (bounded slot i).2)
    rw [value] at residue
    exact ⟨out,readOut,range,residue⟩

end FT1536.Source3.KeygenResidueVectors
