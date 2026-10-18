import Source3.TopInitShape178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopInit178
open C99ArrayReference (State bindValue)
open KeygenLevelExec (Exec)
open TopInitShape178
open KeygenFullData127 (primes)

def p := KeygenNinv31.prime
def p0i := KeygenNinv31.word p
def r2 := KeygenModpR2Word.word p p0i
noncomputable def before := SelectedTopMove177.after
noncomputable def withP := bindValue before "p".toList .uint32 (.uint32 p)
noncomputable def withI := bindValue withP "p0i".toList .uint32 (.uint32 p0i)
noncomputable def after := bindValue withI "R2".toList .uint32 (.uint32 r2)

theorem prime_read : KeygenLevelCalls.PrimeRead before "PRIMES3".toList (.literal .i32 0) .p (.uint32 p) :=
  .read primes p (.add _ _ primes primes (.int32 0) SelectedTopStatics178.prime_binding
    (.literal .int32 0) (by decide) (.within primes 0 (by change 0≤_; exact Nat.zero_le _)))
    rfl (by decide) SelectedTopStatics178.p_bytes

theorem p_source : Exec pSet before ⟨withP,.normal⟩ :=
  .prime _ _ _ _ _ .uint32 none (.uint32 p) rfl prime_read

theorem i_source : Exec iSet withP ⟨withI,.normal⟩ :=
  .modular _ _ _ (.assign _ _ _ .uint32 none (.uint32 p0i) rfl
    (.call1 _ _ _ _ (.scalar _ _ (.variable _ _ _ rfl))
      (.inverse _ _ (KeygenNinv31.source_exists p))))

theorem r_source : Exec rSet withI ⟨after,.normal⟩ :=
  .modular _ _ _ (.assign _ _ _ .uint32 none (.uint32 r2) rfl
    (.call2 _ _ _ _ _ _ (.scalar _ _ (.variable _ _ _ rfl)) (.scalar _ _ (.variable _ _ _ rfl))
      (.r2 _ _ (KeygenModpR2Exec.source_exists withI p p0i))))

theorem source : LevelSequence177.Run steps before after :=
  .cons _ _ _ _ _ p_source (.cons _ _ _ _ _ i_source (.cons _ _ _ _ _ r_source (.nil after)))

theorem heap : after.heap=before.heap := rfl
theorem p_cell : after.locals "p".toList=some (.uint32,some (.uint32 p)) := rfl
theorem i_cell : after.locals "p0i".toList=some (.uint32,some (.uint32 p0i)) := rfl
theorem r_cell : after.locals "R2".toList=some (.uint32,some (.uint32 r2)) := rfl

theorem continue_top (out : C99ProcedureReference.Result)
    (rest : Exec (.seq generate remaining) after out) :
    Exec KeygenMakeFgTop.code SelectedMakeFgTopEntry176.entry out := by
  apply SelectedTopMove177.continue_body out
  rw [shape]
  exact LevelSequence177.source steps before after source _ out rest

end FT1536.Source3.SelectedTopInit178
