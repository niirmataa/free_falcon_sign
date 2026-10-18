import Source3.PublicTripleShape165
import Source3.PublicU32Locals165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleProducts165
open C99ArrayReference (State)
open KeygenPublicExec (Exec)
open PublicU32Locals165 (Env Ready)
open PublicTripleShape165 (names loaded completed products)
open PublicGenerateRow159 (chain_step)

theorem source (s : State) (env : Env s names) (ready : Ready s loaded) :
    ∃ after, Exec KeygenPublicSource.program [] products s ⟨after,.normal⟩ ∧
      Env after names ∧ Ready after completed ∧ after.heap=s.heap := by
  obtain ⟨s1,r1,e1,v1,h1⟩ := PublicU32Locals165.square s names loaded env ready
    "x2" "x" (by decide) (by decide)
  obtain ⟨s2,r2,e2,v2,h2⟩ := PublicU32Locals165.mont s1 names _ e1 v1
    "fB0" "fB" "x" (by decide) (by decide) (by decide)
  obtain ⟨s3,r3,e3,v3,h3⟩ := PublicU32Locals165.mont s2 names _ e2 v2
    "fB1" "fB0" "w" (by decide) (by decide) (by decide)
  obtain ⟨s4,r4,e4,v4,h4⟩ := PublicU32Locals165.mont s3 names _ e3 v3
    "fB2" "fB1" "w" (by decide) (by decide) (by decide)
  obtain ⟨s5,r5,e5,v5,h5⟩ := PublicU32Locals165.mont s4 names _ e4 v4
    "fC0" "fC" "x2" (by decide) (by decide) (by decide)
  obtain ⟨s6,r6,e6,v6,h6⟩ := PublicU32Locals165.mont s5 names _ e5 v5
    "fC1" "fC0" "w" (by decide) (by decide) (by decide)
  obtain ⟨s7,r7,e7,v7,h7⟩ := PublicU32Locals165.mont s6 names _ e6 v6
    "fC2" "fC1" "w" (by decide) (by decide) (by decide)
  exact ⟨s7,chain_step _ _ s s1 ⟨s7,.normal⟩ r1
    (chain_step _ _ s1 s2 ⟨s7,.normal⟩ r2
      (chain_step _ _ s2 s3 ⟨s7,.normal⟩ r3
        (chain_step _ _ s3 s4 ⟨s7,.normal⟩ r4
          (chain_step _ _ s4 s5 ⟨s7,.normal⟩ r5
            (chain_step _ _ s5 s6 ⟨s7,.normal⟩ r6
              (chain_step _ _ s6 s7 ⟨s7,.normal⟩ r7 (.skip s7))))))),e7,v7,
    h7.trans (h6.trans (h5.trans (h4.trans (h3.trans (h2.trans h1)))))⟩

end FT1536.Source3.PublicTripleProducts165
