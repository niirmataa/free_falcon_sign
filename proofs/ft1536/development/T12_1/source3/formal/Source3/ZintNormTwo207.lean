import Source3.ZintNormCall207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormTwo207
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)

def pair (a b : BitVec 32) (i : Nat) := if i=0 then a else b
 def decision (x0 x1 p0 p1 : BitVec 32) := ZintNormFixed207.choice (pair x0 x1) (pair p0 p1) 0 2
 def low (x0 x1 p0 p1 : BitVec 32) := ZintNormFixed207.resultWord (pair x0 x1) (pair p0 p1) (decision x0 x1 p0 p1) 0
 def high (x0 x1 p0 p1 : BitVec 32) := ZintNormFixed207.resultWord (pair x0 x1) (pair p0 p1) (decision x0 x1 p0 p1) 1

theorem source (s : State) (px pp : ArrayPointer) (x0 x1 p0 p1 : BitVec 32)
    (xb : s.arrays "x".toList=some px) (pb : s.arrays "tmp".toList=some pp) (len : Cell s "xlen".toList 2)
    (rx0 : Load32 s.heap px x0) (rx1 : Load32 s.heap (ZintAddMulWord205.next px) x1)
    (rp0 : Load32 s.heap pp p0) (rp1 : Load32 s.heap (ZintAddMulWord205.next pp) p1)
    (writable : s.heap.writable px.block=true)
    (apart : ∀ i j, i < 2 → j < 2 → Separate (elem px i) (elem pp j)) :
    ∃ out, KeygenZintCall.Exec (.call .normZero ZintNormWord194.consumerArgs .discard) s ⟨out,.normal⟩ ∧
      Load32 out.heap px (low x0 x1 p0 p1) ∧
      Load32 out.heap (ZintAddMulWord205.next px) (high x0 x1 p0 p1) ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, Separate px q → Separate (ZintAddMulWord205.next px) q →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have width : px.elementBytes=4 := by cases rx0 with | load _ _ w _ => exact w
  have xc : px.index+2 ≤ px.count := by
    cases rx1 with | load _ h _ _ => have b:=h.2.2.1; change px.index+1 < px.count at b; omega
  have pc : pp.index+0 ≤ pp.count := by cases rp0 with | load _ h _ _ => have b:=h.2.2.1; omega
  have xRead : ∀ i, i < 2 → Load32 s.heap (elem px i) (pair x0 x1 i) := by
    intro i bound
    have index : i=0 ∨ i=1 := by omega
    rcases index with h|h <;> subst i
    · exact rx0
    · exact rx1
  have pRead : ∀ i, i < 2 → Load32 s.heap (elem pp i) (pair p0 p1 i) := by
    intro i bound
    have index : i=0 ∨ i=1 := by omega
    rcases index with h|h <;> subst i
    · exact rp0
    · exact rp1
  obtain ⟨out,run,image,locals,arrays,keep⟩:=ZintNormCall207.source s px pp 2 (pair x0 x1) (pair p0 p1)
    xb pb len (by decide) width xc pc writable xRead pRead apart
  refine ⟨out,run,image 0 (by decide),image 1 (by decide),locals,arrays,?_⟩
  intro q old first second read
  apply keep q old _ read
  intro i bound
  have index : i=0 ∨ i=1 := by omega
  rcases index with h|h <;> subst i
  · exact first
  · exact second

end FT1536.Source3.ZintNormTwo207
