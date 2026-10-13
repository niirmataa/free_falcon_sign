import Source3.KeygenDecodeStaticOuterSuffix

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticOuterScope
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticWire

theorem objects : scopeObjects KeygenDecodeStaticBinding.node109=
    [⟨"sign".toList,.u32,none⟩,⟨"lo".toList,.u32,none⟩,⟨"ne".toList,.u32,none⟩] := rfl

theorem scalar_preserved (s t : State) (name : String)
    (differentSign : name.toList≠"sign".toList) (differentLo : name.toList≠"lo".toList)
    (differentNe : name.toList≠"ne".toList) :
    (scopeExit KeygenDecodeStaticBinding.node109 s t).locals.scalars name.toList=t.locals.scalars name.toList := by
  have noSign : ("sign".toList==name.toList)=false := by simpa only [beq_eq_false_iff_ne] using Ne.symm differentSign
  have noLo : ("lo".toList==name.toList)=false := by simpa only [beq_eq_false_iff_ne] using Ne.symm differentLo
  have noNe : ("ne".toList==name.toList)=false := by simpa only [beq_eq_false_iff_ne] using Ne.symm differentNe
  simp only [scopeExit,objects,List.any_cons,List.any_nil,noSign,noLo,noNe,Bool.false_or,Bool.false_eq_true,ite_false]

theorem reader (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32) (s t : State)
    (ready : Ready args src dst v p db t) :
    Ready args src dst v p db (scopeExit KeygenDecodeStaticBinding.node109 s t) := by
  have cell (name : String) (ty : C99IntegerReference.Ty) (value : IV)
      (differentSign : name.toList≠"sign".toList) (differentLo : name.toList≠"lo".toList)
      (differentNe : name.toList≠"ne".toList) (held : Cell name ty value t.locals) :
      Cell name ty value (scopeExit KeygenDecodeStaticBinding.node109 s t).locals := by
    unfold Cell
    rw [scalar_preserved s t name differentSign differentLo differentNe]
    exact held
  refine ⟨⟨cell "j" _ _ (by decide +kernel) (by decide +kernel) (by decide +kernel) ready.context.j,
    cell "mask" _ _ (by decide +kernel) (by decide +kernel) (by decide +kernel) ready.context.mask,
    cell "n" _ _ (by decide +kernel) (by decide +kernel) (by decide +kernel) ready.context.count,
    cell "len" _ _ (by decide +kernel) (by decide +kernel) (by decide +kernel) ready.context.length,?_,ready.context.destination⟩,
    cell "v" _ _ (by decide +kernel) (by decide +kernel) (by decide +kernel) ready.cursor,
    cell "db_len" _ _ (by decide +kernel) (by decide +kernel) (by decide +kernel) ready.pending,
    cell "db" _ _ (by decide +kernel) (by decide +kernel) (by decide +kernel) ready.accumulator⟩
  have noBuf : hasBuf (scopeObjects KeygenDecodeStaticBinding.node109)=false := by decide +kernel
  simpa only [scopeExit,noBuf,Bool.false_eq_true,ite_false] using ready.context.buffer

theorem wire (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s t : State) (held : Wire args src dst v p db bytes t) :
    Wire args src dst v p db bytes (scopeExit KeygenDecodeStaticBinding.node109 s t) :=
  ⟨reader args src dst v p db s t held.ready,held.reads,held.extent⟩

theorem cursor (s t : State) (u : Nat)
    (held : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) t.locals) :
    Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) (scopeExit KeygenDecodeStaticBinding.node109 s t).locals := by
  unfold Cell
  rw [scalar_preserved s t "u" (by decide +kernel) (by decide +kernel) (by decide +kernel)]
  exact held

end FT1536.Source3.KeygenDecodeStaticOuterScope
