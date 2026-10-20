import Source3.KeygenSamplerFrame
import Source3.KeygenSolverNttCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Calls after resolving the actual fk pointer to its typed rng subobject.
   The enclosing full KeyGen execution must provide that resolution and n;
   neither sampling distributions nor output coefficient bounds are inputs. -/
namespace FT1536.Source3.KeygenSamplerCalls
open C99ArrayReference (State Arg Param Bind)
open C99MemoryReference
open ShakeExtractSource (Layout)

def params : List Param := [.pointer "v".toList,.scalar .uint64 "n".toList]
def arguments (name : String) : List Arg := [.pointer name.toList C99ProcedureParser.zero,.scalar (.var "n".toList)]
theorem calls_source : (Pinned.keygenLines.drop 7887).take 2 =
    ["\t\t\tsample_true_ternary_secret(fk, f, n);\n","\t\t\tsample_true_ternary_secret(fk, g, n);\n"] := by decide

inductive Call (ctx : Layout) (before : State) (args : List Arg) : State → Prop where
  | run (entry after : State) (binding : Bind before params args entry)
      (body : KeygenSamplerSource.Exec ctx entry after) : Call ctx before args {before with heap := after.heap}

theorem binding_entry (before entry : State) (name : String) (p : ArrayPointer)
    (size : C99CountedWords.Limit before) (pointer : before.arrays name.toList=some p)
    (binding : Bind before params (arguments name) entry) :
    C99CountedWords.Limit entry ∧ entry.arrays "v".toList=some p := by
  cases binding with
  | pointer _ _ _ actual _ _ _ address tail =>
    cases tail with
    | scalar _ _ _ _ _ _ value evaluated tail =>
      cases tail
      have hp := KeygenSolverNttCalls.pointer_zero before name p actual pointer address
      have hn := C99CountedWords.variable_exact before "n".toList .uint64 (.uint64 1536) value size evaluated
      subst actual value
      exact ⟨rfl,rfl⟩

theorem slots (ctx : Layout) (before after : State) (args : List Arg) (source : Call ctx before args after) :
    after.locals=before.locals ∧ after.arrays=before.arrays := by cases source; exact ⟨rfl,rfl⟩

theorem material (ctx : Layout) (before after : State) (name : String) (p : ArrayPointer)
    (outside : ctx.block≠p.block) (live : 0<before.heap.size p.block) (width : p.elementBytes=2)
    (size : C99CountedWords.Limit before) (pointer : before.arrays name.toList=some p)
    (source : Call ctx before (arguments name) after) :
    ∃ v : Geometry.Vec, KeygenMaterial.Represents after.heap p v ∧ KeygenIntegerLift.Bound v 1 := by
  cases source with
  | run entry after binding body =>
      have fields := binding_entry before entry name p size pointer binding
      have heap := C99ArrayReference.bind_heap before params (arguments name) entry binding
      exact KeygenSamplerBounds.source_material ctx entry after p outside (by rw [heap]; exact live)
        width fields.1 fields.2 body

theorem frame (ctx : Layout) (before after : State) (name : String) (dst : ArrayPointer) (block : Nat)
    (contextOutside : ctx.block≠block) (destinationOutside : dst.block≠block)
    (live : 0<before.heap.size block) (size : C99CountedWords.Limit before)
    (pointer : before.arrays name.toList=some dst) (source : Call ctx before (arguments name) after) :
    ShakeExtractFrame.SameBlock before.heap after.heap block := by
  cases source with
  | run entry after binding body =>
      have fields := binding_entry before entry name dst size pointer binding
      have heap := C99ArrayReference.bind_heap before params (arguments name) entry binding
      have result := KeygenSamplerFrame.source_frame ctx entry after dst block contextOutside destinationOutside
        (by rw [heap]; exact live) fields.2 body
      rw [heap] at result
      exact result

theorem two_calls (ctx : Layout) (before middle after : State) (f g : ArrayPointer)
    (fOutside : ctx.block≠f.block) (gOutside : ctx.block≠g.block) (separate : f.block≠g.block)
    (fLive : 0<before.heap.size f.block) (gLive : 0<before.heap.size g.block)
    (fWidth : f.elementBytes=2) (gWidth : g.elementBytes=2)
    (size : C99CountedWords.Limit before) (fPointer : before.arrays "f".toList=some f)
    (gPointer : before.arrays "g".toList=some g)
    (first : Call ctx before (arguments "f") middle) (second : Call ctx middle (arguments "g") after) :
    ∃ fv gv : Geometry.Vec,
      KeygenMaterial.Represents after.heap f fv ∧ KeygenIntegerLift.Bound fv 1 ∧
      KeygenMaterial.Represents after.heap g gv ∧ KeygenIntegerLift.Bound gv 1 := by
  obtain ⟨fv,frepr,fbound⟩ := material ctx before middle "f" f fOutside fLive fWidth size fPointer first
  have keepG := frame ctx before middle "f" f g.block gOutside separate gLive size fPointer first
  have control := slots ctx before middle (arguments "f") first
  have middleSize : C99CountedWords.Limit middle := (congrFun control.1 _).trans size
  have gPtr : middle.arrays "g".toList=some g := (congrFun control.2 _).trans gPointer
  have middleGLive : 0<middle.heap.size g.block := by rw [keepG.1]; exact gLive
  have middleFLive : 0<middle.heap.size f.block := by rw [keepG.1]; exact fLive
  obtain ⟨gv,grepr,gbound⟩ := material ctx middle after "g" g gOutside middleGLive gWidth middleSize gPtr second
  have keepF := frame ctx middle after "g" g f.block fOutside (Ne.symm separate) middleFLive middleSize gPtr second
  exact ⟨fv,gv,KeygenSamplerFrame.represents middle.heap after.heap f fv keepF frepr,fbound,grepr,gbound⟩

end FT1536.Source3.KeygenSamplerCalls
