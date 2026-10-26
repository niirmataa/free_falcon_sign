import Source3.WordAtoms205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact executed-word image of zint_mul_small at mlen=1. The 64-bit
   multiply/add, truncation and 31-bit limb mask remain explicit. -/
namespace FT1536.Source3.ZintMulWord205
open C99ArrayReference (State Name Pointer bindValue restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ProcedureReference (Result)
open KeygenWordExec (Stmt Exec)
open KeygenWordExpr (Expr Eval)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64 Slot64 expr32 expr64)
open CrtWordOps205 (widen narrow)

abbrev u : Name := "u".toList
abbrev cc : Name := "cc".toList
abbrev z : Name := "z".toList
abbrev m : Name := "m".toList
abbrev x : Name := "x".toList
abbrev mlen : Name := "mlen".toList

def wide (a b : BitVec 32) := widen a*widen b+widen 0
 def low (a b : BitVec 32) := narrow (wide a b) &&& 2147483647
 def carry (a b : BitVec 32) := narrow (wide a b >>> 31)

def rhs : Expr := .bin .add (.bin .mul (.cast .uint64 (.load32 m (.var u)))
  (.cast .uint64 (.scalar (.var x)))) (.scalar (.var cc))
def storeRhs : Expr := .bin .band (.cast .uint32 (.scalar (.var z))) (.scalar (.literal .i32 2147483647))
def carryRhs : Expr := .cast .uint32 (.bin .shr (.scalar (.var z)) (.scalar (.literal .i32 31)))
def declU : Stmt := .modular (.base (.scalar (.declare .u64 [u])))
def declCC : Stmt := .modular (.base (.scalar (.declare .u32 [cc])))
def cc0 : Stmt := .assign cc (.scalar (.literal .i32 0))
def u0 : Stmt := .assign u (.scalar (.literal .i32 0))
def declZ : Stmt := .modular (.base (.scalar (.declare .u64 [z])))
def setZ : Stmt := .assign z rhs
 def storeM : Stmt := .store m (.var u) storeRhs
 def setCC : Stmt := .assign cc carryRhs
 def skip : Stmt := KeygenWordExec.skip
 def inner : Stmt := .seq declZ (.seq setZ (.seq storeM (.seq setCC skip)))
 def scopedBody : Stmt := .scope [z] inner
 def guard : Expr := .cmp .lt (.scalar (.var u)) (.scalar (.var mlen))
 def inc : Stmt := .modular (.base (.scalar (.update u .add (.literal .i32 1))))
 def loop : Stmt := .loop guard scopedBody inc
 def ret : Stmt := .ret (.scalar (.var cc))
 def tail : Stmt := .seq ret skip
 def loopPart : Stmt := .seq u0 loop
 def body : Stmt := .seq declU (.seq declCC (.seq cc0 (.seq loopPart tail)))

theorem shape : KeygenZintLeaves.code .mul=body := by decide

def s1 (s : State) := C99DeclarationStatements.effect .u64 [u] s
 def s2 (s : State) := C99DeclarationStatements.effect .u32 [cc] (s1 s)
 def s3 (s : State) := set32 (s2 s) "cc" 0
 def s4 (s : State) := set64 (s3 s) "u" 0
 def s5 (s : State) := C99DeclarationStatements.effect .u64 [z] (s4 s)
 def s6 (s : State) (a b : BitVec 32) := set64 (s5 s) "z" (wide a b)
 def s7 (s : State) (p : ArrayPointer) (a b : BitVec 32) :=
  {s6 s a b with heap:=Word32Memory176.write s.heap p (low a b)}
 def s8 (s : State) (p : ArrayPointer) (a b : BitVec 32) := set32 (s7 s p a b) "cc" (carry a b)
 def s9 (s : State) (p : ArrayPointer) (a b : BitVec 32) := restoreScope (s4 s) (s8 s p a b) [z] []
 def s10 (s : State) (p : ArrayPointer) (a b : BitVec 32) := set64 (s9 s p a b) "u" 1

theorem u4 (s : State) : Slot64 (s4 s) "u" 0 := CrtState205.cell64 _ _ _
theorem u5 (s : State) : Slot64 (s5 s) "u" 0 := by
  unfold Slot64 s5
  rw [ZintSubWord194.effect_one_other .u64 z u (s4 s) (by decide)]
  exact u4 s

theorem zero5 (s : State) : Slot (s5 s) "cc" 0 := by
  unfold Slot s5
  rw [ZintSubWord194.effect_one_other .u64 z cc (s4 s) (by decide)]
  exact (CrtState205.keep64 _ "u" "cc" 0 (by decide)).trans (CrtState205.cell32 _ _ _)

theorem before_cells (s : State) (b : BitVec 32) (xb : Slot s "x" b) (len : Slot64 s "mlen" 1) :
    Slot (s5 s) "x" b ∧ Slot64 (s4 s) "mlen" 1 ∧ Slot64 (s5 s) "mlen" 1 := by
  have keep (name : Name) (hu : name≠u) (hc : name≠cc) : (s4 s).locals name=s.locals name := by
    simp only [s4,s3,s2,s1,set32,set64,ModularAtoms178.set,bindValue,C99ScalarReference.set,hu,hc,
      ite_false,C99DeclarationStatements.effect,C99DeclarationCells.declareCells]
  have after5 (name : Name) (hz : name≠z) : (s5 s).locals name=(s4 s).locals name :=
    ZintSubWord194.effect_one_other .u64 z name (s4 s) hz
  have xx : (s5 s).locals x=s.locals x := (after5 x (by decide)).trans (keep x (by decide) (by decide))
  have ll : (s4 s).locals mlen=s.locals mlen := keep mlen (by decide) (by decide)
  exact ⟨xx.trans xb,ll.trans len,(after5 mlen (by decide)).trans (ll.trans len)⟩

theorem source (s : State) (p : ArrayPointer) (a b : BitVec 32)
    (binding : s.arrays m=some p) (xb : Slot s "x" b) (len : Slot64 s "mlen" 1)
    (read : Load32 s.heap p a) (writable : s.heap.writable p.block=true) :
    ∃ out : Result, Exec (KeygenZintLeaves.code .mul) s out ∧
      out.flow=.returned (some (.uint32 (carry a b))) ∧
      out.state.heap=Word32Memory176.write s.heap p (low a b) := by
  obtain ⟨alloc,width⟩ : Allocated s.heap p ∧ p.elementBytes=4 := by
    cases read with | load _ h w _ => exact ⟨h,w⟩
  have bound : p.index+0 ≤ p.count := by have h:=alloc.2.2.1; omega
  have cells:=before_cells s b xb len
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
  have h5 : Exec declZ (s4 s) ⟨s5 s,.normal⟩ := ZintSubWord194.declare_run .u64 [z] (s4 s)
  have address : Pointer (s5 s) m (.var u) p := .add _ _ p p (.uint64 0) binding
    (.variable _ _ _ (u5 s)) (by decide) (.within p 0 bound)
  have rhsEval : Eval (s5 s) rhs (.uint64 (wide a b)) := by
    refine .bin .add _ _ _ _ _ ?_ (expr32 _ "cc" 0 (zero5 s)) (CrtWordOps205.add64_32 _ 0)
    exact .bin .mul _ _ _ _ _ (WordAtoms205.widen _ _ a (.load32 _ _ p a address read))
      (WordAtoms205.widen _ _ b (expr32 _ "x" b cells.1)) (CrtWordOps205.mul64 _ _)
  have h6 : Exec setZ (s5 s) ⟨s6 s a b,.normal⟩ := WordAtoms205.assign64 _ "z" none _ _
    (ZintSubWord194.effect_one_cell .u64 z (s4 s)) rhsEval
  have z6 : Slot64 (s6 s a b) "z" (wide a b) := CrtState205.cell64 _ _ _
  have u6 : Slot64 (s6 s a b) "u" 0 := (CrtState205.keep64 _ "z" "u" _ (by decide)).trans (u5 s)
  have storeEval : Eval (s6 s a b) storeRhs (.uint32 (low a b)) :=
    .bin .band _ _ _ _ _ (WordAtoms205.narrow _ _ _ (expr64 _ "z" _ z6))
      (WordAtoms205.literal _ 2147483647) (CrtWordOps205.mask31 _)
  have h7 : Exec storeM (s6 s a b) ⟨s7 s p a b,.normal⟩ := .store _ _ _ _ _ p (.uint32 (low a b))
    (.add _ _ p p (.uint64 0) binding (.variable _ _ _ u6) (by decide) (.within p 0 bound))
    storeEval (by
      change C99MemoryReference.Store32 s.heap p (BitVec.ofInt 32 ((low a b).toNat : Int)) _
      rw [ZintSubWord194.ofInt_word]
      exact Word32Memory176.source _ _ _ alloc width writable)
  have cc7 : Slot (s7 s p a b) "cc" 0 := by
    change Slot (s6 s a b) "cc" 0
    exact (CrtState205.keep64 (s5 s) "z" "cc" (wide a b) (by decide)).trans (zero5 s)
  have h8 : Exec setCC (s7 s p a b) ⟨s8 s p a b,.normal⟩ := WordAtoms205.assign32 _ "cc" _ _ _ cc7
    (WordAtoms205.narrow _ _ _ (.bin .shr _ _ _ _ _ (expr64 _ "z" _ z6)
      (WordAtoms205.literal _ 31) (CrtWordOps205.right64 (wide a b) 31 (by decide))))
  have h9 : Exec skip (s8 s p a b) ⟨s8 s p a b,.normal⟩ := ZintSubWord194.skip_run _
  have hi : Exec inner (s4 s) ⟨s8 s p a b,.normal⟩ :=
    .seqNormal _ _ _ _ _ h5 (.seqNormal _ _ _ _ _ h6 (.seqNormal _ _ _ _ _ h7 (.seqNormal _ _ _ _ _ h8 h9)))
  have hs : Exec scopedBody (s4 s) ⟨s9 s p a b,.normal⟩ := .scope _ _ _ _ hi
  have framed:=WordControl205.frame scopedBody (s4 s) ⟨s9 s p a b,.normal⟩ (by decide) hs
  have u9 : Slot64 (s9 s p a b) "u" 0 := (framed.2 u (by decide)).trans (u4 s)
  have len9 : Slot64 (s9 s p a b) "mlen" 1 := (framed.2 mlen (by decide)).trans cells.2.1
  have hup : Exec inc (s9 s p a b) ⟨s10 s p a b,.normal⟩ := ZintSubWord194.update_run _ u .add _
    .uint64 (.uint64 0) (.int32 1) (.uint64 1) u9 (.literal .int32 1) ZintSubWord194.inc_one
  have u10 : Slot64 (s10 s p a b) "u" 1 := CrtState205.cell64 _ _ _
  have len10 : Slot64 (s10 s p a b) "mlen" 1 := (CrtState205.keep64 _ "u" "mlen" 1 (by decide)).trans len9
  have hrest : Exec loop (s10 s p a b) ⟨s10 s p a b,.normal⟩ :=
    .loopFalse _ _ _ _ (.int32 0) (WordAtoms205.guard11 _ "mlen" u10 len10) (by decide)
  have hl : Exec loop (s4 s) ⟨s10 s p a b,.normal⟩ :=
    .loopNormal _ _ _ _ _ _ _ (.int32 1) (WordAtoms205.guard01 _ "mlen" (u4 s) cells.2.1)
      (by decide) hs hup hrest
  have cc10 : Slot (s10 s p a b) "cc" (carry a b) := by
    unfold Slot s10
    rw [CrtState205.keep64 _ "u" "cc" 1 (by decide)]
    unfold s9
    rw [WordControl205.restored _ _ [z] cc (by decide)]
    exact CrtState205.cell32 _ _ _
  have hr : Exec ret (s10 s p a b) ⟨s10 s p a b,.returned (some (.uint32 (carry a b)))⟩ :=
    .ret _ _ _ (expr32 _ "cc" _ cc10)
  have ht : Exec tail (s10 s p a b) ⟨s10 s p a b,.returned (some (.uint32 (carry a b)))⟩ :=
    .seqExit _ _ _ _ hr (by intro h; cases h)
  have full : Exec body s ⟨s10 s p a b,.returned (some (.uint32 (carry a b)))⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ h4 hl) ht)))
  exact ⟨_,by rw [shape]; exact full,rfl,rfl⟩

end FT1536.Source3.ZintMulWord205
