import Source3.C99ProcedureFrame138
import Source3.C99LazyBlock129

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ProcedureNormalize138
open C99CompactState115 (State reference)
open C99FiniteMemory114 (Block memory)
open C99MemoryReference (ArrayPointer)
open C99ProcedureSegments136 (Prefix)

def normalize (before : State) (block : Nat) (data : Block) (locals : C99CompactCells115.Locals) : State :=
  {before with heap := C99LazyBlock129.putBlock before.heap block data,locals := locals}

theorem heap_equal (program : C99ProcedureReference.Program) (condition : CLogic.Expr) (body increment : C99ProcedureReference.Stmt) (count : Nat)
    (before after : State) (name : C99ArrayReference.Name) (pointer : ArrayPointer) (data : Block)
    (source : Prefix program condition body increment count (reference before) (reference after))
    (bodyChecked : C99ProcedureFrame138.only [name] body=true) (incrementChecked : C99ProcedureFrame138.only [name] increment=true)
    (binding : (reference before).arrays name=some pointer)
    (found : C99FiniteMap114.lookup after.heap.blocks pointer.block=some data) :
    memory after.heap=memory (C99LazyBlock129.putBlock before.heap pointer.block data) := by
  have stable := C99ProcedureFrame136.prefix_metadata program condition body increment count _ _ source
  rw [C99LazyBlock129.memory_equal]
  apply C99FiniteAllocation115.memory_ext
  · intro block offset
    rw [C99FiniteMemory114.bytes_putBlock]
    by_cases same : block=pointer.block
    · subst block
      simp [memory,found]
    · rw [ite_eq_right same]
      apply (C99ProcedureFrame138.prefix_outside program condition body increment count _ _ source [name]
        bodyChecked incrementChecked block offset ?_).2
      intro actual member address addressFound
      have named := List.mem_singleton.mp member
      subst actual
      have equal : address=pointer := Option.some.inj (addressFound.symm.trans binding)
      subst address
      exact Or.inl same
  · intro block
    rw [C99FiniteMemory114.size_putBlock]
    by_cases same : block=pointer.block
    · subst block
      simp [memory,found]
    · rw [ite_eq_right same]
      exact congrFun stable.sizes block
  · intro block
    rw [C99FiniteMemory114.writable_putBlock]
    by_cases same : block=pointer.block
    · subst block
      simp [memory,found]
    · rw [ite_eq_right same]
      exact congrFun stable.writable block

theorem reference_equal (program : C99ProcedureReference.Program) (condition : CLogic.Expr) (body increment : C99ProcedureReference.Stmt) (count : Nat)
    (before after : State) (name : C99ArrayReference.Name) (pointer : ArrayPointer) (data : Block)
    (locals : C99CompactCells115.Locals)
    (source : Prefix program condition body increment count (reference before) (reference after))
    (bodyChecked : C99ProcedureFrame138.only [name] body=true) (incrementChecked : C99ProcedureFrame138.only [name] increment=true)
    (bodyArrays : KeygenAttemptSlots.procedureOnly body=true) (incrementArrays : KeygenAttemptSlots.procedureOnly increment=true)
    (binding : (reference before).arrays name=some pointer)
    (found : C99FiniteMap114.lookup after.heap.blocks pointer.block=some data) (localValues : after.locals=locals) :
    reference after=reference (normalize before pointer.block data locals) := by
  have heap := heap_equal program condition body increment count before after name pointer data source bodyChecked incrementChecked binding found
  have stable := C99ProcedureFrame136.prefix_metadata program condition body increment count _ _ source
  have arrays := C99ProcedureFrame136.prefix_arrays program condition body increment count _ _ source bodyArrays incrementArrays
  change C99NameMap115.lookup after.arrays=C99NameMap115.lookup before.arrays at arrays
  have globals : C99CompactCells115.environment after.globals=C99CompactCells115.environment before.globals := stable.globals
  have tables : C99NameMap115.lookup after.tables=C99NameMap115.lookup before.tables := stable.tables
  unfold reference normalize
  rw [heap,localValues,arrays,globals,tables]

theorem source_normalized (program : C99ProcedureReference.Program) (condition : CLogic.Expr) (body increment : C99ProcedureReference.Stmt) (count : Nat)
    (before after : State) (name : C99ArrayReference.Name) (pointer : ArrayPointer) (data : Block)
    (locals : C99CompactCells115.Locals)
    (source : Prefix program condition body increment count (reference before) (reference after))
    (bodyChecked : C99ProcedureFrame138.only [name] body=true) (incrementChecked : C99ProcedureFrame138.only [name] increment=true)
    (bodyArrays : KeygenAttemptSlots.procedureOnly body=true) (incrementArrays : KeygenAttemptSlots.procedureOnly increment=true)
    (binding : (reference before).arrays name=some pointer)
    (found : C99FiniteMap114.lookup after.heap.blocks pointer.block=some data) (localValues : after.locals=locals) :
    Prefix program condition body increment count (reference before) (reference (normalize before pointer.block data locals)) := by
  rw [← reference_equal program condition body increment count before after name pointer data locals source
    bodyChecked incrementChecked bodyArrays incrementArrays binding found localValues]
  exact source

end FT1536.Source3.C99ProcedureNormalize138
