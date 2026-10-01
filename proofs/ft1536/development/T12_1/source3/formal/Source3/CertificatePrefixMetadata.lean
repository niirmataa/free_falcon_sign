import Source3.CertificateTailMetadata

namespace FT1536.Source3.CertificatePrefixMetadata
open C99ArrayReference (State bindPointer bindValue)
open C99ProcedureReference (Exec Result)
open CertificateAfterConversion (workspacePointer)

theorem source_result (base : Nat) (before : State) (result : Result)
    (hn : C99AliasSequence.HasN before)
    (gxx : before.arrays "gxx".toList=some (workspacePointer base 7))
    (slot : before.locals "treesize".toList=some (.uint64,none))
    (source : Exec FftProcedurePrograms.program CertificateAfterConversion.code before result) :
    result=⟨{CertificateTailMetadata.ready base before with heap := result.state.heap},.normal⟩ := by
  obtain ⟨middle,_,hm,tail⟩ := CertificateGramPrefix.source_split before result source
  have hl := congrArg State.locals hm
  have ha := congrArg State.arrays hm
  change middle.locals=before.locals at hl
  change middle.arrays=before.arrays at ha
  have hmidN : C99AliasSequence.HasN middle := by simpa only [C99AliasSequence.HasN,hl] using hn
  have hmidG : middle.arrays "gxx".toList=some (workspacePointer base 7) := by simpa only [ha] using gxx
  have hmidS : middle.locals "treesize".toList=some (.uint64,none) := by simpa only [hl] using slot
  have he := CertificateTailMetadata.source_result base middle result hmidN hmidG hmidS tail
  rw [hm] at he
  exact he

theorem ready_n (base : Nat) (before : State) :
    (CertificateTailMetadata.ready base before).locals "n".toList=before.locals "n".toList := by
  simp [CertificateTailMetadata.ready,CertificateTailMetadata.afterSize,CertificateTailMetadata.afterTree,
    bindPointer,bindValue,C99ScalarReference.set]
theorem ready_hn (base : Nat) (before : State) :
    (CertificateTailMetadata.ready base before).locals "hn".toList=before.locals "hn".toList := by
  simp [CertificateTailMetadata.ready,CertificateTailMetadata.afterSize,CertificateTailMetadata.afterTree,
    bindPointer,bindValue,C99ScalarReference.set]
theorem ready_g00 (base : Nat) (before : State) :
    (CertificateTailMetadata.ready base before).arrays "g00".toList=before.arrays "g00".toList := by
  simp [CertificateTailMetadata.ready,CertificateTailMetadata.afterSize,CertificateTailMetadata.afterTree,
    bindPointer,bindValue]
theorem ready_t3 (base : Nat) (before : State) :
    (CertificateTailMetadata.ready base before).arrays "t3".toList=some (workspacePointer base 20) := by
  simp [CertificateTailMetadata.ready,bindPointer]

theorem source_pointers (base : Nat) (before : State) (result : Result)
    (hn : C99AliasSequence.HasN before)
    (gxx : before.arrays "gxx".toList=some (workspacePointer base 7))
    (g00 : before.arrays "g00".toList=some (workspacePointer base 4))
    (slot : before.locals "treesize".toList=some (.uint64,none))
    (source : Exec FftProcedurePrograms.program CertificateAfterConversion.code before result) :
    result.flow=.normal ∧ result.state.arrays "g00".toList=some (workspacePointer base 4) ∧
      result.state.arrays "t3".toList=some (workspacePointer base 20) := by
  rw [source_result base before result hn gxx slot source]
  exact ⟨rfl,(ready_g00 base before).trans g00,ready_t3 base before⟩

end FT1536.Source3.CertificatePrefixMetadata
