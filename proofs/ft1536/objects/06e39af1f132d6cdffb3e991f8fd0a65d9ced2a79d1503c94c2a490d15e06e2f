import Source3.KeygenMkgm3RevMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3LastRow
open C99ModularReference (Stmt Exec Eval)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open C99MemoryReference (ArrayPointer Memory)
open KeygenMkgm3Program
open KeygenMkgm3Atoms
open KeygenMkgm3Upward (Pointers Updates)
open KeygenMkgm3Control (frame chain_inv writes)
open KeygenNttLoopSupport (USlot u64)
open KeygenNttButterflyCalls (U32Slot)
open KeygenMkgm3Rows (Scaled exponent)
open KeygenMkgm3Indices (tableExponent lastIndex)
open KeygenMkgm3Table (Cell)
open KeygenMkgm3RevMemory (Rev)

structure Context (p0i : BitVec 32) (gm igm rev : ArrayPointer) (s : State) : Prop where
  params : Params s p0i
  pointers : Pointers s gm igm
  table : Rev s rev
  k : U32Slot s "k" 1
  b : USlot s "b" 512
  g2 : Word s "g2" 2
  g4 : Word s "g4" 4

theorem context_after (code : Stmt) (s : State) (out : Result) (p0i : BitVec 32)
    (gm igm rev : ArrayPointer) (ctx : Context p0i gm igm rev s)
    (support : KeygenMkgm3Control.supported code=true)
    (limited : writes code ⊆ ["x".toList,"ix".toList]) (source : Exec code s out) :
    Context p0i gm igm rev out.state := by
  have keep (n : C99ArrayReference.Name) (h : n∉["x".toList,"ix".toList]) : n∉writes code :=
    fun hn => h (limited hn)
  have hf := frame code s out support source
  exact ⟨params_transport code s out p0i support (keep _ (by decide)) (keep _ (by decide)) ctx.params source,
    KeygenMkgm3Upward.pointers_after code s out gm igm support ctx.pointers source,
    KeygenMkgm3RevMemory.transported code s out rev support ctx.table source,
    (hf.2.2 _ (keep _ (by decide))).trans ctx.k,
    (hf.2.2 _ (keep _ (by decide))).trans ctx.b,
    word_transport code s out "g2" 2 support (keep _ (by decide)) ctx.g2 source,
    word_transport code s out "g4" 4 support (keep _ (by decide)) ctx.g4 source⟩

theorem shift_k (s : State) (left : CLogic.Expr) (i : Nat) (hi : i<1024)
    (k : U32Slot s "k" 1)
    (left_value : ∀ v, C99ArrayReference.scalar s left v → v=u64 i) :
    ∀ v, C99ArrayReference.scalar s (.bin .shl left (var "k")) v → v.integer.toNat=2*i := by
  intro v source
  obtain ⟨x,y,hx,hy,op⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ v source
  have hx' := left_value x hx
  have hy' := KeygenNttButterflyCalls.variable_u32 s "k" 1 y k hy
  subst x; subst y
  obtain ⟨n,hn,_,he⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
  have hn1 : n=1 := by change (1 : Int)=(n : Int) at hn; omega
  subst n
  change v=C99IntegerReference.convert .uint64 ((u64 i).integer*2^1) at he
  rw [pow_one,KeygenNttLoopSupport.convert_mul_two i (by omega)] at he
  rw [he,KeygenNttLoopSupport.u64_toNat _ (by omega)]
  omega

theorem index_value (s : State) (i : Nat) (hi : i<512) (counter : USlot s "u" i) (k : U32Slot s "k" 1) :
    ∀ v, C99ArrayReference.scalar s revIndex v → v.integer.toNat=2*i :=
  shift_k s (var "u") i (by omega) k (fun v h => KeygenNttLoopSupport.variable_u64 s "u" i v counter h)

theorem next_value (s : State) (i : Nat) (hi : i+1<512) (counter : USlot s "u" i) (k : U32Slot s "k" 1) :
    ∀ v, C99ArrayReference.scalar s revIndexNext v → v.integer.toNat=2*(i+1) := by
  apply shift_k s _ (i+1) (by omega) k
  intro v source
  obtain ⟨x,y,hx,hy,op⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v source
  have hx' := KeygenNttLoopSupport.variable_u64 s "u" i x counter hx
  have hy' := KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x; subst y
  exact KeygenNttLoopSupport.add_one_literal i (by omega) v op

theorem pair_stores (s middle after : State) (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (u : Nat) (hu : u<512) (idx : CLogic.Expr) (ctx : Context p0i gm igm rev s)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (x : Word s "x" (exponent u))
    (index : ∀ v, C99ArrayReference.scalar s idx v → v.integer.toNat=2*u)
    (indexMiddle : ∀ v, C99ArrayReference.scalar middle idx v → v.integer.toNat=2*u)
    (first : Exec (storeRev "gm" idx (cell "x")) s ⟨middle,.normal⟩)
    (second : Exec (storeRev "igm" idx (cell "ix")) middle ⟨after,.normal⟩) :
    Updates gm (lastIndex u) s.heap after.heap := by
  obtain ⟨v,ev,write⟩ := KeygenMkgm3RevMemory.storeRev_address s "gm" idx gm rev u hu
    ctx.pointers.forward ctx.table ctx.b index _ ⟨middle,.normal⟩ first
  obtain ⟨w,hv,law⟩ := cell_word s "x" (exponent u) x v ev
  subst v
  rw [KeygenNttButterflyCalls.ofInt_u32] at write
  have ctx1 := context_after _ s ⟨middle,.normal⟩ p0i gm igm rev ctx rfl (by simp [writes,storeRev]) first
  obtain ⟨iv,_,iwrite⟩ := KeygenMkgm3RevMemory.storeRev_address middle "igm" idx igm rev u hu
    ctx1.pointers.inverse ctx1.table ctx1.b indexMiddle _ ⟨after,.normal⟩ second
  have hlaw : Scaled (tableExponent (lastIndex u)) w := by
    rw [(KeygenMkgm3IndexCert.all_indices u (by omega)).1 hu |>.2.2]
    exact law
  exact KeygenMkgm3Upward.writes_update gm igm gw iw separate (lastIndex u)
    (KeygenMkgm3Table.last_range u hu).2 _ _ _ w (BitVec.ofInt 32 iv.integer) hlaw write iwrite

def PairUpdates (gm : ArrayPointer) (u : Nat) (before after : Memory) : Prop :=
  Cell after gm (lastIndex u) ∧ Cell after gm (lastIndex (u+1)) ∧
    ∀ j<1024, lastIndex u≠j → lastIndex (u+1)≠j → Cell before gm j → Cell after gm j

theorem pair_updates (gm : ArrayPointer) (u : Nat) (hu : u+1<512) (before middle after : Memory)
    (first : Updates gm (lastIndex u) before middle)
    (second : Updates gm (lastIndex (u+1)) middle after) : PairUpdates gm u before after := by
  have ne : lastIndex (u+1)≠lastIndex u := by
    intro h
    have := KeygenMkgm3Table.last_injective (u+1) u hu (by omega) h
    omega
  exact ⟨second.2 _ (KeygenMkgm3Table.last_range u (by omega)).2 ne first.1,second.1,
    fun j hj h1 h2 read => second.2 j hj h2 (first.2 j hj h1 read)⟩

theorem body_result (s : State) (out : Result) (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (j : Nat) (hj : j<256) (ctx : Context p0i gm igm rev s) (counter : USlot s "u" (2*j))
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (x : Word s "x" (exponent (2*j))) (source : Exec lastRowBody s out) :
    Word out.state "x" (exponent (2*(j+1))) ∧ PairUpdates gm (2*j) s.heap out.state.heap := by
  obtain ⟨s1,gst1,tail1⟩ := chain_inv _ _ s out (by decide) source
  obtain ⟨s2,ist1,tail2⟩ := chain_inv _ _ s1 out (by decide) tail1
  obtain ⟨s3,xmul4,tail3⟩ := chain_inv _ _ s2 out (by decide) tail2
  obtain ⟨s4,ixmul4,tail4⟩ := chain_inv _ _ s3 out (by decide) tail3
  obtain ⟨s5,gst2,tail5⟩ := chain_inv _ _ s4 out (by decide) tail4
  obtain ⟨s6,ist2,tail6⟩ := chain_inv _ _ s5 out (by decide) tail5
  obtain ⟨s7,xmul2,tail7⟩ := chain_inv _ _ s6 out (by decide) tail6
  obtain ⟨s8,ixmul2,last⟩ := chain_inv _ _ s7 out (by decide) tail7
  have hend := C99ModularReference.skip_result s8 out last
  have c1 := context_after _ s ⟨s1,.normal⟩ p0i gm igm rev ctx (by decide) (by decide) gst1
  have c2 := context_after _ s1 ⟨s2,.normal⟩ p0i gm igm rev c1 (by decide) (by decide) ist1
  have c3 := context_after _ s2 ⟨s3,.normal⟩ p0i gm igm rev c2 (by decide) (by decide) xmul4
  have c4 := context_after _ s3 ⟨s4,.normal⟩ p0i gm igm rev c3 (by decide) (by decide) ixmul4
  have c5 := context_after _ s4 ⟨s5,.normal⟩ p0i gm igm rev c4 (by decide) (by decide) gst2
  have c6 := context_after _ s5 ⟨s6,.normal⟩ p0i gm igm rev c5 (by decide) (by decide) ist2
  have u1 := KeygenMkgm3Upward.counter_after _ s ⟨s1,.normal⟩ (2*j) (by decide) (by decide) counter gst1
  have u2 := KeygenMkgm3Upward.counter_after _ s1 ⟨s2,.normal⟩ (2*j) (by decide) (by decide) u1 ist1
  have u3 := KeygenMkgm3Upward.counter_after _ s2 ⟨s3,.normal⟩ (2*j) (by decide) (by decide) u2 xmul4
  have u4 := KeygenMkgm3Upward.counter_after _ s3 ⟨s4,.normal⟩ (2*j) (by decide) (by decide) u3 ixmul4
  have u5 := KeygenMkgm3Upward.counter_after _ s4 ⟨s5,.normal⟩ (2*j) (by decide) (by decide) u4 gst2
  have first := pair_stores s s1 s2 p0i gm igm rev (2*j) (by omega) revIndex ctx gw iw separate x
    (index_value s (2*j) (by omega) counter ctx.k) (index_value s1 (2*j) (by omega) u1 c1.k) gst1 ist1
  have x1 := word_transport _ s ⟨s1,.normal⟩ "x" _ (by decide) (by decide) x gst1
  have x2 := word_transport _ s1 ⟨s2,.normal⟩ "x" _ (by decide) (by decide) x1 ist1
  have x3 := (assign_word s2 ⟨s3,.normal⟩ "x" _ _ (word_declared s2 "x" _ x2)
    (mont_word s2 p0i _ _ _ _ c2.params initialization (cell_word s2 "x" _ x2)
      (cell_word s2 "g4" 4 c2.g4)) xmul4).1
  have x4 := word_transport _ s3 ⟨s4,.normal⟩ "x" _ (by decide) (by decide) x3 ixmul4
  have xodd : Word s4 "x" (exponent (2*j+1)) := by
    convert x4 using 1
    rw [KeygenMkgm3Rows.exponent_even,KeygenMkgm3Rows.exponent_odd]
  have second := pair_stores s4 s5 s6 p0i gm igm rev (2*j+1) (by omega) revIndexNext c4 gw iw separate xodd
    (next_value s4 (2*j) (by omega) u4 c4.k) (next_value s5 (2*j) (by omega) u5 c5.k) gst2 ist2
  have x5 := word_transport _ s4 ⟨s5,.normal⟩ "x" _ (by decide) (by decide) xodd gst2
  have x6 := word_transport _ s5 ⟨s6,.normal⟩ "x" _ (by decide) (by decide) x5 ist2
  have x7 := (assign_word s6 ⟨s7,.normal⟩ "x" _ _ (word_declared s6 "x" _ x6)
    (mont_word s6 p0i _ _ _ _ c6.params initialization (cell_word s6 "x" _ x6)
      (cell_word s6 "g2" 2 c6.g2)) xmul2).1
  have x8 := word_transport _ s7 ⟨s8,.normal⟩ "x" _ (by decide) (by decide) x7 ixmul2
  have h4 : s4.heap=s2.heap := (assign_heap s3 _ _ _ ixmul4).trans (assign_heap s2 _ _ _ xmul4)
  have h8 : s8.heap=s6.heap := (assign_heap s7 _ _ _ ixmul2).trans (assign_heap s6 _ _ _ xmul2)
  rw [hend]
  constructor
  · convert x8 using 1
    rw [KeygenMkgm3Rows.exponent_even,KeygenMkgm3Rows.exponent_odd]
    omega
  · rw [h8]
    exact pair_updates gm (2*j) (by omega) _ _ _ first (by simpa only [h4] using second)

end FT1536.Source3.KeygenMkgm3LastRow
