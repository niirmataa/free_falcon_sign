import Source3.KeygenNttForwardExec
import Source3.KeygenNttButterflyCalls
import Source3.ModularWordOps182
import Source3.StepCopyBody190
import Source3.StepProductBody191

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Parse map of the pinned modp_NTT3_ext forward body
   (KeygenNttForwardPrograms.forwardBody, region 3046 91), the per-cell
   keeps of its first pass, and the two per-iteration step runs of that
   pass: the degree-1 butterfly block (KeygenNttButterflyPrograms.firstBody)
   and the u/r1/r2 increment (the first-loop step verbatim). The map reads
   the glued body as one right spine of run steps (the parser's synthetic
   skip terminators are consumed by the glue); each split is a definitional
   spine equation, so later windows chain C99ModularReference.continuation
   along it without re-deriving the parse. The butterfly words are the
   executed leaf words (KeygenModpWord.montgomery, KeygenModpAddSub.result)
   of the loaded words; no transform property, table law, root law or
   positivity claim is made here. -/
namespace FT1536.Source3.StepNttBody195
open C99ModularReference (Stmt Exec Eval)
open C99ArrayReference (State Name Pointer bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32 Store32 Memory byte32)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)

/-! ## Parse map of forwardBody

The glue flattens each part's trailing skip into the next part, so the
whole body is one right spine whose heads are exactly the run steps. The
intermediate part keeps its two-statement head (mInit then the doubling
loop) as one unit, the shape its own composition consumes. -/

def mWalk : Stmt := .loop KeygenNttForwardPrograms.mGuard
  (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.mInner) KeygenNttForwardPrograms.mStep
def mHead : Stmt := .seq KeygenNttForwardPrograms.mInit mWalk
def tailMiddle : Stmt := .seq mHead KeygenNttForwardPrograms.triplePass
def tailT : Stmt := .seq KeygenNttForwardPrograms.tFromHalf tailMiddle
def tailLoop : Stmt := .seq KeygenNttForwardPrograms.firstLoop tailT
def tailW : Stmt := .seq KeygenNttForwardPrograms.wAssign tailLoop
def tailHn : Stmt := .seq KeygenNttForwardPrograms.hnAssign tailW
def tailN : Stmt := .seq KeygenNttForwardPrograms.nAssign tailHn
def tailExit : Stmt := .seq KeygenNttForwardPrograms.earlyExit tailN
def tailPointers : Stmt := .seq KeygenNttForwardPrograms.pointers tailExit
def tailWord : Stmt := .seq KeygenNttForwardPrograms.word tailPointers
def tailLocals : Stmt := .seq KeygenNttForwardPrograms.locals tailWord

theorem body_spine : KeygenNttForwardPrograms.forwardBody = tailLocals := rfl
theorem locals_split : tailLocals = .seq KeygenNttForwardPrograms.locals tailWord := rfl
theorem word_split : tailWord = .seq KeygenNttForwardPrograms.word tailPointers := rfl
theorem pointers_split : tailPointers = .seq KeygenNttForwardPrograms.pointers tailExit := rfl
theorem exit_split : tailExit = .seq KeygenNttForwardPrograms.earlyExit tailN := rfl
theorem n_split : tailN = .seq KeygenNttForwardPrograms.nAssign tailHn := rfl
theorem hn_split : tailHn = .seq KeygenNttForwardPrograms.hnAssign tailW := rfl
theorem w_split : tailW = .seq KeygenNttForwardPrograms.wAssign tailLoop := rfl
theorem loop_split : tailLoop = .seq KeygenNttForwardPrograms.firstLoop tailT := rfl
theorem t_split : tailT = .seq KeygenNttForwardPrograms.tFromHalf tailMiddle := rfl
theorem middle_split : tailMiddle = .seq mHead KeygenNttForwardPrograms.triplePass := rfl
theorem mHead_split : mHead = .seq KeygenNttForwardPrograms.mInit mWalk := rfl

/-! ## First-pass statement shapes -/

def firstGuard : CLogic.Expr :=
  .cmp .lt (KeygenNttForwardPrograms.var "u") (KeygenNttForwardPrograms.var "hn")
def stepU : Stmt := KeygenNttForwardPrograms.step "u"
def advance : Stmt := KeygenNttForwardPrograms.pointerAdvance
def firstWalk : Stmt :=
  .loop firstGuard (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) stepU

theorem first_loop_split :
    KeygenNttForwardPrograms.firstLoop = .seq KeygenNttForwardPrograms.firstInit firstWalk := rfl

theorem init_split : KeygenNttForwardPrograms.firstInit =
    .seq (.assign "u".toList (.scalar (KeygenNttForwardPrograms.num 0)))
      (.seq (.base (.bindPtr "r1".toList "a".toList KeygenNttButterflyPrograms.zero))
        (.base (.bindPtr "r2".toList "a".toList (.bin .mul (KeygenNttForwardPrograms.var "hn")
          (KeygenNttForwardPrograms.var "stride"))))) := rfl

theorem step_split : stepU =
    .seq (.base (.scalar (.update "u".toList .add (KeygenNttForwardPrograms.num 1)))) advance := rfl

theorem advance_split : advance =
    .seq (.base (.bindPtr "r1".toList "r1".toList (KeygenNttForwardPrograms.var "stride")))
      (.base (.bindPtr "r2".toList "r2".toList (KeygenNttForwardPrograms.var "stride"))) := rfl

/-! ## The executed butterfly words -/

def montWord (a1 w pw p0i : BitVec 32) : BitVec 32 := KeygenModpWord.montgomery a1 w pw p0i
def sumWord (a0 a1 pw : BitVec 32) : BitVec 32 := KeygenModpAddSub.result .add a0 a1 pw
def lowWord (a0 a1 w pw p0i : BitVec 32) : BitVec 32 :=
  KeygenModpAddSub.result .add a0 (montWord a1 w pw p0i) pw
def highWord (a0 a1 w pw p0i : BitVec 32) : BitVec 32 :=
  KeygenModpAddSub.result .sub (sumWord a0 a1 pw) (montWord a1 w pw p0i) pw

/- The deterministic words tie back to the per-butterfly call
   observations of KeygenNttButterflyCalls (the pinned algebra at the
   pinned prime word). -/
def first_calls_words (a0 a1 w p0i : BitVec 32) :
    KeygenNttButterflyAlgebra.FirstCalls a0 a1 w p0i
      (lowWord a0 a1 w KeygenNinv31.prime p0i) (highWord a0 a1 w KeygenNinv31.prime p0i) where
  product := montWord a1 w KeygenNinv31.prime p0i
  sum := sumWord a0 a1 KeygenNinv31.prime
  multiply := KeygenModpWord.source_exists a1 w KeygenNinv31.prime p0i
  lowCall := KeygenModpAddSub.source_exists .add a0 (montWord a1 w KeygenNinv31.prime p0i)
    KeygenNinv31.prime
  sumCall := KeygenModpAddSub.source_exists .add a0 a1 KeygenNinv31.prime
  highCall := KeygenModpAddSub.source_exists .sub (sumWord a0 a1 KeygenNinv31.prime)
    (montWord a1 w KeygenNinv31.prime p0i) KeygenNinv31.prime

/-! ## Per-cell keeps

Deterministic reads and stores, the canonical write of a store, the
separated-cell keeps through it, and the memory extensionality used to
identify a store's result with the canonical write (the
NttInverseMiddleRounds192 keep discipline at the heap). -/

theorem load32_unique (h : Memory) (p : ArrayPointer) (x y : BitVec 32)
    (first : Load32 h p x) (second : Load32 h p y) : x = y := by
  cases first with
  | load b1 _ _ bytes1 =>
    cases second with
    | load b2 _ _ bytes2 =>
      have same : b1 = b2 := funext fun i =>
        Option.some.inj ((bytes1 i).symm.trans (bytes2 i))
      subst same
      rfl

theorem memory_ext {a b : Memory} (bytes : a.bytes = b.bytes) (size : a.size = b.size)
    (writable : a.writable = b.writable) : a = b := by
  cases a with
  | mk ab as aw =>
    cases b with
    | mk bb bs bw =>
      have first : ab = bb := bytes
      have second : as = bs := size
      have third : aw = bw := writable
      subst first
      subst second
      subst third
      rfl

theorem store32_unique {h : Memory} {p : ArrayPointer} {w : BitVec 32} {h1 h2 : Memory}
    (first : Store32 h p w h1) (second : Store32 h p w h2) : h1 = h2 := by
  obtain ⟨_alloc1, _width1, _writable1, size1, _wext1, bytes1, keep1⟩ := first
  obtain ⟨_alloc2, _width2, _writable2, size2, _wext2, bytes2, keep2⟩ := second
  have bytes : h1.bytes = h2.bytes := by
    funext block offset
    by_cases window : block = p.block ∧ p.offset ≤ offset ∧ offset < p.offset + 4
    · obtain ⟨sameBlock, low, high⟩ := window
      subst sameBlock
      have e1 : h1.bytes p.block (p.offset + (offset - p.offset)) =
          some (byte32 w ⟨offset - p.offset, by omega⟩) := bytes1 ⟨offset - p.offset, by omega⟩
      have e2 : h2.bytes p.block (p.offset + (offset - p.offset)) =
          some (byte32 w ⟨offset - p.offset, by omega⟩) := bytes2 ⟨offset - p.offset, by omega⟩
      have span : p.offset + (offset - p.offset) = offset := by omega
      rw [span] at e1 e2
      exact e1.trans e2.symm
    · have outside : block ≠ p.block ∨ offset < p.offset ∨ p.offset + 4 ≤ offset := by omega
      exact (keep1 block offset outside).trans (keep2 block offset outside).symm
  have size : h1.size = h2.size := size1.trans size2.symm
  have writable : h1.writable = h2.writable := _wext1.trans _wext2.symm
  exact memory_ext bytes size writable

theorem store32_write (h h' : Memory) (p : ArrayPointer) (w : BitVec 32)
    (store : Store32 h p w h') (allocated : Allocated h p) (width : p.elementBytes = 4)
    (writable : h.writable p.block = true) : h' = Word32Memory176.write h p w :=
  store32_unique store (Word32Memory176.source h p w allocated width writable)

theorem store_keep (h h' : Memory) (p q : ArrayPointer) (w old : BitVec 32)
    (store : Store32 h p w h') (separate : Separate p q) (read : Load32 h q old)
    (allocated : Allocated h p) (width : p.elementBytes = 4) (writable : h.writable p.block = true) :
    Load32 h' q old := by
  rw [store32_write h h' p w store allocated width writable]
  exact Word32Memory176.outside h p q w old separate read

theorem store_here (h h' : Memory) (p : ArrayPointer) (w : BitVec 32)
    (store : Store32 h p w h') (allocated : Allocated h p) (width : p.elementBytes = 4)
    (writable : h.writable p.block = true) : Load32 h' p w := by
  rw [store32_write h h' p w store allocated width writable]
  exact Word32Memory176.here h p w allocated width writable

theorem write_allocated (h : Memory) (p q : ArrayPointer) (w : BitVec 32)
    (allocated : Allocated h q) : Allocated (Word32Memory176.write h p w) q := by
  obtain ⟨eb, aligned, index, extent, small⟩ := allocated
  refine ⟨eb, aligned, index, ?_, ?_⟩
  · show q.base + q.elementBytes * q.count ≤ (Word32Memory176.write h p w).size q.block
    simpa [Word32Memory176.write] using extent
  · show (Word32Memory176.write h p w).size q.block < 2^64
    simpa [Word32Memory176.write] using small

theorem write_writable (h : Memory) (p q : ArrayPointer) (w : BitVec 32)
    (writable : h.writable q.block = true) :
    (Word32Memory176.write h p w).writable q.block = true := by
  simpa [Word32Memory176.write] using writable

/-! ## The butterfly chain states and blocks -/

def bWriteHigh : Stmt := KeygenNttButterflyPrograms.write "r2" KeygenNttButterflyPrograms.zero
  (KeygenNttButterflyPrograms.sub
    (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
      (KeygenNttButterflyPrograms.scalar "a1"))
    (KeygenNttButterflyPrograms.scalar "b"))
def bWriteLow : Stmt := KeygenNttButterflyPrograms.write "r1" KeygenNttButterflyPrograms.zero
  (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
    (KeygenNttButterflyPrograms.scalar "b"))
def bAssignB : Stmt := KeygenNttButterflyPrograms.assign "b"
  (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "a1")
    (KeygenNttButterflyPrograms.scalar "w"))
def bAssignA1 : Stmt := KeygenNttButterflyPrograms.assign "a1"
  (KeygenNttButterflyPrograms.read "r2")
def bAssignA0 : Stmt := KeygenNttButterflyPrograms.assign "a0"
  (KeygenNttButterflyPrograms.read "r1")
def bDeclare : Stmt := KeygenNttButterflyPrograms.declaration ["a0","a1","b"]

def bTail1 : Stmt := .seq bWriteHigh (.base .skip)
def bTail2 : Stmt := .seq bWriteLow bTail1
def bTail3 : Stmt := .seq bAssignB bTail2
def bTail4 : Stmt := .seq bAssignA1 bTail3
def bTail5 : Stmt := .seq bAssignA0 bTail4
def bChain : Stmt := .seq bDeclare bTail5

theorem body_shape : KeygenNttButterflyPrograms.firstBody = bChain := rfl
theorem tail1_split : bTail1 = .seq bWriteHigh (.base .skip) := rfl
theorem tail2_split : bTail2 = .seq bWriteLow bTail1 := rfl
theorem tail3_split : bTail3 = .seq bAssignB bTail2 := rfl
theorem tail4_split : bTail4 = .seq bAssignA1 bTail3 := rfl
theorem tail5_split : bTail5 = .seq bAssignA0 bTail4 := rfl

def firstDecls : List Name := ["a0".toList,"a1".toList,"b".toList]
theorem first_decls : C99ModularParser.declarations KeygenNttButterflyPrograms.firstBody =
    firstDecls := by decide

def declared (s : State) : State := C99DeclarationStatements.effect .u32 firstDecls s
def withA0 (s : State) (a0 : BitVec 32) : State := ModularAtoms178.set (declared s) "a0" a0
def withA1 (s : State) (a0 a1 : BitVec 32) : State := ModularAtoms178.set (withA0 s a0) "a1" a1
def withB (s : State) (a0 a1 b : BitVec 32) : State := ModularAtoms178.set (withA1 s a0 a1) "b" b

def lowHeap (s : State) (p1 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32) : Memory :=
  Word32Memory176.write (withB s a0 a1 (montWord a1 w pw p0i)).heap p1 (lowWord a0 a1 w pw p0i)
def lowState (s : State) (p1 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32) : State :=
  {withB s a0 a1 (montWord a1 w pw p0i) with heap := lowHeap s p1 a0 a1 w pw p0i}
def highHeap (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32) : Memory :=
  Word32Memory176.write (lowHeap s p1 a0 a1 w pw p0i) p2 (highWord a0 a1 w pw p0i)
def highState (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32) : State :=
  {lowState s p1 a0 a1 w pw p0i with heap := highHeap s p1 p2 a0 a1 w pw p0i}
def bodyOut (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32) : State :=
  restoreScope s (highState s p1 p2 a0 a1 w pw p0i) firstDecls []

/- Fresh block locals of the butterfly scope. -/
theorem a0_fresh (s : State) : (declared s).locals "a0".toList = some (.uint32, none) := by
  simp [declared, C99DeclarationStatements.effect, C99DeclarationCells.declareCells, firstDecls,
    C99ScalarReference.set, C99ValueBridge.type]
theorem a1_fresh (s : State) (a0 : BitVec 32) :
    (withA0 s a0).locals "a1".toList = some (.uint32, none) := by
  simp [withA0, ModularAtoms178.set, C99ArrayReference.bindValue, C99ScalarReference.set,
    declared, C99DeclarationStatements.effect, C99DeclarationCells.declareCells, firstDecls,
    C99ValueBridge.type]
theorem b_fresh (s : State) (a0 a1 : BitVec 32) :
    (withA1 s a0 a1).locals "b".toList = some (.uint32, none) := by
  simp [withA1, ModularAtoms178.set, C99ArrayReference.bindValue, C99ScalarReference.set,
    withA0, declared, C99DeclarationStatements.effect, C99DeclarationCells.declareCells, firstDecls,
    C99ValueBridge.type]

theorem a0_slot (s : State) (a0 : BitVec 32) : Slot (withA0 s a0) "a0" a0 :=
  ModularAtoms178.slot (declared s) "a0" a0
theorem a1_slot (s : State) (a0 a1 : BitVec 32) : Slot (withA1 s a0 a1) "a1" a1 :=
  ModularAtoms178.slot (withA0 s a0) "a1" a1
theorem b_slot (s : State) (a0 a1 b : BitVec 32) : Slot (withB s a0 a1 b) "b" b :=
  ModularAtoms178.slot (withA1 s a0 a1) "b" b

theorem set_keep (s : State) (target other : String) (w v : BitVec 32)
    (different : other.toList ≠ target.toList) (base : Slot s other v) :
    Slot (ModularAtoms178.set s target w) other v :=
  (ModularAtoms178.outside s target other w different).trans base

theorem declared_outside (s : State) (name : Name) (absent : ¬ firstDecls.contains name) :
    (declared s).locals name = s.locals name := by
  show C99DeclarationCells.declareCells (C99ValueBridge.type .u32) firstDecls s.locals name = _
  exact StepProductBody191.cells_outside (C99ValueBridge.type .u32) firstDecls s.locals name
    (fun hit => absent (KeygenNttLoopSupport.contains_iff.mpr hit))

theorem declared_keep (s : State) (other : String) (v : BitVec 32) (base : Slot s other v)
    (absent : ¬ firstDecls.contains other.toList) : Slot (declared s) other v :=
  (declared_outside s other.toList absent).trans base

theorem slot_keep (s : State) (target : String) (a0 a1 b v : BitVec 32)
    (first : target.toList ≠ "a0".toList) (second : target.toList ≠ "a1".toList)
    (third : target.toList ≠ "b".toList) (base : Slot s target v) :
    Slot (withB s a0 a1 b) target v :=
  set_keep (withA1 s a0 a1) "b" target b v third
    (set_keep (withA0 s a0) "a1" target a1 v second
      (set_keep (declared s) "a0" target a0 v first
        (declared_keep s target v base (by
          intro hit
          have mem : target.toList ∈ firstDecls := KeygenNttLoopSupport.contains_iff.mp hit
          simp only [firstDecls, List.mem_cons, List.not_mem_nil, or_false] at mem
          rcases mem with h | h | h
          · exact first h
          · exact second h
          · exact third h))))

theorem withB_heap (s : State) (a0 a1 b : BitVec 32) : (withB s a0 a1 b).heap = s.heap := rfl

theorem b_a0_slot (s : State) (a0 a1 b : BitVec 32) : Slot (withB s a0 a1 b) "a0" a0 :=
  set_keep (withA1 s a0 a1) "b" "a0" b a0 (by decide)
    (set_keep (withA0 s a0) "a1" "a0" a1 a0 (by decide) (a0_slot s a0))
theorem b_a1_slot (s : State) (a0 a1 b : BitVec 32) : Slot (withB s a0 a1 b) "a1" a1 :=
  set_keep (withA1 s a0 a1) "b" "a1" b a1 (by decide) (a1_slot s a0 a1)

/-! ## The butterfly block run -/

theorem body_run (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32)
    (wSlot : Slot s "w" w) (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0i)
    (r1Binding : s.arrays "r1".toList = some p1) (r2Binding : s.arrays "r2".toList = some p2)
    (read1 : Load32 s.heap p1 a0) (read2 : Load32 s.heap p2 a1)
    (p1Allocated : Allocated s.heap p1) (p1Width : p1.elementBytes = 4)
    (p1Writable : s.heap.writable p1.block = true)
    (p2Allocated : Allocated s.heap p2) (p2Width : p2.elementBytes = 4)
    (p2Writable : s.heap.writable p2.block = true) :
    Exec KeygenNttButterflyPrograms.firstBody s ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ := by
  have declareRun : Exec bDeclare s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 firstDecls s)
  have p1Cap : p1.index ≤ p1.count := Nat.le_of_lt p1Allocated.2.2.1
  have p2Cap : p2.index ≤ p2.count := Nat.le_of_lt p2Allocated.2.2.1
  have a0Address : Pointer (declared s) "r1".toList KeygenNttButterflyPrograms.zero p1 :=
    StepCopyBody190.zero_pointer (declared s) "r1".toList p1 r1Binding p1Cap
  have a0Run : Exec bAssignA0 (declared s) ⟨withA0 s a0,.normal⟩ :=
    ModularAtoms178.assign (declared s) "a0" none
      (KeygenNttButterflyPrograms.read "r1") a0 (a0_fresh s)
      (.load32 "r1".toList KeygenNttButterflyPrograms.zero p1 a0 a0Address read1)
  have a1Address : Pointer (withA0 s a0) "r2".toList KeygenNttButterflyPrograms.zero p2 :=
    StepCopyBody190.zero_pointer (withA0 s a0) "r2".toList p2 r2Binding p2Cap
  have a1Run : Exec bAssignA1 (withA0 s a0) ⟨withA1 s a0 a1,.normal⟩ :=
    ModularAtoms178.assign (withA0 s a0) "a1" none
      (KeygenNttButterflyPrograms.read "r2") a1 (a1_fresh s a0)
      (.load32 "r2".toList KeygenNttButterflyPrograms.zero p2 a1 a1Address read2)
  have wSlotA1 : Slot (withA1 s a0 a1) "w" w :=
    set_keep (withA0 s a0) "a1" "w" a1 w (by decide)
      (set_keep (declared s) "a0" "w" a0 w (by decide) (declared_keep s "w" w wSlot (by decide)))
  have pSlotA1 : Slot (withA1 s a0 a1) "p" pw :=
    set_keep (withA0 s a0) "a1" "p" a1 pw (by decide)
      (set_keep (declared s) "a0" "p" a0 pw (by decide) (declared_keep s "p" pw pSlot (by decide)))
  have p0iSlotA1 : Slot (withA1 s a0 a1) "p0i" p0i :=
    set_keep (withA0 s a0) "a1" "p0i" a1 p0i (by decide)
      (set_keep (declared s) "a0" "p0i" a0 p0i (by decide)
        (declared_keep s "p0i" p0i p0iSlot (by decide)))
  have montEval : Eval (withA1 s a0 a1)
      (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "a1")
        (KeygenNttButterflyPrograms.scalar "w"))
      (.uint32 (montWord a1 w pw p0i)) :=
    ModularAtoms178.mont (withA1 s a0 a1) (KeygenNttButterflyPrograms.scalar "a1")
      (KeygenNttButterflyPrograms.scalar "w") a1 w pw p0i
      (ModularAtoms178.cell (withA1 s a0 a1) "a1" a1 (a1_slot s a0 a1))
      (ModularAtoms178.cell (withA1 s a0 a1) "w" w wSlotA1) pSlotA1 p0iSlotA1
  have bRun : Exec bAssignB (withA1 s a0 a1) ⟨withB s a0 a1 (montWord a1 w pw p0i),.normal⟩ :=
    ModularAtoms178.assign (withA1 s a0 a1) "b" none
      (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "a1")
        (KeygenNttButterflyPrograms.scalar "w")) (montWord a1 w pw p0i) (b_fresh s a0 a1) montEval
  have pSlotB : Slot (withB s a0 a1 (montWord a1 w pw p0i)) "p" pw :=
    slot_keep s "p" a0 a1 (montWord a1 w pw p0i) pw (by decide) (by decide) (by decide) pSlotA1
  have lowEval : Eval (withB s a0 a1 (montWord a1 w pw p0i))
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
        (KeygenNttButterflyPrograms.scalar "b"))
      (.uint32 (lowWord a0 a1 w pw p0i)) :=
    ModularWordOps182.add (withB s a0 a1 (montWord a1 w pw p0i))
      (KeygenNttButterflyPrograms.scalar "a0") (KeygenNttButterflyPrograms.scalar "b")
      a0 (montWord a1 w pw p0i) pw
      (ModularAtoms178.cell (withB s a0 a1 (montWord a1 w pw p0i)) "a0" a0
        (b_a0_slot s a0 a1 (montWord a1 w pw p0i)))
      (ModularAtoms178.cell (withB s a0 a1 (montWord a1 w pw p0i)) "b" (montWord a1 w pw p0i)
        (b_slot s a0 a1 (montWord a1 w pw p0i))) pSlotB
  have lowStored : Store32 (withB s a0 a1 (montWord a1 w pw p0i)).heap p1
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (lowWord a0 a1 w pw p0i))))
      (Word32Memory176.write (withB s a0 a1 (montWord a1 w pw p0i)).heap p1
        (lowWord a0 a1 w pw p0i)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source (withB s a0 a1 (montWord a1 w pw p0i)).heap p1
        (lowWord a0 a1 w pw p0i) (by rw [withB_heap]; exact p1Allocated) p1Width
        (by rw [withB_heap]; exact p1Writable)
  have lowAddress : Pointer (withB s a0 a1 (montWord a1 w pw p0i)) "r1".toList
      KeygenNttButterflyPrograms.zero p1 :=
    StepCopyBody190.zero_pointer (withB s a0 a1 (montWord a1 w pw p0i)) "r1".toList p1 r1Binding
      p1Cap
  have lowRun : Exec bWriteLow (withB s a0 a1 (montWord a1 w pw p0i))
      ⟨lowState s p1 a0 a1 w pw p0i,.normal⟩ :=
    .store32 "r1".toList KeygenNttButterflyPrograms.zero
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
        (KeygenNttButterflyPrograms.scalar "b"))
      (withB s a0 a1 (montWord a1 w pw p0i))
      (Word32Memory176.write (withB s a0 a1 (montWord a1 w pw p0i)).heap p1
        (lowWord a0 a1 w pw p0i)) p1 (.uint32 (lowWord a0 a1 w pw p0i)) lowAddress lowEval lowStored
  have sumEval : Eval (lowState s p1 a0 a1 w pw p0i)
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
        (KeygenNttButterflyPrograms.scalar "a1"))
      (.uint32 (sumWord a0 a1 pw)) :=
    ModularWordOps182.add (lowState s p1 a0 a1 w pw p0i)
      (KeygenNttButterflyPrograms.scalar "a0") (KeygenNttButterflyPrograms.scalar "a1")
      a0 a1 pw
      (ModularAtoms178.cell (lowState s p1 a0 a1 w pw p0i) "a0" a0
        (b_a0_slot s a0 a1 (montWord a1 w pw p0i)))
      (ModularAtoms178.cell (lowState s p1 a0 a1 w pw p0i) "a1" a1
        (b_a1_slot s a0 a1 (montWord a1 w pw p0i))) pSlotB
  have highEval : Eval (lowState s p1 a0 a1 w pw p0i)
      (KeygenNttButterflyPrograms.sub
        (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
          (KeygenNttButterflyPrograms.scalar "a1"))
        (KeygenNttButterflyPrograms.scalar "b"))
      (.uint32 (highWord a0 a1 w pw p0i)) :=
    ModularWordOps182.sub (lowState s p1 a0 a1 w pw p0i)
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
        (KeygenNttButterflyPrograms.scalar "a1")) (KeygenNttButterflyPrograms.scalar "b")
      (sumWord a0 a1 pw) (montWord a1 w pw p0i) pw sumEval
      (ModularAtoms178.cell (lowState s p1 a0 a1 w pw p0i) "b" (montWord a1 w pw p0i)
        (b_slot s a0 a1 (montWord a1 w pw p0i))) pSlotB
  have highStored : Store32 (lowState s p1 a0 a1 w pw p0i).heap p2
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (highWord a0 a1 w pw p0i))))
      (Word32Memory176.write (lowState s p1 a0 a1 w pw p0i).heap p2
        (highWord a0 a1 w pw p0i)) := by
    have p2Alloc' : Allocated (lowState s p1 a0 a1 w pw p0i).heap p2 :=
      write_allocated (withB s a0 a1 (montWord a1 w pw p0i)).heap p1 p2
        (lowWord a0 a1 w pw p0i) (by rw [withB_heap]; exact p2Allocated)
    have p2Writable' : (lowState s p1 a0 a1 w pw p0i).heap.writable p2.block = true :=
      write_writable (withB s a0 a1 (montWord a1 w pw p0i)).heap p1 p2
        (lowWord a0 a1 w pw p0i) (by rw [withB_heap]; exact p2Writable)
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source (lowState s p1 a0 a1 w pw p0i).heap p2
        (highWord a0 a1 w pw p0i) p2Alloc' p2Width p2Writable'
  have highAddress : Pointer (lowState s p1 a0 a1 w pw p0i) "r2".toList
      KeygenNttButterflyPrograms.zero p2 :=
    StepCopyBody190.zero_pointer (lowState s p1 a0 a1 w pw p0i) "r2".toList p2 r2Binding p2Cap
  have highRun : Exec bWriteHigh (lowState s p1 a0 a1 w pw p0i)
      ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
    .store32 "r2".toList KeygenNttButterflyPrograms.zero
      (KeygenNttButterflyPrograms.sub
        (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
          (KeygenNttButterflyPrograms.scalar "a1"))
        (KeygenNttButterflyPrograms.scalar "b"))
      (lowState s p1 a0 a1 w pw p0i)
      (Word32Memory176.write (lowState s p1 a0 a1 w pw p0i).heap p2
        (highWord a0 a1 w pw p0i)) p2 (.uint32 (highWord a0 a1 w pw p0i)) highAddress highEval
      highStored
  have skipRun : Exec (.base .skip) (highState s p1 p2 a0 a1 w pw p0i)
      ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
    .base _ _ _ (.skip _)
  have run1 : Exec bTail1 (lowState s p1 a0 a1 w pw p0i)
      ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
    .seqNormal _ _ _ _ _ highRun skipRun
  have run2 : Exec bTail2 (withB s a0 a1 (montWord a1 w pw p0i))
      ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
    .seqNormal _ _ _ _ _ lowRun run1
  have run3 : Exec bTail3 (withA1 s a0 a1) ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
    .seqNormal _ _ _ _ _ bRun run2
  have run4 : Exec bTail4 (withA0 s a0) ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
    .seqNormal _ _ _ _ _ a1Run run3
  have run5 : Exec bTail5 (declared s) ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
    .seqNormal _ _ _ _ _ a0Run run4
  rw [body_shape]
  exact .seqNormal _ _ _ _ _ declareRun run5

/-! ## The butterfly block frame -/

theorem first_each : ∀ a ∈ KeygenNttButterflyPrograms.firstAtoms, ∀ s out, Exec a s out →
    ∃ ws : List Name, KeygenNttLoopSupport.localOnly a = some ws ∧
      KeygenNttLoopSupport.FrameOk ws s out ∧ ∀ n, ws.contains n → firstDecls.contains n := by
  intro a hin s out source
  simp [KeygenNttButterflyPrograms.firstAtoms,List.mem_cons] at hin
  rcases hin with rfl|rfl|rfl|rfl|rfl|rfl
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact hn
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="a0".toList := by
      simpa [KeygenNttLoopSupport.contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="a1".toList := by
      simpa [KeygenNttLoopSupport.contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="b".toList := by
      simpa [KeygenNttLoopSupport.contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (KeygenNttLoopSupport.contains_iff.mp hn)).elim
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (KeygenNttLoopSupport.contains_iff.mp hn)).elim

theorem block_run (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32)
    (wSlot : Slot s "w" w) (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0i)
    (r1Binding : s.arrays "r1".toList = some p1) (r2Binding : s.arrays "r2".toList = some p2)
    (read1 : Load32 s.heap p1 a0) (read2 : Load32 s.heap p2 a1)
    (p1Allocated : Allocated s.heap p1) (p1Width : p1.elementBytes = 4)
    (p1Writable : s.heap.writable p1.block = true)
    (p2Allocated : Allocated s.heap p2) (p2Width : p2.elementBytes = 4)
    (p2Writable : s.heap.writable p2.block = true) :
    Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) s
      ⟨bodyOut s p1 p2 a0 a1 w pw p0i,.normal⟩ :=
  .scope (C99ModularParser.declarations KeygenNttButterflyPrograms.firstBody)
    KeygenNttButterflyPrograms.firstBody s ⟨highState s p1 p2 a0 a1 w pw p0i,.normal⟩
    (body_run s p1 p2 a0 a1 w pw p0i wSlot pSlot p0iSlot r1Binding r2Binding read1 read2
      p1Allocated p1Width p1Writable p2Allocated p2Width p2Writable)

theorem block_keep (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32)
    (wSlot : Slot s "w" w) (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0i)
    (r1Binding : s.arrays "r1".toList = some p1) (r2Binding : s.arrays "r2".toList = some p2)
    (read1 : Load32 s.heap p1 a0) (read2 : Load32 s.heap p2 a1)
    (p1Allocated : Allocated s.heap p1) (p1Width : p1.elementBytes = 4)
    (p1Writable : s.heap.writable p1.block = true)
    (p2Allocated : Allocated s.heap p2) (p2Width : p2.elementBytes = 4)
    (p2Writable : s.heap.writable p2.block = true) :
    (bodyOut s p1 p2 a0 a1 w pw p0i).arrays = s.arrays ∧
      (bodyOut s p1 p2 a0 a1 w pw p0i).locals = s.locals := by
  have run := block_run s p1 p2 a0 a1 w pw p0i wSlot pSlot p0iSlot r1Binding r2Binding read1 read2
    p1Allocated p1Width p1Writable p2Allocated p2Width p2Writable
  have key := KeygenNttLoopSupport.block_frame
    (C99ModularParser.declarations KeygenNttButterflyPrograms.firstBody)
    KeygenNttButterflyPrograms.firstAtoms s ⟨bodyOut s p1 p2 a0 a1 w pw p0i,.normal⟩ run (by
      intro a hin s' out' hs
      obtain ⟨ws,hl,hf,hc⟩ := first_each a hin s' out' hs
      refine ⟨ws,hl,hf,?_⟩
      intro n hn
      rw [first_decls]
      exact hc n hn)
  exact ⟨key.2.1,key.2.2⟩

/- The block keeps every caller cell; only the heap changes, by exactly the
   two butterfly stores. -/
theorem body_state (s : State) (p1 p2 : ArrayPointer) (a0 a1 w pw p0i : BitVec 32)
    (wSlot : Slot s "w" w) (pSlot : Slot s "p" pw) (p0iSlot : Slot s "p0i" p0i)
    (r1Binding : s.arrays "r1".toList = some p1) (r2Binding : s.arrays "r2".toList = some p2)
    (read1 : Load32 s.heap p1 a0) (read2 : Load32 s.heap p2 a1)
    (p1Allocated : Allocated s.heap p1) (p1Width : p1.elementBytes = 4)
    (p1Writable : s.heap.writable p1.block = true)
    (p2Allocated : Allocated s.heap p2) (p2Width : p2.elementBytes = 4)
    (p2Writable : s.heap.writable p2.block = true) :
    bodyOut s p1 p2 a0 a1 w pw p0i =
      {s with heap := highHeap s p1 p2 a0 a1 w pw p0i} := by
  have keep := block_keep s p1 p2 a0 a1 w pw p0i wSlot pSlot p0iSlot r1Binding r2Binding read1
    read2 p1Allocated p1Width p1Writable p2Allocated p2Width p2Writable
  exact StepProductBody191.state_ext rfl keep.2 keep.1 rfl rfl

end FT1536.Source3.StepNttBody195
