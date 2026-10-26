import Source3.CrtAddMulCall205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtReduceCall205
open C99ArrayReference (State Arg Pointer Bind)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open CrtState205 (Slot64 set32)
open ZintModSignedWord194 (leafEntry unsignedWord)
open KeygenZintCall (Exec)

def args : List Arg := [.pointer "x".toList C99ProcedureParser.zero,.scalar (.var "u".toList),
  .scalar (.var "p".toList),.scalar (.var "p0i".toList),.scalar (.var "R2".toList)]

theorem binding (s : State) (q : ArrayPointer) (p pi r2 : BitVec 32)
    (px : s.arrays "x".toList=some q) (u : Slot64 s "u" 1)
    (pp : Slot s "p" p) (ip : Slot s "p0i" pi) (rp : Slot s "R2" r2)
    (cap : q.index+0 ≤ q.count) :
    Bind s (KeygenZintCall.params (.leaf .reduce)) args (leafEntry s q p pi r2) := by
  have zero:=C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have ptr : Pointer s "x".toList C99ProcedureParser.zero q :=
    .add _ _ q q (.uint64 0) px zero (by decide) (.within q 0 cap)
  refine .pointer _ _ _ _ _ _ _ ptr ?_
  refine .scalar .uint64 "dlen".toList (.var "u".toList) _ _ _ (.uint64 1) (.variable _ _ _ u) ?_
  refine .scalar .uint32 "p".toList (.var "p".toList) _ _ _ (.uint32 p) (.variable _ _ _ pp) ?_
  refine .scalar .uint32 "p0i".toList (.var "p0i".toList) _ _ _ (.uint32 pi) (.variable _ _ _ ip) ?_
  exact .scalar .uint32 "R2".toList (.var "R2".toList) _ _ _ (.uint32 r2) (.variable _ _ _ rp) .nil

theorem source (s : State) (q : ArrayPointer) (a p pi r2 : BitVec 32)
    (px : s.arrays "x".toList=some q) (u : Slot64 s "u" 1)
    (pp : Slot s "p" p) (ip : Slot s "p0i" pi) (rp : Slot s "R2" r2)
    (xq : s.locals "xq".toList=some (.uint32,none)) (read : Load32 s.heap q a) :
    Exec (.call (.leaf .reduce) args (.into "xq".toList)) s
      ⟨set32 s "xq" (unsignedWord a p pi r2),.normal⟩ := by
  have cap : q.index+0 ≤ q.count := by cases read with | load _ h _ _ => have b:=h.2.2.1; omega
  have ready:=ZintModSignedWord194.leaf_run (leafEntry s q p pi r2) q a p pi r2
    (ZintModSignedWord194.leaf_entry_arrays s q p pi r2) cap
    (ZintModSignedWord194.leaf_entry_p s q p pi r2)
    (ZintModSignedWord194.leaf_entry_p0i s q p pi r2)
    (ZintModSignedWord194.leaf_entry_r2 s q p pi r2)
    (ZintModSignedWord194.leaf_entry_dlen s q p pi r2) read
  have run : KeygenWordExec.Exec (KeygenZintLeaves.code .reduce) (leafEntry s q p pi r2)
      ⟨ZintModSignedWord194.t12 (leafEntry s q p pi r2) a p pi r2,.returned (some (.uint32 (unsignedWord a p pi r2)))⟩ := by
    rw [ZintModSignedWord194.reduce_shape]
    exact ready.1
  refine .call s (.leaf .reduce) args (.into "xq".toList) (leafEntry s q p pi r2) _
    (some (.uint32 (unsignedWord a p pi r2))) _ (binding s q p pi r2 px u pp ip rp cap) (.word _ _ _ run) ?_ ?_
  · have rv:=C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (unsignedWord a p pi r2))
    rw [KeygenDecodeWordOps.self32] at rv
    exact rv
  · rw [ready.2]
    exact .into _ _ .uint32 none _ xq

end FT1536.Source3.CrtReduceCall205
