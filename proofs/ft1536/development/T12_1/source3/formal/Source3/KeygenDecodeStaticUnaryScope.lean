import Source3.KeygenDecodeStaticUnaryRefill
import Source3.KeygenDecodeStaticUnarySelect

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticUnaryScope
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire

theorem objects : scopeObjects KeygenDecodeStaticBinding.node068=[⟨"bit".toList,.u32,none⟩] := rfl

theorem scalar_preserved (s t : State) (name : String) (different : name.toList≠"bit".toList) :
    (scopeExit KeygenDecodeStaticBinding.node068 s t).locals.scalars name.toList=t.locals.scalars name.toList := by
  simp only [scopeExit,objects,List.any_cons,List.any_nil,Bool.or_false]
  have no : ("bit".toList==name.toList)=false := by simpa only [beq_eq_false_iff_ne] using Ne.symm different
  simp only [no,Bool.false_eq_true,ite_false]

theorem reader (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32) (s t : State)
    (ready : Ready args src dst v p db t) :
    Ready args src dst v p db (scopeExit KeygenDecodeStaticBinding.node068 s t) := by
  have cell (name : String) (ty : C99IntegerReference.Ty) (value : IV) (different : name.toList≠"bit".toList)
      (held : Cell name ty value t.locals) : Cell name ty value (scopeExit KeygenDecodeStaticBinding.node068 s t).locals := by
    unfold Cell
    rw [scalar_preserved s t name different]
    exact held
  refine ⟨⟨cell "j" _ _ (by decide +kernel) ready.context.j,
    cell "mask" _ _ (by decide +kernel) ready.context.mask,
    cell "n" _ _ (by decide +kernel) ready.context.count,
    cell "len" _ _ (by decide +kernel) ready.context.length,?_,ready.context.destination⟩,
    cell "v" _ _ (by decide +kernel) ready.cursor,
    cell "db_len" _ _ (by decide +kernel) ready.pending,
    cell "db" _ _ (by decide +kernel) ready.accumulator⟩
  simpa only [scopeExit,objects,hasBuf,List.any_cons,List.any_nil,Bool.or_false,
    show ("bit".toList=="buf".toList)=false by decide +kernel,Bool.false_eq_true,ite_false] using ready.context.buffer

theorem wire (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s t : State) (held : Wire args src dst v p db bytes t) :
    Wire args src dst v p db bytes (scopeExit KeygenDecodeStaticBinding.node068 s t) :=
  ⟨reader args src dst v p db s t held.ready,held.reads,held.extent⟩

end FT1536.Source3.KeygenDecodeStaticUnaryScope
