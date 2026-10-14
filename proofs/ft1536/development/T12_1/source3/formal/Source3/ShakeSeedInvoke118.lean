import Source3.ShakeSeedRun118

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedInvoke118
open C99CompactState115 (State reference)
open C99MemoryReference (ArrayPointer)
open ShakeExtractSource (Layout)
open B20.C (Val)

def initEntry (state : State) (capacity : Val) : State :=
  C99CompactState115.bindValue (C99CompactState115.clearLocals state) "capacity".toList .i32 capacity

theorem initEntry_bound (state : State) (capacity : Val) :
    reference (initEntry state capacity)=ShakeSeedReference.initEntry (reference state) (C99ValueBridge.value capacity) := by
  unfold initEntry
  rw [C99CompactState115.reference_bindValue,C99CompactState115.reference_clearLocals]
  rfl

def injectEntry (state : State) (data : ArrayPointer) (length : Val) : State :=
  C99CompactState115.bindPointer
    (C99CompactState115.bindValue (C99CompactState115.clearLocals state) "len".toList .u64 length) "data".toList data

theorem injectEntry_bound (state : State) (data : ArrayPointer) (length : Val) :
    reference (injectEntry state data length)=ShakeSeedReference.injectEntry (reference state) data (C99ValueBridge.value length) := by
  unfold injectEntry
  rw [C99CompactState115.reference_bindPointer,C99CompactState115.reference_bindValue,C99CompactState115.reference_clearLocals]
  rfl

def init (ctx : Layout) (fuel : Nat) (before : State) (capacity : Val) : Option State :=
  (ShakeSeedRun118.run ctx fuel ShakeSeedProgram.initCode (initEntry before capacity)).map (fun after => {before with heap := after.heap})

theorem init_sound (ctx : Layout) (fuel : Nat) (before after : State) (capacity : Val)
    (computed : init ctx fuel before capacity=some after) :
    ShakeSeedReference.Init ctx (reference before) (C99ValueBridge.value capacity) (reference after) := by
  obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_heap]
  have source := ShakeSeedRun118.run_sound ctx fuel ShakeSeedProgram.initCode (initEntry before capacity) middle body
  rw [initEntry_bound] at source
  exact .run (reference middle) source

def inject (ctx : Layout) (fuel : Nat) (before : State) (data : ArrayPointer) (length : Val) : Option State :=
  (ShakeSeedRun118.run ctx fuel ShakeSeedProgram.injectCode (injectEntry before data length)).map (fun after => {before with heap := after.heap})

theorem inject_sound (ctx : Layout) (fuel : Nat) (before after : State) (data : ArrayPointer) (length : Val)
    (computed : inject ctx fuel before data length=some after) :
    ShakeSeedReference.Inject ctx (reference before) data (C99ValueBridge.value length) (reference after) := by
  obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_heap]
  have source := ShakeSeedRun118.run_sound ctx fuel ShakeSeedProgram.injectCode (injectEntry before data length) middle body
  rw [injectEntry_bound] at source
  exact .run (reference middle) source

def flip (ctx : Layout) (fuel : Nat) (before : State) : Option State :=
  (ShakeSeedRun118.run ctx fuel ShakeSeedProgram.flipCode (C99CompactState115.clearLocals before)).map (fun after => {before with heap := after.heap})

theorem flip_sound (ctx : Layout) (fuel : Nat) (before after : State)
    (computed : flip ctx fuel before=some after) :
    ShakeSeedReference.Flip ctx (reference before) (reference after) := by
  obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_heap]
  have source := ShakeSeedRun118.run_sound ctx fuel ShakeSeedProgram.flipCode (C99CompactState115.clearLocals before) middle body
  rw [C99CompactState115.reference_clearLocals] at source
  exact .run (reference middle) source

end FT1536.Source3.ShakeSeedInvoke118
