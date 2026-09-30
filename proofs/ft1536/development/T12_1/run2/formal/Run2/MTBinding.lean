import Run2.LawBinding

namespace FT1536.Run2
open Games
open FT1536.Relation

noncomputable def solverReturns (beta : Budget) (muH : Law Rq)
    (A : ClassicalAdversary beta) (S : Sampler) : Dist Bool :=
  (Dist.draw muH).bind fun h =>
    (Dist.draw (Law.uniform : Law (List.Vector Rq (beta.qh+1)))).bind fun cs =>
      ((Reduction.build beta A S).code h cs).map Option.isSome

/- The MT event is no longer an arbitrary predicate: runMT's relation test
is equal in law to the concrete constructed solver returning a witness. -/
theorem runMT_build_exact (beta : Budget) (muH : Law Rq)
    (A : ClassicalAdversary beta) (S : Sampler) :
    Dist.Same (runMT (beta.qh+1) muH (Reduction.build beta A S))
      (solverReturns beta muH A S) := by
  classical
  intro f
  simp only [runMT,solverReturns,Dist.expect_bind]
  apply Dist.expect_congr
  intro h
  apply Dist.expect_congr
  intro cs
  unfold Dist.expect
  apply Finset.sum_congr rfl
  intro x _
  have hx := build_output_sound beta A S h cs x
  change ((Reduction.build beta A S).code h cs).law.mass x *
      f (match ((Reduction.build beta A S).code h cs).out x with
        | none => false
        | some (j,z) => match cs.val[j]? with
          | none => false | some c => decide (ShortPreimage h c z)) =
    ((Reduction.build beta A S).code h cs).law.mass x *
      f (((Reduction.build beta A S).code h cs).out x).isSome
  cases hw : ((Reduction.build beta A S).code h cs).out x with
  | none => rfl
  | some w =>
    rw [hw] at hx
    obtain ⟨c,hc,hz⟩ := hx
    simp only [hc,hz,decide_true,Option.isSome_some]

theorem advantage_is_solver_returns (beta : Budget) (muH : Law Rq)
    (A : ClassicalAdversary beta) (S : Sampler) :
    AdvMT (beta.qh+1) muH (Reduction.build beta A S) =
      (solverReturns beta muH A S).event (fun b => b=true) :=
  Dist.same_event _ _ (runMT_build_exact beta muH A S) _

end FT1536.Run2
