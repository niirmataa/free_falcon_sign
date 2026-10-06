import Source3.KeygenNttGeometry
import Source3.KeygenNttFirstValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- A complete executed radix-2 v-loop, with input/output values on the
   same 1536-cell object. The enclosing u1/m composition remains separate. -/
namespace FT1536.Source3.KeygenNttBinaryValues
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttWordAlgebra (R value radix)
open KeygenNttCells (Cell Cells)
open KeygenNttLoopSupport (USlot PSlot)
open KeygenNttButterflyCalls (U32Slot)
open KeygenNttMiddleLoops (VInv VTrace)

def low (a : Nat → R) (base d : Nat) (root : R) (k : Nat) : R := a (base+k)+a (base+d+k)*root
def high (a : Nat → R) (base d : Nat) (root : R) (k : Nat) : R := a (base+k)-a (base+d+k)*root
def values (a : Nat → R) (base d : Nat) (root : R) (j : Nat) : R :=
  if j<base then a j else if j<base+d then low a base d root (j-base)
  else if j<base+2*d then high a base d root (j-(base+d)) else a j
def Snapshot (heap : Memory) (p : ArrayPointer) (a : Nat → R) (base d : Nat) (root : R) (k : Nat) : Prop :=
  (∀ j<d, Cell heap (element p (base+j)) (if j<k then low a base d root j else a (base+j)) ∧
    Cell heap (element p (base+d+j)) (if j<k then high a base d root j else a (base+d+j))) ∧
  (∀ j<1536, j<base ∨ base+2*d≤j → Cell heap (element p j) (a j))

structure Args (tw p0i : BitVec 32) (s : State) : Prop where
  twiddle : U32Slot s "s" tw
  prime : U32Slot s "p" KeygenNinv31.prime
  inverse : U32Slot s "p0i" p0i
  stride : USlot s "stride" 1

theorem snapshot_zero (heap : Memory) (p : ArrayPointer) (a : Nat → R) (base d : Nat) (root : R)
    (extent : base+2*d≤1536) (input : Cells heap p 1536 a) : Snapshot heap p a base d root 0 := by
  constructor
  · intro j hj
    simpa only [Nat.not_lt_zero,ite_false] using
      And.intro (input (base+j) (by omega)) (input (base+d+j) (by omega))
  · exact fun j hj _ => input j hj

theorem snapshot_final (heap : Memory) (p : ArrayPointer) (a : Nat → R) (base d : Nat) (root : R)
    (input : Snapshot heap p a base d root d) : Cells heap p 1536 (values a base d root) := by
  intro j hj
  unfold values
  split_ifs with hlo hmid hhi
  · exact input.2 j hj (Or.inl hlo)
  · have hk : j-base<d := by omega
    have he : base+(j-base)=j := by omega
    simpa only [hk,ite_true,he] using (input.1 (j-base) hk).1
  · have hk : j-(base+d)<d := by omega
    have he : base+d+(j-(base+d))=j := by omega
    simpa only [hk,ite_true,he] using (input.1 (j-(base+d)) hk).2
  · exact input.2 j hj (Or.inr (by omega))

theorem snapshot_step (before : State) (out : Result) (p : ArrayPointer)
    (a : Nat → R) (base d : Nat) (root : R) (k : Nat) (tw p0i : BitVec 32)
    (width : p.elementBytes=4) (extent : base+2*d≤1536) (hk : k<d)
    (inv : VInv p 1 base d k before) (args : Args tw p0i before)
    (input : Snapshot before.heap p a base d root k)
    (twiddle : KeygenNttButterflyAlgebra.Canonical tw ∧ value tw=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody) before out) :
    Snapshot out.state.heap p a base d root (k+1) ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  have ctx : KeygenNttButterflyCalls.FCtx "s" (element p (base+k)) (element p (base+d+k)) tw p0i before :=
    ⟨by simpa only [element,Nat.mul_one,Nat.add_assoc] using inv.low,
      by simpa only [element,Nat.mul_one,Nat.add_assoc] using inv.high,args.twiddle,args.prime,args.inverse⟩
  have cx : Cell before.heap (element p (base+k)) (a (base+k)) := by simpa using (input.1 k hk).1
  have cy : Cell before.heap (element p (base+d+k)) (a (base+d+k)) := by simpa using (input.1 k hk).2
  obtain ⟨_,cl,ch,frame⟩ := KeygenNttCells.binary before out _ _ tw p0i _ _ root ctx
    (KeygenNttCells.elements_separate p width (base+k) (base+d+k) (by omega)) cx cy twiddle initialization source
  have keep (j : Nat) (hne1 : base+k≠j) (hne2 : base+d+k≠j) (z : R)
      (cell : Cell before.heap (element p j) z) : Cell out.state.heap (element p j) z := by
    apply frame _ _ _ cell
    intro q hq
    rcases List.mem_cons.mp hq with rfl | hq
    · exact KeygenNttCells.elements_separate p width _ j hne1
    · have he := List.mem_singleton.mp hq
      subst q
      exact KeygenNttCells.elements_separate p width _ j hne2
  refine ⟨⟨?_,?_⟩,?_⟩
  · intro j hj
    by_cases equal : j=k
    · subst j
      simpa only [Nat.lt_succ_self,ite_true,low,high] using And.intro cl ch
    · have same : (j<k+1)=(j<k) := propext (by omega)
      simp only [same]
      exact ⟨keep (base+j) (by omega) (by omega) _ (input.1 j hj).1,
        keep (base+d+j) (by omega) (by omega) _ (input.1 j hj).2⟩
  · intro j hj outside
    exact keep j (by omega) (by omega) _ (input.2 j hj outside)
  · intro q x separate cell
    apply frame q x _ cell
    intro pos hp
    rcases List.mem_cons.mp hp with rfl | hp
    · exact separate (base+k) (by omega)
    · have he := List.mem_singleton.mp hp
      subst pos
      exact separate (base+d+k) (by omega)

theorem trace_values (p : ArrayPointer) (a : Nat → R) (base d : Nat) (root : R) (tw p0i : BitVec 32)
    (width : p.elementBytes=4) (extent : base+2*d≤1536)
    (twiddle : KeygenNttButterflyAlgebra.Canonical tw ∧ value tw=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (k : Nat) (before after : State) (trace : VTrace p 1 base d k before after)
    (args : Args tw p0i before) (input : Snapshot before.heap p a base d root k) :
    Snapshot after.heap p a base d root d ∧ KeygenNttFirstValues.Frame before.heap after.heap p := by
  induction trace with
  | done k s stop inv =>
      have he : k=d := by have := inv.bound; omega
      subst k
      exact ⟨input,fun _ _ _ hc => hc⟩
  | next k before mid next fin guard inv iteration update rest ih =>
      obtain ⟨cells,frame⟩ := snapshot_step before ⟨mid,.normal⟩ p a base d root k tw p0i width extent
        guard inv args input twiddle initialization iteration
      obtain ⟨_,arrays,locals⟩ := KeygenNttButterflyCalls.binary_body_result before ⟨mid,.normal⟩ iteration
      have st : USlot mid "stride" 1 := KeygenNttFirstLoop.slot_keep locals _ _ args.stride
      obtain ⟨_,_,_,_,keep⟩ := KeygenNttMiddleLoops.step_result "v" mid k 1 _ _ ⟨next,.normal⟩
        (by decide) (by omega) (KeygenNttFirstLoop.slot_keep locals _ _ inv.counter) st (by decide)
        (KeygenNttFirstLoop.ptr_keep arrays _ _ inv.low)
        (KeygenNttFirstLoop.ptr_keep arrays _ _ inv.high) update
      have heap : next.heap=mid.heap := KeygenNttCells.control_heap _ _ _ update (by decide)
      have argsNext : Args tw p0i next := ⟨
        (keep "s".toList (by decide)).trans ((congrFun locals _).trans args.twiddle),
        (keep "p".toList (by decide)).trans ((congrFun locals _).trans args.prime),
        (keep "p0i".toList (by decide)).trans ((congrFun locals _).trans args.inverse),
        (keep "stride".toList (by decide)).trans st⟩
      obtain ⟨done,tail⟩ := ih argsNext (by rw [heap]; exact cells)
      refine ⟨done,?_⟩
      intro q x separate cell
      apply tail q x separate
      rw [heap]
      exact frame q x separate cell

theorem loop_values (before : State) (out : Result) (p : ArrayPointer)
    (a : Nat → R) (base d : Nat) (root : R) (tw p0i : BitVec 32)
    (width : p.elementBytes=4) (extent : base+2*d≤1536) (args : Args tw p0i before)
    (vc : ∃ old, before.locals "v".toList=some (.uint64,old))
    (ht : USlot before "ht" d) (lo : PSlot before "r1" (element p base))
    (hi : PSlot before "r2" (element p (base+d)))
    (input : Cells before.heap p 1536 a)
    (twiddle : KeygenNttButterflyAlgebra.Canonical tw ∧ value tw=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.vLoop before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (values a base d root) ∧
      KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  obtain ⟨mid,first,rest⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right
    (by rintro ⟨r,hr,hn,he⟩; subst r; exact hn (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨_,v0,arrays,keep⟩ := KeygenNttMiddleRounds.assign_nat_result "v" 0 before ⟨mid,.normal⟩
    vc (by decide) first
  have heap : mid.heap=before.heap := KeygenNttCells.control_heap _ _ _ first (by decide)
  have args0 : Args tw p0i mid := ⟨(keep "s".toList (by decide)).trans args.twiddle,
    (keep "p".toList (by decide)).trans args.prime,(keep "p0i".toList (by decide)).trans args.inverse,
    (keep "stride".toList (by decide)).trans args.stride⟩
  have ht0 : USlot mid "ht" d := (keep "ht".toList (by decide)).trans ht
  have inv0 : VInv p 1 base d 0 mid := ⟨v0,
    by simpa only [element,Nat.mul_one,Nat.zero_mul,Nat.add_zero] using KeygenNttFirstLoop.ptr_keep arrays _ _ lo,
    by simpa only [element,Nat.mul_one,Nat.zero_mul,Nat.add_zero,Nat.add_assoc] using
      KeygenNttFirstLoop.ptr_keep arrays _ _ hi,by omega⟩
  obtain ⟨flow,_,trace⟩ := KeygenNttMiddleLoops.loop_trace p 1 base d _ mid out (by decide) (by omega)
    rest rfl 0 (by omega) inv0 args0.stride ht0
  obtain ⟨cells,frame⟩ := trace_values p a base d root tw p0i width extent twiddle initialization 0 mid out.state
    trace args0 (by rw [heap]; exact snapshot_zero before.heap p a base d root extent input)
  rw [heap] at frame
  exact ⟨flow,snapshot_final out.state.heap p a base d root cells,frame⟩

theorem load_twiddle (before : State) (out : Result) (gm : ArrayPointer) (i j : Nat)
    (hi : i≤7) (hj : j<KeygenNttGeometry.m i)
    (mc : USlot before "m" (KeygenNttGeometry.m i)) (uc : USlot before "u1" j)
    (gp : PSlot before "gm" gm) (declared : KeygenNttButterflyCalls.U32Declared before "s")
    (table : KeygenMkgm3Table.Initialized before.heap gm)
    (source : Exec KeygenNttForwardPrograms.sAssign before out) :
    ∃ tw, U32Slot out.state "s" tw ∧
      KeygenMkgm3Rows.Scaled (KeygenMkgm3Indices.tableExponent (KeygenNttGeometry.twiddleIndex i j)) tw ∧
      out.state.heap=before.heap := by
  have hb := KeygenNttGeometry.active_twiddle i j hi hj
  have index : ∀ v, C99ArrayReference.scalar before
      (.bin .add (KeygenNttForwardPrograms.var "m") (KeygenNttForwardPrograms.var "u1")) v →
      v.integer.toNat=KeygenNttGeometry.twiddleIndex i j := by
    intro v evaluated
    obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith before.locals .plus _ _ v evaluated
    have ex := KeygenNttLoopSupport.variable_u64 before "m" _ x mc hx
    have ey := KeygenNttLoopSupport.variable_u64 before "u1" _ y uc hy
    subst x
    subst y
    have hv := KeygenNttLoopSupport.plus_u64 (KeygenNttGeometry.m i) j
      (by dsimp [KeygenNttGeometry.twiddleIndex] at hb; omega)
      (by dsimp [KeygenNttGeometry.twiddleIndex] at hb; omega) v hop
    rw [hv,KeygenNttLoopSupport.u64_toNat _ (by dsimp [KeygenNttGeometry.twiddleIndex] at hb; omega)]
    rfl
  have eval := KeygenMkgm3Atoms.load_word before "gm" _ gm (KeygenNttGeometry.twiddleIndex i j)
    (KeygenMkgm3Indices.tableExponent (KeygenNttGeometry.twiddleIndex i j)) gp index
    (table _ (by omega))
  obtain ⟨tw,scaled,slot,_,heap,_,_⟩ := KeygenNttButterflyCalls.assign32_result _ before "s" _ out declared source eval
  exact ⟨tw,slot,scaled,heap⟩

end FT1536.Source3.KeygenNttBinaryValues
