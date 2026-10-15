import Source3.KeygenSearchFrame133
import Source3.KeygenSearchPreservation133
import Source3.KeygenSearchEmbedding133
import Source3.KeygenSearchDeterminism133
import Source3.KeygenNormSource094

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Explicit source revision: only bound initialization uses the extended
   scalar closure. Raw norm/GS computation and rejection gates stay fixed. -/
namespace FT1536.Source3.KeygenAttemptNorm133
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSearchExec (Stmt)
open KeygenMemoryStability (Stable)
open KeygenAttemptNorm (boundCode writable bound_checked compose tables_after raw_frame gs_frame raw_stable gs_stable)

abbrev GS := KeygenAttemptNorm.GS
abbrev Protected := KeygenAttemptNorm.Protected
abbrev Frame := KeygenAttemptNorm.Frame

inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | rawRejected (bounded : State) (out : Result)
      (initial : KeygenSearchExtended133.Exec ctx boundCode before ⟨bounded,.normal⟩)
      (raw : KeygenNormFrame.Exec ctx bounded out) (rejected : out.flow=.continueLoop) : Exec ctx before out
  | gs (bounded raw : State) (out : Result)
      (initial : KeygenSearchExtended133.Exec ctx boundCode before ⟨bounded,.normal⟩)
      (norm : KeygenNormFrame.Exec ctx bounded ⟨raw,.normal⟩) (gs : GS ctx raw out) : Exec ctx before out

theorem search_frame (ctx : Context) (code : Stmt) (before : State) (out : Result)
    (source : KeygenSearchExtended133.Exec ctx code before out) (checked : KeygenSearchFrame.only writable code=true)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before writable block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset)
    (scratch : C99PointerFootprint.PointOutside ctx.scratch block offset) : Frame before out block offset :=
  KeygenSearchFrame133.body_frame ctx code before out source writable checked block offset outside tables scratch
theorem frame (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before writable block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset)
    (scratch : C99PointerFootprint.PointOutside ctx.scratch block offset) : Frame before out block offset := by
  cases source with
  | rawRejected bounded out initial raw rejected =>
    have a := search_frame ctx _ _ _ initial bound_checked block offset outside tables scratch
    exact compose _ _ _ block offset a (raw_frame ctx _ _ raw block offset a.1 (tables_after _ _ _ _ a tables) scratch)
  | gs bounded raw out initial norm gs =>
    have a := search_frame ctx _ _ _ initial bound_checked block offset outside tables scratch
    have b := raw_frame ctx _ _ norm block offset a.1 (tables_after _ _ _ _ a tables) scratch
    exact compose _ _ _ block offset a (compose _ _ _ block offset b
      (gs_frame ctx _ _ gs block offset b.1 (tables_after _ _ _ _ b (tables_after _ _ _ _ a tables)) scratch))
theorem bytes (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (block : Nat) (separated : Protected ctx before block) :
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  intro offset
  exact (frame ctx before out source block offset
    (fun name member p hp => Or.inl (Ne.symm (separated.2.1 name member p hp)))
    (fun name p hp => Or.inl (Ne.symm (separated.2.2 name p hp))) (Or.inl (Ne.symm separated.1))).2.2
theorem material (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out)
    (p : ArrayPointer) (separated : Protected ctx before p.block) (vector : Geometry.Vec)
    (represented : KeygenMaterial.Represents before.heap p vector) : KeygenMaterial.Represents out.state.heap p vector := by
  have keep := bytes ctx before out source p.block separated
  intro i
  exact ⟨fun b => (keep _).trans ((represented i).1 b),fun b => (keep _).trans ((represented i).2 b)⟩
theorem stable (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out) : Stable before.heap out.state.heap := by
  cases source with
  | rawRejected bounded out initial raw rejected =>
    exact KeygenMemoryStability.trans _ _ _
      (KeygenSearchPreservation133.stable _ _ _ _ initial) (raw_stable _ _ _ raw)
  | gs bounded raw out initial norm gs =>
    exact KeygenMemoryStability.trans _ _ _
      (KeygenSearchPreservation133.stable _ _ _ _ initial) (KeygenMemoryStability.trans _ _ _ (raw_stable _ _ _ norm) (gs_stable _ _ _ gs))


theorem previous (ctx : Context) (before : State) (out : Result)
    (source : KeygenAttemptNorm.Exec ctx before out) : Exec ctx before out := by
  cases source with
  | rawRejected bounded out initial raw rejected =>
      exact .rawRejected bounded out (KeygenSearchEmbedding133.execution _ _ _ _ initial) raw rejected
  | gs bounded raw out initial norm gram =>
      exact .gs bounded raw out (KeygenSearchEmbedding133.execution _ _ _ _ initial) norm gram

theorem slots (ctx : Context) (before : State) (out : Result) (source : Exec ctx before out) :
    KeygenAttemptSlots.Slots before out.state := by
  cases source with
  | rawRejected bounded out initial raw rejected =>
      exact KeygenAttemptSlots.trans _ _ _
        (KeygenSearchPreservation133.search _ _ _ _ initial KeygenAttemptSlots.bound_checked)
        (KeygenAttemptSlots.raw _ _ _ raw)
  | gs bounded middle out initial raw gram =>
      exact KeygenAttemptSlots.trans _ _ _
        (KeygenSearchPreservation133.search _ _ _ _ initial KeygenAttemptSlots.bound_checked)
        (KeygenAttemptSlots.trans _ _ _ (KeygenAttemptSlots.raw _ _ _ raw) (KeygenAttemptSlots.gs _ _ _ gram))

theorem bound_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenSearchExtended133.Exec ctx boundCode before a)
    (second : KeygenSearchExtended133.Exec ctx boundCode before b) : a=b :=
  KeygenSearchDeterminism133.execution ctx boundCode before a b first second

theorem unique (ctx : Context) (before : State) (a b : Result)
    (first : Exec ctx before a) (second : Exec ctx before b) : a=b := by
  cases first <;> cases second
  all_goals grind only [bound_unique, KeygenNormSource094.raw_unique, KeygenNormSource094.gs_unique]

noncomputable def norm (ctx : Context) (before : State) : Part Result where
  Dom := ∃ out, Exec ctx before out
  get domain := Classical.choose domain

theorem norm_spec (ctx : Context) (before : State) (out : Result) :
    out ∈ norm ctx before ↔ Exec ctx before out := by
  constructor
  · rintro ⟨domain,equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result, Exec ctx before result := ⟨out,source⟩
    exact ⟨domain,unique ctx before (Classical.choose domain) out (Classical.choose_spec domain) source⟩

end FT1536.Source3.KeygenAttemptNorm133
