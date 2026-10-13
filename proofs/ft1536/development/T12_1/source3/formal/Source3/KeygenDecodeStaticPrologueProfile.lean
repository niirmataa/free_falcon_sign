import Source3.KeygenDecodeStaticPrologueCalculations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticPrologueProfile
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticPrologueCalculations

def set32 (s : State) (name : String) (word : BitVec 32) : State :=
  withLocals s (localSet s.locals name.toList .uint32 (some (.uint32 word)))
def set64 (s : State) (name : String) (word : BitVec 64) : State :=
  withLocals s (localSet s.locals name.toList .uint64 (some (.uint64 word)))
def profiled (s : State) : State := set32 (set64 s "n" 1536) "j" 8

theorem q_branch (args : Args) (s : State)
    (q : Cell "q" .uint32 (.uint32 18433) s.locals)
    (logn : Cell "logn" .uint32 (.uint32 10) s.locals)
    (n : s.locals.scalars "n".toList=some (.uint64,none))
    (j : s.locals.scalars "j".toList=some (.uint32,none)) :
    Checked args KeygenDecodeStaticBinding.node016 s (profiled s) .normal := by
  let s1 := set64 s "n" 1536
  let s2 := profiled s
  have assignN : Checked args KeygenDecodeStaticBinding.node010 s s1 .normal := by
    have source := assign args s "n".toList .uint64 none nRhs (.uint64 1536) s.locals
      (by decide +kernel) (by decide +kernel) n (.pure _ _ _ (n_calculation args s logn))
    simpa only [KeygenDecodeStaticOuterCounter.self64,source_n,set64,s1] using source
  have oldJ := (KeygenDecodeStaticCellFrame.exec_frame "j".toList args _ s s1 .normal assignN.run (by decide +kernel)).trans j
  have assignJ : Checked args KeygenDecodeStaticBinding.node011 s1 s2 .normal := by
    have source := assign args s1 "j".toList .uint32 none (.number .i32 8) (.int32 8) s1.locals
      (by decide +kernel) (by decide +kernel) oldJ (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
    have cast : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.int32 8).integer=.uint32 8 := by decide +kernel
    simpa only [cast,KeygenDecodeStaticBinding.node011,profiled,set32,s2,s1] using source
  have inside : Checked args KeygenDecodeStaticBinding.node014 s s2 .normal :=
    seq args _ _ s s1 s2 .normal assignN (seq args _ _ s1 s2 s2 .normal assignJ (skip args s2))
  have wrapped : Checked args KeygenDecodeStaticBinding.node015 s s2 .normal := by
    have source := scope args KeygenDecodeStaticBinding.node014 s s2 .normal (by intro impossible; cases impossible) inside
    rw [empty_scope _ _ _ rfl] at source
    exact source
  have same : withLocals s s.locals=s := by cases s; rfl
  exact branch_false args KeygenDecodeStaticBinding.guard016 KeygenDecodeStaticBinding.node009 KeygenDecodeStaticBinding.node015
    s s2 .normal (.int32 0) s.locals (.pure _ _ _ (q_calculation args s q)) (by decide +kernel)
    (by rw [same]; exact wrapped)

end FT1536.Source3.KeygenDecodeStaticPrologueProfile
