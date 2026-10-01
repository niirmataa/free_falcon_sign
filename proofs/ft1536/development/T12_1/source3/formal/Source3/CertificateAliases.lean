import Source3.C99AliasSequence
import Source3.CertificatePrologue

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateAliases
open C99ArrayReference (Name State bindPointer)
open C99ProcedureReference (Stmt Exec Result Program)
open C99AliasSequence
open CertificateAfterConversion (workspacePointer)

def aliases : List Alias := [
  ⟨"tf".toList,"tmp".toList,false⟩,⟨"tg".toList,"tf".toList,true⟩,
  ⟨"tF".toList,"tg".toList,true⟩,⟨"tG".toList,"tF".toList,true⟩,
  ⟨"g00".toList,"tG".toList,true⟩,⟨"g10".toList,"g00".toList,true⟩,
  ⟨"g11".toList,"g10".toList,true⟩,⟨"gxx".toList,"g11".toList,true⟩]
def bindings : List (Name×Nat) := [
  ("tf".toList,0),("tg".toList,1),("tF".toList,2),("tG".toList,3),
  ("g00".toList,4),("g10".toList,5),("g11".toList,6),("gxx".toList,7)]
def installed (base : Nat) (before : State) : State :=
  bindings.foldl (fun s pair => bindPointer s pair.1 (workspacePointer base pair.2)) before
def code : Stmt := thenCode aliases (.base .skip)

theorem source_bound : CertificateAfterConversion.parseRegion 7709 8=some code := by decide

theorem run_installed (base : Nat) (before : State)
    (tmp : before.arrays "tmp".toList=some (workspacePointer base 0)) :
    run aliases before=some (installed base before) := by
  change before.arrays ['t','m','p']=some (workspacePointer base 0) at tmp
  simp [run,aliases,evaluate,amount,advance,installed,bindings,bindPointer,workspacePointer,tmp]

theorem source_result (program : Program) (base : Nat) (before : State) (result : Result)
    (hn : HasN before) (tmp : before.arrays "tmp".toList=some (workspacePointer base 0))
    (source : Exec program code before result) : result=⟨installed base before,.normal⟩ := by
  obtain ⟨out,hr,_,ht⟩ := sequence_complete program aliases (.base .skip) before result hn source
  rw [run_installed base before tmp] at hr
  have he := Option.some.inj hr
  subst out
  exact C99ProcedureScalars.skip_result program (installed base before) result ht

theorem source_exists (program : Program) (base : Nat) (before : State)
    (hn : HasN before) (tmp : before.arrays "tmp".toList=some (workspacePointer base 0)) :
    Exec program code before ⟨installed base before,.normal⟩ :=
  sequence_sound program aliases (.base .skip) before (installed base before) _ hn
    (run_installed base before tmp) (.base .skip _ _ (.skip _))

theorem installed_heap (base : Nat) (before : State) : (installed base before).heap=before.heap := rfl
theorem installed_locals (base : Nat) (before : State) : (installed base before).locals=before.locals := rfl
theorem installed_g00 (base : Nat) (before : State) :
    (installed base before).arrays "g00".toList=some (workspacePointer base 4) := by
  simp [installed,bindings,bindPointer]
theorem installed_tg (base : Nat) (before : State) :
    (installed base before).arrays "tg".toList=some (workspacePointer base 1) := by
  simp [installed,bindings,bindPointer]

end FT1536.Source3.CertificateAliases
