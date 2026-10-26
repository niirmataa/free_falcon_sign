import Source3.ZintNormWhole207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormCall207
open C99ArrayReference (State Bind Pointer bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open CrtState205 (set64)
open StepCopyBody190 (elem)
open C99NatWord141 (word)
open ZintNormFixed207 (Fixed Image choice)
open KeygenZintCall (Exec)

def entry (s : State) (px pp : ArrayPointer) (n : Nat) :=
  bindPointer (bindPointer (set64 (CrtAddMulCall205.fresh s) "len" (word n)) ZintNormWord194.pName pp) ZintNormWord194.xName px

theorem cells (s : State) (px pp : ArrayPointer) (n : Nat) :
    (entry s px pp n).arrays ZintNormWord194.xName=some px ∧
    (entry s px pp n).arrays ZintNormWord194.pName=some pp ∧ Cell (entry s px pp n) ZintNormWord194.lenName n := by
  refine ⟨?_,?_,?_⟩
  · simp only [entry,bindPointer,ite_true]
  · simp only [entry,bindPointer]; rfl
  · change Cell (set64 (CrtAddMulCall205.fresh s) "len" (word n)) ZintNormWord194.lenName n
    exact CrtState205.cell64 _ _ _

theorem binding (s : State) (px pp : ArrayPointer) (n : Nat)
    (xb : s.arrays "x".toList=some px) (pb : s.arrays "tmp".toList=some pp) (len : Cell s "xlen".toList n)
    (xc : px.index+0 ≤ px.count) (pc : pp.index+0 ≤ pp.count) :
    Bind s (KeygenZintCall.params .normZero) ZintNormWord194.consumerArgs (entry s px pp n) := by
  have zero:=C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have ptrX : Pointer s "x".toList C99ProcedureParser.zero px := .add _ _ px px (.uint64 0) xb zero (by decide) (.within px 0 xc)
  have ptrP : Pointer s "tmp".toList C99ProcedureParser.zero pp := .add _ _ pp pp (.uint64 0) pb zero (by decide) (.within pp 0 pc)
  exact .pointer _ _ _ _ _ _ _ ptrX (.pointer _ _ _ _ _ _ _ ptrP
    (.scalar .uint64 ZintNormWord194.lenName (.var "xlen".toList) _ _ _ (.uint64 (word n)) (.variable _ _ _ len) .nil))

theorem source (s : State) (px pp : ArrayPointer) (n : Nat) (xv pv : Nat → BitVec 32)
    (xb : s.arrays "x".toList=some px) (pb : s.arrays "tmp".toList=some pp) (len : Cell s "xlen".toList n)
    (nb : n < 2^64) (width : px.elementBytes=4) (xc : px.index+n ≤ px.count) (pc : pp.index+0 ≤ pp.count)
    (writable : s.heap.writable px.block=true)
    (xRead : ∀ i, i < n → Load32 s.heap (elem px i) (xv i))
    (pRead : ∀ i, i < n → Load32 s.heap (elem pp i) (pv i))
    (apart : ∀ i j, i < n → j < n → Separate (elem px i) (elem pp j)) :
    ∃ out, Exec (.call .normZero ZintNormWord194.consumerArgs .discard) s ⟨out,.normal⟩ ∧
      Image out px n xv pv (choice xv pv 0 n) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i, i < n → Separate (elem px i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have holds:=cells s px pp n
  have fixed : Fixed (entry s px pp n) px pp n xv pv :=
    ⟨nb,width,xc,pc,writable,holds.1,holds.2.1,holds.2.2,xRead,pRead,apart⟩
  obtain ⟨out,run,returned,image,keep⟩:=ZintNormWhole207.source (entry s px pp n) px pp n xv pv fixed
  refine ⟨{s with heap:=out.state.heap},?_,image,rfl,rfl,keep⟩
  exact .call s .normZero ZintNormWord194.consumerArgs .discard (entry s px pp n) out none _
    (binding s px pp n xb pb len (by omega) pc) run returned (.discard _ _)

end FT1536.Source3.ZintNormCall207
