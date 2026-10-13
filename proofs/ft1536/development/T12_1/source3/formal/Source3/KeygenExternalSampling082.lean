import Source3.KeygenSecretComplete081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenExternalSampling082
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open ShakeExtractFrame (SameBlock)

/-- Structural separation of a live caller object from the source write
    destinations and static tables; no preservation assertion is included. -/
structure Outside (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer)
    (h : ArrayPointer) (block : Nat) : Prop where
  context : ctx.object.block≠block
  scratch : ctx.scratch.block≠block
  inputs : ∀ slot, (input slot).block≠block
  publicBlock : h.block≠block
  tables : KeygenPublicFrame.Tables s block
  live : 0<s.heap.size block

theorem moved (ctx : Context) (s t : State) (input : Fin 4 → ArrayPointer) (h : ArrayPointer) (block : Nat)
    (outside : Outside ctx s input h block) (tables : t.tables=s.tables) (sizes : t.heap.size=s.heap.size) :
    Outside ctx t input h block :=
  ⟨outside.context,outside.scratch,outside.inputs,outside.publicBlock,
    KeygenMakeAttemptSpine.tables_same s t block tables.symm outside.tables,by rw [sizes]; exact outside.live⟩

theorem prepared (ctx : Context) (s : State) (i : Nat) (input : Fin 4 → ArrayPointer)
    (h : ArrayPointer) (block : Nat) (outside : Outside ctx s input h block) :
    Outside ctx (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced s i)) input h block :=
  moved ctx s _ input h block outside rfl rfl

theorem norm_prepared (ctx : Context) (s : State) (i : Nat) (input : Fin 4 → ArrayPointer)
    (h : ArrayPointer) (block : Nat) (outside : Outside ctx s input h block) :
    KeygenAttemptNorm.Protected ctx (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced s i)) block := by
  refine ⟨outside.scratch,?_,outside.tables⟩
  intro name member p binding
  rw [KeygenMakeSampling.prepared_rt ctx (KeygenCapWords.advanced s i) name member p binding]
  exact outside.scratch

theorem sampler (ctx : Context) (before after : State) (name : String) (dst : ArrayPointer) (block : Nat)
    (source : KeygenSamplerContext.Call ctx before name after)
    (contextOutside : ctx.object.block≠block) (destinationOutside : dst.block≠block)
    (live : 0<before.heap.size block) (size : C99CountedWords.Limit before)
    (pointer : before.arrays name.toList=some dst) : SameBlock before.heap after.heap block := by
  cases source with
  | run resolved run =>
    exact KeygenSamplerCalls.frame (KeygenSamplerContext.rng ctx) before after name dst block
      contextOutside destinationOutside live size pointer run

theorem two_samplers (ctx : Context) (before middle after : State) (input : Fin 4 → ArrayPointer)
    (h : ArrayPointer) (block : Nat) (outside : Outside ctx before input h block)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1))
    (first : KeygenSamplerContext.Call ctx before "f" middle)
    (second : KeygenSamplerContext.Call ctx middle "g" after) : SameBlock before.heap after.heap block := by
  have one := sampler ctx before middle "f" (input 0) block first outside.context (outside.inputs 0)
    outside.live entry.size entry.fPointer
  have size : C99CountedWords.Limit middle :=
    (congrFun (KeygenCallerTransport.sampler_locals _ _ _ _ first) _).trans entry.size
  have pointer : middle.arrays "g".toList=some (input 1) :=
    (congrFun (KeygenAttemptMaterial.sampler_slots _ _ _ _ first).1 _).trans entry.gPointer
  have two := sampler ctx middle after "g" (input 1) block second outside.context (outside.inputs 1)
    (by rw [one.1]; exact outside.live) size pointer
  exact KeygenPublicForeign081.same_trans _ _ _ block one two

theorem resultants (before : State) (out : Result) (source : KeygenResultantGate.Exec before out) (block : Nat) :
    SameBlock before.heap out.state.heap block := by
  have stable := (KeygenAttemptMaterial.resultants before out source).2
  have bytes := KeygenResultantGate.bytes before out source
  exact ⟨stable.size,stable.writable,fun offset => congrFun (congrFun bytes block) offset⟩

theorem ternary (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer)
    (h : ArrayPointer) (block : Nat) (outside : Outside ctx before input h block)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1))
    (shield : KeygenAttemptNorm.Protected ctx before block)
    (source : KeygenCallerPrefix.Ternary ctx before out) : SameBlock before.heap out.state.heap block := by
  cases source with
  | resultantRejected middle sampled result first second gate rejected =>
    exact KeygenPublicForeign081.same_trans _ _ _ block
      (two_samplers ctx before middle sampled input h block outside entry first second)
      (resultants sampled out gate block)
  | norm middle sampled res result first second gate norm =>
    have sampling := two_samplers ctx before middle sampled input h block outside entry first second
    have resultant := resultants sampled ⟨res,.normal⟩ gate block
    have slots := KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second)
        (KeygenAttemptMaterial.resultants sampled ⟨res,.normal⟩ gate).1)
    have shieldRes := KeygenAttemptMaterial.protected_slots ctx before res block slots shield
    have stable := KeygenAttemptNorm.stable ctx res out norm
    have normFrame : SameBlock res.heap out.state.heap block :=
      ⟨stable.size,stable.writable,KeygenAttemptNorm.bytes ctx res out norm block shieldRes⟩
    exact KeygenPublicForeign081.same_trans _ _ _ block sampling
      (KeygenPublicForeign081.same_trans _ _ _ block resultant normFrame)

end FT1536.Source3.KeygenExternalSampling082
