import Source3.ShakePointFrame
import Source3.KeygenResultantGate

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Bind the sampler's actual fk argument to the embedded RNG subobject.
   The incoming context/profile bytes are legal input data. Their retention
   is proved through the executed SHAKE stores, not assumed as a frame. -/
namespace FT1536.Source3.KeygenSamplerContext
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSamplerSource
open ShakePointFrame (Same)

def rng (ctx : Context) : ShakeExtractSource.Layout := ⟨ctx.object.block,ctx.object.offset+8⟩
inductive Resolve (ctx : Context) (s : State) : Prop where
  | address (actual : C99ArrayReference.Pointer s "fk".toList C99ProcedureParser.zero ctx.object)
      (legal : KeygenSearchContext.ObjectLegal s.heap ctx) : Resolve ctx s
inductive Call (ctx : Context) (before : State) (name : String) : State → Prop where
  | run (after : State) (resolved : Resolve ctx before)
      (source : KeygenSamplerCalls.Call (rng ctx) before (KeygenSamplerCalls.arguments name) after) :
      Call ctx before name after
theorem actual_calls : (Pinned.keygenLines.drop 7887).take 2 =
    ["\t\t\tsample_true_ternary_secret(fk, f, n);\n","\t\t\tsample_true_ternary_secret(fk, g, n);\n"] :=
  KeygenSamplerCalls.calls_source
theorem address_source : Pinned.keygenLines[4769]?=some "\t\t\t\trb = get_rng_u64(&fk->rng);\n" := by decide
theorem rng_layout (ctx : Context) :
    (ShakeExtractSource.field (rng ctx) .dbuf).base=ctx.object.offset+8 ∧
    (ShakeExtractSource.field (rng ctx) .dptr).base=ctx.object.offset+208 ∧
    (ShakeExtractSource.field (rng ctx) .rate).base=ctx.object.offset+216 ∧
    (ShakeExtractSource.field (rng ctx) .a).base=ctx.object.offset+224 ∧
    (ShakeExtractSource.field (rng ctx) .a).base+200=ctx.object.offset+424 := by
  simp [rng,ShakeExtractSource.field,Nat.add_assoc]
def OutsideRng (ctx : Context) (offset : Nat) : Prop := offset<ctx.object.offset+8 ∨ ctx.object.offset+424≤offset
theorem fields_outside (ctx : Context) (offset : Nat) (outside : OutsideRng ctx offset) :
    ∀ member, ShakeBlock.Outside (ShakeExtractSource.field (rng ctx) member) ctx.object.block offset := by
  intro member
  cases member <;> simp only [ShakeBlock.Outside,ShakeExtractSource.field,rng] <;> dsimp [OutsideRng] at outside <;> omega
theorem refill (layout : ShakeExtractSource.Layout) (before after : State) (block offset : Nat)
    (fields : ∀ member, ShakeBlock.Outside (ShakeExtractSource.field layout member) block offset)
    (live : 0<before.heap.size block) (source : Refill layout before after) : Same before.heap after.heap block offset := by
  cases source with
  | skip => exact ⟨rfl,rfl,rfl⟩
  | fill drawn after v w ty old guard nonzero declared draw bits =>
    have keep := ShakePointFrame.rng layout before drawn w draw block offset live fields
    have same := (C99ModularFrame.source_frame assignBits _ ⟨after,.normal⟩ bits (by decide)).1
    change after.heap=drawn.heap at same
    rw [same]
    exact keep
theorem inner (layout : ShakeExtractSource.Layout) (before after : State) (dst : ArrayPointer) (block offset : Nat)
    (fields : ∀ member, ShakeBlock.Outside (ShakeExtractSource.field layout member) block offset)
    (separated : dst.block≠block) (source : Inner layout before after)
    (live : 0<before.heap.size block) (binding : before.arrays "v".toList=some dst) : Same before.heap after.heap block offset := by
  induction source with
  | accepted before refilled after ref tail =>
    have first := refill layout before refilled block offset fields live ref
    have ptr := (congrFun (KeygenSamplerInner.refill_control layout before refilled ref).2.2 _).trans binding
    have last := KeygenSamplerFrame.tail_frame refilled _ dst block separated ptr tail
    exact ShakePointFrame.trans _ _ _ block offset first ⟨last.1,last.2.1,last.2.2 offset⟩
  | rejected before refilled next after ref tail rest ih =>
    have first := refill layout before refilled block offset fields live ref
    have control := KeygenSamplerInner.control_trans before refilled next
      (KeygenSamplerInner.refill_control layout before refilled ref) (KeygenSamplerInner.tail_control refilled _ tail)
    have ptr := (congrFun (KeygenSamplerInner.refill_control layout before refilled ref).2.2 _).trans binding
    have last := KeygenSamplerFrame.tail_frame refilled _ dst block separated ptr tail
    have one := ShakePointFrame.trans _ _ _ block offset first ⟨last.1,last.2.1,last.2.2 offset⟩
    exact ShakePointFrame.trans _ _ _ block offset one
      (ih (by rw [one.1]; exact live) ((congrFun control.2.2 _).trans binding))
theorem outer (layout : ShakeExtractSource.Layout) (before after : State) (dst : ArrayPointer) (block offset : Nat)
    (fields : ∀ member, ShakeBlock.Outside (ShakeExtractSource.field layout member) block offset)
    (separated : dst.block≠block) (source : Outer layout before after)
    (live : 0<before.heap.size block) (binding : before.arrays "v".toList=some dst) : Same before.heap after.heap block offset := by
  induction source with
  | done => exact ⟨rfl,rfl,rfl⟩
  | next before declared next updated after v guard nonzero declaration iteration update rest ih =>
    have hd := KeygenSamplerBounds.declaration_result before declared declaration
    subst declared
    have one := inner layout _ next dst block offset fields separated iteration live binding
    have arrays := (KeygenSamplerInner.inner_control layout _ next iteration).2.2
    have inc := C99ModularFrame.source_frame increment (closedScope before next) ⟨updated,.normal⟩ update (by decide)
    have heap : updated.heap=next.heap := inc.1
    have current : Same before.heap updated.heap block offset := by rw [heap]; exact one
    have ptr := (congrFun inc.2 _).trans ((congrFun arrays _).trans binding)
    exact ShakePointFrame.trans _ _ _ block offset current (ih (by rw [current.1]; exact live) ptr)
theorem sampler (layout : ShakeExtractSource.Layout) (before after : State) (dst : ArrayPointer) (block offset : Nat)
    (fields : ∀ member, ShakeBlock.Outside (ShakeExtractSource.field layout member) block offset)
    (separated : dst.block≠block) (source : Exec layout before after)
    (live : 0<before.heap.size block) (binding : before.arrays "v".toList=some dst) : Same before.heap after.heap block offset := by
  cases source with
  | run declared ready after setup initialization loop =>
    have pro := C99ModularFrame.source_frame prologue before ⟨declared,.normal⟩ setup (by decide)
    have init := C99ModularFrame.source_frame initial declared ⟨ready,.normal⟩ initialization (by decide)
    have heap : ready.heap=before.heap := init.1.trans pro.1
    have ptr := (congrFun init.2 _).trans ((congrFun pro.2 _).trans binding)
    have result := outer layout ready after dst block offset fields separated loop (by rw [heap]; exact live) ptr
    rw [heap] at result
    exact result
theorem context (ctx : Context) (before after : State) (name : String) (dst : ArrayPointer)
    (source : Call ctx before name after) (separated : dst.block≠ctx.object.block)
    (size : C99CountedWords.Limit before) (pointer : before.arrays name.toList=some dst)
    (offset : Nat) (outside : OutsideRng ctx offset) : Same before.heap after.heap ctx.object.block offset := by
  cases source with
  | run resolved source =>
    cases resolved with
    | address actual legal =>
      have live : 0<before.heap.size ctx.object.block := by have := legal.2.1; omega
      cases source with
      | run entry after binding body =>
        have fields := KeygenSamplerCalls.binding_entry before entry name dst size pointer binding
        have heap := C99ArrayReference.bind_heap _ _ _ _ binding
        have result := sampler (rng ctx) entry after dst ctx.object.block offset (fields_outside ctx offset outside)
          separated body (by rw [heap]; exact live) fields.2
        rw [heap] at result
        exact result
theorem profile (ctx : Context) (before after : State) (name : String) (dst : ArrayPointer)
    (source : Call ctx before name after) (separated : dst.block≠ctx.object.block)
    (size : C99CountedWords.Limit before) (pointer : before.arrays name.toList=some dst)
    (profile : KeygenSearchContext.M0 before.heap ctx) : KeygenSearchContext.M0 after.heap ctx := by
  have sizes := (context ctx before after name dst source separated size pointer 0 (Or.inl (by omega))).1
  constructor
  · apply Gate00Memory.load32_transport _ _ _ _ profile.1 sizes
    intro i
    exact (context ctx before after name dst source separated size pointer _ (Or.inl (by
      have := i.isLt; dsimp [KeygenSearchContext.field,ArrayPointer.offset]; omega))).2.2
  · apply Gate00Memory.load32_transport _ _ _ _ profile.2 sizes
    intro i
    exact (context ctx before after name dst source separated size pointer _ (Or.inl (by
      have := i.isLt; dsimp [KeygenSearchContext.field,ArrayPointer.offset]; omega))).2.2
theorem two_calls (ctx : Context) (before middle after : State) (f g : ArrayPointer)
    (fOutside : ctx.object.block≠f.block) (gOutside : ctx.object.block≠g.block) (separate : f.block≠g.block)
    (fLive : 0<before.heap.size f.block) (gLive : 0<before.heap.size g.block)
    (fWidth : f.elementBytes=2) (gWidth : g.elementBytes=2)
    (size : C99CountedWords.Limit before) (fPointer : before.arrays "f".toList=some f)
    (gPointer : before.arrays "g".toList=some g)
    (first : Call ctx before "f" middle) (second : Call ctx middle "g" after) :
    ∃ fv gv : Geometry.Vec, KeygenMaterial.Represents after.heap f fv ∧ KeygenIntegerLift.Bound fv 1 ∧
      KeygenMaterial.Represents after.heap g gv ∧ KeygenIntegerLift.Bound gv 1 := by
  cases first with
  | run resolved first =>
    cases second with
    | run resolved second =>
      exact KeygenSamplerCalls.two_calls (rng ctx) before middle after f g fOutside gOutside separate fLive gLive
        fWidth gWidth size fPointer gPointer first second

end FT1536.Source3.KeygenSamplerContext
