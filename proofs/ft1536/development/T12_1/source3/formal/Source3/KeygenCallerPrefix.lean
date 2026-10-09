import Source3.KeygenCallerTransport

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The same sampled attempt, with the ternary local scope closed BEFORE the
   actual public call. All rejection edges remain; no final legality or
   coefficient-bound premise is added to execution. -/
namespace FT1536.Source3.KeygenCallerPrefix
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenAttemptMaterial (Material PublicGate)
open KeygenRootCaller (Legal)
open KeygenCallerEntry (Initial)
open KeygenAttemptSlots (Slots)

inductive Ternary (ctx : Context) (before : State) : Result → Prop where
  | resultantRejected (middle sampled : State) (out : Result)
      (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled)
      (gate : KeygenResultantGate.Exec sampled out) (rejected : out.flow=.continueLoop) : Ternary ctx before out
  | norm (middle sampled res : State) (out : Result)
      (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled)
      (resultants : KeygenResultantGate.Exec sampled ⟨res,.normal⟩)
      (norm : KeygenAttemptNorm.Exec ctx res out) : Ternary ctx before out
theorem ternary_slots (ctx : Context) (before : State) (out : Result) (source : Ternary ctx before out) : Slots before out.state := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second) (KeygenAttemptMaterial.resultants _ _ gate).1)
  | norm middle sampled res out first second resultants norm =>
    exact KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second)
        (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.resultants _ _ resultants).1 (KeygenAttemptSlots.norm _ _ _ norm)))
theorem ternary_size (ctx : Context) (before : State) (out : Result) (f g : ArrayPointer)
    (entry : KeygenAttemptMaterial.Entry ctx before f g) (source : Ternary ctx before out) : out.state.heap.size=before.heap.size := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact (KeygenAttemptMaterial.resultants _ _ gate).2.size.trans
      (KeygenAttemptMaterial.sampling_metadata ctx before middle sampled f g entry first second).1
  | norm middle sampled res out first second resultants norm =>
    exact (KeygenAttemptNorm.stable _ _ _ norm).size.trans ((KeygenAttemptMaterial.resultants _ _ resultants).2.size.trans
      (KeygenAttemptMaterial.sampling_metadata ctx before middle sampled f g entry first second).1)
theorem ternary_material (ctx : Context) (before : State) (out : Result) (f g : ArrayPointer)
    (entry : KeygenAttemptMaterial.Entry ctx before f g) (source : Ternary ctx before out) : Material out.state.heap f g := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact KeygenAttemptMaterial.through_resultants _ _ gate f g (KeygenAttemptMaterial.sampled_material ctx before middle sampled f g entry first second)
  | norm middle sampled res out first second resultants norm =>
    have slots := KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second) (KeygenAttemptMaterial.resultants _ _ resultants).1)
    exact KeygenAttemptMaterial.through_norm ctx res out norm f g
      (KeygenAttemptMaterial.protected_slots _ _ _ _ slots entry.fNorm) (KeygenAttemptMaterial.protected_slots _ _ _ _ slots entry.gNorm)
      (KeygenAttemptMaterial.through_resultants _ _ resultants f g (KeygenAttemptMaterial.sampled_material ctx before middle sampled f g entry first second))
theorem ternary_root (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1)) (legal : Legal ctx before input primes rev)
    (primesLive : 0<before.heap.size primes.block) (revLive : 0<before.heap.size rev.block)
    (separate : KeygenAttemptNorm.Protected ctx before ctx.object.block) (source : Ternary ctx before out) : Legal ctx out.state input primes rev := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact KeygenCallerTransport.resultant_root ctx sampled out input primes rev
      (KeygenCallerTransport.sampling_root ctx before middle sampled input primes rev entry legal primesLive revLive first second) gate
  | norm middle sampled res out first second resultants norm =>
    have sampledLegal := KeygenCallerTransport.sampling_root ctx before middle sampled input primes rev entry legal primesLive revLive first second
    have resLegal := KeygenCallerTransport.resultant_root ctx sampled ⟨res,.normal⟩ input primes rev sampledLegal resultants
    have slots := KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ second) (KeygenAttemptMaterial.resultants _ _ resultants).1)
    exact KeygenCallerTransport.norm_root ctx res out input primes rev resLegal
      (KeygenAttemptMaterial.protected_slots _ _ _ _ slots separate) norm

def close (saved after : State) : State := C99ArrayReference.restoreScope saved after ["norm".toList,"bound".toList] KeygenCallerInit.rtNames
theorem close_source : Pinned.keygenLines[8019]?=some "\t\t} else {\n" := by decide
theorem local_scope_source : KeygenSearchParser.declarations KeygenCallerInit.setupCode=
    (["norm".toList,"bound".toList],KeygenCallerInit.rtNames) := KeygenCallerInit.setup_declarations
theorem close_array (saved after : State) (name : Name) (outside : name∉KeygenCallerInit.rtNames) :
    (close saved after).arrays name=after.arrays name := by
  have absent : KeygenCallerInit.rtNames.contains name=false := by
    cases h : KeygenCallerInit.rtNames.contains name with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp h)).elim
  simp only [close,C99ArrayReference.restoreScope,absent,Bool.false_eq_true,ite_false]
theorem close_root (ctx : Context) (saved after : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx after input primes rev) : Legal ctx (close saved after) input primes rev := by
  refine ⟨(close_array saved after _ (by decide)).trans legal.context,?_,legal.profile,legal.table,legal.primeObject,
    legal.revBinding,legal.revSource,legal.scratch,legal.width,legal.separate,legal.disjoint,
    legal.contextProtected,legal.fProtected,legal.gProtected⟩
  intro slot
  exact (close_array saved after _ (KeygenCallerEntry.input_not_rt slot)).trans (legal.inputs slot)
theorem close_public (saved after : State) (block : Nat) (source : KeygenPublicFrame.Outside after ["h".toList] block) :
    KeygenPublicFrame.Outside (close saved after) ["h".toList] block := by
  intro name member p binding
  have equal := List.mem_singleton.mp member
  subst name
  exact source _ (by simp only [List.mem_singleton]) p ((close_array saved after _ (by decide)).symm.trans binding)
inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | rejected (entry : State) (out : Result) (init : KeygenCallerInit.Exec ctx before entry)
      (source : Ternary ctx entry out) (rejected : out.flow=.continueLoop) :
      Exec ctx before ⟨close (KeygenCallerInit.sized before) out.state,.continueLoop⟩
  | publicGate (entry normed : State) (out : Result) (init : KeygenCallerInit.Exec ctx before entry)
      (source : Ternary ctx entry ⟨normed,.normal⟩)
      (publicCall : PublicGate (close (KeygenCallerInit.sized before) normed) out) : Exec ctx before out
theorem ternary_entry_root (ctx : Context) (before entry : State) (out : Result) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (init : KeygenCallerInit.Exec ctx before entry)
    (source : Ternary ctx entry out) : Legal ctx out.state input primes rev := by
  have entryLegal := KeygenCallerEntry.root_entry ctx before entry input h primes rev initial init
  have entryMaterial := KeygenCallerEntry.entry ctx before entry input h primes rev initial init
  have heap : entry.heap=before.heap := by rw [KeygenCallerInit.exact_state ctx before entry initial.profile init]; rfl
  exact ternary_root ctx entry out input primes rev entryMaterial entryLegal
    (by rw [heap]; exact initial.staticLive _ primes initial.table)
    (by rw [heap]; exact initial.staticLive _ rev initial.revBinding)
    (KeygenCallerEntry.context_norm ctx before entry input h primes rev initial init) source
theorem root_legal (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : Exec ctx before out) : Legal ctx out.state input primes rev := by
  cases source with
  | rejected entry out init source rejected =>
    exact close_root ctx _ _ input primes rev (ternary_entry_root ctx before entry out input h primes rev initial init source)
  | publicGate entry normed out init source publicCall =>
    have legal := close_root ctx (KeygenCallerInit.sized before) normed input primes rev (ternary_entry_root ctx before entry ⟨normed,.normal⟩ input h primes rev initial init source)
    have publicOutside := KeygenCallerEntry.context_public ctx before entry input h primes rev initial init
    have outside := close_public (KeygenCallerInit.sized before) normed ctx.object.block (KeygenAttemptMaterial.public_slots _ _ _ (ternary_slots ctx entry _ source) publicOutside)
    cases publicCall with
    | reject after v call zero | accept after v call nonzero =>
      exact KeygenCallerTransport.public_root ctx _ after v input primes rev legal outside call
theorem material (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : Initial ctx before input h primes rev) (source : Exec ctx before out) : Material out.state.heap (input 0) (input 1) := by
  cases source with
  | rejected entry out init source rejected =>
    exact ternary_material ctx entry out (input 0) (input 1) (KeygenCallerEntry.entry ctx before entry input h primes rev initial init) source
  | publicGate entry normed out init source publicCall =>
    have entryMaterial := KeygenCallerEntry.entry ctx before entry input h primes rev initial init
    have slots := ternary_slots ctx entry ⟨normed,.normal⟩ source
    have sizes := ternary_size ctx entry ⟨normed,.normal⟩ (input 0) (input 1) entryMaterial source
    change normed.heap.size=entry.heap.size at sizes
    have legal := close_root ctx (KeygenCallerInit.sized before) normed input primes rev (ternary_entry_root ctx before entry ⟨normed,.normal⟩ input h primes rev initial init source)
    have fOut := close_public (KeygenCallerInit.sized before) normed (input 0).block (KeygenAttemptMaterial.public_slots entry normed _ slots entryMaterial.fPublic)
    have gOut := close_public (KeygenCallerInit.sized before) normed (input 1).block (KeygenAttemptMaterial.public_slots entry normed _ slots entryMaterial.gPublic)
    obtain ⟨f,g,hf,bf,hg,bg⟩ := ternary_material ctx entry ⟨normed,.normal⟩ (input 0) (input 1) entryMaterial source
    cases publicCall with
    | reject after v call zero | accept after v call nonzero =>
      exact ⟨f,g,KeygenPublicSource.material _ after v call (input 0) fOut legal.fProtected.2
          (by change 0<normed.heap.size (input 0).block; rw [sizes]; exact entryMaterial.fLive) f hf,bf,
        KeygenPublicSource.material _ after v call (input 1) gOut legal.gProtected.2
          (by change 0<normed.heap.size (input 1).block; rw [sizes]; exact entryMaterial.gLive) g hg,bg⟩

end FT1536.Source3.KeygenCallerPrefix
