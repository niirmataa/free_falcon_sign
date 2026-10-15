import Source3.C99WordStore140
import Source3.C99ArrayReference
import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftWordStoreStep140
open C99ArrayReference (State Name Expr Exec Program Pointer Eval)
open C99MemoryReference (ArrayPointer Allocated)

theorem source (program : Program) (before : State) (name : Name) (index : CLogic.Expr)
    (expr : Expr) (pointer : ArrayPointer) (word : BitVec 64)
    (address : Pointer before name index pointer) (evaluated : Eval before expr (.uint64 word))
    (allocated : Allocated before.heap pointer) (width : pointer.elementBytes=8)
    (writable : before.heap.writable pointer.block=true) :
    Exec program (.store64 name index expr) before
      {before with heap := C99WordStore140.write before.heap pointer word} := by
  refine .store64 _ _ _ _ _ pointer (.uint64 word) address evaluated ?_
  have bits := C99IntegerReference.Value.uint64.inj
    (C99CountedWords.convert_self (C99IntegerReference.Value.uint64 word))
  change BitVec.ofInt 64 (C99IntegerReference.Value.uint64 word).integer=word at bits
  rw [bits]
  exact C99WordStore140.source before.heap pointer word allocated width writable

end FT1536.Source3.FftWordStoreStep140
