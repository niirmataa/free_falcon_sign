import Source3.ZintNormWalkLoop208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormWalkFlat208
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open ZintNormWalkIncrement208 (row point)
open ZintNormWalkFixed208 (Fixed Pending)

def Data (s : State) (root : ArrayPointer) (total : Nat) (W : Nat → BitVec 32) : Prop :=
  ∀ i, i < total → Load32 s.heap (elem root i) (W i)
 def words (len : Nat) (W pv : Nat → BitVec 32) (i : Nat) :=
  ZintNormFixed207.resultWord (fun j => W (i/len*len+j)) pv
    (ZintNormFixed207.choice (fun j => W (i/len*len+j)) pv 0 len) (i%len)

theorem row_zero (root : ArrayPointer) (len : Nat) : row root len 0=root := by
  simp only [row,elem,Nat.zero_mul,Nat.add_zero]

theorem index_bound (n len i j : Nat) (ib : i < n) (jb : j < len) : i*len+j < n*len := by
  have upper : i*len+j < (i+1)*len := by rw [Nat.add_mul,Nat.one_mul]; omega
  have order : (i+1)*len ≤ n*len := Nat.mul_le_mul_right len (by omega)
  omega

theorem quotient_bound (n len i : Nat) (bound : i < n*len) : i/len < n := by
  by_contra absent
  have lower : n ≤ i/len := by omega
  have order : n*len ≤ i/len*len := Nat.mul_le_mul_right len lower
  have floor:=Nat.div_mul_le_self i len
  omega

theorem address (root : ArrayPointer) (len i : Nat) : point root len (i/len) (i%len)=elem root i := by
  have split:=Nat.mod_add_div i len
  rw [Nat.mul_comm len (i/len)] at split
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+(i/len*len+i%len)=root.index+i by omega)

theorem source (s : State) (root tmp : ArrayPointer) (n len : Nat) (W pv : Nat → BitVec 32)
    (fixed : Fixed s root tmp n len pv) (uc : Cell s "u".toList 0)
    (xb : s.arrays "x".toList=some root) (data : Data s root (n*len) W) :
    ∃ out, KeygenZintCall.Exec ZintNormWalk194.walkLoop s ⟨out,.normal⟩ ∧ Fixed out root tmp n len pv ∧
      Cell out "u".toList n ∧ out.arrays "x".toList=some (row root len n) ∧ Data out root (n*len) (words len W pv) ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < n*len → Separate (elem root i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  let rows : Nat → Nat → BitVec 32 := fun i j => W (i*len+j)
  have pending : Pending s root n len rows 0 := by
    intro i _ ib j jb
    exact data (i*len+j) (index_bound n len i j ib jb)
  have ptr : s.arrays "x".toList=some (row root len 0) := by rw [row_zero]; exact xb
  obtain ⟨out,run,finalFixed,finalU,finalX,written,locals,arrays,keep⟩:=
    ZintNormWalkLoop208.source s root tmp n len rows pv fixed uc ptr pending
  refine ⟨out,run,finalFixed,finalU,finalX,?_,locals,arrays,?_⟩
  · intro i bound
    have qbound:=quotient_bound n len i bound
    have rbound:=Nat.mod_lt i fixed.positive
    have read:=written (i/len) qbound (i%len) rbound
    rw [address] at read
    exact read
  · intro q old apart read
    apply keep q old _ read
    intro i j ib jb
    exact apart (i*len+j) (index_bound n len i j ib jb)

end FT1536.Source3.ZintNormWalkFlat208
