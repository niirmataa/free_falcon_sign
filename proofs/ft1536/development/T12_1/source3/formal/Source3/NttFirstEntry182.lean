import Source3.NttFirstControl182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttFirstEntry182
open C99ArrayReference (State bindPointer)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open NttFirstFixed182 (Fixed)
open GeneratorRowControl179 (put)

def counted (s : State) := put s 0
def withFirst (s : State) (a : ArrayPointer) := bindPointer (counted s) "r1".toList a
def after (s : State) (a : ArrayPointer) := bindPointer (withFirst s a) "r2".toList (element a 768)

theorem source (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (old : Option C99IntegerReference.Value) (declared : s.locals "u".toList=some (.uint64,old)) :
    Exec KeygenNttForwardPrograms.firstInit s ⟨after s a,.normal⟩ := by
  have u : Exec (.assign "u".toList (.scalar (KeygenNttForwardPrograms.num 0))) s ⟨counted s,.normal⟩ :=
    .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have first : Exec (KeygenNttForwardPrograms.bind "r1" "a" KeygenNttButterflyPrograms.zero) (counted s) ⟨withFirst s a,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ a (RootBinding175.zero (counted s) "a" a fixed.aBinding (by have h:=fixed.capacity; omega)))
  have second : Exec (KeygenNttForwardPrograms.bind "r2" "a" (.bin .mul (.var "hn".toList) (.var "stride".toList)))
      (withFirst s a) ⟨after s a,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ (element a 768)
      (.add _ _ a _ (.uint64 768) fixed.aBinding
        (.arithmetic .times _ _ _ _ _ (.variable _ _ _ fixed.hnCell) (.variable _ _ _ fixed.stride)
          (.step .times (.uint64 768) (.uint64 1) .uint64 rfl (.uint64 768) (.uint64 1) rfl rfl
            (by intro impossible; cases impossible)))
        (by decide) (.within a 768 (by have h:=fixed.capacity; omega))))
  exact .seqNormal _ _ s (counted s) _ u (.seqNormal _ _ (counted s) (withFirst s a) _ first second)

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (h : Fixed s a gm p p0i w) :
    Fixed (after s a) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

theorem counter (s : State) (a : ArrayPointer) : KeygenNttLoopSupport.USlot (after s a) "u" 0 := GeneratorRowControl179.cell s 0 (by decide)
theorem first_pointer (s : State) (a : ArrayPointer) : (after s a).arrays "r1".toList=some (element a 0) := rfl
theorem second_pointer (s : State) (a : ArrayPointer) : (after s a).arrays "r2".toList=some (element a 768) := rfl

end FT1536.Source3.NttFirstEntry182
