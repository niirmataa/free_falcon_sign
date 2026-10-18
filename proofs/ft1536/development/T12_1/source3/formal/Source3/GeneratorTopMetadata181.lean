import Source3.GeneratorTopSource181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorTopMetadata181
open C99ModularReference (Exec chainOf)
open KeygenMkgm3Program
open KeygenModpR2Exec (Slot)
open SelectedGeneratorScalar178 (r g0)
open SelectedTopInit178 (r2)

def tail := [ifNotFull,whileK,igAssign,rowSelect,kFromLogn,ifFull,squareLoop]

theorem tail_source : Exec (chainOf tail) SelectedGeneratorScalar178.after ⟨SelectedGeneratorSquare181.after,.normal⟩ :=
  ModularSequence178.source _ [ifNotFull,whileK] SelectedGeneratorSquare178.before SelectedGeneratorSquare178.after
    SelectedGeneratorSquare178.source [igAssign,rowSelect,kFromLogn,ifFull,squareLoop] _
    (.seqNormal _ _ SelectedGeneratorInverseCall178.before SelectedGeneratorInverseCall178.after _ SelectedGeneratorInverseCall178.source
      (.seqNormal _ _ SelectedGeneratorRow179.before SelectedGeneratorRow179.after _ SelectedGeneratorRow179.source
        (.seqNormal _ _ SelectedGeneratorCubeSetup180.before SelectedGeneratorCubeSetup180.logged _ SelectedGeneratorCubeSetup180.source
          (.seqNormal _ _ SelectedGeneratorCubeSetup180.logged SelectedGeneratorCubeLoop180.after _ SelectedGeneratorCube180.source
            (.seqNormal _ _ SelectedGeneratorSquare181.before SelectedGeneratorSquare181.after _ SelectedGeneratorSquare181.source
              (.base .skip _ _ (.skip _)))))))

theorem scalar_r : Slot SelectedGeneratorScalar178.after "R" r :=
  (ModularAtoms178.outside SelectedGeneratorScalar178.converted "k" "R" 10 (by decide)).trans
    ((ModularAtoms178.outside SelectedGeneratorScalar178.withR2 "g" "R" g0 (by decide)).trans
      ((ModularAtoms178.outside SelectedGeneratorScalar178.withR "R2" "R" r2 (by decide)).trans
        (ModularAtoms178.slot SelectedGeneratorScalar178.before "R" r)))

theorem scalar_r2 : Slot SelectedGeneratorScalar178.after "R2" r2 :=
  (ModularAtoms178.outside SelectedGeneratorScalar178.converted "k" "R2" 10 (by decide)).trans
    ((ModularAtoms178.outside SelectedGeneratorScalar178.withR2 "g" "R2" g0 (by decide)).trans
      (ModularAtoms178.slot SelectedGeneratorScalar178.withR "R2" r2))

theorem r_cell : Slot SelectedGeneratorSquare181.after "R" r :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) tail_source).2.2 _ (by decide)).trans scalar_r

theorem r2_cell : Slot SelectedGeneratorSquare181.after "R2" r2 :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) tail_source).2.2 _ (by decide)).trans scalar_r2

theorem scalar_w : KeygenMkgm3Prelude.Declared SelectedGeneratorScalar178.after "w" .uint32 :=
  KeygenMkgm3Prelude.declared_transport _ SelectedGeneratorScalar178.before ⟨SelectedGeneratorScalar178.after,.normal⟩
    "w" .uint32 (by decide) (by decide) ⟨none,rfl⟩
    (ModularSequence178.complete _ _ _ _ SelectedGeneratorScalar178.source)

theorem w_declared : KeygenMkgm3Prelude.Declared SelectedGeneratorSquare181.after "w" .uint32 :=
  KeygenMkgm3Prelude.declared_transport _ SelectedGeneratorScalar178.after ⟨SelectedGeneratorSquare181.after,.normal⟩
    "w" .uint32 (by decide) (by decide) scalar_w tail_source

end FT1536.Source3.GeneratorTopMetadata181
