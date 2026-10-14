import Source3.KeygenSeedClosure089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeedDomain089
open C99ArrayReference (State)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)
open KeygenWholeBytes088 (Domain)

variable {env : Env}

/-- Preservation needed by the existing legal caller domain. It permits
    changes in the RNG/flags and allocation of a previously dead seed block. -/
structure Frame (ctx : Context) (before after : State) : Prop where
  globals : after.globals = before.globals
  tables : after.tables = before.tables
  metadata : ∀ b, 0 < before.heap.size b →
    after.heap.size b = before.heap.size b ∧ after.heap.writable b = before.heap.writable b
  bytes : ∀ b o, 0 < before.heap.size b → KeygenRngFrame.Outside ctx b o →
    after.heap.bytes b o = before.heap.bytes b o

theorem Frame.block (frame : Frame ctx before after) (b : Nat)
    (live : 0 < before.heap.size b) (different : b ≠ ctx.object.block) :
    KeygenMakeObjects.Block before.heap after.heap b :=
  ⟨(frame.metadata b live).1, (frame.metadata b live).2,
    fun o => frame.bytes b o live (Or.inl different)⟩

theorem Frame.load32 (frame : Frame ctx before after) (p : ArrayPointer) (word : BitVec 32)
    (read : Load32 before.heap p word)
    (outside : ∀ i : Fin 4, KeygenRngFrame.Outside ctx p.block (p.offset + i.val)) :
    Load32 after.heap p word := by
  cases read with
  | load bytes allocated width initialized =>
      have live := KeygenCallerEntry.allocated_live before.heap p allocated
      have size := (frame.metadata p.block live).1
      exact .load after.heap p bytes (by simpa only [Allocated, size] using allocated) width
        (fun i => (frame.bytes p.block (p.offset + i.val) live (outside i)).trans (initialized i))

theorem Frame.profile (frame : Frame ctx before after) (profile : KeygenSearchContext.M0 before.heap ctx) :
    KeygenSearchContext.M0 after.heap ctx := by
  constructor
  · apply frame.load32 _ _ profile.1
    intro i
    apply Or.inr ∘ Or.inl
    have bound := i.isLt
    dsimp [KeygenSearchContext.field, ArrayPointer.offset]
    omega
  · apply frame.load32 _ _ profile.2
    intro i
    apply Or.inr ∘ Or.inl
    have bound := i.isLt
    dsimp [KeygenSearchContext.field, ArrayPointer.offset]
    omega

theorem Frame.original (frame : Frame env.ctx before after) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original env.ctx (KeygenMakeArguments.entry before env.args) primes rev) :
    KeygenMakeEntry.Original env.ctx (KeygenMakeArguments.entry after env.args) primes rev := by
  have heapBefore : (KeygenMakeArguments.entry before env.args).heap = before.heap := rfl
  have heapAfter : (KeygenMakeArguments.entry after env.args).heap = after.heap := rfl
  have ctxLive : 0 < before.heap.size env.ctx.object.block :=
    KeygenMakeEntry.object_live env.ctx (KeygenMakeArguments.entry before env.args) primes rev original
  have scratchLive : 0 < before.heap.size env.ctx.scratch.block :=
    KeygenMakeEntry.scratch_live env.ctx (KeygenMakeArguments.entry before env.args) primes rev original
  have ctxSize := (frame.metadata env.ctx.object.block ctxLive).1
  have scratchMeta := frame.metadata env.ctx.scratch.block scratchLive
  have primeFrame := frame.block primes.block (original.staticLive _ _ original.table)
    (original.contextTables _ _ original.table)
  have revFrame := frame.block rev.block (original.staticLive _ _ original.revBinding)
    (original.contextTables _ _ original.revBinding)
  refine ⟨?_, ?_, frame.profile original.profile, ?_,
    KeygenMakeEntry.prime_block _ _ primes primeFrame original.primeObject, ?_,
    KeygenMakeEntry.rev_block _ _ rev revFrame original.revSource, ?_,
    original.contextScratch, ?_, ?_⟩
  · change some env.args.fk = some env.ctx.object
    exact original.context
  · simpa only [heapBefore, heapAfter, KeygenSearchContext.ObjectLegal, ctxSize] using original.objectLegal
  · change after.tables "PRIMES3".toList = some primes
    rw [frame.tables]
    exact original.table
  · change after.tables "REV10".toList = some rev
    rw [frame.tables]
    exact original.revBinding
  · simpa only [heapBefore, heapAfter, KeygenMkgm3Layout.Legal, scratchMeta.1, scratchMeta.2] using original.scratch
  · intro name p binding
    change after.tables name = some p at binding
    rw [frame.tables] at binding
    exact original.contextTables name p binding
  · intro name p binding
    change after.tables name = some p at binding
    rw [frame.tables] at binding
    have live := original.staticLive name p binding
    change 0 < after.heap.size p.block
    rw [(frame.metadata p.block live).1]
    exact live

def Frame.domain (frame : Frame env.ctx before after) (domain : Domain env before) : Domain env after := by
  have scratchLive := KeygenMakeEntry.scratch_live _ _ _ _ domain.rootLegal.original
  have scratchSize := (frame.metadata env.ctx.scratch.block scratchLive).1
  have privateSize := (frame.metadata env.args.privkey.block domain.buffers.privateLive).1
  have privateLengthSize := (frame.metadata env.args.privkeyLen.block domain.buffers.privateLengthLive).1
  have publicMeta := frame.metadata env.args.pubkey.block domain.buffers.publicLive
  have publicLengthSize := (frame.metadata env.args.pubkeyLen.block domain.buffers.publicLengthLive).1
  have lengthFrame := frame.block env.args.pubkeyLen.block domain.buffers.publicLengthLive
    domain.publicLegal.contextLength.symm
  refine ⟨domain.primes, domain.rev,
    ⟨frame.original domain.primes domain.rev domain.rootLegal.original,
      domain.rootLegal.workspaceExtent, domain.rootLegal.workspaceAligned, ?_⟩,
    ⟨?_, ?_, ?_, ?_, domain.buffers.privateLength, domain.buffers.privatePublic,
      domain.buffers.privatePublicLength, domain.buffers.lengthPublic,
      domain.buffers.lengthPublicLength, domain.buffers.publicLength⟩,
    domain.comp, domain.capacity, ⟨?_, domain.publicLegal.capacityBound, ?_,
      domain.publicLegal.contextLength, domain.publicLegal.scratchLength, ?_⟩⟩
  · rw [scratchSize]
    exact domain.rootLegal.workspaceSpace
  · rw [privateSize]
    exact domain.buffers.privateLive
  · rw [privateLengthSize]
    exact domain.buffers.privateLengthLive
  · rw [publicMeta.1]
    exact domain.buffers.publicLive
  · rw [publicLengthSize]
    exact domain.buffers.publicLengthLive
  · exact KeygenSecretObserved081.length_block before.heap after.heap _ _ lengthFrame
      domain.publicLegal.capacityRead
  · exact KeygenPublicEntry082.writable_block before.heap after.heap _ 2880
      publicMeta.1 publicMeta.2 domain.publicLegal.writable
  · simpa only [KeygenPublicFrame.Tables, frame.tables] using domain.publicLegal.tablesLength

theorem seed_input_frame (ctx : Context) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed)
    (fresh : base.heap.size block = 0) : Frame ctx base (KeygenSeedEntry089.caller base block seed) := by
  refine ⟨rfl, rfl, ?_, ?_⟩
  · intro b live
    have different : b ≠ block := by intro equal; subst b; rw [fresh] at live; omega
    have keep := KeygenSeedEntry089.outside_seed base block seed b different
    exact ⟨keep.1, keep.2.1⟩
  · intro b o live outside
    have different : b ≠ block := by intro equal; subst b; rw [fresh] at live; omega
    exact (KeygenSeedEntry089.outside_seed base block seed b different).2.2 o

theorem seeded_frame (env : Env) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed) (after : State)
    (source : KeygenSeedEntry089.Seeded env base block seed after) :
    Frame env.ctx (KeygenSeedEntry089.caller base block seed) after := by
  obtain ⟨out, body, returned, equal⟩ := KeygenSeedEntry089.seeded_body env base block seed after source
  have metadata := KeygenSeedClosure089.seeded_metadata env base block seed after source
  refine ⟨?_, ?_, fun b _ => ⟨congrFun metadata.1 b, congrFun metadata.2 b⟩, ?_⟩
  · rw [equal]
  · rw [equal]
  · intro b o live outside
    exact (KeygenSeedClosure089.seeded_frame env base block seed after source b o outside).2.2

/-- Legal input transport is proved from source effects, rather than
    postulated as a legal-domain field on each sampled execution. -/
def seeded_domain (env : Env) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed) (after : State)
    (domain : Domain env base) (fresh : base.heap.size block = 0)
    (source : KeygenSeedEntry089.Seeded env base block seed after) : Domain env after :=
  (seeded_frame env base block seed after source).domain
    ((seed_input_frame env.ctx base block seed fresh).domain domain)

end FT1536.Source3.KeygenSeedDomain089
