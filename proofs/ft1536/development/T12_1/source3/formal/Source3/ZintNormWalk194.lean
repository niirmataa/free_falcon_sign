import Source3.ZintNormWord194
import Source3.MakeFgCrtShape194
import Source3.C99NatWord141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The 512-step normalize loop of the zint_rebuild_CRT normalize branch
   (first half of obligation (c) of the CRT route): the walk loop

     for (u = 0, x = xx; u < num; u ++, x += xstride)
         zint_norm_zero(x, tmp, xlen);

   at the selected instance num = 512, xstride = xlen = 1. Each iteration
   is exactly one ZintNormWord194.norm_call at the walked word with the
   SAME p0 = tmp[0] (the call writes only the walked x[0] cell, so the
   tmp word and every pending walk word survive each earlier step). The
   induction threads the executed-word writes through Word32Memory176
   keeps over the walk; the exported image is

     fun i => normWord p0 (words i)

   loaded at the walk cells after the loop, with the heap keeps outside
   the walk region (the twin fs/gs walks are instantiations of that keep
   at the 512-word separation).

   The loop statement pieces are projections of the pinned parse record
   (probe job 510) through MakeFgCrtShape194.crtNormalize, re-bound here
   by decide; no new parse recognition is performed. Values stay
   executed words: no transform property, table law, root law or
   positivity claim is made here. -/
namespace FT1536.Source3.ZintNormWalk194
open C99ArrayReference (State Name Pointer bindValue bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32 Memory)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open ZintNormWord194 (normWord normImage consumerArgs)
open ZintSubWord194 (subWord)
open C99NatWord141 (word)

/- The walked cell pointer (the StepCopyBody190.elem shape). -/
def elem (base : ArrayPointer) (i : Nat) : ArrayPointer := {base with index := base.index+i}

/- Names of the zint_rebuild_CRT walk frame. -/
def uName : Name := "u".toList
def numName : Name := "num".toList
def xlenName : Name := "xlen".toList
def xstrideName : Name := "xstride".toList
def xName : Name := "x".toList
def tmpName : Name := "tmp".toList

/- Statement pieces of the pinned normalize walk. -/
def wskip : KeygenZintCall.Stmt := .word (.modular (.base .skip))
def wordScalar (s : CLogic.Stmt) : KeygenZintCall.Stmt := .word (.modular (.base (.scalar s)))
def wordArray (s : C99ArrayReference.Stmt) : KeygenZintCall.Stmt := .word (.modular (.base s))

def walkGuard : KeygenWordExpr.Expr := .cmp .lt (.scalar (.var uName)) (.scalar (.var numName))
def walkCall : KeygenZintCall.Stmt := .call .normZero consumerArgs .discard
def walkBody : KeygenZintCall.Stmt := .scope [] [] (.seq walkCall wskip)
def walkIncU : KeygenZintCall.Stmt := wordScalar (.update uName .add (.literal .i32 1))
def walkIncX : KeygenZintCall.Stmt := wordArray (.bindPtr xName xName (.var xstrideName))
def walkInc : KeygenZintCall.Stmt := .seq walkIncU walkIncX
def walkLoop : KeygenZintCall.Stmt := .loop walkGuard walkBody walkInc

/- Projections of the pinned normalize branch (decide-bound, no parse). -/
def normWrap : KeygenZintCall.Stmt := MakeFgCrtShape194.crtNormalize
def normBranch : KeygenZintCall.Stmt := match normWrap with | .seq a _ => a | _ => wskip
def normTail : KeygenZintCall.Stmt := match normWrap with | .seq _ b => b | _ => wskip
theorem norm_split : normWrap=.seq normBranch normTail := by decide

def normTest : KeygenWordExpr.Expr :=
  match normBranch with | .branch c _ _ => c | _ => .scalar (.literal .i32 0)
def normYes : KeygenZintCall.Stmt := match normBranch with | .branch _ y _ => y | _ => wskip
def normNo : KeygenZintCall.Stmt := match normBranch with | .branch _ _ n => n | _ => wskip
theorem norm_branch : normBranch=.branch normTest normYes normNo := by decide

def normWalk : KeygenZintCall.Stmt := match normYes with | .scope _ _ b => b | _ => wskip
theorem norm_scope : normYes=.scope [] [] normWalk := by decide

def normP1 : KeygenZintCall.Stmt := match normWalk with | .seq a _ => a | _ => wskip
def normP2 : KeygenZintCall.Stmt := match normWalk with | .seq _ b => b | _ => wskip
theorem norm_walk_split : normWalk=.seq normP1 normP2 := by decide

def normInit : KeygenZintCall.Stmt := match normP1 with | .seq a _ => a | _ => wskip
def normLoopPart : KeygenZintCall.Stmt := match normP1 with | .seq _ b => b | _ => wskip
theorem norm_p1_split : normP1=.seq normInit normLoopPart := by decide

def normUZero : KeygenZintCall.Stmt := match normInit with | .seq a _ => a | _ => wskip
def normXInit : KeygenZintCall.Stmt := match normInit with | .seq _ b => b | _ => wskip
theorem norm_init_split : normInit=.seq normUZero normXInit := by decide

theorem norm_uzero : normUZero=.word (.assign uName (.scalar (.literal .i32 0))) := by decide
theorem norm_xinit :
    normXInit=wordArray (.bindPtr xName "xx".toList C99ProcedureParser.zero) := by decide
theorem norm_loop : normLoopPart=walkLoop := by decide
theorem norm_p2_skip : normP2=wskip := by decide

/- Executed-word image of the walk prefix. -/
def stepImage (h : Memory) (p : ArrayPointer) (p0 x : BitVec 32) : Memory :=
  if (p0>>>1).toNat<x.toNat then Word32Memory176.write h p (subWord x p0) else h

theorem stepImage_normImage (entry : State) (px : ArrayPointer) (p0 x : BitVec 32) :
    normImage entry px p0 x = stepImage entry.heap px p0 x := rfl

def walkImage (h : Memory) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32) :
    Nat -> Memory
  | 0 => h
  | k+1 => stepImage (walkImage h px p0 words k) (elem px k) p0 (words k)

theorem walkImage_succ (h : Memory) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (k : Nat) : walkImage h px p0 words (k+1)
      = stepImage (walkImage h px p0 words k) (elem px k) p0 (words k) := rfl

theorem write_size (h : Memory) (p : ArrayPointer) (w : BitVec 32) :
    (Word32Memory176.write h p w).size=h.size := rfl
theorem write_writable (h : Memory) (p : ArrayPointer) (w : BitVec 32) :
    (Word32Memory176.write h p w).writable=h.writable := rfl

theorem stepImage_size (h : Memory) (p : ArrayPointer) (p0 x : BitVec 32) :
    (stepImage h p p0 x).size=h.size := by
  unfold stepImage
  split_ifs
  · exact write_size h p (subWord x p0)
  · rfl

theorem stepImage_writable (h : Memory) (p : ArrayPointer) (p0 x : BitVec 32) :
    (stepImage h p p0 x).writable=h.writable := by
  unfold stepImage
  split_ifs
  · exact write_writable h p (subWord x p0)
  · rfl

theorem walkImage_size (h : Memory) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (k : Nat) : (walkImage h px p0 words k).size=h.size := by
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [walkImage_succ,stepImage_size]
    exact ih

theorem walkImage_writable (h : Memory) (px : ArrayPointer) (p0 : BitVec 32)
    (words : Nat -> BitVec 32) (k : Nat) :
    (walkImage h px p0 words k).writable=h.writable := by
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [walkImage_succ,stepImage_writable]
    exact ih

theorem load_alloc {h : Memory} {q : ArrayPointer} {w : BitVec 32} (read : Load32 h q w) :
    Allocated h q := by
  cases read with
  | load b allocated width init => exact allocated

theorem elem_width (px : ArrayPointer) (i : Nat) : (elem px i).elementBytes=px.elementBytes := rfl
theorem elem_block (px : ArrayPointer) (i : Nat) : (elem px i).block=px.block := rfl

theorem elem_separate (px : ArrayPointer) (width : px.elementBytes=4) (i j : Nat)
    (different : i≠j) : Word32Memory176.Separate (elem px i) (elem px j) := by
  unfold Word32Memory176.Separate elem C99MemoryReference.ArrayPointer.offset
  rw [width]
  change px.block≠px.block ∨ px.base+4*(px.index+i)+4≤px.base+4*(px.index+j) ∨
    px.base+4*(px.index+j)+4≤px.base+4*(px.index+i)
  omega

/- Load keeps of the walk image. -/
theorem walkImage_pending {h : Memory} (px : ArrayPointer) (width : px.elementBytes=4)
    (p0 : BitVec 32) (words : Nat -> BitVec 32) :
    ∀ (k : Nat) (j : Nat), k ≤ j → Load32 h (elem px j) (words j) →
      Load32 (walkImage h px p0 words k) (elem px j) (words j) := by
  intro k
  induction k with
  | zero => intro j _ load; exact load
  | succ k ih =>
    intro j kj load
    have kept := ih j (by omega) load
    rw [walkImage_succ]
    unfold stepImage
    split_ifs
    · exact Word32Memory176.outside _ (elem px k) (elem px j) _ _
        (elem_separate px width k j (by omega)) kept
    · exact kept

theorem walkImage_keep {h : Memory} (px : ArrayPointer)
    (p0 : BitVec 32) (words : Nat -> BitVec 32) :
    ∀ (k : Nat) (q : ArrayPointer) (w : BitVec 32),
      (∀ i, i < k → Word32Memory176.Separate (elem px i) q) →
      Load32 h q w → Load32 (walkImage h px p0 words k) q w := by
  intro k
  induction k with
  | zero => intro q w _ load; exact load
  | succ k ih =>
    intro q w separate load
    have kept := ih q w (fun i bound => separate i (by omega)) load
    rw [walkImage_succ]
    unfold stepImage
    split_ifs
    · exact Word32Memory176.outside _ (elem px k) q _ _ (separate k (by omega)) kept
    · exact kept

theorem normWord_left (p0 x : BitVec 32) (lt : ¬x.toNat<p0.toNat>>>1) (gt : p0.toNat>>>1<x.toNat) :
    normWord p0 x = subWord x p0 := by
  simp [normWord,lt,gt]

theorem normWord_right (p0 x : BitVec 32) (gt : ¬p0.toNat>>>1<x.toNat) :
    normWord p0 x = x := by
  simp [normWord,gt]

theorem walkImage_written (h : Memory) (px : ArrayPointer) (width : px.elementBytes=4)
    (p0 : BitVec 32) (words : Nat -> BitVec 32) (k : Nat)
    (pending : Load32 (walkImage h px p0 words k) (elem px k) (words k))
    (writable : (walkImage h px p0 words k).writable px.block=true) :
    Load32 (walkImage h px p0 words (k+1)) (elem px k) (normWord p0 (words k)) := by
  rw [walkImage_succ]
  unfold stepImage
  split_ifs with c
  · have allocated : Allocated (walkImage h px p0 words k) (elem px k) := load_alloc pending
    have here : Load32 (Word32Memory176.write (walkImage h px p0 words k) (elem px k)
        (subWord (words k) p0)) (elem px k) (subWord (words k) p0) :=
      Word32Memory176.here (walkImage h px p0 words k) (elem px k) (subWord (words k) p0)
        allocated ((elem_width px k).trans width) writable
    have ltF : ¬(words k).toNat<(p0>>>1).toNat := by omega
    have norm : normWord p0 (words k)=subWord (words k) p0 :=
      normWord_left p0 (words k) (by simpa [BitVec.toNat_ushiftRight] using ltF)
        (by simpa [BitVec.toNat_ushiftRight] using c)
    rw [norm]
    exact here
  · have norm : normWord p0 (words k)=words k :=
      normWord_right p0 (words k) (by simpa [BitVec.toNat_ushiftRight] using c)
    rw [norm]
    exact pending

theorem walkImage_cells (h : Memory) (px : ArrayPointer) (width : px.elementBytes=4)
    (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (loads : ∀ j, j < 512 → Load32 h (elem px j) (words j))
    (writable : h.writable px.block=true) :
    ∀ (K : Nat), K ≤ 512 →
      ((∀ i, i < K → Load32 (walkImage h px p0 words K) (elem px i) (normWord p0 (words i)))
      ∧ (∀ i, (K ≤ i) → (i < 512) → Load32 (walkImage h px p0 words K) (elem px i) (words i))) := by
  intro K
  induction K with
  | zero =>
    intro _
    refine And.intro ?_ ?_
    · intro i bound
      exact False.elim (by omega)
    · intro i _ bound
      exact loads i bound
  | succ K ih =>
    intro bound
    have Kbound : K ≤ 512 := by omega
    obtain ⟨written,pending⟩ := ih Kbound
    refine And.intro ?_ ?_
    · intro i ibound
      by_cases same : i=K
      · subst same
        rw [walkImage_succ]
        have pendingK : Load32 (walkImage h px p0 words i) (elem px i) (words i) :=
          pending i (by omega) (by omega)
        exact walkImage_written h px width p0 words i pendingK
          (by rw [walkImage_writable]; exact writable)
      · have kept := written i (by omega)
        rw [walkImage_succ]
        unfold stepImage
        split_ifs
        · exact Word32Memory176.outside _ (elem px K) (elem px i) _ _
            (elem_separate px width K i (by omega)) kept
        · exact kept
    · intro i ki boundI
      have kept := pending i (by omega) boundI
      rw [walkImage_succ]
      unfold stepImage
      split_ifs
      · exact Word32Memory176.outside _ (elem px K) (elem px i) _ _
          (elem_separate px width K i (by omega)) kept
      · exact kept

/- The walk states: the recursion mirrors exactly one loop iteration. -/
def walkState (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32) :
    Nat -> State
  | 0 => s0
  | k+1 => bindPointer
      (bindValue {walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)}
        uName .uint64 (.uint64 (word (k+1))))
      xName (elem px (k+1))

theorem walkState_succ (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (k : Nat) : walkState s0 px p0 words (k+1) =
      bindPointer
        (bindValue {walkState s0 px p0 words k with
          heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)}
          uName .uint64 (.uint64 (word (k+1))))
        xName (elem px (k+1)) := rfl

theorem walkState_heap (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (k : Nat) : (walkState s0 px p0 words k).heap=walkImage s0.heap px p0 words k := by
  induction k with
  | zero => rfl
  | succ k ih =>
    show stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)=_
    rw [ih]
    exact (walkImage_succ s0.heap px p0 words k).symm

theorem convert_word (n : Nat) (bound : n<2^64) :
    C99IntegerReference.convert .uint64 (Value.uint64 (word n)).integer=.uint64 (word n) := by
  show Value.uint64 (BitVec.ofInt 64 ((Value.uint64 (word n)).integer))=Value.uint64 (word n)
  simp only [C99IntegerReference.Value.integer]
  rw [C99NatWord141.to_nat n bound,BitVec.ofInt_natCast]
  rfl

theorem bindPointer_self (s : State) (name : Name) (p : ArrayPointer) :
    (bindPointer s name p).arrays name=some p := by
  simp [bindPointer]

theorem bindPointer_other (s : State) (name other : Name) (p : ArrayPointer)
    (different : other≠name) : (bindPointer s name p).arrays other=s.arrays other := by
  simp [bindPointer,different]

theorem bindPointer_locals (s : State) (name : Name) (p : ArrayPointer) (n : Name) :
    (bindPointer s name p).locals n=s.locals n := rfl

/- Cell facts of the walk states. -/
theorem walkState_u (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (u0 : s0.locals uName=some (.uint64,some (.uint64 (word 0)))) :
    ∀ k, k < 2^64 → (walkState s0 px p0 words k).locals uName=some (.uint64,some (.uint64 (word k))) := by
  intro k
  induction k with
  | zero => intro _; exact u0
  | succ k ih =>
    intro bound
    rw [walkState_succ,bindPointer_locals]
    rw [ZintSubWord194.bind_cell]
    rw [convert_word (k+1) (by omega)]

theorem walkState_x (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (x0 : s0.arrays xName=some (elem px 0)) :
    ∀ k, (walkState s0 px p0 words k).arrays xName=some (elem px k) := by
  intro k
  induction k with
  | zero => exact x0
  | succ k _ =>
    rw [walkState_succ,bindPointer_self]

theorem walkState_local_keep (s0 : State) (px : ArrayPointer) (p0 : BitVec 32)
    (words : Nat -> BitVec 32) (name : Name) (different : name≠uName) :
    ∀ k, (walkState s0 px p0 words k).locals name=s0.locals name := by
  intro k
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [walkState_succ,bindPointer_locals]
    rw [ZintSubWord194.bind_other _ uName name .uint64 (.uint64 (word (k+1))) different]
    exact ih

theorem walkState_array_keep (s0 : State) (px : ArrayPointer) (p0 : BitVec 32)
    (words : Nat -> BitVec 32) (name : Name) (different : name≠xName) :
    ∀ k, (walkState s0 px p0 words k).arrays name=s0.arrays name := by
  intro k
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [walkState_succ]
    rw [bindPointer_other _ xName name (elem px (k+1)) different]
    exact ih

/- Branch-guard boolean facts at the walk counter. -/
theorem walk_bool_nonzero (k : Nat) (h : k<512) :
    (C99ScalarReference.boolean (decide (k<512))).integer≠0 := by
  have e : (decide (k<512))=true := by simp [h]
  rw [e]
  show (C99ScalarReference.boolean true).integer≠0
  simp only [C99ScalarReference.boolean,C99IntegerReference.Value.integer]
  decide

theorem walk_bool_zero :
    (C99ScalarReference.boolean (decide (512<512))).integer=0 := by
  simp only [C99ScalarReference.boolean,C99IntegerReference.Value.integer]
  decide

theorem walk_guard (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (k : Nat) (bound : k<2^64)
    (uCell : (walkState s0 px p0 words k).locals uName=some (.uint64,some (.uint64 (word k))))
    (numCell : (walkState s0 px p0 words k).locals numName=some (.uint64,some (.uint64 (word 512)))) :
    KeygenWordExpr.Eval (walkState s0 px p0 words k) walkGuard
      (C99ScalarReference.boolean (decide (k<512))) :=
  KeygenWordExpr.Eval.cmp .lt (.scalar (.var uName)) (.scalar (.var numName))
    (.uint64 (word k)) (.uint64 (word 512)) (C99ScalarReference.boolean (decide (k<512)))
    (KeygenWordExpr.Eval.scalar (.var uName) (.uint64 (word k))
      (C99ScalarReference.Eval.variable uName .uint64 (.uint64 (word k)) uCell))
    (KeygenWordExpr.Eval.scalar (.var numName) (.uint64 (word 512))
      (C99ScalarReference.Eval.variable numName .uint64 (.uint64 (word 512)) numCell))
    (C99NatWord141.less k 512 bound (by decide))

theorem walk_guard_end (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (uCell : (walkState s0 px p0 words 512).locals uName=some (.uint64,some (.uint64 (word 512))))
    (numCell : (walkState s0 px p0 words 512).locals numName=
      some (.uint64,some (.uint64 (word 512)))) :
    KeygenWordExpr.Eval (walkState s0 px p0 words 512) walkGuard
      (C99ScalarReference.boolean (decide (512<512))) :=
  KeygenWordExpr.Eval.cmp .lt (.scalar (.var uName)) (.scalar (.var numName))
    (.uint64 (word 512)) (.uint64 (word 512)) (C99ScalarReference.boolean (decide (512<512)))
    (KeygenWordExpr.Eval.scalar (.var uName) (.uint64 (word 512))
      (C99ScalarReference.Eval.variable uName .uint64 (.uint64 (word 512)) uCell))
    (KeygenWordExpr.Eval.scalar (.var numName) (.uint64 (word 512))
      (C99ScalarReference.Eval.variable numName .uint64 (.uint64 (word 512)) numCell))
    (C99NatWord141.less 512 512 (by decide) (by decide))

/- One iteration: the call step at the walked word. -/
theorem call_exec (before : State) (px pp : ArrayPointer) (xw pw : BitVec 32)
    (xa : before.arrays "x".toList=some px) (xb : before.arrays "tmp".toList=some pp)
    (lv : before.locals "xlen".toList=some (.uint64,some (.uint64 1#64)))
    (xread : Load32 before.heap px xw) (pread : Load32 before.heap pp pw)
    (allocX : Allocated before.heap px) (widthX : px.elementBytes=4)
    (writableX : before.heap.writable px.block=true)
    (xbound : px.index+0≤px.count) (pbound : pp.index+0≤pp.count) :
    KeygenZintCall.Exec walkCall before
      ⟨{before with heap := normImage before px pw xw},.normal⟩ := by
  obtain ⟨entry,out,binding,run,returned,stateEq⟩ :=
    ZintNormWord194.norm_call before px pp xw pw xa xb lv xread pread allocX widthX writableX
      xbound pbound
  have step : KeygenZintCall.Exec walkCall before
      ⟨{before with heap := out.state.heap},.normal⟩ :=
    KeygenZintCall.Exec.call before .normZero consumerArgs .discard entry out none
      ({before with heap := out.state.heap}) binding run returned
      (KeygenZintCall.ReceiveC.discard _ _)
  rw [← stateEq] at step
  exact step

/- One iteration: the body scope and the increment. -/
theorem body_run (s0 : State) (px pp : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (k : Nat)
    (xCell : (walkState s0 px p0 words k).arrays xName=some (elem px k))
    (tCell : (walkState s0 px p0 words k).arrays tmpName=some pp)
    (lenCell : (walkState s0 px p0 words k).locals xlenName=some (.uint64,some (.uint64 (word 1))))
    (loadX : Load32 (walkState s0 px p0 words k).heap (elem px k) (words k))
    (loadT : Load32 (walkState s0 px p0 words k).heap pp p0)
    (widthX : px.elementBytes=4)
    (writableX : (walkState s0 px p0 words k).heap.writable px.block=true)
    (xcap : px.index+k+1≤px.count) (pcap : pp.index+0≤pp.count) :
    KeygenZintCall.Exec walkBody (walkState s0 px p0 words k)
      ⟨{walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)},.normal⟩ := by
  have xstep : (walkState s0 px p0 words k).arrays "x".toList=some (elem px k) := xCell
  have tstep : (walkState s0 px p0 words k).arrays "tmp".toList=some pp := tCell
  have callRun : KeygenZintCall.Exec walkCall (walkState s0 px p0 words k)
      ⟨{walkState s0 px p0 words k with
        heap := normImage (walkState s0 px p0 words k) (elem px k) p0 (words k)},.normal⟩ :=
    call_exec (walkState s0 px p0 words k) (elem px k) pp (words k) p0 xstep tstep lenCell loadX loadT
      (load_alloc loadX) ((elem_width px k).trans widthX) (by rw [elem_block]; exact writableX)
      (by show px.index+k+0≤px.count; omega) pcap
  have image : normImage (walkState s0 px p0 words k) (elem px k) p0 (words k)
      = stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k) := rfl
  have callRun' : KeygenZintCall.Exec walkCall (walkState s0 px p0 words k)
      ⟨{walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)},.normal⟩ := by
    rw [image] at callRun
    exact callRun
  have skipRun : KeygenZintCall.Exec wskip
      ({walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)})
      ⟨{walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)},.normal⟩ :=
    ZintNormWord194.word_skip _
  have seqRun : KeygenZintCall.Exec (.seq walkCall wskip) (walkState s0 px p0 words k)
      ⟨{walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)},.normal⟩ :=
    KeygenZintCall.Exec.seqNormal _ _ (walkState s0 px p0 words k)
      ({walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)})
      ⟨{walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)},.normal⟩
      callRun' skipRun
  exact KeygenZintCall.Exec.scope [] [] (.seq walkCall wskip) (walkState s0 px p0 words k)
    ⟨{walkState s0 px p0 words k with
      heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)},.normal⟩ seqRun

theorem incU_run (s : State) (i : Nat) (bound : i<2^64)
    (uCell : s.locals uName=some (.uint64,some (.uint64 (word i)))) :
    KeygenZintCall.Exec walkIncU s
      ⟨bindValue s uName .uint64 (.uint64 (word (i+1))),.normal⟩ := by
  refine ZintNormWord194.word_update s uName .add (.literal .i32 1) .uint64 (.uint64 (word i))
    (.int32 1#32) (.uint64 (word (i+1))) uCell (C99ScalarReference.Eval.literal .int32 1) ?_
  show C99OperatorBridge.Binary .add (.uint64 (word i)) (.int32 1#32) (.uint64 (word (i+1)))
  exact C99NatWord141.add_one i bound

theorem incX_run (s : State) (px : ArrayPointer) (i : Nat)
    (xCell : s.arrays xName=some (elem px i))
    (stride : s.locals xstrideName=some (.uint64,some (.uint64 (word 1))))
    (xcap : px.index+i+1≤px.count) :
    KeygenZintCall.Exec walkIncX s ⟨bindPointer s xName (elem px (i+1)),.normal⟩ := by
  have one_integer : (Value.uint64 (word 1)).integer=(1 : Int) := by
    simp [C99IntegerReference.Value.integer,C99NatWord141.word]
  have one_toNat : ((Value.uint64 (word 1)).integer).toNat=1 := by
    simp [C99IntegerReference.Value.integer,C99NatWord141.word]
  have within : C99MemoryReference.PointerAdd (elem px i)
      ((Value.uint64 (word 1)).integer).toNat (elem px (i+1)) := by
    rw [one_toNat]
    refine C99MemoryReference.PointerAdd.within (elem px i) 1 ?_
    show (elem px i).index+1≤(elem px i).count
    have count : (elem px i).count=px.count := rfl
    have index : (elem px i).index=px.index+i := rfl
    rw [count,index]
    exact xcap
  have address : Pointer s xName (.var xstrideName) (elem px (i+1)) :=
    Pointer.add xName (.var xstrideName) (elem px i) (elem px (i+1)) (.uint64 (word 1))
      xCell (C99ScalarReference.Eval.variable xstrideName .uint64 (.uint64 (word 1)) stride)
      (by rw [one_integer]; omega) within
  have arrayRun : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr xName xName (.var xstrideName)) s (bindPointer s xName (elem px (i+1))) :=
    C99ArrayReference.Exec.bindPtr s xName xName (.var xstrideName) (elem px (i+1)) address
  have modRun : KeygenWordExec.Exec (.modular (.base (.bindPtr xName xName (.var xstrideName))))
      s ⟨bindPointer s xName (elem px (i+1)),.normal⟩ :=
    KeygenWordExec.Exec.modular _ _ _
      (C99ModularReference.GenExec.base _ _ _ arrayRun)
  exact ZintNormWord194.word_run _ _ _ modRun

theorem inc_run (s0 : State) (px : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (k : Nat) (bound : k+1<2^64)
    (uCell : (walkState s0 px p0 words k).locals uName=some (.uint64,some (.uint64 (word k))))
    (xCell : (walkState s0 px p0 words k).arrays xName=some (elem px k))
    (stride : (walkState s0 px p0 words k).locals xstrideName=
      some (.uint64,some (.uint64 (word 1))))
    (xcap : px.index+k+1≤px.count) :
    KeygenZintCall.Exec walkInc
      ({walkState s0 px p0 words k with
        heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)})
      ⟨walkState s0 px p0 words (k+1),.normal⟩ := by
  set middle : State :=
    ({walkState s0 px p0 words k with
      heap := stepImage (walkState s0 px p0 words k).heap (elem px k) p0 (words k)}) with middleDef
  have middleU : middle.locals uName=some (.uint64,some (.uint64 (word k))) := by
    rw [middleDef]
    exact uCell
  have middleX : middle.arrays xName=some (elem px k) := by
    rw [middleDef]
    exact xCell
  have middleStride : middle.locals xstrideName=some (.uint64,some (.uint64 (word 1))) := by
    rw [middleDef]
    exact stride
  have headRun : KeygenZintCall.Exec walkIncU middle
      ⟨bindValue middle uName .uint64 (.uint64 (word (k+1))),.normal⟩ :=
    incU_run middle k (by omega) middleU
  have tailRun : KeygenZintCall.Exec walkIncX (bindValue middle uName .uint64 (.uint64 (word (k+1))))
      ⟨bindPointer (bindValue middle uName .uint64 (.uint64 (word (k+1)))) xName (elem px (k+1)),
        .normal⟩ := by
    refine incX_run (bindValue middle uName .uint64 (.uint64 (word (k+1)))) px k ?_ ?_ xcap
    · show (bindValue middle uName .uint64 (.uint64 (word (k+1)))).arrays xName=_
      exact middleX
    · show (bindValue middle uName .uint64 (.uint64 (word (k+1)))).locals xstrideName=_
      rw [ZintSubWord194.bind_other _ uName xstrideName .uint64 (.uint64 (word (k+1))) (by decide)]
      exact middleStride
  have seqRun : KeygenZintCall.Exec walkInc middle ⟨walkState s0 px p0 words (k+1),.normal⟩ := by
    refine KeygenZintCall.Exec.seqNormal walkIncU walkIncX middle
      (bindValue middle uName .uint64 (.uint64 (word (k+1))))
      ⟨walkState s0 px p0 words (k+1),.normal⟩ headRun ?_
    have same : bindPointer (bindValue middle uName .uint64 (.uint64 (word (k+1))))
        xName (elem px (k+1))=walkState s0 px p0 words (k+1) := by
      rw [middleDef]
      exact (walkState_succ s0 px p0 words k).symm
    rw [← same]
    exact tailRun
  exact seqRun

/- The 512-step loop run. -/
theorem walk_fuel (s0 : State) (px pp : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (width : px.elementBytes=4)
    (u0 : s0.locals uName=some (.uint64,some (.uint64 (word 0))))
    (x0 : s0.arrays xName=some (elem px 0))
    (t0 : s0.arrays tmpName=some pp)
    (len0 : s0.locals xlenName=some (.uint64,some (.uint64 (word 1))))
    (stride0 : s0.locals xstrideName=some (.uint64,some (.uint64 (word 1))))
    (num0 : s0.locals numName=some (.uint64,some (.uint64 (word 512))))
    (loads : ∀ j, j < 512 → Load32 s0.heap (elem px j) (words j))
    (loadT : Load32 s0.heap pp p0)
    (writable : s0.heap.writable px.block=true)
    (tsep : ∀ i, i < 512 → Word32Memory176.Separate (elem px i) pp)
    (xcap : px.index+512≤px.count) (pcap : pp.index+0≤pp.count) :
    ∀ fuel i, i+fuel=512 →
      KeygenZintCall.Exec walkLoop (walkState s0 px p0 words i)
        ⟨walkState s0 px p0 words 512,.normal⟩ := by
  have uCell : ∀ k, k < 2^64 →
      (walkState s0 px p0 words k).locals uName=some (.uint64,some (.uint64 (word k))) :=
    walkState_u s0 px p0 words u0
  have xCell : ∀ k, (walkState s0 px p0 words k).arrays xName=some (elem px k) :=
    walkState_x s0 px p0 words x0
  have tCell : ∀ k, (walkState s0 px p0 words k).arrays tmpName=some pp :=
    fun k => by
      rw [walkState_array_keep s0 px p0 words tmpName (by decide) k]
      exact t0
  have lenCell : ∀ k,
      (walkState s0 px p0 words k).locals xlenName=some (.uint64,some (.uint64 (word 1))) :=
    fun k => by
      rw [walkState_local_keep s0 px p0 words xlenName (by decide) k]
      exact len0
  have strideCell : ∀ k,
      (walkState s0 px p0 words k).locals xstrideName=some (.uint64,some (.uint64 (word 1))) :=
    fun k => by
      rw [walkState_local_keep s0 px p0 words xstrideName (by decide) k]
      exact stride0
  have numCell : ∀ k,
      (walkState s0 px p0 words k).locals numName=some (.uint64,some (.uint64 (word 512))) :=
    fun k => by
      rw [walkState_local_keep s0 px p0 words numName (by decide) k]
      exact num0
  have cellImage : ∀ K, K ≤ 512 →
      ((∀ i, i < K → Load32 (walkImage s0.heap px p0 words K) (elem px i) (normWord p0 (words i)))
      ∧ (∀ i, (K ≤ i) → (i < 512) → Load32 (walkImage s0.heap px p0 words K) (elem px i) (words i))) :=
    walkImage_cells s0.heap px width p0 words loads writable
  have pendingK : ∀ k, k < 512 →
      Load32 (walkImage s0.heap px p0 words k) (elem px k) (words k) := by
    intro k bound
    obtain ⟨_,pending⟩ := cellImage k (by omega)
    exact pending k (by omega) bound
  intro fuel
  induction fuel with
  | zero =>
    intro i sum
    have i512 : i=512 := by omega
    subst i512
    exact KeygenZintCall.Exec.loopFalse walkGuard walkBody walkInc
      (walkState s0 px p0 words 512) (C99ScalarReference.boolean (decide (512<512)))
      (walk_guard_end s0 px p0 words (uCell 512 (by omega)) (numCell 512)) walk_bool_zero
  | succ fuel ih =>
    intro i sum
    have ibound : i<512 := by omega
    have ilt : i<2^64 := by omega
    have guard : KeygenWordExpr.Eval (walkState s0 px p0 words i) walkGuard
        (C99ScalarReference.boolean (decide (i<512))) :=
      walk_guard s0 px p0 words i ilt (uCell i ilt) (numCell i)
    have heapI : (walkState s0 px p0 words i).heap=walkImage s0.heap px p0 words i :=
      walkState_heap s0 px p0 words i
    have loadX : Load32 (walkState s0 px p0 words i).heap (elem px i) (words i) := by
      rw [heapI]
      exact pendingK i (by omega)
    have loadTI : Load32 (walkState s0 px p0 words i).heap pp p0 := by
      rw [heapI]
      exact walkImage_keep px p0 words i pp p0 (fun j bound => tsep j (by omega)) loadT
    have writableI : (walkState s0 px p0 words i).heap.writable px.block=true := by
      rw [heapI,walkImage_writable]
      exact writable
    have bodyRun : KeygenZintCall.Exec walkBody (walkState s0 px p0 words i)
        ⟨{walkState s0 px p0 words i with
          heap := stepImage (walkState s0 px p0 words i).heap (elem px i) p0 (words i)},.normal⟩ :=
      body_run s0 px pp p0 words i (xCell i) (tCell i) (lenCell i) loadX loadTI width
        writableI (by omega) pcap
    have incRun : KeygenZintCall.Exec walkInc
        ({walkState s0 px p0 words i with
          heap := stepImage (walkState s0 px p0 words i).heap (elem px i) p0 (words i)})
        ⟨walkState s0 px p0 words (i+1),.normal⟩ :=
      inc_run s0 px p0 words i (by omega) (uCell i ilt) (xCell i) (strideCell i) (by omega)
    exact KeygenZintCall.Exec.loopNormal walkGuard walkBody walkInc (walkState s0 px p0 words i)
      ({walkState s0 px p0 words i with
        heap := stepImage (walkState s0 px p0 words i).heap (elem px i) p0 (words i)})
      (walkState s0 px p0 words (i+1)) ⟨walkState s0 px p0 words 512,.normal⟩
      (C99ScalarReference.boolean (decide (i<512))) guard (walk_bool_nonzero i ibound)
      bodyRun incRun (ih (i+1) (by omega))

/- Main export: the 512-step normalize loop run, the executed-word image
   over the walk and the keeps outside the walk region. -/
theorem walk_run (s0 : State) (px pp : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (width : px.elementBytes=4)
    (u0 : s0.locals uName=some (.uint64,some (.uint64 (word 0))))
    (x0 : s0.arrays xName=some (elem px 0))
    (t0 : s0.arrays tmpName=some pp)
    (len0 : s0.locals xlenName=some (.uint64,some (.uint64 (word 1))))
    (stride0 : s0.locals xstrideName=some (.uint64,some (.uint64 (word 1))))
    (num0 : s0.locals numName=some (.uint64,some (.uint64 (word 512))))
    (loads : ∀ j, j < 512 → Load32 s0.heap (elem px j) (words j))
    (loadT : Load32 s0.heap pp p0)
    (writable : s0.heap.writable px.block=true)
    (tsep : ∀ i, i < 512 → Word32Memory176.Separate (elem px i) pp)
    (xcap : px.index+512≤px.count) (pcap : pp.index+0≤pp.count) :
    KeygenZintCall.Exec walkLoop s0 ⟨walkState s0 px p0 words 512,.normal⟩ ∧
    (∀ i, i < 512 → Load32 (walkState s0 px p0 words 512).heap (elem px i) (normWord p0 (words i))) ∧
    (∀ (q : ArrayPointer) (w : BitVec 32),
      (∀ i, i < 512 → Word32Memory176.Separate (elem px i) q) →
      Load32 s0.heap q w → Load32 (walkState s0 px p0 words 512).heap q w) ∧
    (walkState s0 px p0 words 512).locals uName=some (.uint64,some (.uint64 (word 512))) ∧
    (walkState s0 px p0 words 512).arrays xName=some (elem px 512) := by
  have run := walk_fuel s0 px pp p0 words width u0 x0 t0 len0 stride0 num0 loads loadT writable
    tsep xcap pcap 512 0 (by omega)
  obtain ⟨written,_⟩ := walkImage_cells s0.heap px width p0 words loads writable 512 (by omega)
  have image : ∀ i, i < 512 →
      Load32 (walkState s0 px p0 words 512).heap (elem px i) (normWord p0 (words i)) := by
    intro i bound
    rw [walkState_heap s0 px p0 words 512]
    exact written i bound
  have keep : ∀ (q : ArrayPointer) (w : BitVec 32),
      (∀ i, i < 512 → Word32Memory176.Separate (elem px i) q) →
      Load32 s0.heap q w → Load32 (walkState s0 px p0 words 512).heap q w := by
    intro q w separate load
    rw [walkState_heap s0 px p0 words 512]
    exact walkImage_keep px p0 words 512 q w separate load
  exact ⟨run,image,keep,walkState_u s0 px p0 words u0 512 (by omega),
    walkState_x s0 px p0 words x0 512⟩

end FT1536.Source3.ZintNormWalk194
