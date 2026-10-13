import Source3.KeygenDecodeNoneCoefficient

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Construct the complete pinned coefficient body from legal memory and
   actual initialized input bytes, including the real range branch/store.
   Destination values need not be initialized to the desired result. -/
namespace FT1536.Source3.KeygenDecodeNoneCoefficientExists
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneCore KeygenDecodeNoneScalar KeygenDecodeNoneReady
open KeygenDecodeWordOps

def freshW (s : State) : State := ⟨s.heap,localSet s.locals "w".toList .uint32 none,s.buf⟩
def freshY (s : State) : State := ⟨s.heap,localSet s.locals "y".toList .int64 none,s.buf⟩
def setW (s : State) (word : BitVec 32) : State :=
  withLocals s (localSet s.locals "w".toList .uint32 (some (.uint32 word)))
def setY (s : State) (input : BitVec 16) : State :=
  withLocals s (localSet s.locals "y".toList .int64 (some (.int64 (BitVec.ofInt 64 input.toInt))))

theorem w_cell (s : State) (word : BitVec 32) : Cell "w" .uint32 (.uint32 word) (setW s word).locals := by
  simp only [Cell,setW,withLocals,localSet,C99ScalarReference.set,ite_true]

theorem y_cell (s : State) (input : BitVec 16) :
    Cell "y" .int64 (.int64 (BitVec.ofInt 64 input.toInt)) (setY s input).locals := by
  simp only [Cell,setY,withLocals,localSet,C99ScalarReference.set,ite_true]

theorem narrow_word (input : BitVec 16) :
    BitVec.ofInt 16 (C99IntegerReference.Value.int32 (BitVec.ofInt 32 input.toInt)).integer=input := by
  rw [C99IntegerReference.Value.integer,KeygenCodecStaticCountdown.signed_exact input.toInt
    (by have lower:=input.le_toInt; omega) (by have upper:=input.toInt_lt; omega),BitVec.ofInt_toInt]

/-- Legal writable destination and genuine high/low input byte loads suffice
    to construct every source operation of the whole coefficient body. -/
theorem coefficient_exists (args : Args) (s : State) (n : Nat) (bound : n<1536)
    (src dst hiPtr loPtr atWord : ArrayPointer) (input : BitVec 16) (carrier : Carrier input)
    (ready : Ready args n src dst s)
    (highStep : PointerAdd src (2*n) hiPtr) (lowStep : PointerAdd src (2*n+1) loPtr)
    (highLoad : LoadByte s.heap hiPtr (high input)) (lowLoad : LoadByte s.heap loPtr (low input))
    (destination : PointerAdd dst n atWord)
    (allocated : Allocated s.heap atWord) (width : atWord.elementBytes=2)
    (writable : s.heap.writable atWord.block=true) :
    ∃ after, Exec args KeygenDecodeNoneBinding.node041 s after .normal ∧
      Store16 s.heap atWord input after.heap ∧ Ready args n src dst after := by
  let s1 := freshW s
  let s2 := freshY s1
  let word := joined (high input) (low input)
  let s3 := setW s2 word
  let s4 := setW s3 (signedWord word)
  let s5 := setW s4 (adjusted (high input) (low input))
  let s6 := setY s5 input
  have e0 : Exec args KeygenDecodeNoneBinding.node020 s s1 .normal :=
    .declare args s [⟨"w".toList,.u32,none⟩] (localSet s.locals "w".toList .uint32 none) rfl
  have e1 : Exec args KeygenDecodeNoneBinding.node021 s1 s2 .normal :=
    .declare args s1 [⟨"y".toList,.long,none⟩] (localSet s1.locals "y".toList .int64 none) rfl
  have r1 := ready_frame args n src dst _ s s1 .normal e0 (by unfold Checks; decide +kernel) ready
  have r2 := ready_frame args n src dst _ s1 s2 .normal e1 (by unfold Checks; decide +kernel) r1
  have w2 := (KeygenDecodeCellFrame.exec_frame "w".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
    (declare_w args s s1 .normal e0)
  have h2 : LoadByte s2.heap hiPtr (high input) := highLoad
  have l2 : LoadByte s2.heap loPtr (low input) := lowLoad
  have readCalc := KeygenDecodeNoneRead.joined_calculation args s2 n (by omega) r2.cursor
    src hiPtr loPtr (high input) (low input) r2.buffer highStep lowStep h2 l2
  have e2 : Exec args KeygenDecodeNoneBinding.node022 s2 s3 .normal := by
    have actual := assign_exists args s2 "w".toList .uint32 none KeygenDecodeNoneRead.joinRhs (.uint32 word)
      (by decide +kernel) (by decide +kernel) w2 readCalc
    simpa only [self32,setW,KeygenDecodeNoneBinding.node022,KeygenDecodeNoneRead.joinRhs,KeygenDecodeNoneRead.index,s3] using actual
  have r3 := ready_frame args n src dst _ s2 s3 .normal e2 (by unfold Checks; decide +kernel) r2
  have e3 : Exec args KeygenDecodeNoneBinding.node023 s3 s4 .normal := by
    have actual := KeygenDecodeAssignments.compound_exists args s3 "w".toList .uint32 (.uint32 word)
      .bor .bor signRhs (.uint32 (-(word &&& 32768))) (.uint32 (signedWord word))
      (by decide +kernel) (by decide +kernel) (w_cell s2 word) rfl
      (sign_calculation args s3 word (w_cell s2 word)) (.bor _ _ _ (or32 _ _))
    simpa only [self32,setW,KeygenDecodeNoneBinding.node023,signRhs,s4] using actual
  have r4 := ready_frame args n src dst _ s3 s4 .normal e3 (by unfold Checks; decide +kernel) r3
  have e4 : Exec args KeygenDecodeNoneBinding.node024 s4 s5 .normal := by
    have actual := KeygenDecodeAssignments.compound_exists args s4 "w".toList .uint32 (.uint32 (signedWord word))
      .add .add (.variable "q".toList) (.uint32 18433) (.uint32 (adjusted (high input) (low input)))
      (by decide +kernel) (by decide +kernel) (w_cell s3 (signedWord word)) rfl
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) r4.q) (.add _ _ _ (add32 _ _))
    simpa only [self32,setW,KeygenDecodeNoneBinding.node024,s5] using actual
  have r5 := ready_frame args n src dst _ s4 s5 .normal e4 (by unfold Checks; decide +kernel) r4
  have guardExec : Exec args KeygenDecodeNoneBinding.node029 s5 s5 .normal :=
    guard_exists args s5 input carrier (w_cell s4 _) r5.hq r5.tq
  have y5 := (KeygenDecodeCellFrame.exec_frame "y".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans
    ((KeygenDecodeCellFrame.exec_frame "y".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "y".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
        (declare_y args s1 s2 .normal e1)))
  have e5 : Exec args KeygenDecodeNoneBinding.node030 s5 s6 .normal :=
    KeygenDecodeNoneSubtract.subtract_exists args s5 input carrier (w_cell s4 _) r5.q y5
  have r6 := ready_frame args n src dst _ s5 s6 .normal e5 (by unfold Checks; decide +kernel) r5
  let last : State := ⟨KeygenDecodeWrite16.overwrite s.heap atWord input,s6.locals,s6.buf⟩
  have e6 : Exec args KeygenDecodeNoneBinding.node031 s6 last .normal := by
    have indexCalc : Computes args s6.heap s6.buf s6.locals (.variable "u".toList)
        (.uint64 (BitVec.ofNat 64 n)) := .scalar _ _ _ (by unfold Ordinary; decide +kernel) r6.cursor
    apply Exec.store args s6 (.variable "u".toList) (.cast .i16 (.variable "y".toList))
      s6.locals s6.locals dst atWord (.uint64 (BitVec.ofNat 64 n))
      (.int32 (BitVec.ofInt 32 input.toInt)) (KeygenDecodeWrite16.overwrite s.heap atWord input)
      r6.destination (computes_exists _ _ _ _ _ _ indexCalc)
    · rw [KeygenCodecNoneCursor.unsigned_nat64 n (by omega)]; omega
    · rw [KeygenCodecNoneCursor.unsigned_nat64 n (by omega)]
      exact destination
    · exact computes_exists _ _ _ _ _ _ (KeygenDecodeNoneSubtract.narrow_calculation args s6 input (y_cell s5 input))
    · rw [narrow_word]
      exact KeygenDecodeWrite16.exists_store s.heap atWord input allocated width writable
  have bodyExec : Exec args KeygenDecodeNoneBinding.node040 s last .normal :=
    .seq args _ _ s s1 last .normal e0
      (.seq args _ _ s1 s2 last .normal e1
        (.seq args _ _ s2 s3 last .normal e2
          (.seq args _ _ s3 s4 last .normal e3
            (.seq args _ _ s4 s5 last .normal e4
              (.seq args _ _ s5 s5 last .normal guardExec
                (.seq args _ _ s5 s6 last .normal e5
                  (.seq args _ _ s6 last last .normal e6 (.skip args last))))))))
  let after := scopeExit KeygenDecodeNoneBinding.node040 s last
  have full : Exec args KeygenDecodeNoneBinding.node041 s after .normal :=
    .scope args _ s last .normal (by intro impossible; cases impossible) bodyExec
  have actual := KeygenDecodeNoneCoefficient.source_store args s after .normal n bound
    src dst hiPtr loPtr atWord input carrier ready highStep lowStep highLoad lowLoad destination full
  exact ⟨after,full,actual.2.1,actual.2.2⟩

end FT1536.Source3.KeygenDecodeNoneCoefficientExists
