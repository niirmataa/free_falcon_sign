import Source3.FprCFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprCErasure
open FT1536.Source3.FprCFrame FT1536.Source3.FprPrimitives
open B20.C

private def carry (heap : B20.C.Byte.Memory) (o : Option (B20.C.Scalar.State × Option Val)) :
    Option (Machine × Option Val) :=
  o.map (fun p => (⟨p.1,heap⟩,p.2))

private theorem fold_carry (xs : List Nat)
    (f : B20.C.Scalar.State → Nat → Option B20.C.Scalar.State)
    (g : Machine → Nat → Option Machine) (heap : B20.C.Byte.Memory)
    (hg : ∀ (s : B20.C.Scalar.State) (i : Nat),
      g ⟨s,heap⟩ i = (f s i).map (fun next => ⟨next,heap⟩))
    (s : B20.C.Scalar.State) :
    xs.foldlM g ⟨s,heap⟩ = (xs.foldlM f s).map (fun next => ⟨next,heap⟩) := by
  induction xs generalizing s with
  | nil => rfl
  | cons i rest ih =>
      simp only [List.foldlM_cons]
      rw [hg s i]
      cases hf : f s i with
      | none => simp
      | some next => simpa using ih next

/- This is an *erasure proof*, not an assumed equality of two callees:
   both executions step through the parsed C instructions, and the second
   one carries actual caller bytes and local stack values independently. -/
theorem run_erases (fuel : Nat) (result : Ty) (body : List Instr)
    (locals : B20.C.Scalar.State) (heap : B20.C.Byte.Memory) :
    FprCFrame.run fuel result body ⟨locals,heap⟩ =
      carry heap (FprPrimitives.execBlock fuel result body locals) := by
  induction fuel generalizing body locals heap with
  | zero => rfl
  | succ fuel ih =>
      cases body with
      | nil => rfl
      | cons stmt rest =>
          cases stmt with
          | scalar scalar =>
              cases scalar with
              | ret expr =>
                  cases he : FT1536.Source3.CLogic.eval headerCalls locals.values 32 expr with
                  | none => simp [FprCFrame.run,FprPrimitives.execBlock,carry,he]
                  | some v => simp [FprCFrame.run,FprPrimitives.execBlock,carry,he]
              | declare ty names =>
                  cases hs : FT1536.Source3.CLogic.step headerCalls locals (.declare ty names) with
                  | none => simp [FprCFrame.run,FprPrimitives.execBlock,FprPrimitives.execScalar,hs,carry]
                  | some next =>
                      simpa [FprCFrame.run,FprPrimitives.execBlock,FprPrimitives.execScalar,hs,carry]
                        using ih rest next heap
              | assign name expr =>
                  cases hs : FT1536.Source3.CLogic.step headerCalls locals (.assign name expr) with
                  | none => simp [FprCFrame.run,FprPrimitives.execBlock,FprPrimitives.execScalar,hs,carry]
                  | some next =>
                      simpa [FprCFrame.run,FprPrimitives.execBlock,FprPrimitives.execScalar,hs,carry]
                        using ih rest next heap
              | update name op expr =>
                  cases hs : FT1536.Source3.CLogic.step headerCalls locals (.update name op expr) with
                  | none => simp [FprCFrame.run,FprPrimitives.execBlock,FprPrimitives.execScalar,hs,carry]
                  | some next =>
                      simpa [FprCFrame.run,FprPrimitives.execBlock,FprPrimitives.execScalar,hs,carry]
                        using ih rest next heap
          | norm mant exp =>
              cases hs : normStatements mant exp with
              | none => simp [FprCFrame.run,FprPrimitives.execBlock,hs,carry]
              | some stmts =>
                  cases he : execScalars stmts locals with
                  | none => simp [FprCFrame.run,FprPrimitives.execBlock,hs,he,carry]
                  | some next =>
                      simpa [FprCFrame.run,FprPrimitives.execBlock,hs,he,carry]
                        using ih rest (leaveBlock locals next (scalarDecls stmts)) heap
          | forInc index n inner =>
              let f : B20.C.Scalar.State → Nat → Option B20.C.Scalar.State := fun acc _ => do
                if !(← guard index n acc) then none else do
                  let (next,v) ← FprPrimitives.execBlock fuel result inner acc
                  if v.isSome then none else
                    inc index (leaveBlock acc next (blockDecls inner))
              let g : Machine → Nat → Option Machine := fun acc _ => do
                if !(← guard index n acc.locals) then none else do
                  let (next,v) ← FprCFrame.run fuel result inner acc
                  if v.isSome then none else do
                    let updated ← inc index (leaveBlock acc.locals next.locals (blockDecls inner))
                    pure {next with locals := updated}
              have hstep (s : B20.C.Scalar.State) (i : Nat) (h : B20.C.Byte.Memory) :
                  g ⟨s,h⟩ i = (f s i).map (fun next => ⟨next,h⟩) := by
                simp only [g,f]
                cases hg : guard index n s with
                | none => simp
                | some flag =>
                    cases flag with
                    | false => simp
                    | true =>
                        rw [ih inner s h]
                        cases he : FprPrimitives.execBlock fuel result inner s with
                        | none => simp [carry]
                        | some pair =>
                            rcases pair with ⟨next,v⟩
                            cases v with
                            | some _ => simp [carry]
                            | none =>
                                cases hc : inc index (leaveBlock s next (blockDecls inner)) with
                                | none => simp [carry,hc]
                                | some updated => simp [carry,hc]
              have hloop (initial : B20.C.Scalar.State) :
                  ((List.range n).foldlM g ⟨initial,heap⟩).bind
                    (fun after => (guard index n after.locals).bind
                      (fun flag => if flag then none else FprCFrame.run fuel result rest after)) =
                  carry heap (((List.range n).foldlM f initial).bind
                    (fun after => (guard index n after).bind
                      (fun flag => if flag then none else
                        FprPrimitives.execBlock fuel result rest after))) := by
                rw [fold_carry (List.range n) f g heap (fun s i => hstep s i heap) initial]
                cases hf : (List.range n).foldlM f initial with
                | none => rfl
                | some after =>
                    cases hg : guard index n after with
                    | none => simp [hg,carry]
                    | some flag =>
                        cases flag with
                        | true => simp [hg,carry]
                        | false => simpa [hg,carry] using ih rest after heap
              cases hi : B20.C.Scalar.assign locals index (.i32 (0#32)) with
              | none => simp [FprCFrame.run,FprPrimitives.execBlock,hi,carry]
              | some initial =>
                  simpa [FprCFrame.run,FprPrimitives.execBlock,hi,carry,f,g]
                    using hloop initial

theorem source_call_model (p : Option FprPrimitives.Function)
    (x y : BitVec 64) (heap : B20.C.Byte.Memory) :
    FprCFrame.sourceCall p x y heap =
      (FprPrimitives.call p x y).map (fun z => (z,heap)) := by
  simp [FprCFrame.sourceCall,FprPrimitives.call,FprPrimitives.execute,
    run_erases,carry]
  cases hp : p with
  | none => rfl
  | some f =>
      cases ha : B20.C.Scalar.bindArgs f.params [.u64 x,.u64 y] with
      | none => simp [ha]
      | some locals =>
          cases hr : FprPrimitives.execBlock 256 f.result f.body locals with
          | none => simp [ha,hr]
          | some pair =>
              rcases pair with ⟨s,v⟩
              cases v with
              | none => simp [ha,hr]
              | some word => cases word <;> simp [ha,hr]

theorem defined_source_call_iff (p : Option FprPrimitives.Function)
    (x y z : BitVec 64) (before after : B20.C.Byte.Memory) :
    FprCFrame.sourceCall p x y before = some (z,after) ↔
      FprPrimitives.call p x y = some z ∧ after=before := by
  rw [source_call_model]
  cases hc : FprPrimitives.call p x y with
  | none => simp
  | some w => simp [Prod.mk.injEq,eq_comm]

end FT1536.Source3.FprCErasure

#check @FT1536.Source3.FprCErasure.source_call_model
#print axioms FT1536.Source3.FprCErasure.run_erases
#print axioms FT1536.Source3.FprCErasure.source_call_model
#print axioms FT1536.Source3.FprCErasure.defined_source_call_iff
