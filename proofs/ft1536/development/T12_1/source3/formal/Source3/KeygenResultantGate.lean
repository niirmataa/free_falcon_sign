import Source3.KeygenResultantSource
import Source3.KeygenSamplerCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Actual two resultant gates immediately after the selected MODE1 sampling.
   Each call executes the whole helper, including local-array lifetime.
   Both continue edges and the successful fallthrough retain sampled bytes. -/
namespace FT1536.Source3.KeygenResultantGate
open C99ArrayReference (State Arg)
open C99ProcedureReference (Result)
open C99MemoryReference
open C99IntegerReference (Value)

def selected : Option (List String) := KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 7930).take 18)
def visible : List String := ["\t\t\tif (mod2_res_ternary(f, logn) == 0) {\n",
  "\t\t\t\tcontinue;\n","\t\t\t}\n","\t\t\tif (mod2_res_ternary(g, logn) == 0) {\n",
  "\t\t\t\tcontinue;\n","\t\t\t}\n"]
theorem selected_source : selected=some visible := by decide
def arguments (name : String) : List Arg := [.pointer name.toList C99ProcedureParser.zero,.scalar (.var "logn".toList)]
inductive Exec (before : State) : Result → Prop where
  | firstReject (after : State) (v : Value)
      (first : KeygenResultantSource.Call before (arguments "f") after v) (zero : v.integer=0) :
      Exec before ⟨after,.continueLoop⟩
  | secondReject (middle after : State) (x y : Value)
      (first : KeygenResultantSource.Call before (arguments "f") middle x) (nonzero : x.integer≠0)
      (second : KeygenResultantSource.Call middle (arguments "g") after y) (zero : y.integer=0) :
      Exec before ⟨after,.continueLoop⟩
  | accepted (middle after : State) (x y : Value)
      (first : KeygenResultantSource.Call before (arguments "f") middle x) (firstNonzero : x.integer≠0)
      (second : KeygenResultantSource.Call middle (arguments "g") after y) (secondNonzero : y.integer≠0) :
      Exec before ⟨after,.normal⟩
theorem bytes (before : State) (out : Result) (source : Exec before out) : out.state.heap.bytes=before.heap.bytes := by
  cases source with
  | firstReject after v first zero => exact KeygenResultantSource.bytes before after _ v first
  | secondReject middle after x y first nonzero second zero =>
    exact (KeygenResultantSource.bytes middle after _ y second).trans (KeygenResultantSource.bytes before middle _ x first)
  | accepted middle after x y first firstNonzero second secondNonzero =>
    exact (KeygenResultantSource.bytes middle after _ y second).trans (KeygenResultantSource.bytes before middle _ x first)
theorem material (before : State) (out : Result) (source : Exec before out) (p : ArrayPointer)
    (vector : Geometry.Vec) (represented : KeygenMaterial.Represents before.heap p vector) :
    KeygenMaterial.Represents out.state.heap p vector := by
  have keep := bytes before out source
  intro i
  constructor
  · intro byte; rw [keep]; exact (represented i).1 byte
  · intro byte; rw [keep]; exact (represented i).2 byte
theorem sampled_material (ctx : ShakeExtractSource.Layout) (before middle sampled : State) (out : Result)
    (f g : ArrayPointer) (fOutside : ctx.block≠f.block) (gOutside : ctx.block≠g.block) (separate : f.block≠g.block)
    (fLive : 0<before.heap.size f.block) (gLive : 0<before.heap.size g.block)
    (fWidth : f.elementBytes=2) (gWidth : g.elementBytes=2)
    (size : C99CountedWords.Limit before) (fPointer : before.arrays "f".toList=some f)
    (gPointer : before.arrays "g".toList=some g)
    (first : KeygenSamplerCalls.Call ctx before (KeygenSamplerCalls.arguments "f") middle)
    (second : KeygenSamplerCalls.Call ctx middle (KeygenSamplerCalls.arguments "g") sampled)
    (gates : Exec sampled out) :
    ∃ fv gv : Geometry.Vec,
      KeygenMaterial.Represents out.state.heap f fv ∧ KeygenIntegerLift.Bound fv 1 ∧
      KeygenMaterial.Represents out.state.heap g gv ∧ KeygenIntegerLift.Bound gv 1 := by
  obtain ⟨fv,gv,frepr,fbound,grepr,gbound⟩ := KeygenSamplerCalls.two_calls ctx before middle sampled f g
    fOutside gOutside separate fLive gLive fWidth gWidth size fPointer gPointer first second
  exact ⟨fv,gv,material sampled out gates f fv frepr,fbound,material sampled out gates g gv grepr,gbound⟩

end FT1536.Source3.KeygenResultantGate
