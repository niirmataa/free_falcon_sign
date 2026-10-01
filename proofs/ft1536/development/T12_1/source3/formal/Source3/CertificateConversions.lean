import Source3.SmallintsInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateConversions
open C99ArrayReference (Name State)
open C99MemoryReference C99InitializationTrace

def calls : List (Name×Name) :=
  [("tf".toList,"f".toList),("tg".toList,"g".toList),
   ("tF".toList,"F".toList),("tG".toList,"G".toList)]
def signatures (name : Name) : Option (List C99ArrayReference.Param×Option C99IntegerReference.Ty) :=
  if name="smallints_to_fpr_keygen".toList then some (SmallintsProgram.function.params,none)
  else FftProcedurePrograms.signatures name
def code : C99ProcedureReference.Stmt := C99ProcedureParser.chain (calls.map (fun pair =>
  .call "smallints_to_fpr_keygen".toList (SmallintsInvocation.args pair.1 pair.2) .discard))
def sourceBody : Option C99ProcedureReference.Stmt := do
  let chars := ((Pinned.keygenLines.drop 7716).take 4).flatMap String.toList++['}']
  let ts ← C99ProcedureParser.tokens chars
  let (body,_,rest) ← C99ProcedureParser.body signatures CertificateAfterConversion.context 256 ts
  if rest.isEmpty then pure body else none
theorem source_bound : sourceBody=some code := by decide

/- The call table is closed: every step executes SmallintsProgram's parsed
   body through its actual binding/return judgment, rather than a callee
   postcondition. This is the source sequence at7717--7720. -/
inductive Sequence : List (Name×Name) → State → State → Prop where
  | done (s : State) : Sequence [] s s
  | next (destination source : Name) (rest : List (Name×Name)) (before middle after : State)
      (head : SmallintsInvocation.Call destination source before middle)
      (tail : Sequence rest middle after) : Sequence ((destination,source)::rest) before after

theorem bindings (names : List (Name×Name)) (before after : State) (execution : Sequence names before after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  induction execution with
  | done => exact ⟨rfl,rfl,rfl⟩
  | next destination source rest before middle after head tail ih =>
      have hh := SmallintsInvocation.caller_bindings destination source before middle head
      exact ⟨ih.1.trans hh.1,ih.2.1.trans hh.2.1,ih.2.2.trans hh.2.2⟩

theorem memory_steps (names : List (Name×Name)) (before after : State) (execution : Sequence names before after) :
    Steps before.heap after.heap := by
  induction execution with
  | done => exact .done _
  | next destination source rest before middle after head tail ih =>
      exact steps_trans _ _ _ (SmallintsInvocation.memory_steps destination source before middle head) ih

theorem source_frame (names : List (Name×Name)) (before after : State) (execution : Sequence names before after)
    (block offset : Nat) (outside : C99ArrayFrame.Outside before (names.map Prod.fst) block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  induction execution with
  | done => rfl
  | next destination source rest before middle after head tail ih =>
      have hb := SmallintsInvocation.caller_bindings destination source before middle head
      have ho : C99ArrayFrame.Outside before [destination] block offset := by
        intro name hn p hp
        have he : name=destination := by simpa only [List.mem_singleton] using hn
        subst name
        exact outside destination (by simp) p hp
      have hr : C99ArrayFrame.Outside middle (rest.map Prod.fst) block offset := by
        intro name hn p hp
        rw [hb.2.1] at hp
        exact outside name (by simp [hn]) p hp
      have ht : C99PointerFootprint.TablesOutside middle block offset := by
        simpa only [C99PointerFootprint.TablesOutside,hb.2.2] using tables
      exact (ih hr ht).trans (SmallintsInvocation.caller_frame destination source before middle head block offset ho tables)

theorem destination_initialized (names : List (Name×Name)) (before after : State)
    (execution : Sequence names before after)
    (logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (destination source : Name) (member : (destination,source)∈names) (dst src : ArrayPointer)
    (hd : before.arrays destination=some dst) (hs : before.arrays source=some src) (width : dst.elementBytes=8) :
    Initialized after.heap dst.block dst.offset 12288 := by
  induction execution with
  | done => simp at member
  | next outName inName rest before middle after head tail ih =>
      rcases List.mem_cons.mp member with same | member
      · have hnames := Prod.mk.inj same
        obtain ⟨rfl,rfl⟩ := hnames
        have hi := SmallintsInvocation.output_initialized destination source dst src before middle logn hd hs width head
        exact region_preserved middle.heap after.heap (steps_preserve _ _ (memory_steps rest middle after tail))
          dst.block dst.offset 12288 hi
      · have hb := SmallintsInvocation.caller_bindings outName inName before middle head
        exact ih (by simpa only [hb.1] using logn) member
          (by simpa only [hb.2.1] using hd) (by simpa only [hb.2.1] using hs)

end FT1536.Source3.CertificateConversions
