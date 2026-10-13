import Source3.KeygenDecodeNoneReady

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete pinned NONE coefficient body, coupling real byte loads, scalar
   guards and the actual int16 store. No decoded output/frame premise. -/
namespace FT1536.Source3.KeygenDecodeNoneCoefficient
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeNoneCore KeygenDecodeNoneScalar KeygenDecodeNoneReady

/-- Every actual execution of the whole coefficient body on its honest
    physical input bytes writes exactly the original centered input word. -/
theorem source_store (args : Args) (s after : State) (flow : Flow) (n : Nat) (bound : n<1536)
    (src dst hiPtr loPtr atWord : ArrayPointer) (input : BitVec 16) (carrier : Carrier input)
    (ready : Ready args n src dst s)
    (highStep : PointerAdd src (2*n) hiPtr) (lowStep : PointerAdd src (2*n+1) loPtr)
    (highLoad : LoadByte s.heap hiPtr (high input)) (lowLoad : LoadByte s.heap loPtr (low input))
    (destination : PointerAdd dst n atWord)
    (source : Exec args KeygenDecodeNoneBinding.node041 s after flow) :
    flow=.normal ∧ Store16 s.heap atWord input after.heap ∧ Ready args n src dst after := by
  have finalReady := ready_frame args n src dst _ s after flow source body_checked ready
  cases source with
  | scope body s t flow noBufShadow inside =>
    obtain ⟨s1,e0,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node020 KeygenDecodeNoneBinding.node039 s t flow inside (by rfl)
    obtain ⟨s2,e1,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node021 KeygenDecodeNoneBinding.node038 s1 t flow rest (by rfl)
    obtain ⟨s3,e2,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node022 KeygenDecodeNoneBinding.node037 s2 t flow rest (by rfl)
    obtain ⟨s4,e3,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node023 KeygenDecodeNoneBinding.node036 s3 t flow rest (by rfl)
    obtain ⟨s5,e4,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node024 KeygenDecodeNoneBinding.node035 s4 t flow rest (by rfl)
    have r1 := ready_frame args n src dst _ s s1 .normal e0 (by unfold Checks; decide +kernel) ready
    have r2 := ready_frame args n src dst _ s1 s2 .normal e1 (by unfold Checks; decide +kernel) r1
    have r3 := ready_frame args n src dst _ s2 s3 .normal e2 (by unfold Checks; decide +kernel) r2
    have r4 := ready_frame args n src dst _ s3 s4 .normal e3 (by unfold Checks; decide +kernel) r3
    have r5 := ready_frame args n src dst _ s4 s5 .normal e4 (by unfold Checks; decide +kernel) r4
    have w1 := declare_w args s s1 .normal e0
    have w2 := (KeygenDecodeCellFrame.exec_frame "w".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans w1
    have y2 := declare_y args s1 s2 .normal e1
    have heap2 := (KeygenDecodeStateFrame.heap_frame args _ s1 s2 .normal e1 (by decide +kernel)).trans
      (KeygenDecodeStateFrame.heap_frame args _ s s1 .normal e0 (by decide +kernel))
    have high2 : LoadByte s2.heap hiPtr (high input) := by rw [heap2]; exact highLoad
    have low2 : LoadByte s2.heap loPtr (low input) := by rw [heap2]; exact lowLoad
    have same3 := (KeygenDecodeNoneRead.joined_source args s2 s3 .normal n (by omega) r2.cursor
      src hiPtr loPtr (high input) (low input) r2.buffer highStep lowStep high2 low2 w2 e2).1
    have w3 : Cell "w" .uint32 (.uint32 (joined (high input) (low input))) s3.locals := by
      rw [same3]
      simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true]
    have same4 := (sign_source args s3 s4 .normal _ w3 e3).1
    have w4 : Cell "w" .uint32 (.uint32 (signedWord (joined (high input) (low input)))) s4.locals := by
      rw [same4]
      simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true]
    have same5 := (add_q_source args s4 s5 .normal _ w4 r4.q e4).1
    have w5 : Cell "w" .uint32 (.uint32 (adjusted (high input) (low input))) s5.locals := by
      rw [same5]
      simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true,adjusted]
    obtain ⟨guardEnd,guardExec,rest⟩ := KeygenDecodeControl.seq_split_given args
      KeygenDecodeNoneBinding.node029 KeygenDecodeNoneBinding.node034 s5 t flow rest
      (fun next result actual => (guard_source args s5 next result input carrier w5 r5.hq r5.tq actual).2)
    have sameGuard := (guard_source args s5 guardEnd .normal input carrier w5 r5.hq r5.tq guardExec).1
    subst guardEnd
    obtain ⟨s6,e5,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node030 KeygenDecodeNoneBinding.node033 s5 t flow rest (by rfl)
    obtain ⟨s7,e6,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node031 KeygenDecodeNoneBinding.node032 s6 t flow rest (by rfl)
    cases rest
    have y5 := (KeygenDecodeCellFrame.exec_frame "y".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "y".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
        ((KeygenDecodeCellFrame.exec_frame "y".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans y2))
    have same6 := (KeygenDecodeNoneSubtract.subtract_source args s5 s6 .normal input carrier w5 r5.q y5 e5).1
    have y6 : Cell "y" .int64 (.int64 (BitVec.ofInt 64 input.toInt)) s6.locals := by
      rw [same6]
      simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true]
    have r6 := ready_frame args n src dst _ s5 s6 .normal e5 (by unfold Checks; decide +kernel) r5
    have stored := (KeygenDecodeNoneSubtract.store_source args s6 t .normal n (by omega) input dst atWord
      r6.cursor r6.destination destination y6 e6).1
    have heap6 := (KeygenDecodeStateFrame.heap_frame args _ s5 s6 .normal e5 (by decide +kernel)).trans
      ((KeygenDecodeStateFrame.heap_frame args _ s4 s5 .normal e4 (by decide +kernel)).trans
        ((KeygenDecodeStateFrame.heap_frame args _ s3 s4 .normal e3 (by decide +kernel)).trans
          ((KeygenDecodeStateFrame.heap_frame args _ s2 s3 .normal e2 (by decide +kernel)).trans heap2)))
    exact ⟨rfl,by simpa only [scopeExit,heap6] using stored,finalReady⟩

end FT1536.Source3.KeygenDecodeNoneCoefficient
