import Source3.KeygenNttCells
import Source3.KeygenMkgm3Atoms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenNttFirstValues
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttWordAlgebra (R value radix)
open KeygenNttCells (Cell Cells)
open KeygenNttLoopSupport (USlot PSlot)
open KeygenNttButterflyCalls (U32Slot)

def low (a : Nat → R) (root : R) (i : Nat) : R := a i+a (768+i)*root
def high (a : Nat → R) (root : R) (i : Nat) : R := a i+a (768+i)-a (768+i)*root
def values (a : Nat → R) (root : R) (i : Nat) : R :=
  if i<768 then low a root i else high a root (i-768)
def Snapshot (heap : Memory) (p : ArrayPointer) (a : Nat → R) (root : R) (k : Nat) : Prop :=
  ∀ i<768, Cell heap (element p i) (if i<k then low a root i else a i) ∧
    Cell heap (element p (768+i)) (if i<k then high a root i else a (768+i))
def Outside (p q : ArrayPointer) : Prop :=
  ∀ i<1536, KeygenNttCells.Separate (element p i) q
def Frame (before after : Memory) (p : ArrayPointer) : Prop :=
  ∀ q x, Outside p q → Cell before q x → Cell after q x

structure Args (w p0i : BitVec 32) (s : State) : Prop where
  twiddle : U32Slot s "w" w
  prime : U32Slot s "p" KeygenNinv31.prime
  inverse : U32Slot s "p0i" p0i
  stride : USlot s "stride" 1

theorem snapshot_zero (heap : Memory) (p : ArrayPointer) (a : Nat → R) (root : R)
    (input : Cells heap p 1536 a) : Snapshot heap p a root 0 := by
  intro i hi
  simpa only [Nat.not_lt_zero,ite_false] using And.intro (input i (by omega)) (input (768+i) (by omega))

theorem snapshot_final (heap : Memory) (p : ArrayPointer) (a : Nat → R) (root : R)
    (input : Snapshot heap p a root 768) : Cells heap p 1536 (values a root) := by
  intro i hi
  by_cases hlo : i<768
  · simpa only [values,hlo,ite_true] using (input i hlo).1
  · have hj : i-768<768 := by omega
    have he : 768+(i-768)=i := by omega
    simpa only [values,hlo,ite_false,hj,ite_true,he] using (input (i-768) hj).2

theorem snapshot_step (before : State) (out : Result) (p : ArrayPointer)
    (a : Nat → R) (root : R) (k : Nat) (w p0i : BitVec 32)
    (width : p.elementBytes=4) (hk : k<768)
    (inv : KeygenNttFirstLoop.FirstInv p 1 k before) (args : Args w p0i before)
    (input : Snapshot before.heap p a root k)
    (twiddle : KeygenNttButterflyAlgebra.Canonical w ∧ value w=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) before out) :
    Snapshot out.state.heap p a root (k+1) ∧ Frame before.heap out.state.heap p := by
  have ctx : KeygenNttButterflyCalls.FCtx "w" (element p k) (element p (768+k)) w p0i before :=
    ⟨by simpa only [element,Nat.mul_one] using inv.low,by simpa only [element,Nat.mul_one] using inv.high,
      args.twiddle,args.prime,args.inverse⟩
  have cx : Cell before.heap (element p k) (a k) := by simpa using (input k hk).1
  have cy : Cell before.heap (element p (768+k)) (a (768+k)) := by simpa using (input k hk).2
  obtain ⟨_,cl,ch,frame⟩ := KeygenNttCells.first before out _ _ w p0i (a k) (a (768+k)) root ctx
    (KeygenNttCells.elements_separate p width k (768+k) (by omega)) cx cy twiddle initialization source
  constructor
  · intro i hi
    by_cases equal : i=k
    · subst i
      simpa only [Nat.lt_succ_self,ite_true,low,high] using And.intro cl ch
    · have same : (i<k+1)=(i<k) := propext (by omega)
      have keep (j : Nat) (hne1 : k≠j) (hne2 : 768+k≠j) (z : R)
          (cell : Cell before.heap (element p j) z) : Cell out.state.heap (element p j) z := by
        apply frame _ _ _ cell
        intro q hq
        rcases List.mem_cons.mp hq with rfl | hq
        · exact KeygenNttCells.elements_separate p width k j hne1
        · have hq' := List.mem_singleton.mp hq
          subst q
          exact KeygenNttCells.elements_separate p width (768+k) j hne2
      simp only [same]
      exact ⟨keep i (by omega) (by omega) _ (input i hi).1,
        keep (768+i) (by omega) (by omega) _ (input i hi).2⟩
  · intro q x separate cell
    apply frame q x _ cell
    intro pos hp
    rcases List.mem_cons.mp hp with rfl | hp
    · exact separate k (by omega)
    · have he := List.mem_singleton.mp hp
      subst pos
      exact separate (768+k) (by omega)

theorem trace_values (p : ArrayPointer) (a : Nat → R) (root : R) (w p0i : BitVec 32)
    (width : p.elementBytes=4)
    (twiddle : KeygenNttButterflyAlgebra.Canonical w ∧ value w=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (k : Nat) (before after : State) (trace : KeygenNttFirstLoop.FirstTrace p 1 k before after)
    (args : Args w p0i before) (input : Snapshot before.heap p a root k) :
    Snapshot after.heap p a root 768 ∧ Frame before.heap after.heap p := by
  induction trace with
  | done k s stop inv =>
      have he : k=768 := by have := inv.bound; omega
      subst k
      exact ⟨input,fun _ _ _ hc => hc⟩
  | next k before mid next fin guard inv iteration update rest ih =>
      obtain ⟨cells,frame⟩ := snapshot_step before ⟨mid,.normal⟩ p a root k w p0i width guard
        inv args input twiddle initialization iteration
      obtain ⟨_,arrays,locals⟩ := KeygenNttFirstLoop.body_result before ⟨mid,.normal⟩ iteration
      have st : USlot mid "stride" 1 := KeygenNttFirstLoop.slot_keep locals _ _ args.stride
      obtain ⟨_,_,_,_,keep⟩ := KeygenNttFirstLoop.step_result mid k 1 _ _ ⟨next,.normal⟩
        (by decide) (by omega) (KeygenNttFirstLoop.slot_keep locals _ _ inv.counter) st
        (KeygenNttFirstLoop.ptr_keep arrays _ _ inv.low)
        (KeygenNttFirstLoop.ptr_keep arrays _ _ inv.high) update
      have heap : next.heap=mid.heap := KeygenNttCells.control_heap _ _ _ update (by decide)
      have argsNext : Args w p0i next := ⟨
        (keep "w".toList (by decide)).trans ((congrFun locals _).trans args.twiddle),
        (keep "p".toList (by decide)).trans ((congrFun locals _).trans args.prime),
        (keep "p0i".toList (by decide)).trans ((congrFun locals _).trans args.inverse),
        (keep "stride".toList (by decide)).trans st⟩
      have inputNext : Snapshot next.heap p a root (k+1) := by rw [heap]; exact cells
      obtain ⟨done,tail⟩ := ih argsNext inputNext
      refine ⟨done,?_⟩
      intro q x separate cell
      apply tail q x separate
      rw [heap]
      exact frame q x separate cell

theorem init_args (before : State) (out : Result) (w p0i : BitVec 32)
    (args : Args w p0i before) (source : Exec KeygenNttForwardPrograms.firstInit before out) :
    Args w p0i out.state := by
  obtain ⟨mid,first,rest⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right
    (by rintro ⟨r,hr,hn,he⟩; subst r; exact hn (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.assign_result _ _ before ⟨mid,.normal⟩ first
  have hm := congrArg Result.state he
  dsimp only at hm
  subst mid
  obtain ⟨next,first2,rest2⟩ := (KeygenNttForwardExec.seq_inv _ _ _ out rest).resolve_right
    (by rintro ⟨r,hr,hn,he⟩; subst r; exact hn (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨p,_,he2⟩ := KeygenNttLoopSupport.bindPtr_result _ _ _ _ ⟨next,.normal⟩ first2
  have hn := congrArg Result.state he2
  dsimp only at hn
  subst next
  obtain ⟨q,_,he3⟩ := KeygenNttLoopSupport.bindPtr_result _ _ _ _ out rest2
  rw [he3]
  exact ⟨args.twiddle,args.prime,args.inverse,args.stride⟩

theorem loop_values (before : State) (out : Result) (p : ArrayPointer)
    (a : Nat → R) (root : R) (w p0i : BitVec 32) (width : p.elementBytes=4)
    (args : Args w p0i before)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (hn : USlot before "hn" 768) (ap : PSlot before "a" p)
    (input : Cells before.heap p 1536 a)
    (twiddle : KeygenNttButterflyAlgebra.Canonical w ∧ value w=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.firstLoop before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (values a root) ∧ Frame before.heap out.state.heap p := by
  obtain ⟨mid,first,rest⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    exact hexit (KeygenNttFirstLoop.init_result p 1 before out (by decide) (by decide)
      uc hn args.stride ap hr).1)
  obtain ⟨_,inv,st,hn0⟩ := KeygenNttFirstLoop.init_result p 1 before ⟨mid,.normal⟩
    (by decide) (by decide) uc hn args.stride ap first
  have heap : mid.heap=before.heap := KeygenNttCells.control_heap _ _ _ first (by decide)
  obtain ⟨flow,trace⟩ := KeygenNttFirstLoop.loop_trace p 1 _ mid out (by decide) rest rfl 0
    (by decide) inv st hn0
  obtain ⟨cells,frame⟩ := trace_values p a root w p0i width twiddle initialization 0 mid out.state trace
    (init_args before ⟨mid,.normal⟩ w p0i args first)
    (by rw [heap]; exact snapshot_zero before.heap p a root input)
  rw [heap] at frame
  exact ⟨flow,snapshot_final out.state.heap p a root cells,frame⟩

def firstRoot : R := KeygenMkgm3Rows.root^KeygenMkgm3Indices.tableExponent 1

/- The source w=gm[1] read supplies the scaled root. It is not a value
   premise on the completed first pass. -/
theorem pass_values (before : State) (out : Result) (p gm : ArrayPointer)
    (a : Nat → R) (p0i : BitVec 32) (width : p.elementBytes=4)
    (word : KeygenNttButterflyCalls.U32Declared before "w")
    (prime : U32Slot before "p" KeygenNinv31.prime) (inverse : U32Slot before "p0i" p0i)
    (stride : USlot before "stride" 1) (hn : USlot before "hn" 768)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (ap : PSlot before "a" p) (gp : PSlot before "gm" gm)
    (input : Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.firstPass before out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (values a firstRoot) ∧ Frame before.heap out.state.heap p := by
  obtain ⟨mid,first,rest⟩ := KeygenMkgm3Control.chain_inv KeygenNttForwardPrograms.wAssign
    [KeygenNttForwardPrograms.firstLoop] before out (by decide) source
  have eval := KeygenMkgm3Atoms.load_word before "gm" (KeygenNttForwardPrograms.num 1) gm 1
    (KeygenMkgm3Indices.tableExponent 1) gp
    (KeygenMkgm3Atoms.literal_index before 1 (by decide)) (table 1 (by decide))
  obtain ⟨w,scaled,slot,arrays,heap,locals,_⟩ := KeygenNttButterflyCalls.assign32_result
    (KeygenMkgm3Rows.Scaled (KeygenMkgm3Indices.tableExponent 1)) before "w" _ ⟨mid,.normal⟩ word first eval
  have prime' : U32Slot mid "p" KeygenNinv31.prime := by rw [U32Slot,locals]; exact prime
  have inverse' : U32Slot mid "p0i" p0i := by rw [U32Slot,locals]; exact inverse
  have stride' : USlot mid "stride" 1 := by rw [USlot,locals]; exact stride
  have hn' : USlot mid "hn" 768 := by rw [USlot,locals]; exact hn
  have uc' : ∃ old, mid.locals "u".toList=some (.uint64,old) := by rw [locals]; exact uc
  have ap' : PSlot mid "a" p := by rw [PSlot,arrays]; exact ap
  obtain ⟨fin,loop,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ mid out rest).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    exact hexit (loop_values mid out p a firstRoot w p0i width ⟨slot,prime',inverse',stride'⟩ uc' hn' ap'
      (by rw [heap]; exact input) scaled initialization hr).1)
  have result := loop_values mid ⟨fin,.normal⟩ p a firstRoot w p0i width
    ⟨slot,prime',inverse',stride'⟩ uc' hn' ap' (by rw [heap]; exact input) scaled initialization loop
  rw [C99ModularReference.skip_result fin out tail]
  rw [heap] at result
  exact result

end FT1536.Source3.KeygenNttFirstValues
