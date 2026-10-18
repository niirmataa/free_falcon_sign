import Source3.SelectedDeepestConfig175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedDeepestWorkspace175
open C99ArrayReference (State bindPointer)
open KeygenDeepestSource (Exec Stmt)
open KeygenFullData127 (env)
open DeepestDeclarations175 (arrayCode array_source)

def pointer (k : Nat) := KeygenSmallOutput.element env.ctx.scratch (335*k)
def bindCode (dst src : String) := arrayCode (.bindPtr dst.toList src.toList (.var "len".toList))
def steps : List Stmt := [.tmp "Fp".toList,bindCode "Gp" "Fp",bindCode "fp" "Gp",bindCode "gp" "fp",bindCode "t1" "gp"]
def code := KeygenDeepestSource.chain steps
def rest := KeygenDeepestSource.chain [Stmt.make]

theorem shape : KeygenDeepestSource.part 2=KeygenDeepestSource.chain (steps++[Stmt.make]) := by decide

noncomputable def s0 := SelectedDeepestConfig175.after
noncomputable def s1 := bindPointer s0 "Fp".toList (pointer 0)
noncomputable def s2 := bindPointer s1 "Gp".toList (pointer 1)
noncomputable def s3 := bindPointer s2 "fp".toList (pointer 2)
noncomputable def s4 := bindPointer s3 "gp".toList (pointer 3)
noncomputable def after := bindPointer s4 "t1".toList (pointer 4)

theorem tmp_read : KeygenSearchContext.ReadTmp env.ctx s0 (pointer 0) :=
  .read rfl SelectedDeepestEntry175.object SelectedRootContext175.pointer SelectedDeepestEntry175.tmp

theorem first : Exec env.ctx (.tmp "Fp".toList) s0 ⟨s1,.normal⟩ := .tmp _ _ _ tmp_read

theorem second : Exec env.ctx (bindCode "Gp" "Fp") s1 ⟨s2,.normal⟩ :=
  array_source env.ctx _ _ _ (.bindPtr _ _ _ _ (pointer 1)
    (.add _ _ (pointer 0) (pointer 1) (.uint64 335) rfl
      (.variable _ _ _ SelectedDeepestConfig175.length_cell) (by decide) (.within _ 335 (by decide))))
theorem third : Exec env.ctx (bindCode "fp" "Gp") s2 ⟨s3,.normal⟩ :=
  array_source env.ctx _ _ _ (.bindPtr _ _ _ _ (pointer 2)
    (.add _ _ (pointer 1) (pointer 2) (.uint64 335) rfl
      (.variable _ _ _ SelectedDeepestConfig175.length_cell) (by decide) (.within _ 335 (by decide))))
theorem fourth : Exec env.ctx (bindCode "gp" "fp") s3 ⟨s4,.normal⟩ :=
  array_source env.ctx _ _ _ (.bindPtr _ _ _ _ (pointer 3)
    (.add _ _ (pointer 2) (pointer 3) (.uint64 335) rfl
      (.variable _ _ _ SelectedDeepestConfig175.length_cell) (by decide) (.within _ 335 (by decide))))
theorem fifth : Exec env.ctx (bindCode "t1" "gp") s4 ⟨after,.normal⟩ :=
  array_source env.ctx _ _ _ (.bindPtr _ _ _ _ (pointer 4)
    (.add _ _ (pointer 3) (pointer 4) (.uint64 335) rfl
      (.variable _ _ _ SelectedDeepestConfig175.length_cell) (by decide) (.within _ 335 (by decide))))

theorem source : Exec env.ctx code s0 ⟨after,.normal⟩ :=
  .seqNormal _ _ s0 s1 ⟨after,.normal⟩ first
    (.seqNormal _ _ s1 s2 ⟨after,.normal⟩ second
      (.seqNormal _ _ s2 s3 ⟨after,.normal⟩ third
        (.seqNormal _ _ s3 s4 ⟨after,.normal⟩ fourth
          (.seqNormal _ _ s4 after ⟨after,.normal⟩ fifth
            (array_source env.ctx .skip after after (.skip after))))))

theorem continue_part (out : C99ProcedureReference.Result) (remaining : Exec env.ctx rest after out) :
    Exec env.ctx (KeygenDeepestSource.part 2) s0 out := by
  rw [shape]
  exact .seqNormal _ _ s0 s1 out first (.seqNormal _ _ s1 s2 out second
    (.seqNormal _ _ s2 s3 out third (.seqNormal _ _ s3 s4 out fourth
      (.seqNormal _ _ s4 after out fifth remaining))))

end FT1536.Source3.SelectedDeepestWorkspace175
