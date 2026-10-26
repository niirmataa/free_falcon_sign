import Source3.ZintSubWhole207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSubCall207
open C99ArrayReference (State Bind Pointer bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open CrtState205 (set64)
open StepCopyBody190 (elem)
open C99NatWord141 (word)
open ZintSubFixed207 (Fixed Written borrowWord)
open KeygenZintCall (Exec)

def entry (s : State) (pa pb : ArrayPointer) (n : Nat) :=
  bindPointer (bindPointer (set64 (CrtAddMulCall205.fresh s) "len" (word n)) ZintSubWord194.bName pb) ZintSubWord194.aName pa

theorem cells (s : State) (pa pb : ArrayPointer) (n : Nat) :
    (entry s pa pb n).arrays ZintSubWord194.aName=some pa ∧
    (entry s pa pb n).arrays ZintSubWord194.bName=some pb ∧ Cell (entry s pa pb n) ZintSubWord194.lenName n := by
  refine ⟨?_,?_,?_⟩
  · simp only [entry,bindPointer,ite_true]
  · simp only [entry,bindPointer]; rfl
  · change Cell (set64 (CrtAddMulCall205.fresh s) "len" (word n)) ZintSubWord194.lenName n
    exact CrtState205.cell64 _ _ _

theorem binding (s : State) (pa pb : ArrayPointer) (n : Nat)
    (xa : s.arrays "x".toList=some pa) (pp : s.arrays "p".toList=some pb)
    (len : Cell s ZintSubWord194.lenName n) (acap : pa.index+0 ≤ pa.count) (bcap : pb.index+0 ≤ pb.count) :
    Bind s (KeygenZintCall.params (.leaf .sub)) ZintSubWord194.subArgs (entry s pa pb n) := by
  have zero:=C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have ptrA : Pointer s "x".toList C99ProcedureParser.zero pa := .add _ _ pa pa (.uint64 0) xa zero (by decide) (.within pa 0 acap)
  have ptrB : Pointer s "p".toList C99ProcedureParser.zero pb := .add _ _ pb pb (.uint64 0) pp zero (by decide) (.within pb 0 bcap)
  exact .pointer _ _ _ _ _ _ _ ptrA (.pointer _ _ _ _ _ _ _ ptrB
    (.scalar .uint64 ZintSubWord194.lenName (.var ZintSubWord194.lenName) _ _ _ (.uint64 (word n)) (.variable _ _ _ len) .nil))

theorem source (s : State) (pa pb : ArrayPointer) (n : Nat) (av bv : Nat → BitVec 32)
    (xa : s.arrays "x".toList=some pa) (pp : s.arrays "p".toList=some pb)
    (len : Cell s ZintSubWord194.lenName n) (nb : n < 2^64) (width : pa.elementBytes=4)
    (acap : pa.index+n ≤ pa.count) (bcap : pb.index+0 ≤ pb.count) (writable : s.heap.writable pa.block=true)
    (aRead : ∀ i, i < n → Load32 s.heap (elem pa i) (av i))
    (bRead : ∀ i, i < n → Load32 s.heap (elem pb i) (bv i))
    (apart : ∀ i j, i < n → j < n → Separate (elem pa i) (elem pb j)) :
    ∃ out, Exec (.call (.leaf .sub) ZintSubWord194.subArgs .discard) s ⟨out,.normal⟩ ∧ Written out pa av bv n ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i, i < n → Separate (elem pa i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have holds:=cells s pa pb n
  have fixed : Fixed (entry s pa pb n) pa pb n bv :=
    ⟨nb,width,acap,writable,holds.1,holds.2.1,holds.2.2,bRead,apart⟩
  obtain ⟨out,run,flow,written,_,_,keep⟩:=ZintSubWhole207.source (entry s pa pb n) pa pb n av bv fixed aRead
  have returned : C99ProcedureReference.ReturnValue (KeygenZintCall.result (.leaf .sub)) out.flow
      (some (.uint32 (borrowWord av bv n))) := by
    rw [flow]
    have rv:=C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (borrowWord av bv n))
    rw [KeygenDecodeWordOps.self32] at rv
    exact rv
  refine ⟨{s with heap:=out.state.heap},?_,written,rfl,rfl,keep⟩
  exact .call s (.leaf .sub) ZintSubWord194.subArgs .discard (entry s pa pb n) out
    (some (.uint32 (borrowWord av bv n))) _ (binding s pa pb n xa pp len (by omega) bcap)
    (.word _ _ _ run) returned (.discard _ _)

end FT1536.Source3.ZintSubCall207
