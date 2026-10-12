import EmitPredicates020D
import EncodedOutput020D

set_option maxRecDepth 8192
namespace FT1536.S05.ActualEmit020D
open WordRAM020 PairProgram020 ReadSemantics020A BufferField020D OutputValues020D ActualScatter020D
open FT1536.Relation
attribute [local irreducible] exec loopState List.ofFn

def referencePair (h : Rq) (z : StandaloneRuntime019.CachedBox) :=
  (StandaloneRuntime019.keyView (StandaloneRuntime019.challenge (StandaloneRuntime019.saveKey h) z),
    some (fun p : Fin 768 => z.2[p.val]))

theorem from_post (h : Rq) (z : StandaloneRuntime019.CachedBox) (s t : State)
    (post : EmitPredicates020D.Post z (fun r => (StandaloneRuntime019.Scatter.multiply h (noise z))[r.val]) s t) :
    List.ofFn t.out=PairEncoding020.encode (referencePair h z) ∧ t.fault=s.fault :=
  ⟨EncodedOutput020D.encode_correct t.out _ z _ post.1
    (fun j => congrArg ZMod.val (key_reference h z j)) post.2.1 post.2.2.1,post.2.2.2.2⟩

/-- The original emitPair writes exactly the original019 full pair encoding. -/
theorem emit_correct (i : Input) (s : State) (h : Rq) (z : StandaloneRuntime019.CachedBox)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z)
    (hv : Holds s (fun r => (StandaloneRuntime019.Scatter.multiply h (noise z))[r.val])) :
    List.ofFn (exec i emitPair s).out=PairEncoding020.encode (referencePair h z) ∧
      (exec i emitPair s).fault=s.fault :=
  from_post h z s _ (EmitPredicates020D.emit_correct i s z _ hz hv)

end FT1536.S05.ActualEmit020D
