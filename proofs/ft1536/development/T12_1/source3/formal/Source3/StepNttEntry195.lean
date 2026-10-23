import Source3.MakeFgAddPrimeShape194
import Source3.StepCopyBody190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The NTT3 call-shape binding of the make_fg_step additional-prime
   marches: the pinned seven-argument list MakeFgAddPrimeShape194.
   forwardArgs (the expanded stride-1 wrapper call modp_NTT3(t1, gm,
   logn, 0, p, p0i) = modp_NTT3_ext(t1, 1, gm, logn, 0, p, p0i)) bound to
   the callee parameter spine KeygenLevelCalls.params .forward at a
   caller state with the t1/gm bindings and the u32 section cells
   logn/p/p0i. The exported entry frame is the fresh callee frame with
   a := t1, stride := 1, gm := gm, logn := logn word, full := 0,
   p := pw, p0i := p0w (binding order a, stride, gm, logn, full, p, p0i),
   exactly the frame the future modp_NTT3_ext engine runs from
   (KeygenNttForwardPrograms.forwardBody; NO execution engine exists
   yet). Shapes stay decide-bound to the pinned parse record. Values stay
   executed words: no transform property, table law, root law or
   positivity claim is made here. -/
namespace FT1536.Source3.StepNttEntry195
open C99ArrayReference (State Name Pointer Param bindValue bindPointer)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value Ty)
open KeygenLevelCalls (Arg)

/- The pinned parameter spine at the forward kind (the gm pointer name is
   selected by the kind). -/
theorem params_forward : KeygenLevelCalls.params .forward =
    [Param.pointer "a".toList,Param.scalar .uint64 "stride".toList,
      Param.pointer "gm".toList,Param.scalar .uint32 "logn".toList,
      Param.scalar .uint32 "full".toList,Param.scalar .uint32 "p".toList,
      Param.scalar .uint32 "p0i".toList] := rfl

theorem args_shape : MakeFgAddPrimeShape194.forwardArgs =
    [Arg.pointer "t1".toList MakeFgAddPrimeShape194.at0,
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.num 1))),
      Arg.pointer "gm".toList MakeFgAddPrimeShape194.at0,
      Arg.scalar (.modular (.scalar MakeFgAddPrimeShape194.varLogn)),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.num 0))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p"))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))] := rfl

/- The fresh callee frame and the seven-bound entry (tail-first, the head
   parameter binds outermost). -/
def nttFresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩

def entryP0i (s : State) (p0w : BitVec 32) : State :=
  bindValue (nttFresh s) "p0i".toList .uint32 (.uint32 p0w)
def entryP (s : State) (pw p0w : BitVec 32) : State :=
  bindValue (entryP0i s p0w) "p".toList .uint32 (.uint32 pw)
def entryFull (s : State) (pw p0w : BitVec 32) : State :=
  bindValue (entryP s pw p0w) "full".toList .uint32 (.int32 0)
def entryLogn (s : State) (lognw pw p0w : BitVec 32) : State :=
  bindValue (entryFull s pw p0w) "logn".toList .uint32 (.uint32 lognw)
def entryGm (s : State) (gm : ArrayPointer) (lognw pw p0w : BitVec 32) : State :=
  bindPointer (entryLogn s lognw pw p0w) "gm".toList gm
def entryStride (s : State) (gm : ArrayPointer) (lognw pw p0w : BitVec 32) : State :=
  bindValue (entryGm s gm lognw pw p0w) "stride".toList .uint64 (.int32 1)
def entryA (s : State) (t1 gm : ArrayPointer) (lognw pw p0w : BitVec 32) : State :=
  bindPointer (entryStride s gm lognw pw p0w) "a".toList t1
def entry (s : State) (t1 gm : ArrayPointer) (lognw pw p0w : BitVec 32) : State :=
  entryA s t1 gm lognw pw p0w

/- Argument evaluations at the caller state. -/
theorem eval_one (s : State) :
    KeygenLevelCalls.Eval s (.modular (.scalar (MakeFgAddPrimeShape194.num 1))) (.int32 1) :=
  .modular _ _ (.scalar _ _ (.literal .int32 1))

theorem eval_zero (s : State) :
    KeygenLevelCalls.Eval s (.modular (.scalar (MakeFgAddPrimeShape194.num 0))) (.int32 0) :=
  .modular _ _ (.scalar _ _ (.literal .int32 0))

theorem eval_logn (s : State) (lognw : BitVec 32)
    (cell : s.locals "logn".toList=some (.uint32,some (.uint32 lognw))) :
    KeygenLevelCalls.Eval s (.modular (.scalar MakeFgAddPrimeShape194.varLogn)) (.uint32 lognw) :=
  .modular _ _ (.scalar _ _ (.variable "logn".toList .uint32 (.uint32 lognw) cell))

theorem eval_p (s : State) (pw : BitVec 32)
    (cell : s.locals "p".toList=some (.uint32,some (.uint32 pw))) :
    KeygenLevelCalls.Eval s (.modular (.scalar (MakeFgAddPrimeShape194.var "p"))) (.uint32 pw) :=
  .modular _ _ (.scalar _ _ (.variable "p".toList .uint32 (.uint32 pw) cell))

theorem eval_p0i (s : State) (p0w : BitVec 32)
    (cell : s.locals "p0i".toList=some (.uint32,some (.uint32 p0w))) :
    KeygenLevelCalls.Eval s (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i"))) (.uint32 p0w) :=
  .modular _ _ (.scalar _ _ (.variable "p0i".toList .uint32 (.uint32 p0w) cell))

/- The call-shape binding of the pinned forwardArgs list. -/
theorem bind_forward (before : State) (t1 gm : ArrayPointer) (lognw pw p0w : BitVec 32)
    (t1Binding : before.arrays "t1".toList=some t1) (t1Capacity : t1.index≤t1.count)
    (gmBinding : before.arrays "gm".toList=some gm) (gmCapacity : gm.index≤gm.count)
    (lognCell : before.locals "logn".toList=some (.uint32,some (.uint32 lognw)))
    (pCell : before.locals "p".toList=some (.uint32,some (.uint32 pw)))
    (p0iCell : before.locals "p0i".toList=some (.uint32,some (.uint32 p0w))) :
    KeygenLevelCalls.Bind before (KeygenLevelCalls.params .forward)
      MakeFgAddPrimeShape194.forwardArgs (entry before t1 gm lognw pw p0w) := by
  rw [params_forward,args_shape]
  have t1Pointer : Pointer before "t1".toList MakeFgAddPrimeShape194.at0 t1 :=
    StepCopyBody190.zero_pointer before "t1".toList t1 t1Binding t1Capacity
  have gmPointer : Pointer before "gm".toList MakeFgAddPrimeShape194.at0 gm :=
    StepCopyBody190.zero_pointer before "gm".toList gm gmBinding gmCapacity
  refine KeygenLevelCalls.Bind.pointer "a".toList "t1".toList MakeFgAddPrimeShape194.at0 t1
    [Param.scalar .uint64 "stride".toList,Param.pointer "gm".toList,
      Param.scalar .uint32 "logn".toList,Param.scalar .uint32 "full".toList,
      Param.scalar .uint32 "p".toList,Param.scalar .uint32 "p0i".toList]
    [Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.num 1))),
      Arg.pointer "gm".toList MakeFgAddPrimeShape194.at0,
      Arg.scalar (.modular (.scalar MakeFgAddPrimeShape194.varLogn)),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.num 0))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p"))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))]
    _ t1Pointer ?_
  refine KeygenLevelCalls.Bind.scalar .uint64 "stride".toList
    (.modular (.scalar (MakeFgAddPrimeShape194.num 1)))
    [Param.pointer "gm".toList,Param.scalar .uint32 "logn".toList,
      Param.scalar .uint32 "full".toList,Param.scalar .uint32 "p".toList,
      Param.scalar .uint32 "p0i".toList]
    [Arg.pointer "gm".toList MakeFgAddPrimeShape194.at0,
      Arg.scalar (.modular (.scalar MakeFgAddPrimeShape194.varLogn)),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.num 0))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p"))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))]
    _ (.int32 1) (eval_one before) ?_
  refine KeygenLevelCalls.Bind.pointer "gm".toList "gm".toList MakeFgAddPrimeShape194.at0 gm
    [Param.scalar .uint32 "logn".toList,Param.scalar .uint32 "full".toList,
      Param.scalar .uint32 "p".toList,Param.scalar .uint32 "p0i".toList]
    [Arg.scalar (.modular (.scalar MakeFgAddPrimeShape194.varLogn)),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.num 0))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p"))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))]
    _ gmPointer ?_
  refine KeygenLevelCalls.Bind.scalar .uint32 "logn".toList
    (.modular (.scalar MakeFgAddPrimeShape194.varLogn))
    [Param.scalar .uint32 "full".toList,Param.scalar .uint32 "p".toList,
      Param.scalar .uint32 "p0i".toList]
    [Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.num 0))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p"))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))]
    _ (.uint32 lognw) (eval_logn before lognw lognCell) ?_
  refine KeygenLevelCalls.Bind.scalar .uint32 "full".toList
    (.modular (.scalar (MakeFgAddPrimeShape194.num 0)))
    [Param.scalar .uint32 "p".toList,Param.scalar .uint32 "p0i".toList]
    [Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p"))),
      Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))]
    _ (.int32 0) (eval_zero before) ?_
  refine KeygenLevelCalls.Bind.scalar .uint32 "p".toList
    (.modular (.scalar (MakeFgAddPrimeShape194.var "p")))
    [Param.scalar .uint32 "p0i".toList]
    [Arg.scalar (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))]
    _ (.uint32 pw) (eval_p before pw pCell) ?_
  refine KeygenLevelCalls.Bind.scalar .uint32 "p0i".toList
    (.modular (.scalar (MakeFgAddPrimeShape194.var "p0i")))
    [] [] _ (.uint32 p0w) (eval_p0i before p0w p0iCell) ?_
  exact KeygenLevelCalls.Bind.nil

end FT1536.Source3.StepNttEntry195
