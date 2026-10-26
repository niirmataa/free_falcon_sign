import Source3.CrtWalkLoop214

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkFlat214
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open CrtWalkIncrement214 (row point)
open CrtWalkFixed214 (Fixed Pending)
open ZintNormWalkFlat208 (Data index_bound quotient_bound)

theorem row_zero (root : ArrayPointer) (stride : Nat) : row root stride 0=root := ZintNormWalkFlat208.row_zero root stride
 theorem address (root : ArrayPointer) (stride i : Nat) : point root stride (i/stride) (i%stride)=elem root i :=
  ZintNormWalkFlat208.address root stride i

def words (len stride : Nat) (W T : Nat → BitVec 32) (p pi r2 c : BitVec 32) (i : Nat) :=
  if i%stride ≤ len then CrtCoefficientState214.words (fun j => W (i/stride*stride+j)) T len p pi r2 c (i%stride) else W i

theorem outside_tail (root : ArrayPointer) (len stride v i k j : Nat) (width : root.elementBytes=4)
    (room : len+1 ≤ stride) (kb : k ≤ len) (jb : j < stride) (tail : len < j) :
    Separate (point root stride v k) (point root stride i j) := by
  by_cases same : v=i
  · subst i
    exact StepCopyFixed203.elem_separate root width (v*stride+k) (v*stride+j) (by omega)
  · exact ZintNormWalkFixed208.different root stride v i k j width (by omega) jb same

theorem source (s : State) (root tmp : ArrayPointer) (n len stride : Nat) (W T : Nat → BitVec 32) (p pi r2 c : BitVec 32)
    (fixed : Fixed s root tmp n len stride T p pi r2 c) (vc : Cell s "v".toList 0)
    (xb : s.arrays "x".toList=some root) (data : Data s root (n*stride) W) :
    ∃ out, KeygenZintCall.Exec CrtRoundShape205.walk s ⟨out,.normal⟩ ∧ Fixed out root tmp n len stride T p pi r2 c ∧
      Cell out "v".toList n ∧ out.arrays "x".toList=some (row root stride n) ∧ Data out root (n*stride) (words len stride W T p pi r2 c) ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i j, i < n → j ≤ len → Separate (point root stride i j) q) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  let rows : Nat → Nat → BitVec 32 := fun i j => W (i*stride+j)
  have pending : Pending s root n len stride rows 0 := by
    intro i _ ib j jb
    exact data (i*stride+j) (index_bound n stride i j ib (by have room:=fixed.room; omega))
  have ptr : s.arrays "x".toList=some (row root stride 0) := by rw [row_zero]; exact xb
  obtain ⟨out,run,finalFixed,finalV,finalX,written,ls,ars,keep⟩:=
    CrtWalkLoop214.source s root tmp n len stride rows T p pi r2 c fixed vc ptr pending
  refine ⟨out,run,finalFixed,finalV,finalX,?_,ls,ars,keep⟩
  intro i bound
  have qbound:=quotient_bound n stride i bound
  have positive : 0 < stride := by have room:=fixed.room; omega
  have rbound:=Nat.mod_lt i positive
  by_cases low : i%stride ≤ len
  · simp only [words,low,ite_true]
    have read:=written (i/stride) qbound (i%stride) low
    rw [address] at read
    exact read
  · simp only [words,low,ite_false]
    apply keep _ _ _ (data i bound)
    intro v j _ jb
    rw [←address root stride i]
    exact outside_tail root len stride v (i/stride) j (i%stride) fixed.width fixed.room jb rbound (by omega)

end FT1536.Source3.CrtWalkFlat214
