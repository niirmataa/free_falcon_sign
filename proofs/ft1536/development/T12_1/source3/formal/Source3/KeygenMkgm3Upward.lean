import Source3.KeygenMkgm3Atoms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source-body row laws for the ascending cubes and descending squares.
   Every load, nested Montgomery call and interleaved inverse-table store
   is consumed from the existing parsed body execution. -/
namespace FT1536.Source3.KeygenMkgm3Upward
open C99ModularReference (Stmt Exec Eval chainOf)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open C99MemoryReference (ArrayPointer Memory Store32)
open KeygenSmallOutput (element)
open KeygenMkgm3Program
open KeygenMkgm3Atoms
open KeygenMkgm3Control (frame chain_inv)
open KeygenMkgm3Table (Cell)
open KeygenMkgm3Indices (tableExponent)
open KeygenNttLoopSupport (USlot u64)

structure Pointers (s : State) (gm igm : ArrayPointer) : Prop where
  forward : s.arrays "gm".toList=some gm
  inverse : s.arrays "igm".toList=some igm

theorem pointers_after (code : Stmt) (s : State) (out : Result) (gm igm : ArrayPointer)
    (support : KeygenMkgm3Control.supported code=true) (p : Pointers s gm igm)
    (source : Exec code s out) : Pointers out.state gm igm := by
  have ha := (frame code s out support source).2.1
  exact ⟨by rw [ha]; exact p.forward,by rw [ha]; exact p.inverse⟩

theorem counter_after (code : Stmt) (s : State) (out : Result) (i : Nat)
    (support : KeygenMkgm3Control.supported code=true)
    (keep : "u".toList∉KeygenMkgm3Control.writes code) (slot : USlot s "u" i)
    (source : Exec code s out) : USlot out.state "u" i :=
  ((frame code s out support source).2.2 _ keep).trans slot

theorem twice_index (s : State) (i : Nat) (hi : i<1024) (slot : USlot s "u" i) :
    ∀ v, C99ArrayReference.scalar s (.bin .shl (var "u") (num 1)) v → v=u64 (2*i) := by
  intro v source
  obtain ⟨x,y,hx,hy,op⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ v source
  have hxe := KeygenNttLoopSupport.variable_u64 s "u" i x slot hx
  have hye := KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x; subst y
  simpa only [Nat.mul_comm] using KeygenNttLoopSupport.shl_one_u64 i (by omega) v op

theorem twice_nat (s : State) (i : Nat) (hi : i<1024) (slot : USlot s "u" i) :
    ∀ v, C99ArrayReference.scalar s (.bin .shl (var "u") (num 1)) v → v.integer.toNat=2*i := by
  intro v h
  rw [twice_index s i hi slot v h,KeygenNttLoopSupport.u64_toNat _ (by omega)]

theorem declare_pair (s : State) (out : Result)
    (source : Exec (wordDecl ["y","z"]) s out) :
    KeygenNttButterflyCalls.U32Declared out.state "y" := by
  obtain ⟨mid,body,he⟩ := KeygenNttForwardExec.base_inv _ s out source
  obtain ⟨env,exec,hm⟩ := KeygenNttForwardExec.scalar_inv _ s mid body
  have hd := KeygenNttForwardExec.declarations_result s.locals .uint32
    ["y".toList,"z".toList] (.normal env) exec
  cases hd
  rw [he,hm]
  exact ⟨none,by simp [C99ScalarReference.set]⟩

theorem plain_store (s : State) (out : Result) (name : String) (index : CLogic.Expr)
    (e : C99ModularReference.Expr) (p : ArrayPointer) (i : Nat)
    (binding : s.arrays name.toList=some p)
    (value : ∀ v, C99ArrayReference.scalar s index v → v.integer.toNat=i)
    (source : Exec (.store32 name.toList index e) s out) :
    ∃ w, Store32 s.heap (element p i) w out.state.heap := by
  cases source with
  | store32 _ _ _ before after actual v address evaluated write =>
      rw [pointer_index s name index p actual i binding value address] at write
      exact ⟨_,write⟩

def Updates (gm : ArrayPointer) (i : Nat) (before after : Memory) : Prop :=
  Cell after gm i ∧ ∀ j<1024, i≠j → Cell before gm j → Cell after gm j

theorem writes_update (gm igm : ArrayPointer) (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096) (i : Nat) (hi : i<1024)
    (before middle after : Memory) (w inverse : BitVec 32)
    (scaled : KeygenMkgm3Rows.Scaled (tableExponent i) w)
    (first : Store32 before (element gm i) w middle)
    (second : Store32 middle (element igm i) inverse after) : Updates gm i before after := by
  refine ⟨KeygenMkgm3Table.inverse_preserves_cell gm igm gw iw separate i i hi hi _ _ inverse second
    (KeygenMkgm3Table.store_initializes gm i before middle w scaled first),?_⟩
  intro j hj different read
  exact KeygenMkgm3Table.inverse_preserves_cell gm igm gw iw separate i j hi hj _ _ inverse second
    (KeygenMkgm3Table.store_preserves_cell gm gw i j different before middle w first read)

theorem cube_body (s : State) (out : Result) (gm igm : ArrayPointer) (p0i : BitVec 32)
    (i : Nat) (lo : 256 ≤ i) (hi : i<512)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (pointers : Pointers s gm igm) (counter : USlot s "u" i) (params : Params s p0i)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (input : Cell s.heap gm (2*i)) (source : Exec cubeBody s out) :
    out.flow=.normal ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays ∧
      Updates gm i s.heap out.state.heap := by
  obtain ⟨inner,body,hout⟩ := KeygenNttLoopSupport.scope_result _ _ s out source
  obtain ⟨s1,d,tail1⟩ := chain_inv _ _ s inner (by decide) body
  obtain ⟨s2,yload,tail2⟩ := chain_inv _ _ s1 inner (by decide) tail1
  obtain ⟨s3,zload,tail3⟩ := chain_inv _ _ s2 inner (by decide) tail2
  obtain ⟨s4,ycube,tail4⟩ := chain_inv _ _ s3 inner (by decide) tail3
  obtain ⟨s5,zcube,tail5⟩ := chain_inv _ _ s4 inner (by decide) tail4
  obtain ⟨s6,yst,tail6⟩ := chain_inv _ _ s5 inner (by decide) tail5
  obtain ⟨s7,zst,last⟩ := chain_inv _ _ s6 inner (by decide) tail6
  have hend := C99ModularReference.skip_result s7 inner last
  have h1 := pure_heap _ s ⟨s1,.normal⟩ (by decide) d
  change s1.heap=s.heap at h1
  have h2 := assign_heap s1 ⟨s2,.normal⟩ _ _ yload
  have h3 := assign_heap s2 ⟨s3,.normal⟩ _ _ zload
  have h4 := assign_heap s3 ⟨s4,.normal⟩ _ _ ycube
  have h5 := assign_heap s4 ⟨s5,.normal⟩ _ _ zcube
  have ps1 := pointers_after _ s ⟨s1,.normal⟩ gm igm (by decide) pointers d
  have u1 := counter_after _ s ⟨s1,.normal⟩ i (by decide) (by decide) counter d
  have yword := (assign_word s1 ⟨s2,.normal⟩ "y" _ (tableExponent (2*i)) (declare_pair s _ d)
    (load_word s1 "gm" _ gm (2*i) (tableExponent (2*i)) ps1.forward
      (twice_nat s1 i (by omega) u1) (by simpa only [Cell,h1] using input)) yload).1
  have y3 := word_transport _ s2 ⟨s3,.normal⟩ "y" _ (by decide) (by decide) yword zload
  have pa1 := params_transport _ s ⟨s1,.normal⟩ p0i (by decide) (by decide) (by decide) params d
  have pa2 := params_transport _ s1 ⟨s2,.normal⟩ p0i (by decide) (by decide) (by decide) pa1 yload
  have pa3 := params_transport _ s2 ⟨s3,.normal⟩ p0i (by decide) (by decide) (by decide) pa2 zload
  have y4 := (assign_word s3 ⟨s4,.normal⟩ "y" _ _ (word_declared s3 "y" _ y3)
    (mont_word s3 p0i _ _ _ _ pa3 initialization (cell_word s3 "y" _ y3)
      (mont_word s3 p0i _ _ _ _ pa3 initialization (cell_word s3 "y" _ y3)
        (cell_word s3 "y" _ y3))) ycube).1
  have y5 := word_transport _ s4 ⟨s5,.normal⟩ "y" _ (by decide) (by decide) y4 zcube
  have ps2 := pointers_after _ s1 ⟨s2,.normal⟩ gm igm (by decide) ps1 yload
  have ps3 := pointers_after _ s2 ⟨s3,.normal⟩ gm igm (by decide) ps2 zload
  have ps4 := pointers_after _ s3 ⟨s4,.normal⟩ gm igm (by decide) ps3 ycube
  have ps5 := pointers_after _ s4 ⟨s5,.normal⟩ gm igm (by decide) ps4 zcube
  have u2 := counter_after _ s1 ⟨s2,.normal⟩ i (by decide) (by decide) u1 yload
  have u3 := counter_after _ s2 ⟨s3,.normal⟩ i (by decide) (by decide) u2 zload
  have u4 := counter_after _ s3 ⟨s4,.normal⟩ i (by decide) (by decide) u3 ycube
  have u5 := counter_after _ s4 ⟨s5,.normal⟩ i (by decide) (by decide) u4 zcube
  obtain ⟨w,hw,scaled⟩ := store_word s5 ⟨s6,.normal⟩ "gm" _ _ gm i _ ps5.forward
    (u_index s5 "u" i (by omega) u5) (cell_word s5 "y" _ y5) yst
  have ps6 := pointers_after _ s5 ⟨s6,.normal⟩ gm igm (by decide) ps5 yst
  have u6 := counter_after _ s5 ⟨s6,.normal⟩ i (by decide) (by decide) u5 yst
  obtain ⟨iwrd,ihw⟩ := plain_store s6 ⟨s7,.normal⟩ "igm" _ _ igm i ps6.inverse
    (u_index s6 "u" i (by omega) u6) zst
  have law : KeygenMkgm3Rows.Scaled (tableExponent i) w := by
    rw [(KeygenMkgm3IndexCert.all_indices i (by omega)).2.1 ⟨lo,hi⟩]
    convert scaled using 1
    omega
  have updates := writes_update gm igm gw iw separate i (by omega) _ _ _ w iwrd law hw ihw
  have hh : s5.heap=s.heap := h5.trans (h4.trans (h3.trans (h2.trans h1)))
  have whole := frame cubeBody s out (by decide) source
  refine ⟨whole.1,?_,whole.2.1,?_⟩
  · rw [hout]
    funext name
    change (if (["y".toList,"z".toList].contains name) then s.locals name else inner.state.locals name)=s.locals name
    split_ifs with h
    · rfl
    · exact (frame _ s inner (by decide) body).2.2 name (by
        simp [KeygenMkgm3Control.writes,chainOf,wordDecl] at h ⊢
        tauto)
  · rw [hout,hend]
    simpa only [hh,C99ArrayReference.restoreScope] using updates

theorem declare_v (s : State) (out : Result) (source : Exec (indexDecl ["v"]) s out) :
    out.state.locals "v".toList=some (.uint64,none) := by
  obtain ⟨mid,body,he⟩ := KeygenNttForwardExec.base_inv _ s out source
  obtain ⟨env,exec,hm⟩ := KeygenNttForwardExec.scalar_inv _ s mid body
  have hd := KeygenNttForwardExec.declarations_result s.locals .uint64 ["v".toList] (.normal env) exec
  cases hd
  rw [he,hm]
  simp [C99ScalarReference.set]

theorem assign_v (s : State) (out : Result) (i : Nat) (hi : i<1024) (slot : USlot s "u" i)
    (declared : s.locals "v".toList=some (.uint64,none))
    (source : Exec (.assign "v".toList (.scalar (.bin .shl (var "u") (num 1)))) s out) :
    USlot out.state "v" (2*i) := by
  obtain ⟨ty,old,v,hd,ev,he⟩ := KeygenNttForwardExec.assign_inv s _ _ out source
  have ht := congrArg Prod.fst (Option.some.inj (hd.symm.trans declared))
  change ty=C99IntegerReference.Ty.uint64 at ht
  subst ty
  have hv := twice_index s i hi slot v (KeygenNttForwardExec.eval_scalar s _ v ev)
  subst v
  rw [he]
  simp [USlot,C99ArrayReference.bindValue,C99ScalarReference.set,
    KeygenNttLoopSupport.convert_u64_self (2*i) (by omega)]

theorem square_body (s : State) (out : Result) (gm igm : ArrayPointer) (p0i : BitVec 32)
    (i : Nat) (lo : 1 ≤ i) (hi : i<256)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (pointers : Pointers s gm igm) (counter : USlot s "u" i) (params : Params s p0i)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (input : Cell s.heap gm (2*i)) (source : Exec squareBody s out) :
    out.flow=.normal ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays ∧
      Updates gm i s.heap out.state.heap := by
  obtain ⟨inner,body,hout⟩ := KeygenNttLoopSupport.scope_result _ _ s out source
  obtain ⟨s1,d,tail1⟩ := chain_inv _ _ s inner (by decide) body
  obtain ⟨s2,vset,tail2⟩ := chain_inv _ _ s1 inner (by decide) tail1
  obtain ⟨s3,gst,tail3⟩ := chain_inv _ _ s2 inner (by decide) tail2
  obtain ⟨s4,ist,last⟩ := chain_inv _ _ s3 inner (by decide) tail3
  have hend := C99ModularReference.skip_result s4 inner last
  have h1 := pure_heap _ s ⟨s1,.normal⟩ (by decide) d
  have h2 := assign_heap s1 ⟨s2,.normal⟩ _ _ vset
  have hh : s2.heap=s.heap := h2.trans h1
  have u1 := counter_after _ s ⟨s1,.normal⟩ i (by decide) (by decide) counter d
  have u2 := counter_after _ s1 ⟨s2,.normal⟩ i (by decide) (by decide) u1 vset
  have v2 := assign_v s1 ⟨s2,.normal⟩ i (by omega) u1 (declare_v s _ d) vset
  have ps1 := pointers_after _ s ⟨s1,.normal⟩ gm igm (by decide) pointers d
  have ps2 := pointers_after _ s1 ⟨s2,.normal⟩ gm igm (by decide) ps1 vset
  have pa1 := params_transport _ s ⟨s1,.normal⟩ p0i (by decide) (by decide) (by decide) params d
  have pa2 := params_transport _ s1 ⟨s2,.normal⟩ p0i (by decide) (by decide) (by decide) pa1 vset
  have loaded := load_word s2 "gm" (var "v") gm (2*i) (tableExponent (2*i)) ps2.forward
    (u_index s2 "v" (2*i) (by omega) v2) (by simpa only [Cell,hh] using input)
  obtain ⟨w,write,scaled⟩ := store_word s2 ⟨s3,.normal⟩ "gm" _ _ gm i _ ps2.forward
    (u_index s2 "u" i (by omega) u2) (mont_word s2 p0i _ _ _ _ pa2 initialization loaded loaded) gst
  have ps3 := pointers_after _ s2 ⟨s3,.normal⟩ gm igm (by decide) ps2 gst
  have u3 := counter_after _ s2 ⟨s3,.normal⟩ i (by decide) (by decide) u2 gst
  obtain ⟨iwrd,iwrite⟩ := plain_store s3 ⟨s4,.normal⟩ "igm" _ _ igm i ps3.inverse
    (u_index s3 "u" i (by omega) u3) ist
  have law : KeygenMkgm3Rows.Scaled (tableExponent i) w := by
    rw [(KeygenMkgm3IndexCert.all_indices i (by omega)).2.2.1 ⟨lo,hi⟩]
    simpa only [two_mul] using scaled
  have updates := writes_update gm igm gw iw separate i (by omega) _ _ _ w iwrd law write iwrite
  have whole := frame squareBody s out (by decide) source
  refine ⟨whole.1,?_,whole.2.1,?_⟩
  · rw [hout]
    funext name
    change (if (["v".toList].contains name) then s.locals name else inner.state.locals name)=s.locals name
    split_ifs with h
    · rfl
    · exact (frame _ s inner (by decide) body).2.2 name (by
        simpa [KeygenMkgm3Control.writes,chainOf,indexDecl] using h)
  · rw [hout,hend]
    simpa only [hh,C99ArrayReference.restoreScope] using updates

end FT1536.Source3.KeygenMkgm3Upward
