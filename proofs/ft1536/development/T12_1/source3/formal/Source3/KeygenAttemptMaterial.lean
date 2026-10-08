import Source3.KeygenAttemptSlots
import Source3.KeygenPublicStability

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Same sampled material through the actual resultant, raw, GS and public
   gates. Entry is at the two sampler calls; earlier caller initialization
   and root-entry legality are deliberately separate pending obligations. -/
namespace FT1536.Source3.KeygenAttemptMaterial
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open KeygenAttemptSlots (Slots)

theorem resultant_slots (before after : State) (args : List C99ArrayReference.Arg) (v : Value)
    (source : KeygenResultantSource.Call before args after v) : Slots before after := by
  cases source; exact ⟨rfl,rfl⟩
theorem resultant_stable (before after : State) (args : List C99ArrayReference.Arg) (v : Value)
    (source : KeygenResultantSource.Call before args after v) : KeygenMemoryStability.Stable before.heap after.heap := by
  have bytes := KeygenResultantSource.bytes _ _ _ _ source
  refine ⟨?_,?_,fun _ _ _ => congrFun (congrFun bytes _) _⟩
  all_goals
    cases source with
    | run bound ready packed reduced out localBlock word v binding fresh initial legal pack read fallthrough tail returned =>
      have a := KeygenMemoryStability.modular _ _ _ initial
      have b := KeygenMemoryStability.word _ _ _ pack
      have c := KeygenMemoryStability.word _ _ _ fallthrough
      have d := KeygenMemoryStability.word _ _ _ tail
      have hh := C99ArrayReference.bind_heap _ _ _ _ binding
      first
      | have shape : out.state.heap.size=(KeygenResultantSource.entry bound localBlock).heap.size :=
          d.size.trans (c.size.trans (b.size.trans a.size))
        funext block
        by_cases eq : block=localBlock
        · simp only [KeygenRngSource.disposed,eq,ite_true]
        · simpa only [KeygenRngSource.disposed,KeygenResultantSource.entry,C99ArrayReference.bindPointer,
            KeygenResultantSource.allocated,eq,ite_false,hh] using congrFun shape block
      | have shape : out.state.heap.writable=(KeygenResultantSource.entry bound localBlock).heap.writable :=
          d.writable.trans (c.writable.trans (b.writable.trans a.writable))
        funext block
        by_cases eq : block=localBlock
        · simp only [KeygenRngSource.disposed,eq,ite_true]
        · simpa only [KeygenRngSource.disposed,KeygenResultantSource.entry,C99ArrayReference.bindPointer,
            KeygenResultantSource.allocated,eq,ite_false,hh] using congrFun shape block
theorem resultants (before : State) (out : Result) (source : KeygenResultantGate.Exec before out) :
    Slots before out.state ∧ KeygenMemoryStability.Stable before.heap out.state.heap := by
  cases source with
  | firstReject after v first zero => exact ⟨resultant_slots _ _ _ _ first,resultant_stable _ _ _ _ first⟩
  | secondReject middle after x y first nonzero second zero
  | accepted middle after x y first nonzero second nonzero' =>
    exact ⟨KeygenAttemptSlots.trans _ _ _ (resultant_slots _ _ _ _ first) (resultant_slots _ _ _ _ second),
      KeygenMemoryStability.trans _ _ _ (resultant_stable _ _ _ _ first) (resultant_stable _ _ _ _ second)⟩
theorem sampler_slots (ctx : Context) (before after : State) (name : String) (source : KeygenSamplerContext.Call ctx before name after) : Slots before after := by
  cases source with
  | run resolved source => cases source; exact ⟨rfl,rfl⟩
def publicSelected : Option (List String) := KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 8082).take 10)
theorem public_gate_source : publicSelected=some ["\t\tif (!falcon_compute_public(h, f, g, logn, ter)) {\n",
    "\t\t\tcontinue;\n","\t\t}\n"] := by decide
inductive PublicGate (before : State) : Result → Prop where
  | reject (after : State) (v : Value) (source : KeygenPublicSource.Call before after v) (zero : v.integer=0) :
      PublicGate before ⟨after,.continueLoop⟩
  | accept (after : State) (v : Value) (source : KeygenPublicSource.Call before after v) (nonzero : v.integer≠0) :
      PublicGate before ⟨after,.normal⟩
inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | resultantRejected (middle sampled : State) (out : Result)
      (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled)
      (gate : KeygenResultantGate.Exec sampled out) (rejected : out.flow=.continueLoop) : Exec ctx before out
  | normRejected (middle sampled res : State) (out : Result)
      (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled)
      (resultants : KeygenResultantGate.Exec sampled ⟨res,.normal⟩)
      (norm : KeygenAttemptNorm.Exec ctx res out) (rejected : out.flow=.continueLoop) : Exec ctx before out
  | publicGate (middle sampled res normed : State) (out : Result)
      (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled)
      (resultants : KeygenResultantGate.Exec sampled ⟨res,.normal⟩)
      (norm : KeygenAttemptNorm.Exec ctx res ⟨normed,.normal⟩) (publicGate : PublicGate normed out) : Exec ctx before out
structure Entry (ctx : Context) (s : State) (f g : ArrayPointer) : Prop where
  fOutside : ctx.object.block≠f.block
  gOutside : ctx.object.block≠g.block
  separate : f.block≠g.block
  fLive : 0<s.heap.size f.block
  gLive : 0<s.heap.size g.block
  fWidth : f.elementBytes=2
  gWidth : g.elementBytes=2
  size : C99CountedWords.Limit s
  fPointer : s.arrays "f".toList=some f
  gPointer : s.arrays "g".toList=some g
  fNorm : KeygenAttemptNorm.Protected ctx s f.block
  gNorm : KeygenAttemptNorm.Protected ctx s g.block
  fPublic : KeygenPublicFrame.Outside s ["h".toList] f.block
  gPublic : KeygenPublicFrame.Outside s ["h".toList] g.block
theorem protected_slots (ctx : Context) (before after : State) (block : Nat) (slots : Slots before after)
    (separated : KeygenAttemptNorm.Protected ctx before block) : KeygenAttemptNorm.Protected ctx after block := by
  simpa only [KeygenAttemptNorm.Protected,slots.1,slots.2] using separated
theorem public_slots (before after : State) (block : Nat) (slots : Slots before after)
    (outside : KeygenPublicFrame.Outside before ["h".toList] block) : KeygenPublicFrame.Outside after ["h".toList] block := by
  simpa only [KeygenPublicFrame.Outside,slots.1] using outside
theorem sampling_metadata (ctx : Context) (before middle after : State) (f g : ArrayPointer) (entry : Entry ctx before f g)
    (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" after) :
    after.heap.size=before.heap.size ∧ after.heap.writable=before.heap.writable := by
  cases first with
  | run resolved first =>
    cases second with
    | run resolved second =>
      have a := KeygenSamplerCalls.frame (KeygenSamplerContext.rng ctx) before middle "f" f g.block entry.gOutside
        entry.separate entry.gLive entry.size entry.fPointer first
      have slots := KeygenSamplerCalls.slots _ _ _ _ first
      have b := KeygenSamplerCalls.frame (KeygenSamplerContext.rng ctx) middle after "g" g f.block entry.fOutside
        (Ne.symm entry.separate) (by rw [a.1]; exact entry.fLive)
        ((congrFun slots.1 _).trans entry.size) ((congrFun slots.2 _).trans entry.gPointer) second
      exact ⟨b.1.trans a.1,b.2.1.trans a.2.1⟩
def Material (heap : Memory) (f g : ArrayPointer) : Prop := ∃ fv gv : Geometry.Vec,
  KeygenMaterial.Represents heap f fv ∧ KeygenIntegerLift.Bound fv 1 ∧
  KeygenMaterial.Represents heap g gv ∧ KeygenIntegerLift.Bound gv 1
theorem sampled_material (ctx : Context) (before middle sampled : State) (f g : ArrayPointer) (entry : Entry ctx before f g)
    (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" sampled) : Material sampled.heap f g :=
  KeygenSamplerContext.two_calls ctx before middle sampled f g entry.fOutside entry.gOutside entry.separate
    entry.fLive entry.gLive entry.fWidth entry.gWidth entry.size entry.fPointer entry.gPointer first second
theorem through_resultants (before : State) (out : Result) (source : KeygenResultantGate.Exec before out)
    (f g : ArrayPointer) (material : Material before.heap f g) : Material out.state.heap f g := by
  obtain ⟨fv,gv,hf,bf,hg,bg⟩ := material
  exact ⟨fv,gv,KeygenResultantGate.material _ _ source f fv hf,bf,KeygenResultantGate.material _ _ source g gv hg,bg⟩
theorem through_norm (ctx : Context) (before : State) (out : Result) (source : KeygenAttemptNorm.Exec ctx before out)
    (f g : ArrayPointer) (fp : KeygenAttemptNorm.Protected ctx before f.block) (gp : KeygenAttemptNorm.Protected ctx before g.block)
    (material : Material before.heap f g) : Material out.state.heap f g := by
  obtain ⟨fv,gv,hf,bf,hg,bg⟩ := material
  exact ⟨fv,gv,KeygenAttemptNorm.material _ _ _ source f fp fv hf,bf,KeygenAttemptNorm.material _ _ _ source g gp gv hg,bg⟩
theorem material (ctx : Context) (before : State) (out : Result) (f g : ArrayPointer)
    (entry : Entry ctx before f g) (source : Exec ctx before out) : Material out.state.heap f g := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
    exact through_resultants _ _ gate f g (sampled_material ctx before middle sampled f g entry first second)
  | normRejected middle sampled res out first second resultant norm rejected =>
    have slots := KeygenAttemptSlots.trans _ _ _ (sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (sampler_slots _ _ _ _ second) (resultants _ _ resultant).1)
    exact through_norm ctx res out norm f g (protected_slots ctx before res f.block slots entry.fNorm)
      (protected_slots ctx before res g.block slots entry.gNorm)
      (through_resultants _ _ resultant f g (sampled_material ctx before middle sampled f g entry first second))
  | publicGate middle sampled res normed out first second resultant norm publicCall =>
    have resSlots := KeygenAttemptSlots.trans _ _ _ (sampler_slots _ _ _ _ first)
      (KeygenAttemptSlots.trans _ _ _ (sampler_slots _ _ _ _ second) (resultants _ _ resultant).1)
    have normSlots := KeygenAttemptSlots.trans _ _ _ resSlots (KeygenAttemptSlots.norm _ _ _ norm)
    have fp := protected_slots ctx before res f.block resSlots entry.fNorm
    have gp := protected_slots ctx before res g.block resSlots entry.gNorm
    obtain ⟨fv,gv,hf,bf,hg,bg⟩ := through_norm ctx res _ norm f g fp gp
      (through_resultants _ _ resultant f g (sampled_material ctx before middle sampled f g entry first second))
    have sizes : normed.heap.size=before.heap.size := (KeygenAttemptNorm.stable _ _ _ norm).size.trans
      ((resultants _ _ resultant).2.size.trans (sampling_metadata ctx before middle sampled f g entry first second).1)
    have fOut := public_slots before normed f.block normSlots entry.fPublic
    have gOut := public_slots before normed g.block normSlots entry.gPublic
    have tableSlots : normed.tables=before.tables := normSlots.2
    have fTables : KeygenPublicFrame.Tables normed f.block := by
      simpa only [KeygenPublicFrame.Tables,tableSlots] using entry.fNorm.2.2
    have gTables : KeygenPublicFrame.Tables normed g.block := by
      simpa only [KeygenPublicFrame.Tables,tableSlots] using entry.gNorm.2.2
    cases publicCall with
    | reject after v call zero | accept after v call nonzero =>
      exact ⟨fv,gv,KeygenPublicSource.material _ _ _ call f fOut fTables (by rw [sizes]; exact entry.fLive) fv hf,bf,
        KeygenPublicSource.material _ _ _ call g gOut gTables (by rw [sizes]; exact entry.gLive) gv hg,bg⟩

end FT1536.Source3.KeygenAttemptMaterial
