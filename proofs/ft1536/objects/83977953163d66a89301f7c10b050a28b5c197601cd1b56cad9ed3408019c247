import Source3.FprPrimitives
import B20.C.ByteMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprCFrame
open FT1536.Source3.FprPrimitives
open B20.C

/- A byte-addressed heap is threaded through the execution of the *parsed*
   C scalar fragment. Stack locals live in a distinct typed environment.
   A pointer write would need a heap-effectful instruction: the scalar source
   grammar has none, and every nested header call is separately parsed into
   this pointer-free scalar grammar. The byte heap is not silently replaced
   by a postulated return value. -/
structure Machine where
  locals : B20.C.Scalar.State
  heap : B20.C.Byte.Memory

def run : Nat → Ty → List Instr → Machine → Option (Machine × Option Val)
  | 0,_,_,_ => none
  | _+1,_,[],s => some (s,none)
  | _+1,result,.scalar (.ret e) :: _,s => do
      let v ← FT1536.Source3.CLogic.eval headerCalls s.locals.values 32 e
      pure (s,some (B20.C.cast result v))
  | fuel+1,result,.scalar stmt :: rest,s => do
      let next ← FT1536.Source3.CLogic.step headerCalls s.locals stmt
      run fuel result rest {s with locals := next}
  | fuel+1,result,.norm mant exp :: rest,s => do
      let body ← normStatements mant exp
      let next ← execScalars body s.locals
      run fuel result rest {s with locals := leaveBlock s.locals next (scalarDecls body)}
  | fuel+1,result,.forInc index n body :: rest,s => do
      let first ← B20.C.Scalar.assign s.locals index (.i32 0)
      let start : Machine := {s with locals := first}
      let after ← (List.range n).foldlM (fun acc _ => do
        if !(← guard index n acc.locals) then none else do
          let (next, v) ← run fuel result body acc
          if v.isSome then none else do
            let updated ← inc index (leaveBlock acc.locals next.locals (blockDecls body))
            pure {next with locals := updated}) start
      if (← guard index n after.locals) then none else run fuel result rest after

def sourceCall (p : Option FprPrimitives.Function) (x y : BitVec 64)
    (heap : B20.C.Byte.Memory) : Option (BitVec 64 × B20.C.Byte.Memory) := do
  let f ← p
  let locals ← B20.C.Scalar.bindArgs f.params [.u64 x,.u64 y]
  let (final, value) ← run 256 f.result f.body ⟨locals,heap⟩
  match ← value with
  | .u64 z => some (z,final.heap)
  | _ => none

/- Heap in this semantics can contain live, uninitialized and unrelated
   bytes; no well-chosen value of a caller-owned cell is a premise. -/
private theorem fold_frame (step : Machine → Nat → Option Machine)
    (hstep : ∀ (acc out : Machine) (i : Nat), step acc i = some out → out.heap=acc.heap)
    (xs : List Nat) (acc out : Machine) (h : xs.foldlM step acc=some out) :
    out.heap=acc.heap := by
  induction xs generalizing acc with
  | nil =>
      exact congrArg Machine.heap (Option.some.inj (by simpa [List.foldlM] using h)).symm
  | cons i rest ih =>
      simp only [List.foldlM_cons] at h
      cases hs : step acc i with
      | none => simp [hs] at h
      | some mid =>
          have ht : rest.foldlM step mid=some out := by simpa [hs] using h
          exact (ih mid ht).trans (hstep acc mid i hs)

theorem run_frame (fuel : Nat) (result : Ty) (body : List Instr)
    (before final : Machine) (value : Option Val)
    (h : run fuel result body before = some (final,value)) :
    final.heap = before.heap := by
  induction fuel generalizing body before final value with
  | zero => simp [run] at h
  | succ fuel ih =>
      cases body with
      | nil =>
          have heq : (before,none)=(final,value) := by simpa [run] using h
          exact congrArg (fun p : Machine × Option Val => p.1.heap) heq.symm
      | cons instruction rest =>
          cases instruction with
          | scalar stmt =>
              cases stmt with
              | ret e =>
                  cases he : FT1536.Source3.CLogic.eval headerCalls before.locals.values 32 e with
                  | none => simp [run,he] at h
                  | some v =>
                      have heq : (before,some (B20.C.cast result v))=(final,value) := by
                        simpa [run,he] using h
                      exact congrArg (fun p => p.1.heap) heq.symm
              | declare ty ns =>
                  cases hs : FT1536.Source3.CLogic.step headerCalls before.locals (.declare ty ns) with
                  | none => simp [run,hs] at h
                  | some locals =>
                      have ht : run fuel result rest {before with locals := locals}=some (final,value) := by
                        simpa [run,hs] using h
                      exact ih rest {before with locals := locals} final value ht
              | assign name expr =>
                  cases hs : FT1536.Source3.CLogic.step headerCalls before.locals (.assign name expr) with
                  | none => simp [run,hs] at h
                  | some locals =>
                      have ht : run fuel result rest {before with locals := locals}=some (final,value) := by
                        simpa [run,hs] using h
                      exact ih rest {before with locals := locals} final value ht
              | update name op expr =>
                  cases hs : FT1536.Source3.CLogic.step headerCalls before.locals (.update name op expr) with
                  | none => simp [run,hs] at h
                  | some locals =>
                      have ht : run fuel result rest {before with locals := locals}=some (final,value) := by
                        simpa [run,hs] using h
                      exact ih rest {before with locals := locals} final value ht
          | norm mant exp =>
              cases hn : normStatements mant exp with
              | none => simp [run,hn] at h
              | some stmts =>
                  cases hl : execScalars stmts before.locals with
                  | none => simp [run,hn,hl] at h
                  | some locals =>
                      have ht : run fuel result rest
                        {before with locals := leaveBlock before.locals locals (scalarDecls stmts)} =
                          some (final,value) := by simpa [run,hn,hl] using h
                      exact ih rest
                        {before with locals := leaveBlock before.locals locals (scalarDecls stmts)}
                        final value ht
          | forInc index n inner =>
              let step : Machine → Nat → Option Machine := fun acc _ => do
                if !(← guard index n acc.locals) then none else do
                  let (next, v) ← run fuel result inner acc
                  if v.isSome then none else do
                    let updated ← inc index (leaveBlock acc.locals next.locals (blockDecls inner))
                    pure {next with locals := updated}
              change (B20.C.Scalar.assign before.locals index (.i32 (0#32))).bind
                (fun first => (List.foldlM step {before with locals := first} (List.range n)).bind
                  (fun after => (guard index n after.locals).bind
                    (fun g => if g then none else run fuel result rest after))) =
                  some (final,value) at h
              cases hi : B20.C.Scalar.assign before.locals index (.i32 (0#32)) with
              | none => simp [hi] at h
              | some initial =>
                  let start : Machine := {before with locals := initial}
                  simp only [hi, Option.bind_some] at h
                  have hstep (acc out : Machine) (i : Nat)
                      (hs : step acc i = some out) : out.heap = acc.heap := by
                    cases hg : guard index n acc.locals with
                    | none => simp [step,hg] at hs
                    | some g =>
                        cases g with
                        | false => simp [step,hg] at hs
                        | true =>
                            cases hr : run fuel result inner acc with
                            | none => simp [step,hg,hr] at hs
                            | some pair =>
                                rcases pair with ⟨next,v⟩
                                cases v with
                                | some v => simp [step,hg,hr] at hs
                                | none =>
                                    cases hc : inc index
                                        (leaveBlock acc.locals next.locals (blockDecls inner)) with
                                    | none => simp [step,hg,hr,hc] at hs
                                    | some updated =>
                                        have heq : out={next with locals := updated} := by
                                          exact (Option.some.inj (by simpa [step,hg,hr,hc] using hs)).symm
                                        rw [heq]
                                        exact ih inner acc next none hr
                  cases hf : (List.range n).foldlM step start with
                  | none =>
                      have hnone : List.foldlM step
                          {before with locals := initial} (List.range n) = none := by
                        simpa only [start] using hf
                      simp [hnone] at h
                  | some after =>
                      have hfold := fold_frame step hstep (List.range n) start after hf
                      have hsome : List.foldlM step
                          {before with locals := initial} (List.range n) = some after := by
                        simpa only [start] using hf
                      simp only [hsome,Option.bind_some] at h
                      cases hg : guard index n after.locals with
                      | none => simp [hg] at h
                      | some g =>
                          cases g with
                          | true => simp [hg] at h
                          | false =>
                              have ht : run fuel result rest after=some (final,value) := by
                                simpa [hg] using h
                              exact (ih rest after final value ht).trans
                                (hfold.trans (by rfl))

theorem source_call_frame (p : Option FprPrimitives.Function) (x y z : BitVec 64)
    (before after : B20.C.Byte.Memory)
    (h : sourceCall p x y before=some (z,after)) : after=before := by
  unfold sourceCall at h
  obtain ⟨f,_,h1⟩ := Option.bind_eq_some_iff.mp h
  obtain ⟨locals,_,h2⟩ := Option.bind_eq_some_iff.mp h1
  obtain ⟨pair,hr,h3⟩ := Option.bind_eq_some_iff.mp h2
  rcases pair with ⟨final,v⟩
  have hf := run_frame 256 f.result f.body ⟨locals,before⟩ final v hr
  obtain ⟨word,_,h4⟩ := Option.bind_eq_some_iff.mp h3
  cases word with
  | u64 w =>
      have heq : (w,final.heap)=(z,after) := by simpa using h4
      exact (congrArg Prod.snd heq).symm.trans hf
  | u32 _ => simp at h4
  | i32 _ => simp at h4
  | i64 _ => simp at h4

theorem add_byte_frame (x y z : BitVec 64) (before after : B20.C.Byte.Memory)
    (h : sourceCall addProgram x y before=some (z,after)) : after=before :=
  source_call_frame addProgram x y z before after h
theorem mul_byte_frame (x y z : BitVec 64) (before after : B20.C.Byte.Memory)
    (h : sourceCall mulProgram x y before=some (z,after)) : after=before :=
  source_call_frame mulProgram x y z before after h
theorem div_byte_frame (x y z : BitVec 64) (before after : B20.C.Byte.Memory)
    (h : sourceCall divProgram x y before=some (z,after)) : after=before :=
  source_call_frame divProgram x y z before after h

end FT1536.Source3.FprCFrame

#check @FT1536.Source3.FprCFrame.add_byte_frame
#check @FT1536.Source3.FprCFrame.mul_byte_frame
#check @FT1536.Source3.FprCFrame.div_byte_frame
#print axioms FT1536.Source3.FprCFrame.add_byte_frame
#print axioms FT1536.Source3.FprCFrame.mul_byte_frame
#print axioms FT1536.Source3.FprCFrame.div_byte_frame
