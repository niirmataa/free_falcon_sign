import Source3.C99ArrayDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99Metadata091
open C99ArrayReference (State)
open C99ProcedureReference (Result)

structure Stable (before after : State) : Prop where
  sizes : after.heap.size = before.heap.size
  writable : after.heap.writable = before.heap.writable
  tables : after.tables = before.tables
  globals : after.globals = before.globals

theorem refl (s : State) : Stable s s := ⟨rfl, rfl, rfl, rfl⟩
theorem trans (a b c : State) (first : Stable a b) (second : Stable b c) : Stable a c :=
  ⟨second.sizes.trans first.sizes, second.writable.trans first.writable,
    second.tables.trans first.tables, second.globals.trans first.globals⟩

theorem array (program : C99ArrayReference.Program) (code : C99ArrayReference.Stmt) (before after : State)
    (source : C99ArrayReference.Exec program code before after) : Stable before after := by
  induction source with
  | skip | scalar | assign | declarePtr | bindPtr | whileFalse => exact ⟨rfl, rfl, rfl, rfl⟩
  | store64 before after array index e p v address value write => exact ⟨write.2.2.2.1, write.2.2.2.2.1, rfl, rfl⟩
  | store32 before after array index e p v address value write => exact ⟨write.2.2.2.1, write.2.2.2.2.1, rfl, rfl⟩
  | copy before after dst src di si count p q n destination source length dstObject srcObject copy =>
      obtain ⟨_, _, _, _, _, _, _, sizes, writable, _, _⟩ := copy
      exact ⟨sizes, writable, rfl, rfl⟩
  | seq a b before middle after first second ih1 ih2 => exact trans before middle after ih1 ih2
  | scope locals pointers body before after inner ih => exact ⟨ih.sizes, ih.writable, ih.tables, ih.globals⟩
  | branchTrue condition yes no before after v guard nonzero body ih => exact ih
  | branchFalse condition yes no before after v guard zero body ih => exact ih
  | whileTrue condition body before middle after v guard nonzero step rest ih1 ih2 => exact trans before middle after ih1 ih2
  | call name args f before entry result source parameters body ih =>
      have heapEq := C99ArrayReference.bind_heap before f.params args entry parameters
      exact ⟨ih.sizes.trans (congrArg C99MemoryReference.Memory.size heapEq),
        ih.writable.trans (congrArg C99MemoryReference.Memory.writable heapEq), rfl, rfl⟩

theorem modular (calls : C99ModularReference.CallRelation) (code : C99ModularReference.Stmt)
    (before : State) (out : Result) (source : C99ModularReference.GenExec calls code before out) :
    Stable before out.state := by
  induction source with
  | base code before after source => exact array FftLeafPrograms.program code before after source
  | assign | loopFalse | ret | retVoid => exact ⟨rfl, rfl, rfl, rfl⟩
  | store32 name index e before after p v address value write => exact ⟨write.2.2.2.1, write.2.2.2.2.1, rfl, rfl⟩
  | storeRev name table base index e before after p q bv w v baseValue tableAddress tableRead address value write =>
      exact ⟨write.2.2.2.1, write.2.2.2.2.1, rfl, rfl⟩
  | seqNormal first second before middle result head tail ih1 ih2 => exact trans before middle result.state ih1 ih2
  | seqExit first second before result head exit ih => exact ih
  | scope locals body before result inner ih => exact ⟨ih.sizes, ih.writable, ih.tables, ih.globals⟩
  | branchTrue condition yes no before result v guard nonzero body ih => exact ih
  | branchFalse condition yes no before result v guard zero body ih => exact ih
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact trans before next result.state (trans before middle next ih1 ih2) ih3
  | loopReturn condition body increment before after v value guard nonzero iteration ih => exact ih

end FT1536.Source3.C99Metadata091
