import ActualEmitEntry020D
import EmitTag020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.EmitLoops020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D BufferField020D OutputValues020D
open ActualEmitEntry020D
attribute [local irreducible] exec loopState

def keyCode (count : Nat) : Code := seqs [set 28 (lit 0),set 21 (lit 0),.loop count (lit 1) keyBody]
def replyCode (count : Nat) : Code := OutputLoop020D.code replyBody count

theorem key_shape (i : Input) (s : State) (count : Nat) :
    exec i (keyCode count) s=exec i (OutputLoop020D.code keyBody count) (put s 28 (word 0)) := by
  simp only [keyCode,OutputLoop020D.code,exec_seqs_cons,exec_seqs_nil,exec_set]
  rfl

theorem key_correct (i : Input) (s : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs)
    (count : Nat) (hc : count≤1536) (hz : BoxImage020C.readVec s=BoxImage020C.image z) (hv : Holds s v) :
    OutputLoop020D.Good (fun j => (keyValue z v j).val) 0 16 (by decide) s count (exec i (keyCode count) s) ∧
      OutputLoop020D.Frame 0 16 s (exec i (keyCode count) s) := by
  let q := put s 28 (word 0)
  have qz : BoxImage020C.readVec q=BoxImage020C.image z := hz
  have qv : Holds q v := hv
  have post := OutputLoop020D.code_correct i keyBody (fun j => (keyValue z v j).val) 0 16 (by decide) q
    (key_step i q z v qz qv) count hc (put_same _ _ _)
  rw [key_shape]
  exact post

theorem reply_correct (i : Input) (s : State) (z : StandaloneRuntime019.CachedBox)
    (count : Nat) (hc : count≤1536) (hz : BoxImage020C.readVec s=BoxImage020C.image z)
    (h28 : s.reg 28=word 24577) :
    OutputLoop020D.Good (replyValue z) 24577 17 (by decide) s count (exec i (replyCode count) s) ∧
      OutputLoop020D.Frame 24577 17 s (exec i (replyCode count) s) :=
  OutputLoop020D.code_correct i replyBody (replyValue z) 24577 17 (by decide) s
    (reply_step i s z hz) count hc h28

theorem emit_shape (i : Input) (s : State) :
    exec i emitPair s=exec i (replyCode 1536) (exec i EmitTag020D.code (exec i (keyCode 1536) s)) :=
  (CdfStep020A.seqs_append i [set 28 (lit 0),set 21 (lit 0),.loop 1536 (lit 1) keyBody]
    (EmitTag020D.ops++[set 21 (lit 0),.loop 1536 (lit 1) replyBody]) s).trans
    (CdfStep020A.seqs_append i EmitTag020D.ops [set 21 (lit 0),.loop 1536 (lit 1) replyBody]
      (exec i (keyCode 1536) s))

end FT1536.S05.EmitLoops020D
