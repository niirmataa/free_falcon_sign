import Source3.KeygenNttMiddleValues
import Source3.KeygenNttTripleLoop
import Source3.KeygenNttRoots

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- All 512 actual triple iterations, including the executed wSquared
   Montgomery call. Values retain the fixed physical source point order. -/
namespace FT1536.Source3.KeygenNttTripleValues
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttWordAlgebra (R value radix)
open KeygenNttCells (Cell Cells)
open KeygenNttLoopSupport (USlot PSlot)
open KeygenNttButterflyCalls (U32Slot)
open KeygenNttMiddleValues (Args args_keep)
open KeygenNttControl (seq_inv keep_u64 keep_u32)
open KeygenNttRoots (unity)

def root (j : Nat) : R := KeygenMkgm3Rows.root^KeygenMkgm3Indices.tableExponent (512+j)
def tripleValue (a : Nat → R) (j k : Nat) : R :=
  KeygenNttCells.quadratic (a (3*j)) (a (3*j+1)) (a (3*j+2)) (root j*unity^k)
def values (a : Nat → R) (q : Nat) : R := tripleValue a (q/3) (q%3)
def Snapshot (heap : Memory) (p : ArrayPointer) (a : Nat → R) (n : Nat) : Prop :=
  ∀ j<512, ∀ k<3, Cell heap (element p (3*j+k)) (if j<n then tripleValue a j k else a (3*j+k))

theorem snapshot_zero (heap : Memory) (p : ArrayPointer) (a : Nat → R)
    (input : Cells heap p 1536 a) : Snapshot heap p a 0 := by
  intro j hj k hk
  simpa only [Nat.not_lt_zero,ite_false] using input (3*j+k) (by omega)

theorem snapshot_final (heap : Memory) (p : ArrayPointer) (a : Nat → R)
    (input : Snapshot heap p a 512) : Cells heap p 1536 (values a) := by
  intro q hq
  have hdiv : q/3<512 := by omega
  have rem : q%3<3 := Nat.mod_lt q (by decide)
  have equal : 3*(q/3)+q%3=q := by omega
  simpa only [hdiv,ite_true,equal,values] using input (q/3) hdiv (q%3) rem

theorem snapshot_step (before : State) (out : Result) (p gm : ArrayPointer) (a : Nat → R)
    (j : Nat) (w p0i : BitVec 32) (pw : p.elementBytes=4) (hj : j<512)
    (args : Args p gm p0i before) (ws : U32Slot before "w" w)
    (inv : KeygenNttTripleLoop.TripleInv p 1 j before)
    (input : Snapshot before.heap p a j) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (twiddle : KeygenNttButterflyAlgebra.Canonical w ∧ value w=radix*unity)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody) before out) :
    Snapshot out.state.heap p a (j+1) ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  have ctx : KeygenNttButterflyCalls.TCtx (element p (3*j)) gm 1 (512+j) w p0i before :=
    ⟨by simpa only [element,Nat.mul_one,Nat.mul_comm j 3] using inv.pos,
      args.table,args.stride,inv.rev,ws,args.prime,args.inverse⟩
  have ca : Cell before.heap (element p (3*j)) (a (3*j)) := by simpa using input j hj 0 (by decide)
  have cb : Cell before.heap (element (element p (3*j)) 1) (a (3*j+1)) := by
    simpa only [Nat.lt_irrefl,ite_false,element,Nat.add_assoc] using input j hj 1 (by decide)
  have cc : Cell before.heap (element (element p (3*j)) 2) (a (3*j+2)) := by
    simpa only [Nat.lt_irrefl,ite_false,element,Nat.add_assoc] using input j hj 2 (by decide)
  obtain ⟨_,c0,c1,c2,frame⟩ := KeygenNttCells.triple before out (element p (3*j)) gm 1 (512+j) w p0i
    (a (3*j)) (a (3*j+1)) (a (3*j+2)) (root j) unity (by decide) (by decide) (by omega) pw ctx
    ca cb cc (table (512+j) (by omega)) twiddle KeygenNttRoots.unity_cube initialization source
  have newCells (k : Nat) (hk : k<3) : Cell out.state.heap (element p (3*j+k)) (tripleValue a j k) := by
    interval_cases k
    · simpa only [tripleValue,pow_zero,mul_one,Nat.add_zero] using c0
    · simpa only [tripleValue,pow_one,element,Nat.add_assoc] using c1
    · simpa only [tripleValue,element,Nat.add_assoc] using c2
  have keep (q : Nat) (hne0 : q≠3*j) (hne1 : q≠3*j+1) (hne2 : q≠3*j+2) (z : R)
      (cell : Cell before.heap (element p q) z) : Cell out.state.heap (element p q) z := by
    apply frame _ _ _ cell
    intro pos member
    simp only [List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with rfl | rfl | rfl
    · exact KeygenNttCells.elements_separate p pw _ _ hne0.symm
    · simpa only [element,Nat.add_assoc] using KeygenNttCells.elements_separate p pw (3*j+1) q hne1.symm
    · simpa only [element,Nat.add_assoc] using KeygenNttCells.elements_separate p pw (3*j+2) q hne2.symm
  constructor
  · intro b hb k hk
    by_cases equal : b=j
    · subst b
      simpa only [Nat.lt_succ_self,ite_true] using newCells k hk
    · have same : (b<j+1)=(b<j) := propext (by omega)
      simp only [same]
      exact keep (3*b+k) (by omega) (by omega) (by omega) _ (input b hb k hk)
  · intro q z outside cell
    apply frame q z _ cell
    intro pos member
    simp only [List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with rfl | rfl | rfl
    · exact outside (3*j) (by omega)
    · simpa only [element,Nat.add_assoc] using outside (3*j+1) (by omega)
    · simpa only [element,Nat.add_assoc] using outside (3*j+2) (by omega)

theorem trace_values (p gm : ArrayPointer) (a : Nat → R) (w p0i : BitVec 32)
    (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (twiddle : KeygenNttButterflyAlgebra.Canonical w ∧ value w=radix*unity)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (j : Nat) (before after : State) (trace : KeygenNttTripleLoop.TripleTrace p 1 j before after)
    (args : Args p gm p0i before) (ws : U32Slot before "w" w)
    (input : Snapshot before.heap p a j) (table : KeygenMkgm3Table.Initialized before.heap gm) :
    Snapshot after.heap p a 512 ∧ KeygenMkgm3Table.Initialized after.heap gm ∧
      KeygenNttFirstValues.Frame before.heap after.heap p := by
  induction trace with
  | done j s stop inv =>
      have equal : j=512 := by have := inv.bound; omega
      subst j
      exact ⟨input,table,fun _ _ _ cell => cell⟩
  | next j before mid next fin guard inv iteration update rest ih =>
      obtain ⟨cells,frame⟩ := snapshot_step before ⟨mid,.normal⟩ p gm a j w p0i pw (by omega)
        args ws inv input table twiddle initialization iteration
      have tableMid := KeygenNttFirstComposition.table_preserved _ _ p gm pw gw separate table frame
      have heap := KeygenNttCells.control_heap _ _ _ update (by decide)
      obtain ⟨done,tableDone,tail⟩ := ih
        (args_keep update (by decide) (args_keep iteration (by decide) args))
        (keep_u32 update (by decide) "w" w (by decide) (keep_u32 iteration (by decide) "w" w (by decide) ws))
        (by rw [heap]; exact cells) (by rw [heap]; exact tableMid)
      refine ⟨done,tableDone,?_⟩
      intro q z outside cell
      apply tail q z outside
      rw [heap]
      exact frame q z outside cell

theorem loop_values (before : State) (out : Result) (p gm : ArrayPointer) (a : Nat → R) (w p0i : BitVec 32)
    (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (args : Args p gm p0i before) (ws : U32Slot before "w" w)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (rc : ∃ old, before.locals "r".toList=some (.uint64,old))
    (lg : KeygenNttForwardExec.lognAt before) (nc : USlot before "n" 1536)
    (input : Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (twiddle : KeygenNttButterflyAlgebra.Canonical w ∧ value w=radix*unity)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.tripleLoop before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (values a) ∧
      KeygenMkgm3Table.Initialized out.state.heap gm ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨s0,init,loop⟩ := seq_inv _ _ before out (by decide) source
  obtain ⟨_,inv,_,_,_⟩ := KeygenNttTripleLoop.init_result p 1 before ⟨s0,.normal⟩ uc rc lg args.stride args.array init
  have args0 := args_keep init (by decide) args
  obtain ⟨flow,trace⟩ := KeygenNttTripleLoop.loop_trace p 1 _ s0 out (by decide) (by decide) loop rfl 0
    (by decide) inv args0.stride (keep_u64 init (by decide) "n" 1536 (by decide) nc)
  have heap := KeygenNttCells.control_heap _ _ _ init (by decide)
  obtain ⟨cells,tableOut,frame⟩ := trace_values p gm a w p0i pw gw separate twiddle initialization 0 s0 out.state
    trace args0 (keep_u32 init (by decide) "w" w (by decide) ws)
    (by rw [heap]; exact snapshot_zero before.heap p a input) (by rw [heap]; exact table)
  rw [heap] at frame
  exact ⟨flow,snapshot_final _ p a cells,tableOut,frame⟩

theorem square_value (before : State) (out : Result) (gm : ArrayPointer) (p0i : BitVec 32)
    (prime : U32Slot before "p" KeygenNinv31.prime) (inverse : U32Slot before "p0i" p0i)
    (gp : PSlot before "gm" gm) (wc : KeygenNttButterflyCalls.U32Declared before "w")
    (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.wSquared before out) :
    ∃ w, U32Slot out.state "w" w ∧ KeygenNttButterflyAlgebra.Canonical w ∧ value w=radix*unity := by
  have loaded := KeygenMkgm3Atoms.load_word before "gm" (KeygenNttForwardPrograms.num 1) gm 1
    (KeygenMkgm3Indices.tableExponent 1) gp (KeygenMkgm3Atoms.literal_index before 1 (by decide)) (table 1 (by decide))
  have squared := KeygenMkgm3Atoms.mont_word before p0i _ _ _ _ ⟨prime,inverse⟩ initialization loaded loaded
  obtain ⟨⟨w,slot,range,law⟩,_⟩ := KeygenMkgm3Atoms.assign_word before out "w" _ _ wc squared source
  refine ⟨w,slot,range,?_⟩
  rw [KeygenNttRoots.unity_power]
  exact law

theorem pass_values (before : State) (out : Result) (p gm : ArrayPointer) (a : Nat → R) (p0i : BitVec 32)
    (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (args : Args p gm p0i before) (wc : KeygenNttButterflyCalls.U32Declared before "w")
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (rc : ∃ old, before.locals "r".toList=some (.uint64,old))
    (lg : KeygenNttForwardExec.lognAt before) (full : KeygenNttForwardExec.fullAt before) (nc : USlot before "n" 1536)
    (input : Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.triplePass before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (values a) ∧
      KeygenMkgm3Table.Initialized out.state.heap gm ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨s0,branch,tail⟩ := seq_inv _ _ before out (by decide) source
  have chosen : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.tripleInner) before ⟨s0,.normal⟩ := by
    cases branch with
    | branchTrue cond yes no before out v guard nonzero body => exact body
    | branchFalse cond yes no before out v guard zero body =>
        have equal := KeygenNttButterflyCalls.variable_u32 before "full" 1 v full guard
        subst v
        contradiction
  obtain ⟨inner,execution,returned⟩ := KeygenNttLoopSupport.scope_result _ _ before ⟨s0,.normal⟩ chosen
  obtain ⟨s1,square,tail1⟩ := seq_inv _ _ before inner (by decide) execution
  obtain ⟨s2,loop,tail2⟩ := seq_inv _ _ s1 inner (by decide) tail1
  obtain ⟨w,ws,range,law⟩ := square_value before ⟨s1,.normal⟩ gm p0i args.prime args.inverse args.table wc table initialization square
  have frame1 := KeygenNttControl.frame _ _ _ (by decide) square
  have heap := KeygenNttCells.control_heap _ _ _ square (by decide)
  obtain ⟨oldu,uslot⟩ := uc
  obtain ⟨oldr,rslot⟩ := rc
  obtain ⟨_,cells,tableOut,frame⟩ := loop_values s1 ⟨s2,.normal⟩ p gm a w p0i pw gw separate
    (args_keep square (by decide) args) ws
    ⟨oldu,(frame1.2.1 "u".toList (by decide)).trans uslot⟩
    ⟨oldr,(frame1.2.1 "r".toList (by decide)).trans rslot⟩
    ((frame1.2.1 "logn".toList (by decide)).trans lg) (keep_u64 square (by decide) "n" 1536 (by decide) nc)
    (by rw [heap]; exact input) (by rw [heap]; exact table) ⟨range,law⟩ initialization loop
  rw [heap] at frame
  rw [C99ModularReference.skip_result s2 inner tail2] at returned
  have heap0 : s0.heap=s2.heap := congrArg (fun r : Result => r.state.heap) returned
  rw [C99ModularReference.skip_result s0 out tail]
  change _ ∧ Cells s0.heap p 1536 _ ∧ KeygenMkgm3Table.Initialized s0.heap gm ∧ _
  rw [heap0]
  exact ⟨rfl,cells,tableOut,frame⟩

end FT1536.Source3.KeygenNttTripleValues
