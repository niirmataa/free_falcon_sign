import Source3.KeygenPublicEncodeCertified077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Retain every source statement while appending a source suffix. Inversion
   also preserves early return/break, so prefix correctness is not assumed. -/
namespace FT1536.Source3.KeygenPublicEncodeSequence077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeCertified077

def chain (pieces : List Stmt) (tail : Stmt) : Stmt := pieces.foldr Stmt.seq tail

theorem append_run (pieces : List Stmt) (args : Args) (s m t : State) (tail : Stmt) (flow : Flow)
    (first : Exec args (chain pieces .skip) s m .normal) (second : Exec args tail m t flow) :
    Exec args (chain pieces tail) s t flow := by
  induction pieces generalizing s with
  | nil => cases first; exact second
  | cons head rest ih =>
    cases first with
    | seq a b s middle m phase headRun restRun =>
      exact .seq args head (chain rest tail) s middle t flow headRun (ih middle restRun)

theorem split_run (pieces : List Stmt) (args : Args) (s t : State) (tail : Stmt) (flow : Flow)
    (source : Exec args (chain pieces tail) s t flow) :
    (∃ middle, Exec args (chain pieces .skip) s middle .normal ∧ Exec args tail middle t flow) ∨
      (Exec args (chain pieces .skip) s t flow ∧ flow≠.normal) := by
  induction pieces generalizing s with
  | nil => exact Or.inl ⟨s,.skip args s,source⟩
  | cons head rest ih =>
    cases source with
    | seq a b s middle t flow first second =>
      rcases ih middle second with ⟨last,prefixRun,tailRun⟩ | ⟨prefixRun,abnormal⟩
      · exact Or.inl ⟨last,.seq args head (chain rest .skip) s middle last .normal first prefixRun,tailRun⟩
      · exact Or.inr ⟨.seq args head (chain rest .skip) s middle t flow first prefixRun,abnormal⟩
    | seqReturn a b s t value first =>
      exact Or.inr ⟨.seqReturn args head (chain rest .skip) s t value first,by intro impossible; cases impossible⟩

theorem append_checked (pieces : List Stmt) (args : Args) (s m t : State) (tail : Stmt) (flow : Flow)
    (first : Checked args (chain pieces .skip) s m .normal) (second : Checked args tail m t flow) :
    Checked args (chain pieces tail) s t flow := by
  refine ⟨append_run pieces args s m t tail flow first.run second.run,?_⟩
  intro after result source
  rcases split_run pieces args s after tail result source with ⟨middle,prefixRun,tailRun⟩ | ⟨prefixRun,abnormal⟩
  · obtain ⟨same,_⟩ := first.unique _ _ prefixRun
    subst middle
    exact second.unique _ _ tailRun
  · exact (abnormal (first.unique _ _ prefixRun).2).elim

end FT1536.Source3.KeygenPublicEncodeSequence077
