import Source3.PublicForwardEntry159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Constructive mq_NTT_ternary body execution on explicit intermediate
   states (declarations, both automatic arrays, dynamic generator branch,
   aliases). The mq_mkgm3 body execution and the complete tail execution
   are explicit premises; no generated table image enters this layer. -/
namespace FT1536.Source3.PublicForwardBody159
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot)
open PublicForwardEntry159 (clean entryT zero_address logn_slot outer_arrays outer_heap)
open KeygenPublicForwardProgram (dimensionNames generateArgs tail)

def afterDims (s : State) : State :=
  {s with locals := C99DeclarationCells.declareCells .uint64 dimensionNames s.locals}
def afterResidues (s : State) : State :=
  {s with locals := C99DeclarationCells.declareCells .uint32 ["r".toList,"w".toList] (afterDims s).locals}

def gmPointer (gBlock : Nat) : ArrayPointer := KeygenPublicExec.localPointer gBlock 2048
def igmPointer (iBlock : Nat) : ArrayPointer := KeygenPublicExec.localPointer iBlock 2048

def gmEntry (s : State) (gBlock : Nat) : State := KeygenPublicExec.localEntry (afterResidues s) "gm".toList gBlock 2048
def igmEntry (s : State) (gBlock iBlock : Nat) : State :=
  KeygenPublicExec.localEntry (gmEntry s gBlock) "igm".toList iBlock 2048

def squareCleared (s : State) : State :=
  {s with arrays := fun n => if n="gm_square".toList then none else s.arrays n}
def cubicCleared (s : State) : State :=
  {s with arrays := fun n => if n="gm_cubic".toList then none else s.arrays n}
def pointersReady (s : State) (gBlock iBlock : Nat) : State := cubicCleared (squareCleared (igmEntry s gBlock iBlock))

def nBound (s : State) : State := C99ArrayReference.bindValue s "n".toList .uint64 (.uint64 1536)
def hnBound (s : State) : State := C99ArrayReference.bindValue s "hn".toList .uint64 (.uint64 768)
def dimsReady (s : State) (gBlock iBlock : Nat) : State := hnBound (nBound (pointersReady s gBlock iBlock))

def generateEntry (s : State) (gBlock iBlock : Nat) : State :=
  C99ArrayReference.bindPointer
    (C99ArrayReference.bindPointer
      (C99ArrayReference.bindValue (clean (dimsReady s gBlock iBlock)) "logn".toList .uint32 (.uint32 10))
      "igm".toList (igmPointer iBlock)) "gm".toList (gmPointer gBlock)

def afterGenerate (s : State) (gBlock iBlock : Nat) (gState : State) : State :=
  {dimsReady s gBlock iBlock with heap := gState.heap}
def squareAlias (s : State) (gBlock iBlock : Nat) (gState : State) : State :=
  C99ArrayReference.bindPointer (afterGenerate s gBlock iBlock gState) "gm_square".toList (gmPointer gBlock)
def aliasesBound (s : State) (gBlock iBlock : Nat) (gState : State) : State :=
  C99ArrayReference.bindPointer (squareAlias s gBlock iBlock gState) "gm_cubic".toList (gmPointer gBlock)

def tailState (s : State) (gBlock iBlock : Nat) (tState : State) : State :=
  KeygenPublicExec.localExit (gmEntry s gBlock) tState "igm".toList iBlock
def bodyState (s : State) (gBlock iBlock : Nat) (tState : State) : State :=
  KeygenPublicExec.localExit (afterResidues s) (tailState s gBlock iBlock tState) "gm".toList gBlock

/- Slot transports over the intermediate states. -/
theorem pointers_logn (s : State) (a : ArrayPointer) (gBlock iBlock : Nat) :
    Slot (pointersReady (entryT s a) gBlock iBlock) "logn" 10 := rfl
theorem nBound_n (s : State) (a : ArrayPointer) (gBlock iBlock : Nat) :
    (nBound (pointersReady (entryT s a) gBlock iBlock)).locals "n".toList=some (.uint64,some (.uint64 1536)) := rfl
theorem dims_logn (s : State) (a : ArrayPointer) (gBlock iBlock : Nat) :
    Slot (dimsReady (entryT s a) gBlock iBlock) "logn" 10 := rfl
theorem gm_binding (s : State) (a : ArrayPointer) (gBlock iBlock : Nat) :
    (dimsReady (entryT s a) gBlock iBlock).arrays "gm".toList=some (gmPointer gBlock) := rfl
theorem igm_binding (s : State) (a : ArrayPointer) (gBlock iBlock : Nat) :
    (dimsReady (entryT s a) gBlock iBlock).arrays "igm".toList=some (igmPointer iBlock) := rfl
theorem gm_alias (s : State) (a : ArrayPointer) (gBlock iBlock : Nat) (gState : State) :
    (afterGenerate (entryT s a) gBlock iBlock gState).arrays "gm".toList=some (gmPointer gBlock) := rfl
theorem gm_alias2 (s : State) (a : ArrayPointer) (gBlock iBlock : Nat) (gState : State) :
    (squareAlias (entryT s a) gBlock iBlock gState).arrays "gm".toList=some (gmPointer gBlock) := rfl

/- Expression evaluations on the M0 path. -/
theorem n_eval (s : State) (logn : Slot s "logn" 10) :
    KeygenPublicWord.Eval [] s (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 3))
      (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 1))) (.uint64 1536) :=
  have lv : KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.var "logn") (.uint32 10) :=
    .scalar _ _ (.variable _ _ _ logn)
  have one : KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.literal 1) (.int32 1) :=
    .scalar _ _ (.literal .int32 1)
  have three : KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.literal 3) (.int32 3) :=
    .scalar _ _ (.literal .int32 3)
  have right : KeygenPublicWord.Eval [] s
      (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 1)) (.uint32 9) :=
    .bin .sub _ _ _ _ _ lv one (.step .minus (.uint32 10) (.int32 1) .uint32 rfl
      (.uint32 10) (.uint32 1) rfl rfl (by intro impossible; cases impossible))
  have left : KeygenPublicWord.Eval [] s (.cast .uint64 (KeygenPublicTableAtoms.literal 3)) (.uint64 3) :=
    .cast .uint64 _ (.int32 3) three
  .bin .shl _ _ _ _ _ left right (.unsignedLeft (.uint64 3) (.uint32 9) 9 rfl rfl (by decide))

theorem hn_eval (s : State) (n : s.locals "n".toList=some (.uint64,some (.uint64 1536))) :
    KeygenPublicWord.Eval [] s (.bin .shr (KeygenPublicTableAtoms.var "n") (KeygenPublicTableAtoms.literal 1))
      (.uint64 768) :=
  have nv : KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.var "n") (.uint64 1536) :=
    .scalar _ _ (.variable _ _ _ n)
  have one : KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.literal 1) (.int32 1) :=
    .scalar _ _ (.literal .int32 1)
  .bin .shr _ _ _ _ _ nv one (.right (.uint64 1536) (.int32 1) 1 rfl (by decide))

theorem guard_eval (s : State) (logn : Slot s "logn" 10) :
    KeygenPublicWord.Eval [] s
      (.cmp .le (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 9)) (.int32 0) :=
  have lv : KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.var "logn") (.uint32 10) :=
    .scalar _ _ (.variable _ _ _ logn)
  have nine : KeygenPublicWord.Eval [] s (KeygenPublicTableAtoms.literal 9) (.int32 9) :=
    .scalar _ _ (.literal .int32 9)
  .cmp .le _ _ _ _ _ lv nine (.step .le (.uint32 10) (.int32 9) .uint32 rfl
    (.uint32 10) (.uint32 9) rfl rfl)

theorem guard_zero : (C99IntegerReference.Value.int32 0).integer=0 := by decide

/- Parameter binding for the dynamic generator call. -/
theorem generate_bind (s : State) (a : ArrayPointer) (gBlock iBlock : Nat)
    (capacityG : (gmPointer gBlock).index≤(gmPointer gBlock).count)
    (capacityI : (igmPointer iBlock).index≤(igmPointer iBlock).count) :
    KeygenPublicWord.Bind (dimsReady (entryT s a) gBlock iBlock) (KeygenPublicSource.params .generate)
      generateArgs (generateEntry (entryT s a) gBlock iBlock) :=
  .pointer "gm".toList "gm".toList C99ProcedureParser.zero (gmPointer gBlock)
    [.pointer "igm".toList,.scalar .uint32 "logn".toList]
    [.pointer "igm".toList C99ProcedureParser.zero,.scalar (.var "logn".toList)]
    (C99ArrayReference.bindPointer
      (C99ArrayReference.bindValue (clean (dimsReady (entryT s a) gBlock iBlock)) "logn".toList .uint32 (.uint32 10))
      "igm".toList (igmPointer iBlock))
    (zero_address (dimsReady (entryT s a) gBlock iBlock) "gm" (gmPointer gBlock)
      (gm_binding s a gBlock iBlock) capacityG)
    (.pointer "igm".toList "igm".toList C99ProcedureParser.zero (igmPointer iBlock)
      [.scalar .uint32 "logn".toList] [.scalar (.var "logn".toList)]
      (C99ArrayReference.bindValue (clean (dimsReady (entryT s a) gBlock iBlock)) "logn".toList .uint32 (.uint32 10))
      (zero_address (dimsReady (entryT s a) gBlock iBlock) "igm" (igmPointer iBlock)
        (igm_binding s a gBlock iBlock) capacityI)
      (.scalar .uint32 "logn".toList (.var "logn".toList) [] []
        (clean (dimsReady (entryT s a) gBlock iBlock)) (.uint32 10)
        (.variable "logn".toList .uint32 (.uint32 10) (dims_logn s a gBlock iBlock)) .nil))

/- The complete mq_NTT_ternary body from its two open callee regions. -/
theorem source (s : State) (a : ArrayPointer) (gBlock iBlock : Nat)
    (capacityG : (gmPointer gBlock).index≤(gmPointer gBlock).count)
    (capacityI : (igmPointer iBlock).index≤(igmPointer iBlock).count)
    (freshG : KeygenRngSource.Fresh (afterResidues (entryT s a)).heap gBlock)
    (freshI : KeygenRngSource.Fresh (gmEntry (entryT s a) gBlock).heap iBlock)
    (gState tState : State)
    (generateExec : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate)
      (generateEntry (entryT s a) gBlock iBlock) ⟨gState,.normal⟩)
    (tailExec : Exec KeygenPublicSource.program [] tail
      (aliasesBound (entryT s a) gBlock iBlock gState) ⟨tState,.normal⟩) :
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT) (entryT s a)
      ⟨bodyState (entryT s a) gBlock iBlock tState,.normal⟩ := by
  rw [KeygenPublicForwardProgram.source_complete]
  have declDims : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.declareDimensions
      (entryT s a) ⟨afterDims (entryT s a),.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint64 dimensionNames
      (entryT s a).locals)
  have declRes : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.declareResidues
      (afterDims (entryT s a)) ⟨afterResidues (entryT s a),.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32
      ["r".toList,"w".toList] (afterDims (entryT s a)).locals)
  have ptrSquare : Exec KeygenPublicSource.program [] (.declarePointer "gm_square".toList)
      (igmEntry (entryT s a) gBlock iBlock) ⟨squareCleared (igmEntry (entryT s a) gBlock iBlock),.normal⟩ :=
    .declarePointer "gm_square".toList (igmEntry (entryT s a) gBlock iBlock)
  have ptrCubic : Exec KeygenPublicSource.program [] (.declarePointer "gm_cubic".toList)
      (squareCleared (igmEntry (entryT s a) gBlock iBlock))
      ⟨cubicCleared (squareCleared (igmEntry (entryT s a) gBlock iBlock)),.normal⟩ :=
    .declarePointer "gm_cubic".toList (squareCleared (igmEntry (entryT s a) gBlock iBlock))
  have pointers : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.declarePointers
      (igmEntry (entryT s a) gBlock iBlock) ⟨pointersReady (entryT s a) gBlock iBlock,.normal⟩ :=
    .seqNormal _ _ _ _ _ ptrSquare (.seqNormal _ _ _ _ _ ptrCubic (.skip _))
  have nExec : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.nSet
      (pointersReady (entryT s a) gBlock iBlock) ⟨nBound (pointersReady (entryT s a) gBlock iBlock),.normal⟩ :=
    .assign "n".toList _ _ .uint64 none (.uint64 1536) rfl (n_eval _ (pointers_logn s a gBlock iBlock))
  have hnExec : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.hnSet
      (nBound (pointersReady (entryT s a) gBlock iBlock))
      ⟨hnBound (nBound (pointersReady (entryT s a) gBlock iBlock)),.normal⟩ :=
    .assign "hn".toList _ _ .uint64 none (.uint64 768) rfl (hn_eval _ (nBound_n s a gBlock iBlock))
  have generateCall : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.generate
      (dimsReady (entryT s a) gBlock iBlock) ⟨afterGenerate (entryT s a) gBlock iBlock gState,.normal⟩ :=
    .call (KeygenPublicSource.name .generate) generateArgs (KeygenPublicSource.function .generate)
      (dimsReady (entryT s a) gBlock iBlock) (generateEntry (entryT s a) gBlock iBlock) ⟨gState,.normal⟩
      KeygenPublicForwardCall.generate_lookup (generate_bind s a gBlock iBlock capacityG capacityI)
      generateExec .voidEnd
  have squareExec : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.squareAlias
      (afterGenerate (entryT s a) gBlock iBlock gState) ⟨squareAlias (entryT s a) gBlock iBlock gState,.normal⟩ :=
    .pointer "gm_square".toList "gm".toList C99ProcedureParser.zero
      (afterGenerate (entryT s a) gBlock iBlock gState) (gmPointer gBlock)
      (zero_address (afterGenerate (entryT s a) gBlock iBlock gState) "gm" (gmPointer gBlock)
        (gm_alias s a gBlock iBlock gState) capacityG)
  have cubicExec : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.cubicAlias
      (squareAlias (entryT s a) gBlock iBlock gState) ⟨aliasesBound (entryT s a) gBlock iBlock gState,.normal⟩ :=
    .pointer "gm_cubic".toList "gm".toList C99ProcedureParser.zero
      (squareAlias (entryT s a) gBlock iBlock gState) (gmPointer gBlock)
      (zero_address (squareAlias (entryT s a) gBlock iBlock gState) "gm" (gmPointer gBlock)
        (gm_alias2 s a gBlock iBlock gState) capacityG)
  have dynamic : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.dynamic
      (dimsReady (entryT s a) gBlock iBlock) ⟨aliasesBound (entryT s a) gBlock iBlock gState,.normal⟩ :=
    .scope _ _ _ _ _
      (.seqNormal _ _ _ _ _ generateCall
        (.seqNormal _ _ _ _ _ squareExec (.seqNormal _ _ _ _ _ cubicExec (.skip _))))
  have dispatch : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.dispatch
      (dimsReady (entryT s a) gBlock iBlock) ⟨aliasesBound (entryT s a) gBlock iBlock gState,.normal⟩ :=
    .branchFalse _ _ _ _ _ (.int32 0) (guard_eval _ (dims_logn s a gBlock iBlock)) guard_zero dynamic
  have ready : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.readyBody
      (igmEntry (entryT s a) gBlock iBlock) ⟨tState,.normal⟩ :=
    .seqNormal _ _ _ _ _ pointers
      (.seqNormal _ _ _ _ _ nExec
        (.seqNormal _ _ _ _ _ hnExec (.seqNormal _ _ _ _ _ dispatch tailExec)))
  have arrays : Exec KeygenPublicSource.program [] KeygenPublicForwardProgram.arraysBody
      (afterResidues (entryT s a)) ⟨bodyState (entryT s a) gBlock iBlock tState,.normal⟩ :=
    .arrayScope "gm".toList 2048 _ (afterResidues (entryT s a)) _ gBlock (by decide) (by decide) freshG
      (.arrayScope "igm".toList 2048 _ (gmEntry (entryT s a) gBlock) _ iBlock (by decide) (by decide) freshI ready)
  exact .seqNormal _ _ _ _ _ declDims (.seqNormal _ _ _ _ _ declRes arrays)

end FT1536.Source3.PublicForwardBody159
