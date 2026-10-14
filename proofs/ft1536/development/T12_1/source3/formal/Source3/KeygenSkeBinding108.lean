import Source3.KeygenCanonicalAddresses108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSkeBinding108
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf SmallSite VirtualLegal)
open KeygenCanonicalAddresses108 (canonical)
open KeygenMakeSkeCells (SkeCellWord)

/-- The known word is established by source stores and their byte frame.
    The read descriptor's liveness is a conclusion, not a premise. -/
theorem material (env : Env) (before : State) (i : Fin 4) (after : Memory) (ret : BitVec 64)
    (site : SmallSite (canonical env) before i after ret) (word : SkeCellWord (canonical env) i before) :
    site.src = inputOf (canonical env) i :=
  KeygenCanonicalAddresses108.read_known env before.heap _ site.src (inputOf (canonical env) i)
    (KeygenMakeInvocation.inputOf_mem_live (canonical env) i) site.srcCell
    ⟨KeygenMakeInvocation.input_canonical (canonical env) i, word⟩

theorem extend (vb : Nat → Nat) (live : List Nat) (block : Nat)
    (legal : VirtualLegal live vb) (known : block ∈ live) : VirtualLegal (block :: live) vb := by
  have subset : ∀ b, b ∈ block :: live → b ∈ live := by
    intro b member
    rcases List.mem_cons.mp member with rfl | tail
    · exact known
    · exact tail
  exact ⟨fun b member => legal.bounded b (subset b member),
    fun a b ha hb equal => legal.distinct a b (subset a ha) (subset b hb) equal⟩

theorem site_addresses (env : Env) (before : State) (i : Fin 4) (after : Memory) (ret : BitVec 64)
    (site : SmallSite (canonical env) before i after ret) (word : SkeCellWord (canonical env) i before) :
    VirtualLegal (site.src.block :: (canonical env).live) (canonical env).vb := by
  have actual := material env before i after ret site word
  rw [actual]
  exact extend _ _ _ (KeygenCanonicalAddresses108.legal env) (KeygenMakeInvocation.inputOf_mem_live _ i)

/-- The existing all-exit source history is sufficient under the concrete
    representation, including the call that returns zero after partial writes. -/
theorem call_histories (env : Env) (before : State) (headOut out : Result)
    (calls : List (KeygenCodecTypedSegments.Site (canonical env)))
    (cells : KeygenMakeInvocation.TailCells (canonical env) before)
    (chain : KeygenMakeInvocation.Encoding (canonical env) KeygenMakeSkeChain.chain before headOut)
    (normal : headOut.flow = .normal)
    (source : KeygenCodecTypedSegments.Segments (canonical env) 0 (KeygenMakeInvocation.initCounter headOut.state) out calls)
    (separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5) :
    ∀ c ∈ calls, c.site.src = inputOf (canonical env) c.index ∧
      VirtualLegal (c.site.src.block :: (canonical env).live) (canonical env).vb := by
  have words := KeygenCodecTypedSegments.chain_call_histories (canonical env) before headOut out calls cells chain normal source separate
  intro c member
  exact ⟨material env c.before c.index c.after c.ret c.site (words c member),
    site_addresses env c.before c.index c.after c.ret c.site (words c member)⟩

theorem addresses (env : Env) (before : State) (out : Result)
    (cells : KeygenMakeInvocation.TailCells (canonical env) before)
    (separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5)
    (source : KeygenSecretTailSource081.Source (canonical env) before out) :
    KeygenSecretTailSource081.Addresses (canonical env) before out source := by
  have history := call_histories env before ⟨source.headState,.normal⟩ ⟨source.segmentState,.normal⟩
    source.privateCalls cells source.prelude rfl source.segments separate
  exact fun c member => (history c member).2

end FT1536.Source3.KeygenSkeBinding108
