import Source3.NttSize182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttPrologue182
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttForwardPrograms
open KeygenNttForwardExec (afterLocals afterWord afterPointers afterN afterCompute ready)

theorem source (s : State) (logn : Slot s "logn" 10) (full : Slot s "full" 1) :
    Exec prologue s ⟨ready s,.normal⟩ := by
  let a := afterLocals s
  let b := afterWord a
  let c := afterPointers b
  let d := afterN c
  have sizes : Exec locals s ⟨a,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64
      (["n","hn","u","r","m","t"].map String.toList) s)
  have w : Exec word a ⟨b,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["w".toList] a)
  have ptrs : Exec pointers b ⟨c,.normal⟩ :=
    DeepestDeclarations175.pointer_source ["r1".toList,"r2".toList] b (.base .skip) ⟨c,.normal⟩ (.base .skip c c (.skip c))
  have exitGuard : Exec earlyExit c ⟨c,.normal⟩ :=
    .branchFalse _ _ _ c ⟨c,.normal⟩ (.int32 0)
      (.compare .eq _ _ _ _ _ (.variable _ _ _ logn) (.literal .int32 0)
        (.step .eq (.uint32 10) (.int32 0) .uint32 rfl (.uint32 10) (.uint32 0) rfl rfl)) rfl (.base .skip c c (.skip c))
  have n : Exec nAssign c ⟨d,.normal⟩ :=
    .assign _ _ _ .uint64 none (.uint64 1536) rfl (.scalar _ _ (NttSize182.source c logn full))
  have hn : Exec hnAssign d ⟨ready s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.uint64 768) rfl (.scalar _ _
      (.shift .right _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
        (.right (.uint64 1536) (.int32 1) 1 rfl (by decide))))
  exact .seqNormal _ _ s a _ sizes (.seqNormal _ _ a b _ w (.seqNormal _ _ b c _ ptrs
    (.seqNormal _ _ c c _ exitGuard (.seqNormal _ _ c d _ n (.seqNormal _ _ d (ready s) _ hn
      (.base .skip _ _ (.skip _)))))))

theorem heap (s : State) : (ready s).heap=s.heap := rfl

theorem n_cell (s : State) : KeygenNttLoopSupport.USlot (ready s) "n" 1536 := rfl
theorem hn_cell (s : State) : KeygenNttLoopSupport.USlot (ready s) "hn" 768 := rfl
theorem u_declared (s : State) : (ready s).locals "u".toList=some (.uint64,none) := rfl
theorem w_declared (s : State) : (ready s).locals "w".toList=some (.uint32,none) := rfl

end FT1536.Source3.NttPrologue182
