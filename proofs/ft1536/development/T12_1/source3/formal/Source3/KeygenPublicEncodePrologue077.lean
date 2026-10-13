import Source3.KeygenPublicEncodeLoop077
import Source3.KeygenDecodeNoneEntryCalculations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodePrologue077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

def nRhs : Expr := .binary .shl (.cast .size (.number .i32 3))
  (.binary .sub (.variable "logn".toList) (.number .i32 1))

def pieces : List Stmt := [KeygenPublicEncodeBinding077.node000,KeygenPublicEncodeBinding077.node001,
  KeygenPublicEncodeBinding077.node002,KeygenPublicEncodeBinding077.node003,KeygenPublicEncodeBinding077.node004,
  KeygenPublicEncodeBinding077.node005,KeygenPublicEncodeBinding077.node006,KeygenPublicEncodeBinding077.node007,
  KeygenPublicEncodeBinding077.node008]
def code : Stmt := KeygenPublicEncodeSequence077.chain pieces .skip
theorem partition : KeygenPublicEncodeBinding077.node070=
    KeygenPublicEncodeSequence077.chain pieces KeygenPublicEncodeBinding077.node061 := rfl
def freshNU (s : State) : State := withLocals s
  (localSet (localSet s.locals "n".toList .uint64 none) "u".toList .uint64 none)
def freshAcc (s : State) : State := withLocals s (localSet s.locals "acc".toList .uint32 none)
def freshPending (s : State) : State := withLocals s (localSet s.locals "acc_len".toList .int32 none)
def initialized (args : Args) (before : Memory) : State :=
  setPending (set32 (set64 {set64 (freshPending (freshAcc (freshNU (initial args before)))) "n" 1536 with buf := some args.out}
    "u" 0) "acc" 0) 0

theorem n_calculation (s : State) (logn : Cell "logn" .uint32 (.uint32 10) s.locals) :
    KeygenPublicEncodePure077.Computes s.locals nRhs (.uint64 1536) :=
  .binary _ _ _ _ _ _
    (.cast _ _ (.int32 3) _ (.number _ _ _ (by decide +kernel)) (by decide +kernel))
    (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) logn)
      (.number _ _ _ (by decide +kernel)) (.sub _ _ _ KeygenDecodeNoneEntryCalculations.logn_subtraction))
    (.shl _ _ _ KeygenDecodeNoneEntryCalculations.n_shift)

theorem zero (args : Args) (s : State) (name : String) (ty : C99IntegerReference.Ty) (v : C99IntegerReference.Value)
    (notBuf : name.toList≠"buf".toList) (notOut : name.toList≠"out".toList)
    (cell : s.locals.scalars name.toList=some (ty,none))
    (cast : C99IntegerReference.convert ty (C99IntegerReference.Value.int32 0).integer=v) :
    Checked args (.write (.variable name.toList) .set (.number .i32 0)) s
      (withLocals s (localSet s.locals name.toList ty (some v))) .normal := by
  have source := assign args s name.toList ty none (.number .i32 0) (.int32 0) s.locals notBuf notOut cell
    (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
  rw [cast] at source
  exact source

theorem prologue (args : Args) (before : Memory) (out ptr : ArrayPointer)
    (lognM0 : args.logn=10) (output : args.out=some out) (input : args.x=some ptr) :
    Checked args code (initial args before) (initialized args before) .normal ∧
      Ready args out ptr 1536 0 0 0 (initialized args before) ∧ (initialized args before).heap=before := by
  let s0 := initial args before
  let s1 := freshNU s0
  let s2 := freshAcc s1
  let s3 := freshPending s2
  let s4 := set64 s3 "n" 1536
  let s5 := {s4 with buf := some args.out}
  let s6 := set64 s5 "u" 0
  let s7 := set32 s6 "acc" 0
  let s8 := initialized args before
  have d0 : Checked args KeygenPublicEncodeBinding077.node000 s0 s0 .normal :=
    KeygenPublicEncodeCertified077.declare args s0 [⟨"buf".toList,.pointer .byte,none⟩] s0.locals rfl
  have d1 : Checked args KeygenPublicEncodeBinding077.node001 s0 s1 .normal :=
    KeygenPublicEncodeCertified077.declare args s0 [⟨"n".toList,.size,none⟩,⟨"u".toList,.size,none⟩] s1.locals rfl
  have d2 : Checked args KeygenPublicEncodeBinding077.node002 s1 s2 .normal :=
    KeygenPublicEncodeCertified077.declare args s1 [⟨"acc".toList,.u32,none⟩] s2.locals rfl
  have d3 : Checked args KeygenPublicEncodeBinding077.node003 s2 s3 .normal :=
    KeygenPublicEncodeCertified077.declare args s2 [⟨"acc_len".toList,.i32,none⟩] s3.locals rfl
  have logn : Cell "logn" .uint32 (.uint32 10) s3.locals := by
    change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.Value.uint32 args.logn))=
      some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.Value.uint32 10))
    rw [lognM0]
  have setN : Checked args KeygenPublicEncodeBinding077.node004 s3 s4 .normal := by
    have source := assign args s3 "n".toList .uint64 none nRhs (.uint64 1536) s3.locals
      (by decide +kernel) (by decide +kernel) rfl (.pure _ _ _ (n_calculation s3 logn))
    simpa only [KeygenDecodeStaticOuterCounter.self64,KeygenPublicEncodeBinding077.node004,
      nRhs,set64,s4] using source
  have bound : Checked args KeygenPublicEncodeBinding077.node005 s4 s5 .normal := bind args s4
  have u0 : Checked args KeygenPublicEncodeBinding077.node006 s5 s6 .normal :=
    zero args s5 "u" .uint64 (.uint64 0) (by decide +kernel) (by decide +kernel) rfl (by decide +kernel)
  have acc0 : Checked args KeygenPublicEncodeBinding077.node007 s6 s7 .normal :=
    zero args s6 "acc" .uint32 (.uint32 0) (by decide +kernel) (by decide +kernel) rfl (by decide +kernel)
  have p0 : Checked args KeygenPublicEncodeBinding077.node008 s7 s8 .normal :=
    zero args s7 "acc_len" .int32 (.int32 0) (by decide +kernel) (by decide +kernel) rfl (by decide +kernel)
  have full : Checked args code s0 s8 .normal := seq args _ _ s0 s0 s8 .normal d0
    (seq args _ _ s0 s1 s8 .normal d1 (seq args _ _ s1 s2 s8 .normal d2
      (seq args _ _ s2 s3 s8 .normal d3 (seq args _ _ s3 s4 s8 .normal setN
        (seq args _ _ s4 s5 s8 .normal bound (seq args _ _ s5 s6 s8 .normal u0
          (seq args _ _ s6 s7 s8 .normal acc0 (seq args _ _ s7 s8 s8 .normal p0 (skip args s8)))))))))
  refine ⟨full,⟨⟨output,?_,rfl,rfl,rfl⟩,?_,rfl,rfl,rfl,rfl⟩,rfl⟩
  · change some args.out=some (some out)
    rw [output]
  · exact input

end FT1536.Source3.KeygenPublicEncodePrologue077
