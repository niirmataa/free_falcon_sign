import Source3.KeygenSamplerPrefix128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrefixCompose128
open KeygenSamplerPrefix128 (Prefix)

theorem append (ctx : ShakeExtractSource.Layout) (n m : Nat)
    (before middle after : C99ArrayReference.State)
    (first : Prefix ctx n before middle) (second : Prefix ctx m middle after) :
    Prefix ctx (n+m) before after := by
  induction first with
  | done => simpa only [Nat.zero_add] using second
  | next count before declared sampled updated middle value guard nonzero declaration inner increment rest ih =>
      rw [Nat.succ_add]
      exact .next (count+m) before declared sampled updated after value guard nonzero declaration inner increment (ih second)

theorem done (ctx : ShakeExtractSource.Layout) (state : C99CompactState115.State)
    (value : B20.C.Val)
    (computed : C99CompactScalar115.evaluate C99CompactPointer115.noCalls state.locals C99CountedWords.condition=some value)
    (zero : value.integer=0) :
    KeygenSamplerSource.Outer ctx (C99CompactState115.reference state) (C99CompactState115.reference state) :=
  .done _ (C99ValueBridge.value value)
    (C99CompactScalar115.evaluate_sound FprPrefixCalls.calls C99CompactPointer115.noCalls
      (C99CompactPointer115.noCalls_sound _) state.locals C99CountedWords.condition value computed)
    (by simpa only [C99ValueBridge.integer_matches] using zero)

end FT1536.Source3.KeygenPrefixCompose128
