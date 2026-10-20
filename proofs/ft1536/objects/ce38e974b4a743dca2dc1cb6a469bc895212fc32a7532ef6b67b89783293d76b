import Source3.CertificateTop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateExec
open CertificateMemory CertificateEffects

/- A statement-suffix result at the return edge of the enclosing frame.
   The pre-existing addressable bad object remains observable in this
   snapshot; enclosing-function frame teardown is not part of this suffix. -/
structure Result where
  state : State
  returned : Bool
def initialCalls : B20.C.Scalar.Calls := fun name args =>
  if name="fpr_of".toList then CLogic.execute FprOfThree.modelCalls FprScaledAST.ofCode args else none
def macroValues : B20.C.Env := fun name =>
  if name="FT1536_KEYGEN_Q_SQUARED".toList then some (.i64 CertificateQSquared.argument) else none

theorem initializer_model : CLogic.eval initialCalls macroValues 32 CertificateSuffixSyntax.expected.initializer=
    some (.u64 CertificateQSquared.word) := by
  change CLogic.execute FprOfThree.modelCalls FprScaledAST.ofCode [.i64 CertificateQSquared.argument]=_
  exact CertificateQSquared.of_model

def run (l : Layout) (before : B20.C.Byte.Memory) : Option Result := do
  let code ← CertificateSuffixSyntax.source
  if code != CertificateSuffixSyntax.expected then none else do
  let topState ← CertificateTop.run l ⟨before,[]⟩
  let q ← CLogic.eval initialCalls macroValues 32 code.initializer
  match q with
  | .u64 word => do
      let reverseState ← CertificateReverse.loop l word 768 topState
      let scanState ← CertificateScan.run l 1537 0 reverseState
      let returned ← CertificateReturn.run l scanState
      pure ⟨scanState,returned⟩
  | _ => none

def BoundPointers (l : Layout) : Prop :=
  leaves l=(t3Ptr l).offset ∧ ∃ p, C99MemoryReference.PointerAdd (t3Ptr l) 1536 p ∧ p.offset=scratch l
theorem bound_pointers (l : Layout) : BoundPointers l := by
  obtain ⟨h,p,hp,hs,_⟩:=alias_and_pointer_add l
  exact ⟨h,p,hp,by simpa [scratchPtr,C99MemoryReference.ArrayPointer.offset] using hs⟩

/- Syntactic form certifies the two pointer assignments, call graph,
   scoped variable names, loop expressions and return instruction. The
   execution premises are independent source judgments, not run=some. -/
inductive Exec (l : Layout) (code : CertificateSuffixSyntax.Code) (before : RState) : RState → Bool → Prop where
  | sequence (topState reverseState out : RState) (q : BitVec 64) (ret : Bool)
      (form : code=CertificateSuffixSyntax.expected) (pointers : BoundPointers l)
      (top : CertificateTop.Exec l before topState)
      (constant : CertificateQSquared.SourceExec (.uint64 q))
      (reverse : CertificateReverse.Finished l q topState reverseState)
      (scan : CertificateScan.Exec l 0 reverseState out)
      (returned : CertificateReturn.Exec l out ret) : Exec l code before out ret
def PinnedExec (l : Layout) (before after : C99MemoryReference.Memory) (trace : List Event) (ret : Bool) : Prop :=
  ∃ code, CertificateSuffixSyntax.source=some code ∧ Exec l code ⟨before,[]⟩ ⟨after,trace⟩ ret

theorem run_expansion (l : Layout) (h : B20.C.Byte.Memory) : run l h=
    (CertificateTop.run l ⟨h,[]⟩).bind (fun topState =>
      (CertificateReverse.loop l CertificateQSquared.word 768 topState).bind (fun reverseState =>
        (CertificateScan.run l 1537 0 reverseState).bind (fun out =>
          (CertificateReturn.run l out).map (fun ret => ⟨out,ret⟩)))) := by
  unfold run
  rw [CertificateSuffixSyntax.pinned_source]
  change (CertificateTop.run l ⟨h,[]⟩).bind (fun topState =>
    (CLogic.eval initialCalls macroValues 32 CertificateSuffixSyntax.expected.initializer).bind
      (fun q => match q with
      | .u64 w => (CertificateReverse.loop l w 768 topState).bind (fun reverseState =>
          (CertificateScan.run l 1537 0 reverseState).bind (fun out =>
            (CertificateReturn.run l out).bind (fun ret => some (Result.mk out ret))))
      | _ => none))=_
  rw [initializer_model]
  apply congrArg ((CertificateTop.run l ⟨h,[]⟩).bind)
  funext topState
  dsimp only [Option.bind]
  apply congrArg ((CertificateReverse.loop l CertificateQSquared.word 768 topState).bind)
  funext reverseState
  apply congrArg ((CertificateScan.run l 1537 0 reverseState).bind)
  funext out
  cases CertificateReturn.run l out <;> rfl

end FT1536.Source3.CertificateExec
