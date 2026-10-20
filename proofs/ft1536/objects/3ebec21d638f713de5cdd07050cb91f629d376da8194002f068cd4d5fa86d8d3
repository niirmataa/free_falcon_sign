import Source3.CertificateDeclarations
import Source3.C99DeclarationStatements

namespace FT1536.Source3.CertificateEntryDeclarations
open C99ArrayReference (Name State)
open C99ProcedureReference (Exec Result)

def ready (before : State) : State :=
  C99DeclarationStatements.effect .u64 ["treesize".toList] (CertificateDeclarations.clearAll before)

theorem source_result (before : State) (result : Result)
    (source : Exec FftProcedurePrograms.program CertificateDeclarations.code before result) :
    result=⟨ready before,.normal⟩ := by
  have h1 := C99SequenceInversion.continuation FftProcedurePrograms.program
    (CertificateDeclarations.pointerGroup CertificateDeclarations.firstNames) _ before _ result
    (fun out h => CertificateDeclarations.group_result _ _ before out h) source
  have h2 := C99SequenceInversion.continuation FftProcedurePrograms.program
    (CertificateDeclarations.pointerGroup CertificateDeclarations.secondNames) _ _ _ result
    (fun out h => CertificateDeclarations.group_result _ _ _ out h) h1
  have h3 := C99SequenceInversion.continuation FftProcedurePrograms.program
    (CertificateDeclarations.pointerGroup CertificateDeclarations.thirdNames) _ _ _ result
    (fun out h => CertificateDeclarations.group_result _ _ _ out h) h2
  obtain ⟨middle,hs,ht⟩ := C99ProcedureSequence.base_before_tail FftProcedurePrograms.program
    (.scalar CertificateDeclarations.treeDecl) CertificateDeclarations.skip (CertificateDeclarations.clearAll before) result h3
  have he := C99DeclarationStatements.source_result .u64 ["treesize".toList] (CertificateDeclarations.clearAll before) middle hs
  subst middle
  exact C99ProcedureScalars.skip_result FftProcedurePrograms.program (ready before) result ht

theorem source_exists (before : State) :
    Exec FftProcedurePrograms.program CertificateDeclarations.code before ⟨ready before,.normal⟩ := by
  have last : Exec FftProcedurePrograms.program
      (.seq (.base (.scalar CertificateDeclarations.treeDecl)) CertificateDeclarations.skip)
      (CertificateDeclarations.clearAll before) ⟨ready before,.normal⟩ :=
    .seqNormal _ _ _ _ _
      (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["treesize".toList] _))
      (.base .skip _ _ (.skip _))
  exact .seqNormal _ _ _ _ _ (CertificateDeclarations.group_exists _ CertificateDeclarations.firstNames before)
    (.seqNormal _ _ _ _ _ (CertificateDeclarations.group_exists _ CertificateDeclarations.secondNames _)
      (.seqNormal _ _ _ _ _ (CertificateDeclarations.group_exists _ CertificateDeclarations.thirdNames _) last))

theorem local_preserved (before : State) (name : Name) (different : name≠"treesize".toList) :
    (ready before).locals name=before.locals name := by
  change C99ScalarReference.set (CertificateDeclarations.clearAll before).locals "treesize".toList (.uint64,none) name=before.locals name
  rw [CertificateDeclarations.clearAll_locals]
  exact ite_eq_right different

theorem heap_preserved (before : State) : (ready before).heap=before.heap := by
  simp only [ready,C99DeclarationStatements.effect,CertificateDeclarations.clearAll,CertificateDeclarations.clear_heap]
theorem tmp_preserved (before : State) : (ready before).arrays "tmp".toList=before.arrays "tmp".toList := by
  simp [ready,C99DeclarationStatements.effect,CertificateDeclarations.clearAll,CertificateDeclarations.clear,
    CertificateDeclarations.firstNames,CertificateDeclarations.secondNames,CertificateDeclarations.thirdNames]
theorem n_preserved (before : State) : (ready before).locals "n".toList=before.locals "n".toList :=
  local_preserved before "n".toList (by decide)
theorem logn_preserved (before : State) : (ready before).locals "logn".toList=before.locals "logn".toList :=
  local_preserved before "logn".toList (by decide)

end FT1536.Source3.CertificateEntryDeclarations
