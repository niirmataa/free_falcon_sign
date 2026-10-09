import Source3.KeygenCallerInit

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Initial caller memory, before the dimension/local initialization fragments.
   No coefficient values, bounds, final legality, transition or heap frame is
   supplied. Block separation reflects the distinct automatic C arrays. -/
namespace FT1536.Source3.KeygenCallerEntry
open C99ArrayReference (State Name)
open C99MemoryReference
open KeygenSearchContext (Context)

structure Initial (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer) : Prop where
  context : s.arrays "fk".toList=some ctx.object
  inputs : ∀ slot, s.arrays (KeygenResidueTrace.names slot).2.toList=some (input slot)
  publicPointer : s.arrays "h".toList=some h
  profile : KeygenSearchContext.M0 s.heap ctx
  table : s.tables "PRIMES3".toList=some primes
  primeObject : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  scratch : KeygenMkgm3Layout.Legal s.heap ctx.scratch
  allocated : ∀ slot, Allocated s.heap (input slot)
  width : ∀ slot, (input slot).elementBytes=2
  scratchSeparate : ∀ slot, ctx.scratch.block≠(input slot).block
  distinct : ∀ a b : Fin 4, a≠b → (input a).block≠(input b).block
  contextSeparate : ∀ slot, ctx.object.block≠(input slot).block
  contextScratch : ctx.scratch.block≠ctx.object.block
  contextTables : ∀ name p, s.tables name=some p → p.block≠ctx.object.block
  inputTables : ∀ slot name p, s.tables name=some p → p.block≠(input slot).block
  publicSeparate : ∀ slot, h.block≠(input slot).block
  publicContext : h.block≠ctx.object.block
  staticLive : ∀ name p, s.tables name=some p → 0<s.heap.size p.block

theorem allocated_live (heap : Memory) (p : ArrayPointer) (source : Allocated heap p) : 0<heap.size p.block := by
  obtain ⟨positive,_,inside,extent,_⟩ := source
  have product : 0<p.elementBytes*p.count := Nat.mul_pos positive (by omega)
  omega
theorem input_not_rt (slot : Fin 4) : (KeygenResidueTrace.names slot).2.toList∉KeygenCallerInit.rtNames := by
  fin_cases slot <;> decide
theorem input_slot (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx s input h primes rev) (slot : Fin 4) :
    (KeygenCallerInit.ready ctx s).arrays (KeygenResidueTrace.names slot).2.toList=some (input slot) :=
  (KeygenCallerInit.ready_slot ctx s _ (input_not_rt slot)).trans (initial.inputs slot)
theorem norm_protected (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx s input h primes rev) (slot : Fin 4) :
    KeygenAttemptNorm.Protected ctx (KeygenCallerInit.ready ctx s) (input slot).block := by
  refine ⟨initial.scratchSeparate slot,?_,initial.inputTables slot⟩
  intro name member p binding
  have block := KeygenCallerInit.ready_rt ctx s name member p binding
  rw [block]
  exact initial.scratchSeparate slot
theorem public_protected (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx s input h primes rev) (slot : Fin 4) :
    KeygenPublicFrame.Outside (KeygenCallerInit.ready ctx s) ["h".toList] (input slot).block := by
  intro name member p binding
  have nameEq := List.mem_singleton.mp member
  subst name
  have pointer : (KeygenCallerInit.ready ctx s).arrays "h".toList=some h :=
    (KeygenCallerInit.ready_slot ctx s _ (by decide)).trans initial.publicPointer
  have equal := Option.some.inj (pointer.symm.trans binding)
  subst p
  exact initial.publicSeparate slot
theorem entry (ctx : Context) (before after : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : KeygenCallerInit.Exec ctx before after) :
    KeygenAttemptMaterial.Entry ctx after (input 0) (input 1) := by
  rw [KeygenCallerInit.exact_state ctx before after initial.profile source]
  exact ⟨initial.contextSeparate 0,initial.contextSeparate 1,initial.distinct 0 1 (by decide),
    allocated_live _ _ (initial.allocated 0),allocated_live _ _ (initial.allocated 1),initial.width 0,initial.width 1,
    KeygenCallerInit.ready_size ctx before,input_slot ctx before input h primes rev initial 0,
    input_slot ctx before input h primes rev initial 1,norm_protected ctx before input h primes rev initial 0,
    norm_protected ctx before input h primes rev initial 1,public_protected ctx before input h primes rev initial 0,
    public_protected ctx before input h primes rev initial 1⟩
theorem root_entry (ctx : Context) (before after : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : KeygenCallerInit.Exec ctx before after) :
    KeygenRootCaller.Legal ctx after input primes rev := by
  rw [KeygenCallerInit.exact_state ctx before after initial.profile source]
  refine ⟨(KeygenCallerInit.ready_slot ctx before _ (by decide)).trans initial.context,
    input_slot ctx before input h primes rev initial,initial.profile,initial.table,initial.primeObject,
    initial.revBinding,initial.revSource,initial.scratch,initial.width,?_,?_,
    ⟨initial.contextScratch,initial.contextTables⟩,
    ⟨initial.scratchSeparate 0,initial.inputTables 0⟩,⟨initial.scratchSeparate 1,initial.inputTables 1⟩⟩
  · intro slot; exact Or.inl (Ne.symm (initial.scratchSeparate slot))
  · intro a b different; exact Or.inl (initial.distinct a b different)
theorem context_norm (ctx : Context) (before after : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : KeygenCallerInit.Exec ctx before after) :
    KeygenAttemptNorm.Protected ctx after ctx.object.block := by
  rw [KeygenCallerInit.exact_state ctx before after initial.profile source]
  refine ⟨initial.contextScratch,?_,initial.contextTables⟩
  intro name member p binding
  rw [KeygenCallerInit.ready_rt ctx before name member p binding]
  exact initial.contextScratch
theorem context_public (ctx : Context) (before after : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : KeygenCallerInit.Exec ctx before after) :
    KeygenPublicFrame.Outside after ["h".toList] ctx.object.block := by
  rw [KeygenCallerInit.exact_state ctx before after initial.profile source]
  intro name member p binding
  have nameEq := List.mem_singleton.mp member
  subst name
  have pointer : (KeygenCallerInit.ready ctx before).arrays "h".toList=some h :=
    (KeygenCallerInit.ready_slot ctx before _ (by decide)).trans initial.publicPointer
  have equal := Option.some.inj (pointer.symm.trans binding)
  subst p
  exact initial.publicContext

end FT1536.Source3.KeygenCallerEntry
