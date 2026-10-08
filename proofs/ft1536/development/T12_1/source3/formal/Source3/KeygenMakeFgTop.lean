import Source3.KeygenLevelParser
import Source3.KeygenMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete make_fg_ternary_top, a shared deepest/intermediate dependency.
   Only data-derived scratch objects are writable. Original sampled f/g
   survive this actual helper call when separated from those objects. -/
namespace FT1536.Source3.KeygenMakeFgTop
open C99ArrayReference (State Name Param Arg)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenLevelExec

def types : KeygenSearchParser.Types := ["data","gm","igm","fd","gd","fs","gs"].map (fun n => (n.toList,4))
def writable : List Name := types.map Prod.fst
def parsed : Option Stmt := KeygenLevelParser.region types 5582 86
def code : Stmt := parsed.getD skip
theorem signature_source : KeygenLevelNtt.region 5579 3 = ["static void\n",
  "make_fg_ternary_top(uint32_t *data, unsigned logn, int out_ntt)\n","{\n"] := by decide
theorem closing_source : Pinned.keygenLines[5667]?=some "}\n" := by decide
theorem source_audit : parsed.map (only writable)=some true := by decide
theorem source_parsed : parsed=some code := by
  have h := source_audit
  cases hp : parsed with
  | none => simp only [hp,Option.map_none] at h; cases h
  | some p => simp only [code,hp,Option.getD_some]
theorem code_checked : only writable code=true := by
  have h := source_audit
  rw [source_parsed] at h
  exact Option.some.inj h
def params : List Param := [.pointer "data".toList,.scalar .uint32 "logn".toList,.scalar .int32 "out_ntt".toList]
inductive Call (before : State) (args : List Arg) : State → Prop where
  | run (entry : State) (out : Result) (binding : C99ArrayReference.Bind before params args entry)
      (source : Exec code entry out) (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Call before args {before with heap := out.state.heap}
theorem call_frame (before after : State) (args : List Arg) (source : Call before args after)
    (names : List Name) (block offset : Nat)
    (allowed : C99PointerFootprint.arguments names writable params args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out binding execution returned =>
    obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before params args entry binding
      names writable allowed block offset outside tables
    have keep := (body_frame code entry out execution writable code_checked block offset ho
      (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)).2.2
    rw [C99ArrayReference.bind_heap before params args entry binding] at keep
    exact keep
def actualArgs : List Arg := [.pointer "data".toList C99ProcedureParser.zero,
  .scalar (.var "logn".toList),.scalar (.var "out_ntt".toList)]
theorem actual_args_checked : C99PointerFootprint.arguments ["data".toList] writable params actualArgs=true := by decide
theorem material (before after : State) (source : Call before actualArgs after)
    (data input : ArrayPointer) (binding : before.arrays "data".toList=some data)
    (separate : data.block≠input.block)
    (tables : ∀ name p, before.tables name=some p → p.block≠input.block)
    (vector : Geometry.Vec) (represented : KeygenMaterial.Represents before.heap input vector) :
    KeygenMaterial.Represents after.heap input vector := by
  have keep (offset : Nat) : after.heap.bytes input.block offset=before.heap.bytes input.block offset := by
    apply call_frame before after actualArgs source ["data".toList] input.block offset actual_args_checked
    · intro name member p hp
      have equal : name="data".toList := by simpa only [List.mem_singleton] using member
      subst name
      have same := Option.some.inj (hp.symm.trans binding)
      subst p
      exact Or.inl (Ne.symm separate)
    · intro name p hp
      exact Or.inl (Ne.symm (tables name p hp))
  intro i
  constructor
  · intro byte; exact (keep _).trans ((represented i).1 byte)
  · intro byte; exact (keep _).trans ((represented i).2 byte)

end FT1536.Source3.KeygenMakeFgTop
