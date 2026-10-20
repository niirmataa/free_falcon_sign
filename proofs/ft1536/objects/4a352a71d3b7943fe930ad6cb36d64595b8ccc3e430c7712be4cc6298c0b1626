import Source3.C99CheckModels

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99CheckBridge
open B20.C C99MemoryReference C99CheckReference C99CheckModels C99ValueBridge

theorem bad_word (w : BitVec 64) (old : BitVec 32) :
    old ||| (valid w ^^^ 1)=Run2.KeygenLeafGate.stableBad w old := by
  rfl

theorem reference_law (before after : C99MemoryReference.Memory) (p : ArrayPointer)
    (w : BitVec 64) (out : C99IntegerReference.Value)
    (h : C99CheckReference.Exec C99CheckCalls.calls code (entry w) before p out after) :
    out=.uint64 (Run2.KeygenLeafGate.stableWord w) ∧
      ∃ old, Load32 before p old ∧ Store32 before p (Run2.KeygenLeafGate.stableBad w old) after := by
  cases h with
  | step env old new rhsVal merged result after hpre hrhs hload hop hconv hwrite htail =>
      have hpre' : C99ScalarReference.Exec C99CheckCalls.calls (C99Typing.environment (initial w))
          (C99Frontend.scalars prelude) (.normal env) := by rw [entry_related]; exact hpre
      obtain ⟨sm,hm,henv,_,_⟩ := C99NormalBodyBridge.normal_complete C99CheckCalls.signature C99CheckCalls.calls
        StablePositive.pureCalls C99CheckCalls.calls_ok prelude (initial w) localTypes env
        (initial_good w) prelude_checked hpre'
      have hsm : sm=locals w := Option.some.inj (hm.symm.trans (prelude_model w))
      subst sm
      rw [← henv] at hrhs htail
      have he := (C99ExpressionBridge.expression_complete C99CheckCalls.signature C99CheckCalls.calls
        StablePositive.pureCalls C99CheckCalls.calls_ok (locals w) (locals_good w) rhs .u32 rhsVal rhs_checked hrhs).1
      have hv : encode rhsVal=.u32 (valid w ^^^ 1) := Option.some.inj (he.symm.trans (rhs_model w))
      have ho := C99OperatorBridge.binary_complete .bor (.uint32 old) rhsVal merged
        (by intro hn; cases hn <;> contradiction) (by intro hn; contradiction) hop
      rw [hv] at ho
      have hmerged : encode merged=.u32 (old ||| (valid w ^^^ 1)) := by
        exact (Option.some.inj ho).symm
      have hmv : merged=.uint32 (old ||| (valid w ^^^ 1)) := by
        have hm := congrArg value hmerged
        rw [value_encode] at hm
        exact hm
      have hnew : new=Run2.KeygenLeafGate.stableBad w old := by
        rw [hmv] at hconv
        simpa [C99IntegerReference.convert,C99IntegerReference.Value.integer,← bad_word] using hconv.symm
      obtain ⟨ctx,hctx⟩ := Option.isSome_iff_exists.mp suffix_checked
      have hs := C99BodyBridge.body_complete C99CheckCalls.signature C99CheckCalls.calls
        StablePositive.pureCalls C99CheckCalls.calls_ok suffix .u64 (locals w) ctx result
        (locals_good w) hctx htail
      have hresult : B20.C.cast .u64 (encode result)=.u64 (Run2.KeygenLeafGate.stableWord w) :=
        Option.some.inj (hs.symm.trans (suffix_model w))
      have hfinal := congrArg value hresult
      rw [cast_matches,value_encode] at hfinal
      exact ⟨hfinal,old,hload,by rw [hnew] at hwrite; exact hwrite⟩

theorem reference_of_memory (before after : C99MemoryReference.Memory) (p : ArrayPointer)
    (w : BitVec 64) (old : BitVec 32) (hr : Load32 before p old)
    (hw : Store32 before p (Run2.KeygenLeafGate.stableBad w old) after) :
    Check before p w (Run2.KeygenLeafGate.stableWord w) after := by
  obtain ⟨hpre,_,_⟩ := C99BodySound.normal_sound C99CheckCalls.signature C99CheckCalls.calls
    StablePositive.pureCalls C99CheckCalls.calls_sound prelude (initial w) (locals w) localTypes
    (initial_good w) prelude_checked (prelude_model w)
  rw [entry_related] at hpre
  have hrhs := C99ExpressionSound.expression_sound C99CheckCalls.calls StablePositive.pureCalls
    C99CheckCalls.calls_sound (locals w) (locals_good w) rhs (.u32 (valid w ^^^ 1)) (rhs_model w)
  have hop : C99OperatorBridge.Binary .bor (.uint32 old) (.uint32 (valid w ^^^ 1))
      (.uint32 (Run2.KeygenLeafGate.stableBad w old)) :=
    C99IntegerSound.bitwise_sound .or (.u32 old) (.u32 (valid w ^^^ 1))
      (.u32 (Run2.KeygenLeafGate.stableBad w old)) (by rfl)
  obtain ⟨ctx,hctx⟩ := Option.isSome_iff_exists.mp suffix_checked
  obtain ⟨result,htail,hresult⟩ := C99BodySound.return_sound C99CheckCalls.signature C99CheckCalls.calls
    StablePositive.pureCalls C99CheckCalls.calls_sound suffix .u64 (locals w) ctx
    (.u64 (Run2.KeygenLeafGate.stableWord w)) (locals_good w) hctx (suffix_model w)
  have hfinal := congrArg value hresult
  rw [cast_matches,value_encode] at hfinal
  change C99IntegerReference.Value.uint64 (Run2.KeygenLeafGate.stableWord w)=
    C99IntegerReference.convert .uint64 result.integer at hfinal
  change C99CheckReference.Exec _ _ _ _ _ _ _
  rw [hfinal]
  exact C99CheckReference.Exec.step _ old _ _ _ result after hpre hrhs hr hop
    (by simp [C99IntegerReference.convert,C99IntegerReference.Value.integer]) hw htail

theorem check_iff (before after : C99MemoryReference.Memory) (p : ArrayPointer) (w z : BitVec 64) :
    Check before p w z after ↔ z=Run2.KeygenLeafGate.stableWord w ∧
      ∃ old, Load32 before p old ∧ Store32 before p (Run2.KeygenLeafGate.stableBad w old) after := by
  constructor
  · intro h
    obtain ⟨hz,hr⟩ := reference_law before after p w (.uint64 z) h
    exact ⟨C99IntegerReference.Value.uint64.inj hz,hr⟩
  · rintro ⟨rfl,old,hr,hw⟩
    exact reference_of_memory before after p w old hr hw

end FT1536.Source3.C99CheckBridge

#print axioms FT1536.Source3.C99CheckBridge.check_iff
