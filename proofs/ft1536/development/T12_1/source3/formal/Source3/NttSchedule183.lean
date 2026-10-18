import Source3.NttMControl183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttSchedule183

/- A finite kernel certificate for the source counter chain, not a data or
   success assumption. Every next counter must be exactly the source update. -/
inductive Schedule : Nat → Nat → Prop where
  | done : Schedule 512 3
  | step (m t h : Nat) (guard : 3<t) (product : m*t=1536) (half : t=2*h)
      (mBound : m≤512) (tBound : t≤768) (hBound : h≤768)
      (rest : Schedule (2*m) h) : Schedule m t

theorem selected : Schedule 2 768 :=
  .step 2 768 384 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 4 384 192 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 8 192 96 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 16 96 48 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 32 48 24 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 64 24 12 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 128 12 6 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  (.step 256 6 3 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
    .done)))))))

end FT1536.Source3.NttSchedule183
