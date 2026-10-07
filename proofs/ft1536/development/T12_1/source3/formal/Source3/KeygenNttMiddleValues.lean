import Source3.KeygenNttBinaryValues
import Source3.KeygenNttFirstComposition
import Source3.KeygenNttControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Memory-connected composition of the executed u1 and m loops. The
   mathematical arrays below follow the source's physical block order. -/
namespace FT1536.Source3.KeygenNttMiddleValues
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec Stmt)
open KeygenSmallOutput (element)
open KeygenNttWordAlgebra (R)
open KeygenNttCells (Cells)
open KeygenNttLoopSupport (USlot PSlot)
open KeygenNttButterflyCalls (U32Slot)
open KeygenNttGeometry (m t ht twiddleIndex)
open KeygenNttControl (seq_inv keep_u64 keep_u32 keep_pointer)

def root (i j : Nat) : R := KeygenMkgm3Rows.root^KeygenMkgm3Indices.tableExponent (twiddleIndex i j)
def blockValues (a : Nat → R) (i j : Nat) : Nat → R :=
  KeygenNttBinaryValues.values a (j*t i) (ht i) (root i j)
def blocks (a : Nat → R) (i : Nat) : Nat → (Nat → R)
  | 0 => a
  | j+1 => blockValues (blocks a i j) i j
def rounds (a : Nat → R) : Nat → (Nat → R)
  | 0 => a
  | i+1 => blocks (rounds a i) i (m i)

structure Args (p gm : ArrayPointer) (p0i : BitVec 32) (s : State) : Prop where
  prime : U32Slot s "p" KeygenNinv31.prime
  inverse : U32Slot s "p0i" p0i
  stride : USlot s "stride" 1
  array : PSlot s "a" p
  table : PSlot s "gm" gm

def argsSafe (code : Stmt) : Bool :=
  KeygenNttControl.supported code &&
  !((KeygenNttControl.localsWritten code).contains "p".toList) &&
  !((KeygenNttControl.localsWritten code).contains "p0i".toList) &&
  !((KeygenNttControl.localsWritten code).contains "stride".toList) &&
  !((KeygenNttControl.pointersWritten code).contains "a".toList) &&
  !((KeygenNttControl.pointersWritten code).contains "gm".toList)

theorem args_keep {code : Stmt} {before : State} {out : Result} {p gm : ArrayPointer} {p0i : BitVec 32}
    (source : Exec code before out) (checked : argsSafe code=true) (args : Args p gm p0i before) :
    Args p gm p0i out.state := by
  simp [argsSafe] at checked
  rcases checked with ⟨⟨⟨⟨⟨hs,hp⟩,hi⟩,hst⟩,ha⟩,hg⟩
  exact ⟨keep_u32 source hs "p" _ hp args.prime,keep_u32 source hs "p0i" _ hi args.inverse,
    keep_u64 source hs "stride" 1 hst args.stride,keep_pointer source hs "a" p ha args.array,
    keep_pointer source hs "gm" gm hg args.table⟩

theorem block_extent (i j : Nat) (hi : i≤7) (hj : j<m i) : j*t i+2*ht i≤1536 := by
  have halves := (KeygenNttGeometry.active_halving i hi).1
  have bound := Nat.mul_le_mul_right (t i) (show j+1≤m i by omega)
  rw [Nat.add_mul,Nat.one_mul,Nat.mul_comm (m i),KeygenNttGeometry.header_product i (by omega)] at bound
  omega

theorem inner_values (before : State) (out : Result) (p gm : ArrayPointer) (p0i : BitVec 32)
    (i j : Nat) (a : Nat → R) (hi : i≤7) (hj : j<m i)
    (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (args : Args p gm p0i before)
    (mc : USlot before "m" (m i)) (uc : USlot before "u1" j)
    (vc : USlot before "v1" (j*t i)) (hc : USlot before "ht" (ht i))
    (input : Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner) before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (blockValues a i j) ∧
      KeygenMkgm3Table.Initialized out.state.heap gm ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨inner,execution,returned⟩ := KeygenNttLoopSupport.scope_result _ _ before out source
  obtain ⟨s1,dv,tail1⟩ := seq_inv _ _ before inner (by decide) execution
  obtain ⟨s2,ds,tail2⟩ := seq_inv _ _ s1 inner (by decide) tail1
  obtain ⟨s3,load,tail3⟩ := seq_inv _ _ s2 inner (by decide) tail2
  obtain ⟨s4,lo,tail4⟩ := seq_inv _ _ s3 inner (by decide) tail3
  obtain ⟨s5,high,tail5⟩ := seq_inv _ _ s4 inner (by decide) tail4
  obtain ⟨s6,loop,tail6⟩ := seq_inv _ _ s5 inner (by decide) tail5
  have declarations := C99ModularReference.GenExec.seqNormal _ _ before s1 ⟨s2,.normal⟩ dv ds
  have declFrame := KeygenNttControl.frame _ _ _ (by decide) declarations
  have declHeap := KeygenNttCells.control_heap _ _ _ declarations (by decide)
  obtain ⟨_,_,_,wordSlots,_⟩ := KeygenNttButterflyCalls.declaration_result .u32 ["s".toList] s1 ⟨s2,.normal⟩ ds
  have sd : KeygenNttButterflyCalls.U32Declared s2 "s" := ⟨none,by rw [wordSlots]; rfl⟩
  obtain ⟨tw,twSlot,scaled,_⟩ := KeygenNttBinaryValues.load_twiddle s2 ⟨s3,.normal⟩ gm i j hi hj
    ((declFrame.2.1 "m".toList (by decide)).trans mc)
    ((declFrame.2.1 "u1".toList (by decide)).trans uc)
    ((declFrame.2.2 "gm".toList (by decide)).trans args.table) sd
    (by rw [declHeap]; exact table) load
  have setup := C99ModularReference.GenExec.seqNormal _ _ before s2 ⟨s3,.normal⟩ declarations load
  have args3 := args_keep setup (by decide) args
  have vc3 := keep_u64 setup (by decide) "v1" (j*t i) (by decide) vc
  have hc3 := keep_u64 setup (by decide) "ht" (ht i) (by decide) hc
  have extent := block_extent i j hi hj
  have r1 : PSlot s4 "r1" (element p (j*t i)) := by
    simpa only [element,Nat.mul_one] using KeygenNttMiddleLoops.bind_product "r1" "a" "v1" (j*t i) 1
      s3 p ⟨s4,.normal⟩ (by decide) (by omega) (by omega) args3.array vc3 args3.stride lo
  have args4 := args_keep lo (by decide) args3
  have hc4 := keep_u64 lo (by decide) "ht" (ht i) (by decide) hc3
  have r2 : PSlot s5 "r2" (element p (j*t i+ht i)) := by
    simpa only [element,Nat.mul_one,Nat.add_assoc] using KeygenNttMiddleLoops.bind_product "r2" "r1" "ht" (ht i) 1
      s4 (element p (j*t i)) ⟨s5,.normal⟩ (by decide) (by omega) (by omega) r1 hc4 args4.stride high
  have binds := C99ModularReference.GenExec.seqNormal _ _ s3 s4 ⟨s5,.normal⟩ lo high
  have setupAll := C99ModularReference.GenExec.seqNormal _ _ before s3 ⟨s5,.normal⟩ setup binds
  have allHeap := KeygenNttCells.control_heap _ _ _ setupAll (by decide)
  have args5 := args_keep binds (by decide) args3
  obtain ⟨_,_,_,vSlots,_⟩ := KeygenNttButterflyCalls.declaration_result .u64 ["v".toList] before ⟨s1,.normal⟩ dv
  have v1decl : s1.locals "v".toList=some (.uint64,none) := by rw [vSlots]; rfl
  have afterV := C99ModularReference.GenExec.seqNormal _ _ s1 s2 ⟨s5,.normal⟩ ds
    (C99ModularReference.GenExec.seqNormal _ _ s2 s3 ⟨s5,.normal⟩ load binds)
  have v5decl : ∃ old, s5.locals "v".toList=some (.uint64,old) :=
    ⟨none,((KeygenNttControl.frame _ _ _ (by decide) afterV).2.1 "v".toList (by decide)).trans v1decl⟩
  obtain ⟨_,cells,frame⟩ := KeygenNttBinaryValues.loop_values s5 ⟨s6,.normal⟩ p a (j*t i) (ht i) (root i j) tw p0i
    pw extent ⟨keep_u32 binds (by decide) "s" tw (by decide) twSlot,args5.prime,args5.inverse,args5.stride⟩
    v5decl (keep_u64 binds (by decide) "ht" (ht i) (by decide) hc3)
    (keep_pointer high (by decide) "r1" _ (by decide) r1) r2
    (by rw [allHeap]; exact input) scaled initialization loop
  rw [allHeap] at frame
  rw [C99ModularReference.skip_result s6 inner tail6] at returned
  rw [returned]
  exact ⟨rfl,cells,KeygenNttFirstComposition.table_preserved _ _ p gm pw gw separate table frame,frame⟩

theorem counter_extent (i j : Nat) (hi : i≤8) (hj : j≤m i) : j*t i≤1536 := by
  have bound := Nat.mul_le_mul_right (t i) hj
  rw [Nat.mul_comm (m i),KeygenNttGeometry.header_product i hi] at bound
  exact bound

theorem u1_trace_values (p gm : ArrayPointer) (p0i : BitVec 32) (a : Nat → R) (i : Nat)
    (hi : i≤7) (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (j : Nat) (before after : State)
    (trace : KeygenNttMiddleRounds.U1Trace p 1 (m i) (t i) (ht i) j before after)
    (args : Args p gm p0i before) (mc : USlot before "m" (m i)) (hc : USlot before "ht" (ht i))
    (input : Cells before.heap p 1536 (blocks a i j)) (table : KeygenMkgm3Table.Initialized before.heap gm) :
    Cells after.heap p 1536 (blocks a i (m i)) ∧ KeygenMkgm3Table.Initialized after.heap gm ∧
      KeygenNttFirstValues.Frame before.heap after.heap p := by
  induction trace with
  | done j s stop inv =>
      have equal : j=m i := by have := inv.bound; omega
      subst j
      exact ⟨input,table,fun _ _ _ cell => cell⟩
  | next j before mid next fin guard inv iteration run update rest ih =>
      obtain ⟨_,cells,tableMid,frame⟩ := inner_values before ⟨mid,.normal⟩ p gm p0i i j (blocks a i j)
        hi guard pw gw separate args mc inv.u1Slot inv.v1Slot hc input table initialization iteration
      have argsMid := args_keep iteration (by decide) args
      have mcMid := keep_u64 iteration (by decide) "m" (m i) (by decide) mc
      have hcMid := keep_u64 iteration (by decide) "ht" (ht i) (by decide) hc
      have heap := KeygenNttCells.control_heap _ _ _ update (by decide)
      obtain ⟨done,tableDone,tail⟩ := ih (args_keep update (by decide) argsMid)
        (keep_u64 update (by decide) "m" (m i) (by decide) mcMid)
        (keep_u64 update (by decide) "ht" (ht i) (by decide) hcMid)
        (by rw [heap]; exact cells) (by rw [heap]; exact tableMid)
      refine ⟨done,tableDone,?_⟩
      intro q z outside cell
      apply tail q z outside
      rw [heap]
      exact frame q z outside cell

theorem u1_values (before : State) (out : Result) (p gm : ArrayPointer) (p0i : BitVec 32)
    (i : Nat) (a : Nat → R) (hi : i≤7) (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (args : Args p gm p0i before) (mc : USlot before "m" (m i))
    (tc : USlot before "t" (t i)) (hc : USlot before "ht" (ht i))
    (uc : ∃ old, before.locals "u1".toList=some (.uint64,old))
    (vc : ∃ old, before.locals "v1".toList=some (.uint64,old))
    (input : Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.u1Loop before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (blocks a i (m i)) ∧
      KeygenMkgm3Table.Initialized out.state.heap gm ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨s0,init,loop⟩ := seq_inv _ _ before out (by decide) source
  obtain ⟨s1,initU,initV⟩ := seq_inv _ _ before ⟨s0,.normal⟩ (by decide) init
  obtain ⟨_,u0,_,_⟩ := KeygenNttMiddleRounds.assign_nat_result "u1" 0 before ⟨s1,.normal⟩ uc (by decide) initU
  obtain ⟨old,vcell⟩ := vc
  have vc1 : ∃ old, s1.locals "v1".toList=some (.uint64,old) :=
    ⟨old,((KeygenNttControl.frame _ _ _ (by decide) initU).2.1 "v1".toList (by decide)).trans vcell⟩
  obtain ⟨_,v0,_,_⟩ := KeygenNttMiddleRounds.assign_nat_result "v1" 0 s1 ⟨s0,.normal⟩ vc1 (by decide) initV
  have inv0 : KeygenNttMiddleRounds.U1Inv (m i) (t i) 0 s0 :=
    ⟨keep_u64 initV (by decide) "u1" 0 (by decide) u0,by simpa only [Nat.zero_mul] using v0,Nat.zero_le _⟩
  have args0 := args_keep init (by decide) args
  have mc0 := keep_u64 init (by decide) "m" (m i) (by decide) mc
  have hc0 := keep_u64 init (by decide) "ht" (ht i) (by decide) hc
  have tc0 := keep_u64 init (by decide) "t" (t i) (by decide) tc
  have bounds : m i≤256 ∧ t i≤768 ∧ ht i≤384 := by interval_cases i <;> decide
  have fit (j : Nat) (hj : j≤m i) : j*t i<2^64 := by
    have := counter_extent i j (by omega) hj
    omega
  obtain ⟨flow,_,trace⟩ := KeygenNttMiddleRounds.u1_loop_trace p 1 (m i) (t i) (ht i) _ s0 out
    (by decide) (by omega) (by omega) (by omega) fit
    (by simpa only [Nat.mul_one] using fit) (by omega) loop rfl 0 inv0 mc0 tc0 hc0 args0.stride args0.array
  have heap := KeygenNttCells.control_heap _ _ _ init (by decide)
  obtain ⟨cells,tableOut,frame⟩ := u1_trace_values p gm p0i a i hi pw gw separate initialization 0 s0 out.state
    trace args0 mc0 hc0 (by rw [heap]; exact input) (by rw [heap]; exact table)
  rw [heap] at frame
  exact ⟨flow,cells,tableOut,frame⟩

theorem round_values (before : State) (out : Result) (p gm : ArrayPointer) (p0i : BitVec 32)
    (i : Nat) (a : Nat → R) (hi : i≤7) (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (args : Args p gm p0i before) (inv : KeygenNttMiddleRounds.MInv i before)
    (input : Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.mInner) before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (blocks a i (m i)) ∧
      KeygenMkgm3Table.Initialized out.state.heap gm ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨inner,execution,returned⟩ := KeygenNttLoopSupport.scope_result _ _ before out source
  obtain ⟨s1,decl,tail1⟩ := seq_inv _ _ before inner (by decide) execution
  obtain ⟨s2,half,tail2⟩ := seq_inv _ _ s1 inner (by decide) tail1
  obtain ⟨s3,loop,tail3⟩ := seq_inv _ _ s2 inner (by decide) tail2
  obtain ⟨s4,halveT,tail4⟩ := seq_inv _ _ s3 inner (by decide) tail3
  obtain ⟨_,_,_,declSlots,_⟩ := KeygenNttButterflyCalls.declaration_result .u64
    (["ht","u1","v1"].map String.toList) before ⟨s1,.normal⟩ decl
  have htc : s1.locals "ht".toList=some (.uint64,none) := by rw [declSlots]; rfl
  have utc : s1.locals "u1".toList=some (.uint64,none) := by rw [declSlots]; rfl
  have vtc : s1.locals "v1".toList=some (.uint64,none) := by rw [declSlots]; rfl
  obtain ⟨_,hc,_,_⟩ := KeygenNttMiddleRounds.ht_assign_result s1 (t i) ⟨s2,.normal⟩
    (KeygenNttMiddleRounds.base_half_bound i) htc
    (keep_u64 decl (by decide) "t" (t i) (by decide) inv.tSlot) half
  have setup := C99ModularReference.GenExec.seqNormal _ _ before s1 ⟨s2,.normal⟩ decl half
  have heap := KeygenNttCells.control_heap _ _ _ setup (by decide)
  have halfFrame := KeygenNttControl.frame _ _ _ (by decide) half
  obtain ⟨_,cells,table3,frame⟩ := u1_values s2 ⟨s3,.normal⟩ p gm p0i i a hi pw gw separate
    (args_keep setup (by decide) args)
    (keep_u64 setup (by decide) "m" (m i) (by decide) inv.mSlot)
    (keep_u64 setup (by decide) "t" (t i) (by decide) inv.tSlot) hc
    ⟨none,(halfFrame.2.1 "u1".toList (by decide)).trans utc⟩
    ⟨none,(halfFrame.2.1 "v1".toList (by decide)).trans vtc⟩
    (by rw [heap]; exact input) (by rw [heap]; exact table) initialization loop
  rw [heap] at frame
  have heap4 := KeygenNttCells.control_heap _ _ _ halveT (by decide)
  rw [C99ModularReference.skip_result s4 inner tail4] at returned
  rw [returned]
  change _ ∧ Cells s4.heap p 1536 _ ∧ KeygenMkgm3Table.Initialized s4.heap gm ∧
    KeygenNttFirstValues.Frame before.heap s4.heap p
  rw [heap4]
  exact ⟨rfl,cells,table3,frame⟩

theorem m_trace_values (p gm : ArrayPointer) (p0i : BitVec 32) (a : Nat → R)
    (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (i : Nat) (before after : State) (trace : KeygenNttMiddleRounds.MTrace p 1 i before after)
    (hi : i≤8) (args : Args p gm p0i before)
    (input : Cells before.heap p 1536 (rounds a i)) (table : KeygenMkgm3Table.Initialized before.heap gm) :
    Cells after.heap p 1536 (rounds a 8) ∧ KeygenMkgm3Table.Initialized after.heap gm ∧
      KeygenNttFirstValues.Frame before.heap after.heap p := by
  induction trace with
  | done i s stop inv =>
      have equal := KeygenNttGeometry.stop_index i hi stop
      subst i
      exact ⟨input,table,fun _ _ _ cell => cell⟩
  | next i before mid next fin guard inv iteration run update rest ih =>
      have active := KeygenNttMiddleRounds.round_index_bound i guard
      obtain ⟨_,cells,tableMid,frame⟩ := round_values before ⟨mid,.normal⟩ p gm p0i i (rounds a i)
        active pw gw separate args inv input table initialization iteration
      have heap := KeygenNttCells.control_heap _ _ _ update (by decide)
      obtain ⟨done,tableDone,tail⟩ := ih (by omega)
        (args_keep update (by decide) (args_keep iteration (by decide) args))
        (by rw [heap]; exact cells) (by rw [heap]; exact tableMid)
      refine ⟨done,tableDone,?_⟩
      intro q z outside cell
      apply tail q z outside
      rw [heap]
      exact frame q z outside cell

theorem intermediate_values (before : State) (out : Result) (p gm : ArrayPointer) (p0i : BitVec 32)
    (a : Nat → R) (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (args : Args p gm p0i before) (hn : USlot before "hn" 768)
    (tc : ∃ old, before.locals "t".toList=some (.uint64,old))
    (mc : ∃ old, before.locals "m".toList=some (.uint64,old))
    (full : KeygenNttForwardExec.fullAt before)
    (input : Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.intermediatePass before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (rounds a 8) ∧
      KeygenMkgm3Table.Initialized out.state.heap gm ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨s1,initT,tail1⟩ := seq_inv _ _ before out (by decide) source
  obtain ⟨s2,passes,tail2⟩ := seq_inv _ _ s1 out (by decide) tail1
  obtain ⟨s3,initM,loop⟩ := seq_inv _ _ s1 ⟨s2,.normal⟩ (by decide) passes
  obtain ⟨_,t1,_,_⟩ := KeygenNttMiddleRounds.assign_var_result "t" "hn" 768 before ⟨s1,.normal⟩
    (by decide) tc hn initT
  obtain ⟨old,mcell⟩ := mc
  have mc1 : ∃ old, s1.locals "m".toList=some (.uint64,old) :=
    ⟨old,((KeygenNttControl.frame _ _ _ (by decide) initT).2.1 "m".toList (by decide)).trans mcell⟩
  obtain ⟨_,m3,_,_⟩ := KeygenNttMiddleRounds.assign_nat_result "m" 2 s1 ⟨s3,.normal⟩ mc1 (by decide) initM
  have setup := C99ModularReference.GenExec.seqNormal _ _ before s1 ⟨s3,.normal⟩ initT initM
  have args3 := args_keep setup (by decide) args
  have inv0 : KeygenNttMiddleRounds.MInv 0 s3 :=
    ⟨m3,keep_u64 initM (by decide) "t" 768 (by decide) t1⟩
  have full3 : KeygenNttForwardExec.fullAt s3 :=
    ((KeygenNttControl.frame _ _ _ (by decide) setup).2.1 "full".toList (by decide)).trans full
  obtain ⟨_,trace⟩ := KeygenNttMiddleRounds.m_loop_trace p 1 _ s3 ⟨s2,.normal⟩ (by decide) (by decide)
    loop rfl 0 inv0 full3 args3.stride args3.array
  have heap := KeygenNttCells.control_heap _ _ _ setup (by decide)
  obtain ⟨cells,tableOut,frame⟩ := m_trace_values p gm p0i a pw gw separate initialization 0 s3 s2 trace
    (by decide) args3 (by rw [heap]; exact input) (by rw [heap]; exact table)
  rw [heap] at frame
  rw [C99ModularReference.skip_result s2 out tail2]
  exact ⟨rfl,cells,tableOut,frame⟩

end FT1536.Source3.KeygenNttMiddleValues
