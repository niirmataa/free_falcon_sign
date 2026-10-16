import Source3.PublicDivisionChain157
import Source3.C99DeclarationStatements

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicDivisionSource157
open C99ArrayReference (State)
open C99ModularReference (GenExec)
open KeygenPublicDivisionWords (firstNames lastNames initial steps finalStep run division Ready)
open PublicDivisionExpr157 (Known)
open KeygenPublicSquare (Slot converted_word)

def input (x y : BitVec 32) := C99ModularReference.bindParams KeygenPublicScalar.empty
  (KeygenPublicScalar.params .divT) [.uint32 x,.uint32 y]
def first (x y : BitVec 32) := C99DeclarationStatements.effect .u32 (firstNames.map String.toList) (input x y)
def entered (x y : BitVec 32) := C99DeclarationStatements.effect .u32 (lastNames.map String.toList) (first x y)

theorem ready (x y : BitVec 32) : Ready (entered x y) (initial x y) :=
  KeygenPublicDivisionWords.ready_entry x y (entered x y) rfl
theorem known (x y : BitVec 32) : Known (entered x y) (initial x y) ["x","y"] := by
  intro n member
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl|rfl
  all_goals simp [Slot,entered,first,input,initial,firstNames,lastNames,C99DeclarationStatements.effect,
    C99DeclarationCells.declareCells,KeygenPublicScalar.params,C99ModularReference.bindParams,
    C99ArrayReference.bindValue,C99ScalarReference.set,KeygenPublicScalar.empty,converted_word]

theorem body (x y : BitVec 32) : KeygenPublicScalar.Body KeygenPublicScalar.Square .divT [.uint32 x,.uint32 y] (.uint32 (division x y)) := by
  obtain ⟨last,_lastReady,lastKnown,compose⟩ := PublicDivisionChain157.source steps (entered x y) (initial x y) ["x","y"]
    (ready x y) (known x y) KeygenPublicDivisionWords.allowed_steps PublicDivisionExpr157.steps_checked
  have finalValue := PublicDivisionExpr157.source last (run steps (initial x y)) _ finalStep lastKnown PublicDivisionExpr157.final_checked
  have tail : GenExec KeygenPublicScalar.Square KeygenPublicDivisionWords.tail last ⟨last,.returned (some (.uint32 (division x y)))⟩ :=
    .seqExit _ _ _ _ (.ret _ _ _ finalValue) (by intro impossible; cases impossible)
  refine ⟨rfl,⟨last,.returned (some (.uint32 (division x y)))⟩,?_,?_⟩
  · rw [KeygenPublicDivisionWords.source_code]
    exact .seqNormal _ _ _ (first x y) _
      (.base _ _ _ (C99DeclarationStatements.source_exists _ .u32 (firstNames.map String.toList) (input x y)))
      (.seqNormal _ _ _ (entered x y) _
        (.base _ _ _ (C99DeclarationStatements.source_exists _ .u32 (lastNames.map String.toList) (first x y)))
        (compose _ _ tail))
  · simpa only [converted_word] using (C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (division x y)))

theorem source (x y : B20.C.Val) : KeygenPublicScalar.Call "mq_div_18433".toList [C99ValueBridge.value x,C99ValueBridge.value y]
    (.uint32 (division (PublicArgumentSource157.word x) (PublicArgumentSource157.word y))) :=
  .ternary _ _ (KeygenPublicArguments.body_conversion _ .divT _ _ _
    (PublicArgumentSource157.cons_unsigned _ x _ _ _ (PublicArgumentSource157.cons_unsigned _ y _ _ _ .nil))
    (body (PublicArgumentSource157.word x) (PublicArgumentSource157.word y)))

end FT1536.Source3.PublicDivisionSource157
