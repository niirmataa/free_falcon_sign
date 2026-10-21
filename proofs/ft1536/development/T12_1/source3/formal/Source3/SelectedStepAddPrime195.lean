import Source3.MakeFgAddPrimeShape194
import Source3.KeygenModpRxExec
import Source3.KeygenStaticReads
import Source3.C99LoopScalar141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The seven-statement prime prefix of the make_fg_step additional-prime
   loop body at the u = 1 iteration (MakeFgAddPrimeShape194.prefixSteps,
   the selected instance slen = 1 / tlen = 2): the p/p0i/R2/Rx
   declaration, the v and x declarations, the primes[1].p read and the
   executed-word calls p0i = modp_ninv31(p), R2 = modp_R2(p, p0i),
   Rx = modp_Rx(slen, p, p0i, R2). The assembly is over ready elements
   only, with no new engine in this layer: the KeygenLevelCalls.PrimeRead
   constructor at the u = 1 index, the closed KeygenNinv31 and
   KeygenModpR2Exec call exports, and the closed KeygenModpRxExec
   empty-loop engine at the u64 call shape SourceExec64/source64_*.

   The u = 1 words are the executed words p1 = primes[1].p (the row-1
   block-21 ternary table word, pinned by decide against the parse
   record), p0i1 = KeygenNinv31.word p1, r21 = KeygenModpR2Word.word p1
   p0i1 and rx1 = KeygenModpR.word p1 (the empty-loop modp_Rx word at
   x = 1, KeygenModpRxExec.body_exact). The loop head (u = slen, the
   u < tlen guard true at 1 < 2) is composed over any exit state
   carrying the u/slen/tlen cells and the primes binding.

   Values stay executed words: no transform property, table law, root
   law, positivity or Z>0 claim is made here. Scope boundary (honest):
   the row-1 table word load at the entry heap is a HYPOTHESIS of the
   prefix; its transport to the concrete part-3 CRT exit state is the
   block-21 keep chain (SelectedStepCrtWord194 precedent), and the
   loop-body cells at that concrete exit state come from
   SelectedStepFsFd194.source through SelectedStepCrtRun194 — both are
   discharged by the section-export window, not here. The exact
   direction (every derivation of the seven statements ends in the same
   words) is not claimed; the result-state cells pin the words of the
   exported execution, matching the first-prime layer
   (SelectedStepPrime188) scope. -/
namespace FT1536.Source3.SelectedStepAddPrime195
open C99ArrayReference (State Name Pointer bindValue)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes)
open C99NatWord141 (word)
open C99LoopScalar141 (Cell)
open KeygenStaticTables (PrimeObject primeField values fieldValue rows row)

/- The u = 1 words: the primes[1] row of the block-21 ternary table and
   the closed callee words built from it. -/
def p1 : BitVec 32 := BitVec.ofNat 32 2147346433
def p0i1 : BitVec 32 := KeygenNinv31.word p1
def r21 : BitVec 32 := KeygenModpR2Word.word p1 p0i1
def rx1 : BitVec 32 := KeygenModpR.word p1

def primes1 : ArrayPointer := {primes with index := primes.index+1}

theorem row1 : ((rows .ternary)[1]?).bind row=some (2147346433,1119654270,238827065) := by
  decide +kernel
theorem row1_value : (values .ternary)[1]?=some (2147346433,1119654270,238827065) :=
  (KeygenStaticReads.indexed_source .ternary 1).symm.trans row1

theorem p1_word : BitVec.ofNat 32 (fieldValue (2147346433,1119654270,238827065) .p)=p1 := rfl
theorem fieldPointer_one : KeygenLevelCalls.fieldPointer primes1 .p=primeField primes 1 .p := rfl
theorem primes1_index : primes1.index=1 := rfl
theorem primes1_extent : primes1.index<primes1.count := by decide
theorem primes1_width : primes1.elementBytes=12 := rfl

/- The row-1 word from the table object at an arbitrary heap (the keep
   chain supplies the object or the load at the entry state). -/
theorem object_word (s : State) (object : PrimeObject s.heap primes .ternary) :
    Load32 s.heap (primeField primes 1 .p) p1 := by
  rw [← p1_word]
  exact object.2.2.2.2.2.2 1 (2147346433,1119654270,238827065) row1_value .p

/- Executed states of the seven-statement prefix at entry state s. -/
def withWords (s : State) : State :=
  C99DeclarationStatements.effect .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s
def withV (s : State) : State := C99DeclarationStatements.effect .u64 ["v".toList] (withWords s)
def withX (s : State) : State := DeepestDeclarations175.clear (withV s) "x".toList
def withP (s : State) : State := bindValue (withX s) "p".toList .uint32 (.uint32 p1)
def withI (s : State) : State := bindValue (withP s) "p0i".toList .uint32 (.uint32 p0i1)
def withR (s : State) : State := bindValue (withI s) "R2".toList .uint32 (.uint32 r21)
def after (s : State) : State := bindValue (withR s) "Rx".toList .uint32 (.uint32 rx1)

/- State keeps through the declaration effects and the prefix stores. -/
theorem declareCells_keep (ty : C99IntegerReference.Ty) (names : List Name)
    (env : C99ScalarReference.Env) (name : Name) (absent : name∉names) :
    C99DeclarationCells.declareCells ty names env name=env name := by
  induction names generalizing env with
  | nil => rfl
  | cons first rest ih =>
    have different : name≠first := fun same => absurd (by simp [same]) absent
    have tail : name∉rest := fun mem => absent (List.mem_cons_of_mem _ mem)
    simp only [C99DeclarationCells.declareCells]
    rw [ih (C99ScalarReference.set env first (ty,none)) tail]
    simp [C99ScalarReference.set,different]

theorem effect_locals (ty : B20.C.Ty) (names : List Name) (s : State) (name : Name)
    (absent : name∉names) : (C99DeclarationStatements.effect ty names s).locals name=s.locals name :=
  declareCells_keep (C99ValueBridge.type ty) names s.locals name absent

theorem effect_arrays (ty : B20.C.Ty) (names : List Name) (s : State) (name : Name) :
    (C99DeclarationStatements.effect ty names s).arrays name=s.arrays name := rfl
theorem effect_heap (ty : B20.C.Ty) (names : List Name) (s : State) :
    (C99DeclarationStatements.effect ty names s).heap=s.heap := rfl

theorem clear_locals (s : State) (name other : Name) :
    (DeepestDeclarations175.clear s name).locals other=s.locals other := rfl
theorem clear_arrays (s : State) (name other : Name) (different : other≠name) :
    (DeepestDeclarations175.clear s name).arrays other=s.arrays other := by
  simp [DeepestDeclarations175.clear,different]
theorem clear_heap (s : State) (name : Name) :
    (DeepestDeclarations175.clear s name).heap=s.heap := rfl

theorem bind_locals_same (s : State) (name : Name) (ty : C99IntegerReference.Ty) (v : Value) :
    (bindValue s name ty v).locals name=some (ty,some (C99IntegerReference.convert ty v.integer)) := by
  simp [bindValue,C99ScalarReference.set]
theorem locals_keep (s : State) (name : Name) (ty : C99IntegerReference.Ty) (v : Value)
    (other : Name) (different : other≠name) : (bindValue s name ty v).locals other=s.locals other := by
  simp [bindValue,C99ScalarReference.set,different]
theorem bind_arrays (s : State) (name : Name) (ty : C99IntegerReference.Ty) (v : Value)
    (other : Name) : (bindValue s name ty v).arrays other=s.arrays other := rfl
theorem bind_heap (s : State) (name : Name) (ty : C99IntegerReference.Ty) (v : Value) :
    (bindValue s name ty v).heap=s.heap := rfl

theorem cell_pair (ty : C99IntegerReference.Ty) (a b : Value) (same : a=b) :
    some (ty,some a)=some (ty,some b) := congrArg (fun w => some (ty,some w)) same

/- The declared cells consumed by the prefix statements. -/
theorem withX_u (s : State) (uCell : s.locals "u".toList=some (.uint64,some (.uint64 (word 1)))) :
    (withX s).locals "u".toList=some (.uint64,some (.uint64 (word 1))) :=
  (clear_locals (withV s) "x".toList "u".toList).trans
    ((effect_locals .u64 ["v".toList] (withWords s) "u".toList (by decide)).trans
      ((effect_locals .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s "u".toList
        (by decide)).trans uCell))

theorem withX_slen (s : State)
    (slenCell : s.locals "slen".toList=some (.uint64,some (.uint64 (word 1)))) :
    (withX s).locals "slen".toList=some (.uint64,some (.uint64 (word 1))) :=
  (clear_locals (withV s) "x".toList "slen".toList).trans
    ((effect_locals .u64 ["v".toList] (withWords s) "slen".toList (by decide)).trans
      ((effect_locals .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s "slen".toList
        (by decide)).trans slenCell))

theorem withX_primes (s : State) (bind : s.arrays "primes".toList=some primes) :
    (withX s).arrays "primes".toList=some primes :=
  (clear_arrays (withV s) "x".toList "primes".toList (by decide)).trans
    ((effect_arrays .u64 ["v".toList] (withWords s) "primes".toList).trans
      ((effect_arrays .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s
        "primes".toList).trans bind))

theorem withX_heap (s : State) : (withX s).heap=s.heap :=
  (clear_heap (withV s) "x".toList).trans
    ((effect_heap .u64 ["v".toList] (withWords s)).trans
      (effect_heap .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s))

/- Cell equations of the prefix states (the executed words). -/
theorem withP_p (s : State) : (withP s).locals "p".toList=some (.uint32,some (.uint32 p1)) :=
  (bind_locals_same (withX s) "p".toList .uint32 (.uint32 p1)).trans
    (cell_pair _ _ _ (ZintSubWord194.convert_self32 p1))
theorem withI_p (s : State) : (withI s).locals "p".toList=some (.uint32,some (.uint32 p1)) :=
  (locals_keep (withP s) "p0i".toList .uint32 (.uint32 p0i1) "p".toList (by decide)).trans (withP_p s)
theorem withI_i (s : State) : (withI s).locals "p0i".toList=some (.uint32,some (.uint32 p0i1)) :=
  (bind_locals_same (withP s) "p0i".toList .uint32 (.uint32 p0i1)).trans
    (cell_pair _ _ _ (ZintSubWord194.convert_self32 p0i1))
theorem withR_p (s : State) : (withR s).locals "p".toList=some (.uint32,some (.uint32 p1)) :=
  (locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) "p".toList (by decide)).trans (withI_p s)
theorem withR_i (s : State) : (withR s).locals "p0i".toList=some (.uint32,some (.uint32 p0i1)) :=
  (locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) "p0i".toList (by decide)).trans (withI_i s)
theorem withR_r (s : State) : (withR s).locals "R2".toList=some (.uint32,some (.uint32 r21)) :=
  (bind_locals_same (withI s) "R2".toList .uint32 (.uint32 r21)).trans
    (cell_pair _ _ _ (ZintSubWord194.convert_self32 r21))
theorem withR_slen (s : State)
    (slenCell : s.locals "slen".toList=some (.uint64,some (.uint64 (word 1)))) :
    (withR s).locals "slen".toList=some (.uint64,some (.uint64 (word 1))) :=
  (locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) "slen".toList (by decide)).trans
    ((locals_keep (withP s) "p0i".toList .uint32 (.uint32 p0i1) "slen".toList (by decide)).trans
      ((locals_keep (withX s) "p".toList .uint32 (.uint32 p1) "slen".toList (by decide)).trans
        (withX_slen s slenCell)))
theorem after_p (s : State) : (after s).locals "p".toList=some (.uint32,some (.uint32 p1)) :=
  (locals_keep (withR s) "Rx".toList .uint32 (.uint32 rx1) "p".toList (by decide)).trans (withR_p s)
theorem after_i (s : State) : (after s).locals "p0i".toList=some (.uint32,some (.uint32 p0i1)) :=
  (locals_keep (withR s) "Rx".toList .uint32 (.uint32 rx1) "p0i".toList (by decide)).trans (withR_i s)
theorem after_r (s : State) : (after s).locals "R2".toList=some (.uint32,some (.uint32 r21)) :=
  (locals_keep (withR s) "Rx".toList .uint32 (.uint32 rx1) "R2".toList (by decide)).trans (withR_r s)
theorem after_rx (s : State) : (after s).locals "Rx".toList=some (.uint32,some (.uint32 rx1)) :=
  (bind_locals_same (withR s) "Rx".toList .uint32 (.uint32 rx1)).trans
    (cell_pair _ _ _ (ZintSubWord194.convert_self32 rx1))
theorem after_heap (s : State) : (after s).heap=s.heap :=
  (bind_heap (withR s) "Rx".toList .uint32 (.uint32 rx1)).trans
    ((bind_heap (withI s) "R2".toList .uint32 (.uint32 r21)).trans
      ((bind_heap (withP s) "p0i".toList .uint32 (.uint32 p0i1)).trans
        ((bind_heap (withX s) "p".toList .uint32 (.uint32 p1)).trans (withX_heap s))))

/- The three declaration statements. -/
theorem words_run (s : State) : Exec MakeFgAddPrimeShape194.declP s ⟨withWords s,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _
    (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
      ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s)

theorem v_run (s : State) : Exec MakeFgAddPrimeShape194.declV (withWords s) ⟨withV s,.normal⟩ :=
  MakeFgDeclarations176.array_source _ _ _
    (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["v".toList] (withWords s))

theorem x_run (s : State) : Exec MakeFgAddPrimeShape194.declX (withV s) ⟨withX s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (DeepestDeclarations175.pointer_source ["x".toList] (withV s)
    (.base .skip) ⟨withX s,.normal⟩ (.base .skip _ _ (.skip _))))

theorem decls_run (s : State) : MakeFgSequence187.Run
    [MakeFgAddPrimeShape194.declP,MakeFgAddPrimeShape194.declV,MakeFgAddPrimeShape194.declX]
    s (withX s) :=
  .cons _ _ _ _ _ (words_run s) (.cons _ _ _ _ _ (v_run s) (.cons _ _ _ _ _ (x_run s) (.nil (withX s))))

/- Statement 4: p = primes[u].p at u = 1 (the row-1 block-21 word). -/
theorem p_read (s : State) (bind : s.arrays "primes".toList=some primes)
    (uCell : s.locals "u".toList=some (.uint64,some (.uint64 (word 1))))
    (load : Load32 s.heap (primeField primes 1 .p) p1) :
    KeygenLevelCalls.PrimeRead (withX s) "primes".toList (FirstStepEntry187.var "u") .p (.uint32 p1) :=
  KeygenLevelCalls.PrimeRead.read primes1 p1
    (C99ArrayReference.Pointer.add "primes".toList (FirstStepEntry187.var "u") primes primes1
      (.uint64 (word 1)) (withX_primes s bind)
      (C99ScalarReference.Eval.variable "u".toList .uint64 (.uint64 (word 1)) (withX_u s uCell))
      (by decide) (C99MemoryReference.PointerAdd.within primes 1 (by decide)))
    primes1_width primes1_extent (by rw [withX_heap,fieldPointer_one]; exact load)

theorem p_source (s : State) (bind : s.arrays "primes".toList=some primes)
    (uCell : s.locals "u".toList=some (.uint64,some (.uint64 (word 1))))
    (load : Load32 s.heap (primeField primes 1 .p) p1) :
    Exec MakeFgAddPrimeShape194.pSet (withX s) ⟨withP s,.normal⟩ :=
  .level _ _ _ (.prime "p".toList "primes".toList (FirstStepEntry187.var "u") .p (withX s)
    .uint32 none (.uint32 p1) rfl (p_read s bind uCell load))

/- Statement 5: p0i = modp_ninv31(p) at the pinned callee body. -/
theorem i_source (s : State) : Exec MakeFgAddPrimeShape194.iSet (withP s) ⟨withI s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign "p0i".toList
    (C99ModularReference.Expr.call1 "modp_ninv31".toList (KeygenMkgm3Program.cell "p")) (withP s)
    .uint32 none (.uint32 p0i1) rfl
    (.call1 "modp_ninv31".toList (KeygenMkgm3Program.cell "p") (.uint32 p1) (.uint32 p0i1)
      (.scalar _ _ (C99ScalarReference.Eval.variable "p".toList .uint32 (.uint32 p1) (withP_p s)))
      (.inverse [.uint32 p1] (.uint32 p0i1) (KeygenNinv31.source_exists p1)))))

/- Statement 6: R2 = modp_R2(p, p0i) at the pinned callee body. -/
theorem r_source (s : State) : Exec MakeFgAddPrimeShape194.rSet (withI s) ⟨withR s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign "R2".toList
    (C99ModularReference.Expr.call2 "modp_R2".toList (KeygenMkgm3Program.cell "p")
      (KeygenMkgm3Program.cell "p0i")) (withI s) .uint32 none (.uint32 r21) rfl
    (.call2 "modp_R2".toList (KeygenMkgm3Program.cell "p") (KeygenMkgm3Program.cell "p0i")
      (.uint32 p1) (.uint32 p0i1) (.uint32 r21)
      (.scalar _ _ (C99ScalarReference.Eval.variable "p".toList .uint32 (.uint32 p1) (withI_p s)))
      (.scalar _ _ (C99ScalarReference.Eval.variable "p0i".toList .uint32 (.uint32 p0i1) (withI_i s)))
      (.r2 [.uint32 p1,.uint32 p0i1] (.uint32 r21)
        (KeygenModpR2Exec.source_exists (withI s) p1 p0i1)))))

/- Statement 7: Rx = modp_Rx(slen, p, p0i, R2) at the u64 call shape of
   the closed KeygenModpRxExec empty-loop engine (x = slen = 1). -/
theorem rx_source (s : State)
    (slenCell : s.locals "slen".toList=some (.uint64,some (.uint64 (word 1)))) :
    Exec MakeFgAddPrimeShape194.rxSet (withR s) ⟨after s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign "Rx".toList
    (C99ModularReference.Expr.call4 "modp_Rx".toList (KeygenMkgm3Program.cell "slen")
      (KeygenMkgm3Program.cell "p") (KeygenMkgm3Program.cell "p0i") (KeygenMkgm3Program.cell "R2"))
    (withR s) .uint32 none (.uint32 rx1) rfl
    (.call4 "modp_Rx".toList (KeygenMkgm3Program.cell "slen") (KeygenMkgm3Program.cell "p")
      (KeygenMkgm3Program.cell "p0i") (KeygenMkgm3Program.cell "R2")
      (.uint64 (word 1)) (.uint32 p1) (.uint32 p0i1) (.uint32 r21) (.uint32 rx1)
      (.scalar _ _ (C99ScalarReference.Eval.variable "slen".toList .uint64 (.uint64 (word 1))
        (withR_slen s slenCell)))
      (.scalar _ _ (C99ScalarReference.Eval.variable "p".toList .uint32 (.uint32 p1) (withR_p s)))
      (.scalar _ _ (C99ScalarReference.Eval.variable "p0i".toList .uint32 (.uint32 p0i1)
        (withR_i s)))
      (.scalar _ _ (C99ScalarReference.Eval.variable "R2".toList .uint32 (.uint32 r21) (withR_r s)))
      (C99ModularReference.ModCall.rx [.uint64 (word 1),.uint32 p1,.uint32 p0i1,.uint32 r21]
        (.uint32 rx1) (KeygenModpRxExec.source64_exists (withR s) p1 p0i1 r21)))))

/- The exported prefix execution and the continuation of the loop body. -/
theorem append_source (s : State) (bind : s.arrays "primes".toList=some primes)
    (uCell : s.locals "u".toList=some (.uint64,some (.uint64 (word 1))))
    (slenCell : s.locals "slen".toList=some (.uint64,some (.uint64 (word 1))))
    (load : Load32 s.heap (primeField primes 1 .p) p1)
    (tail : KeygenMakeFgSource.Stmt) (out : Result) (rest : Exec tail (after s) out) :
    Exec (MakeFgSequence187.append MakeFgAddPrimeShape194.prefixSteps tail) s out :=
  MakeFgSequence187.source [MakeFgAddPrimeShape194.declP,MakeFgAddPrimeShape194.declV,
      MakeFgAddPrimeShape194.declX] s (withX s) (decls_run s)
    (.seq MakeFgAddPrimeShape194.pSet (.seq MakeFgAddPrimeShape194.iSet
      (.seq MakeFgAddPrimeShape194.rSet (.seq MakeFgAddPrimeShape194.rxSet tail)))) out
    (.seqNormal _ _ (withX s) (withP s) out (p_source s bind uCell load)
      (.seqNormal _ _ (withP s) (withI s) out (i_source s)
        (.seqNormal _ _ (withI s) (withR s) out (r_source s)
          (.seqNormal _ _ (withR s) (after s) out (rx_source s slenCell) rest))))

theorem skip_run (s : State) : Exec KeygenMakeFgSource.skip s ⟨s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _)))

theorem prefix_source (s : State) (bind : s.arrays "primes".toList=some primes)
    (uCell : s.locals "u".toList=some (.uint64,some (.uint64 (word 1))))
    (slenCell : s.locals "slen".toList=some (.uint64,some (.uint64 (word 1))))
    (load : Load32 s.heap (primeField primes 1 .p) p1) :
    Exec (MakeFgSequence187.append MakeFgAddPrimeShape194.prefixSteps KeygenMakeFgSource.skip)
      s ⟨after s,.normal⟩ :=
  append_source s bind uCell slenCell load KeygenMakeFgSource.skip ⟨after s,.normal⟩
    (skip_run (after s))

theorem continue_inner (s : State) (bind : s.arrays "primes".toList=some primes)
    (uCell : s.locals "u".toList=some (.uint64,some (.uint64 (word 1))))
    (slenCell : s.locals "slen".toList=some (.uint64,some (.uint64 (word 1))))
    (load : Load32 s.heap (primeField primes 1 .p) p1)
    (out : Result) (rest : Exec MakeFgAddPrimeShape194.remaining (after s) out) :
    Exec MakeFgAddPrimeShape194.aInner s out := by
  rw [MakeFgAddPrimeShape194.prefix_shape]
  exact append_source s bind uCell slenCell load MakeFgAddPrimeShape194.remaining out rest

/- Result-state cells: the four words of the executed prefix. -/
theorem p_cell (s : State) : KeygenModpR2Exec.Slot (after s) "p" p1 := after_p s
theorem i_cell (s : State) : KeygenModpR2Exec.Slot (after s) "p0i" p0i1 := after_i s
theorem r2_cell (s : State) : KeygenModpR2Exec.Slot (after s) "R2" r21 := after_r s
theorem rx_cell (s : State) : KeygenModpR2Exec.Slot (after s) "Rx" rx1 := after_rx s

/- The loop head of part 4 at an exit state: u = slen (slen = 1), the
   u < tlen guard true at tlen = 2, and the prefix at the resulting
   loop-body entry state u1. The exit-state cells and the row-1 load
   are hypotheses (see the scope note above). -/
def u1 (exit : State) : State := bindValue exit "u".toList .uint64 (.uint64 (word 1))

theorem u_one : C99IntegerReference.convert .uint64 (Value.uint64 (word 1)).integer=.uint64 (word 1) :=
  by decide

theorem u1_cell (exit : State) : (u1 exit).locals "u".toList=some (.uint64,some (.uint64 (word 1))) :=
  (bind_locals_same exit "u".toList .uint64 (.uint64 (word 1))).trans
    (cell_pair _ _ _ u_one)

theorem u1_slen (exit : State)
    (slenCell : exit.locals "slen".toList=some (.uint64,some (.uint64 (word 1)))) :
    (u1 exit).locals "slen".toList=some (.uint64,some (.uint64 (word 1))) :=
  (locals_keep exit "u".toList .uint64 (.uint64 (word 1)) "slen".toList (by decide)).trans slenCell

theorem u1_arrays (exit : State) (name : Name) : (u1 exit).arrays name=exit.arrays name := rfl
theorem u1_heap (exit : State) : (u1 exit).heap=exit.heap := rfl

theorem init_source (exit : State) (old : Option Value)
    (uCell : exit.locals "u".toList=some (.uint64,old))
    (slenCell : exit.locals "slen".toList=some (.uint64,some (.uint64 (word 1)))) :
    Exec MakeFgAddPrimeShape194.initU exit ⟨u1 exit,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign "u".toList (.scalar (MakeFgAddPrimeShape194.var "slen"))
    exit .uint64 old (.uint64 (word 1)) uCell
    (.scalar _ _ (C99ScalarReference.Eval.variable "slen".toList .uint64 (.uint64 (word 1)) slenCell))))

theorem guard1 (exit : State) (tlenCell : Cell exit "tlen".toList 2) :
    C99ArrayReference.scalar (u1 exit) (.cmp .lt MakeFgAddPrimeShape194.varU
      MakeFgAddPrimeShape194.varTlen) (.int32 1) :=
  C99ScalarReference.Eval.compare .lt _ _ (.uint64 (word 1)) (.uint64 (word 2)) (.int32 1)
    (C99ScalarReference.Eval.variable "u".toList .uint64 (.uint64 (word 1)) (u1_cell exit))
    (C99ScalarReference.Eval.variable "tlen".toList .uint64 (.uint64 (word 2))
      ((locals_keep exit "u".toList .uint64 (.uint64 (word 1)) "tlen".toList (by decide)).trans
        tlenCell))
    (C99IntegerReference.CompareExec.step .lt (.uint64 (word 1)) (.uint64 (word 2)) .uint64 rfl
      (.uint64 (word 1)) (.uint64 (word 2)) rfl rfl)

/- The composed export at the loop-body scope entry u = 1: the loop head
   and the seven-statement prefix on the exit state, with the words and
   the continuation of the loop body. -/
theorem body_entry (exit : State) (old : Option Value)
    (uCell : exit.locals "u".toList=some (.uint64,old))
    (slenCell : Cell exit "slen".toList 1) (tlenCell : Cell exit "tlen".toList 2)
    (bind : exit.arrays "primes".toList=some primes)
    (load : Load32 exit.heap (primeField primes 1 .p) p1) :
    Exec MakeFgAddPrimeShape194.initU exit ⟨u1 exit,.normal⟩ ∧
    C99ArrayReference.scalar (u1 exit) (.cmp .lt MakeFgAddPrimeShape194.varU
      MakeFgAddPrimeShape194.varTlen) (.int32 1) ∧
    Exec (MakeFgSequence187.append MakeFgAddPrimeShape194.prefixSteps KeygenMakeFgSource.skip)
      (u1 exit) ⟨after (u1 exit),.normal⟩ ∧
    (∀ out, Exec MakeFgAddPrimeShape194.remaining (after (u1 exit)) out →
      Exec MakeFgAddPrimeShape194.aInner (u1 exit) out) ∧
    KeygenModpR2Exec.Slot (after (u1 exit)) "p" p1 ∧
    KeygenModpR2Exec.Slot (after (u1 exit)) "p0i" p0i1 ∧
    KeygenModpR2Exec.Slot (after (u1 exit)) "R2" r21 ∧
    KeygenModpR2Exec.Slot (after (u1 exit)) "Rx" rx1 ∧
    (after (u1 exit)).heap=exit.heap := by
  have bind1 : (u1 exit).arrays "primes".toList=some primes :=
    (u1_arrays exit "primes".toList).trans bind
  have u1U : (u1 exit).locals "u".toList=some (.uint64,some (.uint64 (word 1))) := u1_cell exit
  have u1Slen : (u1 exit).locals "slen".toList=some (.uint64,some (.uint64 (word 1))) :=
    u1_slen exit slenCell
  have u1Load : Load32 (u1 exit).heap (primeField primes 1 .p) p1 := by
    rw [u1_heap]; exact load
  exact ⟨init_source exit old uCell slenCell,guard1 exit tlenCell,
    prefix_source (u1 exit) bind1 u1U u1Slen u1Load,
    fun out rest => continue_inner (u1 exit) bind1 u1U u1Slen u1Load out rest,
    p_cell _,i_cell _,r2_cell _,rx_cell _,after_heap _⟩

end FT1536.Source3.SelectedStepAddPrime195
