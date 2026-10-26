import Source3.ZintMulWord205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintAddMulWord205
open C99ArrayReference (State Name Pointer restoreScope)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99ProcedureReference (Result)
open KeygenWordExec (Stmt Exec)
open KeygenWordExpr (Expr Eval)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64 Slot64 expr32 expr64)
open CrtWordOps205 (widen narrow)
open ZintMulWord205 (u cc z declU declCC cc0 u0 inc skip s1 s2 s3 s4)

abbrev x : Name := "x".toList
abbrev y : Name := "y".toList
abbrev len : Name := "len".toList
abbrev xw : Name := "xw".toList
abbrev yw : Name := "yw".toList

def wide (a b c : BitVec 32) := (widen b*widen c+widen a)+widen 0
 def low (a b c : BitVec 32) := narrow (wide a b c) &&& 2147483647
 def carry (a b c : BitVec 32) := narrow (wide a b c >>> 31)
 def next (p : ArrayPointer) : ArrayPointer := {p with index:=p.index+1}

def declXY : Stmt := .modular (.base (.scalar (.declare .u32 [xw,yw])))
 def declZ : Stmt := .modular (.base (.scalar (.declare .u64 [z])))
 def readX : Stmt := .assign xw (.load32 x (.var u))
 def readY : Stmt := .assign yw (.load32 y (.var u))
 def as64 (name : String) : Expr := .cast .uint64 (.scalar (.var name.toList))
 def rhs : Expr := .bin .add (.bin .add (.bin .mul (as64 "yw") (as64 "s")) (as64 "xw")) (as64 "cc")
 def setZ : Stmt := .assign z rhs
 def storeX : Stmt := .store x (.var u) ZintMulWord205.storeRhs
 def setCC : Stmt := .assign cc ZintMulWord205.carryRhs
 def inner : Stmt := .seq declXY (.seq declZ (.seq readX (.seq readY
  (.seq setZ (.seq storeX (.seq setCC skip))))))
 def scopedBody : Stmt := .scope [xw,yw,z] inner
 def guard : Expr := .cmp .lt (.scalar (.var u)) (.scalar (.var len))
 def loop : Stmt := .loop guard scopedBody inc
 def loopPart : Stmt := .seq u0 loop
 def tail : Stmt := .seq (.store x (.var len) (.scalar (.var cc))) skip
 def body : Stmt := .seq declU (.seq declCC (.seq cc0 (.seq loopPart tail)))

theorem shape : KeygenZintLeaves.code .addMul=body := by decide

def s5 (s : State) := C99DeclarationStatements.effect .u32 [xw,yw] (s4 s)
 def s6 (s : State) := C99DeclarationStatements.effect .u64 [z] (s5 s)
 def s7 (s : State) (a : BitVec 32) := set32 (s6 s) "xw" a
 def s8 (s : State) (a b : BitVec 32) := set32 (s7 s a) "yw" b
 def s9 (s : State) (a b c : BitVec 32) := set64 (s8 s a b) "z" (wide a b c)
 def s10 (s : State) (p : ArrayPointer) (a b c : BitVec 32) :=
  {s9 s a b c with heap:=Word32Memory176.write s.heap p (low a b c)}
 def s11 (s : State) (p : ArrayPointer) (a b c : BitVec 32) := set32 (s10 s p a b c) "cc" (carry a b c)
 def s12 (s : State) (p : ArrayPointer) (a b c : BitVec 32) := restoreScope (s4 s) (s11 s p a b c) [xw,yw,z] []
 def s13 (s : State) (p : ArrayPointer) (a b c : BitVec 32) := set64 (s12 s p a b c) "u" 1
 def finalHeap (s : State) (p : ArrayPointer) (a b c : BitVec 32) :=
  Word32Memory176.write (Word32Memory176.write s.heap p (low a b c)) (next p) (carry a b c)
 def s14 (s : State) (p : ArrayPointer) (a b c : BitVec 32) :=
  {s13 s p a b c with heap:=finalHeap s p a b c}

theorem before4 (s : State) (name : Name) (hu : name≠u) (hc : name≠cc) :
    (s4 s).locals name=s.locals name := by
  simp only [s4,s3,s2,s1,set32,set64,ModularAtoms178.set,C99ArrayReference.bindValue,
    C99ScalarReference.set,hu,hc,ite_false,C99DeclarationStatements.effect,C99DeclarationCells.declareCells]

theorem before6 (s : State) (name : Name) (hx : name≠xw) (hy : name≠yw) (hz : name≠z) :
    (s6 s).locals name=(s4 s).locals name := by
  simp only [s6,s5,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set,hx,hy,hz,ite_false]

theorem u6 (s : State) : Slot64 (s6 s) "u" 0 :=
  (before6 s u (by decide) (by decide) (by decide)).trans (ZintMulWord205.u4 s)

theorem cc6 (s : State) : Slot (s6 s) "cc" 0 :=
  (before6 s cc (by decide) (by decide) (by decide)).trans
    ((CrtState205.keep64 (s3 s) "u" "cc" 0 (by decide)).trans (CrtState205.cell32 _ _ _))

theorem source (s : State) (p q : ArrayPointer) (a b c : BitVec 32)
    (px : s.arrays x=some p) (qy : s.arrays y=some q)
    (len1 : Slot64 s "len" 1) (cs : Slot s "s" c)
    (readX0 : Load32 s.heap p a) (readY0 : Load32 s.heap q b)
    (cap : p.index+1 < p.count) (writable : s.heap.writable p.block=true) :
    ∃ out : Result, Exec (KeygenZintLeaves.code .addMul) s out ∧ out.flow=.normal ∧
      out.state.heap=finalHeap s p a b c := by
  obtain ⟨alloc,width⟩ : Allocated s.heap p ∧ p.elementBytes=4 := by
    cases readX0 with | load _ h w _ => exact ⟨h,w⟩
  have qbound : q.index+0 ≤ q.count := by
    cases readY0 with | load _ h _ _ => have b:=h.2.2.1; omega
  have pbound : p.index+0 ≤ p.count := by omega
  have tailBound : p.index+1 ≤ p.count := by omega
  have tailAlloc : Allocated s.heap (next p) := ⟨alloc.1,alloc.2.1,cap,alloc.2.2.2⟩
  have h1 : Exec declU s ⟨s1 s,.normal⟩ := ZintSubWord194.declare_run .u64 [u] s
  have h2 : Exec declCC (s1 s) ⟨s2 s,.normal⟩ := ZintSubWord194.declare_run .u32 [cc] (s1 s)
  have h3 : Exec cc0 (s2 s) ⟨s3 s,.normal⟩ := .assign _ _ _ .uint32 none (.int32 0)
    (ZintSubWord194.effect_one_cell .u32 cc (s1 s)) (WordAtoms205.literal _ 0)
  have ud : (s3 s).locals u=some (.uint64,none) := by
    change (set32 (s2 s) "cc" 0).locals u=_
    rw [CrtState205.keep32 _ "cc" "u" 0 (by decide)]
    unfold s2
    rw [ZintSubWord194.effect_one_other .u32 cc u (s1 s) (by decide)]
    exact ZintSubWord194.effect_one_cell .u64 u s
  have h4 : Exec u0 (s3 s) ⟨s4 s,.normal⟩ := .assign _ _ _ .uint64 none (.int32 0) ud (WordAtoms205.literal _ 0)
  have h5 : Exec declXY (s4 s) ⟨s5 s,.normal⟩ := ZintSubWord194.declare_run .u32 [xw,yw] (s4 s)
  have h6 : Exec declZ (s5 s) ⟨s6 s,.normal⟩ := ZintSubWord194.declare_run .u64 [z] (s5 s)
  have xd : (s6 s).locals xw=some (.uint32,none) := by
    simp only [s6,s5,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set]
    rfl
  have h7 : Exec readX (s6 s) ⟨s7 s a,.normal⟩ := WordAtoms205.assign32 _ "xw" none _ a xd
    (.load32 _ _ p a (.add _ _ p p (.uint64 0) px (.variable _ _ _ (u6 s)) (by decide) (.within p 0 pbound)) readX0)
  have yd : (s7 s a).locals yw=some (.uint32,none) := by
    rw [show (s7 s a).locals yw=(s6 s).locals yw from CrtState205.keep32 _ "xw" "yw" a (by decide)]
    simp only [s6,s5,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set]
    rfl
  have u7 : Slot64 (s7 s a) "u" 0 := (CrtState205.keep32 (s6 s) "xw" "u" a (by decide)).trans (u6 s)
  have h8 : Exec readY (s7 s a) ⟨s8 s a b,.normal⟩ := WordAtoms205.assign32 _ "yw" none _ b yd
    (.load32 _ _ q b (.add _ _ q q (.uint64 0) qy (.variable _ _ _ u7) (by decide) (.within q 0 qbound)) readY0)
  have a8 : Slot (s8 s a b) "xw" a := (CrtState205.keep32 (s7 s a) "yw" "xw" b (by decide)).trans (CrtState205.cell32 _ _ _)
  have b8 : Slot (s8 s a b) "yw" b := CrtState205.cell32 _ _ _
  have c6 : Slot (s6 s) "s" c := (before6 s "s".toList (by decide) (by decide) (by decide)).trans
    ((before4 s "s".toList (by decide) (by decide)).trans cs)
  have c8 : Slot (s8 s a b) "s" c := (CrtState205.keep32 (s7 s a) "yw" "s" b (by decide)).trans
    ((CrtState205.keep32 (s6 s) "xw" "s" a (by decide)).trans c6)
  have cc8 : Slot (s8 s a b) "cc" 0 := (CrtState205.keep32 (s7 s a) "yw" "cc" b (by decide)).trans
    ((CrtState205.keep32 (s6 s) "xw" "cc" a (by decide)).trans (cc6 s))
  have ze : Eval (s8 s a b) rhs (.uint64 (wide a b c)) :=
    .bin .add _ _ _ _ _ (.bin .add _ _ _ _ _
      (.bin .mul _ _ _ _ _ (WordAtoms205.widen _ _ b (expr32 _ "yw" b b8))
        (WordAtoms205.widen _ _ c (expr32 _ "s" c c8)) (CrtWordOps205.mul64 _ _))
      (WordAtoms205.widen _ _ a (expr32 _ "xw" a a8)) (CrtWordOps205.add64 _ _))
      (WordAtoms205.widen _ _ 0 (expr32 _ "cc" 0 cc8)) (CrtWordOps205.add64 _ _)
  have zd : (s8 s a b).locals z=some (.uint64,none) := by
    unfold s8
    rw [CrtState205.keep32 _ "yw" "z" b (by decide)]
    unfold s7
    rw [CrtState205.keep32 _ "xw" "z" a (by decide)]
    exact ZintSubWord194.effect_one_cell .u64 z (s5 s)
  have h9 : Exec setZ (s8 s a b) ⟨s9 s a b c,.normal⟩ := WordAtoms205.assign64 _ "z" none _ _ zd ze
  have z9 : Slot64 (s9 s a b c) "z" (wide a b c) := CrtState205.cell64 _ _ _
  have u8 : Slot64 (s8 s a b) "u" 0 := (CrtState205.keep32 (s7 s a) "yw" "u" b (by decide)).trans u7
  have u9 : Slot64 (s9 s a b c) "u" 0 := (CrtState205.keep64 (s8 s a b) "z" "u" (wide a b c) (by decide)).trans u8
  have h10 : Exec storeX (s9 s a b c) ⟨s10 s p a b c,.normal⟩ := .store _ _ _ _ _ p (.uint32 (low a b c))
    (.add _ _ p p (.uint64 0) px (.variable _ _ _ u9) (by decide) (.within p 0 pbound))
    (.bin .band _ _ _ _ _ (WordAtoms205.narrow _ _ _ (expr64 _ "z" _ z9))
      (WordAtoms205.literal _ 2147483647) (CrtWordOps205.mask31 _)) (by
      change C99MemoryReference.Store32 s.heap p (BitVec.ofInt 32 ((low a b c).toNat : Int)) _
      rw [ZintSubWord194.ofInt_word]
      exact Word32Memory176.source _ _ _ alloc width writable)
  have cc10 : Slot (s10 s p a b c) "cc" 0 :=
    (CrtState205.keep64 (s8 s a b) "z" "cc" (wide a b c) (by decide)).trans cc8
  have h11 : Exec setCC (s10 s p a b c) ⟨s11 s p a b c,.normal⟩ := WordAtoms205.assign32 _ "cc" _ _ _ cc10
    (WordAtoms205.narrow _ _ _ (.bin .shr _ _ _ _ _ (expr64 _ "z" _ z9)
      (WordAtoms205.literal _ 31) (CrtWordOps205.right64 (wide a b c) 31 (by decide))))
  have hs0 : Exec skip (s11 s p a b c) ⟨s11 s p a b c,.normal⟩ := ZintSubWord194.skip_run _
  have hi : Exec inner (s4 s) ⟨s11 s p a b c,.normal⟩ :=
    .seqNormal _ _ _ _ _ h5 (.seqNormal _ _ _ _ _ h6 (.seqNormal _ _ _ _ _ h7
      (.seqNormal _ _ _ _ _ h8 (.seqNormal _ _ _ _ _ h9 (.seqNormal _ _ _ _ _ h10 (.seqNormal _ _ _ _ _ h11 hs0))))))
  have hs : Exec scopedBody (s4 s) ⟨s12 s p a b c,.normal⟩ := .scope _ _ _ _ hi
  have framed:=WordControl205.frame scopedBody (s4 s) ⟨s12 s p a b c,.normal⟩ (by decide) hs
  have u12 : Slot64 (s12 s p a b c) "u" 0 := (framed.2 u (by decide)).trans (ZintMulWord205.u4 s)
  have len4 : Slot64 (s4 s) "len" 1 := (before4 s len (by decide) (by decide)).trans len1
  have len12 : Slot64 (s12 s p a b c) "len" 1 := (framed.2 len (by decide)).trans len4
  have hup : Exec inc (s12 s p a b c) ⟨s13 s p a b c,.normal⟩ := ZintSubWord194.update_run _ u .add _
    .uint64 (.uint64 0) (.int32 1) (.uint64 1) u12 (.literal .int32 1) ZintSubWord194.inc_one
  have u13 : Slot64 (s13 s p a b c) "u" 1 := CrtState205.cell64 _ _ _
  have len13 : Slot64 (s13 s p a b c) "len" 1 := (CrtState205.keep64 _ "u" "len" 1 (by decide)).trans len12
  have hrest : Exec loop (s13 s p a b c) ⟨s13 s p a b c,.normal⟩ :=
    .loopFalse _ _ _ _ (.int32 0) (WordAtoms205.guard11 _ "len" u13 len13) (by decide)
  have hl : Exec loop (s4 s) ⟨s13 s p a b c,.normal⟩ :=
    .loopNormal _ _ _ _ _ _ _ (.int32 1) (WordAtoms205.guard01 _ "len" (ZintMulWord205.u4 s) len4)
      (by decide) hs hup hrest
  have cc13 : Slot (s13 s p a b c) "cc" (carry a b c) := by
    unfold Slot s13
    rw [CrtState205.keep64 _ "u" "cc" 1 (by decide)]
    unfold s12
    rw [WordControl205.restored _ _ [xw,yw,z] cc (by decide)]
    exact CrtState205.cell32 _ _ _
  have ht0 : Exec (.store x (.var len) (.scalar (.var cc))) (s13 s p a b c) ⟨s14 s p a b c,.normal⟩ :=
    .store _ _ _ _ _ (next p) (.uint32 (carry a b c))
      (.add _ _ p (next p) (.uint64 1) px (.variable _ _ _ len13) (by decide) (.within p 1 tailBound))
      (expr32 _ "cc" _ cc13) (by
        change C99MemoryReference.Store32 (Word32Memory176.write s.heap p (low a b c)) (next p)
          (BitVec.ofInt 32 ((carry a b c).toNat : Int)) _
        rw [ZintSubWord194.ofInt_word]
        exact Word32Memory176.source _ _ _ tailAlloc width writable)
  have ht : Exec tail (s13 s p a b c) ⟨s14 s p a b c,.normal⟩ :=
    .seqNormal _ _ _ _ _ ht0 (ZintSubWord194.skip_run _)
  have full : Exec body s ⟨s14 s p a b c,.normal⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ h4 hl) ht)))
  exact ⟨_,by rw [shape]; exact full,rfl,rfl⟩

end FT1536.Source3.ZintAddMulWord205
