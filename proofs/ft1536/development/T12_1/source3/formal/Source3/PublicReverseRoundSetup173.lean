import Source3.PublicReverseRoundContext173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseRoundSetup173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec Stmt)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableAtoms (var literal)
open PublicReverseRoundContext173 (Arrays Valid)

def names : List C99ArrayReference.Name := ["ht".toList,"u1".toList,"v1".toList]
def declaration : Stmt := .scalar (.declare .u64 names)
def half : Stmt := .assign "ht".toList (.bin .shr (var "t") (literal 1))
def initialization : Stmt := .seq (.assign "u1".toList (literal 0)) (.assign "v1".toList (literal 0))
def declared (s : State) : State :=
  {s with locals := C99DeclarationCells.declareCells .uint64 names s.locals}
def halved (s : State) (t : Nat) : State := bindValue (declared s) "ht".toList .uint64 (u64 (t/2))
def firstZero (s : State) (t : Nat) : State := bindValue (halved s t) "u1".toList .uint64 (u64 0)
def initial (s : State) (t : Nat) : State := bindValue (firstZero s t) "v1".toList .uint64 (u64 0)

theorem declaration_source (s : State) :
    Exec KeygenPublicSource.program [] declaration s ⟨declared s,.normal⟩ :=
  .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint64 names s.locals)

theorem half_source (s : State) (t : Nat) (bound : t < 2^64) (slot : USlot s "t" t) :
    Exec KeygenPublicSource.program [] half (declared s) ⟨halved s t,.normal⟩ := by
  have tSlot : USlot (declared s) "t" t := slot
  exact .assign _ _ _ .uint64 none (u64 (t/2)) (by rfl)
    (.bin .shr _ _ _ _ _
      (.scalar _ _ (PublicGenerateIndex159.var_u64 (declared s) "t" t tSlot))
      (PublicGenerateHead159.eval_lit (declared s) 1)
      (C99OuterScalar144.half_word t bound))

theorem initialization_source (s : State) (t : Nat) :
    Exec KeygenPublicSource.program [] initialization (halved s t) ⟨initial s t,.normal⟩ :=
  .seqNormal _ _ (halved s t) (firstZero s t) ⟨initial s t,.normal⟩
    (.assign _ _ _ .uint64 none (.int32 0) (by rfl) (.scalar _ _ (.literal .int32 0)))
    (.assign _ _ _ .uint64 none (.int32 0) (by rfl) (.scalar _ _ (.literal .int32 0)))

theorem initial_fixed (s : State) (a gm : ArrayPointer) (t m : Nat)
    (ctx : Arrays s a gm) (valid : Valid t m)
    (tSlot : USlot s "t" t) (mSlot : USlot s "m" m)
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    PublicReverseGroupInvariant173.Fixed (initial s t) a gm (t/2) m := by
  have halfSlot : USlot (halved s t) "ht" (t/2) :=
    PublicGenerateRow159.u64_slot_after (declared s) "ht" (t/2) (by have := valid.wordBound; omega)
  have halfFirst := PublicGenerateRow159.keep_u64 (halved s t) "ht" "u1" .uint64 (u64 0)
    (t/2) (by decide) halfSlot
  have halfFinal := PublicGenerateRow159.keep_u64 (firstZero s t) "ht" "v1" .uint64 (u64 0)
    (t/2) (by decide) halfFirst
  have stride : USlot (initial s t) "t" (2*(t/2)) := by
    rw [← valid.even]
    exact tSlot
  exact ⟨valid.total,valid.groupsBound,ctx.capacity,ctx.tableCapacity,ctx.binding,ctx.tableBinding,
    halfFinal,stride,mSlot,vCell,ctx.tableWritten,ctx.separate,ctx.width,ctx.writable,ctx.allocated,ctx.written⟩

theorem initial_u (s : State) (t : Nat) : USlot (initial s t) "u1" 0 :=
  PublicGenerateRow159.keep_u64 (firstZero s t) "u1" "v1" .uint64 (u64 0) 0 (by decide)
    (PublicGenerateRow159.u64_slot_after (halved s t) "u1" 0 (by decide))

theorem initial_v (s : State) (t : Nat) : USlot (initial s t) "v1" (0*(2*(t/2))) := by
  simpa only [Nat.zero_mul,initial] using PublicGenerateRow159.u64_slot_after (firstZero s t) "v1" 0 (by decide)

end FT1536.Source3.PublicReverseRoundSetup173
