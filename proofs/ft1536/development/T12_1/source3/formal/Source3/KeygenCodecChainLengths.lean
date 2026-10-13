import Source3.KeygenCodecStaticCalls
import Source3.KeygenCodecExactLengths

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact lengths of the four actual STATIC calls, using the SAME original
   physical input lists. Each encoded segment retains its independent padding. -/
namespace FT1536.Source3.KeygenCodecChainLengths
open KeygenMakeInvocation (Env)
open KeygenCodecTypedSegments (Site arguments)
open KeygenCodecStaticCalls
open KeygenCodecStaticLength KeygenCodecExactLengths

/-- Normal completion of the actual source segment chain derives nonzero
    returns; the exact lengths are conclusions, not caller assumptions. -/
theorem chain_lengths (env : Env) (s : C99ArrayReference.State)
    (headOut out : C99ProcedureReference.Result) (calls : List (Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (headNormal : headOut.flow=.normal)
    (source : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (normal : out.flow=.normal) (comp : env.args.comp=1) (separate : Separate env)
    (skeSeparate : env.args.privkey.block≠env.blocks 5)
    (legal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb)
    (inputs : Fin 4 → List (BitVec 16)) (lengths : ∀ j, (inputs j).length=1536)
    (original : Originals env headOut.state.heap inputs) :
    ∀ c, c∈calls → c.ret=BitVec.ofNat 64 (byteLength (inputs c.index)) ∧
      LengthOutcome (arguments env c.before c.index c.after c.ret c.site) c.before.heap c.after
        (inputs c.index) (.returned c.ret) := by
  have outcomes := chain_static env s headOut out calls cells chain headNormal source comp separate skeSeparate legal inputs lengths original
  have nonzero := KeygenCodecNoneDispatch.segments_nonzero env 0 _ out calls source normal
  intro c member
  have outcome := outcome_length _ _ _ (inputs c.index) (.returned c.ret) (outcomes c member)
  exact ⟨nonzero_return _ _ _ (inputs c.index) c.ret outcome (nonzero c member),outcome⟩

/-- Rounding the combined bit count would share padding across segments
    and is false even for four one-coefficient zero lists. -/
theorem independent_padding_required :
    4*byteLength [0]≠byteLength ([0,0,0,0] : List (BitVec 16)) := by decide +kernel

end FT1536.Source3.KeygenCodecChainLengths
