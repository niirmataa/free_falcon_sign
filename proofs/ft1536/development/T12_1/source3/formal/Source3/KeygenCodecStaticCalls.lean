import Source3.KeygenCodecStaticCall
import Source3.KeygenCodecInvocationWindows

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Preserve the original four physical arrays through actual preceding
   codec calls. Exact lengths, decoders and coefficient-WORD transport
   from the mathematical vectors are separate subsequent obligations. -/
namespace FT1536.Source3.KeygenCodecStaticCalls
open C99MemoryReference
open KeygenMakeInvocation (Env inputOf)
open KeygenCodecTypedSegments (Site arguments)
open KeygenCodecStaticMaterial

def Originals (env : Env) (heap : Memory) (inputs : Fin 4 → List (BitVec 16)) : Prop :=
  ∀ j, Words heap (inputOf env j) (inputs j)

def Separate (env : Env) : Prop := ∀ j : Fin 4, (inputOf env j).block≠env.args.privkey.block

theorem allocated_separation (env : Env) (before after : C99ArrayReference.State)
    (allocation : KeygenMakeObjects.Exec 0 before env.blocks after)
    (live : 0<before.heap.size env.args.privkey.block) : Separate env := by
  intro j
  exact Ne.symm (KeygenMakeObjects.fresh_separate 0 before after env.blocks allocation
    ⟨j.val,by have := j.isLt; omega⟩ (by omega) env.args.privkey.block live)

theorem call_preserves (env : Env) (c : Site env) (comp : env.args.comp=1) (separate : Separate env)
    (inputs : Fin 4 → List (BitVec 16)) (original : Originals env c.before.heap inputs) :
    Originals env c.after inputs := by
  have window := KeygenCodecInvocationWindows.site_window env c comp
  intro j
  apply words_preserved (inputOf env j).block c.before.heap c.after
    ⟨window.sizes,fun offset => window.bytes _ offset (Or.inl (separate j))⟩ (inputOf env j) rfl (inputs j)
  exact original j

theorem segment_originals (env : Env) (i : Nat) (s : C99ArrayReference.State)
    (out : C99ProcedureReference.Result) (calls : List (Site env))
    (source : KeygenCodecTypedSegments.Segments env i s out calls)
    (comp : env.args.comp=1) (separate : Separate env) (inputs : Fin 4 → List (BitVec 16))
    (original : Originals env s.heap inputs) :
    ∀ c, c∈calls → Originals env c.before.heap inputs := by
  induction source with
  | done => intro c member; cases member
  | capacity c counter zero =>
    intro d member
    have same : d=c := by simpa using member
    subst d
    exact original
  | next c counter nonzero skoff skoffCell rest ih =>
    intro d member
    rcases List.mem_cons.mp member with same | later
    · subst d; exact original
    · exact ih (call_preserves env c comp separate inputs original) d later

/-- Profiles and source-pointer identities are obtained from the actual
    caller chain. Earlier output writes preserve all original input arrays. -/
theorem chain_static (env : Env) (s : C99ArrayReference.State)
    (headOut out : C99ProcedureReference.Result) (calls : List (Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : KeygenMakeInvocation.Encoding env KeygenMakeSkeChain.chain s headOut)
    (normal : headOut.flow=.normal)
    (source : KeygenCodecTypedSegments.Segments env 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (comp : env.args.comp=1) (separate : Separate env)
    (skeSeparate : env.args.privkey.block≠env.blocks 5)
    (legal : ∀ c, c∈calls → KeygenMakeInvocation.VirtualLegal (c.site.src.block::env.live) env.vb)
    (inputs : Fin 4 → List (BitVec 16)) (lengths : ∀ j, (inputs j).length=1536)
    (original : Originals env headOut.state.heap inputs) :
    ∀ c, c∈calls → KeygenCodecStaticComplete.Outcome
      (arguments env c.before c.index c.after c.ret c.site) c.before.heap c.after
      (KeygenCodecStaticComplete.encoded (inputs c.index)) (.returned c.ret) := by
  have pointers := KeygenCodecTypedSegments.chain_call_material env s headOut out calls cells chain normal source skeSeparate legal
  have profiles := KeygenCodecProfile.chain_profiles env s headOut out calls cells chain source
  have material := segment_originals env 0 _ out calls source comp separate inputs original
  intro c member
  have profile := KeygenCodecProfile.arguments_profile env c (profiles c member)
  have pointer := pointers c member
  apply KeygenCodecStaticCall.call_outcome _ c.before.heap c.after c.ret comp profile.1 profile.2
    (inputOf env c.index) (by simp only [arguments,pointer]) (inputs c.index) (lengths c.index)
    (material c member c.index) _ c.execution
  intro dst held
  have same : dst=KeygenMakeInvocation.byteOff env.args.privkey c.site.skoff.toNat :=
    (Option.some.inj held).symm
  subst dst
  exact separate c.index

end FT1536.Source3.KeygenCodecStaticCalls
