import Source3.NttTripleFacts184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModularStore184
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open C99ModularReference (Exec Eval)

theorem source (s : State) (name : String) (index : CLogic.Expr) (value : C99ModularReference.Expr)
    (pointer : ArrayPointer) (word : BitVec 32) (address : Pointer s name.toList index pointer)
    (evaluation : Eval s value (.uint32 word)) (allocated : Allocated s.heap pointer)
    (width : pointer.elementBytes=4) (writable : s.heap.writable pointer.block=true) :
    Exec (.store32 name.toList index value) s ⟨{s with heap:=Word32Memory176.write s.heap pointer word},.normal⟩ :=
  .store32 _ _ _ _ _ pointer (.uint32 word) address evaluation
    (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq] using
      (Word32Memory176.source s.heap pointer word allocated width writable))

end FT1536.Source3.ModularStore184
