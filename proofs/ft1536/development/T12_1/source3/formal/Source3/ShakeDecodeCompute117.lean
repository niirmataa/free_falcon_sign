import Source3.C99CompactBinding115

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeDecodeCompute117
open C99MemoryReference
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open B20.C (Val)

def ReadGuard (state : State) (pointer : ArrayPointer) : Prop :=
  Allocated (C99FiniteMemory114.memory state.heap) pointer ∧ pointer.elementBytes=1

instance readGuardDecidable (state : State) (pointer : ArrayPointer) : Decidable (ReadGuard state pointer) := by
  unfold ReadGuard
  infer_instance

def read (state : State) (pointer : ArrayPointer) : Option Byte :=
  if ReadGuard state pointer then (C99FiniteMemory114.memory state.heap).bytes pointer.block pointer.offset else none

theorem read_sound (state : State) (pointer : ArrayPointer) (value : Byte) (computed : read state pointer=some value) :
    Allocated (reference state).heap pointer ∧ pointer.elementBytes=1 ∧
    (reference state).heap.bytes pointer.block pointer.offset=some value := by
  unfold read at computed
  split at computed
  next guard => exact ⟨guard.1,guard.2,computed⟩
  next rejected => cases computed

def byteCall (state : State) : List Val → Option Val
  | [index] => do
      let root ← C99NameMap115.lookup state.arrays "buf".toList
      let pointer ← C99CompactPointer115.advance root index
      let value ← read state pointer
      pure (.i32 (BitVec.ofNat 32 value.toNat))
  | _ => none

theorem byteCall_sound (state : State) (args : List Val) (value : Val) (computed : byteCall state args=some value) :
    ShakeSeedMemory.Read8 (reference state) "$seed_byte".toList (args.map C99ValueBridge.value) (C99ValueBridge.value value) := by
  cases args with
  | nil => cases computed
  | cons index rest =>
      cases rest with
      | cons head tail => cases computed
      | nil =>
          obtain ⟨root,binding,rest⟩ := Option.bind_eq_some_iff.mp computed
          obtain ⟨pointer,advanced,rest⟩ := Option.bind_eq_some_iff.mp rest
          obtain ⟨byte,readByte,result⟩ := Option.bind_eq_some_iff.mp rest
          have same := Option.some.inj result
          subst value
          have address := C99CompactPointer115.advance_sound root pointer index advanced
          have loaded := read_sound state pointer byte readByte
          exact .byte (C99ValueBridge.value index) root pointer byte binding address.1 address.2 loaded.1 loaded.2.1 loaded.2.2

def calls (state : State) (name : C99ArrayReference.Name) (args : List Val) : Option Val :=
  if name="$seed_byte".toList then byteCall state args else none

theorem calls_sound (state : State) : C99ExpressionSound.CallsSound (ShakeSeedMemory.Read8 (reference state)) (calls state) := by
  intro name args value computed
  unfold calls at computed
  split at computed
  next matched => subst name; exact byteCall_sound state args value computed
  next rejected => cases computed

def shifted (i : Nat) : CLogic.Expr :=
  let byte := CLogic.Expr.cast .u64 (.call1 "$seed_byte".toList (.literal .i32 i))
  if i=0 then byte else .bin .shl byte (.literal .i32 (8*i))

def code : CLogic.Expr :=
  .bin .bor (.bin .bor (.bin .bor (.bin .bor (.bin .bor (.bin .bor (.bin .bor
    (shifted 0) (shifted 1)) (shifted 2)) (shifted 3)) (shifted 4)) (shifted 5)) (shifted 6)) (shifted 7)

theorem expression_bound : C99Frontend.expression code=ShakeSeedMemory.decodeExpr := rfl

def entry (state : State) (pointer : ArrayPointer) : State :=
  {state with locals := [], arrays := [("data".toList,pointer)]}

theorem entry_bound (state : State) (pointer : ArrayPointer) :
    reference (entry state pointer)=ShakeSeedMemory.decodeEntry (reference state) pointer := rfl

def decode (state : State) (pointer : ArrayPointer) : Option (BitVec 64) := do
  let declared := C99CompactPointer115.declarePointer (entry state pointer) "buf".toList
  let input ← C99CompactPointer115.pointer noCalls declared "data".toList C99ProcedureParser.zero
  let ready := C99CompactState115.bindPointer declared "buf".toList input
  let value ← C99CompactScalar115.evaluate (calls ready) ready.locals code
  match value with | .u64 word => some word | _ => none

theorem decode_sound (before : State) (pointer : ArrayPointer) (word : BitVec 64)
    (computed : decode before pointer=some word) : ShakeSeedMemory.Decode (reference before) pointer word := by
  let declared := C99CompactPointer115.declarePointer (entry before pointer) "buf".toList
  obtain ⟨input,address,rest⟩ := Option.bind_eq_some_iff.mp computed
  let ready := C99CompactState115.bindPointer declared "buf".toList input
  obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
  cases value with
  | i64 value | u32 value | i32 value => cases result
  | u64 value =>
      have same := Option.some.inj result
      subst word
      refine .run (reference declared) (reference ready) value ?_ ?_ ?_
      · dsimp only [declared]
        rw [C99CompactPointer115.declarePointer_reference,entry_bound]
        exact .declarePtr _ _
      · dsimp only [ready]
        rw [C99CompactState115.reference_bindPointer]
        exact .bindPtr _ _ _ _ input
          (C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _) declared _ _ input address)
      · have calculation := C99CompactScalar115.evaluate_sound (ShakeSeedMemory.Read8 (reference ready)) (calls ready)
          (calls_sound ready) ready.locals code (.u64 value) evaluated
        rw [expression_bound] at calculation
        exact calculation

end FT1536.Source3.ShakeDecodeCompute117
